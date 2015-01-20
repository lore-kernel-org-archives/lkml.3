Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbbATFxo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 00:53:44 -0500
Received: from mga03.intel.com ([134.134.136.65]:24972 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394AbbATFxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 00:53:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,432,1418112000"; 
   d="scan'208";a="664447954"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Dimitri Sivanich <sivanich@sgi.com>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch Part2 v4 21/33] x86/irq: Remove sis apic bug workaround
Date: Tue, 20 Jan 2015 13:51:41 +0800
Message-Id: <1421733113-15704-22-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421733113-15704-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421733113-15704-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

The SiS apic bug workaround is now obsolete as we cache the register
values for performance reasons.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/io_apic.h |    3 ---
 arch/x86/kernel/apic/io_apic.c |   35 ++++++++++-------------------------
 drivers/pci/quirks.c           |    7 -------
 3 files changed, 10 insertions(+), 35 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 628a95497635..b2510b8dad44 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -120,9 +120,6 @@ extern int mp_irq_entries;
 /* MP IRQ source entries */
 extern struct mpc_intsrc mp_irqs[MAX_IRQ_SOURCES];
 
-/* Older SiS APIC requires we rewrite the index register */
-extern int sis_apic_bug;
-
 /* 1 if "noapic" boot option passed */
 extern int skip_ioapic_setup;
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 83c3c90bd903..068f26428984 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -18,6 +18,16 @@
  *					and Rolf G. Tews
  *					for testing these extensively
  *	Paul Diefenbaugh	:	Added full ACPI support
+ *
+ * Historical information which is worth to be preserved:
+ *
+ * - SiS APIC rmw bug:
+ *
+ *	We used to have a workaround for a bug in SiS chips which
+ *	required to rewrite the index register for a read-modify-write
+ *	operation as the chip lost the index information which was
+ *	setup for the read already. We cache the data now, so that
+ *	workaround has been removed.
  */
 
 #include <linux/mm.h>
@@ -68,17 +78,6 @@
 
 int acpi_get_override_irq(u32 gsi, int *trigger, int *polarity);
 
-/*
- * Is the SiS APIC rmw bug present ?
- *      -1 = don't know, 0 = no, 1 = yes
- * When doing a read-modify-write operation on IOAPIC registers, older SiS APIC
- * requires we rewrite the index register again where the read already set up
- * the index register.
- * The code to make use of sis_apic_bug has been removed, but we don't want to
- * loss this knowledge.
- */
-int sis_apic_bug = -1;
-
 static DEFINE_RAW_SPINLOCK(ioapic_lock);
 static DEFINE_MUTEX(ioapic_mutex);
 static unsigned int ioapic_dynirq_base;
@@ -2318,20 +2317,6 @@ void __init setup_IO_APIC(void)
 	ioapic_initialized = 1;
 }
 
-/*
- *      Called after all the initialization is done. If we didn't find any
- *      APIC bugs then we can allow the modify fast path
- */
-
-static int __init io_apic_bug_finalize(void)
-{
-	if (sis_apic_bug == -1)
-		sis_apic_bug = 0;
-	return 0;
-}
-
-late_initcall(io_apic_bug_finalize);
-
 static void resume_ioapic_id(int ioapic_idx)
 {
 	unsigned long flags;
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index ed6f89b6efe5..69bbed5ff30b 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -785,13 +785,6 @@ static void quirk_amd_ioapic(struct pci_dev *dev)
 	}
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD,	PCI_DEVICE_ID_AMD_VIPER_7410,	quirk_amd_ioapic);
-
-static void quirk_ioapic_rmw(struct pci_dev *dev)
-{
-	if (dev->devfn == 0 && dev->bus->number == 0)
-		sis_apic_bug = 1;
-}
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SI,	PCI_ANY_ID,			quirk_ioapic_rmw);
 #endif /* CONFIG_X86_IO_APIC */
 
 /*
-- 
1.7.10.4

