Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758742AbaFUVSx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 17:18:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36173 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758713AbaFUVSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 17:18:40 -0400
Date: Sat, 21 Jun 2014 14:12:40 -0700
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-18e485518656205bbffce5e01f07830a6c3f557d@git.kernel.org>
Cc: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        hpa@zytor.com, jiang.liu@linux.intel.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org, joro@8bytes.org,
        benh@kernel.crashing.org, bhelgaas@google.com, rjw@rjwysocki.net,
        paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        hpa@zytor.com, jiang.liu@linux.intel.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org, joro@8bytes.org,
        benh@kernel.crashing.org, bhelgaas@google.com, rjw@rjwysocki.net,
        paul.gortmaker@windriver.com
In-Reply-To: <1402302011-23642-17-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-17-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq:
  Introduce some helper utilities to improve readability
Git-Commit-ID: 18e485518656205bbffce5e01f07830a6c3f557d
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

Commit-ID:  18e485518656205bbffce5e01f07830a6c3f557d
Gitweb:     http://git.kernel.org/tip/18e485518656205bbffce5e01f07830a6c3f557d
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 9 Jun 2014 16:19:45 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 21 Jun 2014 23:05:41 +0200

x86, irq: Introduce some helper utilities to improve readability

It also fixes an off by one bug in
	if ((ioapic_idx > 0) && (irq > NR_IRQS_LEGACY))
It should be
	if ((ioapic_idx > 0) && (irq >= NR_IRQS_LEGACY))

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1402302011-23642-17-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/io_apic.h |  2 ++
 arch/x86/kernel/apic/io_apic.c | 29 ++++++++++++++++++++++-------
 2 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index de3d8b0..b775cf3 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -171,6 +171,7 @@ extern u32 gsi_top;
 
 extern int mp_find_ioapic(u32 gsi);
 extern int mp_find_ioapic_pin(int ioapic, u32 gsi);
+extern u32 mp_pin_to_gsi(int ioapic, int pin);
 extern void __init mp_register_ioapic(int id, u32 address, u32 gsi_base);
 extern void __init pre_init_apic_IRQ0(void);
 
@@ -212,6 +213,7 @@ extern void io_apic_eoi(unsigned int apic, unsigned int vector);
 static inline void ioapic_insert_resources(void) { }
 #define gsi_top (NR_IRQS_LEGACY)
 static inline int mp_find_ioapic(u32 gsi) { return 0; }
+static inline u32 mp_pin_to_gsi(int ioapic, int pin) { return UINT_MAX; }
 
 struct io_apic_irq_attr;
 static inline int io_apic_set_pci_routing(struct device *dev, int irq,
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 09e5c7b..424f795 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -117,6 +117,24 @@ struct mp_ioapic_gsi *mp_ioapic_gsi_routing(int ioapic_idx)
 	return &ioapics[ioapic_idx].gsi_config;
 }
 
+static inline int mp_ioapic_pin_count(int ioapic)
+{
+	struct mp_ioapic_gsi *gsi_cfg = mp_ioapic_gsi_routing(ioapic);
+
+	return gsi_cfg->gsi_end - gsi_cfg->gsi_base + 1;
+}
+
+u32 mp_pin_to_gsi(int ioapic, int pin)
+{
+	return mp_ioapic_gsi_routing(ioapic)->gsi_base + pin;
+}
+
+/* Initialize all legacy IRQs and all pins on the first IOAPIC at boot */
+static inline int mp_init_irq_at_boot(int ioapic, int irq)
+{
+	return ioapic == 0 || (irq >= 0 && irq < NR_IRQS_LEGACY);
+}
+
 int nr_ioapics;
 
 /* The one past the highest gsi number used */
@@ -1367,8 +1385,7 @@ static void __init __io_apic_setup_irqs(unsigned int ioapic_idx)
 			continue;
 
 		irq = pin_2_irq(idx, ioapic_idx, pin);
-
-		if ((ioapic_idx > 0) && (irq > NR_IRQS_LEGACY))
+		if (!mp_init_irq_at_boot(ioapic_idx, irq))
 			continue;
 
 		/*
@@ -1419,9 +1436,7 @@ void setup_IO_APIC_irq_extra(u32 gsi)
 		return;
 
 	irq = pin_2_irq(idx, ioapic_idx, pin);
-
-	/* Only handle the non legacy irqs on secondary ioapics */
-	if (ioapic_idx == 0 || irq < NR_IRQS_LEGACY)
+	if (mp_init_irq_at_boot(ioapic_idx, irq))
 		return;
 
 	set_io_apic_irq_attr(&attr, ioapic_idx, pin, irq_trigger(idx),
@@ -3528,9 +3543,9 @@ void __init setup_ioapic_dest(void)
 		irq_entry = find_irq_entry(ioapic, pin, mp_INT);
 		if (irq_entry == -1)
 			continue;
-		irq = pin_2_irq(irq_entry, ioapic, pin);
 
-		if ((ioapic > 0) && (irq > NR_IRQS_LEGACY))
+		irq = pin_2_irq(irq_entry, ioapic, pin);
+		if (!mp_init_irq_at_boot(ioapic, irq))
 			continue;
 
 		idata = irq_get_irq_data(irq);
