Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbaIOT30 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:29:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54952 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbaIOT3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:29:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        NeilBrown <neilb@suse.de>
Subject: [PATCH 3.16 126/158] md/raid5: avoid livelock caused by non-aligned writes.
Date: Mon, 15 Sep 2014 12:26:05 -0700
Message-Id: <20140915192546.665958378@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit a40687ff73a5b14909d6aa522f7d778b158911c5 upstream.

If a stripe in a raid6 array received a write to each data block while
the array is degraded, and if any of these writes to a missing device
are not page-aligned, then a live-lock happens.

In this case the P and Q blocks need to be read so that the part of
the missing block which is *not* being updated by the write can be
constructed.  Due to a logic error, these blocks are not loaded, so
the update cannot proceed and the stripe is 'handled' repeatedly in an
infinite loop.

This bug is unlikely as most writes are page aligned.  However as it
can lead to a livelock it is suitable for -stable.  It was introduced
in 3.16.

Fixed: 67f455486d2ea20b2d94d6adf5b9b783d079e321
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2922,7 +2922,7 @@ static int fetch_block(struct stripe_hea
 	      (!test_bit(R5_Insync, &dev->flags) || test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) &&
 	      !test_bit(R5_OVERWRITE, &fdev[0]->flags)) ||
 	     (sh->raid_conf->level == 6 && s->failed && s->to_write &&
-	      s->to_write < sh->raid_conf->raid_disks - 2 &&
+	      s->to_write - s->non_overwrite < sh->raid_conf->raid_disks - 2 &&
 	      (!test_bit(R5_Insync, &dev->flags) || test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))))) {
 		/* we would like to get this block, possibly by computing it,
 		 * otherwise read it if the backing disk is insync


