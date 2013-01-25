Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab3AYAdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 19:33:25 -0500
Received: from mail-ve0-f171.google.com ([209.85.128.171]:40325 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab3AYAdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 19:33:17 -0500
X-Greylist: delayed 88846 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jan 2013 19:33:17 EST
MIME-Version: 1.0
In-Reply-To: <20130112173144.GA22338@redhat.com>
References: <CANN689HRmVTLCjNL9c=JqhWy5F5vwr=A7coo3TVKLZGSVUpQjw@mail.gmail.com>
	<20130109174922.GA31211@redhat.com>
	<CANN689FEr+vFdNekW9hm7xwji1aX4FCUQ1BS=P3FhyKiC70qjg@mail.gmail.com>
	<20130112173144.GA22338@redhat.com>
Date: Thu, 24 Jan 2013 16:33:16 -0800
Message-ID: <CANN689E4d=E5Gr-AU5N2KE2ES32cB+DfLU3E_Ucah50jXvmGcQ@mail.gmail.com>
Subject: Re: rwlock_t unfairness and tasklist_lock
From: Michel Lespinasse <walken@google.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: David Howells <dhowells@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Salman Qazi <sqazi@google.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2013 at 9:31 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 01/09, Michel Lespinasse wrote:
>> >> - Would there be any fundamental objection to implementing a fair
>> >> rwlock_t and dealing with the reentrancy issues in tasklist_lock ? My
>> >> proposal there would be along the lines of:
>> >
>> > I don't really understand your proposal in details, but until we kill
>> > tasklist_lock, perhaps it makes sense to implement something simple, say,
>> > write-biased rwlock and add "int task_struct->tasklist_read_lock_counter"
>> > to avoid the read-write-read deadlock.
>>
>> Right. But one complexity that has to be dealt with, is how to handle
>> reentrant uses of the tasklist_lock read side,
>> ...
>>
>> there is still the
>> possibility of an irq coming up in before the counter is incremented.
>
> Sure, I didn't try to say that it is trivial to implement
> read_lock_tasklist(), we should prevent this race.
>
>> So to deal with that, I think we have to explicitly detect the
>> tasklist_lock uses that are in irq/softirq context and deal with these
>> differently from those in process context
>
> I disagree. In the long term, I think that tasklist (or whatever we use
> instead) should be never used in irq/atomic context. And probably the
> per-process lock should be rw_semaphore (although it is not recursive).

All right. So I went through all tasklist_lock call sites, and
converted them to use helper functions:

First 4 are for the sites I know are only used in process context:
tasklist_write_lock() / tasklist_write_unlock() / tasklist_read_lock()
/ tasklist_read_unlock()

Remaining ones are for the sites that can be called from irq/softirq
context as well:
tassklist_read_lock_any() / tasklist_read_trylock_any() /
tasklist_read_unlock_any()

I'm not sure if upstream would take these ? IMO, it helps to identify
the irq context call sites. If I didn't get it wrong, they are:

- send_sigio(): may be called in any context from kill_fasync()
  (examples: process context from pipe_read(), softirq context from
   n_tty_receive_buf(), hardirq context from rtc_interrupt())

- send_sigurg(): may be called from process or softirq context
  (network receive is typically processed in softirq, but packets can be
   queued up while sockets are being locked and the backlog processed from
   process context as the socket gets unlocked)

- kill_pgrp(): called in process context from job_control(), pty_resize()
  or in softirq context through n_tty_receive_buf()
  or even in hardirq context from arch/um/drivers/line.c winch_interrupt()

- posix_cpu_timer_schedule(): called through cpu_timer_fire(),
  in process context (from posix_cpu_timer_set()) or
  in hardirq context (from run_posix_cpu_timers())

- sysrq debugging features: handle_sysrq() runs in multiple contexts and
  calls into send_sig_all(), debug_show_all_locks(), normalize_rt_tasks(),
  print_rq().

- arch/blackfin/kernel/trace.c decode_address(): another debugging feature,
  may be called from any contexts.

I suppose we could do away with the sysrq stuff (or run it in a work
queue or whatever). This leaves us with signal delivery and posix cpu
timers. To be honest, I looked at signal delivery and couldn't tell
why it needs to take the tasklist_lock, but I also couldn't remove it
in any way that I would feel safe about :)

> But until then, if we try to improve the things somehow, we should not
> complicate the code, we need something simple.
>
> But actually I am not sure, you can be right.

I actually also have an implementation that makes tasklist_lock fair
for process context call sites. It's easy enough if you can use a
split lock for the process vs irq context uses. But I agree it'd be
much nicer / more upstreamable if we could just get rid of the irq
context uses first, at which point there is no remaining obstacle to
replacing rwlock_t with a fair lock.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
