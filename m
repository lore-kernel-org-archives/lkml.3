Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502Ab3LJFKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 00:10:41 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:62903 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab3LJFKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 00:10:18 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>, <xen-devel@lists.xen.org>,
        stable <stable@vger.kernel.org>
Subject: [RFC][PATCH 3/3] timekeeping: Fix potential lost pv notification of time change
Date: Mon,  9 Dec 2013 21:09:57 -0800
Message-Id: <1386652197-7035-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386652197-7035-1-git-send-email-john.stultz@linaro.org>
References: <1386652197-7035-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 780427f0e11 (Indicate that clock was set in the pvclock
gtod notifier), logic was added to pass a CLOCK_WAS_SET
notification to the pvclock notifier chain.

While that patch added a action flag returned from
accumulate_nsecs_to_secs(), it only uses the returned value
in one location, and not in the logarithmic accumulation.

This means if a leap second triggered during the logarithmic
accumulation (which is most likely where it would happen),
the notification that the clock was set would not make it to
the pv notifiers.

This patch extends the logarithmic_accumulation pass down
that action flag so proper notification will occur.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: <xen-devel@lists.xen.org>
Cc: stable <stable@vger.kernel.org> #3.11+
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index c615e9d..e429229 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1297,7 +1297,7 @@ static inline unsigned int accumulate_nsecs_to_secs(struct timekeeper *tk)
  * Returns the unconsumed cycles.
  */
 static cycle_t logarithmic_accumulation(struct timekeeper *tk, cycle_t offset,
-						u32 shift)
+						u32 shift, int *action)
 {
 	cycle_t interval = tk->cycle_interval << shift;
 	u64 raw_nsecs;
@@ -1311,7 +1311,7 @@ static cycle_t logarithmic_accumulation(struct timekeeper *tk, cycle_t offset,
 	tk->cycle_last += interval;
 
 	tk->xtime_nsec += tk->xtime_interval << shift;
-	accumulate_nsecs_to_secs(tk);
+	*action |= accumulate_nsecs_to_secs(tk);
 
 	/* Accumulate raw time */
 	raw_nsecs = (u64)tk->raw_interval << shift;
@@ -1369,7 +1369,7 @@ static void update_wall_time(void)
 	struct timekeeper *tk = &shadow_timekeeper;
 	cycle_t offset;
 	int shift = 0, maxshift;
-	unsigned int action;
+	unsigned int action = 0;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
@@ -1404,7 +1404,7 @@ static void update_wall_time(void)
 	maxshift = (64 - (ilog2(ntp_tick_length())+1)) - 1;
 	shift = min(shift, maxshift);
 	while (offset >= tk->cycle_interval) {
-		offset = logarithmic_accumulation(tk, offset, shift);
+		offset = logarithmic_accumulation(tk, offset, shift, &action);
 		if (offset < tk->cycle_interval<<shift)
 			shift--;
 	}
@@ -1422,7 +1422,7 @@ static void update_wall_time(void)
 	 * Finally, make sure that after the rounding
 	 * xtime_nsec isn't larger than NSEC_PER_SEC
 	 */
-	action = accumulate_nsecs_to_secs(tk);
+	action |= accumulate_nsecs_to_secs(tk);
 
 	write_seqcount_begin(&timekeeper_seq);
 	/* Update clock->cycle_last with the new value */
-- 
1.8.3.2

