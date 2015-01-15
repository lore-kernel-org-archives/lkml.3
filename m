Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbbAONAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 08:00:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50010 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbbAONAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 08:00:39 -0500
Date: Thu, 15 Jan 2015 04:59:38 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-2599094f6e381128cc274311758add604c1e108a@git.kernel.org>
Cc: tony.luck@intel.com, tglx@linutronix.de, joro@8bytes.org, oren@scalemp.com,
        linux-kernel@vger.kernel.org, jiang.liu@linux.intel.com,
        benh@kernel.crashing.org, hpa@zytor.com, d.hatayama@jp.fujitsu.com,
        rientjes@google.com, bp@alien8.de, yinghai@kernel.org,
        JBeulich@suse.com, mingo@kernel.org, richard@nod.at,
        hpa@linux.intel.com
Reply-To: tony.luck@intel.com, joro@8bytes.org, tglx@linutronix.de,
        yinghai@kernel.org, JBeulich@suse.com, bp@alien8.de,
        hpa@linux.intel.com, richard@nod.at, mingo@kernel.org,
        jiang.liu@linux.intel.com, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org, oren@scalemp.com, rientjes@google.com,
        d.hatayama@jp.fujitsu.com, hpa@zytor.com
In-Reply-To: <1420615903-28253-5-git-send-email-jiang.liu@linux.intel.com>
References: <1420615903-28253-5-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic: Panic if kernel doesn'
 t support x2apic but BIOS has enabled x2apic
Git-Commit-ID: 2599094f6e381128cc274311758add604c1e108a
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

Commit-ID:  2599094f6e381128cc274311758add604c1e108a
Gitweb:     http://git.kernel.org/tip/2599094f6e381128cc274311758add604c1e108a
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Wed, 7 Jan 2015 15:31:31 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 15 Jan 2015 11:24:22 +0100

x86/apic: Panic if kernel doesn't support x2apic but BIOS has enabled x2apic

When kernel doesn't support X2APIC but BIOS has enabled X2APIC, system
may panic or hang without useful messages. On the other hand, it's
hard to dynamically disable X2APIC when CONFIG_X86_X2APIC is disabled.
So panic with a clear message in such a case.

Now system panics as below when X2APIC is disabled and interrupt remapping
is enabled:
[    0.316118] LAPIC pending interrupts after 512 EOI
[    0.322126] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.368655] Kernel panic - not syncing: timer doesn't work through Interrupt-remapped IO-APIC
[    0.378300] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.18.0+ #340
[    0.385300] Hardware name: Intel Corporation BRICKLAND/BRICKLAND, BIOS BRIVTIN1.86B.0051.L05.1406240953 06/24/2014
[    0.396997]  ffff88046dc03000 ffff88046c307dd8 ffffffff8179dada 00000000000043f2
[    0.405629]  ffffffff81a92158 ffff88046c307e58 ffffffff8179b757 0000000000000002
[    0.414261]  0000000000000008 ffff88046c307e68 ffff88046c307e08 ffffffff813ad82b
[    0.422890] Call Trace:
[    0.425711]  [<ffffffff8179dada>] dump_stack+0x45/0x57
[    0.431533]  [<ffffffff8179b757>] panic+0xc1/0x1f5
[    0.436978]  [<ffffffff813ad82b>] ? delay_tsc+0x3b/0x70
[    0.442910]  [<ffffffff8166fa2c>] panic_if_irq_remap+0x1c/0x20
[    0.449524]  [<ffffffff81d73645>] setup_IO_APIC+0x405/0x82e
[    0.464979]  [<ffffffff81d6fcc2>] native_smp_prepare_cpus+0x2d9/0x31c
[    0.472274]  [<ffffffff81d5d0ac>] kernel_init_freeable+0xd6/0x223
[    0.479170]  [<ffffffff81792ad0>] ? rest_init+0x80/0x80
[    0.485099]  [<ffffffff81792ade>] kernel_init+0xe/0xf0
[    0.490932]  [<ffffffff817a537c>] ret_from_fork+0x7c/0xb0
[    0.497054]  [<ffffffff81792ad0>] ? rest_init+0x80/0x80
[    0.502983] ---[ end Kernel panic - not syncing: timer doesn't work through Interrupt-remapped IO-APIC

System hangs as below when X2APIC and interrupt remapping are both disabled:
[    1.102782] pci 0000:00:02.0: System wakeup disabled by ACPI
[    1.109351] pci 0000:00:03.0: System wakeup disabled by ACPI
[    1.115915] pci 0000:00:03.2: System wakeup disabled by ACPI
[    1.122479] pci 0000:00:03.3: System wakeup disabled by ACPI
[    1.132274] pci 0000:00:1c.0: Enabling MPC IRBNCE
[    1.137620] pci 0000:00:1c.0: Intel PCH root port ACS workaround enabled
[    1.145239] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    1.151790] pci 0000:00:1c.7: Enabling MPC IRBNCE
[    1.157128] pci 0000:00:1c.7: Intel PCH root port ACS workaround enabled
[    1.164748] pci 0000:00:1c.7: System wakeup disabled by ACPI
[    1.171447] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    1.178612] acpiphp: Slot [8] registered
[    1.183095] pci 0000:00:02.0: PCI bridge to [bus 01]
[    1.188867] acpiphp: Slot [2] registered

With this patch applied, the system panics in both cases with a proper
panic message.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: iommu@lists.linux-foundation.org
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Rientjes <rientjes@google.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Jan Beulich <JBeulich@suse.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Oren Twaig <oren@scalemp.com>
Link: http://lkml.kernel.org/r/1420615903-28253-5-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/apic.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 8a81a68..5446733 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1598,6 +1598,14 @@ void __init enable_IR_x2apic(void)
 	int ret, x2apic_enabled = 0;
 	int hardware_init_ret;
 
+	if (!IS_ENABLED(CONFIG_X86_X2APIC)) {
+		u64 msr;
+
+		rdmsrl(MSR_IA32_APICBASE, msr);
+		if (msr & X2APIC_ENABLE)
+			panic("BIOS has enabled x2apic but kernel doesn't support x2apic, please disable x2apic in BIOS.\n");
+	}
+
 	hardware_init_ret = irq_remapping_prepare();
 	if (hardware_init_ret && !x2apic_supported())
 		return;
