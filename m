Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab3FIAAf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 20:00:35 -0400
Received: from gloria.sntech.de ([95.129.55.99]:37135 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753103Ab3FIAAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 20:00:33 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/2] pinctrl: add function to separate combined pinconfig values
Date: Sun, 9 Jun 2013 02:00:29 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Patrice Chotard <patrice.chotard.st@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <201306090159.05383.heiko@sntech.de>
In-Reply-To: <201306090159.05383.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201306090200.30258.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous patch introduced constants to combine pinconfig settings
into one value for easier devicetree handling.

Therefore also add a function, that can separate these bitmaps into
regular generic pinconfig options for handling inside pinctrl drivers.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 .../bindings/pinctrl/pinctrl-bindings.txt          |    3 +
 drivers/pinctrl/pinconf-generic.c                  |   61 ++++++++++++++++++++
 drivers/pinctrl/pinconf.h                          |    6 ++
 3 files changed, 70 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
index d206da0..55141af 100644
--- a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
@@ -132,3 +132,6 @@ controller device.
 dt-bindings/pinctrl/pinconfig.h defines a set of constants to combine basic
 generic pinconfig settings, like pulls, into one value, that can be used
 in pinctrl bindings like <bank pin mux CONFIG>.
+
+This value can then be split into individual generic pinconfig values in the
+driver using pinconf_generic_parse_dt_bitmap.
diff --git a/drivers/pinctrl/pinconf-generic.c b/drivers/pinctrl/pinconf-generic.c
index 9a6812b..90896fe 100644
--- a/drivers/pinctrl/pinconf-generic.c
+++ b/drivers/pinctrl/pinconf-generic.c
@@ -139,3 +139,64 @@ void pinconf_generic_dump_config(struct pinctrl_dev *pctldev,
 }
 EXPORT_SYMBOL_GPL(pinconf_generic_dump_config);
 #endif
+
+/*
+ * Maps the devicetree config bits to actual pinconf values.
+ * The array indizes match the bits set in dt-bindings/pinctrl/pinconf.h
+ * and the array should contain an entry for each bit defined there
+ */
+static unsigned long conf_map[] = {
+	PIN_CONF_PACKED(PIN_CONFIG_BIAS_DISABLE, 0),
+	PIN_CONF_PACKED(PIN_CONFIG_BIAS_HIGH_IMPEDANCE, 0),
+	PIN_CONF_PACKED(PIN_CONFIG_BIAS_BUS_HOLD, 0),
+	PIN_CONF_PACKED(PIN_CONFIG_BIAS_PULL_PIN_DEFAULT, 0),
+	PIN_CONF_PACKED(PIN_CONFIG_BIAS_PULL_UP, 0),
+	PIN_CONF_PACKED(PIN_CONFIG_BIAS_PULL_DOWN, 0),
+	PIN_CONF_PACKED(PIN_CONFIG_DRIVE_PUSH_PULL, 0),
+	PIN_CONF_PACKED(PIN_CONFIG_DRIVE_OPEN_DRAIN, 0),
+	PIN_CONF_PACKED(PIN_CONFIG_DRIVE_OPEN_SOURCE, 0),
+	PIN_CONF_PACKED(PIN_CONFIG_INPUT_SCHMITT_ENABLE, 1),
+	PIN_CONF_PACKED(PIN_CONFIG_INPUT_SCHMITT_ENABLE, 0),
+	PIN_CONF_PACKED(PIN_CONFIG_LOW_POWER_MODE, 0),
+	PIN_CONF_PACKED(PIN_CONFIG_OUTPUT, 0),
+	PIN_CONF_PACKED(PIN_CONFIG_OUTPUT, 1),
+};
+
+/*
+ * Parse a pinconf bitmap from a devicetree entry into individual pin configs.
+ * @pinconf: the bitmap containing config bits
+ * @configs: after the function returns contains a pointer to an array of
+ *	     pin configs
+ * @nconfigs: number of entries of configs
+ */
+int pinconf_generic_parse_dt_bitmap(unsigned long pinconf,
+				    unsigned long **configs,
+				    unsigned int *nconfigs)
+{
+	int bit;
+	int i;
+	unsigned long *cnf;
+	unsigned int ncnf;
+
+	ncnf = hweight_long(pinconf);
+	cnf = kzalloc(ncnf * sizeof(unsigned long), GFP_KERNEL);
+
+	i = 0;
+	while (pinconf && i < ncnf) {
+		bit = __ffs(pinconf);
+		pinconf &= ~BIT(i);
+
+		if (bit > ARRAY_SIZE(conf_map)) {
+			pr_err("%s: unknown bit %d\n", __func__, bit);
+			kfree(cnf);
+			return -EINVAL;
+		}
+
+		cnf[i] = conf_map[bit];
+		i++;
+	}
+
+	*configs = cnf;
+	*nconfigs = ncnf;
+	return 0;
+}
diff --git a/drivers/pinctrl/pinconf.h b/drivers/pinctrl/pinconf.h
index 92c7267..ae7480c 100644
--- a/drivers/pinctrl/pinconf.h
+++ b/drivers/pinctrl/pinconf.h
@@ -123,3 +123,9 @@ static inline void pinconf_generic_dump_config(struct pinctrl_dev *pctldev,
 	return;
 }
 #endif
+
+#ifdef CONFIG_GENERIC_PINCONF
+int pinconf_generic_parse_dt_bitmap(unsigned long pinconf,
+				    unsigned long **configs,
+				    unsigned int *nconfigs);
+#endif
-- 
1.7.2.3

