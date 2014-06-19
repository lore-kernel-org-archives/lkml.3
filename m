Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbaFSNF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 09:05:29 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:53004 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbaFSNFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 09:05:24 -0400
From: Ulf Hansson <ulf.hansson@linaro.org>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Alexandre Courbot <gnurou@gmail.com>,
        Arend van Spriel <arend@broadcom.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, Chris Ball <chris@printf.net>,
        Chen-Yu Tsai <wens@csie.org>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [RFC 1/2] pwrseq: Add subsystem to handle complex power sequences
Date: Thu, 19 Jun 2014 15:04:50 +0200
Message-Id: <1403183091-27876-2-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403183091-27876-1-git-send-email-ulf.hansson@linaro.org>
References: <1403183091-27876-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pwrseq subsystem handles complex power sequences, typically useful
for subsystems that makes use of discoverable buses, like for example
MMC and I2C.

The pwrseq subsystem is dependant on CONFIG_OF to be able to parse a DT
childnode to find out what power sequence method to bind for a device.

>From the DT childnode, the pwrseq DT parser tries to locate a
"power-method" property, which string is matched towards the list of
supported pwrseq methods.

Each pwrseq method implements it's own power sequence and interfaces
the pwrseq core through a few callback functions.

To instantiate a pwrseq method, clients shall use the devm_pwrseq_get()
API. If needed, clients can explicity drop the references to a pwrseq
method using devm_pwrseq_put() API.

Besides instantiation, the pwrseq API provides clients opportunity to
select a certain power state. In this intial version, PWRSEQ_POWER_ON
and PWRSEQ_POWER_OFF are supported. Those are also mandatory for each
pwrseq method to support.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 .../devicetree/bindings/pwrseq/pwrseq.txt          |   48 ++++++
 drivers/Makefile                                   |    2 +-
 drivers/pwrseq/Makefile                            |    2 +
 drivers/pwrseq/core.c                              |  175 ++++++++++++++++++++
 drivers/pwrseq/core.h                              |   37 +++++
 drivers/pwrseq/method.c                            |   38 +++++
 include/linux/pwrseq.h                             |   50 ++++++
 7 files changed, 351 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/pwrseq/pwrseq.txt
 create mode 100644 drivers/pwrseq/Makefile
 create mode 100644 drivers/pwrseq/core.c
 create mode 100644 drivers/pwrseq/core.h
 create mode 100644 drivers/pwrseq/method.c
 create mode 100644 include/linux/pwrseq.h

diff --git a/Documentation/devicetree/bindings/pwrseq/pwrseq.txt b/Documentation/devicetree/bindings/pwrseq/pwrseq.txt
new file mode 100644
index 0000000..80848ae
--- /dev/null
+++ b/Documentation/devicetree/bindings/pwrseq/pwrseq.txt
@@ -0,0 +1,48 @@
+Power sequence DT bindings
+
+Each power sequence method has a corresponding "power-method" property string.
+This property shall be set in a subnode for a device. That subnode should also
+describe resourses which are specific to that power method.
+
+Do note, power sequences as such isn't encoded through DT. Instead those are
+implemented by each power method.
+
+Required subnode properties:
+- power-method: should contain the string for the power method to bind.
+
+	Supported power methods: None.
+
+Example:
+
+Note, the "clock" power method in this example isn't actually supported, but
+used to visualize how a childnode could be described.
+
+// WLAN SDIO channel
+sdi1_per2@80118000 {
+	compatible = "arm,pl18x", "arm,primecell";
+	reg = <0x80118000 0x1000>;
+	interrupts = <0 50 IRQ_TYPE_LEVEL_HIGH>;
+
+	dmas = <&dma 32 0 0x2>, /* Logical - DevToMem */
+	       <&dma 32 0 0x0>; /* Logical - MemToDev */
+	dma-names = "rx", "tx";
+
+	clocks = <&prcc_kclk 2 4>, <&prcc_pclk 2 6>;
+	clock-names = "sdi", "apb_pclk";
+
+	arm,primecell-periphid = <0x10480180>;
+	max-frequency = <100000000>;
+	bus-width = <4>;
+	non-removable;
+	pinctrl-names = "default", "sleep";
+	pinctrl-0 = <&sdi1_default_mode>;
+	pinctrl-1 = <&sdi1_sleep_mode>;
+
+	status = "okay";
+
+	pwrseq: pwrseq1 {
+		power-method = "clock";
+		clocks = <&someclk 1 2>, <&someclk 3 4>;
+		clock-names = "pwrseq1", "pwrseq2";
+	};
+};
diff --git a/drivers/Makefile b/drivers/Makefile
index f98b50d..ac1bf5b 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -128,7 +128,7 @@ endif
 obj-$(CONFIG_DCA)		+= dca/
 obj-$(CONFIG_HID)		+= hid/
 obj-$(CONFIG_PPC_PS3)		+= ps3/
-obj-$(CONFIG_OF)		+= of/
+obj-$(CONFIG_OF)		+= of/ pwrseq/
 obj-$(CONFIG_SSB)		+= ssb/
 obj-$(CONFIG_BCMA)		+= bcma/
 obj-$(CONFIG_VHOST_RING)	+= vhost/
