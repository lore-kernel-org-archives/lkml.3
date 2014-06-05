Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362AbaFEHCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 03:02:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:62924 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbaFEHCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 03:02:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,979,1392192000"; 
   d="scan'208";a="551900401"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: [RFC Patch 1/3] ce4100, irq: make CE4100 depend on CONFIG_X86_IOAPIC
Date: Thu,  5 Jun 2014 15:04:35 +0800
Message-Id: <1401951877-23032-2-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401951877-23032-1-git-send-email-jiang.liu@linux.intel.com>
References: <1401951877-23032-1-git-send-email-jiang.liu@linux.intel.com>
In-Reply-To: <5385BCD0.1080802@linutronix.de>
References: <5385BCD0.1080802@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel CE4100 platforms need IOAPIC support becasue some devices are
always connected to the second IOAPIC.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/Kconfig                  |    1 +
 arch/x86/platform/ce4100/ce4100.c |    9 ++-------
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 47247708c9eb..55ec58b0b373 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -426,6 +426,7 @@ config X86_INTEL_CE
 	bool "CE4100 TV platform"
 	depends on PCI
 	depends on PCI_GODIRECT
+	depends on X86_IO_APIC
 	depends on X86_32
 	depends on X86_EXTENDED_PLATFORM
 	select X86_REBOOTFIXUPS
diff --git a/arch/x86/platform/ce4100/ce4100.c b/arch/x86/platform/ce4100/ce4100.c
index 8244f5ec2f4c..0a54a586559b 100644
--- a/arch/x86/platform/ce4100/ce4100.c
+++ b/arch/x86/platform/ce4100/ce4100.c
@@ -135,14 +135,12 @@ static void __init sdv_arch_setup(void)
 	sdv_serial_fixup();
 }
 
-#ifdef CONFIG_X86_IO_APIC
 static void sdv_pci_init(void)
 {
 	x86_of_pci_init();
 	/* We can't set this earlier, because we need to calibrate the timer */
 	legacy_pic = &null_legacy_pic;
 }
-#endif
 
 /*
  * CE4100 specific x86_init function overrides and early setup
@@ -155,7 +153,9 @@ void __init x86_ce4100_early_setup(void)
 	x86_init.resources.probe_roms = x86_init_noop;
 	x86_init.mpparse.get_smp_config = x86_init_uint_noop;
 	x86_init.mpparse.find_smp_config = x86_init_noop;
+	x86_init.mpparse.setup_ioapic_ids = setup_ioapic_ids_from_mpc_nocheck;
 	x86_init.pci.init = ce4100_pci_init;
+	x86_init.pci.init_irq = sdv_pci_init;
 
 	/*
 	 * By default, the reboot method is ACPI which is supported by the
@@ -166,10 +166,5 @@ void __init x86_ce4100_early_setup(void)
 	 */
 	reboot_type = BOOT_KBD;
 
-#ifdef CONFIG_X86_IO_APIC
-	x86_init.pci.init_irq = sdv_pci_init;
-	x86_init.mpparse.setup_ioapic_ids = setup_ioapic_ids_from_mpc_nocheck;
-#endif
-
 	pm_power_off = ce4100_power_off;
 }
-- 
1.7.10.4

