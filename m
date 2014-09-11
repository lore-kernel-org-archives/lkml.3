Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbaIKRcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 13:32:09 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:38267 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbaIKRcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 13:32:04 -0400
Date: Thu, 11 Sep 2014 19:32:01 +0200
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, marc.zyngier@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, alex.williamson@redhat.com, joel.schopp@amd.com,
        kim.phillips@freescale.com, paulus@samba.org, gleb@kernel.org,
        pbonzini@redhat.com, linux-kernel@vger.kernel.org, patches@linaro.org,
        will.deacon@arm.com, a.motakis@virtualopensystems.com,
        a.rigo@virtualopensystems.com, john.liuli@huawei.com
Subject: Re: [RFC v2 8/9] KVM: KVM-VFIO: generic KVM_DEV_VFIO_DEVICE command
 and IRQ forwarding control
Message-ID: <20140911173201.GG5535@lvm>
References: <1409575968-5329-1-git-send-email-eric.auger@linaro.org>
 <1409575968-5329-9-git-send-email-eric.auger@linaro.org>
 <20140911031026.GI2784@lvm>
 <54116CFC.1050807@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54116CFC.1050807@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 11:35:56AM +0200, Eric Auger wrote:
> On 09/11/2014 05:10 AM, Christoffer Dall wrote:
> > On Mon, Sep 01, 2014 at 02:52:47PM +0200, Eric Auger wrote:

[...]

> >> +	if (!pfwd)
> >> +		return -ENOMEM;
> >> +	pfwd->index = fwd_irq->index;
> >> +	pfwd->gsi = fwd_irq->gsi;
> >> +	pfwd->hwirq = hwirq;
> >> +	pfwd->vcpu = kvm_get_vcpu(kdev->kvm, 0);
> >> +	ret = kvm_arch_set_fwd_state(pfwd, KVM_VFIO_IRQ_SET_FORWARD);
> >> +	if (ret < 0) {
> >> +		kvm_arch_set_fwd_state(pfwd, KVM_VFIO_IRQ_CLEANUP);
> > 
> > this whole thing feels incredibly broken to me.  Setting a forward
> > should either work or not work, not something in between that leaves
> > something to be cleaned up.  Why this two-stage thingy here?
> I wanted to exploit the return value of vgic_map_phys_irq which is
> likely to fail if the phys/virt mapping exists at VGIC level.

then just have the kvm_arch_set_fwd_state return with -EXIST and it is
the responsibility of that function itself to cleanup from whatever it
was doing, not to rely on its caller to call a cleanup function.

> 
> I already validated the injection from a KVM_VFIO_DEVICE point of view
> (the device/irq is not known internally). But what if another external
> component - which does not exist yet - maps the IRQ at VGIC level? Maybe
> I need to replace the existing validation check by querying the VGIC at
> low level instead of checking KVM-VFIO local variables.

No need to over-complicate this, in this case, the
kvm_arch_set_fwd_state() will simply fail (graceously), as I said above,
and you just return to the user, "sorry, couldn't do what you asked me
because of this error code".


[...]

> >> + *
> >> + * When this function is called, the vcpu already are destroyed. No
> >                                     the VPUCs are already destroyed.
> >> + * vgic manipulation can happen hence the KVM_VFIO_IRQ_CLEANUP
> >> + * kvm_arch_set_fwd_state action
> > 
> > this last bit didn't make any sense to me.  Also, why are we referring
> > to the vgic in generic code?
> doesn't make sense anymore indeed. I wanted to emphasize the fact that
> VGIC KVM device is destroyed before the KVM VFIO device and this
> explains why I need a special CLEANUP cmd (besides the fact I need to
> call chip->irq_eoi(d) for the forwarded IRQs);
> 

I don't think it explains why you need a special CLEANUP cmd.  When the
vgic is going away it must cleanup its state.  When the kvm vfio device
goes away, it must unforward any unforwarded IRQs, and the architecture
specific implementation MUST correctly unforward such IRQs - as a single
operation!

Hope this helps.
-Christoffer
