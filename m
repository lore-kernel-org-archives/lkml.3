Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbbALNgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 08:36:32 -0500
Received: from mga01.intel.com ([192.55.52.88]:51574 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbbALNga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:36:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="439461829"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Sander Eikelenboom <linux@eikelenboom.it>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: [PATCH v2] [Bugfix] x86/apic: Fix xen IRQ allocation failure caused by commit b81975eade8c
Date: Mon, 12 Jan 2015 21:39:22 +0800
Message-Id: <1421069966-19729-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1767175032.20150110201202@eikelenboom.it>
References: <1767175032.20150110201202@eikelenboom.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b81975eade8c ("x86, irq: Clean up irqdomain transition code")
breaks xen IRQ allocation because xen_smp_prepare_cpus() doesn't invoke
setup_IO_APIC(), so no irqdomains created for IOAPICs and
mp_map_pin_to_irq() fails at the very beginning.

Enhance xen_smp_prepare_cpus() to call setup_IO_APIC() to initialize
irqdomain for IOAPICs.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
Hi Sander,
	Could you please help to test this patch against 3.19-rc3?
I have reworked it based Konrad's suggestions.
Thanks!
Gerry
---
 arch/x86/kernel/apic/io_apic.c |   31 +++++++++++++++++++++++--------
 arch/x86/xen/smp.c             |    1 +
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 3f5f60406ab1..81d4faeb8040 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -38,6 +38,8 @@
 #include <linux/slab.h>
 #include <linux/bootmem.h>
 
+#include <xen/xen.h>
+
 #include <asm/idle.h>
 #include <asm/io.h>
 #include <asm/smp.h>
@@ -2165,6 +2167,9 @@ static inline void __init check_timer(void)
 	unsigned long flags;
 	int no_pin1 = 0;
 
+	if (!nr_legacy_irqs())
+		return;
+
 	local_irq_save(flags);
 
 	/*
@@ -2185,6 +2190,13 @@ static inline void __init check_timer(void)
 	apic_write(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_EXTINT);
 	legacy_pic->init(1);
 
+	/*
+	 * legacy_pic will be changed to null_legacy_pic if init() fails to
+	 * to detect legacy PIC hardware. Recheck again.
+	 */
+	if (!nr_legacy_irqs())
+		goto out;
+
 	pin1  = find_isa_irq_pin(0, mp_INT);
 	apic1 = find_isa_irq_apic(0, mp_INT);
 	pin2  = ioapic_i8259.pin;
@@ -2369,6 +2381,15 @@ static void ioapic_destroy_irqdomain(int idx)
 	ioapics[idx].pin_info = NULL;
 }
 
+static void setup_IO_APIC_IDs(void)
+{
+	if (xen_domain())
+		return;
+
+	x86_init.mpparse.setup_ioapic_ids();
+	sync_Arb_IDs();
+}
+
 void __init setup_IO_APIC(void)
 {
 	int ioapic;
@@ -2382,16 +2403,10 @@ void __init setup_IO_APIC(void)
 	for_each_ioapic(ioapic)
 		BUG_ON(mp_irqdomain_create(ioapic));
 
-	/*
-         * Set up IO-APIC IRQ routing.
-         */
-	x86_init.mpparse.setup_ioapic_ids();
-
-	sync_Arb_IDs();
+	setup_IO_APIC_IDs();
 	setup_IO_APIC_irqs();
 	init_IO_APIC_traps();
-	if (nr_legacy_irqs())
-		check_timer();
+	check_timer();
 
 	ioapic_initialized = 1;
 }
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 4c071aeb8417..9f404df64422 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -327,6 +327,7 @@ static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
 		xen_raw_printk(m);
 		panic(m);
 	}
+	setup_IO_APIC();
 	xen_init_lock_cpu(0);
 
 	smp_store_boot_cpu_info();
-- 
1.7.10.4

