Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455AbaDUNl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 09:41:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367AbaDUNlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 09:41:55 -0400
Date: Mon, 21 Apr 2014 15:41:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>, mingo@redhat.com, mingo@kernel.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4 v2] nmi: Provide the option to issue an NMI back trace
	to every cpu but current
Message-ID: <20140421134154.GA13766@redhat.com>
References: <20140415075650.GG2195@atomlin.usersys.redhat.com> <20140415170202.GA7948@redhat.com> <20140415172649.GA10152@redhat.com> <20140421132100.GW8488@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140421132100.GW8488@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21, Don Zickus wrote:
>
> On Tue, Apr 15, 2014 at 07:26:49PM +0200, Oleg Nesterov wrote:
> > On 04/15, Oleg Nesterov wrote:
> > >
> > > Looking at https://lkml.org/lkml/2014/4/4/469... It seems that 2/4 can be
> > > simplified, you can simply remove smp_processor_id() from backtrace_mask
> > > if !include_self and use apic->send_IPI_mask(backtrace_mask). But this is
> > > minor, I won't insist.
> >
> > And in fact, I do not understand why arch_trigger_all_cpu_backtrace() doesn't
> > disable preemption. OK, probably we can simply ignore the race with cpu hotplug.
> >
> > But it seems that your patch makes the things worse. Lets look at, say,
> > numachip_send_IPI_mask_allbutself(). The usage of smp_processor_id() is
> > obviously racy but perhaps we do not care again. But we do not want a warning
> > from debug_smp_processor_id().
>
> Good point.  I forgot that going from all cpus down to allbutself,
> preemption now matters.

I am not sure it actually matters wrt "show other CPU's traces". If the preemption
is possible then the caller can be preempted even before it sends ipi.

OTOH I think it does matter anyway, even without your patch, otherwise the usage
of cpu_online_mask is racy and we can hit the "Wait for up to 10 seconds" case.

Btw...

	/* Wait for up to 10 seconds for all CPUs to do the backtrace */
	for (i = 0; i < 10 * 1000; i++) {
		if (cpumask_empty(to_cpumask(backtrace_mask)))
			break;
		mdelay(1);
	}

OK, but perhaps we should clear backtrace_mask if we return due to timeout.

> does disabling preemption help in the cpu
> hotplug case?

Yes. But I'd suggest to change your patch to use get_cpu() instead of
preempt_disable/smp_processor_id.

And I think it would be better to not discuss this off-list, I added lkml.

Oleg.

