Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468AbaKEQpv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:45:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41497 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084AbaKEQpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:45:49 -0500
Date: Wed, 5 Nov 2014 08:39:26 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-a6845cb49054a56955efa8311d67361f251679cb@git.kernel.org>
Cc: gregkh@linuxfoundation.org, mingo@kernel.org, tglx@linutronix.de,
        rjw@rjwysocki.net, rdunlap@infradead.org, yinghai@kernel.org,
        tony.luck@intel.com, konrad.wilk@oracle.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org,
        jiang.liu@linux.intel.com, benh@kernel.crashing.org,
        bhelgaas@google.com, prarit@redhat.com, joro@8bytes.org, bp@alien8.de
Reply-To: gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@kernel.org,
        rjw@rjwysocki.net, rdunlap@infradead.org, tony.luck@intel.com,
        yinghai@kernel.org, hpa@zytor.com, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org,
        bhelgaas@google.com, benh@kernel.crashing.org,
        jiang.liu@linux.intel.com, prarit@redhat.com, bp@alien8.de,
        joro@8bytes.org
In-Reply-To: <1414397531-28254-17-git-send-email-jiang.liu@linux.intel.com>
References: <1414397531-28254-17-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq:
  Use helpers to access irq_cfg data structure associated with IRQ
Git-Commit-ID: a6845cb49054a56955efa8311d67361f251679cb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a6845cb49054a56955efa8311d67361f251679cb
Gitweb:     http://git.kernel.org/tip/a6845cb49054a56955efa8311d67361f251679cb
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 27 Oct 2014 16:12:07 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 5 Nov 2014 11:04:47 +0100

x86, irq: Use helpers to access irq_cfg data structure associated with IRQ

Use helpers to access irq_cfg data structure associated with IRQ,
instead of accessing irq_data->chip_data directly. Later we can
rewrite those helpers to support hierarchy irqdomain.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Link: http://lkml.kernel.org/r/1414397531-28254-17-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/htirq.c   |  2 +-
 arch/x86/kernel/apic/io_apic.c | 10 +++++-----
 arch/x86/kernel/apic/msi.c     |  6 +++---
 arch/x86/kernel/apic/vector.c  |  6 +++---
 arch/x86/platform/uv/uv_irq.c  |  4 ++--
 5 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/apic/htirq.c b/arch/x86/kernel/apic/htirq.c
index a4980c5..816f36e 100644
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
index 2619cbe..3f5f604 100644
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
index 7eff986..75f4f56 100644
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
@@ -180,7 +180,7 @@ static int
 dmar_msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
 		      bool force)
 {
-	struct irq_cfg *cfg = data->chip_data;
+	struct irq_cfg *cfg = irqd_cfg(data);
 	unsigned int dest, irq = data->irq;
 	struct msi_msg msg;
 	int ret;
@@ -235,7 +235,7 @@ int arch_setup_dmar_msi(unsigned int irq)
 static int hpet_msi_set_affinity(struct irq_data *data,
 				 const struct cpumask *mask, bool force)
 {
-	struct irq_cfg *cfg = data->chip_data;
+	struct irq_cfg *cfg = irqd_cfg(data);
 	struct msi_msg msg;
 	unsigned int dest;
 	int ret;
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index e194447..27e1ac4 100644
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
index 3e8fab7..0ce6736 100644
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
