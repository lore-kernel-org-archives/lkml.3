Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbbAEPsZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:48:25 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:55683 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269AbbAEPsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:48:20 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-8b-54aab2417956
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Pavel Machek <pavel@ucw.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RFC PATCHv2 01/19] power_supply: Add driver private data
Date: Mon, 05 Jan 2015 16:47:44 +0100
Message-id: <1420472882-10463-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420472882-10463-1-git-send-email-k.kozlowski@samsung.com>
References: <1420472882-10463-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKLMWRmVeSWpSXmKPExsVy+t/xa7qOm1aFGBydJG8x6cl7ZouJKycz
	W7x+YWix8+FbNovl+/oZLTY9vsZqcXnXHDaLz71HGC3unjrKZnHm9CVWi9O7Sxy4PXbOusvu
	sXmFlsemVZ1sHpuX1HtsudrO4tG3ZRWjx4rV39k9Pm+SC+CI4rJJSc3JLEst0rdL4Mp4+PcT
	S0GjYMXL3SvZGhhX83UxcnBICJhIHPvH3sXICWSKSVy4t56ti5GLQ0hgKaPEwqmfGCGcPiaJ
	HY8fsIFUsQkYS2xevgSsSkTgCZPE9NaTLCAJZgFDiZ/v/oCNEhZwkviybguYzSKgKjFx2VUm
	EJtXwF3i/eoVUOvkJE4em8wKYnMKeEg0/b0ANkcIqObDs1+sExh5FzAyrGIUTS1NLihOSs81
	1CtOzC0uzUvXS87P3cQICcovOxgXH7M6xCjAwajEw+txYmWIEGtiWXFl7iFGCQ5mJRHeV+mr
	QoR4UxIrq1KL8uOLSnNSiw8xMnFwSjUwhmwrPX3n+yOmr0VyWee7j94SLD9oVRbl+N4iV7gq
	+Ewe82zj1QGvnXcnHk1dv0F+x4vudxJKU/Wv5Wt0vLk4y2z1p07j+9o/RBvm6iiqqd5JmHdG
	74X8P/Zs29jzM0KSVCQ/H5syu/K0c7hZEsfhwJZF57s63FMndtdeSZ7Wb7X0vXF++wppJZbi
	jERDLeai4kQAfs7msSgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow drivers to store private data inside power_supply structure for
later usage in power supply operations.

Usage of driver private data is necessary to access driver's state
container object from power supply calls (like get_property()) if struct
'power_supply' is a stored there as a pointer, for example:

struct some_driver_info {
	struct i2c_client       *client;
	struct power_supply     *power_supply;
	...
}

In such case one cannot use container_of() and must store pointer to
state container as private data.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/power/power_supply_core.c | 6 ++++++
 include/linux/power_supply.h      | 4 ++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index 694e8cddd5c1..84ef3f40e7bf 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -629,6 +629,12 @@ void power_supply_unregister(struct power_supply *psy)
 }
 EXPORT_SYMBOL_GPL(power_supply_unregister);
 
+void *power_supply_get_drvdata(struct power_supply *psy)
+{
+	return psy->drv_data;
+}
+EXPORT_SYMBOL_GPL(power_supply_get_drvdata);
+
 static int __init power_supply_class_init(void)
 {
 	power_supply_class = class_create(THIS_MODULE, "power_supply");
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 096dbced02ac..a5743f24e03e 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -209,6 +209,9 @@ struct power_supply {
 	/* For APM emulation, think legacy userspace. */
 	int use_for_apm;
 
+	/* Driver private data */
+	void *drv_data;
+
 	/* private */
 	struct device *dev;
 	struct work_struct changed_work;
@@ -281,6 +284,7 @@ extern int power_supply_register_no_ws(struct device *parent,
 extern void power_supply_unregister(struct power_supply *psy);
 extern int power_supply_powers(struct power_supply *psy, struct device *dev);
 
+extern void *power_supply_get_drvdata(struct power_supply *psy);
 /* For APM emulation, think legacy userspace. */
 extern struct class *power_supply_class;
 
-- 
1.9.1

