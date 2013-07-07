Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab3GGNrr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 09:47:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:50062 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759Ab3GGNro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 09:47:44 -0400
Date: Sun, 7 Jul 2013 15:47:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Wang YanQing <udknight@gmail.com>
cc: Chuansheng Liu <chuansheng.liu@intel.com>, mingo@kernel.org,
        peterz@infradead.org, jbeulich@suse.com, paulmck@linux.vnet.ibm.com,
        akpm@linux-foundation.org, mina86@mina86.org,
        srivatsa.bhat@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        jun.zhang@intel.com, fengguang.wu@intel.com
Subject: Re: [PATCH V2] smp: Give WARN()ing when calling smp_call_function_many()/single()
 in serving irq
In-Reply-To: <20130707035907.GA2875@udknight>
Message-ID: <alpine.DEB.2.02.1307071546540.32106@ionos.tec.linutronix.de>
References: <1360163901.24670.13.camel@cliu38-desktop-build> <1361023075.11130.12.camel@cliu38-desktop-build> <1361023812.11130.15.camel@cliu38-desktop-build> <alpine.DEB.2.02.1307051548430.32106@ionos.tec.linutronix.de> <alpine.DEB.2.02.1307051615100.32106@ionos.tec.linutronix.de>
 <20130707035907.GA2875@udknight>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Jul 2013, Wang YanQing wrote:
> On Fri, Jul 05, 2013 at 04:37:14PM +0200, Thomas Gleixner wrote:
> > Hmm, even there it matters, because of the following scenario:
> > 
> > CPU 0
> > smp_call_function_single(CPU 1)
> >     csd_lock(CPU 1)
> 
> No, smpl_call_function_single(CPU 1)
> will csd_lock(CPU 0), not csd_lock(CPU 1)
> 
> >     irq_enter()
> >     irq_exit()
> >     __do_softirq()
> >     smp_call_function_many()
> >       setup csd (CPU 1)
> >         csd_lock(CPU 1) ==> CPU 0 deadlocked itself.
> > 
> 
> maybe below is the scenario:
>      irq_enter()
>      irq_exit()
>      __do_softirq()
>      smp_call_function_single()
>        setup csd (CPU 1)
>          csd_lock(CPU 0) ==> CPU 0 deadlocked itself.

Right, I fatfingered that :)
