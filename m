Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbaFEKhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 06:37:43 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:62061 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaFEKhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 06:37:41 -0400
Date: Thu, 5 Jun 2014 12:37:36 +0200
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Eric Auger <eric.auger@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>,
        "eric.auger@st.com" <eric.auger@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "christophe.barnichon@st.com" <christophe.barnichon@st.com>,
        Antonios Motakis <a.motakis@virtualopensystems.com>
Subject: Re: [PATCH v2] ARM: KVM: add irqfd and irq routing support
Message-ID: <20140605103736.GB3994@lvm>
References: <1401694196-30861-1-git-send-email-eric.auger@linaro.org>
 <87bnub1kor.fsf@approximate.cambridge.arm.com>
 <538C8D5C.70207@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538C8D5C.70207@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 04:42:36PM +0200, Eric Auger wrote:
> On 06/02/2014 03:54 PM, Marc Zyngier wrote:
> > Hi Eric,
> > 
> > On Mon, Jun 02 2014 at  8:29:56 am BST, Eric Auger <eric.auger@linaro.org> wrote:

[...]

> >> @@ -408,11 +411,27 @@ static bool handle_mmio_clear_pending_reg(struct kvm_vcpu *vcpu,
> >>                                           struct kvm_exit_mmio *mmio,
> >>                                           phys_addr_t offset)
> >>  {
> >> -       u32 *reg = vgic_bitmap_get_reg(&vcpu->kvm->arch.vgic.irq_state,
> >> +       struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
> >> +       unsigned int i;
> >> +       bool is_assigned_irq;
> >> +       DECLARE_BITMAP(old, VGIC_NR_SHARED_IRQS);
> >> +       DECLARE_BITMAP(diff, VGIC_NR_SHARED_IRQS);
> >> +       unsigned long *pending =
> >> +               vgic_bitmap_get_shared_map(&dist->irq_state);
> >> +       u32 *reg;
> >> +       bitmap_copy(old, pending, VGIC_NR_SHARED_IRQS);
> > 
> > That's really heavy. You could find out which interrupts are potentially
> > affected (only 32 of them) and just handle those. Also, you do the copy
> > on both the read and write paths. Not great.
> for the copy you are fully right. I will add the check. Then to detect
> which pending IRQ is cleared I need to further study how I can optimize.
> Why do you say 32?  Can't any SPI be assigned to a guest?
> > 
> >> +       reg = vgic_bitmap_get_reg(&vcpu->kvm->arch.vgic.irq_state,
> >>                                        vcpu->vcpu_id, offset);
> >>         vgic_reg_access(mmio, reg, offset,
> >>                         ACCESS_READ_VALUE | ACCESS_WRITE_CLEARBIT);
> >>         if (mmio->is_write) {
> >> +               pending = vgic_bitmap_get_shared_map(&dist->irq_state);
> >> +               bitmap_xor(diff, old, pending, VGIC_NR_SHARED_IRQS);
> >> +               for_each_set_bit(i, diff, VGIC_NR_SHARED_IRQS) {
> >> +                       is_assigned_irq = kvm_irq_has_notifier(vcpu->kvm, 0, i);
> >> +                       if (is_assigned_irq)
> >> +                               kvm_notify_acked_irq(vcpu->kvm, 0, i);
> > 
> > Are you saying that a masked interrupt should be treated the same as an
> > EOI-ed interrupt? That seems wrong from my PoV.
> Actually all that stuff comes from a bug I encountered with
> qemu_system_arm and the VFIO platform QEMU device (RFCv3 sent today).
> The scenario is the following:
> 1) I launch a 1st qemu_system_arm session with one xgmac bound to the
> KVM guest with vfio. IRQs are routed through irqfd.
> 2) I kill that session and launch a 2d one.
> 
> After the 1st session kill, xgmac ic still running (funny principle of
> VFIO "meta" driver which is HW device agnostic and do not know how to
> reset the xgmac). So very early I can see the xgmac sends a main IRQ
> which is handled by the vfio platform driver. This later masks the IRQ
> before signaling the eventfd. During guest setup I observe MMIO accesses
> that clears the xgmac pending IRQ under the hood. So for that IRQ the
> maintenance IRQ code will never be called, the notifier will not be be
> acked and thus the IRQ is never unmasked at VFIO driver level. As a
> result the xgmac driver gets stuck.
> 
> So currently this is the best fix I have found. VFIO Reset management
> need to be further studied anyway. THis is planned but I understand it
> will not straightforward.

It sounds to me like this is being done in the wrong place.  ICPENDRn
and ISPENDRn are used for saving/restoring state, not for
enabling/disabling IRQs.

Somehow, the VFIO driver must know that the xgmac has an active
interrupt which is masked.  When you setup the IRQ routing for your new
VM (when you start it the second time) there must be a mechanism to
probe this state, but you don't inject that into the VM until the VM
actually enables that IRQ (the guest kernel does request_irq()).  This
should already be handled by the existing vgic code.

Note that what should also happen is that the guest driver should now
reset the xgmac so that it doesn't inject IRQs, which should let VFIO
know to lower the line to the vgic too, and then only later it becomes
re-enabeld.  But that should be handled generically, iow. we shouldn't
write code specifically to address only such a flow of events.

[...]

> > 
> > I clearly need to do some more reading about all of this, but some of
> > the questions/remarks I've outlined above need anwers.
> 
> hope I answered them.
> > 
> > Also, how does this combine with the work the VOS guys are doing?
> 
> This patch may address a subset of VOSYS original targets (ie. SPI
> routing through irqfd). Besides VFIO platform driver I understood
> Antonios original plan was to put the whole VGIC behind irqchip which
> was not my intent here. But I will let him update us wrt their plans and
> progress.
> 
I thought we had this conversation with the VOS guys and that there were
no direct overlap between this work and what they had done, but the
details are a bit fussy and I also remember seeing that irq routing
patch from Antonios.

Antonios, other VOSYS guys, what are your thought here?

-Christoffer
