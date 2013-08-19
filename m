Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751142Ab3HSJlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 05:41:15 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:55726 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab3HSJlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 05:41:13 -0400
Date: Mon, 19 Aug 2013 11:41:10 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timer fixes
Message-ID: <20130819094110.GA30390@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-urgent-for-linus

   HEAD: ae920eb24277e4a174a3ca575ce42b98b18a6748 Merge branch 'fortglx/3.11/time' of git://git.linaro.org/people/jstultz/linux into timers/urgent

Three small fixlets.

 Thanks,

	Ingo

------------------>
Baruch Siach (1):
      sched_clock: Fix integer overflow

Li Zhong (1):
      nohz: fix compile warning in tick_nohz_init()

Steven Rostedt (1):
      nohz: Do not warn about unstable tsc unless user uses nohz_full


 kernel/time/sched_clock.c | 2 +-
 kernel/time/tick-sched.c  | 5 ++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/time/sched_clock.c b/kernel/time/sched_clock.c
index a326f27..0b479a6 100644
--- a/kernel/time/sched_clock.c
+++ b/kernel/time/sched_clock.c
@@ -121,7 +121,7 @@ void __init setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate)
 	BUG_ON(bits > 32);
 	WARN_ON(!irqs_disabled());
 	read_sched_clock = read;
-	sched_clock_mask = (1 << bits) - 1;
+	sched_clock_mask = (1ULL << bits) - 1;
 	cd.rate = rate;
 
 	/* calculate the mult/shift to convert counter ticks to ns. */
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index e80183f..9563c74 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -182,7 +182,8 @@ static bool can_stop_full_tick(void)
 		 * Don't allow the user to think they can get
 		 * full NO_HZ with this machine.
 		 */
-		WARN_ONCE(1, "NO_HZ FULL will not work with unstable sched clock");
+		WARN_ONCE(have_nohz_full_mask,
+			  "NO_HZ FULL will not work with unstable sched clock");
 		return false;
 	}
 #endif
@@ -343,8 +344,6 @@ static int tick_nohz_init_all(void)
 
 void __init tick_nohz_init(void)
 {
-	int cpu;
-
 	if (!have_nohz_full_mask) {
 		if (tick_nohz_init_all() < 0)
 			return;
