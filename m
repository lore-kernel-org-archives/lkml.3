Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929Ab3IRN0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 09:26:33 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:36571 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab3IRN0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 09:26:30 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 07/10] of/irq: Propagate errors in of_irq_to_resource_table()
Date: Wed, 18 Sep 2013 15:24:49 +0200
Message-Id: <1379510692-32435-8-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1379510692-32435-1-git-send-email-treding@nvidia.com>
References: <1379510692-32435-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all helpers return precise error codes, this function can
propagate these errors to the caller properly.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Changes in v2:
- return 0 on success or a negative error code on failure
- convert callers to new calling convention

 arch/mips/lantiq/irq.c       |  2 +-
 arch/mips/lantiq/xway/gptu.c |  6 ++++--
 drivers/of/irq.c             | 14 ++++++++------
 drivers/tty/serial/lantiq.c  |  2 +-
 4 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/arch/mips/lantiq/irq.c b/arch/mips/lantiq/irq.c
index eb3e186..5bb7ee6 100644
--- a/arch/mips/lantiq/irq.c
+++ b/arch/mips/lantiq/irq.c
@@ -389,7 +389,7 @@ int __init icu_of_init(struct device_node *node, struct device_node *parent)
 
 		ret = of_irq_to_resource_table(eiu_node,
 						ltq_eiu_irq, exin_avail);
-		if (ret != exin_avail)
+		if (ret < 0)
 			panic("failed to load external irq resources\n");
 
 		if (request_mem_region(res.start, resource_size(&res),
diff --git a/arch/mips/lantiq/xway/gptu.c b/arch/mips/lantiq/xway/gptu.c
index 850821d..0c4b134 100644
--- a/arch/mips/lantiq/xway/gptu.c
+++ b/arch/mips/lantiq/xway/gptu.c
@@ -137,10 +137,12 @@ static int gptu_probe(struct platform_device *pdev)
 {
 	struct clk *clk;
 	struct resource *res;
+	int ret;
 
-	if (of_irq_to_resource_table(pdev->dev.of_node, irqres, 6) != 6) {
+	ret = of_irq_to_resource_table(pdev->dev.of_node, irqres, 6);
+	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to get IRQ list\n");
-		return -EINVAL;
+		return ret;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index e4f38c0..6d7f824 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -397,18 +397,20 @@ int of_irq_count(struct device_node *dev)
  * @res: array of resources to fill in
  * @nr_irqs: the number of IRQs (and upper bound for num of @res elements)
  *
- * Returns the size of the filled in table (up to @nr_irqs).
+ * Returns 0 on success or a negative error code on failure.
  */
 int of_irq_to_resource_table(struct device_node *dev, struct resource *res,
 		int nr_irqs)
 {
-	int i;
+	int i, ret;
 
-	for (i = 0; i < nr_irqs; i++, res++)
-		if (!of_irq_to_resource(dev, i, res))
-			break;
+	for (i = 0; i < nr_irqs; i++, res++) {
+		ret = of_irq_to_resource(dev, i, res);
+		if (ret < 0)
+			return ret;
+	}
 
-	return i;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(of_irq_to_resource_table);
 
diff --git a/drivers/tty/serial/lantiq.c b/drivers/tty/serial/lantiq.c
index 88d01e0..e59efdc 100644
--- a/drivers/tty/serial/lantiq.c
+++ b/drivers/tty/serial/lantiq.c
@@ -686,7 +686,7 @@ lqasc_probe(struct platform_device *pdev)
 
 	mmres = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	ret = of_irq_to_resource_table(node, irqres, 3);
-	if (!mmres || (ret != 3)) {
+	if (!mmres || (ret < 0)) {
 		dev_err(&pdev->dev,
 			"failed to get memory/irq for serial port\n");
 		return -ENODEV;
-- 
1.8.4

