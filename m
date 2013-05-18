Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558Ab3ERC1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:27:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4553 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756233Ab3ERCQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:49 -0400
X-Authority-Analysis: v=2.0 cv=L+efspv8 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=67R-nQQk79sA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=bjsJvxqRM9cA:10 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=2P_yjdDCiPxNvVu0absA:9 a=7DSvI1NPTFQA:10 a=jeBq3FmKZ4MA:10 a=x2pSk5NLVyX0FJlV:21 a=o4NAIQm9Z9bu5PUa:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021645.585397709@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 024/136 ] xen/smp/spinlock: Fix leakage of the spinlock interrupt line for
 every CPU online/offline
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0024-xen-smp-spinlock-Fix-leakage-of-the-spinlock-interru.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

[ Upstream commit 66ff0fe9e7bda8aec99985b24daad03652f7304e ]

While we don't use the spinlock interrupt line (see for details
commit f10cd522c5fbfec9ae3cc01967868c9c2401ed23 -
xen: disable PV spinlocks on HVM) - we should still do the proper
init / deinit sequence. We did not do that correctly and for the
CPU init for PVHVM guest we would allocate an interrupt line - but
failed to deallocate the old interrupt line.

This resulted in leakage of an irq_desc but more importantly this splat
as we online an offlined CPU:

genirq: Flags mismatch irq 71. 0002cc20 (spinlock1) vs. 0002cc20 (spinlock1)
Pid: 2542, comm: init.late Not tainted 3.9.0-rc6upstream #1
Call Trace:
 [<ffffffff811156de>] __setup_irq+0x23e/0x4a0
 [<ffffffff81194191>] ? kmem_cache_alloc_trace+0x221/0x250
 [<ffffffff811161bb>] request_threaded_irq+0xfb/0x160
 [<ffffffff8104c6f0>] ? xen_spin_trylock+0x20/0x20
 [<ffffffff813a8423>] bind_ipi_to_irqhandler+0xa3/0x160
 [<ffffffff81303758>] ? kasprintf+0x38/0x40
 [<ffffffff8104c6f0>] ? xen_spin_trylock+0x20/0x20
 [<ffffffff810cad35>] ? update_max_interval+0x15/0x40
 [<ffffffff816605db>] xen_init_lock_cpu+0x3c/0x78
 [<ffffffff81660029>] xen_hvm_cpu_notify+0x29/0x33
 [<ffffffff81676bdd>] notifier_call_chain+0x4d/0x70
 [<ffffffff810bb2a9>] __raw_notifier_call_chain+0x9/0x10
 [<ffffffff8109402b>] __cpu_notify+0x1b/0x30
 [<ffffffff8166834a>] _cpu_up+0xa0/0x14b
 [<ffffffff816684ce>] cpu_up+0xd9/0xec
 [<ffffffff8165f754>] store_online+0x94/0xd0
 [<ffffffff8141d15b>] dev_attr_store+0x1b/0x20
 [<ffffffff81218f44>] sysfs_write_file+0xf4/0x170
 [<ffffffff811a2864>] vfs_write+0xb4/0x130
 [<ffffffff811a302a>] sys_write+0x5a/0xa0
 [<ffffffff8167ada9>] system_call_fastpath+0x16/0x1b
cpu 1 spinlock event irq -16
smpboot: Booting Node 0 Processor 1 APIC 0x2

And if one looks at the /proc/interrupts right after
offlining (CPU1):

  70:          0          0  xen-percpu-ipi       spinlock0
  71:          0          0  xen-percpu-ipi       spinlock1
  77:          0          0  xen-percpu-ipi       spinlock2

There is the oddity of the 'spinlock1' still being present.

CC: stable@vger.kernel.org
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/xen/smp.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 3fc224d..641c91e 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -667,6 +667,7 @@ static void xen_hvm_cpu_die(unsigned int cpu)
 	unbind_from_irqhandler(per_cpu(xen_debug_irq, cpu), NULL);
 	unbind_from_irqhandler(per_cpu(xen_callfuncsingle_irq, cpu), NULL);
 	unbind_from_irqhandler(per_cpu(xen_irq_work, cpu), NULL);
+	xen_uninit_lock_cpu(cpu);
 	xen_teardown_timer(cpu);
 	native_cpu_die(cpu);
 }
-- 
1.7.10.4


