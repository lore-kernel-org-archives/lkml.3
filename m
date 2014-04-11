Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017AbaDKNv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 09:51:56 -0400
Received: from moutng.kundenserver.de ([212.227.17.13]:55174 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757913AbaDKNvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 09:51:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Liviu Dudau <Liviu.Dudau@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Will Deacon <Will.Deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v7 4/6] pci: Introduce a domain number for pci_host_bridge.
Date: Fri, 11 Apr 2014 15:51:15 +0200
Message-ID: <4601983.fD0IEt2fVM@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140411092225.GW985@e106497-lin.cambridge.arm.com>
References: <1394811272-1547-5-git-send-email-Liviu.Dudau@arm.com> <6459805.ygy4tBNDNz@wuerfel> <20140411092225.GW985@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:x1tlgpaxYfc/HRLcb3OwHb8AY5lpV92P4AxhREVS3eY
 wWBw+KfMF8vdn8+U6EpjXXXKbruTt7HUtkcHbjeMj0ZhU+rnuJ
 njMqOJnkZr0z0F17J4CTBMN8yiesj5PahzpZRATVxHjThQKw2x
 Aksb6gniwdSD5wRwFT00Wpb2ZYKuq+athBLRV8MMAM2HlbO4JA
 +VCHZeQF5c1tYsK7weIGbi7PA6XBntWXRF28scHinCj1AsbW5r
 QLhEo8eGU5Y1a6K4omijiaf9N+htBhBviDIH1oKKZbew9OhTI2
 iYtxkKawimAcSVJkqLi6l9q8vjaP4sw9YTiB1fzZGNK53d3ZMt
 RzvwWZJm5597XaPYwZNc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 April 2014 10:22:25 Liviu Dudau wrote:
> On Thu, Apr 10, 2014 at 09:46:36PM +0100, Arnd Bergmann wrote:
> > On Thursday 10 April 2014 15:53:04 Liviu Dudau wrote:
> > > So Arnd seems to agree with me: we should try to get out of architecture specific
> > > pci_sys_data and link the host bridge driver straight into the PCI core. The
> > > core then can call into arch code via pcibios_*() functions.
> > > 
> > > Arnd, am I reading correctly into what you are saying?
> > 
> > Half of it ;-)
> > 
> > I think it would be better to not have an architecture specific data
> > structure, just like it would be better not to have architecture specific
> > pcibios_* functions that get called by the PCI core. Note that the
> > architecture specific functions are the ones that rely on the architecture
> > specific data structures as well. If they only use the common fields,
> > it should also be possible to share the code.
> 
> While I've come to like the pcibios_*() interface (and yes, it could be
> formalised and abstracted into a pci_xxxx_ops structure) I don't like the fact
> that those functions use architectural data in order to function. I know it
> might sound strange, as they *are* supposed to be implemented by the arches,
> but in my mind the link between generic code and arch code for PCI should be
> done by the host bridge driver. That's how PCI spec describes it, and I see no
> reason why we should not be able to adopt the same view.

Yes, that's a good goal for the architectures that need the complexity.
I would also like to have a way to change as little as possible for
the architectures that don't care about this because they only have
one possible host controller implementation, which isn't necessarily
a conflict.

> To be more precise, what I would like to happen in the case of some functions
> would be for the PCI core code to call a pci_host_bridge_ops method which
> in turn will call the arch specific code if it needs to. Why I think that would
> be better? Because otherwise you put in the architectural side code to cope
> with a certain host bridge, then another host bridge comes in and you add
> more architectural code, but then when you port host bridge X to arch B you
> discover that you need to add code there as well for X. And it all ends up in
> the mess we currently have where the drivers in drivers/pci/host are not capable
> of being ported to a different architecture because they rely on infrastructure
> only present in arm32 that is not properly documented.

Right. Now it was intentional that we started putting the host drivers
into drivers/pci/host before cleaning it all up. We just had to start
somewhere.

> > I also don't realistically think we can get there on a lot of architectures
> > any time soon. Note that most architectures only have one PCI host
> > implementation, so the architecture structure is the same as the host
> > driver structure anyway.
> > 
> > For architectures like powerpc and arm that have people actively working
> > on them, we have a chance to clean up that code in the way we want it
> > (if we can agree on the direction), but it's still not trivial to do.
> > 
> > Speaking of arm32 in particular, I think we will end up with a split
> > approach: modern platforms (multiplatform, possibly all DT based) using
> > PCI core infrastructure directly and no architecture specific PCI
> > code on the one side, and a variation of today's code for the legacy
> > platforms on the other.
> 
> Actually, if we could come up with a compromise for the pci_fixup_*() functions
> (are they still used by functional hardware?)  then I think we could convert
> most of the arm32 arch code to re-direct the calls to the infrastructure code.

The fixups are used by hardware that we want to keep supporting, but I don't
see a problem there. None of them rely on the architecture specific PCI
implementation, and we could easily move the fixup code into a separate
file. Also, I suspect they are all used only on platforms that won't be
using CONFIG_ARCH_MULTIPLATFORM.

> But yes, there might be a lot of resistance to change due to lack of resources
> when changing old platforms.

Well, it should be trivial to just create a pci_host_bridge_ops structure
containing the currently global functions, and use that for everything
registered through pci_common_init_dev(). We definitely have to support
this method for things like iop/ixp/pxa/sa1100/footbridge, especially those
that have their own concept of PCI domains.

For the more modern multiplatform stuff that uses DT for probing and
has a driver in drivers/pci/host, we should be able to use completely
distinct pci_host_bridge_ops structure that can be shared with arm64.

	Arnd
