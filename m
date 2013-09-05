Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab3IEWXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 18:23:09 -0400
Received: from mail-qe0-f46.google.com ([209.85.128.46]:60369 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804Ab3IEWXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 18:23:05 -0400
Date: Thu, 5 Sep 2013 18:23:04 -0400
From: Milosz Tanski <milosz@adfin.com>
To: ceph-devel@vger.kernel.org
Cc: sage@inktank.com, zheng.z.yan@intel.com, dhowells@redhat.com,
        jiayisuse@gmail.com, linux-cachefs@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] ceph: page still marked private_2
Message-ID: <954accf7905f4bf549a0d6a2b75e206f639f7cd9.1378418255.git.milosz@adfin.com>
References: <cover.1378418255.git.milosz@adfin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1378418255.git.milosz@adfin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous patch that allowed us to cleanup most of the issues with pages marked
as private_2 when calling ceph_readpages. However, there seams to be a case in
the error case clean up in start read that still trigers this from time to
time. I've only seen this one a couple times.

BUG: Bad page state in process petabucket  pfn:335b82
page:ffffea000cd6e080 count:0 mapcount:0 mapping:          (null) index:0x0
page flags: 0x200000000001000(private_2)
Call Trace:
 [<ffffffff81563442>] dump_stack+0x46/0x58
 [<ffffffff8112c7f7>] bad_page+0xc7/0x120
 [<ffffffff8112cd9e>] free_pages_prepare+0x10e/0x120
 [<ffffffff8112e580>] free_hot_cold_page+0x40/0x160
 [<ffffffff81132427>] __put_single_page+0x27/0x30
 [<ffffffff81132d95>] put_page+0x25/0x40
 [<ffffffffa02cb409>] ceph_readpages+0x2e9/0x6f0 [ceph]
 [<ffffffff811313cf>] __do_page_cache_readahead+0x1af/0x260

Signed-off-by: Milosz Tanski <milosz@adfin.com>
Signed-off-by: Sage Weil <sage@inktank.com>
---
 fs/ceph/addr.c  |    1 +
 fs/ceph/cache.h |   14 +++++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 1fda9cf..6df8bd4 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -336,6 +336,7 @@ static int start_read(struct inode *inode, struct list_head *page_list, int max)
 		     page->index);
 		if (add_to_page_cache_lru(page, &inode->i_data, page->index,
 					  GFP_NOFS)) {
+			ceph_fscache_uncache_page(inode, page);
 			page_cache_release(page);
 			dout("start_read %p add_to_page_cache failed %p\n",
 			     inode, page);
diff --git a/fs/ceph/cache.h b/fs/ceph/cache.h
index fb326fd..bf48695 100644
--- a/fs/ceph/cache.h
+++ b/fs/ceph/cache.h
@@ -51,6 +51,13 @@ static inline void ceph_fscache_invalidate(struct inode *inode)
 	fscache_invalidate(ceph_inode(inode)->fscache);
 }
 
+static inline void ceph_fscache_uncache_page(struct inode *inode,
+					     struct page *page)
+{
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	return fscache_uncache_page(ci->fscache, page);
+}
+
 static inline int ceph_release_fscache_page(struct page *page, gfp_t gfp)
 {
 	struct inode* inode = page->mapping->host;
@@ -94,7 +101,8 @@ static inline void ceph_fscache_register_inode_cookie(struct ceph_fs_client* par
 {
 }
 
-static inline void ceph_fscache_unregister_inode_cookie(struct ceph_inode_info* ci)
+static inline void ceph_fscache_uncache_page(struct inode *inode,
+					     struct page *pages)
 {
 }
 
@@ -126,6 +134,10 @@ static inline void ceph_invalidate_fscache_page(struct inode *inode,
 {
 }
 
+static inline void ceph_fscache_unregister_inode_cookie(struct ceph_inode_info* ci)
+{
+}
+
 static inline int ceph_release_fscache_page(struct page *page, gfp_t gfp)
 {
 	return 1;
-- 
1.7.9.5

