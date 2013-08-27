Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979Ab3H0BFU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:05:20 -0400
Received: from cobra.newdream.net ([66.33.216.30]:43746 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab3H0BFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:05:14 -0400
Date: Mon, 26 Aug 2013 18:05:14 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: Milosz Tanski <milosz@adfin.com>
cc: ceph-devel@vger.kernel.org, zheng.z.yan@intel.com, dhowells@redhat.com,
        linux-cachefs@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] ceph: use fscache as a local presisent cache
In-Reply-To: <c701d932a7e7b6f7b30cda7a812d4cc781369ed5.1375999914.git.milosz@adfin.com>
Message-ID: <alpine.DEB.2.00.1308261755390.1794@cobra.newdream.net>
References: <cover.1375999914.git.milosz@adfin.com> <c701d932a7e7b6f7b30cda7a812d4cc781369ed5.1375999914.git.milosz@adfin.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Aug 2013, Milosz Tanski wrote:
> Adding support for fscache to the Ceph filesystem. This would bring it to on
> par with some of the other network filesystems in Linux (like NFS, AFS, etc...)
> 
> In order to mount the filesystem with fscache the 'fsc' mount option must be
> passed.
> 
> Signed-off-by: Milosz Tanski <milosz@adfin.com>

I fixed up a couple build errors when adding this to the tree and realized 
a few things need to be cleaned up first.  Basically, any #ifdef 
CONFIG_CEPH_FSCACHE outside of a header file is a no-no.  Everything in 
cache.h that is outside of the #ifdef block should be moved in, and no-op 
variants added in the #else block.

More below:

