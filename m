Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538AbaIDNds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 09:33:48 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:48199 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbaIDNdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 09:33:45 -0400
Date: Thu, 4 Sep 2014 15:33:40 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Catalin Iacob <iacobcatalin@gmail.com>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 3/9] irq_work: Force raised irq work to run on irq
 work interrupt
Message-ID: <20140904133337.GA1771@lerouge>
References: <1408632777-3348-1-git-send-email-fweisbec@gmail.com>
 <1408632777-3348-4-git-send-email-fweisbec@gmail.com>
 <20140904061137.GB3190@worktop.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140904061137.GB3190@worktop.ger.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 08:11:37AM +0200, Peter Zijlstra wrote:
> On Thu, Aug 21, 2014 at 04:52:51PM +0200, Frederic Weisbecker wrote:
> > diff --git a/kernel/irq_work.c b/kernel/irq_work.c
> > index e6bcbe7..17bd203 100644
> > --- a/kernel/irq_work.c
> > +++ b/kernel/irq_work.c
> > @@ -22,6 +22,7 @@
> >  
> >  static DEFINE_PER_CPU(struct llist_head, raised_list);
> >  static DEFINE_PER_CPU(struct llist_head, lazy_list);
> > +static bool has_own_interrupt;
> >  
> >  /*
> >   * Claim the entry so that no one else will poke at it.
> 
> > +void irq_work_tick(void)
> > +{
> > +	if (!has_own_interrupt)
> > +		irq_work_run_list(&__get_cpu_var(raised_list));
> > +	irq_work_run_list(&__get_cpu_var(lazy_list));
> > +}
> > +
> >  /*
> >   * Synchronize against the irq_work @entry, ensures the entry is not
> >   * currently in use.
> 
> Why not something like the below; then it becomes a compile time matter.

Problem is that some archs only have that information at runtime.
See x86 for example which tests cpu_has_apic.
