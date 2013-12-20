Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab3LTJ0s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 04:26:48 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:39373 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab3LTJ0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 04:26:43 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH] microblaze: timer: Use generic sched_clock implementation
Date: Fri, 20 Dec 2013 10:26:29 +0100
Message-Id: <8d9086d9fb20805f533fe5762a6ab5d6460b783d.1387531581.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-16918-1387531589-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-16918-1387531589-0001

Remove sched_clock from the driver and use setup_check_clock
function.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

Thomas: Can you please review this patch?
I would like to be sure that I have done it correctly.

Thanks,
Michal
---
 arch/microblaze/Kconfig        |  1 +
 arch/microblaze/kernel/timer.c | 27 ++++++++-------------------
 2 files changed, 9 insertions(+), 19 deletions(-)

diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index e23cccd..9a4339f 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -30,6 +30,7 @@ config MICROBLAZE
 	select MODULES_USE_ELF_RELA
 	select CLONE_BACKWARDS3
 	select CLKSRC_OF
+	select GENERIC_SCHED_CLOCK

 config SWAP
 	def_bool n
diff --git a/arch/microblaze/kernel/timer.c b/arch/microblaze/kernel/timer.c
index 3e39b10..7ad0d2e 100644
--- a/arch/microblaze/kernel/timer.c
+++ b/arch/microblaze/kernel/timer.c
@@ -12,12 +12,12 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/sched.h>
+#include <linux/sched_clock.h>
 #include <linux/clk.h>
 #include <linux/clockchips.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <asm/cpuinfo.h>
-#include <linux/cnt32_to_63.h>

 static void __iomem *timer_baseaddr;

@@ -167,10 +167,15 @@ static __init void xilinx_clockevent_init(void)
 	clockevents_register_device(&clockevent_xilinx_timer);
 }

+static u32 xilinx_clock_read(void)
+{
+	return in_be32(timer_baseaddr + TCR1);
+}
+
 static cycle_t xilinx_read(struct clocksource *cs)
 {
 	/* reading actual value of timer 1 */
-	return (cycle_t) (in_be32(timer_baseaddr + TCR1));
+	return (cycle_t)xilinx_clock_read();
 }

 static struct timecounter xilinx_tc = {
@@ -222,12 +227,6 @@ static int __init xilinx_clocksource_init(void)
 	return 0;
 }

-/*
- * We have to protect accesses before timer initialization
- * and return 0 for sched_clock function below.
- */
-static int timer_initialized;
-
 static void __init xilinx_timer_init(struct device_node *timer)
 {
 	u32 irq;
@@ -263,18 +262,8 @@ static void __init xilinx_timer_init(struct device_node *timer)
 #endif
 	xilinx_clocksource_init();
 	xilinx_clockevent_init();
-	timer_initialized = 1;
-}
-
-unsigned long long notrace sched_clock(void)
-{
-	if (timer_initialized) {
-		struct clocksource *cs = &clocksource_microblaze;

-		cycle_t cyc = cnt32_to_63(cs->read(NULL)) & LLONG_MAX;
-		return clocksource_cyc2ns(cyc, cs->mult, cs->shift);
-	}
-	return 0;
+	setup_sched_clock(xilinx_clock_read, 32, timer_clock_freq);
 }

 CLOCKSOURCE_OF_DECLARE(xilinx_timer, "xlnx,xps-timer-1.00.a",
--
1.8.2.3


--=_mimegpg-monstr-desktop-16918-1387531589-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlK0DUUACgkQykllyylKDCH+HwCeK6d9Udthrx9Vpnsi4wx9jP50
i7gAn3GzQc1ruIeflK7drvtXgO7D3oVX
=9X4j
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-16918-1387531589-0001--
