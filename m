Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbaIZOzh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:55:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:3489 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754944AbaIZOzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:55:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,604,1406617200"; 
   d="scan'208";a="597291935"
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
Subject: [RFC v1 01/28] x86, irq: Kill unused setup_timer_IRQ0_pin()
Date: Fri, 26 Sep 2014 22:57:31 +0800
Message-Id: <1411743478-31435-2-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1411743478-31435-1-git-send-email-jiang.liu@linux.intel.com>
References: <1411743478-31435-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now there's no user of setup_timer_IRQ0_pin(), so kill it.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
Hi all,
	This patch depends on Thomas' work to remove the last caller of
setup_timer_IRQ0_pin(). So the "#if 0" is intended, so it won't block
following up patches.
Regards!
Gerry
---
 arch/x86/include/asm/io_apic.h          |    1 -
 arch/x86/kernel/apic/io_apic.c          |   17 -----------------
 arch/x86/platform/intel-mid/intel-mid.c |    2 ++
 3 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 7bf86bfe05b1..f9a99bc28981 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -204,7 +204,6 @@ extern int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
 			    irq_hw_number_t hwirq);
 extern void mp_irqdomain_unmap(struct irq_domain *domain, unsigned int virq);
 extern int mp_set_gsi_attr(u32 gsi, int trigger, int polarity, int node);
-extern void __init pre_init_apic_IRQ0(void);
 
 extern void mp_save_irq(struct mpc_intsrc *m);
 extern bool mp_should_keep_irq(struct device *dev);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 37796fcd33e2..5cccf8989507 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3091,20 +3091,3 @@ bool mp_should_keep_irq(struct device *dev)
 
 	return false;
 }
-
-/* Enable IOAPIC early just for system timer */
-void __init pre_init_apic_IRQ0(void)
-{
-	struct io_apic_irq_attr attr = { 0, 0, 0, 0 };
-
-	printk(KERN_INFO "Early APIC setup for system timer0\n");
-#ifndef CONFIG_SMP
-	physid_set_mask_of_physid(boot_cpu_physical_apicid,
-					 &phys_cpu_present_map);
-#endif
-	setup_local_APIC();
-
-	io_apic_setup_irq_pin(0, 0, &attr);
-	irq_set_chip_and_handler_name(0, &ioapic_chip, handle_edge_irq,
-				      "edge");
-}
diff --git a/arch/x86/platform/intel-mid/intel-mid.c b/arch/x86/platform/intel-mid/intel-mid.c
index 1bbedc4b0f88..f8855b703cab 100644
--- a/arch/x86/platform/intel-mid/intel-mid.c
+++ b/arch/x86/platform/intel-mid/intel-mid.c
@@ -99,7 +99,9 @@ static void __init intel_mid_time_init(void)
 		return;
 	}
 	/* we need at least one APB timer */
+#if 0
 	pre_init_apic_IRQ0();
+#endif
 	apbt_time_init();
 }
 
-- 
1.7.10.4

