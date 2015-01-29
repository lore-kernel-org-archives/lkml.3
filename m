Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760476AbbA2Ko4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:44:56 -0500
Received: from mga03.intel.com ([134.134.136.65]:14632 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757461AbbA2Kow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 05:44:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,485,1418112000"; 
   d="scan'208";a="644412350"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Jerome Blin <jerome.blin@intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pinctrl: cherryview: Configure HiZ pins to be input when requested as GPIOs
Date: Thu, 29 Jan 2015 12:44:48 +0200
Message-Id: <1422528288-84076-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the pin is in HiZ mode when it is requested as GPIO its value cannot be
read (it always returns 0). In order to cope with the Linux GPIO subsystem
where we do not have such state at all, turn the pin to be input instead.

Reported-by: Jerome Blin <jerome.blin@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/pinctrl/intel/pinctrl-cherryview.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/intel/pinctrl-cherryview.c b/drivers/pinctrl/intel/pinctrl-cherryview.c
index dde67d425e9c..abe18960933d 100644
--- a/drivers/pinctrl/intel/pinctrl-cherryview.c
+++ b/drivers/pinctrl/intel/pinctrl-cherryview.c
@@ -880,9 +880,22 @@ static int chv_gpio_request_enable(struct pinctrl_dev *pctldev,
 		value &= ~CHV_PADCTRL1_INVRXTX_MASK;
 		chv_writel(value, reg);
 
-		/* Switch to a GPIO mode */
 		reg = chv_padreg(pctrl, offset, CHV_PADCTRL0);
-		value = readl(reg) | CHV_PADCTRL0_GPIOEN;
+		value = readl(reg);
+
+		/*
+		 * If the pin is in HiZ mode (both TX and RX buffers are
+		 * disabled) we turn it to be input now.
+		 */
+		if ((value & CHV_PADCTRL0_GPIOCFG_MASK) ==
+		     (CHV_PADCTRL0_GPIOCFG_HIZ << CHV_PADCTRL0_GPIOCFG_SHIFT)) {
+			value &= ~CHV_PADCTRL0_GPIOCFG_MASK;
+			value |= CHV_PADCTRL0_GPIOCFG_GPI <<
+				CHV_PADCTRL0_GPIOCFG_SHIFT;
+		}
+
+		/* Switch to a GPIO mode */
+		value |= CHV_PADCTRL0_GPIOEN;
 		chv_writel(value, reg);
 	}
 
-- 
2.1.4

