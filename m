Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759164Ab3EFVNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 17:13:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59034 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757398Ab3EFUqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:46:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 033/115] xen/smp: Fix leakage of timer interrupt line for every CPU online/offline.
Date: Mon,  6 May 2013 13:44:29 -0700
Message-Id: <20130506203058.970211248@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506203055.537199268@linuxfoundation.org>
References: <20130506203055.537199268@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit 888b65b4bc5e7fcbbb967023300cd5d44dba1950 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/xen/smp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -662,6 +662,7 @@ static void xen_hvm_cpu_die(unsigned int
 	unbind_from_irqhandler(per_cpu(xen_debug_irq, cpu), NULL);
 	unbind_from_irqhandler(per_cpu(xen_callfuncsingle_irq, cpu), NULL);
 	unbind_from_irqhandler(per_cpu(xen_irq_work, cpu), NULL);
+	xen_teardown_timer(cpu);
 	native_cpu_die(cpu);
 }
 


