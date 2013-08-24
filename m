Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab3HXVhK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 17:37:10 -0400
Received: from 8.mo2.mail-out.ovh.net ([188.165.52.147]:48353 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755827Ab3HXVhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 17:37:08 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Jiri Kosina <jkosina@suse.cz>, Masanari Iida <standby24x7@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, James Hogan <james.hogan@imgtec.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: [RFC PATCH 1/3] pinctrl: add new generic pinconf config for deglitch filter
Date: Sat, 24 Aug 2013 23:35:09 +0200
Message-Id: <1377380109-11247-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377379926-11163-1-git-send-email-b.brezillon@overkiz.com>
References: <1377379926-11163-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 2842334316216744160
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrhedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrhedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new parameter to support deglitch filter configuration.
A deglitch filter works like a debounce filter but with a smaller
delay (nanoseconds).

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 .../bindings/pinctrl/pinctrl-bindings.txt          |    1 +
 drivers/pinctrl/pinconf-generic.c                  |    2 ++
 include/linux/pinctrl/pinconf-generic.h            |    5 +++++
 3 files changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
index 1958ca9..2f7613e 100644
--- a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
@@ -154,6 +154,7 @@ drive-strength		- sink or source at most X mA
 input-schmitt-enable	- enable schmitt-trigger mode
 input-schmitt-disable	- disable schmitt-trigger mode
 input-debounce		- debounce mode with debound time X
+input-deglitch		- deglitch mode
 low-power-enable	- enable low power mode
 low-power-disable	- disable low power mode
 output-low		- set the pin to output mode with low level
diff --git a/drivers/pinctrl/pinconf-generic.c b/drivers/pinctrl/pinconf-generic.c
index 2c62225..f14a386 100644
--- a/drivers/pinctrl/pinconf-generic.c
+++ b/drivers/pinctrl/pinconf-generic.c
@@ -51,6 +51,7 @@ static struct pin_config_item conf_items[] = {
 	PCONFDUMP(PIN_CONFIG_INPUT_SCHMITT_ENABLE, "input schmitt enabled", NULL),
 	PCONFDUMP(PIN_CONFIG_INPUT_SCHMITT, "input schmitt trigger", NULL),
 	PCONFDUMP(PIN_CONFIG_INPUT_DEBOUNCE, "input debounce", "usec"),
+	PCONFDUMP(PIN_CONFIG_INPUT_DEGLITCH, "input deglitch", NULL),
 	PCONFDUMP(PIN_CONFIG_POWER_SOURCE, "pin power source", "selector"),
 	PCONFDUMP(PIN_CONFIG_SLEW_RATE, "slew rate", NULL),
 	PCONFDUMP(PIN_CONFIG_LOW_POWER_MODE, "pin low power", "mode"),
@@ -163,6 +164,7 @@ static struct pinconf_generic_dt_params dt_params[] = {
 	{ "input-schmitt-enable", PIN_CONFIG_INPUT_SCHMITT_ENABLE, 1 },
 	{ "input-schmitt-disable", PIN_CONFIG_INPUT_SCHMITT_ENABLE, 0 },
 	{ "input-debounce", PIN_CONFIG_INPUT_DEBOUNCE, 0 },
+	{ "input-deglitch", PIN_CONFIG_INPUT_DEGLITCH, 0 },
 	{ "low-power-enable", PIN_CONFIG_LOW_POWER_MODE, 1 },
 	{ "low-power-disable", PIN_CONFIG_LOW_POWER_MODE, 0 },
 	{ "output-low", PIN_CONFIG_OUTPUT, 0, },
diff --git a/include/linux/pinctrl/pinconf-generic.h b/include/linux/pinctrl/pinconf-generic.h
index fb90ef5..aa06535 100644
--- a/include/linux/pinctrl/pinconf-generic.h
+++ b/include/linux/pinctrl/pinconf-generic.h
@@ -72,6 +72,10 @@
  *	which means it will wait for signals to settle when reading inputs. The
  *	argument gives the debounce time in usecs. Setting the
  *	argument to zero turns debouncing off.
+  * @PIN_CONFIG_INPUT_DEGLITCH: this will configure the pin to deglitch mode,
+ *	which means it will wait for signals to settle when reading inputs. The
+ *      If the argument != 0, deglitch mode is enabled. If it's 0, deglitch
+ *      mode is disabled.
  * @PIN_CONFIG_POWER_SOURCE: if the pin can select between different power
  *	supplies, the argument to this parameter (on a custom format) tells
  *	the driver which alternative power source to use.
@@ -102,6 +106,7 @@ enum pin_config_param {
 	PIN_CONFIG_INPUT_SCHMITT_ENABLE,
 	PIN_CONFIG_INPUT_SCHMITT,
 	PIN_CONFIG_INPUT_DEBOUNCE,
+	PIN_CONFIG_INPUT_DEGLITCH,
 	PIN_CONFIG_POWER_SOURCE,
 	PIN_CONFIG_SLEW_RATE,
 	PIN_CONFIG_LOW_POWER_MODE,
-- 
1.7.9.5

