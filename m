Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967431AbaLLUf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 15:35:26 -0500
Received: from www.linutronix.de ([62.245.132.108]:37222 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965445AbaLLUfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 15:35:24 -0500
Date: Fri, 12 Dec 2014 21:35:14 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Jiang Liu <jiang.liu@linux.intel.com>, x86@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Yinghai Lu <yinghai@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Status of tip/x86/apic
Message-ID: <alpine.DEB.2.11.1412121539300.16494@nanos>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

after mulling this in my head for quite some time, I'm going to
postpone the whole thing for 3.20.

That said, I need to say, that I'm really happy with the outcome of
this massive overhaul. I really want to thank all involved people,
especially Jiang, for their great work and help so far!!!

The hierarchical irq domains really improve the code by distangling
the various subsystems and the arm[64] use cases just prove that it
was the right decision.

We're almost there with x86 but my gut feeling tells me that pushing
it now is too risky. I rather prefer quiet holidays for all of us than
the nagging fear that the post holiday inbox will be full of obscure
bug reports and we then start a chase and bandaid race which will kill
the well earned recreation in an instant.

This will block other things in that area for a while, but it's the
only sane decision at the moment, unless Linus insists on pulling the
lot and promises to deal with the fallout. :)

The reasons why I decided to do so are:

 - The bugs we found in the last week. That tells me that there is
   some more stuff lurking.

 - The already existing mess in a some areas which got unearthed by
   this work in the last week. That definitely needs a thorough
   cleanup and not some more bandaids.

 - Lack of proper debugging features. Sending out per issue debug
   patches simply does not scale.

 - It's not bisectable and unfortunately there are too many fixes to
   various places to make manual bisection feasible.

For 3.20 I want to proceed in the following way:

 - Apply all bug fixes to x86/apic

 - Address the issues with the resource management (and elsewhere)
   proper on top

 - Add a proper debugging mechanism (the existing irqdomain debugfs
   interface is completely useless).

   For the hierarchical domains we really want two things:

   1) A debugfs interface which lets us introspect the hierarchy.

      I was working on that before I got dragged into bug chasing and
      merge window frenzy.

      For proper introspection down to the hardware level this
      requires either domain/irq_chip specific callbacks or some
      unified way to track the current state. The latter is painful as
      it requires to store information redundantly.

      So having domain/chip callbacks to retrieve the state is the
      right solution. Most chip/domain implementations cache their
      [hardware] state already, so providing an accessor to convert
      that into a common data format is the best way. If the callback
      is not implemented then the information is not available or
      maybe not relevant.

      I'm not going to have a per domain/chip seqfile print function
      as this is just a complete waste. Pretty printing obscure
      hardware information does not help much for the general user. We
      rather have the raw data and proper post processing tools which
      can provide that pretty print information than bloating the
      kernel binary with randomized and possibly useless seq_print
      functions.

      Another reason why I want just raw binary data is that I want to
      use exactly the same mechanism for tracing. See below.

      After looking at the various new domain/chip implementations its
      sufficient to have 16 bytes of storage space for this, but
      that's a minor detail.

      To provide a proper translation into pretty printed values we
      can do the following:

       Create a new section for storing such data and have a data
       structure there which describes the content of the buffer. That
       section goes into a seperate file and not linked into the
       kernel binary. Simple enough for tools to pick up and for bug
       reporters to use/provide. If the stupid file is not available
       we still can recreate it from source and translate the hex
       dump. And in the most cases the pure hexdump will be sufficient
       for the people who need actually to look at this.

   2) Proper trace point support so we can actually track allocation
      and the hardware access at the various domain levels because
      some of these issues cannot be decoded by looking at a state
      snapshot in debugfs. With some of them we even can't access
      debugfs at all.

      Though one issue with that is, that for the early boot process
      there is no way to store that information as the tracer gets
      enabled way after init_IRQ(). But there is no reason why the
      tracer could not be enabled before that. All it needs is a
      working memory allocator. Steven?

      Now there is another class of problems which might be hard to
      debug. When the machine just boots into a hang, so we dont get a
      ftrace output neither from an oops nor from a console. It would
      be nice if we could have a command line option which prints
      enabled trace points via (early_)printk. That would avoid
      sending out ad hoc printk debug patches which will basically
      provide the same information as the trace_points. That would be
      useful for other hard to debug boot hangs as well. Steven?
      
      I think the above can be solved, so we need to agree on a proper
      set of tracepoints. I came up with the following list:

      - trace_irqdomain_create(domain->id, domain->name, ...)
      - trace_irqdomain_destroy(domain->id)
      
      - trace_irqdomain_alloc(irq_data)

      	struct irq_data contains all relevant information for
      	assigning the tracepoint data.
	
		__entry->virq		= irq_data->virq;
		__entry->domainid	= irq_data->domain;
		__entry->hwirq		= irq_data->hwirq;
		TP_STORE_DATA(__entry->data, irq_data);

	Where TP_STORE_DATA checks for the above callback and uses it
	if available, otherwise we just clear the data field.
      
        So this reuses the callback which we want for debugfs
        anyway. The print format is just hexdump. See my above
        rationale for that.

      - trace_irqdomain_free(virq, domain->id)
	  
      - trace_irqdomain_hw_access(irqdata)

	Same "data" and pretty printing argument as for
	trace_irqdomain_alloc()

	The obvious place to put such a trace point is
	e.g. irq_chip_write_msi_msg() where the callback records the
	currently written msi msg.

Once we have sorted that, I'll push x86/apic into a seperate git
repository so the history is preserved.

After that I'll redo x86/apic from scratch with proper ordering and
all fixes folded to the right places so the whole thing becomes
bisectable.

Thoughts?

Thanks,

	Thomas
