Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140AbaLJGpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 01:45:45 -0500
Received: from mga11.intel.com ([192.55.52.93]:21063 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932107AbaLJGpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 01:45:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,550,1413270000"; 
   d="scan'208";a="645283406"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Borislav Petkov <bp@alien8.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        iommu@lists.linux-foundation.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC Patch V1 8/9] iommu/irq_remapping: Normailize the way to detect whether IR is enabled
Date: Wed, 10 Dec 2014 14:47:50 +0800
Message-Id: <1418194071-13785-9-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1418194071-13785-1-git-send-email-jiang.liu@linux.intel.com>
References: <1418194071-13785-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refine code by normailizing the way to detect whether IR is enabled.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/irq_remapping.c |   30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index fbd585e49ebd..c7ef51a2555a 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -112,22 +112,16 @@ int __init irq_remapping_enable(void)
 
 void irq_remapping_disable(void)
 {
-	if (!irq_remapping_enabled ||
-	    !remap_ops ||
-	    !remap_ops->disable)
-		return;
-
-	remap_ops->disable();
+	if (irq_remapping_enabled && remap_ops->disable)
+		remap_ops->disable();
 }
 
 int irq_remapping_reenable(int mode)
 {
-	if (!irq_remapping_enabled ||
-	    !remap_ops ||
-	    !remap_ops->reenable)
-		return 0;
+	if (irq_remapping_enabled && remap_ops->reenable)
+		return remap_ops->reenable(mode);
 
-	return remap_ops->reenable(mode);
+	return 0;
 }
 
 int __init irq_remap_enable_fault_handling(void)
@@ -135,7 +129,7 @@ int __init irq_remap_enable_fault_handling(void)
 	if (!irq_remapping_enabled)
 		return 0;
 
-	if (!remap_ops || !remap_ops->enable_faulting)
+	if (!remap_ops->enable_faulting)
 		return -ENODEV;
 
 	return remap_ops->enable_faulting();
@@ -176,10 +170,10 @@ void irq_remapping_print_chip(struct irq_data *data, struct seq_file *p)
 struct irq_domain *
 irq_remapping_get_ir_irq_domain(struct irq_alloc_info *info)
 {
-	if (!remap_ops || !remap_ops->get_ir_irq_domain)
-		return NULL;
+	if (irq_remapping_enabled && remap_ops->get_ir_irq_domain)
+		return remap_ops->get_ir_irq_domain(info);
 
-	return remap_ops->get_ir_irq_domain(info);
+	return NULL;
 }
 
 /**
@@ -194,8 +188,8 @@ irq_remapping_get_ir_irq_domain(struct irq_alloc_info *info)
 struct irq_domain *
 irq_remapping_get_irq_domain(struct irq_alloc_info *info)
 {
-	if (!remap_ops || !remap_ops->get_irq_domain)
-		return NULL;
+	if (irq_remapping_enabled && remap_ops->get_irq_domain)
+		return remap_ops->get_irq_domain(info);
 
-	return remap_ops->get_irq_domain(info);
+	return NULL;
 }
-- 
1.7.10.4

