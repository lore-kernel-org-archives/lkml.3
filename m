Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933249AbaFIIZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:25:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:59321 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754016AbaFIIZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:25:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="352322135"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: [Patch V4 42/42] x86, irq: clean up irqdomain transition code
Date: Mon,  9 Jun 2014 16:20:11 +0800
Message-Id: <1402302011-23642-43-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have completely switched to irqdomain, so clean up transition code
in IOAPIC drivers.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apic/io_apic.c |   28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 60555354b331..26490336ef6f 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -86,6 +86,7 @@ static DEFINE_RAW_SPINLOCK(ioapic_lock);
 static DEFINE_RAW_SPINLOCK(vector_lock);
 static DEFINE_MUTEX(ioapic_mutex);
 static unsigned int ioapic_dynirq_base;
+static int ioapic_initialized;
 
 struct mp_pin_info {
 	int trigger;
@@ -1034,13 +1035,8 @@ static int mp_map_pin_to_irq(u32 gsi, int idx, int ioapic, int pin,
 	struct irq_domain *domain = mp_ioapic_irqdomain(ioapic);
 	struct mp_pin_info *info = mp_pin_info(ioapic, pin);
 
-	if (!domain) {
-		/*
-		 * Provide an identity mapping of gsi == irq except on truly
-		 * weird platforms that have non isa irqs in the first 16 gsis.
-		 */
-		return gsi >= nr_legacy_irqs() ? gsi : gsi_top + gsi;
-	}
+	if (!domain)
+		return -1;
 
 	mutex_lock(&ioapic_mutex);
 
@@ -2986,6 +2982,8 @@ void __init setup_IO_APIC(void)
 	init_IO_APIC_traps();
 	if (nr_legacy_irqs())
 		check_timer();
+
+	ioapic_initialized = 1;
 }
 
 /*
@@ -3457,12 +3455,11 @@ static int __init io_apic_get_redir_entries(int ioapic)
 
 unsigned int arch_dynirq_lower_bound(unsigned int from)
 {
-	unsigned int min = gsi_top + nr_legacy_irqs();
-
-	if (ioapic_dynirq_base)
-		return ioapic_dynirq_base;
-
-	return from < min ? min : from;
+	/*
+	 * dmar_alloc_hwirq() may be called before setup_IO_APIC(), so use
+	 * gsi_top if ioapic_dynirq_base hasn't been initialized yet.
+	 */
+	return ioapic_initialized ? ioapic_dynirq_base : gsi_top;
 }
 
 int __init arch_probe_nr_irqs(void)
@@ -3837,10 +3834,7 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base,
 	ioapics[idx].mp_config.flags = MPC_APIC_USABLE;
 	ioapics[idx].mp_config.apicaddr = address;
 	ioapics[idx].irqdomain = NULL;
-	if (cfg)
-		ioapics[idx].irqdomain_cfg = *cfg;
-	else
-		ioapics[idx].irqdomain_cfg.type = IOAPIC_DOMAIN_INVALID;
+	ioapics[idx].irqdomain_cfg = *cfg;
 
 	set_fixmap_nocache(FIX_IO_APIC_BASE_0 + idx, address);
 
-- 
1.7.10.4

