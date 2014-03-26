Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbaCZRbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 13:31:16 -0400
Received: from www.linutronix.de ([62.245.132.108]:33881 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaCZRbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 13:31:13 -0400
Date: Wed, 26 Mar 2014 18:31:18 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
cc: Viresh Kumar <viresh.kumar@linaro.org>, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        linaro-networking@linaro.org
Subject: Re: [PATCH 04/14] hrtimer: use base->index instead of basenum in
 switch_hrtimer_base()
In-Reply-To: <5332BD50.1070600@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.02.1403261830400.21095@ionos.tec.linutronix.de>
References: <cover.1395832156.git.viresh.kumar@linaro.org> <535a552cd2c05a3ae2cb61da2583646e1c649699.1395832156.git.viresh.kumar@linaro.org> <5332BD50.1070600@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2014, Srivatsa S. Bhat wrote:
> On 03/26/2014 04:51 PM, Viresh Kumar wrote:
> > In switch_hrtimer_base() we have created a local variable basenum which is set
> > to base->index. This variable is used at only one place. It makes code more
> > readable if we remove this variable use base->index directly.
> > 
> 
> No, this doesn't look right. Note that the code can re-execute
> the assignment to new_base, by jumping to the 'again' label.
> See below.
> 
> > --- a/kernel/hrtimer.c
> > +++ b/kernel/hrtimer.c
> > @@ -202,11 +202,10 @@ switch_hrtimer_base(struct hrtimer *timer, struct hrtimer_clock_base *base,
> >  	struct hrtimer_cpu_base *new_cpu_base;
> >  	int this_cpu = smp_processor_id();
> >  	int cpu = get_nohz_timer_target(pinned);
> > -	int basenum = base->index;
> > 
> >  again:
> >  	new_cpu_base = &per_cpu(hrtimer_bases, cpu);
> > -	new_base = &new_cpu_base->clock_base[basenum];
> > +	new_base = &new_cpu_base->clock_base[base->index];
> > 
> 
> Further down, timer->base can be altered (and set to NULL too).
> So if we jump back to 'again', we'll end up in trouble.
> So I think its important to cache the value in basenum and
> use it.

That's irrelevant. base is not changing.
