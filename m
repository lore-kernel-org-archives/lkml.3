Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541AbaKISmk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 13:42:40 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:31436 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbaKISmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 13:42:38 -0500
X-Mailbox-Line: From 375a82230accf26dfbbb74e6f928243ea8e38b50 Mon Sep 17 00:00:00 2001
Message-Id: <375a82230accf26dfbbb74e6f928243ea8e38b50.1415557680.git.moinejf@free.fr>
In-Reply-To: <cover.1415557680.git.moinejf@free.fr>
References: <cover.1415557680.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Sat, 8 Nov 2014 19:33:22 +0100
Subject: [PATCH 1/2] of: Make const the device node pointers in of_clk_get and
 of_node_put
To: Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>, Mark Brown <broonie@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some device nodes are sometimes referenced by const pointers.

This patch avoids to cast these pointers when calling the functions
of_clk_get() and of_node_put().

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/clk/clkdev.c | 2 +-
 drivers/of/dynamic.c | 2 +-
 include/linux/clk.h  | 4 ++--
 include/linux/of.h   | 4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index da4bda8..eaee11e 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -53,7 +53,7 @@ struct clk *of_clk_get_by_clkspec(struct of_phandle_args *clkspec)
 	return clk;
 }
 
-struct clk *of_clk_get(struct device_node *np, int index)
+struct clk *of_clk_get(const struct device_node *np, int index)
 {
 	struct of_phandle_args clkspec;
 	struct clk *clk;
diff --git a/drivers/of/dynamic.c b/drivers/of/dynamic.c
index f297891..64eb5ba 100644
--- a/drivers/of/dynamic.c
+++ b/drivers/of/dynamic.c
@@ -34,7 +34,7 @@ EXPORT_SYMBOL(of_node_get);
  * @node:	Node to dec refcount, NULL is supported to simplify writing of
  *		callers
  */
-void of_node_put(struct device_node *node)
+void of_node_put(const struct device_node *node)
 {
 	if (node)
 		kobject_put(&node->kobj);
diff --git a/include/linux/clk.h b/include/linux/clk.h
index c7f258a..4e077a4 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -425,11 +425,11 @@ struct device_node;
 struct of_phandle_args;
 
 #if defined(CONFIG_OF) && defined(CONFIG_COMMON_CLK)
-struct clk *of_clk_get(struct device_node *np, int index);
+struct clk *of_clk_get(const struct device_node *np, int index);
 struct clk *of_clk_get_by_name(struct device_node *np, const char *name);
 struct clk *of_clk_get_from_provider(struct of_phandle_args *clkspec);
 #else
-static inline struct clk *of_clk_get(struct device_node *np, int index)
+static inline struct clk *of_clk_get(const struct device_node *np, int index)
 {
 	return ERR_PTR(-ENOENT);
 }
diff --git a/include/linux/of.h b/include/linux/of.h
index 6545e7a..b738681 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -95,14 +95,14 @@ static inline int of_node_is_attached(struct device_node *node)
 
 #ifdef CONFIG_OF_DYNAMIC
 extern struct device_node *of_node_get(struct device_node *node);
-extern void of_node_put(struct device_node *node);
+extern void of_node_put(const struct device_node *node);
 #else /* CONFIG_OF_DYNAMIC */
 /* Dummy ref counting routines - to be implemented later */
 static inline struct device_node *of_node_get(struct device_node *node)
 {
 	return node;
 }
-static inline void of_node_put(struct device_node *node) { }
+static inline void of_node_put(const struct device_node *node) { }
 #endif /* !CONFIG_OF_DYNAMIC */
 
 #ifdef CONFIG_OF
-- 
2.1.3

