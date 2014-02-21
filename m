Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220AbaBUMuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:50:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46906 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144AbaBUMuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:50:06 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sasha Levin <sasha.levin@oracle.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>, <xen-devel@lists.xen.org>,
        John Stultz <john.stultz@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 039/121] timekeeping: Fix potential lost pv notification of time change
Date: Fri, 21 Feb 2014 12:47:43 +0000
Message-Id: <1392986945-9693-40-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Stultz <john.stultz@linaro.org>

commit 5258d3f25c76f6ab86e9333abf97a55a877d3870 upstream.

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

This patch also changes the varialbe action -> clock_set
per Ingo's suggestion.

Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: <xen-devel@lists.xen.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/time/timekeeping.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 22f3ae2..7b96f30 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1256,7 +1256,7 @@ out_adjust:
 static inline unsigned int accumulate_nsecs_to_secs(struct timekeeper *tk)
 {
 	u64 nsecps = (u64)NSEC_PER_SEC << tk->shift;
-	unsigned int action = 0;
+	unsigned int clock_set = 0;
 
 	while (tk->xtime_nsec >= nsecps) {
 		int leap;
@@ -1279,10 +1279,10 @@ static inline unsigned int accumulate_nsecs_to_secs(struct timekeeper *tk)
 			__timekeeping_set_tai_offset(tk, tk->tai_offset - leap);
 
 			clock_was_set_delayed();
-			action = TK_CLOCK_WAS_SET;
+			clock_set = TK_CLOCK_WAS_SET;
 		}
 	}
-	return action;
+	return clock_set;
 }
 
 /**
@@ -1295,7 +1295,8 @@ static inline unsigned int accumulate_nsecs_to_secs(struct timekeeper *tk)
  * Returns the unconsumed cycles.
  */
 static cycle_t logarithmic_accumulation(struct timekeeper *tk, cycle_t offset,
-						u32 shift)
+						u32 shift,
+						unsigned int *clock_set)
 {
 	cycle_t interval = tk->cycle_interval << shift;
 	u64 raw_nsecs;
@@ -1309,7 +1310,7 @@ static cycle_t logarithmic_accumulation(struct timekeeper *tk, cycle_t offset,
 	tk->cycle_last += interval;
 
 	tk->xtime_nsec += tk->xtime_interval << shift;
-	accumulate_nsecs_to_secs(tk);
+	*clock_set |= accumulate_nsecs_to_secs(tk);
 
 	/* Accumulate raw time */
 	raw_nsecs = (u64)tk->raw_interval << shift;
@@ -1367,7 +1368,7 @@ static void update_wall_time(void)
 	struct timekeeper *tk = &shadow_timekeeper;
 	cycle_t offset;
 	int shift = 0, maxshift;
-	unsigned int action;
+	unsigned int clock_set = 0;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
@@ -1402,7 +1403,8 @@ static void update_wall_time(void)
 	maxshift = (64 - (ilog2(ntp_tick_length())+1)) - 1;
 	shift = min(shift, maxshift);
 	while (offset >= tk->cycle_interval) {
-		offset = logarithmic_accumulation(tk, offset, shift);
+		offset = logarithmic_accumulation(tk, offset, shift,
+							&clock_set);
 		if (offset < tk->cycle_interval<<shift)
 			shift--;
 	}
@@ -1420,7 +1422,7 @@ static void update_wall_time(void)
 	 * Finally, make sure that after the rounding
 	 * xtime_nsec isn't larger than NSEC_PER_SEC
 	 */
-	action = accumulate_nsecs_to_secs(tk);
+	clock_set |= accumulate_nsecs_to_secs(tk);
 
 	write_seqcount_begin(&timekeeper_seq);
 	/* Update clock->cycle_last with the new value */
@@ -1436,7 +1438,7 @@ static void update_wall_time(void)
 	 * updating.
 	 */
 	memcpy(real_tk, tk, sizeof(*tk));
-	timekeeping_update(real_tk, action);
+	timekeeping_update(real_tk, clock_set);
 	write_seqcount_end(&timekeeper_seq);
 out:
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
-- 
1.9.0

