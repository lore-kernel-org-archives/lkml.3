Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbbAGGLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 01:11:21 -0500
Received: from mga01.intel.com ([192.55.52.88]:20537 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854AbbAGGLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 01:11:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,712,1413270000"; 
   d="scan'208";a="647398984"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Jiang Liu <jiang.liu@linux.intel.com>, Jan Beulich <JBeulich@suse.com>,
        David Rientjes <rientjes@google.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Richard Weinberger <richard@nod.at>, Oren Twaig <oren@scalemp.com>,
        Grant Likely <grant.likely@linaro.org>,
        Prarit Bhargava <prarit@redhat.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Ingo Molnar <mingo@kernel.org>, xen-devel@lists.xenproject.org
Subject: [Bugfix] x86/apic: Fix xen IRQ allocation failure caused by commit b81975eade8c
Date: Wed,  7 Jan 2015 14:13:49 +0800
Message-Id: <1420611244-25624-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
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
Reported-and-tested-by: Sander Eikelenboom <linux@eikelenboom.it>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
Hi all,
	This patch should be backported to v3.17, but there are
conflicts. So I will send backported patch to 3.17/3.18 stable tree
once this patch has been merged into mainstream kernel.
Thanks!
Gerry
---
 arch/x86/include/asm/io_apic.h       |    2 +-
 arch/x86/include/asm/smpboot_hooks.h |    5 ++---
 arch/x86/kernel/apic/apic.c          |    5 ++---
 arch/x86/kernel/apic/io_apic.c       |   32 +++++++++++++++-----------------
 arch/x86/xen/smp.c                   |    3 +++
 5 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index bf006cce9418..72a1298658bb 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -237,7 +237,7 @@ static inline void io_apic_modify(unsigned int apic, unsigned int reg, unsigned
 
 extern void io_apic_eoi(unsigned int apic, unsigned int vector);
 
-extern void setup_IO_APIC(void);
+extern void setup_IO_APIC(bool xen_smp);
 extern void enable_IO_APIC(void);
 extern void disable_IO_APIC(void);
 extern void setup_ioapic_dest(void);
diff --git a/arch/x86/include/asm/smpboot_hooks.h b/arch/x86/include/asm/smpboot_hooks.h
index 0da7409f0bec..e47df710a588 100644
--- a/arch/x86/include/asm/smpboot_hooks.h
+++ b/arch/x86/include/asm/smpboot_hooks.h
@@ -53,10 +53,9 @@ static inline void __init smpboot_setup_io_apic(void)
 	 * go and set it up:
 	 */
 	if (!skip_ioapic_setup && nr_ioapics)
-		setup_IO_APIC();
-	else {
+		setup_IO_APIC(false);
+	else
 		nr_ioapics = 0;
-	}
 #endif
 }
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 29b5b18afa27..71b8a6cb7f0e 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1913,10 +1913,9 @@ int __init APIC_init_uniprocessor(void)
 
 #ifdef CONFIG_X86_IO_APIC
 	if (smp_found_config && !skip_ioapic_setup && nr_ioapics)
-		setup_IO_APIC();
-	else {
+		setup_IO_APIC(false);
+	else
 		nr_ioapics = 0;
-	}
 #endif
 
 	x86_init.timers.setup_percpu_clockev();
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 3f5f60406ab1..13cddc75e4c0 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2369,31 +2369,29 @@ static void ioapic_destroy_irqdomain(int idx)
 	ioapics[idx].pin_info = NULL;
 }
 
-void __init setup_IO_APIC(void)
+void __init setup_IO_APIC(bool xen_smp)
 {
 	int ioapic;
 
-	/*
-	 * calling enable_IO_APIC() is moved to setup_local_APIC for BP
-	 */
-	io_apic_irqs = nr_legacy_irqs() ? ~PIC_IRQS : ~0UL;
+	if (!xen_smp) {
+		apic_printk(APIC_VERBOSE, "ENABLING IO-APIC IRQs\n");
+		io_apic_irqs = nr_legacy_irqs() ? ~PIC_IRQS : ~0UL;
+
+		/* Set up IO-APIC IRQ routing. */
+		x86_init.mpparse.setup_ioapic_ids();
+		sync_Arb_IDs();
+	}
 
-	apic_printk(APIC_VERBOSE, "ENABLING IO-APIC IRQs\n");
 	for_each_ioapic(ioapic)
 		BUG_ON(mp_irqdomain_create(ioapic));
-
-	/*
-         * Set up IO-APIC IRQ routing.
-         */
-	x86_init.mpparse.setup_ioapic_ids();
-
-	sync_Arb_IDs();
 	setup_IO_APIC_irqs();
-	init_IO_APIC_traps();
-	if (nr_legacy_irqs())
-		check_timer();
-
 	ioapic_initialized = 1;
+
+	if (!xen_smp) {
+		init_IO_APIC_traps();
+		if (nr_legacy_irqs())
+			check_timer();
+	}
 }
 
 /*
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 4c071aeb8417..7eb0283901fa 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -326,7 +326,10 @@ static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
 
 		xen_raw_printk(m);
 		panic(m);
+	} else {
+		setup_IO_APIC(true);
 	}
+
 	xen_init_lock_cpu(0);
 
 	smp_store_boot_cpu_info();
-- 
1.7.10.4

