Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424AbaFPL0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 07:26:39 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37759 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755406AbaFPL0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 07:26:36 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <santosh.shilimkar@ti.com>, <nm@ti.com>,
        <rnayak@ti.com>, <linux@arm.linux.org.uk>, <r.sricharan@ti.com>,
        <tglx@linutronix.de>, <jason@lakedaemon.net>, <joe@perches.com>
Subject: [PATCH V3 09/16] irqchip: crossbar: return proper error value
Date: Mon, 16 Jun 2014 16:53:09 +0530
Message-ID: <1402917796-31574-10-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402917796-31574-1-git-send-email-r.sricharan@ti.com>
References: <1402917796-31574-1-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nishanth Menon <nm@ti.com>

crossbar_of_init always returns -ENOMEM in case of errors.
There can be other causes of failure like invalid data from
DT. So return a appropriate error value for that case.

Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sricharan R <r.sricharan@ti.com>
---
[V3] Changed commit log

 drivers/irqchip/irq-crossbar.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
index 6eee61b..5bcedc0 100644
--- a/drivers/irqchip/irq-crossbar.c
+++ b/drivers/irqchip/irq-crossbar.c
@@ -129,19 +129,25 @@ static const struct irq_domain_ops routable_irq_domain_ops = {
 
 static int __init crossbar_of_init(struct device_node *node)
 {
-	int i, size, max, reserved = 0, entry;
+	int i, size, max = 0, reserved = 0, entry;
 	const __be32 *irqsr;
+	int ret = -ENOMEM;
 
 	cb = kzalloc(sizeof(*cb), GFP_KERNEL);
 
 	if (!cb)
-		return -ENOMEM;
+		return ret;
 
 	cb->crossbar_base = of_iomap(node, 0);
 	if (!cb->crossbar_base)
 		goto err1;
 
 	of_property_read_u32(node, "ti,max-irqs", &max);
+	if (!max) {
+		pr_err("missing 'ti,max-irqs' property\n");
+		ret = -EINVAL;
+		goto err2;
+	}
 	cb->irq_map = kcalloc(max, sizeof(int), GFP_KERNEL);
 	if (!cb->irq_map)
 		goto err2;
@@ -162,6 +168,7 @@ static int __init crossbar_of_init(struct device_node *node)
 						   i, &entry);
 			if (entry > max) {
 				pr_err("Invalid reserved entry\n");
+				ret = -EINVAL;
 				goto err3;
 			}
 			cb->irq_map[entry] = IRQ_RESERVED;
@@ -205,6 +212,7 @@ static int __init crossbar_of_init(struct device_node *node)
 		break;
 	default:
 		pr_err("Invalid reg-size property\n");
+		ret = -EINVAL;
 		goto err4;
 		break;
 	}
@@ -243,7 +251,7 @@ err2:
 	iounmap(cb->crossbar_base);
 err1:
 	kfree(cb);
-	return -ENOMEM;
+	return ret;
 }
 
 static const struct of_device_id crossbar_match[] __initconst = {
-- 
1.7.9.5

