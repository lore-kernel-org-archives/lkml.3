Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbaIKIXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:23:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:19478 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364AbaIKIXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:23:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,504,1406617200"; 
   d="scan'208";a="571629303"
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
Subject: [RFC Part1 v1 15/18] x86, irq: Use helpers to access irq_cfg data structure associated with IRQ
Date: Thu, 11 Sep 2014 16:25:02 +0800
Message-Id: <1410423905-26239-16-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410423905-26239-1-git-send-email-jiang.liu@linux.intel.com>
References: <1410423905-26239-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use helpers to access irq_cfg data structure associated with IRQ,
instead of accessing irq_data->chip_data directly. Later we could
rewrite those helpers to support hierarchy irqdomain.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apic/htirq.c   |    2 +-
 arch/x86/kernel/apic/io_apic.c |   10 +++++-----
 arch/x86/kernel/apic/msi.c     |    6 +++---
 arch/x86/kernel/apic/vector.c  |    6 +++---
 arch/x86/platform/uv/uv_irq.c  |    4 ++--
 5 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/apic/htirq.c b/arch/x86/kernel/apic/htirq.c
index 1cd879fe39d7..6f527b02ac4c 100644
--- a/arch/x86/kernel/apic/htirq.c
+++ b/arch/x86/kernel/apic/htirq.c
@@ -39,7 +39,7 @@ static void target_ht_irq(unsigned int irq, unsigned int dest, u8 vector)
 static int
 ht_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
 {
-	struct irq_cfg *cfg = data->chip_data;
+	struct irq_cfg *cfg = irqd_cfg(data);
 	unsigned int dest;
 	int ret;
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index f51143507c1c..e02e78ec579f 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -501,7 +501,7 @@ static void mask_ioapic(struct irq_cfg *cfg)
 
 static void mask_ioapic_irq(struct irq_data *data)
 {
-	mask_ioapic(data->chip_data);
+	mask_ioapic(irqd_cfg(data));
 }
 
 static void __unmask_ioapic(struct irq_cfg *cfg)
@@ -520,7 +520,7 @@ static void unmask_ioapic(struct irq_cfg *cfg)
 
 static void unmask_ioapic_irq(struct irq_data *data)
 {
-	unmask_ioapic(data->chip_data);
+	unmask_ioapic(irqd_cfg(data));
 }
 
 /*
@@ -1801,7 +1801,7 @@ static unsigned int startup_ioapic_irq(struct irq_data *data)
 		if (legacy_pic->irq_pending(irq))
 			was_pending = 1;
 	}
-	__unmask_ioapic(data->chip_data);
+	__unmask_ioapic(irqd_cfg(data));
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	return was_pending;
@@ -1852,7 +1852,7 @@ int native_ioapic_set_affinity(struct irq_data *data,
 	if (!ret) {
 		/* Only the high 8 bits are valid. */
 		dest = SET_APIC_LOGICAL_ID(dest);
-		__target_IO_APIC_irq(irq, dest, data->chip_data);
+		__target_IO_APIC_irq(irq, dest, irqd_cfg(data));
 		ret = IRQ_SET_MASK_OK_NOCOPY;
 	}
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
@@ -1943,7 +1943,7 @@ static inline void ioapic_irqd_unmask(struct irq_data *data,
 
 static void ack_ioapic_level(struct irq_data *data)
 {
-	struct irq_cfg *cfg = data->chip_data;
+	struct irq_cfg *cfg = irqd_cfg(data);
 	int i, irq = data->irq;
 	unsigned long v;
 	bool masked;
diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index 8ad0046849f3..fb45663395ca 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -78,7 +78,7 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
 static int
 msi_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
 {
-	struct irq_cfg *cfg = data->chip_data;
+	struct irq_cfg *cfg = irqd_cfg(data);
 	struct msi_msg msg;
 	unsigned int dest;
 	int ret;
@@ -179,7 +179,7 @@ static int
 dmar_msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
 		      bool force)
 {
-	struct irq_cfg *cfg = data->chip_data;
+	struct irq_cfg *cfg = irqd_cfg(data);
 	unsigned int dest, irq = data->irq;
 	struct msi_msg msg;
 	int ret;
@@ -233,7 +233,7 @@ int arch_setup_dmar_msi(unsigned int irq)
 static int hpet_msi_set_affinity(struct irq_data *data,
 				 const struct cpumask *mask, bool force)
 {
-	struct irq_cfg *cfg = data->chip_data;
+	struct irq_cfg *cfg = irqd_cfg(data);
 	struct msi_msg msg;
 	unsigned int dest;
 	int ret;
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index 2df1bff738b1..7562cb15b3bd 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -321,7 +321,7 @@ void setup_vector_irq(int cpu)
 
 int apic_retrigger_irq(struct irq_data *data)
 {
-	struct irq_cfg *cfg = data->chip_data;
+	struct irq_cfg *cfg = irqd_cfg(data);
 	unsigned long flags;
 	int cpu;
 
@@ -335,7 +335,7 @@ int apic_retrigger_irq(struct irq_data *data)
 
 void apic_ack_edge(struct irq_data *data)
 {
-	irq_complete_move(data->chip_data);
+	irq_complete_move(irqd_cfg(data));
 	irq_move_irq(data);
 	ack_APIC_irq();
 }
@@ -348,7 +348,7 @@ void apic_ack_edge(struct irq_data *data)
 int apic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 		      unsigned int *dest_id)
 {
-	struct irq_cfg *cfg = data->chip_data;
+	struct irq_cfg *cfg = irqd_cfg(data);
 	unsigned int irq = data->irq;
 	int err;
 
diff --git a/arch/x86/platform/uv/uv_irq.c b/arch/x86/platform/uv/uv_irq.c
index 3e8fab740c1d..0ce673645432 100644
--- a/arch/x86/platform/uv/uv_irq.c
+++ b/arch/x86/platform/uv/uv_irq.c
@@ -131,7 +131,7 @@ arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
 		       unsigned long mmr_offset, int limit)
 {
 	const struct cpumask *eligible_cpu = cpumask_of(cpu);
-	struct irq_cfg *cfg = irq_get_chip_data(irq);
+	struct irq_cfg *cfg = irq_cfg(irq);
 	unsigned long mmr_value;
 	struct uv_IO_APIC_route_entry *entry;
 	int mmr_pnode, err;
@@ -198,7 +198,7 @@ static int
 uv_set_irq_affinity(struct irq_data *data, const struct cpumask *mask,
 		    bool force)
 {
-	struct irq_cfg *cfg = data->chip_data;
+	struct irq_cfg *cfg = irqd_cfg(data);
 	unsigned int dest;
 	unsigned long mmr_value, mmr_offset;
 	struct uv_IO_APIC_route_entry *entry;
-- 
1.7.10.4

