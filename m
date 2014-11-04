Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbaKDMAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 07:00:33 -0500
Received: from mga14.intel.com ([192.55.52.115]:14984 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659AbaKDMA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 07:00:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,313,1413270000"; 
   d="scan'208";a="616765078"
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
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [Patch Part2 v4 05/31] genirq: Add IRQ_SET_MASK_OK_DONE to support stacked irqchip
Date: Tue,  4 Nov 2014 20:01:39 +0800
Message-Id: <1415102525-9898-6-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415102525-9898-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415102525-9898-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add IRQ_SET_MASK_OK_DONE in addition to IRQ_SET_MASK_OK and
IRQ_SET_MASK_OK_NOCOPY to support stacked irqchip. IRQ_SET_MASK_OK_DONE
is the same as IRQ_SET_MASK_OK to irq core. To stacked irqchip, it means
that ascendant irqchips have done all the work and no more handling
needed in descendant irqchips.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 include/linux/irq.h |    4 ++++
 kernel/irq/manage.c |    2 ++
 2 files changed, 6 insertions(+)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 536b7fc6c8f4..041edd6dc409 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -114,10 +114,14 @@ enum {
  *
  * IRQ_SET_MASK_OK	- OK, core updates irq_data.affinity
  * IRQ_SET_MASK_NOCPY	- OK, chip did update irq_data.affinity
+ * IRQ_SET_MASK_OK_DONE	- Same as IRQ_SET_MASK_OK for core. Special code to
+ *			  support stacked irqchips, which indicates skipping
+ *			  all descendent irqchips.
  */
 enum {
 	IRQ_SET_MASK_OK = 0,
 	IRQ_SET_MASK_OK_NOCOPY,
+	IRQ_SET_MASK_OK_DONE,
 };
 
 struct msi_desc;
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 0a9104b4608b..80692373abd6 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -183,6 +183,7 @@ int irq_do_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	ret = chip->irq_set_affinity(data, mask, force);
 	switch (ret) {
 	case IRQ_SET_MASK_OK:
+	case IRQ_SET_MASK_OK_DONE:
 		cpumask_copy(data->affinity, mask);
 	case IRQ_SET_MASK_OK_NOCOPY:
 		irq_set_thread_affinity(desc);
@@ -600,6 +601,7 @@ int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 
 	switch (ret) {
 	case IRQ_SET_MASK_OK:
+	case IRQ_SET_MASK_OK_DONE:
 		irqd_clear(&desc->irq_data, IRQD_TRIGGER_MASK);
 		irqd_set(&desc->irq_data, flags);
 
-- 
1.7.10.4