diff --git a/drivers/pwrseq/Makefile b/drivers/pwrseq/Makefile
new file mode 100644
index 0000000..afb914f
--- /dev/null
+++ b/drivers/pwrseq/Makefile
@@ -0,0 +1,2 @@
+#Support for the power sequence subsystem
+obj-y = core.o method.o
diff --git a/drivers/pwrseq/core.c b/drivers/pwrseq/core.c
new file mode 100644
index 0000000..baf7bb6
--- /dev/null
+++ b/drivers/pwrseq/core.c
@@ -0,0 +1,175 @@
+/*
+ * Core of the power sequence subsystem
+ *
+ * Copyright (C) 2014 Linaro Ltd
+ *
+ * Author: Ulf Hansson <ulf.hansson@linaro.org>
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#include <linux/kernel.h>
+#include <linux/export.h>
+#include <linux/device.h>
+#include <linux/string.h>
+#include <linux/err.h>
+#include <linux/of.h>
+
+#include <linux/pwrseq.h>
+#include "core.h"
+
+static int pwrseq_find(const char *power_method)
+{
+	int i;
+
+	for (i = 0; pwrseq_methods[i].bind_method != NULL; i++)
+		if (!strcasecmp(power_method, pwrseq_methods[i].method))
+			return i;
+	return -ENODEV;
+}
+
+static void devm_pwrseq_release(struct device *dev, void *res)
+{
+	struct pwrseq *ps = res;
+
+	dev_dbg(dev, "%s: Release method=%s\n", __func__, ps->method);
+
+	ps->ps_ops->release(ps);
+	of_node_put(ps->np_child);
+}
+
+static struct pwrseq *pwrseq_get(struct device *dev,
+				struct device_node *np,
+				const char *power_method)
+{
+	struct pwrseq *ps;
+	int ret;
+
+	ret = pwrseq_find(power_method);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	ps = devres_alloc(devm_pwrseq_release, sizeof(ps), GFP_KERNEL);
+	if (!ps)
+		return ERR_PTR(-ENOMEM);
+
+	ps->dev = dev;
+	ps->np_child = np;
+	ps->method = pwrseq_methods[ret].method;
+
+	/*
+	 * The on/off states is mandatory to be supported. Additional states
+	 * shall be added by each method during binding.
+	 */
+	ps->supported_states = PWRSEQ_POWER_OFF | PWRSEQ_POWER_ON;
+	/*
+	 * The default current state is PWRSEQ_POWER_OFF, it may be updated
+	 * during binding.
+	 */
+	ps->current_state = PWRSEQ_POWER_OFF;
+
+	ret = pwrseq_methods[ret].bind_method(ps);
+	if (ret) {
+		devres_free(ps);
+		return ERR_PTR(ret);
+	}
+
+	devres_add(dev, ps);
+	return ps;
+}
+
+static int pwrseq_of_find(struct device *dev,
+			struct device_node **np_child,
+			const char **power_method)
+{
+	struct device_node *np;
+	const char *pm;
+
+	if (!dev->of_node)
+		return -ENODEV;
+
+	/* Parse childnodes to find a power-method property. */
+	for_each_child_of_node(dev->of_node, np) {
+		if (!of_property_read_string(np, "power-method", &pm)) {
+			*np_child = np;
+			*power_method = pm;
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+static struct pwrseq *_devm_pwrseq_get(struct device *dev, bool optional)
+{
+	struct pwrseq *ps;
+	struct device_node *np;
+	const char *pm;
+	int ret;
+
+	if (!dev)
+		return ERR_PTR(-ENODEV);
+
+	ret = pwrseq_of_find(dev, &np, &pm);
+	if (ret < 0) {
+		return ERR_PTR(ret);
+	} else if (ret) {
+		ps = pwrseq_get(dev, np, pm);
+		if (IS_ERR(ps))
+			of_node_put(np);
+	} else if (optional) {
+		ps = pwrseq_get(dev, NULL, "dummy");
+	} else {
+		return ERR_PTR(-ENODEV);
+	}
+
+	if (!IS_ERR(ps))
+		dev_dbg(dev, "%s: Bound method=%s\n", __func__, ps->method);
+
+	return ps;
+}
+
+struct pwrseq *devm_pwrseq_get_optional(struct device *dev)
+{
+	return _devm_pwrseq_get(dev, true);
+}
+EXPORT_SYMBOL_GPL(devm_pwrseq_get_optional);
+
+struct pwrseq *devm_pwrseq_get(struct device *dev)
+{
+	return _devm_pwrseq_get(dev, false);
+}
+EXPORT_SYMBOL_GPL(devm_pwrseq_get);
+
+static int devm_pwrseq_match(struct device *dev, void *res, void *data)
+{
+	struct pwrseq **ps = res;
+
+	return *ps == data;
+}
+
+void devm_pwrseq_put(struct pwrseq *ps)
+{
+	devres_release(ps->dev, devm_pwrseq_release, devm_pwrseq_match, ps);
+}
+EXPORT_SYMBOL_GPL(devm_pwrseq_put);
+
+int pwrseq_select_state(struct pwrseq *ps, enum pwrseq_state ps_state)
+{
+	int ret = 0;
+
+	if (ps->current_state != ps_state)
+		ret = ps->ps_ops->select_state(ps, ps_state);
+
+	if (!ret)
+		ps->current_state = ps_state;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pwrseq_select_state);
+
+unsigned int pwrseq_supported_states(struct pwrseq *ps)
+{
+	return ps->supported_states;
+}
+EXPORT_SYMBOL_GPL(pwrseq_supported_states);
diff --git a/drivers/pwrseq/core.h b/drivers/pwrseq/core.h
new file mode 100644
index 0000000..84a6449
--- /dev/null
+++ b/drivers/pwrseq/core.h
@@ -0,0 +1,37 @@
+/*
+ * Core private header for the power sequence subsystem
+ *
+ * Copyright (C) 2014 Linaro Ltd
+ *
+ * Author: Ulf Hansson <ulf.hansson@linaro.org>
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#ifndef __PWRSEQ_PWRSEQ_H
+#define __PWRSEQ_PWRSEQ_H
+
+#include <linux/pwrseq.h>
+
+struct pwrseq_ops {
+	int (*select_state)(struct pwrseq *, enum pwrseq_state);
+	void (*release)(struct pwrseq *);
+};
+
+struct pwrseq {
+	struct device *dev;
+	struct device_node *np_child;
+	const char *method;
+	enum pwrseq_state supported_states;
+	enum pwrseq_state current_state;
+	struct pwrseq_ops *ps_ops;
+	void *data;
+};
+
+struct pwrseq_method {
+	int (*bind_method)(struct pwrseq *);
+	const char *method;
+};
+
+extern struct pwrseq_method pwrseq_methods[];
+#endif
diff --git a/drivers/pwrseq/method.c b/drivers/pwrseq/method.c
new file mode 100644
index 0000000..fe16579
--- /dev/null
+++ b/drivers/pwrseq/method.c
@@ -0,0 +1,38 @@
+/*
+ * Implements a dummy power method for power sequence subsystem
+ *
+ * Copyright (C) 2014 Linaro Ltd
+ *
+ * Author: Ulf Hansson <ulf.hansson@linaro.org>
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#include <linux/kernel.h>
+
+#include <linux/pwrseq.h>
+#include "core.h"
+
+static int pwrseq_dummy_select_state(struct pwrseq *ps, enum pwrseq_state s)
+{
+	return 0;
+}
+
+static void pwrseq_dummy_release(struct pwrseq *ps) { }
+
+static struct pwrseq_ops pwrseq_dummy_ops = {
+	.select_state = pwrseq_dummy_select_state,
+	.release = pwrseq_dummy_release,
+};
+
+static int pwrseq_dummy_bind(struct pwrseq *ps)
+{
+	ps->ps_ops = &pwrseq_dummy_ops;
+	return 0;
+}
+
+/* The extern list of supported power sequence_methods */
+struct pwrseq_method pwrseq_methods[] = {
+	{ pwrseq_dummy_bind, "dummy" },
+	{ NULL, NULL },
+};
diff --git a/include/linux/pwrseq.h b/include/linux/pwrseq.h
new file mode 100644
index 0000000..528b544
--- /dev/null
+++ b/include/linux/pwrseq.h
@@ -0,0 +1,50 @@
+/*
+ * Interface for the power sequence subsystem
+ *
+ * Copyright (C) 2014 Linaro Ltd
+ *
+ * Author: Ulf Hansson <ulf.hansson@linaro.org>
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+#ifndef __LINUX_PWRSEQ_PWRSEQ_H
+#define __LINUX_PWRSEQ_PWRSEQ_H
+
+#include <linux/bitops.h>
+
+struct device;
+struct pwrseq;
+
+enum pwrseq_state {
+	PWRSEQ_POWER_OFF = BIT(0),
+	PWRSEQ_POWER_ON = BIT(1),
+};
+
+#ifdef CONFIG_OF
+extern struct pwrseq *devm_pwrseq_get(struct device *dev);
+extern struct pwrseq *devm_pwrseq_get_optional(struct device *dev);
+extern void devm_pwrseq_put(struct pwrseq *ps);
+extern int pwrseq_select_state(struct pwrseq *ps, unsigned int ps_state);
+extern unsigned int pwrseq_supported_states(struct pwrseq *ps);
+#else
+static inline struct pwrseq *devm_pwrseq_get(struct device *dev)
+{
+	return ERR_PTR(-ENODEV);
+}
+static inline struct pwrseq *devm_pwrseq_get_optional(struct device *dev)
+{
+	return ERR_PTR(-ENODEV);
+}
+static inline void devm_pwrseq_put(struct pwrseq *ps) {}
+static inline int pwrseq_select_state(struct pwrseq *ps,
+				enum pwrseq_state ps_state)
+{
+	return 0;
+}
+static inline unsigned int pwrseq_supported_states(struct pwrseq *ps)
+{
+	return 0;
+}
+#endif
+
+#endif /* __LINUX_PWRSEQ_PWRSEQ_H */
-- 
1.7.9.5

