Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaLNK5c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 05:57:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:46792 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbaLNK52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 05:57:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="498464395"
Message-ID: <548D6D13.8070706@linux.intel.com>
Date: Sun, 14 Dec 2014 18:57:23 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
CC: x86@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Yinghai Lu <yinghai@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: Status of tip/x86/apic
References: <alpine.DEB.2.11.1412121539300.16494@nanos>
In-Reply-To: <alpine.DEB.2.11.1412121539300.16494@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/13 4:35, Thomas Gleixner wrote:
> Folks,
> 
> after mulling this in my head for quite some time, I'm going to
> postpone the whole thing for 3.20.
> 
> That said, I need to say, that I'm really happy with the outcome of
> this massive overhaul. I really want to thank all involved people,
> especially Jiang, for their great work and help so far!!!
> 
> The hierarchical irq domains really improve the code by distangling
> the various subsystems and the arm[64] use cases just prove that it
> was the right decision.
> 
> We're almost there with x86 but my gut feeling tells me that pushing
> it now is too risky. I rather prefer quiet holidays for all of us than
> the nagging fear that the post holiday inbox will be full of obscure
> bug reports and we then start a chase and bandaid race which will kill
> the well earned recreation in an instant.
Hi Thomas,
	It's more safe to let it mature for another merge window
in tip tree:)

> 
> This will block other things in that area for a while, but it's the
> only sane decision at the moment, unless Linus insists on pulling the
> lot and promises to deal with the fallout. :)
> 
> The reasons why I decided to do so are:
> 
>  - The bugs we found in the last week. That tells me that there is
>    some more stuff lurking.
> 
>  - The already existing mess in a some areas which got unearthed by
>    this work in the last week. That definitely needs a thorough
>    cleanup and not some more bandaids.
> 
>  - Lack of proper debugging features. Sending out per issue debug
>    patches simply does not scale.
> 
>  - It's not bisectable and unfortunately there are too many fixes to
>    various places to make manual bisection feasible.
> 
> For 3.20 I want to proceed in the following way:
> 
>  - Apply all bug fixes to x86/apic
> 
>  - Address the issues with the resource management (and elsewhere)
>    proper on top
> 
>  - Add a proper debugging mechanism (the existing irqdomain debugfs
>    interface is completely useless).
> 
>    For the hierarchical domains we really want two things:
> 
>    1) A debugfs interface which lets us introspect the hierarchy.
> 
>       I was working on that before I got dragged into bug chasing and
>       merge window frenzy.
> 
>       For proper introspection down to the hardware level this
>       requires either domain/irq_chip specific callbacks or some
>       unified way to track the current state. The latter is painful as
>       it requires to store information redundantly.
> 
>       So having domain/chip callbacks to retrieve the state is the
>       right solution. Most chip/domain implementations cache their
>       [hardware] state already, so providing an accessor to convert
>       that into a common data format is the best way. If the callback
>       is not implemented then the information is not available or
>       maybe not relevant.
> 
>       I'm not going to have a per domain/chip seqfile print function
>       as this is just a complete waste. Pretty printing obscure
>       hardware information does not help much for the general user. We
>       rather have the raw data and proper post processing tools which
>       can provide that pretty print information than bloating the
>       kernel binary with randomized and possibly useless seq_print
>       functions.
> 
>       Another reason why I want just raw binary data is that I want to
>       use exactly the same mechanism for tracing. See below.
> 
>       After looking at the various new domain/chip implementations its
>       sufficient to have 16 bytes of storage space for this, but
>       that's a minor detail.
> 
>       To provide a proper translation into pretty printed values we
>       can do the following:
> 
>        Create a new section for storing such data and have a data
>        structure there which describes the content of the buffer. That
>        section goes into a seperate file and not linked into the
>        kernel binary. Simple enough for tools to pick up and for bug
>        reporters to use/provide. If the stupid file is not available
>        we still can recreate it from source and translate the hex
>        dump. And in the most cases the pure hexdump will be sufficient
>        for the people who need actually to look at this.
> 
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
> 
>       Now there is another class of problems which might be hard to
>       debug. When the machine just boots into a hang, so we dont get a
>       ftrace output neither from an oops nor from a console. It would
>       be nice if we could have a command line option which prints
>       enabled trace points via (early_)printk. That would avoid
>       sending out ad hoc printk debug patches which will basically
>       provide the same information as the trace_points. That would be
>       useful for other hard to debug boot hangs as well. Steven?
>       
>       I think the above can be solved, so we need to agree on a proper
>       set of tracepoints. I came up with the following list:
> 
>       - trace_irqdomain_create(domain->id, domain->name, ...)
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
> Once we have sorted that, I'll push x86/apic into a seperate git
> repository so the history is preserved.
> 
> After that I'll redo x86/apic from scratch with proper ordering and
> all fixes folded to the right places so the whole thing becomes
> bisectable.
> 
> Thoughts?
This really sounds a good idea to debug interrupt.

So I will work on following items for 3.20:
1) Continue to convert PCI MSI code into generic MSI code
as much as possible.
2) Simplify interrupt remapping initialization on x86, the first
version has been posted at: https://lkml.org/lkml/2014/12/10/20.
3) Solve new bugs if any:)
Thanks!
Gerry

> 
> Thanks,
> 
> 	Thomas
> 
