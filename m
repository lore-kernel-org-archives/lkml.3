Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874AbaLEMsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 07:48:18 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:36407 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaLEMsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 07:48:17 -0500
Subject: [PATCH] tick-broadcast: Register for hrtimer based broadcast as the
 default broadcast mode
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
To: tglx@linutronix.de
Cc: mark.rutland@arm.com, lorenzo.pieralisi@arm.com, peterz@infradead.org,
        benh@kernel.crashing.org, rafael.j.wysocki@intel.com,
        will.deacon@arm.com, linux-kernel@vger.kernel.org,
        shawn.guo@linaro.org, fweisbec@gmail.com, jingchang.lu@freescale.com,
        svaidy@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Date: Fri, 05 Dec 2014 18:17:57 +0530
Message-ID: <20141205124756.25803.4988.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120512-0013-0000-0000-000006CA283F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 5d1638acb9f62fa7 added a hrtimer based broadcast mode for those
platforms in which local timers stop when CPUs enter deep idle states. The
commit expected the platforms to register for this mode explicitly when they
lacked a better external device to wake up CPUs in deep idle. Given that
more platforms are beginning to use this mode, we can avoid the call to
set it up on every platform that requires it, by registering for the hrtimer
based broadcast mode in the core code before clock devices begin to get
initialized.

So if there exists a better broadcast device, it will overide the hrtimer
based one; else there is a backup mechanism when a wakeup device is required.
This commit also helps detect cases where the platform fails to register for
a broadcast device but invokes the help of one when entering deep idle states.
Currently we do not handle this situation at all and invoke the help of the
broadcast clock device without checking for its existence. Registering a default
broadcast mode will handle such buggy cases properly.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 arch/arm64/kernel/time.c   |    2 --
 arch/powerpc/kernel/time.c |    1 -
 kernel/time/timekeeping.c  |    4 ++++
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/time.c b/arch/arm64/kernel/time.c
index 1a7125c..47baaa8 100644
--- a/arch/arm64/kernel/time.c
+++ b/arch/arm64/kernel/time.c
@@ -70,8 +70,6 @@ void __init time_init(void)
 	of_clk_init(NULL);
 	clocksource_of_init();
 
-	tick_setup_hrtimer_broadcast();
-
 	arch_timer_rate = arch_timer_get_rate();
 	if (!arch_timer_rate)
 		panic("Unable to initialise architected timer.\n");
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 7505599..51433a8 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -942,7 +942,6 @@ void __init time_init(void)
 	clocksource_init();
 
 	init_decrementer_clockevent();
-	tick_setup_hrtimer_broadcast();
 }
 
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index ec1791f..6044a51 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1016,6 +1016,10 @@ void __init timekeeping_init(void)
 		boot.tv_sec = 0;
 		boot.tv_nsec = 0;
 	}
+	/* Register for hrtimer based broadcast as the default timekeeping
+	 * mode in deep idle states.
+	 */
+	tick_setup_hrtimer_broadcast();
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
 	write_seqcount_begin(&tk_core.seq);

