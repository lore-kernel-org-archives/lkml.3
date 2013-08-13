Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab3HMA3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 20:29:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4477 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059Ab3HMA3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 20:29:12 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=lGRwBxRWGKEA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=jE_6hgDtenQA:10 a=pGLkceISAAAA:8 a=S5W3k2AicAlnduVw2YUA:9 a=CjuIK1q_8ugA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Mon, 12 Aug 2013 20:29:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Shailaja Neelam <neelamshaila@gmail.com>
Cc: fweisbec@gmail.com, akpm@linux-foundation.org, anish198519851985@gmail.com,
        james.hogan@imgtec.com, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] fix a Sparse warning in the arch/x86/kernel/irq_work.c
 file
Message-ID: <20130812202909.373bc152@gandalf.local.home>
In-Reply-To: <CAOUhrBGcH4Oe32cDFs++a1UyKaGNfCm1sCG6UC4an_fO5vDjjQ@mail.gmail.com>
References: <CAOUhrBGcH4Oe32cDFs++a1UyKaGNfCm1sCG6UC4an_fO5vDjjQ@mail.gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Aug 2013 15:18:16 -0700
Shailaja Neelam <neelamshaila@gmail.com> wrote:

> I am a high school student trying to become familiar with the
> opensource process and linux kernel. This is my first submission to
> the ITC mailing list.

Hi Shailaja,

Welcome to Linux kernel development :-)

> 
> My patch is for the file arch/x86/kernel/irq_work.c in the vesion
> linux-3.10 kernel. When I ran the kernel with Sparse, the error read:
> arch/x86/kernel/irq_work.c:21:
> 6: warning: symbol 'arch_irq_work_raise'
> was not declared. Should it be static?
> 
> To fix this (rather than add static) I declared the symbol in the
> header file linux/irq_work.h.

Correct, because adding static would have been a bug.


> Afterwards, my error did not show up
> when I ran the kernel with Sparse again. I also ran the command "make
> menuconfig" to change the kernel version so that I could assure the
> correct kernel was running when I tested it, and it was. Then I test
> built the kernel. It built and rebooted correctly.

The patch looks good. Let me give you a bit more information and
background on that function. Just your FYI.

The purpose of irq_work() in general, is to trigger some event in a
critical location that is not safe to do the event you want to trigger.
For example, in perf, it may be executing within a Non-Maskable
Interrupt (NMI) or within the scheduler with the runqueue (rq) lock
held. If it would like to wake up a task that is monitoring the perf
output, it can't because to do so would require taking the rq lock and
possibly causing a deadlock.

Instead, it calls irq_work() to do the event within a normal interrupt
context. Some architectures have the ability to trigger an interrupt on
the current CPU that it is running on. This way, if we are in an NMI,
we trigger the self interrupt to the CPU, but because NMIs run with
interrupts disable, and the rq lock is held with interrupts disabled,
the interrupt will stay pending until interrupts are enabled again (out
of NMI and out from holding the rq lock). When interrupts are enabled,
the interrupt that we sent will trigger and run our event in a safe
location (someplace that allows for interrupts to be enabled).

But to do this self triggering of an interrupt requires specific
architecture knowledge. As Linux supports 30 architectures, and few
of us have hardware to test on each of these or even know how to write
code for all of them, we have ways to do things for just the
architectures we are familiar with. Some architectures may not even
have the ability to do what we want, even if we knew the architecture
well.

The "arch_irq_work_raise()" function is one of these cases. For
architectures that do not support a self triggering interrupt, or one
that we just didn't get to yet, we create a generic
arch_irq_work_raise() function that just does our work at the next
timer interrupt. This isn't the most efficient way, because that next
timer interrupt may be 10 milliseconds away. But we annotate that
function with the gcc "__attribute__((weak))" attribute (defined in
include/linux/compiler-gcc.h as "__weak").

What the __weak attribute does, is to tell the compiler (linker really)
that this function is to be used if it is not defined someplace else.
Then, in an architecture that has this specific optimization, we write
an arch_irq_work_raise() function without the "__weak" attribute, and
the linker will use that function instead at all of the call sites that
reference it. This way, the generic code can support architectures that
does the optimization as well as those that don't.


> 
> Signed-off-by: Shailaja Neelam <neelamshaila@gmail.com>

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


> ---
> --- linux-3.10/include/linux/irq_
> work.h    2013-06-30 15:13:29.000000000 -0700
> +++ linux-3.10.change/include/linux/irq_work.h    2013-07-24
> 12:06:15.521140635 -0700
> @@ -33,6 +33,7 @@ void init_irq_work(struct irq_work *work
>  void irq_work_queue(struct irq_work *work);
>  void irq_work_run(void);
>  void irq_work_sync(struct irq_work *work);
> +void arch_irq_work_raise(void);
> 
>  #ifdef CONFIG_IRQ_WORK
>  bool irq_work_needs_cpu(void);

