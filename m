Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbaIKIam (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:30:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:19347 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967AbaIKIWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:22:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,504,1406617200"; 
   d="scan'208";a="571629006"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [RFC Part1 v1 05/18] x86, irq: Rename local APIC related functions in io_apic.c as apic_xxx()
Date: Thu, 11 Sep 2014 16:24:52 +0800
Message-Id: <1410423905-26239-6-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410423905-26239-1-git-send-email-jiang.liu@linux.intel.com>
References: <1410423905-26239-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename local APIC related functions in io_apic.c as apic_xxx() instead
of ioapic_xxx(), later they will be moved into separate file.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/hw_irq.h  |    4 ++--
 arch/x86/kernel/apic/io_apic.c |   42 ++++++++++++++++++++--------------------
 arch/x86/platform/uv/uv_irq.c  |    2 +-
 3 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 8188d648d48c..18e8717bf644 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -137,8 +137,8 @@ extern int assign_irq_vector(int, struct irq_cfg *, const struct cpumask *);
 extern void send_cleanup_vector(struct irq_cfg *);
 
 struct irq_data;
-int __ioapic_set_affinity(struct irq_data *, const struct cpumask *,
-			  unsigned int *dest_id);
+int apic_set_affinity(struct irq_data *, const struct cpumask *,
+		      unsigned int *dest_id);
 #endif	/* CONFIG_X86_LOCAL_APIC */
 
 #ifdef CONFIG_X86_IO_APIC
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 0a479242b244..814527753563 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2252,7 +2252,7 @@ static unsigned int startup_ioapic_irq(struct irq_data *data)
 	return was_pending;
 }
 
