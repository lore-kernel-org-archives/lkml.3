Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbaH0I6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 04:58:34 -0400
Received: from www.linutronix.de ([62.245.132.108]:59704 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbaH0I63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 04:58:29 -0400
Date: Wed, 27 Aug 2014 10:57:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Borislav Petkov <bp@suse.de>
Subject: Re: [RFC Patch] irqdomain: Introduce new interfaces to support
 hierarchy irqdomains
In-Reply-To: <53FD8F64.20300@linux.intel.com>
Message-ID: <alpine.DEB.2.10.1408271009200.3323@nanos>
References: <1406880493-18859-1-git-send-email-jiang.liu@linux.intel.com> <alpine.DEB.2.10.1408261053450.3323@nanos> <53FD8F64.20300@linux.intel.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiang,

On Wed, 27 Aug 2014, Jiang Liu wrote:
> >> Third, a special value IRQDOMAIN_AUTO_ASSIGN_HWIRQ is defined out of
> >> irq_hw_number_t, which indicates that irqdomain callbacks should
> >> automatically hardware interrupt number for clients. This will be used
> >> to support CPU vector allocation and interrupt remapping controller
> >> on x86 platforms.
> > 
> > I can't see the point of this. If we have a hierarchy then this is a
> > property of the hierarchy itself not of an indiviual call.
> When invoking irqdomain interfaces, we need to pass in an hwirq. For
> IOAPIC, it's the pin number. But for remap and vector domains, caller
> can't provide hwirq, it's assigned by remap and vector domains
> themselves. So introduced IRQDOMAIN_AUTO_ASSIGN_HWIRQ to indicate
> that irqdomain will assign hwirq for callers.

I don't think it's an issue. You don't have to worry about the
existing irqdomain semantics and functionality. By introducing
hierarchy some of the existing rules are going to change no matter
what. So we should not try to make the interfaces which are required
for the hierarchical domains follow the semantics of the existing
plain interfaces.

If we decide to have the allocation scheme which I outlined, then this
becomes completely moot, simply because the allocation will take care
of this.

Lets look at the MSI example again. MSI does not have a hwirq number,
the MSI domain manages the MSI msg and that is composed from the
information which is created/managed by the remap and vector domains.
 
> >> Fourth, the flag IRQDOMAIN_FLAG_HIERARCHY is used to indicate weather
> >> irqdomain operations are hierarchy request. The irqdomain core uses
> > 
> > Why do we need that flag? If a domain has a parent domain, we already
> > know that this domain is part of a hierarchy.
> This flag is passed into hierarchy irqdomain interfaces for two
> purposes:
> 1) to protect irq_data->hwirq and irq_data->domain

Again, you try to bolt the hierarchy into the existing design rather
than doing a hierarchy design for irq domains and either map the
existing flat domain functionality into it or just leave it alone.

> > But your data representation is not hierarchical because only the
> > outmost domain map is stored in irq_data. For the parent domains you
> > offload the storage to the domain implementation itself.
> 
> One of my design rules is only to change x86 arch specific code when
> possible, so used above solution.

This design rule is wrong to begin with. You need to touch core code
anyway to support the hierarchy mechanisms. So you better have a
proper support for all of this in the core than having half baken
infrastructure plus ugly workarounds in the architecture code.

> If we could make changes to public data structures, we may find
> better solution as you have suggested:)

Of course we can do that and we should do it.

> > and avoid magic conditionals in the chip callbacks.
> That's a good suggestion. Should we reuse irq_data directly or
> group some fields from irq_data into a new data structure?

If we keep irq_data, then all nested chip callbacks and other things
just work. So creating a new sub structure is probably
counterproductive.

> > Now you might ask the question how #2 makes use of #1
> > (cfg->vector/cfg->domain) and #3 makes use of #2 (msi msg). That's
> > rather simple.
>
> Currently we solve this issue by packing all data into irq_cfg,
> we remap and ioapic level could access apic id and vector in
> vector domain.

Well, that's how it was hacked into the code in the first place, but
that's not something we want to keep. Clear separation of storage is
definitely a goal of doing the whole hierarchy change.
 
> I plan to build one irqdomain to support MSI/MSIx, but system may have
> multiple interrupt remapping units. It's a little tricky to maintain
> hierarchy relationship between MSI irqdomain and remapping irqdomain.
> It's hard to maintain N:N relationship for MSI and remapping irqdomains.
> So should we maintain 1:N or 1:1 relationships? In other words, should
> we build one irqdomain for each remapping unit or only build one
> irqdomain for all remapping units?

If you have several remapping domains, then you might consider to have
several corresponding MSI[X] domains as well. That's how the hardware
is structured.
 
> On the other hand, it's a good news that we almost have the same goals,
> and just have different ways to achieve our goals. I tried to change
> x86 arch code only, and you suggest to touch the irq public code.
> To be honest, I have no enough confidence to touch irq public code
> at the first step:(

Don't worry about touching generic code. It's not different from x86
code and having a proper core infrastructure makes the architecture
side clean and simple rather than stuffed with obscure workarounds.

I'm happy to guide you through if there are questions or design
decisions to make.
 
Thanks,

	tglx
