Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779Ab3G3JhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:37:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53391 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932667Ab3G3Jd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:33:57 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 096/106] md/raid5: fix interaction of 'replace' and 'recovery'.
Date: Tue, 30 Jul 2013 10:31:55 +0100
Message-Id: <1375176725-5825-97-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit f94c0b6658c7edea8bc19d13be321e3860a3fa54 upstream.

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

Reported-by: qindehua <13691222965@163.com>
Tested-by: qindehua <qindehua@163.com>
Signed-off-by: NeilBrown <neilb@suse.de>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/raid5.c | 15 ++++++++++-----
 drivers/md/raid5.h |  1 +
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index bcd096b..ecf09ec 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3372,6 +3372,7 @@ static void handle_stripe(struct stripe_head *sh)
 	if (test_and_clear_bit(STRIPE_SYNC_REQUESTED, &sh->state)) {
 		set_bit(STRIPE_SYNCING, &sh->state);
 		clear_bit(STRIPE_INSYNC, &sh->state);
+		clear_bit(STRIPE_REPLACED, &sh->state);
 	}
 	clear_bit(STRIPE_DELAYED, &sh->state);
 
@@ -3511,19 +3512,23 @@ static void handle_stripe(struct stripe_head *sh)
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
index 2164021..43d22fc 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -307,6 +307,7 @@ enum {
 	STRIPE_SYNC_REQUESTED,
 	STRIPE_SYNCING,
 	STRIPE_INSYNC,
+	STRIPE_REPLACED,
 	STRIPE_PREREAD_ACTIVE,
 	STRIPE_DELAYED,
 	STRIPE_DEGRADED,
-- 
1.8.3.2

