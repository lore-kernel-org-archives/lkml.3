Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545AbaC0MTm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 08:19:42 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:49387 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbaC0MTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 08:19:40 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-b7-5334175a6a6b
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: mturquette@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        gregkh@linuxfoundation.org, linux@arm.linux.org.uk, robh+dt@kernel.org,
        grant.likely@linaro.org, mark.rutland@arm.com, galak@codeaurora.org,
        kyungmin.park@samsung.com, sw0312.kim@samsung.com,
        m.szyprowski@samsung.com, t.figa@samsung.com,
        linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC v3 1/2] clk: Add function parsing arbitrary clock list DT
 property
Date: Thu, 27 Mar 2014 13:16:18 +0100
Message-id: <1395922579-28547-2-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1395922579-28547-1-git-send-email-s.nawrocki@samsung.com>
References: <1395922579-28547-1-git-send-email-s.nawrocki@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jAd0ocZNgg82tZhbzj5xjteh/s5DV
	4sCfHYwWzYvXs1mcbXrDbrHp8TVWi8u75rBZ3L7Ma7H2yF12i6XXLzJZPJ1wkc2ide8RdovD
	b9pZLWZMfslmsX7GaxYHfo8189YwerQ097B5XO7rZfLYtKqTzePOtT1sHvvnrmH32Lyk3qNv
	yypGj8+b5AI4o7hsUlJzMstSi/TtErgy9vR0MBXMkKiY9OEfcwPjO+EuRk4OCQETiW+t/ewQ
	tpjEhXvr2UBsIYFFjBLbGqy6GLmA7A4miQmnfrCAJNgEDCV6j/YxgtgiApISDz5PZwEpYhZo
	Z5ZYO2UTWJGwQIRE+8InYJNYBFQlVj2dDWbzCrhJfD13H2gbB9A2BYk5k2xAwpwC7hK731xh
	gVjsJvHk2H/GCYy8CxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEB/Iz6R2MqxosDjEK
	cDAq8fDuuG8ULMSaWFZcmXuIUYKDWUmE97awSbAQb0piZVVqUX58UWlOavEhRmkOFiVx3oOt
	1oFCAumJJanZqakFqUUwWSYOTqkGRrbo/S5aT1IeWtR3u096x6ZzrjfhiK3I54PVrMEbdK/I
	df9+8tNK86RHgNY9r+cLKzuL5nPs/Lww8ITU902WihoB6pv+ZpRt7HitpHf8jNhBnWuFU3/v
	l7/15iaf1d+q197zywW7G3js7xUa+YY0PGj7u1Qg8vCM2HsJsecvff95YMLH4o1zXiuxFGck
	GmoxFxUnAgAK6SPHYAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The of_clk_get_by_property() function added by this patch is similar to
of_clk_get(), except it allows to pass name of a DT property containing
list of phandles and clock specifiers. For of_clk_get() this has been
hard coded to "clocks".

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
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
index 0dd9114..f71235b 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -383,6 +383,8 @@ struct of_phandle_args;
 
 #if defined(CONFIG_OF) && defined(CONFIG_COMMON_CLK)
 struct clk *of_clk_get(struct device_node *np, int index);
+struct clk *of_clk_get_by_property(struct device_node *np,
+				   const char *list_name, int index);
 struct clk *of_clk_get_by_name(struct device_node *np, const char *name);
 struct clk *of_clk_get_from_provider(struct of_phandle_args *clkspec);
 #else
@@ -395,6 +397,11 @@ static inline struct clk *of_clk_get_by_name(struct device_node *np,
 {
 	return ERR_PTR(-ENOENT);
 }
+struct clk *of_clk_get_by_property(struct device_node *np,
+				   const char *list_name, int index)
+{
+	return ERR_PTR(-ENOENT);
+}
 #endif
 
 #endif
-- 
1.7.9.5

