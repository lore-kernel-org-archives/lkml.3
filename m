Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589AbaFFMgO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 08:36:14 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:49628 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbaFFMgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 08:36:12 -0400
Date: Fri, 6 Jun 2014 14:36:06 +0200
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
Message-ID: <20140606123606.GC22341@lvm>
References: <1401694196-30861-1-git-send-email-eric.auger@linaro.org>
 <87bnub1kor.fsf@approximate.cambridge.arm.com>
 <538C8D5C.70207@linaro.org>
 <20140605103736.GB3994@lvm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140605103736.GB3994@lvm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 12:37:36PM +0200, Christoffer Dall wrote:
> On Mon, Jun 02, 2014 at 04:42:36PM +0200, Eric Auger wrote:
> > On 06/02/2014 03:54 PM, Marc Zyngier wrote:
> > > Hi Eric,
> > > 
> > > On Mon, Jun 02 2014 at  8:29:56 am BST, Eric Auger <eric.auger@linaro.org> wrote:
> 
> [...]
> 
> > >> @@ -408,11 +411,27 @@ static bool handle_mmio_clear_pending_reg(struct kvm_vcpu *vcpu,
> > >>                                           struct kvm_exit_mmio *mmio,
> > >>                                           phys_addr_t offset)
> > >>  {
> > >> -       u32 *reg = vgic_bitmap_get_reg(&vcpu->kvm->arch.vgic.irq_state,
> > >> +       struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
> > >> +       unsigned int i;
> > >> +       bool is_assigned_irq;
> > >> +       DECLARE_BITMAP(old, VGIC_NR_SHARED_IRQS);
> > >> +       DECLARE_BITMAP(diff, VGIC_NR_SHARED_IRQS);
> > >> +       unsigned long *pending =
> > >> +               vgic_bitmap_get_shared_map(&dist->irq_state);
> > >> +       u32 *reg;
> > >> +       bitmap_copy(old, pending, VGIC_NR_SHARED_IRQS);
> > > 
> > > That's really heavy. You could find out which interrupts are potentially
> > > affected (only 32 of them) and just handle those. Also, you do the copy
> > > on both the read and write paths. Not great.
> > for the copy you are fully right. I will add the check. Then to detect
> > which pending IRQ is cleared I need to further study how I can optimize.
> > Why do you say 32?  Can't any SPI be assigned to a guest?
> > > 
> > >> +       reg = vgic_bitmap_get_reg(&vcpu->kvm->arch.vgic.irq_state,
> > >>                                        vcpu->vcpu_id, offset);
> > >>         vgic_reg_access(mmio, reg, offset,
> > >>                         ACCESS_READ_VALUE | ACCESS_WRITE_CLEARBIT);
> > >>         if (mmio->is_write) {
> > >> +               pending = vgic_bitmap_get_shared_map(&dist->irq_state);
> > >> +               bitmap_xor(diff, old, pending, VGIC_NR_SHARED_IRQS);
> > >> +               for_each_set_bit(i, diff, VGIC_NR_SHARED_IRQS) {
> > >> +                       is_assigned_irq = kvm_irq_has_notifier(vcpu->kvm, 0, i);
> > >> +                       if (is_assigned_irq)
> > >> +                               kvm_notify_acked_irq(vcpu->kvm, 0, i);
> > > 
> > > Are you saying that a masked interrupt should be treated the same as an
> > > EOI-ed interrupt? That seems wrong from my PoV.
> > Actually all that stuff comes from a bug I encountered with
> > qemu_system_arm and the VFIO platform QEMU device (RFCv3 sent today).
> > The scenario is the following:
> > 1) I launch a 1st qemu_system_arm session with one xgmac bound to the
> > KVM guest with vfio. IRQs are routed through irqfd.
> > 2) I kill that session and launch a 2d one.
> > 
> > After the 1st session kill, xgmac ic still running (funny principle of
> > VFIO "meta" driver which is HW device agnostic and do not know how to
> > reset the xgmac). So very early I can see the xgmac sends a main IRQ
> > which is handled by the vfio platform driver. This later masks the IRQ
> > before signaling the eventfd. During guest setup I observe MMIO accesses
> > that clears the xgmac pending IRQ under the hood. So for that IRQ the
> > maintenance IRQ code will never be called, the notifier will not be be
> > acked and thus the IRQ is never unmasked at VFIO driver level. As a
> > result the xgmac driver gets stuck.
> > 
> > So currently this is the best fix I have found. VFIO Reset management
> > need to be further studied anyway. THis is planned but I understand it
> > will not straightforward.
> 
> It sounds to me like this is being done in the wrong place.  ICPENDRn
> and ISPENDRn are used for saving/restoring state, not for
> enabling/disabling IRQs.
> 
> Somehow, the VFIO driver must know that the xgmac has an active
> interrupt which is masked.  When you setup the IRQ routing for your new
> VM (when you start it the second time) there must be a mechanism to
> probe this state, but you don't inject that into the VM until the VM
> actually enables that IRQ (the guest kernel does request_irq()).  This
> should already be handled by the existing vgic code.
> 
> Note that what should also happen is that the guest driver should now
> reset the xgmac so that it doesn't inject IRQs, which should let VFIO
> know to lower the line to the vgic too, and then only later it becomes
> re-enabeld.  But that should be handled generically, iow. we shouldn't
> write code specifically to address only such a flow of events.
> 

Talked to Eric about this again, and I think the problem is that we're
not handling ICPENDRn and ISPENDRn properly.  It was a pain to deal with
this in the QEMU too, but basically we're not honering the semantics of
the registers, because the final pending state needs to be or'ed with
the external input signal.

I'll have a look at fixing this.

-Christoffer
