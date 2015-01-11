Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600AbbAKMGK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 07:06:10 -0500
Received: from mx-relay15.cloudservice.ag ([81.20.94.70]:45586 "EHLO
	mx-relay15.cloudservice.ag" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750773AbbAKMGD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 07:06:03 -0500
X-Greylist: delayed 374 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Jan 2015 07:06:03 EST
From: "Stoidner, Christoph" <c.stoidner@arvero.de>
To: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: AW: Question concerning RCU
Thread-Topic: Question concerning RCU
Thread-Index: AQHQKdgN5pYhqCTrrEydsWtlbI+1KpyzbZSAgAdiVA4=
Date: Sun, 11 Jan 2015 11:59:45 +0000
Message-ID: <81b94fc89c774b71a967fc93823e9c63@EX132MBOX1A.de2.local>
References: <94921a144a97457385ae95b838c3c6fa@EX132MBOX1A.de2.local>,<20150106194317.GG5280@linux.vnet.ibm.com>
In-Reply-To: <20150106194317.GG5280@linux.vnet.ibm.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [217.91.168.120]
x-exclaimer-md-config: 2329e0da-e5c9-454a-b62b-9269baa51382
x-hoag-tnef: done
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-cloud-security-sender: c.stoidner@oujhf.hostedoffice.ag
X-cloud-security-recipient: linux-kernel@vger.kernel.org
X-cloud-security-Virusscan: CLEAN
X-cloud-security-disclaimer: This E-Mail was scanned by E-Mailservice on mx-gate15 with 879A22118001
X-cloud-security-connect: fw1.hostedoffice.ag[81.20.90.82], TLS=, IP=81.20.90.82
X-cloud-security: scantime:.1586
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Paul,

many thanks for your fast answer!

Now I have changed my application in that way, that it does not require 
Xenomai/I-Pipe anymore. That means my kernel is build now from 
mainline source, with preempt_rt only and no Xenomai or I-Pipe. 
However the problem is exact the same. After some runtime (minutes 
or hours) the kernel freezes and JTAG debugging shows that it ends-up 
in an endless loop in rcu_print_task_stall (as described before). 

> First I have seen this.  Were you doing lots of CPU-hotplug operations?

My system has only one core. So I think there should not be any 
CPU-hotplugging.

> If you have more CPUs than the value of CONFIG_RCU_FANOUT (which
> defaults to 16), and if your workload offlined a full block of CPUs (full
> blocks being CPUs 0-15, 16-31, 32-47, and so on for the default value
> of CONFIG_RCU_FANOUT), then there is a theoretical issue that -might-
> cause the problem that you are seeing.

Also this could not only happen on a single core system. Am I right?

I have no idea how to find the problem. Do you have any more hints or ideas?

Here is a backtrace when the problem has occurred on the system without Xenomai/I-Pipe:

#0  rcu_print_task_stall (rnp=0xc0498dc8 <rcu_preempt_state>) at kernel/rcutree_plugin.h:528
#1  0xc005cabc in print_other_cpu_stall (rsp=0xc0498dc8 <rcu_preempt_state>) at kernel/rcutree.c:885
#2  check_cpu_stall (rdp=0x80000093, rsp=0xc0498dc8 <rcu_preempt_state>) at kernel/rcutree.c:977
#3  __rcu_pending (rdp=0x80000093, rsp=0xc0498dc8 <rcu_preempt_state>) at kernel/rcutree.c:2750
#4  rcu_pending (cpu=<optimized out>) at kernel/rcutree.c:2800
#5  rcu_check_callbacks (cpu=<optimized out>, user=<optimized out>) at kernel/rcutree.c:2179
#6  0xc0027648 in update_process_times (user_tick=0) at kernel/timer.c:1427
#7  0xc004e840 in tick_sched_timer (timer=0xc0498860 <tick_cpu_sched>) at kernel/time/tick-sched.c:1095
#8  0xc003a0dc in __run_hrtimer (timer=0xc0498860 <tick_cpu_sched>, now=<optimized out>) at kernel/hrtimer.c:1363
#9  0xc003ab4c in hrtimer_interrupt (dev=<optimized out>) at kernel/hrtimer.c:1582
#10 0xc02bf7bc in mxs_timer_interrupt (irq=<optimized out>, dev_id=<optimized out>) at drivers/clocksource/mxs_timer.c:132
#11 0xc0055154 in handle_irq_event_percpu (desc=0xc7804c00, action=0xc04b0520 <mxs_timer_irq>) at kernel/irq/handle.c:144
#12 0xc0055320 in handle_irq_event (desc=0xc7804c00) at kernel/irq/handle.c:197
#13 0xc00578b8 in handle_level_irq (irq=<optimized out>, desc=0xc7804c00) at kernel/irq/chip.c:406
#14 0xc0054aec in generic_handle_irq_desc (desc=<optimized out>, irq=16) at include/linux/irqdesc.h:115
#15 generic_handle_irq (irq=16) at kernel/irq/irqdesc.c:314
#16 0xc000f58c in handle_IRQ (irq=16, regs=<optimized out>) at arch/arm/kernel/irq.c:80
#17 0xc000e360 in __irq_svc () at arch/arm/kernel/entry-armv.S:202
#18 0xc000e360 in __irq_svc () at arch/arm/kernel/entry-armv.S:202
#19 0xc000e360 in __irq_svc () at arch/arm/kernel/entry-armv.S:202
#20 0xc000e360 in __irq_svc () at arch/arm/kernel/entry-armv.S:202
...

Thanks and regards,
Christoph
