Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab3GFGEx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 02:04:53 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:40758 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab3GFGEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 02:04:51 -0400
Date: Sat, 6 Jul 2013 14:03:17 +0800
From: Wang YanQing <udknight@gmail.com>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: xiaoguangrong@cn.fujitsu.com, mingo@elte.hu, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, npiggin@suse.de,
        deepthi@linux.vnet.ibm.com, peterz@infradead.org,
        rusty@rustcorp.com.au, heiko.carstens@de.ibm.com, rostedt@goodmis.org,
        miltonm@bga.com, srivatsa.bhat@linux.vnet.ibm.com,
        jens.axboe@oracle.com, tj@kernel.org, akpm@linux-foundation.org,
        svaidy@linux.vnet.ibm.com, shli@kernel.org, tglx@linutronix.de,
        lig.fnst@cn.fujitsu.com, anton@samba.org,
        torvalds@linux-foundation.org, jbeulich@suse.com
Subject: Re: [PATCH 1/3] smp/ipi: Remove redundant cfd->cpumask_ipi mask
Message-ID: <20130706060317.GA3382@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Preeti U Murthy <preeti@linux.vnet.ibm.com>,
	xiaoguangrong@cn.fujitsu.com, mingo@elte.hu,
	paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
	a.p.zijlstra@chello.nl, npiggin@suse.de, deepthi@linux.vnet.ibm.com,
	peterz@infradead.org, rusty@rustcorp.com.au,
	heiko.carstens@de.ibm.com, rostedt@goodmis.org, miltonm@bga.com,
	srivatsa.bhat@linux.vnet.ibm.com, jens.axboe@oracle.com,
	tj@kernel.org, akpm@linux-foundation.org, svaidy@linux.vnet.ibm.com,
	shli@kernel.org, tglx@linutronix.de, lig.fnst@cn.fujitsu.com,
	anton@samba.org, torvalds@linux-foundation.org, jbeulich@suse.com
References: <20130705162548.16888.18957.stgit@preeti.in.ibm.com>
 <20130705162701.16888.81171.stgit@preeti.in.ibm.com>
 <20130706031310.GA1941@udknight>
 <51D7AB43.7010208@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D7AB43.7010208@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 06, 2013 at 10:59:39AM +0530, Preeti U Murthy wrote:
> Hi Wang,
> 
> On 07/06/2013 08:43 AM, Wang YanQing wrote:
> > On Fri, Jul 05, 2013 at 09:57:01PM +0530, Preeti U Murthy wrote:
> >> cfd->cpumask_ipi is used only in smp_call_function_many().The existing
> >> comment around it says that this additional mask is used because
> >> cfd->cpumask can get overwritten.
> >>
> >> There is no reason why the cfd->cpumask can be overwritten, since this
> >> is a per_cpu mask; nobody can change it but us and we are
> >> called with preemption disabled.
> > 
> > The ChangeLog for f44310b98ddb7f0d06550d73ed67df5865e3eda5
> > which import cfd->cpumask_ipi saied the reason why we need
> > it:
> > 
> > "    As explained by Linus as well:
> >     
> >      |
> >      | Once we've done the "list_add_rcu()" to add it to the
> >      | queue, we can have (another) IPI to the target CPU that can
> >      | now see it and clear the mask.
> >      |
> >      | So by the time we get to actually send the IPI, the mask might
> >      | have been cleared by another IPI.
> 
> I am unable to understand where the cfd->cpumask of the source cpu is
> getting cleared. Surely not by itself, since it is preempt disabled.
> Also why should it get cleared?

Assume we have three CPUs: A,B,C

A call smp_call_function_many to notify C do something,
and current it execute on finished below codes:

"for_each_cpu(cpu, cfd->cpumask) {
                struct call_single_data *csd = per_cpu_ptr(cfd->csd, cpu);
                struct call_single_queue *dst =
                                        &per_cpu(call_single_queue, cpu);
                unsigned long flags;

                csd_lock(csd);
                csd->func = func;
                csd->info = info;

                raw_spin_lock_irqsave(&dst->lock, flags);
                list_add_tail(&csd->list, &dst->list);
                raw_spin_unlock_irqrestore(&dst->lock, flags);
        }
"
You see "list_add_tail(&csd->list, &dst->list);", it pass the address of csd,
and A stop before call arch_send_call_function_ipi_mask due interrupt.

At this time B send ipi to C also, then C will see the csd passed by A,
then C will clear itself in the cfd->cpumask.

Thanks.

