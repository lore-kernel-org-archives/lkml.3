Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab3HWPE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 11:04:56 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:23650 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab3HWPEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 11:04:54 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-aa-52177a14f7fe
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, mturquette@linaro.org, jiada_wang@mentor.com,
        broonie@kernel.org, vapier@gentoo.org, ralf@linux-mips.org,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
        shawn.guo@linaro.org, sebastian.hesselbarth@gmail.com,
        LW@KARO-electronics.de, t.figa@samsung.com, g.liakhovetski@gmx.de,
        laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v3 1/5] clk: Provide not locked variant of
 of_clk_get_from_provider()
Date: Fri, 23 Aug 2013 17:03:43 +0200
Message-id: <1377270227-1030-2-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1377270227-1030-1-git-send-email-s.nawrocki@samsung.com>
References: <1377270227-1030-1-git-send-email-s.nawrocki@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsVy+t9jAV2RKvEgg1//zSymPnzCZvF+4zwm
	i54/lRZnm96wW3ROXMJusenxNVaLy7vmsFlMmDqJ3WLOnynMFrcv81oceLKczeLphItsFrcb
	V7BZXNqjYnH4TTurxfufjhZP1y1htlg/4zWLxcKGL+wWNyf8YHYQ8Whp7mHzWDnd2+Py9zfM
	Hjtn3WX3+PAxzmN2x0xWj/nTHzF7bFrVyeZx59oeNo+jK9cyeWxeUu+x+2sTo0ffllWMHp83
	yQXwRXHZpKTmZJalFunbJXBlbNtzkrXgrFzFseVr2RsYd0p2MXJySAiYSDyc28gIYYtJXLi3
	nq2LkYtDSGARo8TS6evZIZwOJon+I/PYQKrYBAwleo/2gXWICGhITOl6DFbELNDLIjFl8k0W
	kISwQLjEke/XmUFsFgFViUOXZ4PFeQVcJTp/zWDtYuQAWqcgMWeSDUiYU8BNonnNWSaQsBBQ
	yd8tmhMYeRcwMqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI6RZ9I7GFc1WBxiFOBgVOLh
	neAsFiTEmlhWXJl7iFGCg1lJhHdnnniQEG9KYmVValF+fFFpTmrxIUZpDhYlcd6DrdaBQgLp
	iSWp2ampBalFMFkmDk6pBsYVHusW3ptg18VSffqm461AH7tyf/vrnUwm6dXpWpPWHNDmfLLT
	Nbrmx7PITql21p+nHL7FOhSlr2ibsn31agHeg42Xz1aUv17zNvOPrNTc4+nhRjluPsF1iRMU
	IzUenNN8JFgz34pNzfHkJBuBFj4zjiPPjh7sWrU97N1XJut1L4V1IktVG5VYijMSDbWYi4oT
	AQI2klSNAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add helper functions for the of_clk_providers list locking and
an unlocked variant of of_clk_get_from_provider().
These functions are intended to be used in the clkdev to avoid
race condition in the device tree based clock look up in clk_get().

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
Changes since v2:
 - fixed typo in clk.h.

Changes since v1:
 - moved the function declaractions to a local header.
---
 drivers/clk/clk.c |   38 ++++++++++++++++++++++++++++++--------
 drivers/clk/clk.h |   16 ++++++++++++++++
 2 files changed, 46 insertions(+), 8 deletions(-)
 create mode 100644 drivers/clk/clk.h

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 54a191c..eb3207e 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -21,6 +21,8 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 
+#include "clk.h"
+
 static DEFINE_SPINLOCK(enable_lock);
 static DEFINE_MUTEX(prepare_lock);
 
@@ -1990,7 +1992,18 @@ static const struct of_device_id __clk_of_table_sentinel
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
@@ -2034,9 +2047,9 @@ int of_clk_add_provider(struct device_node *np,
 	cp->data = data;
 	cp->get = clk_src_get;
 
-	mutex_lock(&of_clk_lock);
+	mutex_lock(&of_clk_mutex);
 	list_add(&cp->link, &of_clk_providers);
-	mutex_unlock(&of_clk_lock);
+	mutex_unlock(&of_clk_mutex);
 	pr_debug("Added clock from %s\n", np->full_name);
 
 	return 0;
@@ -2051,7 +2064,7 @@ void of_clk_del_provider(struct device_node *np)
 {
 	struct of_clk_provider *cp;
 
-	mutex_lock(&of_clk_lock);
+	mutex_lock(&of_clk_mutex);
 	list_for_each_entry(cp, &of_clk_providers, link) {
 		if (cp->node == np) {
 			list_del(&cp->link);
@@ -2060,24 +2073,33 @@ void of_clk_del_provider(struct device_node *np)
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
index 0000000..795cc9f
--- /dev/null
+++ b/drivers/clk/clk.h
@@ -0,0 +1,16 @@
+/*
+ * linux/drivers/clk/clk.h
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
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

