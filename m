Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab3JNKu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 06:50:59 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:47468 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964Ab3JNKu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 06:50:57 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>
Subject: [PATCH] of: Add helper for printing an of_phandle_args structure
Date: Mon, 14 Oct 2013 11:50:51 +0100
Message-Id: <1381747851-20594-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is sometimes useful for debug to get the contents of an
of_phandle_args structure out into the kernel log.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
---
 drivers/of/base.c  | 9 +++++++++
 drivers/of/irq.c   | 6 +++---
 include/linux/of.h | 1 +
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 924ba04..4caa9f4 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1192,6 +1192,15 @@ int of_property_count_strings(struct device_node *np, const char *propname)
 }
 EXPORT_SYMBOL_GPL(of_property_count_strings);
 
+void of_print_phandle_args(const char *msg, const struct of_phandle_args *args)
+{
+	int i;
+	printk("%s %s", msg, of_node_full_name(args->np));
+	for (i = 0; i < args->args_count; i++)
+		printk(i ? ",%08x" : ":%08x", args->args[i]);
+	printk("\n");
+}
+
 static int __of_parse_phandle_with_args(const struct device_node *np,
 					const char *list_name,
 					const char *cells_name,
diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index b6c32bc..4bda131 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -101,9 +101,9 @@ int of_irq_parse_raw(const __be32 *addr, struct of_phandle_args *out_irq)
 	u32 intsize = 1, addrsize, newintsize = 0, newaddrsize = 0;
 	int imaplen, match, i;
 
-	pr_debug("of_irq_parse_raw: par=%s,intspec=[0x%08x 0x%08x...],ointsize=%d\n",
-		 of_node_full_name(out_irq->np), out_irq->args[0], out_irq->args[1],
-		 out_irq->args_count);
+#ifdef DEBUG
+	of_print_phandle_args("of_irq_parse_raw: ", out_irq);
+#endif
 
 	ipar = of_node_get(out_irq->np);
 
diff --git a/include/linux/of.h b/include/linux/of.h
index 54017b8..5ea16e5 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -277,6 +277,7 @@ extern int of_n_size_cells(struct device_node *np);
 extern const struct of_device_id *of_match_node(
 	const struct of_device_id *matches, const struct device_node *node);
 extern int of_modalias_node(struct device_node *node, char *modalias, int len);
+extern void of_print_phandle_args(const char *msg, const struct of_phandle_args *args);
 extern struct device_node *of_parse_phandle(const struct device_node *np,
 					    const char *phandle_name,
 					    int index);
-- 
1.8.1.2

