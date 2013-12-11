Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273Ab3LKTQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 14:16:17 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:56050 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab3LKTOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 14:14:19 -0500
X-IronPort-AV: E=Sophos;i="4.93,873,1378882800"; 
   d="scan'208";a="1870495"
From: Sherman Yin <syin@broadcom.com>
To: Rob Herring <rob.herring@calxeda.com>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Matt Porter <matt.porter@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <bcm-kernel-feedback-list@broadcom.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Sherman Yin <syin@broadcom.com>
Subject: [PATCH v3 2/6] pinctrl: Adds slew-rate, input-enable/disable
Date: Wed, 11 Dec 2013 10:37:17 -0800
Message-ID: <1386787041-6035-3-git-send-email-syin@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386787041-6035-1-git-send-email-syin@broadcom.com>
References: <1381174108-25168-1-git-send-email-syin@broadcom.com>
 <1386787041-6035-1-git-send-email-syin@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds slew-rate and input-enable/disable support for pinconf
-generic.

Signed-off-by: Sherman Yin <syin@broadcom.com>
---
v3: added to patchset

 .../bindings/pinctrl/pinctrl-bindings.txt          |    3 +++
 drivers/pinctrl/pinconf-generic.c                  |    4 ++++
 include/linux/pinctrl/pinconf-generic.h            |    4 ++++
 3 files changed, 11 insertions(+)

diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
index 1958ca9..4414163 100644
--- a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
@@ -151,6 +151,8 @@ drive-push-pull		- drive actively high and low
 drive-open-drain	- drive with open drain
 drive-open-source	- drive with open source
 drive-strength		- sink or source at most X mA
+input-enable		- enable input on pin (no effect on output)
+input-disable		- disable input on pin (no effect on output)
 input-schmitt-enable	- enable schmitt-trigger mode
 input-schmitt-disable	- disable schmitt-trigger mode
 input-debounce		- debounce mode with debound time X
@@ -158,6 +160,7 @@ low-power-enable	- enable low power mode
 low-power-disable	- disable low power mode
 output-low		- set the pin to output mode with low level
 output-high		- set the pin to output mode with high level
+slew-rate		- set the slew rate
 
 Some of the generic properties take arguments. For those that do, the
 arguments are described below.
diff --git a/drivers/pinctrl/pinconf-generic.c b/drivers/pinctrl/pinconf-generic.c
index 55a0ebe..3d9a999 100644
--- a/drivers/pinctrl/pinconf-generic.c
+++ b/drivers/pinctrl/pinconf-generic.c
@@ -48,6 +48,7 @@ static struct pin_config_item conf_items[] = {
 	PCONFDUMP(PIN_CONFIG_DRIVE_OPEN_DRAIN, "output drive open drain", NULL),
 	PCONFDUMP(PIN_CONFIG_DRIVE_OPEN_SOURCE, "output drive open source", NULL),
 	PCONFDUMP(PIN_CONFIG_DRIVE_STRENGTH, "output drive strength", "mA"),
+	PCONFDUMP(PIN_CONFIG_INPUT_ENABLE, "input enabled", NULL),
 	PCONFDUMP(PIN_CONFIG_INPUT_SCHMITT_ENABLE, "input schmitt enabled", NULL),
 	PCONFDUMP(PIN_CONFIG_INPUT_SCHMITT, "input schmitt trigger", NULL),
 	PCONFDUMP(PIN_CONFIG_INPUT_DEBOUNCE, "input debounce", "usec"),
@@ -160,6 +161,8 @@ static struct pinconf_generic_dt_params dt_params[] = {
 	{ "drive-open-drain", PIN_CONFIG_DRIVE_OPEN_DRAIN, 0 },
 	{ "drive-open-source", PIN_CONFIG_DRIVE_OPEN_SOURCE, 0 },
 	{ "drive-strength", PIN_CONFIG_DRIVE_STRENGTH, 0 },
+	{ "input-enable", PIN_CONFIG_INPUT_ENABLE, 1 },
+	{ "input-disable", PIN_CONFIG_INPUT_ENABLE, 0 },
 	{ "input-schmitt-enable", PIN_CONFIG_INPUT_SCHMITT_ENABLE, 1 },
 	{ "input-schmitt-disable", PIN_CONFIG_INPUT_SCHMITT_ENABLE, 0 },
 	{ "input-debounce", PIN_CONFIG_INPUT_DEBOUNCE, 0 },
@@ -167,6 +170,7 @@ static struct pinconf_generic_dt_params dt_params[] = {
 	{ "low-power-disable", PIN_CONFIG_LOW_POWER_MODE, 0 },
 	{ "output-low", PIN_CONFIG_OUTPUT, 0, },
 	{ "output-high", PIN_CONFIG_OUTPUT, 1, },
+	{ "slew-rate", PIN_CONFIG_SLEW_RATE, 0},
 };
 
 /**
diff --git a/include/linux/pinctrl/pinconf-generic.h b/include/linux/pinctrl/pinconf-generic.h
index fb90ef5..0db67bf 100644
--- a/include/linux/pinctrl/pinconf-generic.h
+++ b/include/linux/pinctrl/pinconf-generic.h
@@ -61,6 +61,9 @@
  *	argument is ignored.
  * @PIN_CONFIG_DRIVE_STRENGTH: the pin will sink or source at most the current
  *	passed as argument. The argument is in mA.
+ * @PIN_CONFIG_INPUT_ENABLE: enable the pin's input.  Note that this does not
+ *	affect the pin's ability to drive output.  1 enables input, 0 disables
+ *	input.
  * @PIN_CONFIG_INPUT_SCHMITT_ENABLE: control schmitt-trigger mode on the pin.
  *      If the argument != 0, schmitt-trigger mode is enabled. If it's 0,
  *      schmitt-trigger mode is disabled.
@@ -99,6 +102,7 @@ enum pin_config_param {
 	PIN_CONFIG_DRIVE_OPEN_DRAIN,
 	PIN_CONFIG_DRIVE_OPEN_SOURCE,
 	PIN_CONFIG_DRIVE_STRENGTH,
+	PIN_CONFIG_INPUT_ENABLE,
 	PIN_CONFIG_INPUT_SCHMITT_ENABLE,
 	PIN_CONFIG_INPUT_SCHMITT,
 	PIN_CONFIG_INPUT_DEBOUNCE,
-- 
1.7.9.5

