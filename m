Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbaCaQm5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 12:42:57 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:19462 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbaCaQmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 12:42:55 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-36-53399b0d8199
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org,
        mturquette@linaro.org, linux@arm.linux.org.uk, robh+dt@kernel.org,
        grant.likely@linaro.org, mark.rutland@arm.com, galak@codeaurora.org,
        kyungmin.park@samsung.com, sw0312.kim@samsung.com,
        m.szyprowski@samsung.com, t.figa@samsung.com,
        laurent.pinchart@ideasonboard.com, s.hauer@pengutronix.de,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC v4 1/2] clk: Add function parsing arbitrary clock list DT
 property
Date: Mon, 31 Mar 2014 18:41:55 +0200
Message-id: <1396284116-19178-2-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1396284116-19178-1-git-send-email-s.nawrocki@samsung.com>
References: <1396284116-19178-1-git-send-email-s.nawrocki@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t9jAV3e2ZbBBhPem1jMP3KO1aL/zUJW
	iwN/djBaNC9ez2ZxtukNu0XnxCXsFpseX2O1uLxrDpvF7cu8FmuP3GW3WHr9IpPF0wkX2Sxa
	9x5ht/i7fROLxeE37awWMya/ZLNYP+M1i4Ogx5p5axg9Wpp72Dwu9/UyeczumMnqsWlVJ5vH
	nWt72Dz2z13D7rF5Sb1H/18Dj74tqxg9Pm+SC+CO4rJJSc3JLEst0rdL4Mo4vv8pa8E/iYqb
	+86zNTAeEOli5OSQEDCReHV8NxOELSZx4d56ti5GLg4hgUWMEpffnWeHcDqYJP68m8MIUsUm
	YCjRe7QPzBYRsJHo2XKSEaSIWWA+s8TxJyfYQBLCAhESZ26tYAaxWQRUJXb294A18Aq4SZx4
	cJO1i5EDaJ2CxJxJNiBhTgF3iUXbvoKVCAGVzH26iXkCI+8CRoZVjKKpBckFxUnpuYZ6xYm5
	xaV56XrJ+bmbGMEB/0xqB+PKBotDjAIcjEo8vBbllsFCrIllxZW5hxglOJiVRHiPTAcK8aYk
	VlalFuXHF5XmpBYfYpTmYFES5z3Qah0oJJCeWJKanZpakFoEk2Xi4JRqYEz3lW4ueTh/ZX9H
	A9uNZ53bg+Tawiar2ySu3H6tsJH78tKex2tEdrj+DJ6pmpK5K/5Gdgr/vQsLHlqvb+Vjlnqk
	135hk1j4xKuLjwgtPS+kbHkmUzWIj2++cKDx2kUTF1pxX/poxcC4gFvo7m32yTqnWOvex4qZ
	Xm8tPHVJUmch37+Ut9dczJRYijMSDbWYi4oTAVvA/N90AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The of_clk_get_by_property() function added by this patch is similar to
of_clk_get(), except it allows to pass name of a DT property containing
list of phandles and clock specifiers. For of_clk_get() this has been
hard coded to "clocks".

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
Changes since v3:
 - added missing 'static inline' to the function stub definition.

Changes since v2:
 - moved the function declaration from drivers/clk/clk.h to
   include/linux/clk.h

Changes since v1:
 - s/of_clk_get_list_entry/of_clk_get_by_property.
---
 drivers/clk/clkdev.c |   25 +++++++++++++++++++++----
 include/linux/clk.h  |    7 +++++++
 2 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index a360b2e..1d41540 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -27,17 +27,28 @@ static LIST_HEAD(clocks);
 static DEFINE_MUTEX(clocks_mutex);
 
 #if defined(CONFIG_OF) && defined(CONFIG_COMMON_CLK)
-struct clk *of_clk_get(struct device_node *np, int index)
+/**
+ * of_clk_get_by_property() - Parse and lookup a clock referenced by a device node
+ * @np: pointer to clock consumer node
+ * @list_name: name of the clock list property
+ * @index: index to the clock list
+ *
+ * This function parses the @list_name property and together with @index
+ * value indicating an entry of the list uses it to look up the struct clk
+ * from the registered list of clock providers.
+ */
+struct clk *of_clk_get_by_property(struct device_node *np,
+				   const char *list_name, int index)
 {
 	struct of_phandle_args clkspec;
 	struct clk *clk;
 	int rc;
 
-	if (index < 0)
+	if (index < 0 || !list_name)
 		return ERR_PTR(-EINVAL);
 
-	rc = of_parse_phandle_with_args(np, "clocks", "#clock-cells", index,
-					&clkspec);
+	rc = of_parse_phandle_with_args(np, list_name, "#clock-cells",
+					index, &clkspec);
 	if (rc)
 		return ERR_PTR(rc);
 
@@ -51,6 +62,12 @@ struct clk *of_clk_get(struct device_node *np, int index)
 	of_node_put(clkspec.np);
 	return clk;
 }
+EXPORT_SYMBOL(of_clk_get_by_property);
+
+struct clk *of_clk_get(struct device_node *np, int index)
+{
+	return of_clk_get_by_property(np, "clocks", index);
+}
 EXPORT_SYMBOL(of_clk_get);
 
 /**
diff --git a/include/linux/clk.h b/include/linux/clk.h
index fb5e097..f3811d3 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -397,6 +397,8 @@ struct of_phandle_args;
 
 #if defined(CONFIG_OF) && defined(CONFIG_COMMON_CLK)
 struct clk *of_clk_get(struct device_node *np, int index);
+struct clk *of_clk_get_by_property(struct device_node *np,
+				   const char *list_name, int index);
 struct clk *of_clk_get_by_name(struct device_node *np, const char *name);
 struct clk *of_clk_get_from_provider(struct of_phandle_args *clkspec);
 #else
@@ -409,6 +411,11 @@ static inline struct clk *of_clk_get_by_name(struct device_node *np,
 {
 	return ERR_PTR(-ENOENT);
 }
+static inline struct clk *of_clk_get_by_property(struct device_node *np,
+				   const char *list_name, int index)
+{
+	return ERR_PTR(-ENOENT);
+}
 #endif
 
 #endif
-- 
1.7.9.5

