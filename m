Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901AbaBLP7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 10:59:55 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:36988 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaBLP7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 10:59:53 -0500
MIME-Version: 1.0
In-Reply-To: <20140212101324.GC3545@laptop.programming.kicks-ass.net>
References: <CALCETrVL44ewQPJXNwPAm2s5aj9auo2p4tYYieNcxANoL91VWw@mail.gmail.com>
	<alpine.DEB.2.02.1402112219160.21991@ionos.tec.linutronix.de>
	<CALCETrUPyG1HoXFToXuVLOzX2f20zzxJyABKASOUPY691JmjMA@mail.gmail.com>
	<20140212101324.GC3545@laptop.programming.kicks-ass.net>
Date: Wed, 12 Feb 2014 16:59:52 +0100
Message-ID: <CAFTL4hyJtUHaT39NmM71=Ho4fp28PJ+-KezQryXJE_gTEMaHqA@mail.gmail.com>
Subject: Re: Too many rescheduling interrupts (still!)
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <bitbucket@online.de>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-12 11:13 GMT+01:00 Peter Zijlstra <peterz@infradead.org>:
> On Tue, Feb 11, 2014 at 02:34:11PM -0800, Andy Lutomirski wrote:
>> On Tue, Feb 11, 2014 at 1:21 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> >> A small number of reschedule interrupts appear to be due to a race:
>> >> both resched_task and wake_up_idle_cpu do, essentially:
>> >>
>> >> set_tsk_need_resched(t);
>> >> smb_mb();
>> >> if (!tsk_is_polling(t))
>> >>   smp_send_reschedule(cpu);
>> >>
>> >> The problem is that set_tsk_need_resched wakes the CPU and, if the CPU
>> >> is too quick (which isn't surprising if it was in C0 or C1), then it
>> >> could *clear* TS_POLLING before tsk_is_polling is read.
>
> Yeah we have the wrong default for the idle loops.. it should default to
> polling and only switch to !polling at the very last moment if it really
> needs an interrupt to wake.
>
> Changing this requires someone (probably me again :/) to audit all arch
> cpu idle drivers/functions.

Looking at wake_up_idle_cpu(), we set need_resched and send the IPI.
On the other end, the CPU wakes up, exits the idle loop and even goes
to the scheduler while there is probably no task to schedule.

I wonder if this is all necessary. All we need is the timer to be
handled by the dynticks code to re-evaluate the next tick. So calling
irq_exit() -> tick_nohz_irq_exit() from the scheduler_ipi() should be
enough.

We could use a specific flag set before smp_send_reschedule() and read
in scheduler_ipi() entry to check if we need irq_entry()/irq_exit().
