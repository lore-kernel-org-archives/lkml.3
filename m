Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934160Ab3EAA7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 20:59:16 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:44196 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933787Ab3EAA6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 20:58:55 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Stephen Warren <swarren@nvidia.com>, Daniel Mack <zonque@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Marek Belisko <marek.belisko@streamunlimited.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] clk: add non CONFIG_OF routines for clk-provider
Date: Wed,  1 May 2013 02:58:28 +0200
Message-Id: <1367369910-20402-2-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367369910-20402-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1367369910-20402-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some drivers that are shared between architectures have HAVE_CLK selected
but don't have OF. To remove compilation errors for drivers that provide
clocks on DT with of_clk_add_provider we would have to enclose these calls
within #ifdef CONFIG_OF, #endif.

This patch adds some stubs for OF related clk-provider functions that
either do nothing or return appropriate values if CONFIG_OF is not set.
So, definition of these routines will always be available.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
---
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Daniel Mack <zonque@gmail.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Marek Belisko <marek.belisko@streamunlimited.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 include/linux/clk-provider.h |   47 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 39 insertions(+), 8 deletions(-)

diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 1186098..265f384 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -423,6 +423,17 @@ struct of_device_id;
 
 typedef void (*of_clk_init_cb_t)(struct device_node *);
 
+struct clk_onecell_data {
+	struct clk **clks;
+	unsigned int clk_num;
+};
+
+#define CLK_OF_DECLARE(name, compat, fn)			\
+	static const struct of_device_id __clk_of_table_##name	\
+		__used __section(__clk_of_table)		\
+		= { .compatible = compat, .data = fn };
+
+#ifdef CONFIG_OF
 int of_clk_add_provider(struct device_node *np,
 			struct clk *(*clk_src_get)(struct of_phandle_args *args,
 						   void *data),
@@ -430,19 +441,39 @@ int of_clk_add_provider(struct device_node *np,
 void of_clk_del_provider(struct device_node *np);
 struct clk *of_clk_src_simple_get(struct of_phandle_args *clkspec,
 				  void *data);
-struct clk_onecell_data {
-	struct clk **clks;
-	unsigned int clk_num;
-};
 struct clk *of_clk_src_onecell_get(struct of_phandle_args *clkspec, void *data);
 const char *of_clk_get_parent_name(struct device_node *np, int index);
 
 void of_clk_init(const struct of_device_id *matches);
 
-#define CLK_OF_DECLARE(name, compat, fn)			\
-	static const struct of_device_id __clk_of_table_##name	\
-		__used __section(__clk_of_table)		\
-		= { .compatible = compat, .data = fn };
+#else /* !CONFIG_OF */
 
+static inline int of_clk_add_provider(struct device_node *np,
+			struct clk *(*clk_src_get)(struct of_phandle_args *args,
+						   void *data),
+			void *data)
+{
+	return 0;
+}
+#define of_clk_del_provider(np) \
+	{ while (0); }
+static inline struct clk *of_clk_src_simple_get(
+	struct of_phandle_args *clkspec, void *data)
+{
+	return ERR_PTR(-ENOENT);
+}
+static inline struct clk *of_clk_src_onecell_get(
+	struct of_phandle_args *clkspec, void *data)
+{
+	return ERR_PTR(-ENOENT);
+}
+static inline const char *of_clk_get_parent_name(struct device_node *np,
+						 int index)
+{
+	return NULL;
+}
+#define of_clk_init(matches) \
+	{ while (0); }
+#endif /* CONFIG_OF */
 #endif /* CONFIG_COMMON_CLK */
 #endif /* CLK_PROVIDER_H */
-- 
1.7.10.4

