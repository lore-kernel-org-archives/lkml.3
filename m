Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab3IEWW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 18:22:26 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:39745 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab3IEWWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 18:22:24 -0400
Date: Thu, 5 Sep 2013 18:22:22 -0400
From: Milosz Tanski <milosz@adfin.com>
To: ceph-devel@vger.kernel.org
Cc: sage@inktank.com, zheng.z.yan@intel.com, dhowells@redhat.com,
        jiayisuse@gmail.com, linux-cachefs@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] ceph: use fscache as a local presisent cache
Message-ID: <cb0963fcf836232447e11f42ded9733612e4c63f.1378418255.git.milosz@adfin.com>
References: <cover.1378418255.git.milosz@adfin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1378418255.git.milosz@adfin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support for fscache to the Ceph filesystem. This would bring it to on
par with some of the other network filesystems in Linux (like NFS, AFS, etc...)

In order to mount the filesystem with fscache the 'fsc' mount option must be
passed.

Signed-off-by: Milosz Tanski <milosz@adfin.com>
Signed-off-by: Sage Weil <sage@inktank.com>
---
 fs/ceph/Kconfig  |    9 ++
 fs/ceph/Makefile |    1 +
 fs/ceph/addr.c   |   37 ++++-
 fs/ceph/cache.c  |  393 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/cache.h  |  138 +++++++++++++++++++
 fs/ceph/caps.c   |   19 ++-
 fs/ceph/file.c   |   17 +++
 fs/ceph/inode.c  |   14 +-
 fs/ceph/super.c  |   35 ++++-
 fs/ceph/super.h  |   16 +++
 10 files changed, 666 insertions(+), 13 deletions(-)
 create mode 100644 fs/ceph/cache.c
 create mode 100644 fs/ceph/cache.h

diff --git a/fs/ceph/Kconfig b/fs/ceph/Kconfig
index 49bc782..ac9a2ef 100644
--- a/fs/ceph/Kconfig
+++ b/fs/ceph/Kconfig
@@ -16,3 +16,12 @@ config CEPH_FS
 
 	  If unsure, say N.
 
+if CEPH_FS
+config CEPH_FSCACHE
+	bool "Enable Ceph client caching support"
+	depends on CEPH_FS=m && FSCACHE || CEPH_FS=y && FSCACHE=y
+	help
+	  Choose Y here to enable persistent, read-only local
+	  caching support for Ceph clients using FS-Cache
+
+endif
diff --git a/fs/ceph/Makefile b/fs/ceph/Makefile
index bd35212..32e3010 100644
--- a/fs/ceph/Makefile
+++ b/fs/ceph/Makefile
@@ -9,3 +9,4 @@ ceph-y := super.o inode.o dir.o file.o locks.o addr.o ioctl.o \
 	mds_client.o mdsmap.o strings.o ceph_frag.o \
 	debugfs.o
 
+ceph-$(CONFIG_CEPH_FSCACHE) += cache.o
diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 3bed7da..3a21a7c 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -11,6 +11,7 @@
 
 #include "super.h"
 #include "mds_client.h"
