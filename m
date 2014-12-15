Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbaLOPwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:52:11 -0500
Received: from smtprelay0116.hostedemail.com ([216.40.44.116]:33339 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750944AbaLOPwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 10:52:07 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:966:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1543:1593:1594:1605:1711:1730:1747:1777:1792:2196:2199:2393:2553:2559:2562:2693:2736:2892:2901:2907:3138:3139:3140:3141:3142:3622:3743:3865:3866:3867:3868:3870:3871:3872:3874:4385:4605:5007:6119:6261:6742:7875:7903:9010:10004:10400:10450:10455:10848:10967:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12740:13138:13231:14096:14097:19904:19999:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: box63_694e68124e632
X-Filterd-Recvd-Size: 4751
Date: Mon, 15 Dec 2014 10:52:01 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        x86@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Marc Zyngier <marc.zyngier@arm.com>, Yinghai Lu <yinghai@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: Status of tip/x86/apic
Message-ID: <20141215105201.16110c6d@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.11.1412121539300.16494@nanos>
References: <alpine.DEB.2.11.1412121539300.16494@nanos>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Dec 2014 21:35:14 +0100 (CET)
Thomas Gleixner <tglx@linutronix.de> wrote:

>    2) Proper trace point support so we can actually track allocation
>       and the hardware access at the various domain levels because
>       some of these issues cannot be decoded by looking at a state
>       snapshot in debugfs. With some of them we even can't access
>       debugfs at all.
> 
>       Though one issue with that is, that for the early boot process
>       there is no way to store that information as the tracer gets
>       enabled way after init_IRQ(). But there is no reason why the
>       tracer could not be enabled before that. All it needs is a
>       working memory allocator. Steven?

And as we found out, we also need working RCU ;-) (but that still
happens before init_IRQ() which is what we want here).


> 
>       Now there is another class of problems which might be hard to
>       debug. When the machine just boots into a hang, so we dont get a
>       ftrace output neither from an oops nor from a console. It would
>       be nice if we could have a command line option which prints
>       enabled trace points via (early_)printk. That would avoid
>       sending out ad hoc printk debug patches which will basically
>       provide the same information as the trace_points. That would be
>       useful for other hard to debug boot hangs as well. Steven?

Agreed and patches have been sent to Linus.

>       
>       I think the above can be solved, so we need to agree on a proper
>       set of tracepoints. I came up with the following list:
> 
>       - trace_irqdomain_create(domain->id, domain->name, ...)

Is that suppose to be a variable number of args? Tracepoints do not
support a variable length number of args passed in. I guess we could
add that, but it wont be for this merge window.

I've added Mathieu and Frederic to the Cc list here.

If we do support this (and if it is needed) we could make it use the
bprintf() infrastructure. It already supports just saving a format and
args directly to the the buffer, and a way to print them again.

tools/lib/traceevent/event-parse.c will need to deal with this. But it
too also already handles trace_bprintk().


>       - trace_irqdomain_destroy(domain->id)
>       
>       - trace_irqdomain_alloc(irq_data)
> 
>       	struct irq_data contains all relevant information for
>       	assigning the tracepoint data.
> 	
> 		__entry->virq		= irq_data->virq;
> 		__entry->domainid	= irq_data->domain;
> 		__entry->hwirq		= irq_data->hwirq;
> 		TP_STORE_DATA(__entry->data, irq_data);
> 
> 	Where TP_STORE_DATA checks for the above callback and uses it
> 	if available, otherwise we just clear the data field.
>       
>         So this reuses the callback which we want for debugfs
>         anyway. The print format is just hexdump. See my above
>         rationale for that.

We could also create a plugin in tools/lib/traceevent that can give us
more than just a hexdump. That is, we have the code in the kernel
source tree but not in the kernel binary.

-- Steve

> 
>       - trace_irqdomain_free(virq, domain->id)
> 	  
>       - trace_irqdomain_hw_access(irqdata)
> 
> 	Same "data" and pretty printing argument as for
> 	trace_irqdomain_alloc()
> 
> 	The obvious place to put such a trace point is
> 	e.g. irq_chip_write_msi_msg() where the callback records the
> 	currently written msi msg.
> 
