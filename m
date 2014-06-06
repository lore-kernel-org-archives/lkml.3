Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376AbaFFMQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 08:16:30 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:33509 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaFFMQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 08:16:28 -0400
Date: Fri, 6 Jun 2014 14:16:23 +0200
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Eric Auger <eric.auger@linaro.org>,
        "eric.auger@st.com" <eric.auger@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "christophe.barnichon@st.com" <christophe.barnichon@st.com>
Subject: Re: [PATCH v2] ARM: KVM: add irqfd and irq routing support
Message-ID: <20140606121623.GB22341@lvm>
References: <1401694196-30861-1-git-send-email-eric.auger@linaro.org>
 <87bnub1kor.fsf@approximate.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bnub1kor.fsf@approximate.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 02:54:12PM +0100, Marc Zyngier wrote:
> Hi Eric,
> 
> On Mon, Jun 02 2014 at  8:29:56 am BST, Eric Auger <eric.auger@linaro.org> wrote:
> > This patch enables irqfd and irq routing on ARM.
> >
> > It turns on CONFIG_HAVE_KVM_EVENTFD and CONFIG_HAVE_KVM_IRQ_ROUTING
> >
> > irqfd framework enables to assign physical IRQs to guests.
> >
> > 1) user-side uses KVM_IRQFD VM ioctl to pass KVM a kvm_irqfd struct that
> > associates a VM, an eventfd, an IRQ number (aka. the GSI). When an actor
> > signals the eventfd (typically a VFIO platform driver), the irqfd subsystem
> > injects the specified IRQ into the VM (the "GSI" takes the semantic of a
> > virtual IRQ for that guest).
> 
> Just so I can understand how this works: Who EOIs (handles) the physical
> interrupt? If it is the VFIO driver, then I don't see how you prevent
> the interrupt from firing again immediately (unless this is an edge
> interrupt?).
> 
> > 2) the other use case is user-side does 1) and uses KVM_SET_GSI_ROUTING
> > VM ioctl to create an association between a VM, a physical IRQ (aka GSI) and
> > a virtual IRQ (aka irchip.pin).  This creates a so-called GSI routing entry.
> > When someone triggers the eventfd, irqfd handles it but uses the specified
> > routing and eventually injects irqchip.pin virtual IRQ into the guest. In that
> > context the GSI takes the semantic of a physical IRQ while the irqchip.pin
> > takes the semantic of a virtual IRQ.
> >
> > in 1) routing is used by irqfd but an identity routing is created by default
> > making the gsi = irqchip.pin. Note on ARM there is a single interrupt
> > controller kind, the GIC.
> >
> > GSI routing mostly is implemented in generic irqchip.c.
> > The tiny ARM specific part is directly implemented in the virtual interrupt
> > controller (vgic.c) as it is done for powerpc for instance. This option was
> > prefered compared to implementing other #ifdef in irq_comm.c (x86 and ia64).
> > Hence irq_comm.c is not used at all.
> >
> > Routing currently is not used for anything else than irqfd IRQ injection. Only
> > SPI can be injected. This means the vgic is not totally hidden behind the
> > irqchip. There are separate discussions on PPI/SGI routing.
> >
> > Only level sensitive IRQs are supported (with a registered resampler). As a
> > reminder the resampler is a second eventfd called by irqfd framework when the
> > virtual IRQ is completed by the guest. This eventfd is supposed to be handled
> > on user-side
> >
> > MSI routing is not supported yet.
> >
> > This work was tested with Calxeda Midway xgmac main interrupt (with and without
> > explicit user routing) with qemu-system-arm and QEMU VFIO platform device.
> >
> > changes v1 -> v2:
> > 2 fixes:
> > - v1 assumed gsi/irqchip.pin was already incremented by VGIC_NR_PRIVATE_IRQS.
> >   This is now vgic_set_assigned_irq that increments it before injection.
> > - v2 now handles the case where a pending assigned irq is cleared through
> >   MMIO access. The irq is properly acked allowing the resamplefd handler
> >   to possibly unmask the physical IRQ.
> >
> > Signed-off-by: Eric Auger <eric.auger@linaro.org>
> >
> > Conflicts:
> >         Documentation/virtual/kvm/api.txt
> >         arch/arm/kvm/Kconfig
> >
> > Conflicts:
> >         Documentation/virtual/kvm/api.txt
> > ---
> >  Documentation/virtual/kvm/api.txt |   4 +-
> >  arch/arm/include/uapi/asm/kvm.h   |   8 +++
> >  arch/arm/kvm/Kconfig              |   2 +
> >  arch/arm/kvm/Makefile             |   1 +
> >  arch/arm/kvm/irq.h                |  25 +++++++
> >  virt/kvm/arm/vgic.c               | 141 ++++++++++++++++++++++++++++++++++++--
> >  6 files changed, 174 insertions(+), 7 deletions(-)
> >  create mode 100644 arch/arm/kvm/irq.h
> >
> > diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> > index b4f5365..b376334 100644
> > --- a/Documentation/virtual/kvm/api.txt
> > +++ b/Documentation/virtual/kvm/api.txt
> > @@ -1339,7 +1339,7 @@ KVM_ASSIGN_DEV_IRQ. Partial deassignment of host or guest IRQ is allowed.
> >  4.52 KVM_SET_GSI_ROUTING
> >
> >  Capability: KVM_CAP_IRQ_ROUTING
> > -Architectures: x86 ia64 s390
> > +Architectures: x86 ia64 s390 arm
> >  Type: vm ioctl
> >  Parameters: struct kvm_irq_routing (in)
> >  Returns: 0 on success, -1 on error
> > @@ -2126,7 +2126,7 @@ into the hash PTE second double word).
> >  4.75 KVM_IRQFD
> >
> >  Capability: KVM_CAP_IRQFD
> > -Architectures: x86 s390
> > +Architectures: x86 s390 arm
> >  Type: vm ioctl
> >  Parameters: struct kvm_irqfd (in)
> >  Returns: 0 on success, -1 on error
> > diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
> > index ef0c878..89b864d 100644
> > --- a/arch/arm/include/uapi/asm/kvm.h
> > +++ b/arch/arm/include/uapi/asm/kvm.h
> > @@ -192,6 +192,14 @@ struct kvm_arch_memory_slot {
> >  /* Highest supported SPI, from VGIC_NR_IRQS */
> >  #define KVM_ARM_IRQ_GIC_MAX            127
> >
> > +/* needed by IRQ routing */
> > +
> > +/* One single KVM irqchip, ie. the VGIC */
> > +#define KVM_NR_IRQCHIPS          1
> > +
> > +/* virtual interrupt controller input pins (max 480 SPI, 32 SGI/PPI) */
> > +#define KVM_IRQCHIP_NUM_PINS     256
> 
> Gahhhh... Please don't. We're trying hard to move away from hard-coded
> definitions such as this, since GICv3 has much higher limits. And the
> comment you've added perfectly outlines why this is such a bad idea
> (even on GICv2, we can have up to 960 SPIs).
> 
> Have a look at what's brewing in my kvm-arm64/vgic-dyn branch.
> 
Looked at this a bit more, and the generic code does require this
definition, but it can be arbitrarily high (it is not used to allocate
tables or anything like that).  Could we not just define it to the
highest possible number for now, and then deal with it if the number is
too large for gicv3?

(There may be some more issues related to this and the identity_table
setup code, but I'll let Eric investigate and comment on this).

-Christoffer
