Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637Ab3AYORF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 09:17:05 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:50219 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757188Ab3AYOPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 09:15:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@list.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 18/19] ARM: at91: suspend both memory controllers on at91sam9263
Date: Fri, 25 Jan 2013 14:14:35 +0000
Message-Id: <1359123276-15833-19-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1359123276-15833-1-git-send-email-arnd@arndb.de>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:kP7NT5I+vfrDBeGzVLYr4gSbRjQJaFRf9rYort398p2
 lCIaG7RZha2PR+hOJvtQ0ucnvFzA+gvgGjp75B0HogHiDMRTOS
 ik92BAQgGK/Z9ZMbLe/PN4D6Wm6Ecz6PkMp5dRoVPca+V2cMxc
 MqfOX1FXBTAPNk2jl/kkmLdkux5MclfWMXAf4UzBOt8vrZi/A7
 lRy4dmTbXZS3bVrugXL7A7Rf49CVQDJhSl+MaiLu5VSllxQA/b
 4EyPukOQZdsV5vm/UEM0Di5H/IYdOKoSNdEQ0OiwcXUQPgL2OE
 /blT9nVxcxCrXQag+GmNX4s3DHe7JgsvC/PmvGpfLmGp8zxB3m
 sx31gVdu0NjP2AF/q6XNsr/54q6ubzzAhfsTX3q42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the past three years, we have had a #warning in
mach-at91 about the sdram_selfrefresh_enable or
at91sam9_standby functions possibly not working on
at91sam9263. In the meantime a function was added
to do the right thing on at91sam9g45, which looks like
it should also work on '9263.

This patch blindly removes the warning and changes the
at91sam9263 to use the same code at at91sam9g45, which
may or may not be the right solution. If it is not,
maybe someone could provide a better fix.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Andrew Victor <linux@maxim.org.za>
Cc: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 arch/arm/mach-at91/cpuidle.c | 2 +-
 arch/arm/mach-at91/pm.c      | 2 +-
 arch/arm/mach-at91/pm.h      | 8 --------
 3 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-at91/cpuidle.c b/arch/arm/mach-at91/cpuidle.c
index 0c63815..208d486 100644
--- a/arch/arm/mach-at91/cpuidle.c
+++ b/arch/arm/mach-at91/cpuidle.c
@@ -36,7 +36,7 @@ static int at91_enter_idle(struct cpuidle_device *dev,
 {
 	if (cpu_is_at91rm9200())
 		at91rm9200_standby();
-	else if (cpu_is_at91sam9g45())
+	else if (cpu_is_at91sam9g45() || cpu_is_at91sam9263())
 		at91sam9g45_standby();
 	else
 		at91sam9_standby();
diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index adb6db8..f6bd4fa 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -265,7 +265,7 @@ static int at91_pm_enter(suspend_state_t state)
 			 */
 			if (cpu_is_at91rm9200())
 				at91rm9200_standby();
-			else if (cpu_is_at91sam9g45())
+			else if (cpu_is_at91sam9g45() || cpu_is_at91sam9263())
 				at91sam9g45_standby();
 			else
 				at91sam9_standby();
diff --git a/arch/arm/mach-at91/pm.h b/arch/arm/mach-at91/pm.h
index 38f467c..5252216 100644
--- a/arch/arm/mach-at91/pm.h
+++ b/arch/arm/mach-at91/pm.h
@@ -70,14 +70,6 @@ static inline void at91sam9g45_standby(void)
 	at91_ramc_write(1, AT91_DDRSDRC_LPR, saved_lpr1);
 }
 
-#ifdef CONFIG_SOC_AT91SAM9263
-/*
- * FIXME either or both the SDRAM controllers (EB0, EB1) might be in use;
- * handle those cases both here and in the Suspend-To-RAM support.
- */
-#warning Assuming EB1 SDRAM controller is *NOT* used
-#endif
-
 static inline void at91sam9_standby(void)
 {
 	u32 saved_lpr, lpr;
-- 
1.8.0

