Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844Ab3CTGit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 02:38:49 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47316 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747Ab3CTGis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 02:38:48 -0400
From: Philip Avinash <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>
CC: <nsekhar@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <prakash.pm@ti.com>,
        Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH v2] pwm: davinci: Add Kconfig support for ECAP & EHRPWM devices
Date: Wed, 20 Mar 2013 12:09:24 +0530
Message-ID: <1363761564-14814-1-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add EHRPWM and ECAP support build support for DAVINCI_DA8XX platforms.

Also, since DAVINCI platforms doesn't support TI-PWM-Subsystem module,
remove the select option for CONFIG_PWM_TIPWMSS.

Also, update CONFIG_PWM_TIPWMSS compiler directive appropriately in
pwm-tipwmss.h to fix the below compiler error upon removal of
CONFIG_PWM_TIPWMSS for DAVINCI platforms.

	drivers/pwm/pwm-tiecap.c: In function 'ecap_pwm_probe':
	drivers/pwm/pwm-tiecap.c:263:4: error: 'PWMSS_ECAPCLK_EN' undeclared
	(first use in this function)
	drivers/pwm/pwm-tiecap.c:263:4: note: each undeclared identifier
	is reported only once for each function it appears in
	drivers/pwm/pwm-tiecap.c:264:17: error: 'PWMSS_ECAPCLK_EN_ACK'
	undeclared (first use in this function)
	drivers/pwm/pwm-tiecap.c: In function 'ecap_pwm_remove':
	drivers/pwm/pwm-tiecap.c:291:49: error: 'PWMSS_ECAPCLK_STOP_REQ'
	undeclared (first use in this function)
	make[2]: *** [drivers/pwm/pwm-tiecap.o] Error 1
	make[1]: *** [drivers/pwm] Error 2
	make: *** [drivers] Error 2

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
---
Changes Since v1:
	- Change the Kconfig dependency to ARCH_DAVINCI_DA8XX from
	  ARCH_DAVINCI_DA850.

This patch series based on [1] and is available at [2].

[1] https://gitorious.org/linux-pwm/linux-pwm/trees/for-next
[2] https://github.com/avinashphilip/am335x_linux/tree/davinci-for-v3.9_soc_pwm

:100644 100644 0e0bfa0... 115b644... M	drivers/pwm/Kconfig
:100644 100644 11f76a1... 10ad804... M	drivers/pwm/pwm-tipwmss.h
 drivers/pwm/Kconfig       |    8 +++-----
 drivers/pwm/pwm-tipwmss.h |    2 +-
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index 0e0bfa0..115b644 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -147,8 +147,7 @@ config PWM_TEGRA
 
 config  PWM_TIECAP
 	tristate "ECAP PWM support"
-	depends on SOC_AM33XX
-	select PWM_TIPWMSS
+	depends on SOC_AM33XX || ARCH_DAVINCI_DA8XX
 	help
 	  PWM driver support for the ECAP APWM controller found on AM33XX
 	  TI SOC
@@ -158,8 +157,7 @@ config  PWM_TIECAP
 
 config  PWM_TIEHRPWM
 	tristate "EHRPWM PWM support"
-	depends on SOC_AM33XX
-	select PWM_TIPWMSS
+	depends on SOC_AM33XX || ARCH_DAVINCI_DA8XX
 	help
 	  PWM driver support for the EHRPWM controller found on AM33XX
 	  TI SOC
@@ -169,7 +167,7 @@ config  PWM_TIEHRPWM
 
 config  PWM_TIPWMSS
 	bool
-	depends on SOC_AM33XX && (PWM_TIEHRPWM || PWM_TIECAP)
+	default y if SOC_AM33XX && (PWM_TIECAP || PWM_TIEHRPWM)
 	help
 	  PWM Subsystem driver support for AM33xx SOC.
 
diff --git a/drivers/pwm/pwm-tipwmss.h b/drivers/pwm/pwm-tipwmss.h
index 11f76a1..10ad804 100644
--- a/drivers/pwm/pwm-tipwmss.h
+++ b/drivers/pwm/pwm-tipwmss.h
@@ -18,7 +18,6 @@
 #ifndef __TIPWMSS_H
 #define __TIPWMSS_H
 
-#ifdef CONFIG_PWM_TIPWMSS
 /* PWM substem clock gating */
 #define PWMSS_ECAPCLK_EN	BIT(0)
 #define PWMSS_ECAPCLK_STOP_REQ	BIT(1)
@@ -28,6 +27,7 @@
 #define PWMSS_ECAPCLK_EN_ACK	BIT(0)
 #define PWMSS_EPWMCLK_EN_ACK	BIT(8)
 
+#ifdef CONFIG_PWM_TIPWMSS
 extern u16 pwmss_submodule_state_change(struct device *dev, int set);
 #else
 static inline u16 pwmss_submodule_state_change(struct device *dev, int set)
-- 
1.7.9.5

