Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbaKYHue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 02:50:34 -0500
Received: from mga11.intel.com ([192.55.52.93]:1305 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859AbaKYHu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 02:50:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,454,1413270000"; 
   d="scan'208";a="627835210"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Joerg Roedel <joro@8bytes.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [Patch Part3 v4 15/38] x86, irq: Kill x86_io_apic_ops.eoi_ioapic_pin and related interfaces
Date: Tue, 25 Nov 2014 15:49:39 +0800
Message-Id: <1416901802-24211-16-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1416901802-24211-1-git-send-email-jiang.liu@linux.intel.com>
References: <1416901802-24211-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now there is no user of x86_io_apic_ops.eoi_ioapic_pin anymore, so kill
it.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Tested-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/io_apic.h  |    7 -------
 arch/x86/include/asm/x86_init.h |    1 -
 arch/x86/kernel/apic/io_apic.c  |   20 ++++----------------
 arch/x86/kernel/x86_init.c      |    1 -
 drivers/iommu/irq_remapping.c   |   19 -------------------
 5 files changed, 4 insertions(+), 44 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 5fba350fec1f..3b54f0f9cbb7 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -150,10 +150,6 @@ struct irq_cfg;
 extern void ioapic_insert_resources(void);
 extern int arch_early_ioapic_init(void);
 
-extern void eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg);
-
-extern void native_eoi_ioapic_pin(int apic, int pin, int vector);
-
 extern int save_ioapic_entries(void);
 extern void mask_ioapic_entries(void);
 extern int restore_ioapic_entries(void);
@@ -237,8 +233,6 @@ static inline void io_apic_modify(unsigned int apic, unsigned int reg, unsigned
 	x86_io_apic_ops.modify(apic, reg, value);
 }
 
-extern void io_apic_eoi(unsigned int apic, unsigned int vector);
-
 extern void setup_IO_APIC(void);
 extern void enable_IO_APIC(void);
 extern void disable_IO_APIC(void);
@@ -282,7 +276,6 @@ static inline void disable_ioapic_support(void) { }
 #define native_io_apic_write		NULL
 #define native_io_apic_modify		NULL
 #define native_disable_io_apic		NULL
-#define native_eoi_ioapic_pin		NULL
 #endif
 
 #endif /* _ASM_X86_IO_APIC_H */
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index f9f83cfabcaa..4ada3d3a0e86 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -191,7 +191,6 @@ struct x86_io_apic_ops {
 	void		(*write)  (unsigned int apic, unsigned int reg, unsigned int value);
 	void		(*modify) (unsigned int apic, unsigned int reg, unsigned int value);
 	void		(*disable)(void);
-	void		(*eoi_ioapic_pin)(int apic, int pin, int vector);
 };
 
 extern struct x86_init_ops x86_init;
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 26fa504b57f6..2a10cb9f03bf 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -268,7 +268,7 @@ static __attribute_const__ struct io_apic __iomem *io_apic_base(int idx)
 		+ (mpc_ioapic_addr(idx) & ~PAGE_MASK);
 }
 
-void io_apic_eoi(unsigned int apic, unsigned int vector)
+static inline void io_apic_eoi(unsigned int apic, unsigned int vector)
 {
 	struct io_apic __iomem *io_apic = io_apic_base(apic);
 	writel(vector, &io_apic->eoi);
@@ -524,7 +524,7 @@ static void unmask_ioapic_irq(struct irq_data *data)
  * Otherwise, we simulate the EOI message manually by changing the trigger
  * mode to edge and then back to level, with RTE being masked during this.
  */
-void native_eoi_ioapic_pin(int apic, int pin, int vector)
+static void __eoi_ioapic_pin(int apic, int pin, int vector)
 {
 	if (mpc_ioapic_ver(apic) >= 0x20) {
 		io_apic_eoi(apic, vector);
@@ -555,19 +555,7 @@ void eoi_ioapic_pin(int vector, struct irq_cfg *cfg)
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	for_each_irq_pin(entry, cfg->irq_2_pin)
-		native_eoi_ioapic_pin(entry->apic, entry->pin, vector);
-	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
-}
-
-void eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
-{
-	struct irq_pin_list *entry;
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	for_each_irq_pin(entry, cfg->irq_2_pin)
-		x86_io_apic_ops.eoi_ioapic_pin(entry->apic, entry->pin,
-					       cfg->vector);
+		__eoi_ioapic_pin(entry->apic, entry->pin, vector);
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
@@ -603,7 +591,7 @@ static void clear_IO_APIC_pin(unsigned int apic, unsigned int pin)
 			ioapic_write_entry(apic, pin, entry);
 		}
 		raw_spin_lock_irqsave(&ioapic_lock, flags);
-		native_eoi_ioapic_pin(apic, pin, entry.vector);
+		__eoi_ioapic_pin(apic, pin, entry.vector);
 		raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 	}
 
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index f7e8eab3a7c4..f612dc018fb6 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -144,5 +144,4 @@ struct x86_io_apic_ops x86_io_apic_ops = {
 	.write			= native_io_apic_write,
 	.modify			= native_io_apic_modify,
 	.disable		= native_disable_io_apic,
-	.eoi_ioapic_pin		= native_eoi_ioapic_pin,
 };
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 13243ac9040f..d175d6911821 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -44,21 +44,9 @@ static void irq_remapping_disable_io_apic(void)
 		disconnect_bsp_APIC(0);
 }
 
-static void eoi_ioapic_pin_remapped(int apic, int pin, int vector)
-{
-	/*
-	 * Intr-remapping uses pin number as the virtual vector
-	 * in the RTE. Actual vector is programmed in
-	 * intr-remapping table entry. Hence for the io-apic
-	 * EOI we use the pin number.
-	 */
-	io_apic_eoi(apic, pin);
-}
-
 static void __init irq_remapping_modify_x86_ops(void)
 {
 	x86_io_apic_ops.disable		= irq_remapping_disable_io_apic;
-	x86_io_apic_ops.eoi_ioapic_pin	= eoi_ioapic_pin_remapped;
 }
 
 static __init int setup_nointremap(char *str)
@@ -194,12 +182,6 @@ void ir_ack_apic_edge(struct irq_data *data)
 	ack_APIC_irq();
 }
 
-static void ir_ack_apic_level(struct irq_data *data)
-{
-	ack_APIC_irq();
-	eoi_ioapic_irq(data->irq, irqd_cfg(data));
-}
-
 void irq_remapping_print_chip(struct irq_data *data, struct seq_file *p)
 {
 	/*
@@ -222,7 +204,6 @@ void irq_remap_modify_chip_defaults(struct irq_chip *chip)
 {
 	chip->irq_print_chip = ir_print_prefix;
 	chip->irq_ack = ir_ack_apic_edge;
-	chip->irq_eoi = ir_ack_apic_level;
 }
 
 bool setup_remapped_irq(int irq, struct irq_cfg *cfg, struct irq_chip *chip)
-- 
1.7.10.4

