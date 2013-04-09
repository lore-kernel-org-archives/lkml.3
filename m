Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936273Ab3DIJ2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:28:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964938Ab3DIJOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:14:52 -0400
From: Lukas Czerner <lczerner@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>,
        ceph-devel@vger.kernel.org
Subject: [PATCH v3 07/18] ceph: use ->invalidatepage() length argument
Date: Tue,  9 Apr 2013 11:14:16 +0200
Message-Id: <1365498867-27782-8-git-send-email-lczerner@redhat.com>
In-Reply-To: <1365498867-27782-1-git-send-email-lczerner@redhat.com>
References: <1365498867-27782-1-git-send-email-lczerner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

->invalidatepage() aop now accepts range to invalidate so we can make
use of it in ceph_invalidatepage().

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
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

