Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbbATI3o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 03:29:44 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:57823 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbbATI3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 03:29:43 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <nicolas.ferre@atmel.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <alexandre.belloni@free-electrons.com>, <sylvain.rochet@finsecur.com>,
        <peda@axentia.se>, <wenyou.yang@atmel.com>
Subject: [PATCH 12/12] pm: at91: amend the pm_suspend entry for at91_cpuidle_device
Date: Tue, 20 Jan 2015 16:26:25 +0800
Message-ID: <1421742385-18470-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1421741825-18226-1-git-send-email-wenyou.yang@atmel.com>
References: <1421741825-18226-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because the at91_xxx_standby() function is substitued by the at91_pm_suspend(),
the pm_suspend entry for at91_cpuidle_device changes as well.

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/pm.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 07b723f..041adad 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -48,8 +48,6 @@ static struct {
 	int memctrl;
 } at91_pm_data;
 
-static void (*at91_pm_standby)(void);
-
 static int at91_pm_valid_state(suspend_state_t state)
 {
 	switch (state) {
@@ -218,12 +216,15 @@ static struct platform_device at91_cpuidle_device = {
 	.name = "cpuidle-at91",
 };
 
-void at91_pm_set_standby(void (*at91_standby)(void))
+static void at91_cpuidle_suspend(void)
 {
-	if (at91_standby) {
-		at91_cpuidle_device.dev.platform_data = at91_standby;
-		at91_pm_standby = at91_standby;
-	}
+	at91_pm_suspend(PM_SUSPEND_ON);
+}
+
+static void at91_cpuidle_set_suspend(void (*at91_suspend)(void))
+{
+	if (at91_suspend)
+		at91_cpuidle_device.dev.platform_data = at91_suspend;
 }
 
 static void __init at91_pm_sram_init(void)
@@ -302,6 +303,8 @@ static void __init at91_pm_init(void)
 
 	at91_pm_sram_init();
 
+	at91_cpuidle_set_suspend(at91_cpuidle_suspend);
+
 	if (at91_cpuidle_device.dev.platform_data)
 		platform_device_register(&at91_cpuidle_device);
 
-- 
1.7.9.5