+#include "cache.h"
 #include <linux/ceph/osd_client.h>
 
 /*
@@ -144,6 +145,11 @@ static void ceph_invalidatepage(struct page *page, unsigned int offset,
 		return;
 	}
 
+	ceph_invalidate_fscache_page(inode, page);
+
+	if (!PagePrivate(page))
+		return;
+
 	/*
 	 * We can get non-dirty pages here due to races between
 	 * set_page_dirty and truncate_complete_page; just spit out a
@@ -163,14 +169,17 @@ static void ceph_invalidatepage(struct page *page, unsigned int offset,
 	ClearPagePrivate(page);
 }
 
-/* just a sanity check */
 static int ceph_releasepage(struct page *page, gfp_t g)
 {
 	struct inode *inode = page->mapping ? page->mapping->host : NULL;
 	dout("%p releasepage %p idx %lu\n", inode, page, page->index);
 	WARN_ON(PageDirty(page));
-	WARN_ON(PagePrivate(page));
-	return 0;
+
+	/* Can we release the page from the cache? */
+	if (!ceph_release_fscache_page(page, g))
+		return 0;
+
+	return !PagePrivate(page);
 }
 
 /*
@@ -180,11 +189,16 @@ static int readpage_nounlock(struct file *filp, struct page *page)
 {
 	struct inode *inode = file_inode(filp);
 	struct ceph_inode_info *ci = ceph_inode(inode);
-	struct ceph_osd_client *osdc = 
+	struct ceph_osd_client *osdc =
 		&ceph_inode_to_client(inode)->client->osdc;
 	int err = 0;
 	u64 len = PAGE_CACHE_SIZE;
 
+	err = ceph_readpage_from_fscache(inode, page);
+
+	if (err == 0)
+		goto out;
+
 	dout("readpage inode %p file %p page %p index %lu\n",
 	     inode, filp, page, page->index);
 	err = ceph_osdc_readpages(osdc, ceph_vino(inode), &ci->i_layout,
@@ -202,6 +216,9 @@ static int readpage_nounlock(struct file *filp, struct page *page)
 	}
 	SetPageUptodate(page);
 
+	if (err == 0)
+		ceph_readpage_to_fscache(inode, page);
+
 out:
 	return err < 0 ? err : 0;
 }
@@ -244,6 +261,7 @@ static void finish_read(struct ceph_osd_request *req, struct ceph_msg *msg)
 		     page->index);
 		flush_dcache_page(page);
 		SetPageUptodate(page);
+		ceph_readpage_to_fscache(inode, page);
 		unlock_page(page);
 		page_cache_release(page);
 		bytes -= PAGE_CACHE_SIZE;
@@ -313,7 +331,7 @@ static int start_read(struct inode *inode, struct list_head *page_list, int max)
 		page = list_entry(page_list->prev, struct page, lru);
 		BUG_ON(PageLocked(page));
 		list_del(&page->lru);
-		
+
  		dout("start_read %p adding %p idx %lu\n", inode, page,
 		     page->index);
 		if (add_to_page_cache_lru(page, &inode->i_data, page->index,
@@ -360,6 +378,12 @@ static int ceph_readpages(struct file *file, struct address_space *mapping,
 	int rc = 0;
 	int max = 0;
 
+	rc = ceph_readpages_from_fscache(mapping->host, mapping, page_list,
+					 &nr_pages);
+
+	if (rc == 0)
+		goto out;
+
 	if (fsc->mount_options->rsize >= PAGE_CACHE_SIZE)
 		max = (fsc->mount_options->rsize + PAGE_CACHE_SIZE - 1)
 			>> PAGE_SHIFT;
@@ -479,6 +503,8 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
 	    CONGESTION_ON_THRESH(fsc->mount_options->congestion_kb))
 		set_bdi_congested(&fsc->backing_dev_info, BLK_RW_ASYNC);
 
+	ceph_readpage_to_fscache(inode, page);
+
 	set_page_writeback(page);
 	err = ceph_osdc_writepages(osdc, ceph_vino(inode),
 				   &ci->i_layout, snapc,
@@ -534,7 +560,6 @@ static void ceph_release_pages(struct page **pages, int num)
 	pagevec_release(&pvec);
 }
 
-
 /*
  * async writeback completion handler.
  *
diff --git a/fs/ceph/cache.c b/fs/ceph/cache.c
new file mode 100644
index 0000000..5c413ec
--- /dev/null
+++ b/fs/ceph/cache.c
@@ -0,0 +1,393 @@
+/*
+ * Ceph cache definitions.
+ *
+ *  Copyright (C) 2013 by Adfin Solutions, Inc. All Rights Reserved.
+ *  Written by Milosz Tanski (milosz@adfin.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2
+ *  as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to:
+ *  Free Software Foundation
+ *  51 Franklin Street, Fifth Floor
+ *  Boston, MA  02111-1301  USA
+ *
+ */
+
+#include <linux/fscache.h>
+
+#include "super.h"
+#include "cache.h"
+
+struct ceph_aux_inode {
+	struct timespec	mtime;
+	loff_t          size;
+};
+
+struct fscache_netfs ceph_cache_netfs = {
+	.name		= "ceph",
+	.version	= 0,
+};
+
+static uint16_t ceph_fscache_session_get_key(const void *cookie_netfs_data,
+					     void *buffer, uint16_t maxbuf)
+{
+	const struct ceph_fs_client* fsc = cookie_netfs_data;
+	uint16_t klen;
+
+	klen = sizeof(fsc->client->fsid);
+	if (klen > maxbuf)
+		return 0;
+
+	memcpy(buffer, &fsc->client->fsid, klen);
+	return klen;
+}
+
+static const struct fscache_cookie_def ceph_fscache_fsid_object_def = {
+	.name		= "CEPH.fsid",
+	.type		= FSCACHE_COOKIE_TYPE_INDEX,
+	.get_key	= ceph_fscache_session_get_key,
+};
+
+int ceph_fscache_register()
+{
+	return fscache_register_netfs(&ceph_cache_netfs);
+}
+
+void ceph_fscache_unregister()
+{
+	fscache_unregister_netfs(&ceph_cache_netfs);
+}
+
+int ceph_fscache_register_fs(struct ceph_fs_client* fsc)
+{
+	fsc->fscache = fscache_acquire_cookie(ceph_cache_netfs.primary_index,
+					      &ceph_fscache_fsid_object_def,
+					      fsc);
+
+	if (fsc->fscache == NULL) {
+		pr_err("Unable to resgister fsid: %p fscache cookie", fsc);
+		return 0;
+	}
+
+	fsc->revalidate_wq = alloc_workqueue("ceph-revalidate", 0, 1);
+	if (fsc->revalidate_wq == NULL)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static uint16_t ceph_fscache_inode_get_key(const void *cookie_netfs_data,
+					   void *buffer, uint16_t maxbuf)
+{
+	const struct ceph_inode_info* ci = cookie_netfs_data;
+	uint16_t klen;
+
+	/* use ceph virtual inode (id + snaphot) */
+	klen = sizeof(ci->i_vino);
+	if (klen > maxbuf)
+		return 0;
+
+	memcpy(buffer, &ci->i_vino, klen);
+	return klen;
+}
+
+static uint16_t ceph_fscache_inode_get_aux(const void *cookie_netfs_data,
+					   void *buffer, uint16_t bufmax)
+{
+	struct ceph_aux_inode aux;
+	const struct ceph_inode_info* ci = cookie_netfs_data;
+	const struct inode* inode = &ci->vfs_inode;
+
+	memset(&aux, 0, sizeof(aux));
+	aux.mtime = inode->i_mtime;
+	aux.size = inode->i_size;
+
+	memcpy(buffer, &aux, sizeof(aux));
+
+	return sizeof(aux);
+}
+
+static void ceph_fscache_inode_get_attr(const void *cookie_netfs_data,
+					uint64_t *size)
+{
+	const struct ceph_inode_info* ci = cookie_netfs_data;
+	const struct inode* inode = &ci->vfs_inode;
+
+	*size = inode->i_size;
+}
+
+static enum fscache_checkaux ceph_fscache_inode_check_aux(
+	void *cookie_netfs_data, const void *data, uint16_t dlen)
+{
+	struct ceph_aux_inode aux;
+	struct ceph_inode_info* ci = cookie_netfs_data;
+	struct inode* inode = &ci->vfs_inode;
+
+	if (dlen != sizeof(aux))
+		return FSCACHE_CHECKAUX_OBSOLETE;
+
+	memset(&aux, 0, sizeof(aux));
+	aux.mtime = inode->i_mtime;
+	aux.size = inode->i_size;
+
+	if (memcmp(data, &aux, sizeof(aux)) != 0)
+		return FSCACHE_CHECKAUX_OBSOLETE;
+
+	dout("ceph inode 0x%p cached okay", ci);
+	return FSCACHE_CHECKAUX_OKAY;
+}
+
+static void ceph_fscache_inode_now_uncached(void* cookie_netfs_data)
+{
+	struct ceph_inode_info* ci = cookie_netfs_data;
+	struct pagevec pvec;
+	pgoff_t first;
+	int loop, nr_pages;
+
+	pagevec_init(&pvec, 0);
+	first = 0;
+
+	dout("ceph inode 0x%p now uncached", ci);
+
+	while (1) {
+		nr_pages = pagevec_lookup(&pvec, ci->vfs_inode.i_mapping, first,
+					  PAGEVEC_SIZE - pagevec_count(&pvec));
+
+		if (!nr_pages)
+			break;
+
+		for (loop = 0; loop < nr_pages; loop++)
+			ClearPageFsCache(pvec.pages[loop]);
+
+		first = pvec.pages[nr_pages - 1]->index + 1;
+
+		pvec.nr = nr_pages;
+		pagevec_release(&pvec);
+		cond_resched();
+	}
+}
+
+static const struct fscache_cookie_def ceph_fscache_inode_object_def = {
+	.name		= "CEPH.inode",
+	.type		= FSCACHE_COOKIE_TYPE_DATAFILE,
+	.get_key	= ceph_fscache_inode_get_key,
+	.get_attr	= ceph_fscache_inode_get_attr,
+	.get_aux	= ceph_fscache_inode_get_aux,
+	.check_aux	= ceph_fscache_inode_check_aux,
+	.now_uncached	= ceph_fscache_inode_now_uncached,
+};
+
+void ceph_fscache_register_inode_cookie(struct ceph_fs_client* fsc,
+					struct ceph_inode_info* ci)
+{
+	struct inode* inode = &ci->vfs_inode;
+
+	/* No caching for filesystem */
+	if (fsc->fscache == NULL)
+		return;
+
+	/* Only cache for regular files that are read only */
+	if ((ci->vfs_inode.i_mode & S_IFREG) == 0)
+		return;
+
+	/* Avoid multiple racing open requests */
+	mutex_lock(&inode->i_mutex);
+
+	if (ci->fscache)
+		goto done;
+
+	ci->fscache = fscache_acquire_cookie(fsc->fscache,
+					     &ceph_fscache_inode_object_def,
+					     ci);
+done:
+	mutex_unlock(&inode->i_mutex);
+
+}
+
+void ceph_fscache_unregister_inode_cookie(struct ceph_inode_info* ci)
+{
+	struct fscache_cookie* cookie;
+
+	if ((cookie = ci->fscache) == NULL)
+		return;
+
+	ci->fscache = NULL;
+
+	fscache_uncache_all_inode_pages(cookie, &ci->vfs_inode);
+	fscache_relinquish_cookie(cookie, 0);
+}
+
+static void ceph_vfs_readpage_complete(struct page *page, void *data, int error)
+{
+	if (!error)
+		SetPageUptodate(page);
+}
+
+static void ceph_vfs_readpage_complete_unlock(struct page *page, void *data, int error)
+{
+	if (!error)
+		SetPageUptodate(page);
+
+	unlock_page(page);
+}
+
+static inline int cache_valid(struct ceph_inode_info *ci)
+{
+	return ((ceph_caps_issued(ci) & CEPH_CAP_FILE_CACHE) &&
+		(ci->i_fscache_gen == ci->i_rdcache_gen));
+}
+
+
+/* Atempt to read from the fscache,
+ *
+ * This function is called from the readpage_nounlock context. DO NOT attempt to
+ * unlock the page here (or in the callback).
+ */
+int ceph_readpage_from_fscache(struct inode *inode, struct page *page)
+{
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	int ret;
+
+	if (!cache_valid(ci))
+		return -ENOBUFS;
+
+	ret = fscache_read_or_alloc_page(ci->fscache, page,
+					 ceph_vfs_readpage_complete, NULL,
+					 GFP_KERNEL);
+
+	switch (ret) {
+		case 0: /* Page found */
+			dout("page read submitted\n");
+			return 0;
+		case -ENOBUFS: /* Pages were not found, and can't be */
+		case -ENODATA: /* Pages were not found */
+			dout("page/inode not in cache\n");
+			return ret;
+		default:
+			dout("%s: unknown error ret = %i\n", __func__, ret);
+			return ret;
+	}
+}
+
+int ceph_readpages_from_fscache(struct inode *inode,
+				  struct address_space *mapping,
+				  struct list_head *pages,
+				  unsigned *nr_pages)
+{
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	int ret;
+
+	if (!cache_valid(ci))
+		return -ENOBUFS;
+
+	ret = fscache_read_or_alloc_pages(ci->fscache, mapping, pages, nr_pages,
+					  ceph_vfs_readpage_complete_unlock,
+					  NULL, mapping_gfp_mask(mapping));
+
+	switch (ret) {
+		case 0: /* All pages found */
+			dout("all-page read submitted\n");
+			return 0;
+		case -ENOBUFS: /* Some pages were not found, and can't be */
+		case -ENODATA: /* some pages were not found */
+			dout("page/inode not in cache\n");
+			return ret;
+		default:
+			dout("%s: unknown error ret = %i\n", __func__, ret);
+			return ret;
+	}
+}
+
+void ceph_readpage_to_fscache(struct inode *inode, struct page *page)
+{
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	int ret;
+
+	if (!cache_valid(ci))
+		return;
+
+	ret = fscache_write_page(ci->fscache, page, GFP_KERNEL);
+	if (ret)
+		 fscache_uncache_page(ci->fscache, page);
+}
+
+void ceph_invalidate_fscache_page(struct inode* inode, struct page *page)
+{
+	struct ceph_inode_info *ci = ceph_inode(inode);
+
+	fscache_wait_on_page_write(ci->fscache, page);
+	fscache_uncache_page(ci->fscache, page);
+}
+
+void ceph_fscache_unregister_fs(struct ceph_fs_client* fsc)
+{
+	if (fsc->revalidate_wq)
+		destroy_workqueue(fsc->revalidate_wq);
+
+	fscache_relinquish_cookie(fsc->fscache, 0);
+	fsc->fscache = NULL;
+}
+
+static void ceph_revalidate_work(struct work_struct *work)
+{
+	int issued;
+	u32 orig_gen;
+	struct ceph_inode_info *ci = container_of(work, struct ceph_inode_info,
+						  i_revalidate_work);
+	struct inode *inode = &ci->vfs_inode;
+
+	spin_lock(&ci->i_ceph_lock);
+	issued = __ceph_caps_issued(ci, NULL);
+	orig_gen = ci->i_rdcache_gen;
+	spin_unlock(&ci->i_ceph_lock);
+
+	if (!(issued & CEPH_CAP_FILE_CACHE)) {
+		dout("revalidate_work lost cache before validation %p\n",
+		     inode);
+		goto out;
+	}
+
+	if (!fscache_check_consistency(ci->fscache))
+		fscache_invalidate(ci->fscache);
+
+	spin_lock(&ci->i_ceph_lock);
+	/* Update the new valid generation (backwards sanity check too) */
+	if (orig_gen > ci->i_fscache_gen) {
+		ci->i_fscache_gen = orig_gen;
+	}
+	spin_unlock(&ci->i_ceph_lock);
+
+out:
+	iput(&ci->vfs_inode);
+}
+
+void ceph_queue_revalidate(struct inode *inode)
+{
+	struct ceph_inode_info *ci = ceph_inode(inode);
+
+	ihold(inode);
+
+	if (queue_work(ceph_sb_to_client(inode->i_sb)->revalidate_wq,
+		       &ci->i_revalidate_work)) {
+		dout("ceph_queue_revalidate %p\n", inode);
+	} else {
+		dout("ceph_queue_revalidate %p failed\n)", inode);
+		iput(inode);
+	}
+}
+
+void ceph_fscache_inode_init(struct ceph_inode_info *ci)
+{
+	ci->fscache = NULL;
+	/* The first load is verifed cookie open time */
+	ci->i_fscache_gen = 1;
+	INIT_WORK(&ci->i_revalidate_work, ceph_revalidate_work);
+}
diff --git a/fs/ceph/cache.h b/fs/ceph/cache.h
new file mode 100644
index 0000000..0ea95cb
--- /dev/null
+++ b/fs/ceph/cache.h
@@ -0,0 +1,138 @@
+/*
+ * Ceph cache definitions.
+ *
+ *  Copyright (C) 2013 by Adfin Solutions, Inc. All Rights Reserved.
+ *  Written by Milosz Tanski (milosz@adfin.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2
+ *  as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to:
+ *  Free Software Foundation
+ *  51 Franklin Street, Fifth Floor
+ *  Boston, MA  02111-1301  USA
+ *
+ */
+
+#ifndef _CEPH_CACHE_H
+#define _CEPH_CACHE_H
+
+#ifdef CONFIG_CEPH_FSCACHE
+
+int ceph_fscache_register(void);
+void ceph_fscache_unregister(void);
+
+int ceph_fscache_register_fs(struct ceph_fs_client* fsc);
+void ceph_fscache_unregister_fs(struct ceph_fs_client* fsc);
+
+void ceph_fscache_inode_init(struct ceph_inode_info *ci);
+void ceph_fscache_register_inode_cookie(struct ceph_fs_client* fsc,
+					struct ceph_inode_info* ci);
+void ceph_fscache_unregister_inode_cookie(struct ceph_inode_info* ci);
+
+int ceph_readpage_from_fscache(struct inode *inode, struct page *page);
+int ceph_readpages_from_fscache(struct inode *inode,
+				struct address_space *mapping,
+				struct list_head *pages,
+				unsigned *nr_pages);
+void ceph_readpage_to_fscache(struct inode *inode, struct page *page);
+void ceph_invalidate_fscache_page(struct inode* inode, struct page *page);
+void ceph_queue_revalidate(struct inode *inode);
+
+static inline void ceph_fscache_invalidate(struct inode *inode)
+{
+	fscache_invalidate(ceph_inode(inode)->fscache);
+}
+
+static inline int ceph_release_fscache_page(struct page *page, gfp_t gfp)
+{
+	struct inode* inode = page->mapping->host;
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	return fscache_maybe_release_page(ci->fscache, page, gfp);
+}
+
+#else
+
+static inline int ceph_fscache_register(void)
+{
+	return 0;
+}
+
+static inline void ceph_fscache_unregister(void)
+{
+}
+
+static inline int ceph_fscache_register_fs(struct ceph_fs_client* fsc)
+{
+	return 0;
+}
+
+static inline void ceph_fscache_unregister_fs(struct ceph_fs_client* fsc)
+{
+}
+
+static inline void ceph_fscache_inode_init(struct ceph_inode_info *ci)
+{
+}
+
+static inline void ceph_fscache_register_inode_cookie(struct ceph_fs_client* parent_fsc,
+						      struct ceph_inode_info* ci)
+{
+}
+
+static inline void ceph_fscache_unregister_inode_cookie(struct ceph_inode_info* ci)
+{
+}
+
+static inline int ceph_readpage_from_fscache(struct inode* inode,
+					     struct page *page)
+{
+	return -ENOBUFS;
+}
+
+static inline int ceph_readpages_from_fscache(struct inode *inode,
+					      struct address_space *mapping,
+					      struct list_head *pages,
+					      unsigned *nr_pages)
+{
+	return -ENOBUFS;
+}
+
+static inline void ceph_readpage_to_fscache(struct inode *inode,
+					    struct page *page)
+{
+}
+
+static inline void ceph_fscache_invalidate(struct inode *inode)
+{
+}
+
+static inline void ceph_invalidate_fscache_page(struct inode *inode,
+						struct page *page)
+{
+}
+
+static inline int ceph_release_fscache_page(struct page *page, gfp_t gfp)
+{
+	return 1;
+}
+
+static inline void ceph_fscache_readpages_cancel(struct inode *inode,
+						 struct list_head *pages)
+{
+}
+
+static inline void ceph_queue_revalidate(struct inode *inode)
+{
+}
+
+#endif
+
+#endif
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 5a26bc1..7b451eb 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -10,6 +10,7 @@
 
 #include "super.h"
 #include "mds_client.h"
+#include "cache.h"
 #include <linux/ceph/decode.h>
 #include <linux/ceph/messenger.h>
 
@@ -479,8 +480,9 @@ static void __check_cap_issue(struct ceph_inode_info *ci, struct ceph_cap *cap,
 	 * i_rdcache_gen.
 	 */
 	if ((issued & (CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO)) &&
-	    (had & (CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO)) == 0)
+	    (had & (CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO)) == 0) {
 		ci->i_rdcache_gen++;
+	}
 
 	/*
 	 * if we are newly issued FILE_SHARED, mark dir not complete; we
@@ -2395,6 +2397,7 @@ static void handle_cap_grant(struct inode *inode, struct ceph_mds_caps *grant,
 	int writeback = 0;
 	int queue_invalidate = 0;
 	int deleted_inode = 0;
+	int queue_revalidate = 0;
 
 	dout("handle_cap_grant inode %p cap %p mds%d seq %d %s\n",
 	     inode, cap, mds, seq, ceph_cap_string(newcaps));
@@ -2417,6 +2420,8 @@ static void handle_cap_grant(struct inode *inode, struct ceph_mds_caps *grant,
 				ci->i_rdcache_revoking = ci->i_rdcache_gen;
 			}
 		}
+
+		ceph_fscache_invalidate(inode);
 	}
 
 	/* side effects now are allowed */
@@ -2458,6 +2463,11 @@ static void handle_cap_grant(struct inode *inode, struct ceph_mds_caps *grant,
 		}
 	}
 
