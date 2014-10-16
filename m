Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbaJPHmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 03:42:24 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36852 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaJPHmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 03:42:19 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-50-543f76d86d24
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org
Cc: Anton Vorontsov <anton@enomsg.org>, Pavel Machek <pavel@ucw.cz>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH v2 1/7] power_supply: Add power_supply_put for decrementing
 device reference counter
Date: Thu, 16 Oct 2014 09:42:01 +0200
Message-id: <1413445327-24862-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413445327-24862-1-git-send-email-k.kozlowski@samsung.com>
References: <1413445327-24862-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsVy+t/xa7o3y+xDDLbdYbQ4uFXTYuOM9awW
	S5oyLCY9ec9sMXHlZGaLaRvFLV6/MLRYtvgpo8XZpjfsFve/HmW0mPJnOZPFpsfXWC0u75rD
	ZvG59wijxcelG1gt1h65y25x6cACJou7p46yWTxe8Zbd4nQ3q8Xp3SUWmzdNZbb4seExq4O4
	x4T+T4weO2fdZfdYsKnUY/MKLY/Fe14yeWxa1cnmcefaHjaPd+fOsXvMOxnosXlJvcfHp7dY
	PN7vu8rm0bdlFaPHitXf2T0+b5LzONHyhTVAIIrLJiU1J7MstUjfLoEr4+jaF4wFLXIVO183
	MTYwzpbsYuTkkBAwkVh6ejYThC0mceHeerYuRi4OIYGljBLP39xjhXD6mCS2frrPDFLFJmAs
	sXn5ErAqEYFNrBLbVixgAnGYBa4zSqy+epu9i5GDQ1ggTeLsizyQBhYBVYndbXtZQWxeAXeJ
	P0sXskCsk5M4eWwyWJxTwEPif+9csDOEgGruvmlnncDIu4CRYRWjaGppckFxUnquoV5xYm5x
	aV66XnJ+7iZGSEx92cG4+JjVIUYBDkYlHl6NYPsQIdbEsuLK3EOMEhzMSiK8zYVAId6UxMqq
	1KL8+KLSnNTiQ4xMHJxSDYyJL2Ou5M/6abFy3W7ePbvNfV5PSqp825a7dvbLKI6Veo8uuyyb
	MjPkhKmQy5+pl7rTVJwcHHVn/dufWHVZQsGalyWw+sycrVlfa2Y0ul+b80M5hVvrbPYL1ux/
	k+7rufB1JnGHrO4892Z/W5zkq0hLnct7/0uwXlkt5Hlh7d+/AsGOVjfmP3+gxFKckWioxVxU
	nAgAMI/fK4cCAAA=
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
index 94f278cf2cbb..db368527c65b 100644
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
index 44e749c65505..1b6db883e090 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -256,6 +256,7 @@ extern struct atomic_notifier_head power_supply_notifier;
 extern int power_supply_reg_notifier(struct notifier_block *nb);
 extern void power_supply_unreg_notifier(struct notifier_block *nb);
 extern struct power_supply *power_supply_get_by_name(const char *name);
+extern void power_supply_put(struct power_supply *psy);
 #ifdef CONFIG_OF
 extern struct power_supply *power_supply_get_by_phandle(struct device_node *np,
 							const char *property);
-- 
1.9.1

