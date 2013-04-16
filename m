Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936145Ab3DPUJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 16:09:19 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:22385 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935907Ab3DPUJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 16:09:17 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: stefano.stabellini@eu.citrix.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, stable@vger.kernel.org
Subject: [PATCH 1/9] xen/smp: Fix leakage of timer interrupt line for every CPU online/offline.
Date: Tue, 16 Apr 2013 16:08:59 -0400
Message-Id: <1366142947-18655-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1366142947-18655-1-git-send-email-konrad.wilk@oracle.com>
References: <1366142947-18655-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the PVHVM path when we do CPU online/offline path we would
leak the timer%d IRQ line everytime we do a offline event. The
online path (xen_hvm_setup_cpu_clockevents via
x86_cpuinit.setup_percpu_clockev) would allocate a new interrupt
line for the timer%d.

But we would still use the old interrupt line leading to:

kernel BUG at /home/konrad/ssd/konrad/linux/kernel/hrtimer.c:1261!
invalid opcode: 0000 [#1] SMP
RIP: 0010:[<ffffffff810b9e21>]  [<ffffffff810b9e21>] hrtimer_interrupt+0x261/0x270
.. snip..
 <IRQ>
 [<ffffffff810445ef>] xen_timer_interrupt+0x2f/0x1b0
 [<ffffffff81104825>] ? stop_machine_cpu_stop+0xb5/0xf0
 [<ffffffff8111434c>] handle_irq_event_percpu+0x7c/0x240
 [<ffffffff811175b9>] handle_percpu_irq+0x49/0x70
 [<ffffffff813a74a3>] __xen_evtchn_do_upcall+0x1c3/0x2f0
 [<ffffffff813a760a>] xen_evtchn_do_upcall+0x2a/0x40
 [<ffffffff8167c26d>] xen_hvm_callback_vector+0x6d/0x80
 <EOI>
 [<ffffffff81666d01>] ? start_secondary+0x193/0x1a8
 [<ffffffff81666cfd>] ? start_secondary+0x18f/0x1a8

There is also the oddity (timer1) in the /proc/interrupts after
offlining CPU1:

  64:       1121          0  xen-percpu-virq      timer0
  78:          0          0  xen-percpu-virq      timer1
  84:          0       2483  xen-percpu-virq      timer2

This patch fixes it.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: stable@vger.kernel.org
---
 arch/x86/xen/smp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 09ea61d..f80e69c 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -662,6 +662,7 @@ static void xen_hvm_cpu_die(unsigned int cpu)
 	unbind_from_irqhandler(per_cpu(xen_debug_irq, cpu), NULL);
 	unbind_from_irqhandler(per_cpu(xen_callfuncsingle_irq, cpu), NULL);
 	unbind_from_irqhandler(per_cpu(xen_irq_work, cpu), NULL);
+	xen_teardown_timer(cpu);
 	native_cpu_die(cpu);
 }
 
-- 
1.8.1.4

