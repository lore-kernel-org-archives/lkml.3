Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479Ab3GGClw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 22:41:52 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:50600 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab3GGClp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 22:41:45 -0400
Date: Sun, 7 Jul 2013 10:41:13 +0800
From: Wang YanQing <udknight@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Chuansheng Liu <chuansheng.liu@intel.com>, mingo@kernel.org,
        peterz@infradead.org, jbeulich@suse.com, paulmck@linux.vnet.ibm.com,
        akpm@linux-foundation.org, mina86@mina86.org,
        srivatsa.bhat@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        jun.zhang@intel.com, fengguang.wu@intel.com
Subject: Re: [PATCH V2] smp: Give WARN()ing when calling
 smp_call_function_many()/single() in serving irq
Message-ID: <20130707024113.GA2767@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Chuansheng Liu <chuansheng.liu@intel.com>, mingo@kernel.org,
	peterz@infradead.org, jbeulich@suse.com, paulmck@linux.vnet.ibm.com,
	akpm@linux-foundation.org, mina86@mina86.org,
	srivatsa.bhat@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
	jun.zhang@intel.com, fengguang.wu@intel.com
References: <1360163901.24670.13.camel@cliu38-desktop-build>
 <1361023075.11130.12.camel@cliu38-desktop-build>
 <1361023812.11130.15.camel@cliu38-desktop-build>
 <alpine.DEB.2.02.1307051548430.32106@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1307051548430.32106@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 05, 2013 at 03:50:57PM +0200, Thomas Gleixner wrote:
> On Sat, 16 Feb 2013, Chuansheng Liu wrote:
> > There is a real case for softirq DEADLOCK case:
> > 
> > CPUA                            CPUB
> >                                 spin_lock(&spinlock)
> >                                 Any irq coming, call the irq handler
> >                                 irq_exit()
> > spin_lock_irq(&spinlock)
> > <== Blocking here due to
> > CPUB hold it
> >                                   __do_softirq()
> >                                     run_timer_softirq()
> >                                       timer_cb()
> >                                         call smp_call_function_many()
> >                                           send IPI interrupt to CPUA
> >                                             wait_csd()
> > 
> > Then both CPUA and CPUB will be deadlocked here.
> 

Why can't we just use spin_lock_irq instead of spin_lock in CPUB to
prevent this to happen ?

And the according senario for kernel/smp.c is to use raw_spin_lock_irqsave
instead of raw_spin_lock in generic_smp_call_function_single_interrupt
to protect the follow one line codes:

        raw_spin_lock(&q->lock);
        list_replace_init(&q->list, &list);
        raw_spin_unlock(&q->lock);

Thanks.
