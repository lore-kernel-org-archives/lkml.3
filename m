Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714AbbAGBw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 20:52:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46417 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932566AbbAGBwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 20:52:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        NeilBrown <neilb@suse.de>
Subject: [PATCH 3.10 06/38] md/bitmap: always wait for writes on unplug.
Date: Tue,  6 Jan 2015 17:50:18 -0800
Message-Id: <20150107014953.489780441@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107014952.440109372@linuxfoundation.org>
References: <20150107014952.440109372@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bitmap.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -883,7 +883,6 @@ void bitmap_unplug(struct bitmap *bitmap
 {
 	unsigned long i;
 	int dirty, need_write;
-	int wait = 0;
 
 	if (!bitmap || !bitmap->storage.filemap ||
 	    test_bit(BITMAP_STALE, &bitmap->flags))
@@ -901,16 +900,13 @@ void bitmap_unplug(struct bitmap *bitmap
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


