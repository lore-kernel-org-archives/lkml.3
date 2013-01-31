Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab3AaVue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 16:50:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57859 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755266Ab3AaVua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 16:50:30 -0500
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Jan Kara <jack@suse.cz>
Subject: [PATCH 3/6] fs: Provide function to take mapping lock in buffered write path
Date: Thu, 31 Jan 2013 22:49:51 +0100
Message-Id: <1359668994-13433-4-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1359668994-13433-1-git-send-email-jack@suse.cz>
References: <1359668994-13433-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a flag to grab_cache_page_write_begin() which makes the function grab
mapping range lock while creating the page in page cache. Callers that don't
need special lock ordering for the mapping range lock (e.g. xfs) can use
this flag.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/fs.h |    2 ++
 mm/filemap.c       |    7 +++++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2027d25..1e0a1e4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -281,6 +281,8 @@ enum positive_aop_returns {
 #define AOP_FLAG_NOFS			0x0004 /* used by filesystem to direct
 						* helper code (eg buffer layer)
 						* to clear GFP_FS from alloc */
+#define AOP_FLAG_LOCK_MAPPING		0x0008 /* Lock mapping range where
+						* page is create */
 
 /*
  * oh the beauties of C type declarations.
diff --git a/mm/filemap.c b/mm/filemap.c
index 4826cb4..f4a9e9a 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2266,6 +2266,7 @@ struct page *grab_cache_page_write_begin(struct address_space *mapping,
 	gfp_t gfp_mask;
 	struct page *page;
 	gfp_t gfp_notmask = 0;
+	struct range_lock mapping_lock;
 
 	gfp_mask = mapping_gfp_mask(mapping);
 	if (mapping_cap_account_dirty(mapping))
@@ -2280,8 +2281,14 @@ repeat:
 	page = __page_cache_alloc(gfp_mask & ~gfp_notmask);
 	if (!page)
 		return NULL;
+	if (flags & AOP_FLAG_LOCK_MAPPING) {
+		range_lock_init(&mapping_lock, index, index);
+		range_lock(&mapping->mapping_lock, &mapping_lock);
+	}
 	status = add_to_page_cache_lru(page, mapping, index,
 						GFP_KERNEL & ~gfp_notmask);
+	if (flags & AOP_FLAG_LOCK_MAPPING)
+		range_unlock(&mapping->mapping_lock, &mapping_lock);
 	if (unlikely(status)) {
 		page_cache_release(page);
 		if (status == -EEXIST)
-- 
1.7.1

