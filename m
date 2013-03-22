Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933753Ab3CVP2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 11:28:19 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51741 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933585Ab3CVP2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 11:28:06 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 5/5] ARM: ux500: Do not supply DMA platform data when booting u8540 platform
Date: Fri, 22 Mar 2013 15:27:45 +0000
Message-Id: <1363966065-2478-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363966065-2478-1-git-send-email-lee.jones@linaro.org>
References: <1363966065-2478-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The u8540 platform DMA settings are not currently supported. In this
patch we ensure they are not passed to the serial driver during boot.
This allows us to reach a terminal when booting with Device Tree
enabled.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/cpu-db8500.c |   26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index 19235cf..da425f7 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -257,9 +257,6 @@ static struct of_dev_auxdata u8500_auxdata_lookup[] __initdata = {
 	/* Requires call-back bindings. */
 	OF_DEV_AUXDATA("arm,cortex-a9-pmu", 0, "arm-pmu", &db8500_pmu_platdata),
 	/* Requires DMA bindings. */
-	OF_DEV_AUXDATA("arm,pl011", 0x80120000, "uart0", &uart0_plat),
-	OF_DEV_AUXDATA("arm,pl011", 0x80121000, "uart1", &uart1_plat),
-	OF_DEV_AUXDATA("arm,pl011", 0x80007000, "uart2", &uart2_plat),
 	OF_DEV_AUXDATA("arm,pl022", 0x80002000, "ssp0",  &ssp0_plat),
 	OF_DEV_AUXDATA("arm,pl18x", 0x80126000, "sdi0",  &mop500_sdi0_data),
 	OF_DEV_AUXDATA("arm,pl18x", 0x80118000, "sdi1",  &mop500_sdi1_data),
@@ -297,6 +294,22 @@ static struct of_dev_auxdata u8500_auxdata_lookup[] __initdata = {
 	{},
 };
 
+static struct of_dev_auxdata u8500_auxdata_uart_lookup[] __initdata = {
+	/* Requires DMA bindings. */
+	OF_DEV_AUXDATA("arm,pl011", 0x80120000, "uart0", &uart0_plat),
+	OF_DEV_AUXDATA("arm,pl011", 0x80121000, "uart1", &uart1_plat),
+	OF_DEV_AUXDATA("arm,pl011", 0x80007000, "uart2", &uart2_plat),
+	{},
+};
+
+static struct of_dev_auxdata u8540_auxdata_uart_lookup[] __initdata = {
+	/* Requires DMA bindings. */
+	OF_DEV_AUXDATA("arm,pl011", 0x80120000, "uart0", NULL),
+	OF_DEV_AUXDATA("arm,pl011", 0x80121000, "uart1", NULL),
+	OF_DEV_AUXDATA("arm,pl011", 0x80007000, "uart2", NULL),
+	{},
+};
+
 static const struct of_device_id u8500_local_bus_nodes[] = {
 	/* only create devices below soc node */
 	{ .compatible = "stericsson,db8500", },
@@ -324,6 +337,13 @@ static void __init u8500_init_machine(void)
 
 	/* automatically probe child nodes of db8500 device */
 	of_platform_populate(NULL, u8500_local_bus_nodes, u8500_auxdata_lookup, parent);
+
+	if (of_machine_is_compatible("st-ericsson,u8540"))
+		of_platform_populate(NULL, u8500_local_bus_nodes,
+				     u8540_auxdata_uart_lookup, parent);
+	else
+		of_platform_populate(NULL, u8500_local_bus_nodes,
+				     u8500_auxdata_uart_lookup, parent);
 }
 
 static const char * stericsson_dt_platform_compat[] = {
-- 
1.7.10.4

