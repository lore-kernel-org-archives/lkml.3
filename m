Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbaBKVVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 16:21:36 -0500
Received: from www.linutronix.de ([62.245.132.108]:46259 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbaBKVVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 16:21:34 -0500
Date: Tue, 11 Feb 2014 22:21:38 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andy Lutomirski <luto@amacapital.net>
cc: Mike Galbraith <bitbucket@online.de>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: Too many rescheduling interrupts (still!)
In-Reply-To: <CALCETrVL44ewQPJXNwPAm2s5aj9auo2p4tYYieNcxANoL91VWw@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1402112219160.21991@ionos.tec.linutronix.de>
References: <CALCETrVL44ewQPJXNwPAm2s5aj9auo2p4tYYieNcxANoL91VWw@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Feb 2014, Andy Lutomirski wrote:

Just adding Peter for now, as I'm too tired to grok the issue right
now.

> Rumor has it that Linux 3.13 was supposed to get rid of all the silly
> rescheduling interrupts.  It doesn't, although it does seem to have
> improved the situation.
> 
> A small number of reschedule interrupts appear to be due to a race:
> both resched_task and wake_up_idle_cpu do, essentially:
> 
> set_tsk_need_resched(t);
> smb_mb();
> if (!tsk_is_polling(t))
>   smp_send_reschedule(cpu);
> 
> The problem is that set_tsk_need_resched wakes the CPU and, if the CPU
> is too quick (which isn't surprising if it was in C0 or C1), then it
> could *clear* TS_POLLING before tsk_is_polling is read.
> 
> Is there a good reason that TIF_NEED_RESCHED is in thread->flags and
> TS_POLLING is in thread->status?  Couldn't both of these be in the
> same field in something like struct rq?  That would allow a real
> atomic op here.
> 
> The more serious issue is that AFAICS default_wake_function is
> completely missing the polling check.  It goes through
> ttwu_queue_remote, which unconditionally sends an interrupt.
> 
> --Andy
> 