+	/* Do we need to revalidate our fscache cookie. Don't bother on the
+	 * first cache cap as we already validate at cookie creation time. */
+	if ((issued & CEPH_CAP_FILE_CACHE) && ci->i_rdcache_gen > 1)
+		queue_revalidate = 1;
+
 	/* size/ctime/mtime/atime? */
 	ceph_fill_file_size(inode, issued,
 			    le32_to_cpu(grant->truncate_seq),
@@ -2542,6 +2552,7 @@ static void handle_cap_grant(struct inode *inode, struct ceph_mds_caps *grant,
 	BUG_ON(cap->issued & ~cap->implemented);
 
 	spin_unlock(&ci->i_ceph_lock);
+
 	if (writeback)
 		/*
 		 * queue inode for writeback: we can't actually call
@@ -2553,6 +2564,8 @@ static void handle_cap_grant(struct inode *inode, struct ceph_mds_caps *grant,
 		ceph_queue_invalidate(inode);
 	if (deleted_inode)
 		invalidate_aliases(inode);
+	if (queue_revalidate)
+		ceph_queue_revalidate(inode);
 	if (wake)
 		wake_up_all(&ci->i_cap_wq);
 
@@ -2709,8 +2722,10 @@ static void handle_cap_trunc(struct inode *inode,
 					  truncate_seq, truncate_size, size);
 	spin_unlock(&ci->i_ceph_lock);
 
-	if (queue_trunc)
+	if (queue_trunc) {
 		ceph_queue_vmtruncate(inode);
+		ceph_fscache_invalidate(inode);
+	}
 }
 
 /*
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 20d0222..3de8982 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -12,6 +12,7 @@
 
 #include "super.h"
 #include "mds_client.h"
+#include "cache.h"
 
 /*
  * Ceph file operations
@@ -69,9 +70,23 @@ static int ceph_init_file(struct inode *inode, struct file *file, int fmode)
 {
 	struct ceph_file_info *cf;
 	int ret = 0;
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	struct ceph_fs_client *fsc = ceph_sb_to_client(inode->i_sb);
+	struct ceph_mds_client *mdsc = fsc->mdsc;
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFREG:
+		/* First file open request creates the cookie, we want to keep
+		 * this cookie around for the filetime of the inode as not to
+		 * have to worry about fscache register / revoke / operation
+		 * races.
+		 *
+		 * Also, if we know the operation is going to invalidate data
+		 * (non readonly) just nuke the cache right away.
+		 */
+		ceph_fscache_register_inode_cookie(mdsc->fsc, ci);
+		if ((fmode & CEPH_FILE_MODE_WR))
+			ceph_fscache_invalidate(inode);
 	case S_IFDIR:
 		dout("init_file %p %p 0%o (regular)\n", inode, file,
 		     inode->i_mode);
@@ -182,6 +197,7 @@ int ceph_open(struct inode *inode, struct file *file)
 		spin_unlock(&ci->i_ceph_lock);
 		return ceph_init_file(inode, file, fmode);
 	}
+
 	spin_unlock(&ci->i_ceph_lock);
 
 	dout("open fmode %d wants %s\n", fmode, ceph_cap_string(wanted));
@@ -192,6 +208,7 @@ int ceph_open(struct inode *inode, struct file *file)
 	}
 	req->r_inode = inode;
 	ihold(inode);
