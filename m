Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965201AbaFQQ0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:26:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50937 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964811AbaFQQZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:25:59 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stuart Hayes <stuart.w.hayes@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 101/121] hrtimer: Prevent all reprogramming if hang detected
Date: Tue, 17 Jun 2014 09:17:59 -0700
Message-Id: <1403021899-16708-74-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403021899-16708-2-git-send-email-kamal@canonical.com>
References: <1403021899-16708-2-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.24 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/hrtimer.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 60f7e32..3c29703 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -567,6 +567,23 @@ hrtimer_force_reprogram(struct hrtimer_cpu_base *cpu_base, int skip_equal)
 
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
-- 
1.9.1

