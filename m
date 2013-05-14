Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254Ab3ENQiH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 12:38:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932105Ab3ENQiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 12:38:04 -0400
From: Lukas Czerner <lczerner@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
        hughd@google.com, lczerner@redhat.com, reiserfs-devel@vger.kernel.org
Subject: [PATCH v4 09/20] reiserfs: use ->invalidatepage() length argument
Date: Tue, 14 May 2013 18:37:23 +0200
Message-Id: <1368549454-8930-10-git-send-email-lczerner@redhat.com>
In-Reply-To: <1368549454-8930-1-git-send-email-lczerner@redhat.com>
References: <1368549454-8930-1-git-send-email-lczerner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

->invalidatepage() aop now accepts range to invalidate so we can make
use of it in reiserfs_invalidatepage()

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Cc: reiserfs-devel@vger.kernel.org
---
 fs/reiserfs/inode.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 808e02e..e963164 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -2975,11 +2975,13 @@ static void reiserfs_invalidatepage(struct page *page, unsigned int offset,
 	struct buffer_head *head, *bh, *next;
 	struct inode *inode = page->mapping->host;
 	unsigned int curr_off = 0;
+	unsigned int stop = offset + length;
+	int partial_page = (offset || length < PAGE_CACHE_SIZE);
 	int ret = 1;
 
 	BUG_ON(!PageLocked(page));
 
-	if (offset == 0)
+	if (!partial_page)
 		ClearPageChecked(page);
 
 	if (!page_has_buffers(page))
@@ -2991,6 +2993,9 @@ static void reiserfs_invalidatepage(struct page *page, unsigned int offset,
 		unsigned int next_off = curr_off + bh->b_size;
 		next = bh->b_this_page;
 
+		if (next_off > stop)
+			goto out;
+
 		/*
 		 * is this block fully invalidated?
 		 */
@@ -3009,7 +3014,7 @@ static void reiserfs_invalidatepage(struct page *page, unsigned int offset,
 	 * The get_block cached value has been unconditionally invalidated,
 	 * so real IO is not possible anymore.
 	 */
-	if (!offset && ret) {
+	if (!partial_page && ret) {
 		ret = try_to_release_page(page, 0);
 		/* maybe should BUG_ON(!ret); - neilb */
 	}
-- 
1.7.7.6

