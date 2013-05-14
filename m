Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203Ab3ENQiD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 12:38:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932105Ab3ENQh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 12:37:59 -0400
From: Lukas Czerner <lczerner@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
        hughd@google.com, lczerner@redhat.com, ceph-devel@vger.kernel.org
Subject: [PATCH v4 07/20] ceph: use ->invalidatepage() length argument
Date: Tue, 14 May 2013 18:37:21 +0200
Message-Id: <1368549454-8930-8-git-send-email-lczerner@redhat.com>
In-Reply-To: <1368549454-8930-1-git-send-email-lczerner@redhat.com>
References: <1368549454-8930-1-git-send-email-lczerner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

->invalidatepage() aop now accepts range to invalidate so we can make
use of it in ceph_invalidatepage().

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Acked-by: Sage Weil <sage@inktank.com>
Cc: ceph-devel@vger.kernel.org
---
 fs/ceph/addr.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 168a35a..d953afd 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -164,20 +164,20 @@ static void ceph_invalidatepage(struct page *page, unsigned int offset,
 	if (!PageDirty(page))
 		pr_err("%p invalidatepage %p page not dirty\n", inode, page);
 
-	if (offset == 0)
+	if (offset == 0 && length == PAGE_CACHE_SIZE)
 		ClearPageChecked(page);
 
 	ci = ceph_inode(inode);
-	if (offset == 0) {
-		dout("%p invalidatepage %p idx %lu full dirty page %u\n",
-		     inode, page, page->index, offset);
+	if (offset == 0 && length == PAGE_CACHE_SIZE) {
+		dout("%p invalidatepage %p idx %lu full dirty page\n",
+		     inode, page, page->index);
 		ceph_put_wrbuffer_cap_refs(ci, 1, snapc);
 		ceph_put_snap_context(snapc);
 		page->private = 0;
 		ClearPagePrivate(page);
 	} else {
-		dout("%p invalidatepage %p idx %lu partial dirty page\n",
-		     inode, page, page->index);
+		dout("%p invalidatepage %p idx %lu partial dirty page %u(%u)\n",
+		     inode, page, page->index, offset, length);
 	}
 }
 
-- 
1.7.7.6

