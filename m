Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261Ab3ERDB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:01:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32671 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758781Ab3ERDAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:33 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=25rujEImLSIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=qsCZD99ltQwA:10 a=VwQbUJbxAAAA:8 a=vpVRfoo1AAAA:8 a=Og3cMCZlAAAA:8 a=aCPqOQJ_S1qBLZ7JjQ4A:9 a=LI9Vle30uBYA:10 a=5KVauyKsRKMA:10 a=0yVQzcu7H6MA:10 a=0kPLrQdw3YYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021652.241642429@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Shaohua Li <shli@fusionio.com>, NeilBrown <neilb@suse.de>
Subject: [ 065/136 ] MD: ignore discard request for hard disks of hybid raid1/raid10
 array
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0065-MD-ignore-discard-request-for-hard-disks-of-hybid-ra.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Shaohua Li <shli@kernel.org>

[ Upstream commit 32f9f570d04461a41bdcd5c1d93b41ebc5ce182a ]

In SSD/hard disk hybid storage, discard request should be ignored for hard
disk. We used to be doing this way, but the unplug path forgets it.

This is suitable for stable tree since v3.6.

Cc: stable@vger.kernel.org
Reported-and-tested-by: Markus <M4rkusXXL@web.de>
Signed-off-by: Shaohua Li <shli@fusionio.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/md/raid1.c  |    7 ++++++-
 drivers/md/raid10.c |    6 ++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 7077dcf..36c6003 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -976,7 +976,12 @@ static void raid1_unplug(struct blk_plug_cb *cb, bool from_schedule)
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
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index c52d893..bec9db8 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -912,6 +912,12 @@ static void flush_pending_writes(struct r10conf *conf)
 			struct bio *next = bio->bi_next;
 			bio->bi_next = NULL;
 			generic_make_request(bio);
+			if (unlikely((bio->bi_rw & REQ_DISCARD) &&
+				     !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
+				/* Just ignore it */
+				bio_endio(bio, 0);
+			else
+				generic_make_request(bio);
 			bio = next;
 		}
 	} else
-- 
1.7.10.4


