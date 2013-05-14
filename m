Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757833Ab3ENQlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 12:41:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948Ab3ENQiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 12:38:05 -0400
From: Lukas Czerner <lczerner@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
        hughd@google.com, lczerner@redhat.com, cluster-devel@redhat.com
Subject: [PATCH v4 08/20] gfs2: use ->invalidatepage() length argument
Date: Tue, 14 May 2013 18:37:22 +0200
Message-Id: <1368549454-8930-9-git-send-email-lczerner@redhat.com>
In-Reply-To: <1368549454-8930-1-git-send-email-lczerner@redhat.com>
References: <1368549454-8930-1-git-send-email-lczerner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

->invalidatepage() aop now accepts range to invalidate so we can make
use of it in gfs2_invalidatepage().

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Acked-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: cluster-devel@redhat.com
---
 fs/gfs2/aops.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 37093ba..ea920bf 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -947,24 +947,29 @@ static void gfs2_invalidatepage(struct page *page, unsigned int offset,
 				unsigned int length)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(page->mapping->host);
+	unsigned int stop = offset + length;
+	int partial_page = (offset || length < PAGE_CACHE_SIZE);
 	struct buffer_head *bh, *head;
 	unsigned long pos = 0;
 
 	BUG_ON(!PageLocked(page));
-	if (offset == 0)
+	if (!partial_page)
 		ClearPageChecked(page);
 	if (!page_has_buffers(page))
 		goto out;
 
 	bh = head = page_buffers(page);
 	do {
+		if (pos + bh->b_size > stop)
+			return;
+
 		if (offset <= pos)
 			gfs2_discard(sdp, bh);
 		pos += bh->b_size;
 		bh = bh->b_this_page;
 	} while (bh != head);
 out:
-	if (offset == 0)
+	if (!partial_page)
 		try_to_release_page(page, 0);
 }
 
-- 
1.7.7.6

