Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbaB1LMs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 06:12:48 -0500
Received: from ni.piap.pl ([195.187.100.4]:41145 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbaB1LMr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 06:12:47 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: linux-arm-kernel@lists.infradead.org
Cc: lkml <linux-kernel@vger.kernel.org>, Anton Vorontsov <anton@enomsg.org>,
        Yinghai Lu <yinghai@kernel.org>, Russell King <linux@arm.linux.org.uk>
References: <m3eh2nqz7n.fsf@t19.piap.pl>
Date: Fri, 28 Feb 2014 12:12:45 +0100
In-Reply-To: <m3eh2nqz7n.fsf@t19.piap.pl> ("Krzysztof =?utf-8?Q?Ha=C5=82as?=
 =?utf-8?Q?a=22's?= message of
	"Fri, 28 Feb 2014 12:00:12 +0100")
MIME-Version: 1.0
Message-ID: <m3sir3pk2a.fsf@t19.piap.pl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] CNS3xxx: Fix PCIe early iotable_init().
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE,
	 bases: 20140228 #7333291, check: 20140228 clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>

--- a/arch/arm/mach-cns3xxx/cns3420vb.c
+++ b/arch/arm/mach-cns3xxx/cns3420vb.c
@@ -240,7 +240,7 @@ static void __init cns3420_map_io(void)
 {
 	cns3xxx_map_io();
 	iotable_init(cns3420_io_desc, ARRAY_SIZE(cns3420_io_desc));
-
+	cns3xxx_pcie_iotable_init();
 	cns3420_early_serial_setup();
 }
 
--- a/arch/arm/mach-cns3xxx/core.h
+++ b/arch/arm/mach-cns3xxx/core.h
@@ -14,6 +14,7 @@
 #include <linux/reboot.h>
 
 extern void cns3xxx_timer_init(void);
+extern void cns3xxx_pcie_iotable_init(void);
 
 #ifdef CONFIG_CACHE_L2X0
 void __init cns3xxx_l2x0_init(void);
--- a/arch/arm/mach-cns3xxx/pcie.c
+++ b/arch/arm/mach-cns3xxx/pcie.c
@@ -357,6 +357,15 @@ static int cns3xxx_pcie_abort_handler(unsigned long addr, unsigned int fsr,
 	return 0;
 }
 
+void __init cns3xxx_pcie_iotable_init()
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(cns3xxx_pcie); i++)
+		iotable_init(cns3xxx_pcie[i].cfg_bases,
+			     ARRAY_SIZE(cns3xxx_pcie[i].cfg_bases));
+}
+
 static int __init cns3xxx_pcie_init(void)
 {
 	int i;
@@ -368,8 +377,6 @@ static int __init cns3xxx_pcie_init(void)
 			"imprecise external abort");
 
 	for (i = 0; i < ARRAY_SIZE(cns3xxx_pcie); i++) {
-		iotable_init(cns3xxx_pcie[i].cfg_bases,
-			     ARRAY_SIZE(cns3xxx_pcie[i].cfg_bases));
 		cns3xxx_pwr_clk_en(0x1 << PM_CLK_GATE_REG_OFFSET_PCIE(i));
 		cns3xxx_pwr_soft_rst(0x1 << PM_SOFT_RST_REG_OFFST_PCIE(i));
 		cns3xxx_pcie_check_link(&cns3xxx_pcie[i]);
