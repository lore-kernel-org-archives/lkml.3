Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464Ab3CADhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 22:37:18 -0500
Received: from mga09.intel.com ([134.134.136.24]:31648 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894Ab3CADhQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 22:37:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,758,1355126400"; 
   d="scan'208";a="292131366"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Lai Jiangshan <eag0628@gmail.com>
CC: "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "jbeulich@suse.com" <jbeulich@suse.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mina86@mina86.org" <mina86@mina86.org>,
        "srivatsa.bhat@linux.vnet.ibm.com" <srivatsa.bhat@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhang, Jun" <jun.zhang@intel.com>,
        "Wu, Fengguang" <fengguang.wu@intel.com>
Subject: RE: [PATCH V2] smp: Give WARN()ing when calling
 smp_call_function_many()/single() in serving irq
Thread-Topic: [PATCH V2] smp: Give WARN()ing when calling
 smp_call_function_many()/single() in serving irq
Thread-Index: AQHOFPnYZzR13Lbn4kqCOXdqJ2GuPZiQMIyw
Date: Fri, 1 Mar 2013 03:37:11 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A2427D4@SHSMSX101.ccr.corp.intel.com>
References: <1360163901.24670.13.camel@cliu38-desktop-build>
	<1361023075.11130.12.camel@cliu38-desktop-build>
	<1361023812.11130.15.camel@cliu38-desktop-build>
 <CACvQF51cfqYk3idypNrQ54TOYJSPYvzR+1TTRBOQ5_vH8etwWw@mail.gmail.com>
In-Reply-To: <CACvQF51cfqYk3idypNrQ54TOYJSPYvzR+1TTRBOQ5_vH8etwWw@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Lai Jiangshan [mailto:eag0628@gmail.com]
> Sent: Wednesday, February 27, 2013 10:51 PM
> To: Liu, Chuansheng
> Cc: mingo@kernel.org; peterz@infradead.org; jbeulich@suse.com;
> paulmck@linux.vnet.ibm.com; akpm@linux-foundation.org;
> mina86@mina86.org; srivatsa.bhat@linux.vnet.ibm.com;
> linux-kernel@vger.kernel.org; Zhang, Jun; Wu, Fengguang
> Subject: Re: [PATCH V2] smp: Give WARN()ing when calling
> smp_call_function_many()/single() in serving irq
> 
> On Sat, Feb 16, 2013 at 10:10 PM, Chuansheng Liu
> <chuansheng.liu@intel.com> wrote:
> > Currently the functions smp_call_function_many()/single() will
> > give a WARN()ing only in the case of irqs_disabled(), but that
> > check is not enough to guarantee execution of the SMP
> > cross-calls.
> >
> > In many other cases such as softirq handling/interrupt handling,
> > the two APIs still can not be called, just as the
> > smp_call_function_many() comments say:
> >
> >   * You must not call this function with disabled interrupts or from a
> >   * hardware interrupt handler or from a bottom half handler. Preemption
> >   * must be disabled when calling this function.
> >
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
> >                                         call
> smp_call_function_many()
> >                                           send IPI interrupt to
> CPUA
> >                                             wait_csd()
> >
> > Then both CPUA and CPUB will be deadlocked here.
> >
> > So we should give a warning in the nmi, hardirq or softirq context as well.
> >
> > Moreover, adding one new macro in_serving_irq() which indicates
> > we are processing nmi, hardirq or sofirq.
> 
> The code smells bad. in_serving_softirq() don't take spin_lock_bh() in account.
> 
> CPUA                    CPUB                             CPUC
>                         spin_lock(&lockA)
>                           Any irq coming, call
>                           the irq handler
>                           irq_exit()
> spin_lock_irq(&lockA)
> *Blocking* here
> due to CPUB hold it
> spin_lock_bh(&lockB)
>                             __do_softirq()
>                               run_timer_softirq()
>                                 spin_lock_bh(&lockB)
>                                 *Blocking* heredue to
>                                 CPUC hold it
>                                                          call
> smp_call_function_many()
>                                                          send IPI
> interrupt to CPUA
> 
> wait_csd()
> 
> *Blocking* here.
> 
> So it is still deadlock. but your code does not warn it.
In your case, even you change spin_lock_bh() to spin_lock(), the deadlock is still there. So no relation with _bh() at all,
Do not need warning for such deadlock case in smp_call_xxx() or for _bh() case.

> so in_softirq() is better than in_serving_softirq() in in_serving_irq(),
> and results in_serving_irq() is the same as in_interrupt().
> 
> so please remove in_serving_irq() and use in_interrupt() instead.
The original patch is using in_interrupt(). https://lkml.org/lkml/2013/2/6/34 

> And add:
> 
> Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
