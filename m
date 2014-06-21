Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780AbaFUVTR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 17:19:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36215 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756706AbaFUVTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 17:19:14 -0400
Date: Sat, 21 Jun 2014 14:18:16 -0700
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-b81975eade8c6495f3c4d6746d22bdc95f617777@git.kernel.org>
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
In-Reply-To: <1402302011-23642-43-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-43-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq: Clean up irqdomain transition code
Git-Commit-ID: b81975eade8c6495f3c4d6746d22bdc95f617777
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

Commit-ID:  b81975eade8c6495f3c4d6746d22bdc95f617777
Gitweb:     http://git.kernel.org/tip/b81975eade8c6495f3c4d6746d22bdc95f617777
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 9 Jun 2014 16:20:11 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 21 Jun 2014 23:05:44 +0200

x86, irq: Clean up irqdomain transition code

Now we have completely switched to irqdomain, so clean up transition code
in IOAPIC drivers.

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
Link: http://lkml.kernel.org/r/1402302011-23642-43-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/io_apic.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 8d80a8f..a44dce8 100644
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
@@ -3461,12 +3459,11 @@ static int __init io_apic_get_redir_entries(int ioapic)
 
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
@@ -3841,10 +3838,7 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base,
 	ioapics[idx].mp_config.flags = MPC_APIC_USABLE;
 	ioapics[idx].mp_config.apicaddr = address;
 	ioapics[idx].irqdomain = NULL;
-	if (cfg)
-		ioapics[idx].irqdomain_cfg = *cfg;
-	else
-		ioapics[idx].irqdomain_cfg.type = IOAPIC_DOMAIN_INVALID;
+	ioapics[idx].irqdomain_cfg = *cfg;
 
 	set_fixmap_nocache(FIX_IO_APIC_BASE_0 + idx, address);
 