-static int ioapic_retrigger_irq(struct irq_data *data)
+static int apic_retrigger_irq(struct irq_data *data)
 {
 	struct irq_cfg *cfg = data->chip_data;
 	unsigned long flags;
@@ -2407,8 +2407,8 @@ static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, struct irq
  * ->cpu_mask_to_apicid of that in dest_id, or returns -1 and
  * leaves data->affinity untouched.
  */
-int __ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
-			  unsigned int *dest_id)
+int apic_set_affinity(struct irq_data *data, const struct cpumask *mask,
+		      unsigned int *dest_id)
 {
 	struct irq_cfg *cfg = data->chip_data;
 	unsigned int irq = data->irq;
@@ -2449,7 +2449,7 @@ int native_ioapic_set_affinity(struct irq_data *data,
 		return -EPERM;
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	ret = __ioapic_set_affinity(data, mask, &dest);
+	ret = apic_set_affinity(data, mask, &dest);
 	if (!ret) {
 		/* Only the high 8 bits are valid. */
 		dest = SET_APIC_LOGICAL_ID(dest);
@@ -2460,7 +2460,7 @@ int native_ioapic_set_affinity(struct irq_data *data,
 	return ret;
 }
 
-static void ack_apic_edge(struct irq_data *data)
+static void apic_ack_edge(struct irq_data *data)
 {
 	irq_complete_move(data->chip_data);
 	irq_move_irq(data);
@@ -2549,7 +2549,7 @@ static inline void ioapic_irqd_unmask(struct irq_data *data,
 }
 #endif
 
-static void ack_apic_level(struct irq_data *data)
+static void ack_ioapic_level(struct irq_data *data)
 {
 	struct irq_cfg *cfg = data->chip_data;
 	int i, irq = data->irq;
@@ -2621,10 +2621,10 @@ static struct irq_chip ioapic_chip __read_mostly = {
 	.irq_startup		= startup_ioapic_irq,
 	.irq_mask		= mask_ioapic_irq,
 	.irq_unmask		= unmask_ioapic_irq,
-	.irq_ack		= ack_apic_edge,
-	.irq_eoi		= ack_apic_level,
+	.irq_ack		= apic_ack_edge,
+	.irq_eoi		= ack_ioapic_level,
 	.irq_set_affinity	= native_ioapic_set_affinity,
-	.irq_retrigger		= ioapic_retrigger_irq,
+	.irq_retrigger		= apic_retrigger_irq,
 };
 
 static inline void init_IO_APIC_traps(void)
@@ -3158,7 +3158,7 @@ msi_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
 	unsigned int dest;
 	int ret;
 
-	ret = __ioapic_set_affinity(data, mask, &dest);
+	ret = apic_set_affinity(data, mask, &dest);
 	if (ret)
 		return ret;
 
@@ -3182,9 +3182,9 @@ static struct irq_chip msi_chip = {
 	.name			= "PCI-MSI",
 	.irq_unmask		= unmask_msi_irq,
 	.irq_mask		= mask_msi_irq,
-	.irq_ack		= ack_apic_edge,
+	.irq_ack		= apic_ack_edge,
 	.irq_set_affinity	= msi_set_affinity,
-	.irq_retrigger		= ioapic_retrigger_irq,
+	.irq_retrigger		= apic_retrigger_irq,
 };
 
 int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
@@ -3259,7 +3259,7 @@ dmar_msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	struct msi_msg msg;
 	int ret;
 
-	ret = __ioapic_set_affinity(data, mask, &dest);
+	ret = apic_set_affinity(data, mask, &dest);
 	if (ret)
 		return ret;
 
@@ -3280,9 +3280,9 @@ static struct irq_chip dmar_msi_type = {
 	.name			= "DMAR_MSI",
 	.irq_unmask		= dmar_msi_unmask,
 	.irq_mask		= dmar_msi_mask,
-	.irq_ack		= ack_apic_edge,
+	.irq_ack		= apic_ack_edge,
 	.irq_set_affinity	= dmar_msi_set_affinity,
-	.irq_retrigger		= ioapic_retrigger_irq,
+	.irq_retrigger		= apic_retrigger_irq,
 };
 
 int arch_setup_dmar_msi(unsigned int irq)
@@ -3310,7 +3310,7 @@ static int hpet_msi_set_affinity(struct irq_data *data,
 	unsigned int dest;
 	int ret;
 
-	ret = __ioapic_set_affinity(data, mask, &dest);
+	ret = apic_set_affinity(data, mask, &dest);
 	if (ret)
 		return ret;
 
@@ -3330,9 +3330,9 @@ static struct irq_chip hpet_msi_type = {
 	.name = "HPET_MSI",
 	.irq_unmask = hpet_msi_unmask,
 	.irq_mask = hpet_msi_mask,
-	.irq_ack = ack_apic_edge,
+	.irq_ack = apic_ack_edge,
 	.irq_set_affinity = hpet_msi_set_affinity,
-	.irq_retrigger = ioapic_retrigger_irq,
+	.irq_retrigger = apic_retrigger_irq,
 };
 
 int default_setup_hpet_msi(unsigned int irq, unsigned int id)
@@ -3381,7 +3381,7 @@ ht_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
 	unsigned int dest;
 	int ret;
 
-	ret = __ioapic_set_affinity(data, mask, &dest);
+	ret = apic_set_affinity(data, mask, &dest);
 	if (ret)
 		return ret;
 
@@ -3393,9 +3393,9 @@ static struct irq_chip ht_irq_chip = {
 	.name			= "PCI-HT",
 	.irq_mask		= mask_ht_irq,
 	.irq_unmask		= unmask_ht_irq,
-	.irq_ack		= ack_apic_edge,
+	.irq_ack		= apic_ack_edge,
 	.irq_set_affinity	= ht_set_affinity,
-	.irq_retrigger		= ioapic_retrigger_irq,
+	.irq_retrigger		= apic_retrigger_irq,
 };
 
 int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
diff --git a/arch/x86/platform/uv/uv_irq.c b/arch/x86/platform/uv/uv_irq.c
index b233681af4de..3e8fab740c1d 100644
--- a/arch/x86/platform/uv/uv_irq.c
+++ b/arch/x86/platform/uv/uv_irq.c
@@ -204,7 +204,7 @@ uv_set_irq_affinity(struct irq_data *data, const struct cpumask *mask,
 	struct uv_IO_APIC_route_entry *entry;
 	int mmr_pnode;
 
-	if (__ioapic_set_affinity(data, mask, &dest))
+	if (apic_set_affinity(data, mask, &dest))
 		return -1;
 
 	mmr_value = 0;
-- 
1.7.10.4

