Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617Ab3ERC1L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:27:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9220 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199Ab3ERCQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:49 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=p7jZFUqYi-cA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=iJK_KqH5CHIA:10 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=0AUmnEBeaMiSp7dXt0oA:9 a=7DSvI1NPTFQA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021645.419621071@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 023/136 ] xen/smp: Fix leakage of timer interrupt line for every CPU
 online/offline.
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0023-xen-smp-Fix-leakage-of-timer-interrupt-line-for-ever.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

[ Upstream commit 888b65b4bc5e7fcbbb967023300cd5d44dba1950 ]

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/xen/smp.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index f58dca7..3fc224d 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -667,6 +667,7 @@ static void xen_hvm_cpu_die(unsigned int cpu)
 	unbind_from_irqhandler(per_cpu(xen_debug_irq, cpu), NULL);
 	unbind_from_irqhandler(per_cpu(xen_callfuncsingle_irq, cpu), NULL);
 	unbind_from_irqhandler(per_cpu(xen_irq_work, cpu), NULL);
+	xen_teardown_timer(cpu);
 	native_cpu_die(cpu);
 }
 
-- 
1.7.10.4


