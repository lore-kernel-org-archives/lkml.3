Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbbALS5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:57:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58127 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006AbbALSaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:09 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 147/216] md/bitmap: always wait for writes on unplug.
Date: Mon, 12 Jan 2015 18:28:45 +0000
Message-Id: <1421087394-2712-35-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 4b5060ddae2b03c5387321fafc089d242225697a upstream.

If two threads call bitmap_unplug at the same time, then
one might schedule all the writes, and the other might
decide that it doesn't need to wait.  But really it does.

It rarely hurts to wait when it isn't absolutely necessary,
and the current code doesn't really focus on 'absolutely necessary'
anyway.  So just wait always.

This can potentially lead to data corruption if a crash happens
at an awkward time and data was written before the bitmap was
updated.  It is very unlikely, but this should go to -stable
just to be safe.  Appropriate for any -stable.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/bitmap.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 67f8b31e2054..da3604e73e8a 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -879,7 +879,6 @@ void bitmap_unplug(struct bitmap *bitmap)
 {
 	unsigned long i;
 	int dirty, need_write;
-	int wait = 0;
 
 	if (!bitmap || !bitmap->storage.filemap ||
 	    test_bit(BITMAP_STALE, &bitmap->flags))
@@ -897,16 +896,13 @@ void bitmap_unplug(struct bitmap *bitmap)
 			clear_page_attr(bitmap, i, BITMAP_PAGE_PENDING);
 			write_page(bitmap, bitmap->storage.filemap[i], 0);
 		}
-		if (dirty)
-			wait = 1;
-	}
-	if (wait) { /* if any writes were performed, we need to wait on them */
-		if (bitmap->storage.file)
-			wait_event(bitmap->write_wait,
-				   atomic_read(&bitmap->pending_writes)==0);
-		else
-			md_super_wait(bitmap->mddev);
 	}
+	if (bitmap->storage.file)
+		wait_event(bitmap->write_wait,
+			   atomic_read(&bitmap->pending_writes)==0);
+	else
+		md_super_wait(bitmap->mddev);
+
 	if (test_bit(BITMAP_WRITE_ERROR, &bitmap->flags))
 		bitmap_file_kick(bitmap);
 }
-- 
2.1.4

