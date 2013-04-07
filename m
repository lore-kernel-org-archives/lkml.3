Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab3DGFyh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 01:54:37 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:46375 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab3DGFyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 01:54:36 -0400
Message-ID: <51610A25.4010301@oracle.com>
Date: Sun, 07 Apr 2013 13:54:45 +0800
From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Reply-To: zhenzhong.duan@oracle.com
Organization: oracle
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xen-devel <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Feng Jin <joe.jin@oracle.com>, Tamon Shiose <tamon.shiose@oracle.com>
Subject: [PATCH-v2] xen: Don't call arch_trigger_all_cpu_backtrace in dom0(pvm)
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nmi isn't supported in dom0, fallback to general all cpu backtrace code.

Without fix, on xAPIC system, doing sysrq+l, no backtrace is showed,
as xen_send_IPI_all is called and it doesn't support nmi vector.

On x2APIC enabled system, got NULL pointer dereference as below.

    SysRq : Show backtrace of all active CPUs
    BUG: unable to handle kernel NULL pointer dereference at           (null)
    IP: [<ffffffff8125e3cb>] memcpy+0xb/0x120
    Call Trace:
     [<ffffffff81039633>] ? __x2apic_send_IPI_mask+0x73/0x160
     [<ffffffff8103973e>] x2apic_send_IPI_all+0x1e/0x20
     [<ffffffff8103498c>] arch_trigger_all_cpu_backtrace+0x6c/0xb0
     [<ffffffff81501be4>] ? _raw_spin_lock_irqsave+0x34/0x50
     [<ffffffff8131654e>] sysrq_handle_showallcpus+0xe/0x10
     [<ffffffff8131616d>] __handle_sysrq+0x7d/0x140
     [<ffffffff81316230>] ? __handle_sysrq+0x140/0x140
     [<ffffffff81316287>] write_sysrq_trigger+0x57/0x60
     [<ffffffff811ca996>] proc_reg_write+0x86/0xc0
     [<ffffffff8116dd8e>] vfs_write+0xce/0x190
     [<ffffffff8116e3e5>] sys_write+0x55/0x90
     [<ffffffff8150a242>] system_call_fastpath+0x16/0x1b

That's because apic points to apic_x2apic_cluster or apic_x2apic_phys
but the basic element like cpumask isn't initialized.

-v2: Mask x2APIC feature in pvm to avoid overwrite of apic pointer,
     update commit message per Konrad's suggestion.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Tested-by: Tamon Shiose <tamon.shiose@oracle.com>
---
 arch/x86/xen/enlighten.c |    3 +++
 include/linux/nmi.h      |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index c8e1c7b..12b0718 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -386,6 +386,9 @@ static void __init xen_init_cpuid_mask(void)
 		cpuid_leaf1_edx_mask &=
 			~((1 << X86_FEATURE_APIC) |  /* disable local APIC */
 			  (1 << X86_FEATURE_ACPI));  /* disable ACPI */
+
+	cpuid_leaf1_ecx_mask &= ~(1 << (X86_FEATURE_X2APIC % 32));
+
 	ax = 1;
 	cx = 0;
 	xen_cpuid(&ax, &bx, &cx, &dx);
diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index db50840..b845757 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -32,6 +32,8 @@ static inline void touch_nmi_watchdog(void)
 #ifdef arch_trigger_all_cpu_backtrace
 static inline bool trigger_all_cpu_backtrace(void)
 {
+	if (xen_domain())
+		return false;
 	arch_trigger_all_cpu_backtrace();
 
 	return true;
-- 
1.7.3

