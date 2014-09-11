Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbaIKWOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 18:14:42 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:61144 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbaIKWOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 18:14:40 -0400
Date: Thu, 11 Sep 2014 15:14:39 -0700
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, marc.zyngier@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, alex.williamson@redhat.com, joel.schopp@amd.com,
        kim.phillips@freescale.com, paulus@samba.org, gleb@kernel.org,
        pbonzini@redhat.com, linux-kernel@vger.kernel.org, patches@linaro.org,
        will.deacon@arm.com, a.motakis@virtualopensystems.com,
        a.rigo@virtualopensystems.com, john.liuli@huawei.com
Subject: Re: [RFC v2 1/9] KVM: ARM: VGIC: fix multiple injection of level
 sensitive forwarded IRQ
Message-ID: <20140911221439.GL5535@lvm>
References: <1409575968-5329-1-git-send-email-eric.auger@linaro.org>
 <1409575968-5329-2-git-send-email-eric.auger@linaro.org>
 <20140911030945.GC2784@lvm>
 <5411E74D.4080309@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5411E74D.4080309@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 08:17:49PM +0200, Eric Auger wrote:
> On 09/11/2014 05:09 AM, Christoffer Dall wrote:
> > On Mon, Sep 01, 2014 at 02:52:40PM +0200, Eric Auger wrote:
> >> Fix multiple injection of level sensitive forwarded IRQs.
> >> With current code, the second injection fails since the state bitmaps
> >> are not reset (process_maintenance is not called anymore).
> >> New implementation consists in fully bypassing the vgic state
> >> management for forwarded IRQ (checks are ignored in
> >> vgic_update_irq_pending). This obviously assumes the forwarded IRQ is
> >> injected from kernel side.
> >>
> >> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> >>
> >> ---
> >>
> >> It was attempted to reset the states in __kvm_vgic_sync_hwstate, checking
> >> the emptied LR of forwarded IRQ. However surprisingly this solution does
> >> not seem to work. Some times, a new forwarded IRQ injection is observed
> >> while the LR of the previous instance was not observed as empty.
> > 
> > hmmm, concerning.  It would probably have been helpful overall if you
> > could start by describing the problem with the current implementation in
> > the commit message, and then explain the fix...
> > 
> >>
> >> v1 -> v2:
> >> - fix vgic state bypass in vgic_queue_hwirq
> >> ---
> >>  virt/kvm/arm/vgic.c | 13 ++++++++++---
> >>  1 file changed, 10 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> >> index 0007300..8ef495b 100644
> >> --- a/virt/kvm/arm/vgic.c
> >> +++ b/virt/kvm/arm/vgic.c
> >> @@ -1259,7 +1259,9 @@ static bool vgic_queue_sgi(struct kvm_vcpu *vcpu, int irq)
> >>  
> >>  static bool vgic_queue_hwirq(struct kvm_vcpu *vcpu, int irq)
> >>  {
> >> -	if (vgic_irq_is_queued(vcpu, irq))
> >> +	bool is_forwarded =  (vgic_get_phys_irq(vcpu, irq) > 0);
> > 
> > can you create a static function to factor this vgic_get_phys_irq check out, please?
> yes sure
> > 
> >> +
> >> +	if (vgic_irq_is_queued(vcpu, irq) && !is_forwarded)
> >>  		return true; /* level interrupt, already queued */
> > 
> > so essentially if an IRQ is already on a LR so we shouldn't resample the
> > line, then we still resample the line if the IRQ is forwarded?
> > 
> > I think you need to explain this, both to me here, and also in the code
> > by moving the comment following the return statement above the check and
> > comment this clearly.
> Well, I admit it may look a bit pushy! When we discussed this issue with
> Marc, the outcome was that the vgic states were not accurate with
> forwarded IRQs and VGIC state may be fully bypassed.

Can you explain this in more details?  Perhaps with a concrete example?

> Since the first
> injection still sets the state - and I did not want to modify this - the
> 2d one would fail due to that check, and the validate_injection. May be
> cleaner to not update the states when injecting the fwd irq too.

Hmmm, I don't think I understand you here.  I think you need to think
about the whole flow of things here and understand any posible sequence
of events combined with any potential state you may have.  Perhaps this
is better deferred to a face-to-face discussion.

> 
> > 
> >>  
> >>  	if (vgic_queue_irq(vcpu, 0, irq)) {
> >> @@ -1517,14 +1519,18 @@ static bool vgic_update_irq_pending(struct kvm *kvm, int cpuid,
> >>  	int edge_triggered, level_triggered;
> >>  	int enabled;
> >>  	bool ret = true;
> >> +	bool is_forwarded;
> >>  
> >>  	spin_lock(&dist->lock);
> >>  
> >>  	vcpu = kvm_get_vcpu(kvm, cpuid);
> >> +	is_forwarded = (vgic_get_phys_irq(vcpu, irq_num) > 0);
> > 
> > use your new function here as well.
> ok
> > 
> >> +
> >>  	edge_triggered = vgic_irq_is_edge(vcpu, irq_num);
> >>  	level_triggered = !edge_triggered;
> >>  
> >> -	if (!vgic_validate_injection(vcpu, irq_num, level)) {
> >> +	if (!is_forwarded &&
> >> +		!vgic_validate_injection(vcpu, irq_num, level)) {
> > 
> > I don't see the rationale here either.  If an IRQ is forwarded, why do
> > you need to do anything if the condition of the line hasn't changed for
> > a level-triggered IRQ or if you have a falling edge on an edge-triggered
> > IRQ (assuming active-HIGH)?
> To me this even cannot cannot happen. a second fwd irq can only hit if
> the same virtual IRQ was completed and completed the corresponding phys
> IRQ. Still the problem is that on the 1st injection we updated the VGIC
> state. 

Updated teh VGIC state?  Be more specific!

> I aknowledge this is a hack to work around the 1st injection
> update the state and nothing reset them. So on subsequent injections, -
> and even on the 1st one-  I never check the state.

Is the case here that you propogate the line state onto the vcpu pending
state when somebody calls this inject function, so you use this as a
chance to resample the line?

If so, we need to document this clearly (and you need to convince me
that this is in fact the right thing we're doing overall), and we may
have to reword and refactor some of this to not have these weird-looking
corner cases with outrageously complicated comments describing state in
what's basically becoming a non-trivial state machine.

> > 
> >>  		ret = false;
> >>  		goto out;
> >>  	}
> >> @@ -1557,7 +1563,8 @@ static bool vgic_update_irq_pending(struct kvm *kvm, int cpuid,
> >>  		goto out;
> >>  	}
> >>  
> >> -	if (level_triggered && vgic_irq_is_queued(vcpu, irq_num)) {
> >> +	if (!is_forwarded &&
> >> +		level_triggered && vgic_irq_is_queued(vcpu, irq_num)) {
> > 
> > So here it's making sense for SPIs since you can have an EOIed interrupt
> > on a CPU that didn't exit the VM yet, and this it's still queued, but
> > you still need to resample the line to respect other CPUs.  Only, we
> > ever only target a single CPU for SPIs IIRC (the first in the target
> > list register) so we have to wait for that CPU to to exit the VM anyhow.
> > 
> > This leads me to believe that, given a fowarded irq, you can only have
> > XXX situations at this point:
> > 
> > (1) is_queued && target_vcpu_in_vm:
> > The vcpu should resample this line when it exits the VM, because we
> > check the LRs for IRQs like this one, so we don't have to do anything
> > and go to out here.
> > 
> > (2) is_queued && !target_vcpu_in_vm::
> > You have a bug because you exited the VM which must have done an EOI on
> > the interrupt, otherwise this function shouldn't have been called!  This
> > means that we should have cleared the queued state of the interrupt.
> > 
> > (3) !is_queued && whatever:
> > Set the irq pending bits, so do not goto out.
> > 
> > I'm aware that there's theoretically a race between (1) and (2), but you
> > should consider target_cpu_in_vm as "it hasn't been through
> > __kvm_vgic_sync_hwstate() yet" and this should hold.
> I will prepare something accurate for next week.
> 
Yeah, I think we need to talk this through at LCU14.

-Christoffer
