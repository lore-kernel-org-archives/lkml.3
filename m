Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbaKDPNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:13:15 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:16747 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbaKDPKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:10:48 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-8d-5458ec761ffb
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org
Cc: Anton Vorontsov <anton@enomsg.org>, Pavel Machek <pavel@ucw.cz>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH RESEND v2 1/7] power_supply: Add power_supply_put for
 decrementing device reference counter
Date: Tue, 04 Nov 2014 16:10:30 +0100
Message-id: <1415113836-26098-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1415113836-26098-1-git-send-email-k.kozlowski@samsung.com>
References: <1415113836-26098-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsVy+t/xy7plbyJCDGZMkLM4uFXTYuOM9awW
	S5oyLCY9ec9sMXHlZGaLaRvFLV6/MLRYtvgpo8XZpjfsFve/HmW0mPJnOZPFpsfXWC0u75rD
	ZvG59wijxcelG1gt1h65y25x6cACJou7p46yWTxe8Zbd4nQ3q8Xp3SUWmzdNZbb4seExq4O4
	x4T+T4weO2fdZfdYsKnUY/MKLY/Fe14yeWxa1cnmcefaHjaPd+fOsXvMOxnosXlJvcfHp7dY
	PN7vu8rm0bdlFaPHitXf2T0+b5LzONHyhTVAIIrLJiU1J7MstUjfLoEr49njO+wFLXIVC/9u
	YGtgnC3ZxcjJISFgItF46SorhC0mceHeerYuRi4OIYGljBJP3z9ggXD6mCSeTp3GCFLFJmAs
	sXn5ErAqEYFGVolzW98wgTjMAh1MErdbdoLNEhbIlWiYto4JxGYRUJU4/uwzG4jNK+AucXv9
	PEaIfXISJ49NBqvnFPCQ2Nnynx3EFgKqebNxO+sERt4FjAyrGEVTS5MLipPScw31ihNzi0vz
	0vWS83M3MUKi6ssOxsXHrA4xCnAwKvHwZqhHhAixJpYVV+YeYpTgYFYS4VV/DBTiTUmsrEot
	yo8vKs1JLT7EyMTBKdXAGPX4U6Nje6/D6Vc/S7jK5j+67MLyyOVV60n51vy0k3dfMnVItPXv
	Mp9zYMmZC9lpN86WPjn/4LjWT7EGy30/FC/LqdU+XlAlo3rhUXjAt5OF+z4lSq6zzfj+LnKB
	6zLFPr57n/dsKTRL3/c0POGsLNu8+x22aRFtOxYvXpp1aU7Y1ozLyrqPPimxFGckGmoxFxUn
	AgCplyWBiAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The power_supply_get_by_phandle() and power_supply_get_by_name() use
function class_find_device() for obtaining the reference to power
supply. Each use of class_find_device() increases the power supply's
device reference counter.

However the reference counter was not decreased by users of this API.
Thus final device_unregister() call from power_supply_unregister() could
not release the device and clean up its resources. This lead to memory
leak if at least once power_supply_get_by_*() was called between
registering and unregistering the power supply.

Add and document new API power_supply_put() for decrementing the
reference counter.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/power/power_supply_core.c | 38 ++++++++++++++++++++++++++++++++++++++
 include/linux/power_supply.h      |  1 +
 2 files changed, 39 insertions(+)

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index bd8f5be0d976..cf860d2fd8c9 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -331,6 +331,17 @@ static int power_supply_match_device_by_name(struct device *dev, const void *dat
 	return strcmp(psy->name, name) == 0;
 }
 
+/**
+ * power_supply_get_by_name() - Search for a power supply and returns its ref
+ * @name: Power supply name to fetch
+ *
+ * If power supply was found, it increases reference count for the
+ * internal power supply's device. The user should power_supply_put()
+ * after usage.
+ *
+ * Return: On success returns a reference to a power supply with
+ * matching name equals to @name, a NULL otherwise.
+ */
 struct power_supply *power_supply_get_by_name(const char *name)
 {
 	struct device *dev = class_find_device(power_supply_class, NULL, name,
@@ -340,12 +351,39 @@ struct power_supply *power_supply_get_by_name(const char *name)
 }
 EXPORT_SYMBOL_GPL(power_supply_get_by_name);
 
+/**
+ * power_supply_put() - Drop reference obtained with power_supply_get_by_name
+ * @psy: Reference to put
+ *
+ * The reference to power supply should be put before unregistering
+ * the power supply.
+ */
+void power_supply_put(struct power_supply *psy)
+{
+	might_sleep();
+
+	put_device(psy->dev);
+}
+EXPORT_SYMBOL_GPL(power_supply_put);
+
 #ifdef CONFIG_OF
 static int power_supply_match_device_node(struct device *dev, const void *data)
 {
 	return dev->parent && dev->parent->of_node == data;
 }
 
+/**
+ * power_supply_get_by_phandle() - Search for a power supply and returns its ref
+ * @np: Pointer to device node holding phandle property
+ * @phandle_name: Name of property holding a power supply name
+ *
+ * If power supply was found, it increases reference count for the
+ * internal power supply's device. The user should power_supply_put()
+ * after usage.
+ *
+ * Return: On success returns a reference to a power supply with
+ * matching name equals to value under @property, NULL or ERR_PTR otherwise.
+ */
 struct power_supply *power_supply_get_by_phandle(struct device_node *np,
 							const char *property)
 {
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 0ef515301aaf..9abb2aef55eb 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -262,6 +262,7 @@ extern struct atomic_notifier_head power_supply_notifier;
 extern int power_supply_reg_notifier(struct notifier_block *nb);
 extern void power_supply_unreg_notifier(struct notifier_block *nb);
 extern struct power_supply *power_supply_get_by_name(const char *name);
+extern void power_supply_put(struct power_supply *psy);
 #ifdef CONFIG_OF
 extern struct power_supply *power_supply_get_by_phandle(struct device_node *np,
 							const char *property);
-- 
1.9.1

