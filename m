Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab3HTRgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 13:36:04 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:21591 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab3HTRgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 13:36:01 -0400
X-AuditID: cbfee61b-b7efe6d000007b11-ea-5213a8ffc1d4
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, mturquette@linaro.org, jiada_wang@mentor.com,
        robherring2@gmail.com, grant.likely@linaro.org, broonie@kernel.org,
        vapier@gentoo.org, ralf@linux-mips.org, kyungmin.park@samsung.com,
        shawn.guo@linaro.org, sebastian.hesselbarth@gmail.com,
        LW@KARO-electronics.de, t.figa@samsung.com, g.liakhovetski@gmx.de,
        laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 3/4] clk: Provide not locked variant of
 of_clk_get_from_provider()
Date: Tue, 20 Aug 2013 19:34:22 +0200
Message-id: <1377020063-30213-4-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1377020063-30213-1-git-send-email-s.nawrocki@samsung.com>
References: <1377020063-30213-1-git-send-email-s.nawrocki@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsVy+t9jQV2GlcJBBkvusVtMffiEzeL9xnlM
	Fgf+7GC06PlTaXG26Q27RefEJewWmx5fY7W4vGsOm8WEqZPYLeb8mcJscfsyr8WBJ8vZLJ5O
	uMhmcWmPisX3b9/YLA6/aWe1eP/T0eLpuiXMFutnvGaxWNjwhd3i5oQfzA6iHi3NPWweK6d7
	e1z+/obZY+esu+weHz7GeczumMnqMX/6I2aPTas62TzuXNvD5nF05Vomj81L6j12f21i9Ojb
	sorR4/MmuQC+KC6blNSczLLUIn27BK6MYzvTC17IVnx5fImlgfGZRBcjJ4eEgInEo6+72SFs
	MYkL99azdTFycQgJTGeUOLntOpTTwSTxcsJZNpAqNgFDid6jfYwgtoiAhsSUrsfsIEXMAotZ
	JLZtXsQMkhAWCJd4e/sVWBGLgKrE3H2HwOK8Am4Sm/qvA9kcQOsUJOZMsgEJcwq4S0w4uYMV
	xBYCKnk0YR7rBEbeBYwMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCo+WZ9A7GVQ0WhxgF
	OBiVeHg3FAoHCbEmlhVX5h5ilOBgVhLh3ZYBFOJNSaysSi3Kjy8qzUktPsQozcGiJM57sNU6
	UEggPbEkNTs1tSC1CCbLxMEp1cCocUG9Le5c+1n+6577pnxYekVepGxzkduppWYsikXiv5M1
	F77PbiwVvawy+f3EPWaRzwwv/cg58efjdV1zHZUDy9IusQj0Mu3b8e15wNFzAdem3Clw2Rsa
	uvCqRRnrE+uF/CuWa3Zd4ktOvZO65s+Eb6cZPWeUTlRmtLKO6/wUs4q54PC9JE5nJZbijERD
	Leai4kQAx6GEkZICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add helper functions for the of_clk_providers list locking and
an unlocked variant of of_clk_get_from_provider().
These functions are intended to be used in the clkdev to avoid
race condition in the device tree based clock look up in clk_get().

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Changes since v1:
 - moved the function declaractions to a local header.
---
 drivers/clk/clk.c |   38 ++++++++++++++++++++++++++++++--------
 drivers/clk/clk.h |   16 ++++++++++++++++
 2 files changed, 46 insertions(+), 8 deletions(-)
 create mode 100644 drivers/clk/clk.h

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 549fcb7..0a90582 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -21,6 +21,8 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 
+#include "clk.h"
+
 static DEFINE_SPINLOCK(enable_lock);
 static DEFINE_MUTEX(prepare_lock);
 
@@ -2132,7 +2134,18 @@ static const struct of_device_id __clk_of_table_sentinel
 	__used __section(__clk_of_table_end);
 
 static LIST_HEAD(of_clk_providers);
-static DEFINE_MUTEX(of_clk_lock);
+static DEFINE_MUTEX(of_clk_mutex);
+
+/* of_clk_provider list locking helpers */
+void of_clk_lock(void)
+{
+	mutex_lock(&of_clk_mutex);
+}
+
+void of_clk_unlock(void)
+{
+	mutex_unlock(&of_clk_mutex);
+}
 
 struct clk *of_clk_src_simple_get(struct of_phandle_args *clkspec,
 				     void *data)
@@ -2176,9 +2189,9 @@ int of_clk_add_provider(struct device_node *np,
 	cp->data = data;
 	cp->get = clk_src_get;
 
-	mutex_lock(&of_clk_lock);
+	mutex_lock(&of_clk_mutex);
 	list_add(&cp->link, &of_clk_providers);
-	mutex_unlock(&of_clk_lock);
+	mutex_unlock(&of_clk_mutex);
 	pr_debug("Added clock from %s\n", np->full_name);
 
 	return 0;
@@ -2193,7 +2206,7 @@ void of_clk_del_provider(struct device_node *np)
 {
 	struct of_clk_provider *cp;
 
-	mutex_lock(&of_clk_lock);
+	mutex_lock(&of_clk_mutex);
 	list_for_each_entry(cp, &of_clk_providers, link) {
 		if (cp->node == np) {
 			list_del(&cp->link);
@@ -2202,24 +2215,33 @@ void of_clk_del_provider(struct device_node *np)
 			break;
 		}
 	}
-	mutex_unlock(&of_clk_lock);
+	mutex_unlock(&of_clk_mutex);
 }
 EXPORT_SYMBOL_GPL(of_clk_del_provider);
 
-struct clk *of_clk_get_from_provider(struct of_phandle_args *clkspec)
+struct clk *__of_clk_get_from_provider(struct of_phandle_args *clkspec)
 {
 	struct of_clk_provider *provider;
 	struct clk *clk = ERR_PTR(-ENOENT);
 
 	/* Check if we have such a provider in our array */
-	mutex_lock(&of_clk_lock);
 	list_for_each_entry(provider, &of_clk_providers, link) {
 		if (provider->node == clkspec->np)
 			clk = provider->get(clkspec, provider->data);
 		if (!IS_ERR(clk))
 			break;
 	}
-	mutex_unlock(&of_clk_lock);
+
+	return clk;
+}
+
+struct clk *of_clk_get_from_provider(struct of_phandle_args *clkspec)
+{
+	struct clk *clk;
+
+	mutex_lock(&of_clk_mutex);
+	clk = __of_clk_get_from_provider(clkspec);
+	mutex_unlock(&of_clk_mutex);
 
 	return clk;
 }
diff --git a/drivers/clk/clk.h b/drivers/clk/clk.h
new file mode 100644
index 0000000..4f7d09c
--- /dev/null
+++ b/drivers/clk/clk.h
@@ -0,0 +1,16 @@
+/*
+ * linux/drivers/clk/clk.h
+ *
+ * Copyright (C) 2013 Samsung Electroncs Co., Ltd.
+ * Sylwester Nawrocki <s.nawrocki@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#if defined(CONFIG_OF) && defined(CONFIG_COMMON_CLK)
+struct clk *__of_clk_get_from_provider(struct of_phandle_args *clkspec);
+void of_clk_lock(void);
+void of_clk_unlock(void);
+#endif
-- 
1.7.9.5