> ---
>  fs/ceph/Kconfig  |   9 ++
>  fs/ceph/Makefile |   2 +
>  fs/ceph/addr.c   |  37 +++++--
>  fs/ceph/cache.c  | 311 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/ceph/cache.h  | 123 ++++++++++++++++++++++
>  fs/ceph/caps.c   |  19 +++-
>  fs/ceph/file.c   |  17 +++
>  fs/ceph/inode.c  |  66 +++++++++++-
>  fs/ceph/super.c  |  47 ++++++++-
>  fs/ceph/super.h  |  17 +++
>  10 files changed, 636 insertions(+), 12 deletions(-)
>  create mode 100644 fs/ceph/cache.c
>  create mode 100644 fs/ceph/cache.h
> 
> diff --git a/fs/ceph/Kconfig b/fs/ceph/Kconfig
> index 49bc782..ac9a2ef 100644
> --- a/fs/ceph/Kconfig
> +++ b/fs/ceph/Kconfig
> @@ -16,3 +16,12 @@ config CEPH_FS
>  
>  	  If unsure, say N.
>  
> +if CEPH_FS
> +config CEPH_FSCACHE
> +	bool "Enable Ceph client caching support"
> +	depends on CEPH_FS=m && FSCACHE || CEPH_FS=y && FSCACHE=y
> +	help
> +	  Choose Y here to enable persistent, read-only local
> +	  caching support for Ceph clients using FS-Cache
> +
> +endif
> diff --git a/fs/ceph/Makefile b/fs/ceph/Makefile
> index bd35212..0af0678 100644
> --- a/fs/ceph/Makefile
> +++ b/fs/ceph/Makefile
> @@ -9,3 +9,5 @@ ceph-y := super.o inode.o dir.o file.o locks.o addr.o ioctl.o \
>  	mds_client.o mdsmap.o strings.o ceph_frag.o \
>  	debugfs.o
>  
> +ceph-$(CONFIG_CEPH_FSCACHE) += cache.o
> +
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index cb78ce8..632bb48 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -11,6 +11,7 @@
>  
>  #include "super.h"
>  #include "mds_client.h"
> +#include "cache.h"
>  #include <linux/ceph/osd_client.h>
>  
>  /*
> @@ -159,6 +160,11 @@ static void ceph_invalidatepage(struct page *page, unsigned int offset,
>  		return;
>  	}
>  
> +	ceph_invalidate_fscache_page(inode, page);
> +
> +	if (!PagePrivate(page))
> +		return;
> +
>  	/*
>  	 * We can get non-dirty pages here due to races between
>  	 * set_page_dirty and truncate_complete_page; just spit out a
> @@ -178,14 +184,17 @@ static void ceph_invalidatepage(struct page *page, unsigned int offset,
>  	ClearPagePrivate(page);
>  }
>  
> -/* just a sanity check */
>  static int ceph_releasepage(struct page *page, gfp_t g)
>  {
>  	struct inode *inode = page->mapping ? page->mapping->host : NULL;
>  	dout("%p releasepage %p idx %lu\n", inode, page, page->index);
>  	WARN_ON(PageDirty(page));
> -	WARN_ON(PagePrivate(page));
> -	return 0;
> +
> +	/* Can we release the page from the cache? */
> +	if (!ceph_release_fscache_page(page, g))
> +		return 0;
> +
> +	return !PagePrivate(page);
>  }
>  
>  /*
> @@ -195,11 +204,16 @@ static int readpage_nounlock(struct file *filp, struct page *page)
>  {
>  	struct inode *inode = file_inode(filp);
>  	struct ceph_inode_info *ci = ceph_inode(inode);
> -	struct ceph_osd_client *osdc = 
> +	struct ceph_osd_client *osdc =
>  		&ceph_inode_to_client(inode)->client->osdc;
>  	int err = 0;
>  	u64 len = PAGE_CACHE_SIZE;
>  
> +	err = ceph_readpage_from_fscache(inode, page);
> +
> +	if (err == 0)
> +		goto out;
> +
>  	dout("readpage inode %p file %p page %p index %lu\n",
>  	     inode, filp, page, page->index);
>  	err = ceph_osdc_readpages(osdc, ceph_vino(inode), &ci->i_layout,
> @@ -217,6 +231,9 @@ static int readpage_nounlock(struct file *filp, struct page *page)
>  	}
>  	SetPageUptodate(page);
>  
> +	if (err == 0)
> +		ceph_readpage_to_fscache(inode, page);
> +
>  out:
>  	return err < 0 ? err : 0;
>  }
> @@ -259,6 +276,7 @@ static void finish_read(struct ceph_osd_request *req, struct ceph_msg *msg)
>  		     page->index);
>  		flush_dcache_page(page);
>  		SetPageUptodate(page);
> +		ceph_readpage_to_fscache(inode, page);
>  		unlock_page(page);
>  		page_cache_release(page);
>  		bytes -= PAGE_CACHE_SIZE;
> @@ -328,7 +346,7 @@ static int start_read(struct inode *inode, struct list_head *page_list, int max)
>  		page = list_entry(page_list->prev, struct page, lru);
>  		BUG_ON(PageLocked(page));
>  		list_del(&page->lru);
> -		
> +
>   		dout("start_read %p adding %p idx %lu\n", inode, page,
>  		     page->index);
>  		if (add_to_page_cache_lru(page, &inode->i_data, page->index,
> @@ -375,6 +393,12 @@ static int ceph_readpages(struct file *file, struct address_space *mapping,
>  	int rc = 0;
>  	int max = 0;
>  
> +	rc = ceph_readpages_from_fscache(mapping->host, mapping, page_list,
> +					 &nr_pages);
> +
> +	if (rc == 0)
> +		goto out;
> +
>  	if (fsc->mount_options->rsize >= PAGE_CACHE_SIZE)
>  		max = (fsc->mount_options->rsize + PAGE_CACHE_SIZE - 1)
>  			>> PAGE_SHIFT;
> @@ -494,6 +518,8 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
>  	    CONGESTION_ON_THRESH(fsc->mount_options->congestion_kb))
>  		set_bdi_congested(&fsc->backing_dev_info, BLK_RW_ASYNC);
>  
> +	ceph_readpage_to_fscache(inode, page);
> +
>  	set_page_writeback(page);
>  	err = ceph_osdc_writepages(osdc, ceph_vino(inode),
>  				   &ci->i_layout, snapc,
> @@ -549,7 +575,6 @@ static void ceph_release_pages(struct page **pages, int num)
>  	pagevec_release(&pvec);
>  }
>  
> -
>  /*
>   * async writeback completion handler.
>   *
> diff --git a/fs/ceph/cache.c b/fs/ceph/cache.c
> new file mode 100644
> index 0000000..a5ad9c3
> --- /dev/null
> +++ b/fs/ceph/cache.c
> @@ -0,0 +1,311 @@
> +/*
> + * Ceph cache definitions.
> + *
> + *  Copyright (C) 2013 by Adfin Solutions, Inc. All Rights Reserved.
> + *  Written by Milosz Tanski (milosz@adfin.com)
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License version 2
> + *  as published by the Free Software Foundation.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to:
> + *  Free Software Foundation
> + *  51 Franklin Street, Fifth Floor
> + *  Boston, MA  02111-1301  USA
> + *
> + */
> +
> +#include "super.h"
> +#include "cache.h"
> +
> +struct ceph_aux_inode {
> +	struct timespec	mtime;
> +	loff_t          size;
> +};
> +
> +struct fscache_netfs ceph_cache_netfs = {
> +	.name		= "ceph",
> +	.version	= 0,
> +};
> +
> +static uint16_t ceph_fscache_session_get_key(const void *cookie_netfs_data,
> +					     void *buffer, uint16_t maxbuf)
> +{
> +	const struct ceph_fs_client* fsc = cookie_netfs_data;
> +	uint16_t klen;
> +
> +	klen = sizeof(fsc->client->fsid);
> +	if (klen > maxbuf)
> +		return 0;
> +
> +	memcpy(buffer, &fsc->client->fsid, klen);
> +	return klen;
> +}
> +
> +static const struct fscache_cookie_def ceph_fscache_fsid_object_def = {
> +	.name		= "CEPH.fsid",
> +	.type		= FSCACHE_COOKIE_TYPE_INDEX,
> +	.get_key	= ceph_fscache_session_get_key,
> +};
> +
> +void ceph_fscache_register_fsid_cookie(struct ceph_fs_client* fsc)
> +{
> +	fsc->fscache = fscache_acquire_cookie(ceph_cache_netfs.primary_index,
> +					      &ceph_fscache_fsid_object_def,
> +					      fsc);
> +}
> +
> +void ceph_fscache_unregister_fsid_cookie(struct ceph_fs_client* fsc)
> +{
> +	fscache_relinquish_cookie(fsc->fscache, 0);
> +	fsc->fscache = NULL;
> +}
> +
> +static uint16_t ceph_fscache_inode_get_key(const void *cookie_netfs_data,
> +					   void *buffer, uint16_t maxbuf)
> +{
> +	const struct ceph_inode_info* ci = cookie_netfs_data;
> +	uint16_t klen;
> +
> +	/* use ceph virtual inode (id + snaphot) */
> +	klen = sizeof(ci->i_vino);
> +	if (klen > maxbuf)
> +		return 0;
> +
> +	memcpy(buffer, &ci->i_vino, klen);
> +	return klen;
> +}
> +
> +static uint16_t ceph_fscache_inode_get_aux(const void *cookie_netfs_data,
> +					   void *buffer, uint16_t bufmax)
> +{
> +	struct ceph_aux_inode aux;
> +	const struct ceph_inode_info* ci = cookie_netfs_data;
> +	const struct inode* inode = &ci->vfs_inode;
> +
> +	memset(&aux, 0, sizeof(aux));
> +	aux.mtime = inode->i_mtime;
> +	aux.size = inode->i_size;
> +
> +	memcpy(buffer, &aux, sizeof(aux));
> +
> +	return sizeof(aux);
> +}
> +
> +static void ceph_fscache_inode_get_attr(const void *cookie_netfs_data,
> +					uint64_t *size)
> +{
> +	const struct ceph_inode_info* ci = cookie_netfs_data;
> +	const struct inode* inode = &ci->vfs_inode;
> +
> +	*size = inode->i_size;
> +}
> +
> +static enum fscache_checkaux ceph_fscache_inode_check_aux(
> +	void *cookie_netfs_data, const void *data, uint16_t dlen)
> +{
> +	struct ceph_aux_inode aux;
> +	struct ceph_inode_info* ci = cookie_netfs_data;
> +	struct inode* inode = &ci->vfs_inode;
> +
> +	if (dlen != sizeof(aux))
> +		return FSCACHE_CHECKAUX_OBSOLETE;
> +
> +	memset(&aux, 0, sizeof(aux));
> +	aux.mtime = inode->i_mtime;
> +	aux.size = inode->i_size;
> +
> +	if (memcmp(data, &aux, sizeof(aux)) != 0)
> +		return FSCACHE_CHECKAUX_OBSOLETE;
> +
> +	dout("ceph inode 0x%p cached okay", ci);
> +	return FSCACHE_CHECKAUX_OKAY;
> +}
> +
> +static void ceph_fscache_inode_now_uncached(void* cookie_netfs_data)
> +{
> +	struct ceph_inode_info* ci = cookie_netfs_data;
> +	struct pagevec pvec;
> +	pgoff_t first;
> +	int loop, nr_pages;
> +
> +	pagevec_init(&pvec, 0);
> +	first = 0;
> +
> +	dout("ceph inode 0x%p now uncached", ci);
> +
> +	while (1) {
> +		nr_pages = pagevec_lookup(&pvec, ci->vfs_inode.i_mapping, first,
> +					  PAGEVEC_SIZE - pagevec_count(&pvec));
> +
> +		if (!nr_pages)
> +			break;
> +
> +		for (loop = 0; loop < nr_pages; loop++)
> +			ClearPageFsCache(pvec.pages[loop]);
> +
> +		first = pvec.pages[nr_pages - 1]->index + 1;
> +
> +		pvec.nr = nr_pages;
> +		pagevec_release(&pvec);
> +		cond_resched();
> +	}
> +}
> +
> +static const struct fscache_cookie_def ceph_fscache_inode_object_def = {
> +	.name		= "CEPH.inode",
> +	.type		= FSCACHE_COOKIE_TYPE_DATAFILE,
> +	.get_key	= ceph_fscache_inode_get_key,
> +	.get_attr	= ceph_fscache_inode_get_attr,
> +	.get_aux	= ceph_fscache_inode_get_aux,
> +	.check_aux	= ceph_fscache_inode_check_aux,
> +	.now_uncached	= ceph_fscache_inode_now_uncached,
> +};
> +
> +void ceph_fscache_register_inode_cookie(struct ceph_fs_client* fsc,
> +					struct ceph_inode_info* ci)
> +{
> +	struct inode* inode = &ci->vfs_inode;
> +
> +	/* No caching for filesystem */
> +	if (fsc->fscache == NULL)
> +		return;
> +
> +	/* Only cache for regular files that are read only */
> +	if ((ci->vfs_inode.i_mode & S_IFREG) == 0)
> +		return;
> +
> +	/* Avoid multiple racing open requests */
> +	mutex_lock(&inode->i_mutex);
> +
> +	if (ci->fscache)
> +		goto done;
> +
> +	ci->fscache = fscache_acquire_cookie(fsc->fscache,
> +					     &ceph_fscache_inode_object_def,
> +					     ci);
> +done:
> +	mutex_unlock(&inode->i_mutex);
> +
> +}
> +
> +void ceph_fscache_unregister_inode_cookie(struct ceph_inode_info* ci)
> +{
> +	struct fscache_cookie* cookie;
> +
> +	if ((cookie = ci->fscache) == NULL)
> +		return;
> +
> +	ci->fscache = NULL;
> +
> +	fscache_uncache_all_inode_pages(cookie, &ci->vfs_inode);
> +	fscache_relinquish_cookie(cookie, 0);
> +}
> +
> +static void ceph_vfs_readpage_complete(struct page *page, void *data, int error)
> +{
> +	if (!error)
> +		SetPageUptodate(page);
> +}
> +
> +static void ceph_vfs_readpage_complete_unlock(struct page *page, void *data, int error)
> +{
> +	if (!error)
> +		SetPageUptodate(page);
> +
> +	unlock_page(page);
> +}
> +
> +static inline int cache_valid(struct ceph_inode_info *ci)
> +{
> +	return ((ceph_caps_issued(ci) & CEPH_CAP_FILE_CACHE) &&
> +		(ci->i_fscache_gen == ci->i_rdcache_gen));
> +}
> +
> +
> +/* Atempt to read from the fscache,
> + *
> + * This function is called from the readpage_nounlock context. DO NOT attempt to
> + * unlock the page here (or in the callback).
> + */
> +int __ceph_readpage_from_fscache(struct inode *inode, struct page *page)
> +{
> +	struct ceph_inode_info *ci = ceph_inode(inode);
> +	int ret;
> +
> +	if (!cache_valid(ci))
> +		return -ENOBUFS;
> +
> +	ret = fscache_read_or_alloc_page(ci->fscache, page,
> +					 ceph_vfs_readpage_complete, NULL,
> +					 GFP_KERNEL);
> +
> +	switch (ret) {
> +		case 0: /* Page found */
> +			dout("page read submitted\n");
> +			return 0;
> +		case -ENOBUFS: /* Pages were not found, and can't be */
> +		case -ENODATA: /* Pages were not found */
> +			dout("page/inode not in cache\n");
> +			return ret;
> +		default:
> +			dout("%s: unknown error ret = %i\n", __func__, ret);
> +			return ret;
> +	}
> +}
> +
> +int __ceph_readpages_from_fscache(struct inode *inode,
> +				  struct address_space *mapping,
> +				  struct list_head *pages,
> +				  unsigned *nr_pages)
> +{
> +	struct ceph_inode_info *ci = ceph_inode(inode);
> +	int ret;
> +
> +	if (!cache_valid(ci))
> +		return -ENOBUFS;
> +
> +	ret = fscache_read_or_alloc_pages(ci->fscache, mapping, pages, nr_pages,
> +					  ceph_vfs_readpage_complete_unlock,
> +					  NULL, mapping_gfp_mask(mapping));
> +
> +	switch (ret) {
> +		case 0: /* All pages found */
> +			dout("all-page read submitted\n");
> +			return 0;
> +		case -ENOBUFS: /* Some pages were not found, and can't be */
> +		case -ENODATA: /* some pages were not found */
> +			dout("page/inode not in cache\n");
> +			return ret;
> +		default:
> +			dout("%s: unknown error ret = %i\n", __func__, ret);
> +			return ret;
> +	}
> +}
> +
> +void __ceph_readpage_to_fscache(struct inode *inode, struct page *page)
> +{
> +	struct ceph_inode_info *ci = ceph_inode(inode);
> +	int ret;
> +
> +	if (!cache_valid(ci))
> +		return;
> +
> +	ret = fscache_write_page(ci->fscache, page, GFP_KERNEL);
> +	if (ret)
> +		 fscache_uncache_page(ci->fscache, page);
> +}
> +
> +void __ceph_invalidate_fscache_page(struct inode* inode, struct page *page)
> +{
> +	struct ceph_inode_info *ci = ceph_inode(inode);
> +
> +	fscache_wait_on_page_write(ci->fscache, page);
> +	fscache_uncache_page(ci->fscache, page);
> +}
> diff --git a/fs/ceph/cache.h b/fs/ceph/cache.h
> new file mode 100644
> index 0000000..23f2666
> --- /dev/null
> +++ b/fs/ceph/cache.h
> @@ -0,0 +1,123 @@
> +/*
> + * Ceph cache definitions.
> + *
> + *  Copyright (C) 2013 by Adfin Solutions, Inc. All Rights Reserved.
> + *  Written by Milosz Tanski (milosz@adfin.com)
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License version 2
> + *  as published by the Free Software Foundation.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to:
> + *  Free Software Foundation
> + *  51 Franklin Street, Fifth Floor
> + *  Boston, MA  02111-1301  USA
> + *
> + */
> +
> +#ifndef _CEPH_CACHE_H
> +#define _CEPH_CACHE_H
> +
> +#include <linux/fscache.h>
> +
> +
> +extern struct fscache_netfs ceph_cache_netfs;
> +
> +
> +void ceph_fscache_register_fsid_cookie(struct ceph_fs_client* fsc);
> +void ceph_fscache_unregister_fsid_cookie(struct ceph_fs_client* fsc);
> +void ceph_fscache_register_inode_cookie(struct ceph_fs_client* parent_fsc,
> +					struct ceph_inode_info* ci);
> +void ceph_fscache_unregister_inode_cookie(struct ceph_inode_info* ci);
> +
> +int __ceph_readpage_from_fscache(struct inode *inode, struct page *page);
> +int __ceph_readpages_from_fscache(struct inode *inode,
> +				  struct address_space *mapping,
> +				  struct list_head *pages,
> +				  unsigned *nr_pages);
> +void __ceph_readpage_to_fscache(struct inode *inode, struct page *page);
> +void __ceph_invalidate_fscache_page(struct inode* inode, struct page *page);

