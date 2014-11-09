Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbaKIPHt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 10:07:49 -0500
Received: from mga02.intel.com ([134.134.136.20]:37821 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbaKIPHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 10:07:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,346,1413270000"; 
   d="scan'208";a="604932784"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>, x86@kernel.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC Part4 v1 02/17] genirq: Introduce helper irq_domain_set_info() to reduce duplicated code
Date: Sun,  9 Nov 2014 23:10:24 +0800
Message-Id: <1415545839-28263-3-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415545839-28263-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415545839-28263-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce helper irq_domain_set_info() to reduce duplicated code.
We use "void *handler" instead of "irq_flow_handler_t handler" to solve
a recursive header file inclusion issue.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apic/htirq.c  |    5 ++---
 arch/x86/platform/uv/uv_irq.c |    5 ++---
 include/linux/irqdomain.h     |    4 ++++
 kernel/irq/irqdomain.c        |   10 ++++++++++
 4 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/apic/htirq.c b/arch/x86/kernel/apic/htirq.c
index 900f1401a452..1448df3f9e9f 100644
--- a/arch/x86/kernel/apic/htirq.c
+++ b/arch/x86/kernel/apic/htirq.c
@@ -96,9 +96,8 @@ static int htirq_domain_alloc(struct irq_domain *domain, unsigned int virq,
 	ht_cfg->update = info->ht_update;
 	ht_cfg->pos = info->ht_pos;
 	ht_cfg->idx = 0x10 + (info->ht_idx * 2);
-	irq_domain_set_hwirq_and_chip(domain, virq, hwirq, &ht_irq_chip,
-				      ht_cfg);
-	__irq_set_handler(virq, handle_edge_irq, 0, "edge");
+	irq_domain_set_info(domain, virq, hwirq, &ht_irq_chip, ht_cfg,
+			    handle_edge_irq, NULL, "edge");
 
 	return 0;
 }
diff --git a/arch/x86/platform/uv/uv_irq.c b/arch/x86/platform/uv/uv_irq.c
index 66d531e71c9a..b242e0aada19 100644
--- a/arch/x86/platform/uv/uv_irq.c
+++ b/arch/x86/platform/uv/uv_irq.c
@@ -102,9 +102,8 @@ static int uv_domain_alloc(struct irq_domain *domain, unsigned int virq,
 
 		chip_data->pnode = uv_blade_to_pnode(info->uv_blade);
 		chip_data->offset = info->uv_offset;
-		irq_domain_set_hwirq_and_chip(domain, virq, virq,
-					      &uv_irq_chip, chip_data);
-		__irq_set_handler(virq, handle_percpu_irq, 0, info->uv_name);
+		irq_domain_set_info(domain, virq, virq, &uv_irq_chip, chip_data,
+				    handle_percpu_irq, NULL, info->uv_name);
 	} else {
 		kfree(chip_data);
 	}
diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index 50931e936149..fb7af45f9425 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -263,6 +263,10 @@ extern int irq_domain_set_hwirq_and_chip(struct irq_domain *domain,
 					 irq_hw_number_t hwirq,
 					 struct irq_chip *chip,
 					 void *chip_data);
+extern void irq_domain_set_info(struct irq_domain *domain, unsigned int virq,
+				irq_hw_number_t hwirq, struct irq_chip *chip,
+				void *chip_data, void *handler,
+				void *handler_data, const char *handler_name);
 extern void irq_domain_reset_irq_data(struct irq_data *irq_data);
 extern void irq_domain_free_irqs_common(struct irq_domain *domain,
 					int virq, int nr_irqs);
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 4811bee1b8a7..1da30ae88665 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -882,6 +882,16 @@ int irq_domain_set_hwirq_and_chip(struct irq_domain *domain, unsigned int virq,
 	return 0;
 }
 
+void irq_domain_set_info(struct irq_domain *domain, unsigned int virq,
+			 irq_hw_number_t hwirq, struct irq_chip *chip,
+			 void *chip_data, void *handler, void *handler_data,
+			 const char *handler_name)
+{
+	irq_domain_set_hwirq_and_chip(domain, virq, hwirq, chip, chip_data);
+	__irq_set_handler(virq, handler, 0, handler_name);
+	irq_set_handler_data(virq, handler_data);
+}
+
 void irq_domain_reset_irq_data(struct irq_data *irq_data)
 {
 	irq_data->hwirq = 0;
-- 
1.7.10.4

