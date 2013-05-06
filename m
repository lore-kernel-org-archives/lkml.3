Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086Ab3EFUrA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 16:47:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59333 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758018Ab3EFUq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:46:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Shaohua Li <shli@fusionio.com>, NeilBrown <neilb@suse.de>
Subject: [ 088/115] MD: ignore discard request for hard disks of hybid raid1/raid10 array
Date: Mon,  6 May 2013 13:45:24 -0700
Message-Id: <20130506203104.621935552@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506203055.537199268@linuxfoundation.org>
References: <20130506203055.537199268@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shaohua Li <shli@kernel.org>

commit 32f9f570d04461a41bdcd5c1d93b41ebc5ce182a upstream.

In SSD/hard disk hybid storage, discard request should be ignored for hard
disk. We used to be doing this way, but the unplug path forgets it.

This is suitable for stable tree since v3.6.

Reported-and-tested-by: Markus <M4rkusXXL@web.de>
Signed-off-by: Shaohua Li <shli@fusionio.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid1.c  |    7 ++++++-
 drivers/md/raid10.c |    7 ++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -981,7 +981,12 @@ static void raid1_unplug(struct blk_plug
 	while (bio) { /* submit pending writes */
 		struct bio *next = bio->bi_next;
 		bio->bi_next = NULL;
-		generic_make_request(bio);
+		if (unlikely((bio->bi_rw & REQ_DISCARD) &&
+		    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
+			/* Just ignore it */
+			bio_endio(bio, 0);
+		else
+			generic_make_request(bio);
 		bio = next;
 	}
 	kfree(plug);
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1133,7 +1133,12 @@ static void raid10_unplug(struct blk_plu
 	while (bio) { /* submit pending writes */
 		struct bio *next = bio->bi_next;
 		bio->bi_next = NULL;
-		generic_make_request(bio);
+		if (unlikely((bio->bi_rw & REQ_DISCARD) &&
+		    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
+			/* Just ignore it */
+			bio_endio(bio, 0);
+		else
+			generic_make_request(bio);
 		bio = next;
 	}
 	kfree(plug);