These should all move down.  The revalidate_work method should get moved 
in here and into cache.c, too.

> +
> +#ifdef CONFIG_CEPH_FSCACHE
> +
> +
> +static inline int ceph_readpage_from_fscache(struct inode* inode,
> +					     struct page *page)
> +{
> +	return __ceph_readpage_from_fscache(inode, page);
> +}
> +
> +static inline int ceph_readpages_from_fscache(struct inode *inode,
> +					      struct address_space *mapping,
> +					      struct list_head *pages,
> +					      unsigned *nr_pages)
> +{
> +	return __ceph_readpages_from_fscache(inode, mapping, pages,
> +					     nr_pages);
> +}
> +
> +static inline void ceph_readpage_to_fscache(struct inode *inode,
> +					    struct page *page)
> +{
> +	return __ceph_readpage_to_fscache(inode, page);
> +}
> +
> +static inline void ceph_invalidate_fscache_page(struct inode *inode,
> +						struct page *page)
> +{
> +	return __ceph_invalidate_fscache_page(inode, page);
> +}
> +
> +static inline int ceph_release_fscache_page(struct page *page, gfp_t gfp)
> +{
> +	struct inode* inode = page->mapping->host;
> +	struct ceph_inode_info *ci = ceph_inode(inode);
> +	return fscache_maybe_release_page(ci->fscache, page, gfp);
> +}
> +
> +#else
> +
> +static inline int ceph_readpage_from_fscache(struct inode* inode,
> +					     struct page *page)
> +{
> +	return -ENOBUFS;
> +}
> +
> +static inline int ceph_readpages_from_fscache(struct inode *inode,
> +					      struct address_space *mapping,
> +					      struct list_head *pages,
> +					      unsigned *nr_pages)
> +{
> +	return -ENOBUFS;
> +}
> +
> +static inline void ceph_readpage_to_fscache(struct inode *inode,
> +					    struct page *page)
> +{
> +}
> +
> +static inline void ceph_invalidate_fscache_page(struct inode *inode,
> +						struct page *page)
> +{
> +}
> +
> +static inline int ceph_release_fscache_page(struct page *page, gfp_t gfp)
> +{
> +	return 1;
> +}
> +
> +static void ceph_fscache_readpages_cancel(struct inode *inode,
> +					  struct list_head *pages)
> +{
> +
> +}
> +
> +#endif
> +
> +#endif
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 5a26bc1..a94ca4b 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -10,6 +10,7 @@
>  
>  #include "super.h"
>  #include "mds_client.h"
> +#include "cache.h"
>  #include <linux/ceph/decode.h>
>  #include <linux/ceph/messenger.h>
>  
> @@ -479,8 +480,9 @@ static void __check_cap_issue(struct ceph_inode_info *ci, struct ceph_cap *cap,
>  	 * i_rdcache_gen.
>  	 */
>  	if ((issued & (CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO)) &&
> -	    (had & (CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO)) == 0)
> +	    (had & (CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO)) == 0) {
>  		ci->i_rdcache_gen++;
> +	}
>  
>  	/*
>  	 * if we are newly issued FILE_SHARED, mark dir not complete; we
> @@ -2395,6 +2397,7 @@ static void handle_cap_grant(struct inode *inode, struct ceph_mds_caps *grant,
>  	int writeback = 0;
>  	int queue_invalidate = 0;
>  	int deleted_inode = 0;
> +	int queue_revalidate = 0;
>  
>  	dout("handle_cap_grant inode %p cap %p mds%d seq %d %s\n",
>  	     inode, cap, mds, seq, ceph_cap_string(newcaps));
> @@ -2417,6 +2420,8 @@ static void handle_cap_grant(struct inode *inode, struct ceph_mds_caps *grant,
>  				ci->i_rdcache_revoking = ci->i_rdcache_gen;
>  			}
>  		}
> +
> +		fscache_invalidate(ci->fscache);
>  	}
>  
>  	/* side effects now are allowed */
> @@ -2458,6 +2463,11 @@ static void handle_cap_grant(struct inode *inode, struct ceph_mds_caps *grant,
>  		}
>  	}
>  
> +	/* Do we need to revalidate our fscache cookie. Don't bother on the
> +	 * first cache cap as we already validate at cookie creation time. */
> +	if ((issued & CEPH_CAP_FILE_CACHE) && ci->i_rdcache_gen > 1)
> +		queue_revalidate = 1;
> +
>  	/* size/ctime/mtime/atime? */
>  	ceph_fill_file_size(inode, issued,
>  			    le32_to_cpu(grant->truncate_seq),
> @@ -2542,6 +2552,7 @@ static void handle_cap_grant(struct inode *inode, struct ceph_mds_caps *grant,
>  	BUG_ON(cap->issued & ~cap->implemented);
>  
>  	spin_unlock(&ci->i_ceph_lock);
> +
>  	if (writeback)
>  		/*
>  		 * queue inode for writeback: we can't actually call
> @@ -2553,6 +2564,8 @@ static void handle_cap_grant(struct inode *inode, struct ceph_mds_caps *grant,
>  		ceph_queue_invalidate(inode);
>  	if (deleted_inode)
>  		invalidate_aliases(inode);
> +	if (queue_revalidate)
> +		ceph_queue_revalidate(inode);
>  	if (wake)
>  		wake_up_all(&ci->i_cap_wq);
>  
> @@ -2709,8 +2722,10 @@ static void handle_cap_trunc(struct inode *inode,
>  					  truncate_seq, truncate_size, size);
>  	spin_unlock(&ci->i_ceph_lock);
>  
> -	if (queue_trunc)
> +	if (queue_trunc) {
>  		ceph_queue_vmtruncate(inode);
> +		fscache_invalidate(ci->fscache);

This should call ceph_fscache_invalidate(inode), a wrapper in cache.[ch].  
(This is fixed in my patch in the ceph-client.git testing branch.)

> +	}
>  }
>  
>  /*
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 68af489..b81c75f 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -12,6 +12,7 @@
>  
>  #include "super.h"
>  #include "mds_client.h"
> +#include "cache.h"
>  
>  /*
>   * Ceph file operations
> @@ -69,9 +70,23 @@ static int ceph_init_file(struct inode *inode, struct file *file, int fmode)
>  {
>  	struct ceph_file_info *cf;
>  	int ret = 0;
> +	struct ceph_inode_info *ci = ceph_inode(inode);
> +	struct ceph_fs_client *fsc = ceph_sb_to_client(inode->i_sb);
> +	struct ceph_mds_client *mdsc = fsc->mdsc;
>  
>  	switch (inode->i_mode & S_IFMT) {
>  	case S_IFREG:
> +		/* First file open request creates the cookie, we want to keep
> +		 * this cookie around for the filetime of the inode as not to
> +		 * have to worry about fscache register / revoke / operation
> +		 * races.
> +		 *
> +		 * Also, if we know the operation is going to invalidate data
> +		 * (non readonly) just nuke the cache right away.
> +		 */
> +		ceph_fscache_register_inode_cookie(mdsc->fsc, ci);
> +		if ((fmode & CEPH_FILE_MODE_WR))
> +			fscache_invalidate(ci->fscache);
>  	case S_IFDIR:
>  		dout("init_file %p %p 0%o (regular)\n", inode, file,
>  		     inode->i_mode);
> @@ -182,6 +197,7 @@ int ceph_open(struct inode *inode, struct file *file)
>  		spin_unlock(&ci->i_ceph_lock);
>  		return ceph_init_file(inode, file, fmode);
>  	}
> +
>  	spin_unlock(&ci->i_ceph_lock);
>  
>  	dout("open fmode %d wants %s\n", fmode, ceph_cap_string(wanted));
> @@ -192,6 +208,7 @@ int ceph_open(struct inode *inode, struct file *file)
>  	}
>  	req->r_inode = inode;
>  	ihold(inode);
> +
>  	req->r_num_caps = 1;
>  	if (flags & (O_CREAT|O_TRUNC))
>  		parent_inode = ceph_get_dentry_parent_inode(file->f_dentry);
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 602ccd8..5daf7f8 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -12,6 +12,7 @@
>  
>  #include "super.h"
>  #include "mds_client.h"
> +#include "cache.h"
>  #include <linux/ceph/decode.h>
>  
>  /*
> @@ -31,6 +32,7 @@ static const struct inode_operations ceph_symlink_iops;
>  static void ceph_invalidate_work(struct work_struct *work);
>  static void ceph_writeback_work(struct work_struct *work);
>  static void ceph_vmtruncate_work(struct work_struct *work);
> +static void ceph_revalidate_work(struct work_struct *work);

This can go in cache.h, without the 'static'...

>  
>  /*
>   * find or create an inode, given the ceph ino number
> @@ -386,6 +388,13 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
>  
>  	INIT_WORK(&ci->i_vmtruncate_work, ceph_vmtruncate_work);
>  
> +#ifdef CONFIG_CEPH_FSCACHE
> +	ci->fscache = NULL;
> +	/* The first load is verifed cookie open time */
> +	ci->i_fscache_gen = 1;
> +	INIT_WORK(&ci->i_revalidate_work, ceph_revalidate_work);
> +#endif
> +
>  	return &ci->vfs_inode;
>  }
>  
> @@ -405,6 +414,8 @@ void ceph_destroy_inode(struct inode *inode)
>  
>  	dout("destroy_inode %p ino %llx.%llx\n", inode, ceph_vinop(inode));
>  
> +	ceph_fscache_unregister_inode_cookie(ci);
> +
>  	ceph_queue_caps_release(inode);
>  
>  	/*
> @@ -439,7 +450,6 @@ void ceph_destroy_inode(struct inode *inode)
>  	call_rcu(&inode->i_rcu, ceph_i_callback);
>  }
>  
> -
>  /*
>   * Helpers to fill in size, ctime, mtime, and atime.  We have to be
>   * careful because either the client or MDS may have more up to date
> @@ -491,6 +501,10 @@ int ceph_fill_file_size(struct inode *inode, int issued,
>  		     truncate_size);
>  		ci->i_truncate_size = truncate_size;
>  	}
> +
> +	if (queue_trunc)
> +		fscache_invalidate(ci->fscache);
> +
>  	return queue_trunc;
>  }
>  
> @@ -1079,7 +1093,7 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req,
>  			 * complete.
>  			 */
>  			ceph_set_dentry_offset(req->r_old_dentry);
> -			dout("dn %p gets new offset %lld\n", req->r_old_dentry, 
> +			dout("dn %p gets new offset %lld\n", req->r_old_dentry,
>  			     ceph_dentry(req->r_old_dentry)->offset);
>  
>  			dn = req->r_old_dentry;  /* use old_dentry */
> @@ -1494,6 +1508,7 @@ void ceph_queue_vmtruncate(struct inode *inode)
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  
>  	ihold(inode);
> +
>  	if (queue_work(ceph_sb_to_client(inode->i_sb)->trunc_wq,
>  		       &ci->i_vmtruncate_work)) {
>  		dout("ceph_queue_vmtruncate %p\n", inode);
> @@ -1565,6 +1580,53 @@ retry:
>  	wake_up_all(&ci->i_cap_wq);
>  }
>  
> +static void ceph_revalidate_work(struct work_struct *work)
> +{
> +	int issued;
> +	u32 orig_gen;
> +	struct ceph_inode_info *ci = container_of(work, struct ceph_inode_info,
> +						  i_revalidate_work);
> +	struct inode *inode = &ci->vfs_inode;
> +
> +	spin_lock(&ci->i_ceph_lock);
> +	issued = __ceph_caps_issued(ci, NULL);
> +	orig_gen = ci->i_rdcache_gen;
> +	spin_unlock(&ci->i_ceph_lock);
> +
> +	if (!(issued & CEPH_CAP_FILE_CACHE)) {
> +		dout("revalidate_work lost cache before validation %p\n",
> +		     inode);
> +		goto out;
> +	}
> +
> +	if (!fscache_check_consistency(ci->fscache))
> +		fscache_invalidate(ci->fscache);
> +
> +	spin_lock(&ci->i_ceph_lock);
> +	/* Update the new valid generation (backwards sanity check too) */
> +	if (orig_gen > ci->i_fscache_gen) {
> +		ci->i_fscache_gen = orig_gen;
> +	}
> +	spin_unlock(&ci->i_ceph_lock);
> +
> +out:
> +	iput(&ci->vfs_inode);
> +}
> +
> +void ceph_queue_revalidate(struct inode *inode)
> +{
> +	struct ceph_inode_info *ci = ceph_inode(inode);
> +
> +	ihold(inode);
> +
> +	if (queue_work(ceph_sb_to_client(inode->i_sb)->revalidate_wq,
> +		       &ci->i_revalidate_work)) {
> +		dout("ceph_queue_revalidate %p\n", inode);
> +	} else {
> +		dout("ceph_queue_revalidate %p failed\n)", inode);
> +		iput(inode);
> +	}
> +}

Move these to cache.c, and put a no-op ceph_queue_revalidate() in 
cache.h's #else block...

>  
>  /*
>   * symlinks
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 6627b26..a56baab 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -17,6 +17,7 @@
>  
>  #include "super.h"
>  #include "mds_client.h"
> +#include "cache.h"
>  
>  #include <linux/ceph/ceph_features.h>
>  #include <linux/ceph/decode.h>
> @@ -142,6 +143,8 @@ enum {
>  	Opt_nodcache,
>  	Opt_ino32,
>  	Opt_noino32,
> +	Opt_fscache,
> +	Opt_nofscache
>  };
>  
>  static match_table_t fsopt_tokens = {
> @@ -167,6 +170,8 @@ static match_table_t fsopt_tokens = {
>  	{Opt_nodcache, "nodcache"},
>  	{Opt_ino32, "ino32"},
>  	{Opt_noino32, "noino32"},
> +	{Opt_fscache, "fsc"},
> +	{Opt_nofscache, "nofsc"},
>  	{-1, NULL}
>  };
>  
> @@ -260,6 +265,12 @@ static int parse_fsopt_token(char *c, void *private)
>  	case Opt_noino32:
>  		fsopt->flags &= ~CEPH_MOUNT_OPT_INO32;
>  		break;
> +	case Opt_fscache:
> +		fsopt->flags |= CEPH_MOUNT_OPT_FSCACHE;
> +		break;
> +	case Opt_nofscache:
> +		fsopt->flags &= ~CEPH_MOUNT_OPT_FSCACHE;
> +		break;
>  	default:
>  		BUG_ON(token);
>  	}
> @@ -422,6 +433,10 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
>  		seq_puts(m, ",dcache");
>  	else
>  		seq_puts(m, ",nodcache");
> +	if (fsopt->flags & CEPH_MOUNT_OPT_FSCACHE)
> +		seq_puts(m, ",fsc");
> +	else
> +		seq_puts(m, ",nofsc");
>  
>  	if (fsopt->wsize)
>  		seq_printf(m, ",wsize=%d", fsopt->wsize);
> @@ -530,11 +545,24 @@ static struct ceph_fs_client *create_fs_client(struct ceph_mount_options *fsopt,
>  	if (!fsc->wb_pagevec_pool)
>  		goto fail_trunc_wq;
>  
> +#ifdef CONFIG_CEPH_FSCACHE
> +	if ((fsopt->flags & CEPH_MOUNT_OPT_FSCACHE))
> +		ceph_fscache_register_fsid_cookie(fsc);
> +
> +	fsc->revalidate_wq = alloc_workqueue("ceph-revalidate", 0, 1);
> +	if (fsc->revalidate_wq == NULL)
> +		goto fail_fscache;
> +#endif
> +

Since this is non-trivial, I'd make ceph_fscache_init() and _shutdown() 
functions (in cache.[ch]) so the #ifdef's go away here, too.

>  	/* caps */
>  	fsc->min_caps = fsopt->max_readdir;
>  
>  	return fsc;
>  
> +#ifdef CONFIG_CEPH_FSCACHE
> +fail_fscache:
> +	ceph_fscache_unregister_fsid_cookie(fsc);
> +#endif
>  fail_trunc_wq:
>  	destroy_workqueue(fsc->trunc_wq);
>  fail_pg_inv_wq:
> @@ -554,6 +582,10 @@ static void destroy_fs_client(struct ceph_fs_client *fsc)
>  {
>  	dout("destroy_fs_client %p\n", fsc);
>  
> +#ifdef CONFIG_CEPH_FSCACHE
> +	ceph_fscache_unregister_fsid_cookie(fsc);
> +#endif
> +

and here

>  	destroy_workqueue(fsc->wb_wq);
>  	destroy_workqueue(fsc->pg_inv_wq);
>  	destroy_workqueue(fsc->trunc_wq);
> @@ -588,6 +620,8 @@ static void ceph_inode_init_once(void *foo)
>  
>  static int __init init_caches(void)
>  {
> +	int error = -ENOMEM;
> +
>  	ceph_inode_cachep = kmem_cache_create("ceph_inode_info",
>  				      sizeof(struct ceph_inode_info),
>  				      __alignof__(struct ceph_inode_info),
> @@ -611,15 +645,19 @@ static int __init init_caches(void)
>  	if (ceph_file_cachep == NULL)
>  		goto bad_file;
>  
> -	return 0;
> +#ifdef CONFIG_CEPH_FSCACHE
> +	if ((error = fscache_register_netfs(&ceph_cache_netfs)))
> +		goto bad_file;
> +#endif

ceph_fscache_register() (?) in cache.h?

>  
> +	return 0;
>  bad_file:
>  	kmem_cache_destroy(ceph_dentry_cachep);
>  bad_dentry:
>  	kmem_cache_destroy(ceph_cap_cachep);
>  bad_cap:
>  	kmem_cache_destroy(ceph_inode_cachep);
> -	return -ENOMEM;
> +	return error;
>  }
>  
>  static void destroy_caches(void)
> @@ -629,10 +667,15 @@ static void destroy_caches(void)
>  	 * destroy cache.
>  	 */
>  	rcu_barrier();
> +
>  	kmem_cache_destroy(ceph_inode_cachep);
>  	kmem_cache_destroy(ceph_cap_cachep);
>  	kmem_cache_destroy(ceph_dentry_cachep);
>  	kmem_cache_destroy(ceph_file_cachep);
> +
> +#ifdef CONFIG_CEPH_FSCACHE
> +	fscache_unregister_netfs(&ceph_cache_netfs);
> +#endif

and ceph_fscache_unregister()

We'd also like to make sure this gets tested by our qa suite.  That 
probably means setting up the fscache stuff on the clients in the 
teuthology.git/teuthology/tests/kclient.py task.  I'd settle for a
quick run-down of what steps we should take to do that during 
mount/umount, though.

Thanks, Milosz!
sage


>  }
>  
>  
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index f1e4e47..72eac24 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -16,6 +16,10 @@
>  
>  #include <linux/ceph/libceph.h>
>  
> +#ifdef CONFIG_CEPH_FSCACHE
> +#include <linux/fscache.h>
> +#endif
> +
>  /* f_type in struct statfs */
>  #define CEPH_SUPER_MAGIC 0x00c36400
>  
> @@ -29,6 +33,7 @@
>  #define CEPH_MOUNT_OPT_NOASYNCREADDIR  (1<<7) /* no dcache readdir */
>  #define CEPH_MOUNT_OPT_INO32           (1<<8) /* 32 bit inos */
>  #define CEPH_MOUNT_OPT_DCACHE          (1<<9) /* use dcache for readdir etc */
> +#define CEPH_MOUNT_OPT_FSCACHE         (1<<10) /* use fscache */
>  
>  #define CEPH_MOUNT_OPT_DEFAULT    (CEPH_MOUNT_OPT_RBYTES)
>  
> @@ -90,6 +95,11 @@ struct ceph_fs_client {
>  	struct dentry *debugfs_bdi;
>  	struct dentry *debugfs_mdsc, *debugfs_mdsmap;
>  #endif
> +
> +#ifdef CONFIG_CEPH_FSCACHE
> +	struct fscache_cookie *fscache;
> +	struct workqueue_struct *revalidate_wq;
> +#endif
>  };
>  
>  
> @@ -320,6 +330,12 @@ struct ceph_inode_info {
>  
>  	struct work_struct i_vmtruncate_work;
>  
> +#ifdef CONFIG_CEPH_FSCACHE
> +	struct fscache_cookie *fscache;
> +	u32 i_fscache_gen; /* sequence, for delayed fscache validate */
> +	struct work_struct i_revalidate_work;
> +#endif
> +
>  	struct inode vfs_inode; /* at end */
>  };
>  
> @@ -700,6 +716,7 @@ extern void ceph_queue_vmtruncate(struct inode *inode);
>  
>  extern void ceph_queue_invalidate(struct inode *inode);
>  extern void ceph_queue_writeback(struct inode *inode);
> +extern void ceph_queue_revalidate(struct inode *inode);
>  
>  extern int ceph_do_getattr(struct inode *inode, int mask);
>  extern int ceph_permission(struct inode *inode, int mask);
> -- 
> 1.8.1.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
