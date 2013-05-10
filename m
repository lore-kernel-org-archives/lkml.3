Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983Ab3EJO3M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:29:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57262 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755740Ab3EJOV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:21:57 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.726947006@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [035/118] xen/smp: Fix leakage of timer interrupt line for every
 CPU online/offline.
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/xen/smp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -563,6 +563,7 @@ static void xen_hvm_cpu_die(unsigned int
 	unbind_from_irqhandler(per_cpu(xen_callfunc_irq, cpu), NULL);
 	unbind_from_irqhandler(per_cpu(xen_debug_irq, cpu), NULL);
 	unbind_from_irqhandler(per_cpu(xen_callfuncsingle_irq, cpu), NULL);
+	xen_teardown_timer(cpu);
 	native_cpu_die(cpu);
 }
 

