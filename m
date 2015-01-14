Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbbANH2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:28:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57945 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbbANH2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:28:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Henry Cai <henryplusplus@gmail.com>, NeilBrown <neilb@suse.de>
Subject: [PATCH 3.18 083/150] md/raid5: fetch_block must fetch all the blocks handle_stripe_dirtying wants.
Date: Tue, 13 Jan 2015 23:22:34 -0800
Message-Id: <20150114072059.609658645@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 108cef3aa41669610e1836fe638812dd067d72de upstream.

It is critical that fetch_block() and handle_stripe_dirtying()
are consistent in their analysis of what needs to be loaded.
Otherwise raid5 can wait forever for a block that won't be loaded.

Currently when writing to a RAID5 that is resyncing, to a location
beyond the resync offset, handle_stripe_dirtying chooses a
reconstruct-write cycle, but fetch_block() assumes a
read-modify-write, and a lockup can happen.

So treat that case just like RAID6, just as we do in
handle_stripe_dirtying.  RAID6 always does reconstruct-write.

This bug was introduced when the behaviour of handle_stripe_dirtying
was changed in 3.7, so the patch is suitable for any kernel since,
though it will need careful merging for some versions.

Fixes: a7854487cd7128a30a7f4f5259de9f67d5efb95f
Reported-by: Henry Cai <henryplusplus@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid5.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2917,8 +2917,11 @@ static int fetch_block(struct stripe_hea
 	     (sh->raid_conf->level <= 5 && s->failed && fdev[0]->towrite &&
 	      (!test_bit(R5_Insync, &dev->flags) || test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) &&
 	      !test_bit(R5_OVERWRITE, &fdev[0]->flags)) ||
-	     (sh->raid_conf->level == 6 && s->failed && s->to_write &&
-	      s->to_write - s->non_overwrite < sh->raid_conf->raid_disks - 2 &&
+	     ((sh->raid_conf->level == 6 ||
+	       sh->sector >= sh->raid_conf->mddev->recovery_cp)
+	      && s->failed && s->to_write &&
+	      (s->to_write - s->non_overwrite <
+	       sh->raid_conf->raid_disks - sh->raid_conf->max_degraded) &&
 	      (!test_bit(R5_Insync, &dev->flags) || test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))))) {
 		/* we would like to get this block, possibly by computing it,
 		 * otherwise read it if the backing disk is insync


