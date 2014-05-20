Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbaETQQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 12:16:17 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:61076 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753825AbaETQQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 12:16:16 -0400
Message-ID: <1400602574.4912.43.camel@x220>
Subject: [PATCH] MIPS: cavium-octeon: remove checks for CONFIG_CAVIUM_GDB
From: Paul Bolle <pebolle@tiscali.nl>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Date: Tue, 20 May 2014 18:16:14 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 May 2014 16:16:15.0094 (UTC) FILETIME=[D2D80960:01CF7446]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Three checks for CONFIG_CAVIUM_GDB were added in v2.6.29. But the
Kconfig symbol CAVIUM_GDB was never added to the tree. Remove these
checks.

Also remove the last reference to octeon_get_boot_debug_flag(). There is
no definition of that function anyway.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

A follow up might be to remove plat_smp_ops.cpus_done. All these
callbacks are now (basically) nops.

 arch/mips/cavium-octeon/setup.c       | 11 -----------
 arch/mips/cavium-octeon/smp.c         | 17 -----------------
 arch/mips/include/asm/octeon/octeon.h |  1 -
 3 files changed, 29 deletions(-)

diff --git a/arch/mips/cavium-octeon/setup.c b/arch/mips/cavium-octeon/setup.c
index 953ca85f84fa..989781fbae76 100644
--- a/arch/mips/cavium-octeon/setup.c
+++ b/arch/mips/cavium-octeon/setup.c
@@ -729,17 +729,6 @@ void __init prom_init(void)
 	octeon_write_lcd("Linux");
 #endif
 
-#ifdef CONFIG_CAVIUM_GDB
-	/*
-	 * When debugging the linux kernel, force the cores to enter
-	 * the debug exception handler to break in.
-	 */
-	if (octeon_get_boot_debug_flag()) {
-		cvmx_write_csr(CVMX_CIU_DINT, 1 << cvmx_get_core_num());
-		cvmx_read_csr(CVMX_CIU_DINT);
-	}
-#endif
-
 	octeon_setup_delays();
 
 	/*
diff --git a/arch/mips/cavium-octeon/smp.c b/arch/mips/cavium-octeon/smp.c
index 67a078ffc464..78e1abebc854 100644
--- a/arch/mips/cavium-octeon/smp.c
+++ b/arch/mips/cavium-octeon/smp.c
@@ -218,15 +218,6 @@ void octeon_prepare_cpus(unsigned int max_cpus)
  */
 static void octeon_smp_finish(void)
 {
-#ifdef CONFIG_CAVIUM_GDB
-	unsigned long tmp;
-	/* Pulse MCD0 signal on Ctrl-C to stop all the cores. Also set the MCD0
-	   to be not masked by this core so we know the signal is received by
-	   someone */
-	asm volatile ("dmfc0 %0, $22\n"
-		      "ori   %0, %0, 0x9100\n" "dmtc0 %0, $22\n" : "=r" (tmp));
-#endif
-
 	octeon_user_io_init();
 
 	/* to generate the first CPU timer interrupt */
@@ -239,14 +230,6 @@ static void octeon_smp_finish(void)
  */
 static void octeon_cpus_done(void)
 {
-#ifdef CONFIG_CAVIUM_GDB
-	unsigned long tmp;
-	/* Pulse MCD0 signal on Ctrl-C to stop all the cores. Also set the MCD0
-	   to be not masked by this core so we know the signal is received by
-	   someone */
-	asm volatile ("dmfc0 %0, $22\n"
-		      "ori   %0, %0, 0x9100\n" "dmtc0 %0, $22\n" : "=r" (tmp));
-#endif
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
diff --git a/arch/mips/include/asm/octeon/octeon.h b/arch/mips/include/asm/octeon/octeon.h
index f5d77b91537f..d781f9e66884 100644
--- a/arch/mips/include/asm/octeon/octeon.h
+++ b/arch/mips/include/asm/octeon/octeon.h
@@ -211,7 +211,6 @@ union octeon_cvmemctl {
 
 extern void octeon_write_lcd(const char *s);
 extern void octeon_check_cpu_bist(void);
-extern int octeon_get_boot_debug_flag(void);
 extern int octeon_get_boot_uart(void);
 
 struct uart_port;
-- 
1.9.0

