Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762Ab3DFIbo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 04:31:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:54715 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932735Ab3DFIbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 04:31:41 -0400
Date: Sat, 6 Apr 2013 10:31:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
cc: Dave Hansen <dave@sr71.net>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, dhillf@gmail.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: kernel BUG at kernel/smpboot.c:134!
In-Reply-To: <515FCAC6.8090806@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.02.1304061019000.21884@ionos>
References: <515F457E.5050505@sr71.net> <515FCAC6.8090806@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Apr 2013, Srivatsa S. Bhat wrote:

> Hi Dave,
> 
> On 04/06/2013 03:13 AM, Dave Hansen wrote:
> > Hey Thomas,
> > 
> > I seem to be running in to smpboot_thread_fn()'s
> > 
> > 	BUG_ON(td->cpu != smp_processor_id());

That should be WARN_ON of course. Stupid me.
 
> > pretty regularly, both at boot and if I boot with maxcpus=x and then
> > online the CPUs from sysfs after boot.  It's a 160-logical-cpu system,
> > so it's quite a beast.  I _seem_ to be hitting it more often at higher
> > cpu counts, but it doesn't trigger on bringing up a particular CPU as
> > far as I can tell.
> > 
> > This is on a pull of mainline from today, e0a77f263.  Any ideas?
> >
> 
> Dave Jones had reported a similar problem some time back and Hillf had
> proposed a fix. I guess it slipped through the cracks and never went
> upstream.
> 
> Here is the link: https://lkml.org/lkml/2013/1/19/1

This is Hillfs proposed patch:

> --- a/kernel/kthread.c	Sat Jan 19 13:03:52 2013
> +++ b/kernel/kthread.c	Sat Jan 19 13:17:54 2013
> @@ -306,6 +306,7 @@ struct task_struct *kthread_create_on_cp
>   	  return p;
> 	  set_bit(KTHREAD_IS_PER_CPU, &to_kthread(p)->flags);
> 	  to_kthread(p)->cpu = cpu;
> +	  __kthread_bind(p, cpu);
> 	  /* Park the thread to get it out of TASK_UNINTERRUPTIBLE state */
> 	  kthread_park(p);
> 	  return p;
 
That's bogus. Simply because when we create the thread then the thread
status is HP_THREAD_NONE and the path with the BUG_ON is only entered
with status == HP_THREAD_ACTIVE:

	if (ht->park && td->status == HP_THREAD_ACTIVE) {

So in Dave's case the thread was already created and has entered
active state.

> >> [  790.226909] Pid: 3909, comm: migration/135 Tainted: G        W    3.9.0-rc5-00184-gb6a9b7f-dirty #118 FUJITSU-SV PRIMEQUEST 1800E2/SB

Hmm, it's the migration thread which trips over this. Oh joy!

Dave, does the issue reproduce with function tracing enabled? For a
first shot it's probably enough to filter on smpboot_* functions plus
sched_switch and sched_wakeup events.

Thanks,

	tglx
