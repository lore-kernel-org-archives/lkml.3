Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab3IKFVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:21:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11316 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab3IKE53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:29 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=4zemMMdr6EQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=7msQEFwcS5IA:10 a=VwQbUJbxAAAA:8 a=Byx-y9mGAAAA:8 a=kU22j93PDO2Hjae0MjcA:9 a=xe3m-ifz_csA:10 a=0kPLrQdw3YYA:10 a=lSQsbIguPOwA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042908.959873051@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: qindehua <13691222965@163.com>, qindehua <qindehua@163.com>,
        NeilBrown <neilb@suse.de>
Subject: [100/251] md/raid5: fix interaction of replace and recovery.
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0100-md-raid5-fix-interaction-of-replace-and-recovery.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit f94c0b6658c7edea8bc19d13be321e3860a3fa54 ]

If a device in a RAID4/5/6 is being replaced while another is being
recovered, then the writes to the replacement device currently don't
happen, resulting in corruption when the replacement completes and the
new drive takes over.

This is because the replacement writes are only triggered when
's.replacing' is set and not when the similar 's.sync' is set (which
is the case during resync and recovery - it means all devices need to
be read).

So schedule those writes when s.replacing is set as well.

In this case we cannot use "STRIPE_INSYNC" to record that the
replacement has happened as that is needed for recording that any
parity calculation is complete.  So introduce STRIPE_REPLACED to
record if the replacement has happened.

For safety we should also check that STRIPE_COMPUTE_RUN is not set.
This has a similar effect to the "s.locked == 0" test.  The latter
ensure that now IO has been flagged but not started.  The former
checks if any parity calculation has been flagged by not started.
We must wait for both of these to complete before triggering the
'replace'.

Add a similar test to the subsequent check for "are we finished yet".
This possibly isn't needed (is subsumed in the STRIPE_INSYNC test),
but it makes it more obvious that the REPLACE will happen before we
think we are finished.

Finally if a NeedReplace device is not UPTODATE then that is an
error.  We really must trigger a warning.

This bug was introduced in commit 9a3e1101b827a59ac9036a672f5fa8d5279d0fe2
(md/raid5:  detect and handle replacements during recovery.)
which introduced replacement for raid5.
That was in 3.3-rc3, so any stable kernel since then would benefit
from this fix.

Cc: stable@vger.kernel.org (3.3+)
Reported-by: qindehua <13691222965@163.com>
Tested-by: qindehua <qindehua@163.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/md/raid5.c |   15 ++++++++++-----
 drivers/md/raid5.h |    1 +
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0689173..f94452d 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3396,6 +3396,7 @@ static void handle_stripe(struct stripe_head *sh)
 	if (test_and_clear_bit(STRIPE_SYNC_REQUESTED, &sh->state)) {
 		set_bit(STRIPE_SYNCING, &sh->state);
 		clear_bit(STRIPE_INSYNC, &sh->state);
+		clear_bit(STRIPE_REPLACED, &sh->state);
 	}
 	clear_bit(STRIPE_DELAYED, &sh->state);
 
@@ -3535,19 +3536,23 @@ static void handle_stripe(struct stripe_head *sh)
 			handle_parity_checks5(conf, sh, &s, disks);
 	}
 
-	if (s.replacing && s.locked == 0
-	    && !test_bit(STRIPE_INSYNC, &sh->state)) {
+	if ((s.replacing || s.syncing) && s.locked == 0
+	    && !test_bit(STRIPE_COMPUTE_RUN, &sh->state)
+	    && !test_bit(STRIPE_REPLACED, &sh->state)) {
 		/* Write out to replacement devices where possible */
 		for (i = 0; i < conf->raid_disks; i++)
-			if (test_bit(R5_UPTODATE, &sh->dev[i].flags) &&
-			    test_bit(R5_NeedReplace, &sh->dev[i].flags)) {
+			if (test_bit(R5_NeedReplace, &sh->dev[i].flags)) {
+				WARN_ON(!test_bit(R5_UPTODATE, &sh->dev[i].flags));
 				set_bit(R5_WantReplace, &sh->dev[i].flags);
 				set_bit(R5_LOCKED, &sh->dev[i].flags);
 				s.locked++;
 			}
-		set_bit(STRIPE_INSYNC, &sh->state);
+		if (s.replacing)
+			set_bit(STRIPE_INSYNC, &sh->state);
+		set_bit(STRIPE_REPLACED, &sh->state);
 	}
 	if ((s.syncing || s.replacing) && s.locked == 0 &&
+	    !test_bit(STRIPE_COMPUTE_RUN, &sh->state) &&
 	    test_bit(STRIPE_INSYNC, &sh->state)) {
 		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
 		clear_bit(STRIPE_SYNCING, &sh->state);
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index a9fc249..03f988b 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -309,6 +309,7 @@ enum {
 	STRIPE_SYNC_REQUESTED,
 	STRIPE_SYNCING,
 	STRIPE_INSYNC,
+	STRIPE_REPLACED,
 	STRIPE_PREREAD_ACTIVE,
 	STRIPE_DELAYED,
 	STRIPE_DEGRADED,
-- 
1.7.10.4


