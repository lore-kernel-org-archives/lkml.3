Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758AbaD3Khq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 06:37:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48259 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757213AbaD3Khp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 06:37:45 -0400
Date: Wed, 30 Apr 2014 03:37:20 -0700
From: tip-bot for Stuart Hayes <tipbot@zytor.com>
Message-ID: <tip-6c6c0d5a1c949d2e084706f9e5fb1fccc175b265@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        stuart.w.hayes@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stuart.w.hayes@gmail.com, tglx@linutronix.de
In-Reply-To: <53602DC6.2060101@gmail.com>
References: <53602DC6.2060101@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] hrtimer:
  Prevent all reprogramming if hang detected
Git-Commit-ID: 6c6c0d5a1c949d2e084706f9e5fb1fccc175b265
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6c6c0d5a1c949d2e084706f9e5fb1fccc175b265
Gitweb:     http://git.kernel.org/tip/6c6c0d5a1c949d2e084706f9e5fb1fccc175b265
Author:     Stuart Hayes <stuart.w.hayes@gmail.com>
AuthorDate: Tue, 29 Apr 2014 17:55:02 -0500
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 30 Apr 2014 12:34:51 +0200

hrtimer: Prevent all reprogramming if hang detected

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
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/hrtimer.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index d55092c..e3724fd 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -569,6 +569,23 @@ hrtimer_force_reprogram(struct hrtimer_cpu_base *cpu_base, int skip_equal)
 
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
