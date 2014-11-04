Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbaKDL7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 06:59:31 -0500
Received: from mga11.intel.com ([192.55.52.93]:23727 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470AbaKDL7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 06:59:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,313,1413270000"; 
   d="scan'208";a="616764901"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jiang Liu <jiang.liu@linux.intel.com>
Subject: [Patch Part2 v4 02/31] irqdomain: Do irq_find_mapping and set_type for hierarchy irqdomain in case OF
Date: Tue,  4 Nov 2014 20:01:36 +0800
Message-Id: <1415102525-9898-3-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415102525-9898-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415102525-9898-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yingjoe Chen <yingjoe.chen@mediatek.com>

It is possible to call irq_create_of_mapping to create/translate the
same IRQ from DT for multiple times. Perform irq_find_mapping check
and set_type for hierarchy irqdomain in irq_create_of_mapping() to
avoid duplicate these functionality in all outer most irqdomain.

Signed-off-by: Yingjoe Chen <yingjoe.chen@mediatek.com>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 kernel/irq/irqdomain.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 899150452ae8..e1351b0bd7f8 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -478,11 +478,6 @@ unsigned int irq_create_of_mapping(struct of_phandle_args *irq_data)
 		return 0;
 	}
 
-	if (irq_domain_is_hierarchy(domain)) {
-		virq = irq_domain_alloc_irqs(domain, 1, NUMA_NO_NODE, irq_data);
-		return virq <= 0 ? 0 : virq;
-	}
-
 	/* If domain has no translation, then we assume interrupt line */
 	if (domain->ops->xlate == NULL)
 		hwirq = irq_data->args[0];
@@ -492,10 +487,24 @@ unsigned int irq_create_of_mapping(struct of_phandle_args *irq_data)
 			return 0;
 	}
 
-	/* Create mapping */
-	virq = irq_create_mapping(domain, hwirq);
-	if (!virq)
-		return virq;
+	if (irq_domain_is_hierarchy(domain)) {
+		/*
+		 * If we've already configured this interrupt,
+		 * don't do it again, or hell will break loose.
+		 */
+		virq = irq_find_mapping(domain, hwirq);
+		if (virq)
+			return virq;
+
+		virq = irq_domain_alloc_irqs(domain, 1, NUMA_NO_NODE, irq_data);
+		if (virq <= 0)
+			return 0;
+	} else {
+		/* Create mapping */
+		virq = irq_create_mapping(domain, hwirq);
+		if (!virq)
+			return virq;
+	}
 
 	/* Set type if specified and different than the current one */
 	if (type != IRQ_TYPE_NONE &&
-- 
1.7.10.4