+
 	req->r_num_caps = 1;
 	if (flags & (O_CREAT|O_TRUNC))
 		parent_inode = ceph_get_dentry_parent_inode(file->f_dentry);
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 602ccd8..eae41cd 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -12,6 +12,7 @@
 
 #include "super.h"
 #include "mds_client.h"
+#include "cache.h"
 #include <linux/ceph/decode.h>
 
 /*
@@ -386,6 +387,8 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
 
 	INIT_WORK(&ci->i_vmtruncate_work, ceph_vmtruncate_work);
 
+	ceph_fscache_inode_init(ci);
+
 	return &ci->vfs_inode;
 }
 
@@ -405,6 +408,8 @@ void ceph_destroy_inode(struct inode *inode)
 
 	dout("destroy_inode %p ino %llx.%llx\n", inode, ceph_vinop(inode));
 
+	ceph_fscache_unregister_inode_cookie(ci);
+
 	ceph_queue_caps_release(inode);
 
 	/*
@@ -439,7 +444,6 @@ void ceph_destroy_inode(struct inode *inode)
 	call_rcu(&inode->i_rcu, ceph_i_callback);
 }
 
-
 /*
  * Helpers to fill in size, ctime, mtime, and atime.  We have to be
  * careful because either the client or MDS may have more up to date
@@ -491,6 +495,10 @@ int ceph_fill_file_size(struct inode *inode, int issued,
 		     truncate_size);
 		ci->i_truncate_size = truncate_size;
 	}
+
+	if (queue_trunc)
+		ceph_fscache_invalidate(inode);
+
 	return queue_trunc;
 }
 
@@ -1079,7 +1087,7 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req,
 			 * complete.
 			 */
 			ceph_set_dentry_offset(req->r_old_dentry);
