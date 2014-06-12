Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933549AbaFLQGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:06:50 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51690 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756233AbaFLQGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:06:21 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: <geert+renesas@glider.be>
CC: <laurent.pinchart@ideasonboard.com>, <ulf.hansson@linaro.org>,
        <khilman@linaro.org>, <grant.likely@secretlab.ca>,
        <mturquette@linaro.org>, <tomasz.figa@gmail.com>,
        <ben.dooks@codethink.co.uk>, <horms@verge.net.au>,
        <magnus.damm@gmail.com>, <rjw@rjwysocki.net>,
        <linux-sh@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [RFC PATCH 1/2] clk: of: introduce of_clk_get_from_set()
Date: Thu, 12 Jun 2014 19:53:42 +0300
Message-ID: <1402592023-13416-2-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402592023-13416-1-git-send-email-grygorii.strashko@ti.com>
References: <1398334403-26181-1-git-send-email-geert+renesas@glider.be>
 <1402592023-13416-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In many case it's useful to divide device's clocks into
few sets according to their designation.
- some clocks can be optional for the device
- some clocks can be managed by PM frameworks (like clock_ops for example)
  while some need to be managed by driver directly.

This patch introduces new API of_clk_get_from_set() which allows
the callers to specify additional prefix to be used together with
generic DT clocks list property name "clocks".

In the example bellow, the caller asks CLK framework to retrieve
clock from the clocks list "clkops-clocks" and not from "clocks":
DT:
	usb: usb@2680000 {
		compatible = "ti,keystone-dwc3";
		[...]
		clkops-clocks = <&clkusb>;

Code:
	clk = of_clk_get_from_set(np, "clkops", 0);

This changes will not affect on already existed code.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/clk/clkdev.c |   24 ++++++++++++++++++++++--
 include/linux/clk.h  |    7 +++++++
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index f890b90..2308518 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -53,7 +53,8 @@ struct clk *of_clk_get_by_clkspec(struct of_phandle_args *clkspec)
 	return clk;
 }
 
-struct clk *of_clk_get(struct device_node *np, int index)
+static struct clk *of_clk_get_named(struct device_node *np,
+		const char *propname, int index)
 {
 	struct of_phandle_args clkspec;
 	struct clk *clk;
@@ -62,7 +63,7 @@ struct clk *of_clk_get(struct device_node *np, int index)
 	if (index < 0)
 		return ERR_PTR(-EINVAL);
 
-	rc = of_parse_phandle_with_args(np, "clocks", "#clock-cells", index,
+	rc = of_parse_phandle_with_args(np, propname, "#clock-cells", index,
 					&clkspec);
 	if (rc)
 		return ERR_PTR(rc);
@@ -71,8 +72,27 @@ struct clk *of_clk_get(struct device_node *np, int index)
 	of_node_put(clkspec.np);
 	return clk;
 }
+
+struct clk *of_clk_get(struct device_node *np, int index)
+{
+	return of_clk_get_named(np, "clocks", index);
+}
 EXPORT_SYMBOL(of_clk_get);
 
+struct clk *of_clk_get_from_set(struct device_node *np,
+		const char *set_id, int index)
+{
+	char prop_name[32]; /* 32 is max size of property name */
+
+	if (set_id)
+		snprintf(prop_name, 32, "%s-clocks", set_id);
+	else
+		snprintf(prop_name, 32, "clocks");
+
+	return of_clk_get_named(np, prop_name, index);
+}
+EXPORT_SYMBOL(of_clk_get_from_set);
+
 /**
  * of_clk_get_by_name() - Parse and lookup a clock referenced by a device node
  * @np: pointer to clock consumer node
diff --git a/include/linux/clk.h b/include/linux/clk.h
index fb5e097..fc8865a 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -397,6 +397,8 @@ struct of_phandle_args;
 
 #if defined(CONFIG_OF) && defined(CONFIG_COMMON_CLK)
 struct clk *of_clk_get(struct device_node *np, int index);
+struct clk *of_clk_get_from_set(struct device_node *np,
+		const char *set_id, int index);
 struct clk *of_clk_get_by_name(struct device_node *np, const char *name);
 struct clk *of_clk_get_from_provider(struct of_phandle_args *clkspec);
 #else
@@ -409,6 +411,11 @@ static inline struct clk *of_clk_get_by_name(struct device_node *np,
 {
 	return ERR_PTR(-ENOENT);
 }
+static inline struct clk *of_clk_get_from_set(struct device_node *np,
+					const char *set_id, int index)
+{
+	return ERR_PTR(-ENOENT);
+}
 #endif
 
 #endif
-- 
1.7.9.5

