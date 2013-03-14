Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab3CNKde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:33:34 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52128 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756640Ab3CNKdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:33:31 -0400
From: Philip Avinash <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>
CC: <nsekhar@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <prakash.pm@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH 1/3] pwm: davinci: Add Kconfig support for ECAP & EHRPWM devices
Date: Thu, 14 Mar 2013 16:02:36 +0530
Message-ID: <1363257158-11615-2-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363257158-11615-1-git-send-email-avinashphilip@ti.com>
References: <1363257158-11615-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add EHRPWM and ECAP support build support for DAVINCI_DA850 platforms.

Also, since DAVINCI platforms doesn't support TI-PWM-Subsystem module,
remove the select option for CONFIG_PWM_TIPWMSS.

Also, update CONFIG_PWM_TIPWMSS compiler directive appropriately in
pwm-tipwmss.h to fix the below compiler error upon removal of
CONFIG_PWM_TIPWMSS for Davinci platforms.

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
:100644 100644 0e0bfa0... 897b53c... M	drivers/pwm/Kconfig
:100644 100644 11f76a1... 10ad804... M	drivers/pwm/pwm-tipwmss.h
 drivers/pwm/Kconfig       |    8 +++-----
 drivers/pwm/pwm-tipwmss.h |    2 +-
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index 0e0bfa0..897b53c 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -147,8 +147,7 @@ config PWM_TEGRA
 
 config  PWM_TIECAP
 	tristate "ECAP PWM support"
-	depends on SOC_AM33XX
-	select PWM_TIPWMSS
+	depends on SOC_AM33XX || ARCH_DAVINCI_DA850
 	help
 	  PWM driver support for the ECAP APWM controller found on AM33XX
 	  TI SOC
@@ -158,8 +157,7 @@ config  PWM_TIECAP
 
 config  PWM_TIEHRPWM
 	tristate "EHRPWM PWM support"
-	depends on SOC_AM33XX
-	select PWM_TIPWMSS
+	depends on SOC_AM33XX || ARCH_DAVINCI_DA850
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

