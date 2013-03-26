Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab3CZXcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:32:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52613 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958Ab3CZWoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:44:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        majianpeng <majianpeng@gmail.com>, NeilBrown <neilb@suse.de>
Subject: [ 76/98] md/raid5: schedule_construction should abort if nothing to do.
Date: Tue, 26 Mar 2013 15:43:05 -0700
Message-Id: <20130326224250.363298029@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit ce7d363aaf1e28be8406a2976220944ca487e8ca upstream.

Since commit 1ed850f356a0a422013846b5291acff08815008b
    md/raid5: make sure to_read and to_write never go negative.

It has been possible for handle_stripe_dirtying to be called
when there isn't actually any work to do.
It then calls schedule_reconstruction() which will set R5_LOCKED
on the parity block(s) even when nothing else is happening.
This then causes problems in do_release_stripe().

So add checks to schedule_reconstruction() so that if it doesn't
find anything to do, it just aborts.

This bug was introduced in v3.7, so the patch is suitable
for -stable kernels since then.

Reported-by: majianpeng <majianpeng@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid5.c |   38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2319,17 +2319,6 @@ schedule_reconstruction(struct stripe_he
 	int level = conf->level;
 
 	if (rcw) {
-		/* if we are not expanding this is a proper write request, and
-		 * there will be bios with new data to be drained into the
-		 * stripe cache
-		 */
-		if (!expand) {
-			sh->reconstruct_state = reconstruct_state_drain_run;
-			set_bit(STRIPE_OP_BIODRAIN, &s->ops_request);
-		} else
-			sh->reconstruct_state = reconstruct_state_run;
-
-		set_bit(STRIPE_OP_RECONSTRUCT, &s->ops_request);
 
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
@@ -2342,6 +2331,21 @@ schedule_reconstruction(struct stripe_he
 				s->locked++;
 			}
 		}
+		/* if we are not expanding this is a proper write request, and
+		 * there will be bios with new data to be drained into the
+		 * stripe cache
+		 */
+		if (!expand) {
+			if (!s->locked)
+				/* False alarm, nothing to do */
+				return;
+			sh->reconstruct_state = reconstruct_state_drain_run;
+			set_bit(STRIPE_OP_BIODRAIN, &s->ops_request);
+		} else
+			sh->reconstruct_state = reconstruct_state_run;
+
+		set_bit(STRIPE_OP_RECONSTRUCT, &s->ops_request);
+
 		if (s->locked + conf->max_degraded == disks)
 			if (!test_and_set_bit(STRIPE_FULL_WRITE, &sh->state))
 				atomic_inc(&conf->pending_full_writes);
@@ -2350,11 +2354,6 @@ schedule_reconstruction(struct stripe_he
 		BUG_ON(!(test_bit(R5_UPTODATE, &sh->dev[pd_idx].flags) ||
 			test_bit(R5_Wantcompute, &sh->dev[pd_idx].flags)));
 
-		sh->reconstruct_state = reconstruct_state_prexor_drain_run;
-		set_bit(STRIPE_OP_PREXOR, &s->ops_request);
-		set_bit(STRIPE_OP_BIODRAIN, &s->ops_request);
-		set_bit(STRIPE_OP_RECONSTRUCT, &s->ops_request);
-
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
 			if (i == pd_idx)
@@ -2369,6 +2368,13 @@ schedule_reconstruction(struct stripe_he
 				s->locked++;
 			}
 		}
+		if (!s->locked)
+			/* False alarm - nothing to do */
+			return;
+		sh->reconstruct_state = reconstruct_state_prexor_drain_run;
+		set_bit(STRIPE_OP_PREXOR, &s->ops_request);
+		set_bit(STRIPE_OP_BIODRAIN, &s->ops_request);
+		set_bit(STRIPE_OP_RECONSTRUCT, &s->ops_request);
 	}
 
 	/* keep the parity disk(s) locked while asynchronous operations


