Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab3ISQLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 12:11:41 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:44257 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab3ISQLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 12:11:39 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: mpatlasov@parallels.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: [PATCH 3/3] fuse: writepage: skip already in flight
Date: Thu, 19 Sep 2013 18:11:56 +0200
Message-Id: <1379607116-13382-4-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1379607116-13382-1-git-send-email-miklos@szeredi.hu>
References: <1379607116-13382-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

If ->writepage() tries to write back a page whose copy is still in flight,
then just skip by calling redirty_page_for_writepage().

This is OK, since now ->writepage() should never be called for data
integrity sync.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/fuse/file.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index f8ff019..135360e 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1591,6 +1591,18 @@ static int fuse_writepage(struct page *page, struct writeback_control *wbc)
 {
 	int err;
 
+	if (fuse_page_is_writeback(page->mapping->host, page->index)) {
+		/*
+		 * ->writepages() should be called for sync() and friends.  We
+		 * should only get here on direct reclaim and then we are
+		 * allowed to skip a page which is already in flight
+		 */
+		WARN_ON(wbc->sync_mode == WB_SYNC_ALL);
+
+		redirty_page_for_writepage(wbc, page);
+		return 0;
+	}
+
 	err = fuse_writepage_locked(page);
 	unlock_page(page);
 
-- 
1.8.1.4

