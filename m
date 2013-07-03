Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454Ab3GCSxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:53:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33750 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933218Ab3GCSk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:40:57 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=auy0Vb47FqsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=HK5x-_4mIs4A:10 a=8981fWPbAAAA:8 a=VwQbUJbxAAAA:8 a=tBb2bbeoAAAA:8 a=eo28vNW5fjKHd3-HlXAA:9 a=YuKU6ANggZ8A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184051.402637585@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:39:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Finn Thain <fthain@telegraphics.com.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [041/141] m68k/mac: Fix unexpected interrupt with CONFIG_EARLY_PRINTK
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0041-m68k-mac-Fix-unexpected-interrupt-with-CONFIG_EARLY_.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit df66834a43c461de2565c45d815288ba1c0def37 ]

The present code does not wait for the SCC to finish resetting itself
before trying to initialise the device. The result is that the SCC
interrupt sources become enabled (if they weren't already). This leads to
an early boot crash (unexpected interrupt) given CONFIG_EARLY_PRINTK. Fix
this by adding a delay. A successful reset disables the interrupt sources.

Also, after the reset for channel A setup, the SCC then gets a second
reset for channel B setup which leaves channel A uninitialised again. Fix
this by performing the reset only once.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Cc: stable@vger.kernel.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/m68k/kernel/head.S |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/arch/m68k/kernel/head.S b/arch/m68k/kernel/head.S
index d197e7f..ac85f16 100644
--- a/arch/m68k/kernel/head.S
+++ b/arch/m68k/kernel/head.S
@@ -2752,11 +2752,9 @@ func_return	get_new_page
 #ifdef CONFIG_MAC
 
 L(scc_initable_mac):
-	.byte	9,12		/* Reset */
 	.byte	4,0x44		/* x16, 1 stopbit, no parity */
 	.byte	3,0xc0		/* receiver: 8 bpc */
 	.byte	5,0xe2		/* transmitter: 8 bpc, assert dtr/rts */
-	.byte	9,0		/* no interrupts */
 	.byte	10,0		/* NRZ */
 	.byte	11,0x50		/* use baud rate generator */
 	.byte	12,1,13,0	/* 38400 baud */
@@ -2899,6 +2897,7 @@ func_start	serial_init,%d0/%d1/%a0/%a1
 	is_not_mac(L(serial_init_not_mac))
 
 #ifdef SERIAL_DEBUG
+
 /* You may define either or both of these. */
 #define MAC_USE_SCC_A /* Modem port */
 #define MAC_USE_SCC_B /* Printer port */
@@ -2908,9 +2907,21 @@ func_start	serial_init,%d0/%d1/%a0/%a1
 #define mac_scc_cha_b_data_offset	0x4
 #define mac_scc_cha_a_data_offset	0x6
 
+#if defined(MAC_USE_SCC_A) || defined(MAC_USE_SCC_B)
+	movel	%pc@(L(mac_sccbase)),%a0
+	/* Reset SCC device */
+	moveb	#9,%a0@(mac_scc_cha_a_ctrl_offset)
+	moveb	#0xc0,%a0@(mac_scc_cha_a_ctrl_offset)
+	/* Wait for 5 PCLK cycles, which is about 68 CPU cycles */
+	/* 5 / 3.6864 MHz = approx. 1.36 us = 68 / 50 MHz */
+	movel	#35,%d0
+5:
+	subq	#1,%d0
+	jne	5b
+#endif
+
 #ifdef MAC_USE_SCC_A
 	/* Initialize channel A */
-	movel	%pc@(L(mac_sccbase)),%a0
 	lea	%pc@(L(scc_initable_mac)),%a1
 5:	moveb	%a1@+,%d0
 	jmi	6f
@@ -2922,9 +2933,6 @@ func_start	serial_init,%d0/%d1/%a0/%a1
 
 #ifdef MAC_USE_SCC_B
 	/* Initialize channel B */
-#ifndef MAC_USE_SCC_A	/* Load mac_sccbase only if needed */
-	movel	%pc@(L(mac_sccbase)),%a0
-#endif	/* MAC_USE_SCC_A */
 	lea	%pc@(L(scc_initable_mac)),%a1
 7:	moveb	%a1@+,%d0
 	jmi	8f
@@ -2933,6 +2941,7 @@ func_start	serial_init,%d0/%d1/%a0/%a1
 	jra	7b
 8:
 #endif	/* MAC_USE_SCC_B */
+
 #endif	/* SERIAL_DEBUG */
 
 	jra	L(serial_init_done)
@@ -3006,17 +3015,17 @@ func_start	serial_putc,%d0/%d1/%a0/%a1
 
 #ifdef SERIAL_DEBUG
 
-#ifdef MAC_USE_SCC_A
+#if defined(MAC_USE_SCC_A) || defined(MAC_USE_SCC_B)
 	movel	%pc@(L(mac_sccbase)),%a1
+#endif
+
+#ifdef MAC_USE_SCC_A
 3:	btst	#2,%a1@(mac_scc_cha_a_ctrl_offset)
 	jeq	3b
 	moveb	%d0,%a1@(mac_scc_cha_a_data_offset)
 #endif	/* MAC_USE_SCC_A */
 
 #ifdef MAC_USE_SCC_B
-#ifndef MAC_USE_SCC_A	/* Load mac_sccbase only if needed */
-	movel	%pc@(L(mac_sccbase)),%a1
-#endif	/* MAC_USE_SCC_A */
 4:	btst	#2,%a1@(mac_scc_cha_b_ctrl_offset)
 	jeq	4b
 	moveb	%d0,%a1@(mac_scc_cha_b_data_offset)
-- 
1.7.10.4


