Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933304AbaHHVCE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:02:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41403 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933119AbaHHUx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:53:59 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Russell King <linux@arm.linux.org.uk>, Rob Herring <robh@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 129/259] of/irq: do irq resolution in platform_get_irq_byname()
Date: Fri,  8 Aug 2014 13:39:12 -0700
Message-Id: <1407530482-4483-130-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Grygorii Strashko <grygorii.strashko@ti.com>

commit ad69674e73a18dc3a8da557f4059ccf9389531a5 upstream.

The commit 9ec36cafe43bf835f8f29273597a5b0cbc8267ef
"of/irq: do irq resolution in platform_get_irq" from Rob Herring -
moves resolving of the interrupt resources in platform_get_irq().
But this solution isn't complete because platform_get_irq_byname()
need to be modified the same way.

Hence, fix it by adding interrupt resolution code at the
platform_get_irq_byname() function too.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Rob Herring <robh@kernel.org>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Thierry Reding <thierry.reding@gmail.com>

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Grant Likely <grant.likely@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/base/platform.c |  7 +++++--
 drivers/of/irq.c        | 22 ++++++++++++++++++++++
 include/linux/of_irq.h  |  5 +++++
 3 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 39d2f6b..0d13679 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -131,9 +131,12 @@ EXPORT_SYMBOL_GPL(platform_get_resource_byname);
  */
 int platform_get_irq_byname(struct platform_device *dev, const char *name)
 {
-	struct resource *r = platform_get_resource_byname(dev, IORESOURCE_IRQ,
-							  name);
+	struct resource *r;
+
+	if (IS_ENABLED(CONFIG_OF_IRQ) && dev->dev.of_node)
+		return of_irq_get_byname(dev->dev.of_node, name);
 
+	r = platform_get_resource_byname(dev, IORESOURCE_IRQ, name);
 	return r ? r->start : -ENXIO;
 }
 EXPORT_SYMBOL_GPL(platform_get_irq_byname);
diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 11c7f73..5d8c346 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -403,6 +403,28 @@ int of_irq_get(struct device_node *dev, int index)
 }
 
 /**
+ * of_irq_get_byname - Decode a node's IRQ and return it as a Linux irq number
+ * @dev: pointer to device tree node
+ * @name: irq name
+ *
+ * Returns Linux irq number on success, or -EPROBE_DEFER if the irq domain
+ * is not yet created, or error code in case of any other failure.
+ */
+int of_irq_get_byname(struct device_node *dev, const char *name)
+{
+	int index;
+
+	if (unlikely(!name))
+		return -EINVAL;
+
+	index = of_property_match_string(dev, "interrupt-names", name);
+	if (index < 0)
+		return index;
+
+	return of_irq_get(dev, index);
+}
+
+/**
  * of_irq_count - Count the number of IRQs a node uses
  * @dev: pointer to device tree node
  */
diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
index 6404253..bfec136 100644
--- a/include/linux/of_irq.h
+++ b/include/linux/of_irq.h
@@ -45,6 +45,7 @@ extern void of_irq_init(const struct of_device_id *matches);
 #ifdef CONFIG_OF_IRQ
 extern int of_irq_count(struct device_node *dev);
 extern int of_irq_get(struct device_node *dev, int index);
+extern int of_irq_get_byname(struct device_node *dev, const char *name);
 #else
 static inline int of_irq_count(struct device_node *dev)
 {
@@ -54,6 +55,10 @@ static inline int of_irq_get(struct device_node *dev, int index)
 {
 	return 0;
 }
+static inline int of_irq_get_byname(struct device_node *dev, const char *name)
+{
+	return 0;
+}
 #endif
 
 #if defined(CONFIG_OF)
-- 
1.9.1

