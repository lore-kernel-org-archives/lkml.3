Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbaFGBah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:30:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36122 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752673AbaFGBXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Stuart Hayes" <stuart.w.hayes@gmail.com>,
        "Thomas Gleixner" <tglx@linutronix.de>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.469315064@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 39/92] hrtimer: Prevent all reprogramming if hang detected
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Stuart Hayes <stuart.w.hayes@gmail.com>

commit 6c6c0d5a1c949d2e084706f9e5fb1fccc175b265 upstream.

If the last hrtimer interrupt detected a hang it sets hang_detected=1
and programs the clock event device with a delay to let the system
make progress.

If hang_detected == 1, we prevent reprogramming of the clock event
device in hrtimer_reprogram() but not in hrtimer_force_reprogram().

This can lead to the following situation:

hrtimer_interrupt()
   hang_detected = 1;
   program ce device to Xms from now (hang delay)

We have two timers pending:
   T1 expires 50ms from now
   T2 expires 5s from now

Now T1 gets canceled, which causes hrtimer_force_reprogram() to be
invoked, which in turn programs the clock event device to T2 (5
seconds from now).

Any hrtimer_start after that will not reprogram the hardware due to
hang_detected still being set. So we effectivly block all timers until
the T2 event fires and cleans up the hang situation.

Add a check for hang_detected to hrtimer_force_reprogram() which
prevents the reprogramming of the hang delay in the hardware
timer. The subsequent hrtimer_interrupt will resolve all outstanding
issues.

[ tglx: Rewrote subject and changelog and fixed up the comment in
  	hrtimer_force_reprogram() ]

Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
Link: http://lkml.kernel.org/r/53602DC6.2060101@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/hrtimer.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -567,6 +567,23 @@ hrtimer_force_reprogram(struct hrtimer_c
 
 	cpu_base->expires_next.tv64 = expires_next.tv64;
 
+	/*
+	 * If a hang was detected in the last timer interrupt then we
+	 * leave the hang delay active in the hardware. We want the
+	 * system to make progress. That also prevents the following
+	 * scenario:
+	 * T1 expires 50ms from now
+	 * T2 expires 5s from now
+	 *
+	 * T1 is removed, so this code is called and would reprogram
+	 * the hardware to 5s from now. Any hrtimer_start after that
+	 * will not reprogram the hardware due to hang_detected being
+	 * set. So we'd effectivly block all timers until the T2 event
+	 * fires.
+	 */
+	if (cpu_base->hang_detected)
+		return;
+
 	if (cpu_base->expires_next.tv64 != KTIME_MAX)
 		tick_program_event(cpu_base->expires_next, 1);
 }

