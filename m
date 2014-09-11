Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbaIKRYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 13:24:25 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:63168 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaIKRYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 13:24:24 -0400
Date: Thu, 11 Sep 2014 19:24:21 +0200
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Eric Auger <eric.auger@linaro.org>, eric.auger@st.com,
        marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, joel.schopp@amd.com,
        kim.phillips@freescale.com, paulus@samba.org, gleb@kernel.org,
        pbonzini@redhat.com, linux-kernel@vger.kernel.org, patches@linaro.org,
        will.deacon@arm.com, a.motakis@virtualopensystems.com,
        a.rigo@virtualopensystems.com, john.liuli@huawei.com
Subject: Re: [RFC v2 8/9] KVM: KVM-VFIO: generic KVM_DEV_VFIO_DEVICE command
 and IRQ forwarding control
Message-ID: <20140911172421.GF5535@lvm>
References: <1409575968-5329-1-git-send-email-eric.auger@linaro.org>
 <1409575968-5329-9-git-send-email-eric.auger@linaro.org>
 <20140911031026.GI2784@lvm>
 <1410411949.2982.284.camel@ul30vt.home>
 <54118FD7.5000005@linaro.org>
 <1410451164.2982.312.camel@ul30vt.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410451164.2982.312.camel@ul30vt.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 09:59:24AM -0600, Alex Williamson wrote:
> On Thu, 2014-09-11 at 14:04 +0200, Eric Auger wrote:
> > On 09/11/2014 07:05 AM, Alex Williamson wrote:
> > > On Thu, 2014-09-11 at 05:10 +0200, Christoffer Dall wrote:
> > >> On Mon, Sep 01, 2014 at 02:52:47PM +0200, Eric Auger wrote:
> > >>> This patch introduces a new KVM_DEV_VFIO_DEVICE attribute.
> > >>>
> > >>> This is a new control channel which enables KVM to cooperate with
> > >>> viable VFIO devices.
> > >>>
> > >>> The kvm-vfio device now holds a list of devices (kvm_vfio_device)
> > >>> in addition to a list of groups (kvm_vfio_group). The new
> > >>> infrastructure enables to check the validity of the VFIO device
> > >>> file descriptor, get and hold a reference to it.
> > >>>
> > >>> The first concrete implemented command is IRQ forward control:
> > >>> KVM_DEV_VFIO_DEVICE_FORWARD_IRQ, KVM_DEV_VFIO_DEVICE_UNFORWARD_IRQ.
> > >>>
> > >>> It consists in programing the VFIO driver and KVM in a consistent manner
> > >>> so that an optimized IRQ injection/completion is set up. Each
> > >>> kvm_vfio_device holds a list of forwarded IRQ. When putting a
> > >>> kvm_vfio_device, the implementation makes sure the forwarded IRQs
> > >>> are set again in the normal handling state (non forwarded).
> > >>
> > >> 'putting a kvm_vfio_device' sounds to like you're golf'ing :)
> > >>
> > >> When a kvm_vfio_device is released?
> > >>
> > >>>
> > >>> The forwarding programmming is architecture specific, embodied by the
> > >>> kvm_arch_set_fwd_state function. Its implementation is given in a
> > >>> separate patch file.
> > >>
> > >> I would drop the last sentence and instead indicate that this is handled
> > >> properly when the architecture does not support such a feature.
> > >>
> > >>>
> > >>> The forwarding control modality is enabled by the
> > >>> __KVM_HAVE_ARCH_KVM_VFIO_FORWARD define.
> > >>>
> > >>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> > >>>
> > >>> ---
> > >>>
> > >>> v1 -> v2:
> > >>> - __KVM_HAVE_ARCH_KVM_VFIO renamed into __KVM_HAVE_ARCH_KVM_VFIO_FORWARD
> > >>> - original patch file separated into 2 parts: generic part moved in vfio.c
> > >>>   and ARM specific part(kvm_arch_set_fwd_state)
> > >>> ---
> > >>>  include/linux/kvm_host.h |  27 +++
> > >>>  virt/kvm/vfio.c          | 452 ++++++++++++++++++++++++++++++++++++++++++++++-
> > >>>  2 files changed, 477 insertions(+), 2 deletions(-)
> > >>>
> > >>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > >>> index a4c33b3..24350dc 100644
> > >>> --- a/include/linux/kvm_host.h
> > >>> +++ b/include/linux/kvm_host.h
> > >>> @@ -1065,6 +1065,21 @@ struct kvm_device_ops {
> > >>>  		      unsigned long arg);
> > >>>  };
> > >>>  
> > >>> +enum kvm_fwd_irq_action {
> > >>> +	KVM_VFIO_IRQ_SET_FORWARD,
> > >>> +	KVM_VFIO_IRQ_SET_NORMAL,
> > >>> +	KVM_VFIO_IRQ_CLEANUP,
> > >>
> > >> This is KVM internal API, so it would probably be good to document this.
> > >> Especially the CLEANUP bit worries me, see below.
> > > 
> > > This also doesn't match the user API, which is simply FORWARD/UNFORWARD.
> > Hi Alex,
> > 
> > will change that.
> > > Extra states worry me too.
> > 
> > I tried to explained the 2 motivations behind. Please let me know if it
> > makes sense.
> 
> Not really.  It seems like it's just a leak of arch specific handling
> out into common code.
> 
> > >>> +};
> > >>> +
> > >>> +/* internal structure describing a forwarded IRQ */
> > >>> +struct kvm_fwd_irq {
> > >>> +	struct list_head link;
> > >>
> > >> this list entry is local to the kvm vfio device, right? that means you
> > >> probably want a struct with just the below fields, and then have a
> > >> containing struct in the generic device file, private to it's logic.
> > > 
> > > Yes, this is part of the abstraction problem.
> > OK will fix that.
> > > 
> > >>> +	__u32 index; /* platform device irq index */
> > > 
> > > This is a vfio_device irq_index, but vfio_devices support indexes and
> > > sub-indexes.  At this level the API should match vfio, not the specifics
> > > of platform devices not supporting sub-index.
> > I will add sub-indexes then.
> > > 
> > >>> +	__u32 hwirq; /*physical IRQ */
> > >>> +	__u32 gsi; /* virtual IRQ */
> > >>> +	struct kvm_vcpu *vcpu; /* vcpu to inject into*/
> > > 
> > > Not sure I understand why vcpu is necessary.
> > vcpu is used when providing the physical IRQ/virtual IRQ mapping to the
> > virtual GIC. I can remove it from and add a vcpu struct * param to
> > kvm_arch_set_fwd_state if you prefer.
> 
> The kvm-vfio API for this interface doesn't allow the user to indicate
> which vcpu to inject to.  On x86, it would be the programming of the
> interrupt controller that would decide that.  In the code here we
> arbitrarily pick vcpu0.  It feels both architecture specific and a bit
> unspecified.
> 
> > 
> >   Also I see a 'get' in the code below, but not a 'put'.
> > Sorry I do not understand your comment here? What 'get' do you mention?
> 
> I suppose vcpus don't subscribe to the get/put philosophy, I was
> expecting a reference count, but there is none.  How do we know that
> vcpu pointer is still valid later?
> 

Because it will stay valid for as long as you can have a handle to this
instance of the kvm vfio device?

The only way for it to go away is when the VM is completely dying, but
the KVM device API should keep it a alive with a reference, right?

-Christoffer
