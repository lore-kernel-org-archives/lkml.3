Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933829Ab3EFXfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:35:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36700 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760436Ab3EFXN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 19:13:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 032/104] xen/smp/spinlock: Fix leakage of the spinlock interrupt line for every CPU online/offline
Date: Mon,  6 May 2013 16:11:51 -0700
Message-Id: <20130506230046.921948290@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506230043.526528358@linuxfoundation.org>
References: <20130506230043.526528358@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit 66ff0fe9e7bda8aec99985b24daad03652f7304e upstream.

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

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/xen/smp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -658,6 +658,7 @@ static void xen_hvm_cpu_die(unsigned int
 	unbind_from_irqhandler(per_cpu(xen_debug_irq, cpu), NULL);
 	unbind_from_irqhandler(per_cpu(xen_callfuncsingle_irq, cpu), NULL);
 	unbind_from_irqhandler(per_cpu(xen_irq_work, cpu), NULL);
+	xen_uninit_lock_cpu(cpu);
 	xen_teardown_timer(cpu);
 	native_cpu_die(cpu);
 }


