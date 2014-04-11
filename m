Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbaDKIg4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 04:36:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.130]:56234 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654AbaDKIgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 04:36:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
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
Subject: Re: [PATCH v7 4/6] pci: Introduce a domain number for pci_host_bridge.
Date: Fri, 11 Apr 2014 10:36:06 +0200
Message-ID: <5745677.MbvfSQPiZ9@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1397192469.19518.11.camel@pasglop>
References: <1394811272-1547-5-git-send-email-Liviu.Dudau@arm.com> <6459805.ygy4tBNDNz@wuerfel> <1397192469.19518.11.camel@pasglop>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:VQtpXqR32ctJOenRZo7VcFg1d8HDxLDAXADxfHw827R
 0vPnB14xmD+CHMZaIx4cy9egCU10TqvHpmyazzfJQv4UDihuWz
 bDCryLVtOgR3WfqWr+Q+AA79APyWsDjkqrgmDGU4Ork/b4VRde
 OTOGvkNKCB7a9BYqs0F6Ir/68NUZLg0QwM/zZlvr1y9Qfg2Am3
 Lmgf1FtbFAzKu7iofKCz8d5NL9n27eAK4Wb2fFuZgkj+FmjblC
 whho1gHSGonyRdczcvUEioVTq5g8NfsUmBgR0DC6k0dPorzD4A
 bvA4sEdFIQ9A9m2yW8lqNfh5uxmyIMZmBi3JKzJpzbQdXZKO6c
 0WTndJwFN2Y9nIq3N+Rg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 April 2014 15:01:09 Benjamin Herrenschmidt wrote:
> On Thu, 2014-04-10 at 22:46 +0200, Arnd Bergmann wrote:
> 
> > Half of it ;-)
> > 
> > I think it would be better to not have an architecture specific data
> > structure, just like it would be better not to have architecture specific
> > pcibios_* functions that get called by the PCI core. Note that the
> > architecture specific functions are the ones that rely on the architecture
> > specific data structures as well. If they only use the common fields,
> > it should also be possible to share the code.
> 
> I don't understand... we'll never get rid of architecture specific hooks
> in one form or another.
> 
> We'll always need to some things in an architecture or host-bridge
> specific way. Now if you don't want to call them arch hooks, then call
> them host bridge ops, but they are needed and thus they will need some
> kind of architecture specific extension to the base host bridge 
> structure.

Absolutely right. The thing I'd like to get rid of in the long run
is global functions defined in the architecture code that are called
by core code for host bridge specific functionality. In a lot of
cases, they should not be needed if we can express the same things
in a generic way. In other cases, we can use function pointers that
are set at the time that the host bridge is registered.

> EEH is one big nasty example on powerpc.
> 
> Another random one that happens to be hot in my brain right now because
> we just finished debugging it: On powernv, we are just fixing a series
> of bugs caused by the generic code trying to do hot resets on PCIe "by
> hand" by directly toggling the secondary reset register in bridges.
> 
> Well, on our root complexes, this triggers a link loss which triggers
> a fatal EEH "ER_all" interrupt which we escalate into a fence and all
> hell breaks loose.
> 
> We need to mask some error traps in the hardware before doing something
> that can cause an intentional link loss... and unmask them when done.
> (Among other things, there are other issues on P7 with hot reset).
> 
> So hot reset must be an architecture hook.

This sounds to me very much host bridge specific, not architecture specific.
If you have the same host bridge in an ARM system, you'd want the same
things to happen, and if you have another host bridge on PowerPC, you
probably don't want that code to be called.

> PERST (fundamental reset) can *only* be a hook. The way to generate a
> PERST is not specified. In fact, on our machines, we have special GPIOs
> we can use to generate PERST on individual slots below a PLX bridge
> and a different methods for slots directly on a PHB.
> 
> Eventually most of those hooks land into firmware, and as such it's akin
> to ACPI which also keeps a separate state structure and a pile of hooks.

On PowerPC, there are currently a bunch of platform specific callbacks
in the ppc_md: pcibios_after_init, pci_exclude_device,
pcibios_fixup_resources, pcibios_fixup_bus, pcibios_enable_device_hook,
pcibios_fixup_phb, pcibios_window_alignment, and possibly some more.
There is some architecture specific code that gets called by the
PCI core, with the main purpose of calling into these.

On ARM32, we have a similar set of callbacks in the architecture
private pci_sys_data: swizzle, map_irq, align_resource, add_bus,
remove_bus, and some more callbacks for setup in the hw_pci
structure that is used at initialization time: setup, scan,
preinit, postinit. Again, these are called from architecture
specific code that gets called by the PCI core.

I'm sure some of the other architectures have similar things, most
of them probably less verbose because there is fewer variability
between subarchitectures.

I think a nice way to deal with these in the long run would be
to have a generic 'struct pci_host_bridge_ops' that can be defined
by the architecture or the platform, or a particular host bridge
driver. We'd have to define exactly which function pointers would
go in there, but a good start would be the set of functions that
are today provided by each architecture. The reset method you describe
above would also fit well into this.

A host bridge driver can fill out the pointers with its own functions,
or put platform or architecture specific function pointers in there,
that get called by the PCI core. There are multiple ways to deal with
default implementations here, one way would be that the core just
falls back to a generic implementation (which is currently the __weak
function) if it sees a NULL pointer. Another way would be to require
each driver to either fill out all pointers or none of them, in which
case we would use a default pci_host_bridge_ops struct that contains
the pointers to the global pcibios_*() functions.

	Arnd
