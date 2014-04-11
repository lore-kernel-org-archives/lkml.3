Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306AbaDKJST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 05:18:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:57026 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756093AbaDKJSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 05:18:12 -0400
Message-ID: <1397207819.19518.26.camel@pasglop>
Subject: Re: [PATCH v7 4/6] pci: Introduce a domain number for
 pci_host_bridge.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 11 Apr 2014 19:16:59 +1000
In-Reply-To: <5745677.MbvfSQPiZ9@wuerfel>
References: <1394811272-1547-5-git-send-email-Liviu.Dudau@arm.com>
	 <6459805.ygy4tBNDNz@wuerfel> <1397192469.19518.11.camel@pasglop>
	 <5745677.MbvfSQPiZ9@wuerfel>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-11 at 10:36 +0200, Arnd Bergmann wrote:

> > EEH is one big nasty example on powerpc.
> > 
> > Another random one that happens to be hot in my brain right now because
> > we just finished debugging it: On powernv, we are just fixing a series
> > of bugs caused by the generic code trying to do hot resets on PCIe "by
> > hand" by directly toggling the secondary reset register in bridges.
> > 
> > Well, on our root complexes, this triggers a link loss which triggers
> > a fatal EEH "ER_all" interrupt which we escalate into a fence and all
> > hell breaks loose.
> > 
> > We need to mask some error traps in the hardware before doing something
> > that can cause an intentional link loss... and unmask them when done.
> > (Among other things, there are other issues on P7 with hot reset).
> > 
> > So hot reset must be an architecture hook.
> 
> This sounds to me very much host bridge specific, not architecture specific.
> If you have the same host bridge in an ARM system, you'd want the same
> things to happen, and if you have another host bridge on PowerPC, you
> probably don't want that code to be called.

Yes, it is partially host bridge specific, partially firmware related
(OPAL vs. ACPI, vs....) so it's a mixture here.

So I do agree, host bridge ops to replace most of these pcibios_* hooks
does make sense.
> 
> > PERST (fundamental reset) can *only* be a hook. The way to generate a
> > PERST is not specified. In fact, on our machines, we have special GPIOs
> > we can use to generate PERST on individual slots below a PLX bridge
> > and a different methods for slots directly on a PHB.
> > 
> > Eventually most of those hooks land into firmware, and as such it's akin
> > to ACPI which also keeps a separate state structure and a pile of hooks.
> 
> On PowerPC, there are currently a bunch of platform specific callbacks
> in the ppc_md: pcibios_after_init, pci_exclude_device,
> pcibios_fixup_resources, pcibios_fixup_bus, pcibios_enable_device_hook,
> pcibios_fixup_phb, pcibios_window_alignment, and possibly some more.
> There is some architecture specific code that gets called by the
> PCI core, with the main purpose of calling into these.

Yes. Most of them could be made into host bridge hooks fairly easily.

The remaining ones are going to need somebody (probably me) to
untangle :-)

> On ARM32, we have a similar set of callbacks in the architecture
> private pci_sys_data: swizzle, map_irq, align_resource, add_bus,
> remove_bus, and some more callbacks for setup in the hw_pci
> structure that is used at initialization time: setup, scan,
> preinit, postinit. Again, these are called from architecture
> specific code that gets called by the PCI core.
> 
> I'm sure some of the other architectures have similar things, most
> of them probably less verbose because there is fewer variability
> between subarchitectures.
> 
> I think a nice way to deal with these in the long run would be
> to have a generic 'struct pci_host_bridge_ops' that can be defined
> by the architecture or the platform, or a particular host bridge
> driver.

Well, the host bridge needs either a "driver" or be subclassed or
both...

>  We'd have to define exactly which function pointers would
> go in there, but a good start would be the set of functions that
> are today provided by each architecture. The reset method you describe
> above would also fit well into this.
> 
> A host bridge driver can fill out the pointers with its own functions,
> or put platform or architecture specific function pointers in there,
> that get called by the PCI core. There are multiple ways to deal with
> default implementations here, one way would be that the core just
> falls back to a generic implementation (which is currently the __weak
> function) if it sees a NULL pointer. Another way would be to require
> each driver to either fill out all pointers or none of them, in which
> case we would use a default pci_host_bridge_ops struct that contains
> the pointers to the global pcibios_*() functions.

Either works, we can start with the easy ones like window alignment, and
move from there.

Ben.


