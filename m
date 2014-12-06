Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466AbaLFNxO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 08:53:14 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:19903 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaLFNxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 08:53:13 -0500
Date: Sat, 6 Dec 2014 16:52:57 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] iommu/amd: fix a small leak in irq_remapping_alloc()
Message-ID: <20141206135257.GB17278@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a memory leak here that was detected by Smatch:

	drivers/iommu/amd_iommu.c:4261 irq_remapping_alloc()
	warn: possible memory leak of 'data'

It happens if you hit the "if (!irq_data || !cfg) {" on the first
iteration through the loop.  The original code was a bit weird.  For
example, it treated the first allocation as a special case for some
reason. Anyway I cleaned it up a bit.

Fixes: ecf87b38d902 ('iommu/amd: Enhance AMD IR driver to suppport hierarchy irqdomain')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Please review this carefully.  I haven't tested it.

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 35a38db..3bb69e4 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -4208,11 +4208,6 @@ static int irq_remapping_alloc(struct irq_domain *domain, unsigned int virq,
 	if (ret < 0)
 		return ret;
 
-	ret = -ENOMEM;
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
-	if (!data)
-		goto out_free_parent;
-
 	if (info->type == X86_IRQ_ALLOC_TYPE_IOAPIC) {
 		if (get_irq_table(devid, true))
 			index = info->ioapic_pin;
@@ -4223,7 +4218,6 @@ static int irq_remapping_alloc(struct irq_domain *domain, unsigned int virq,
 	}
 	if (index < 0) {
 		pr_warn("Failed to allocate IRTE\n");
-		kfree(data);
 		goto out_free_parent;
 	}
 
@@ -4232,14 +4226,16 @@ static int irq_remapping_alloc(struct irq_domain *domain, unsigned int virq,
 		cfg = irqd_cfg(irq_data);
 		if (!irq_data || !cfg) {
 			ret = -EINVAL;
-			goto out_free_data;
+			goto out_unwind_loop;
 		}
 
-		if (i > 0) {
-			data = kzalloc(sizeof(*data), GFP_KERNEL);
-			if (!data)
-				goto out_free_data;
+
+		data = kzalloc(sizeof(*data), GFP_KERNEL);
+		if (!data) {
+			ret = -ENOMEM;
+			goto out_unwind_loop;
 		}
+
 		irq_data->hwirq = (devid << 16) + i;
 		irq_data->chip_data = data;
 		irq_data->chip = &amd_ir_chip;
@@ -4248,8 +4244,8 @@ static int irq_remapping_alloc(struct irq_domain *domain, unsigned int virq,
 	}
 	return 0;
 
-out_free_data:
-	for (i--; i >= 0; i--) {
+out_unwind_loop:
+	while (--i >= 0) {
 		irq_data = irq_domain_get_irq_data(domain, virq + i);
 		if (irq_data)
 			kfree(irq_data->chip_data);
