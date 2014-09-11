Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbaIKOJ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:09:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:12864 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400AbaIKOCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:02:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="384738306"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC Part2 v1 02/21] genirq: Introduce helper functions to support stacked irq_chip
Date: Thu, 11 Sep 2014 22:03:29 +0800
Message-Id: <1410444228-3134-3-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410444228-3134-1-git-send-email-jiang.liu@linux.intel.com>
References: <1410444228-3134-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we already support hierarchy irq_datas, so introduce several helpers
to support stacked irq_chips.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 include/linux/irq.h |    5 +++++
 kernel/irq/chip.c   |   18 ++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 4b74565690ce..bfa027f6814a 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -433,6 +433,11 @@ extern void handle_percpu_devid_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_bad_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_nested_irq(unsigned int irq);
 
+#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
+extern void irq_chip_ack_parent(struct irq_data *data);
+extern int irq_chip_retrigger_hierarchy(struct irq_data *data);
+#endif
+
 /* Handling of unhandled and spurious interrupts: */
 extern void note_interrupt(unsigned int irq, struct irq_desc *desc,
 			   irqreturn_t action_ret);
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 46bd5e2190c3..b8ee27efde73 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -821,3 +821,21 @@ void irq_cpu_offline(void)
 		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 }
+
+#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
+void irq_chip_ack_parent(struct irq_data *data)
+{
+	data = data->parent_data;
+	if (data && data->chip && data->chip->irq_ack)
+		data->chip->irq_ack(data);
+}
+
+int irq_chip_retrigger_hierarchy(struct irq_data *data)
+{
+	for (data = data->parent_data; data; data = data->parent_data)
+		if (data->chip && data->chip->irq_retrigger)
+			return data->chip->irq_retrigger(data);
+
+	return -ENOSYS;
+}
+#endif
-- 
1.7.10.4

