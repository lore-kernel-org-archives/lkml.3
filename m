Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266AbaAGImD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 03:42:03 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:17609 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755988AbaAGImB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 03:42:01 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 07 Jan 2014 00:42:10 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <linus.walleij@linaro.org>
CC: <sameo@linux.intel.com>, <lee.jones@linaro.org>,
        <linux-kernel@vger.kernel.org>, <swarren@wwwdotorg.org>,
        Mallikarjun Kasoju <mkasoju@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] pinctrl: as3722: Set pin to output mode for some function
Date: Tue, 7 Jan 2014 14:10:56 +0530
Message-ID: <1389084056-17076-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mallikarjun Kasoju <mkasoju@nvidia.com>

If pins are used for function output like pwm, clk32k,
power good etc then set it as output mode default.

Signed-off-by: Mallikarjun Kasoju <mkasoju@nvidia.com>
Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/pinctrl/pinctrl-as3722.c |   20 ++++++++++++++++++++
 include/linux/mfd/as3722.h       |    1 +
 2 files changed, 21 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-as3722.c b/drivers/pinctrl/pinctrl-as3722.c
index b80f1e1..92ed4b2 100644
--- a/drivers/pinctrl/pinctrl-as3722.c
+++ b/drivers/pinctrl/pinctrl-as3722.c
@@ -250,6 +250,26 @@ static int as3722_pinctrl_enable(struct pinctrl_dev *pctldev, unsigned function,
 		return ret;
 	}
 	as_pci->gpio_control[group].io_function = function;
+
+	switch (val) {
+	case AS3722_GPIO_IOSF_SD0_OUT:
+	case AS3722_GPIO_IOSF_PWR_GOOD_OUT:
+	case AS3722_GPIO_IOSF_Q32K_OUT:
+	case AS3722_GPIO_IOSF_PWM_OUT:
+	case AS3722_GPIO_IOSF_SD6_LOW_VOLT_LOW:
+		ret = as3722_update_bits(as_pci->as3722, gpio_cntr_reg,
+			AS3722_GPIO_MODE_MASK, AS3722_GPIO_MODE_OUTPUT_VDDH);
+		if (ret < 0) {
+			dev_err(as_pci->dev, "GPIO%d_CTRL update failed %d\n",
+				group, ret);
+			return ret;
+		}
+		as_pci->gpio_control[group].mode_prop =
+				AS3722_GPIO_MODE_OUTPUT_VDDH;
+		break;
+	default:
+		break;
+	}
 	return ret;
 }
 
diff --git a/include/linux/mfd/as3722.h b/include/linux/mfd/as3722.h
index bb9616d..8d43e9f 100644
--- a/include/linux/mfd/as3722.h
+++ b/include/linux/mfd/as3722.h
@@ -316,6 +316,7 @@
 #define AS3722_GPIO_IOSF_GPIO_INTERRUPT_IN		AS3722_GPIO_IOSF_VAL(3)
 #define AS3722_GPIO_IOSF_ISINK_PWM_IN			AS3722_GPIO_IOSF_VAL(4)
 #define AS3722_GPIO_IOSF_VOLTAGE_STBY			AS3722_GPIO_IOSF_VAL(5)
+#define AS3722_GPIO_IOSF_SD0_OUT			AS3722_GPIO_IOSF_VAL(6)
 #define AS3722_GPIO_IOSF_PWR_GOOD_OUT			AS3722_GPIO_IOSF_VAL(7)
 #define AS3722_GPIO_IOSF_Q32K_OUT			AS3722_GPIO_IOSF_VAL(8)
 #define AS3722_GPIO_IOSF_WATCHDOG_IN			AS3722_GPIO_IOSF_VAL(9)
-- 
1.7.9.5

