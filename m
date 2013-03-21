Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932813Ab3CUWzt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 18:55:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25717 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167Ab3CUWzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 18:55:48 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=C9_bW7JfhfAA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=nCYlKkaQDMwA:10 a=zzCkzv0pq2-_bC2O4I4A:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363906545.6345.81.camel@gandalf.local.home>
Subject: [RT LATENCY] 249 microsecond latency caused by slub's
 unfreeze_partials() code.
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Lameter <cl@linux.com>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <clark@redhat.com>
Date: Thu, 21 Mar 2013 18:55:45 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph,

I've been trying to hunt down a latency on a 40 core box, where funny,
the more tracing we enabled the less likely it would hit. It would take
up to 12 hours to hit the latency, and if we had too much tracing on, it
never would hit :-p

Thus I would add little by little to find where things were going bad. I
found the timer interrupt was triggering late. I then traced with:

trace-cmd start -p function --func-stack -e irq -e raw_syscalls -e 'sched_wakeup*' \
  -e sched_switch -e hrtimer_start -e hrtimer_expire_entry

I kicked off the test again, when it detected a latency it would stop
tracing, I extract the trace data from the buffers, send it to my
workstation and analyze it.

I found this:


hackbenc-61738  39d...0 238202.164474: function:             smp_apic_timer_interrupt
hackbenc-61738  39d...0 238202.164484: kernel_stack:         <stack
trace>
=> apic_timer_interrupt (ffffffff81528077)
=> retint_kernel (ffffffff81520967)
=> __slab_free (ffffffff8115517a)
=> kfree (ffffffff811554e1)
=> skb_free_head (ffffffff8143b9ee)
=> skb_release_data (ffffffff8143c830)
=> __kfree_skb (ffffffff8143c8be)
=> consume_skb (ffffffff8143c9c1)
=> unix_stream_recvmsg (ffffffff814ecd88)
=> sock_aio_read (ffffffff81431f6e)
=> do_sync_read (ffffffff8115fdea)
=> vfs_read (ffffffff811605c0)
=> sys_read (ffffffff811606e1)
=> tracesys (ffffffff8152778d)

That __slab_free() happened here:

   0xffffffff81155160 <+544>:	cmpb   $0x0,-0x55(%rbp)
   0xffffffff81155164 <+548>:	jns    0xffffffff8115509e <__slab_free+350>
   0xffffffff8115516a <+554>:	mov    $0x1,%edx
   0xffffffff8115516f <+559>:	mov    %r13,%rsi
   0xffffffff81155172 <+562>:	mov    %r15,%rdi
   0xffffffff81155175 <+565>:	callq  0xffffffff81154d90 <put_cpu_partial>
   0xffffffff8115517a <+570>:	jmpq   0xffffffff8115509e <__slab_free+350>
   0xffffffff8115517f <+575>:	mov    %r8,-0xf8(%rbp)


The ffffffff8115517a is just before put_cpu_partial() which calls
unfreeze_partials() with irqs disabled. So I started tracing again, this
time with:

trace-cmd start -p function_graph -l smp_apic_timer_interrupt -l unfreeze_partials \
  -e irq -e raw_syscalls -e 'sched_wakeup*' -e sched_switch -e hrtimer_start \
  -e hrtimer_expire_entry

The difference was instead of tracing the function
smp_apic_timer_interrupt and its stack trace, I decided to trace the
function graph of unfreeze_partials, and by only selecting that
function, it gives me a good idea of how long that function runs. Here's
the result:

hackbenc-80563  14...10 262219.108980: sys_exit:             NR 0 = 100
hackbenc-80563  14...10 262219.108981: sys_enter:            NR 0 (a, 7fff1b700d50, 64, 8, 7fff1b700c80, 138ef)
hackbenc-80563  14d...0 262219.108982: funcgraph_entry:      ! 249.510 us |  unfreeze_partials();
hackbenc-80563  14d...0 262219.109233: funcgraph_entry:                   |  smp_apic_timer_interrupt() {
hackbenc-80563  14d.h10 262219.109234: hrtimer_expire_entry: hrtimer=0xffff881fcf731e88 now=262298497076329 function=hrtimer_wakeup/0x0
hackbenc-80563  14d.h30 262219.109235: sched_wakeup:         cyclictest:33010 [4] success=1 CPU:014


It ran for 249.51 microseconds!!! With interrupts disabled! This was
what caused the interrupt to go off late. I have no idea why adding
tracing makes this latency go away. Perhaps it changes the timings just
enough to not let things line up?

I did a report with '-R' and showing the raw events, which will show the
exit part of the function graph we have:

   <...>-80563  14d...0 262219.108982: funcgraph_entry:       func=0xffffffff81154954 depth=0
   <...>-80563  14d...0 262219.109233: funcgraph_exit:        func=0xffffffff81154954 calltime=0xee7ca4d8200f rettime=0xee7ca4dbeeb5 overrun=0x0 depth=0
   <...>-80563  14d...0 262219.109233: funcgraph_entry:       func=0xffffffff81528e47 depth=0

The funcgraph_exit is within the same microsecond the
smp_apic_timer_interrupt() went off, so yes this is what delayed it.

Anyway, this is run on 3.6.11-rt30, but looking at the current code, it
doesn't look like it changed in any meaningful way. The while ((page =
c->partial)) makes me nervous. How big can this list be? Is there a way
to limit the amount this can run?

Thanks!

-- Steve