-			dout("dn %p gets new offset %lld\n", req->r_old_dentry, 
+			dout("dn %p gets new offset %lld\n", req->r_old_dentry,
 			     ceph_dentry(req->r_old_dentry)->offset);
 
 			dn = req->r_old_dentry;  /* use old_dentry */
@@ -1494,6 +1502,7 @@ void ceph_queue_vmtruncate(struct inode *inode)
 	struct ceph_inode_info *ci = ceph_inode(inode);
 
 	ihold(inode);
+
 	if (queue_work(ceph_sb_to_client(inode->i_sb)->trunc_wq,
 		       &ci->i_vmtruncate_work)) {
 		dout("ceph_queue_vmtruncate %p\n", inode);
@@ -1565,7 +1574,6 @@ retry:
 	wake_up_all(&ci->i_cap_wq);
 }
 
-
 /*
  * symlinks
  */
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 6627b26..6a0951e 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -17,6 +17,7 @@
 
 #include "super.h"
 #include "mds_client.h"
+#include "cache.h"
 
 #include <linux/ceph/ceph_features.h>
 #include <linux/ceph/decode.h>
@@ -142,6 +143,8 @@ enum {
 	Opt_nodcache,
 	Opt_ino32,
 	Opt_noino32,
+	Opt_fscache,
+	Opt_nofscache
 };
 
 static match_table_t fsopt_tokens = {
@@ -167,6 +170,8 @@ static match_table_t fsopt_tokens = {
 	{Opt_nodcache, "nodcache"},
 	{Opt_ino32, "ino32"},
 	{Opt_noino32, "noino32"},
+	{Opt_fscache, "fsc"},
+	{Opt_nofscache, "nofsc"},
 	{-1, NULL}
 };
 
@@ -260,6 +265,12 @@ static int parse_fsopt_token(char *c, void *private)
 	case Opt_noino32:
 		fsopt->flags &= ~CEPH_MOUNT_OPT_INO32;
 		break;
+	case Opt_fscache:
+		fsopt->flags |= CEPH_MOUNT_OPT_FSCACHE;
+		break;
+	case Opt_nofscache:
+		fsopt->flags &= ~CEPH_MOUNT_OPT_FSCACHE;
+		break;
 	default:
 		BUG_ON(token);
 	}
@@ -422,6 +433,10 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
 		seq_puts(m, ",dcache");
 	else
 		seq_puts(m, ",nodcache");
+	if (fsopt->flags & CEPH_MOUNT_OPT_FSCACHE)
+		seq_puts(m, ",fsc");
+	else
+		seq_puts(m, ",nofsc");
 
 	if (fsopt->wsize)
 		seq_printf(m, ",wsize=%d", fsopt->wsize);
@@ -530,11 +545,18 @@ static struct ceph_fs_client *create_fs_client(struct ceph_mount_options *fsopt,
 	if (!fsc->wb_pagevec_pool)
 		goto fail_trunc_wq;
 
+	/* setup fscache */
+	if ((fsopt->flags & CEPH_MOUNT_OPT_FSCACHE) &&
+	    (ceph_fscache_register_fs(fsc) != 0))
+		goto fail_fscache;
+
 	/* caps */
 	fsc->min_caps = fsopt->max_readdir;
 
 	return fsc;
 
+fail_fscache:
+	ceph_fscache_unregister_fs(fsc);
 fail_trunc_wq:
 	destroy_workqueue(fsc->trunc_wq);
 fail_pg_inv_wq:
@@ -554,6 +576,8 @@ static void destroy_fs_client(struct ceph_fs_client *fsc)
 {
 	dout("destroy_fs_client %p\n", fsc);
 
+	ceph_fscache_unregister_fs(fsc);
+
 	destroy_workqueue(fsc->wb_wq);
 	destroy_workqueue(fsc->pg_inv_wq);
 	destroy_workqueue(fsc->trunc_wq);
@@ -588,6 +612,8 @@ static void ceph_inode_init_once(void *foo)
 
 static int __init init_caches(void)
 {
+	int error = -ENOMEM;
+
 	ceph_inode_cachep = kmem_cache_create("ceph_inode_info",
 				      sizeof(struct ceph_inode_info),
 				      __alignof__(struct ceph_inode_info),
@@ -611,15 +637,17 @@ static int __init init_caches(void)
 	if (ceph_file_cachep == NULL)
 		goto bad_file;
 
-	return 0;
+	if ((error = ceph_fscache_register()))
+		goto bad_file;
 
+	return 0;
 bad_file:
 	kmem_cache_destroy(ceph_dentry_cachep);
 bad_dentry:
 	kmem_cache_destroy(ceph_cap_cachep);
 bad_cap:
 	kmem_cache_destroy(ceph_inode_cachep);
-	return -ENOMEM;
+	return error;
 }
 
 static void destroy_caches(void)
@@ -629,10 +657,13 @@ static void destroy_caches(void)
 	 * destroy cache.
 	 */
 	rcu_barrier();
+
 	kmem_cache_destroy(ceph_inode_cachep);
 	kmem_cache_destroy(ceph_cap_cachep);
 	kmem_cache_destroy(ceph_dentry_cachep);
 	kmem_cache_destroy(ceph_file_cachep);
+
+	ceph_fscache_unregister();
 }
 
 
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index f1e4e47..bb23ef6 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -16,6 +16,10 @@
 
 #include <linux/ceph/libceph.h>
 
+#ifdef CONFIG_CEPH_FSCACHE
+#include <linux/fscache.h>
+#endif
+
 /* f_type in struct statfs */
 #define CEPH_SUPER_MAGIC 0x00c36400
 
@@ -29,6 +33,7 @@
 #define CEPH_MOUNT_OPT_NOASYNCREADDIR  (1<<7) /* no dcache readdir */
 #define CEPH_MOUNT_OPT_INO32           (1<<8) /* 32 bit inos */
 #define CEPH_MOUNT_OPT_DCACHE          (1<<9) /* use dcache for readdir etc */
+#define CEPH_MOUNT_OPT_FSCACHE         (1<<10) /* use fscache */
 
 #define CEPH_MOUNT_OPT_DEFAULT    (CEPH_MOUNT_OPT_RBYTES)
 
@@ -90,6 +95,11 @@ struct ceph_fs_client {
 	struct dentry *debugfs_bdi;
 	struct dentry *debugfs_mdsc, *debugfs_mdsmap;
 #endif
+
+#ifdef CONFIG_CEPH_FSCACHE
+	struct fscache_cookie *fscache;
+	struct workqueue_struct *revalidate_wq;
+#endif
 };
 
 
@@ -320,6 +330,12 @@ struct ceph_inode_info {
 
 	struct work_struct i_vmtruncate_work;
 
+#ifdef CONFIG_CEPH_FSCACHE
+	struct fscache_cookie *fscache;
+	u32 i_fscache_gen; /* sequence, for delayed fscache validate */
+	struct work_struct i_revalidate_work;
+#endif
+
 	struct inode vfs_inode; /* at end */
 };
 
-- 
1.7.9.5

