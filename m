Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbaIKRWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 13:22:20 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:54783 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaIKRWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 13:22:18 -0400
Date: Thu, 11 Sep 2014 19:22:10 +0200
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Eric Auger <eric.auger@linaro.org>
Cc: Alex Williamson <alex.williamson@redhat.com>, eric.auger@st.com,
        marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, joel.schopp@amd.com,
        kim.phillips@freescale.com, paulus@samba.org, gleb@kernel.org,
        pbonzini@redhat.com, linux-kernel@vger.kernel.org, patches@linaro.org,
        will.deacon@arm.com, a.motakis@virtualopensystems.com,
        a.rigo@virtualopensystems.com, john.liuli@huawei.com
Subject: Re: [RFC v2 8/9] KVM: KVM-VFIO: generic KVM_DEV_VFIO_DEVICE command
 and IRQ forwarding control
Message-ID: <20140911172210.GE5535@lvm>
References: <1409575968-5329-1-git-send-email-eric.auger@linaro.org>
 <1409575968-5329-9-git-send-email-eric.auger@linaro.org>
 <20140911031026.GI2784@lvm>
 <1410411949.2982.284.camel@ul30vt.home>
 <54118FD7.5000005@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54118FD7.5000005@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 02:04:39PM +0200, Eric Auger wrote:
> On 09/11/2014 07:05 AM, Alex Williamson wrote:
> > On Thu, 2014-09-11 at 05:10 +0200, Christoffer Dall wrote:
> >> On Mon, Sep 01, 2014 at 02:52:47PM +0200, Eric Auger wrote:
> >>> This patch introduces a new KVM_DEV_VFIO_DEVICE attribute.
> >>>
> >>> This is a new control channel which enables KVM to cooperate with
> >>> viable VFIO devices.
> >>>
> >>> The kvm-vfio device now holds a list of devices (kvm_vfio_device)
> >>> in addition to a list of groups (kvm_vfio_group). The new
> >>> infrastructure enables to check the validity of the VFIO device
> >>> file descriptor, get and hold a reference to it.
> >>>
> >>> The first concrete implemented command is IRQ forward control:
> >>> KVM_DEV_VFIO_DEVICE_FORWARD_IRQ, KVM_DEV_VFIO_DEVICE_UNFORWARD_IRQ.
> >>>
> >>> It consists in programing the VFIO driver and KVM in a consistent manner
> >>> so that an optimized IRQ injection/completion is set up. Each
> >>> kvm_vfio_device holds a list of forwarded IRQ. When putting a
> >>> kvm_vfio_device, the implementation makes sure the forwarded IRQs
> >>> are set again in the normal handling state (non forwarded).
> >>
> >> 'putting a kvm_vfio_device' sounds to like you're golf'ing :)
> >>
> >> When a kvm_vfio_device is released?
> >>
> >>>
> >>> The forwarding programmming is architecture specific, embodied by the
> >>> kvm_arch_set_fwd_state function. Its implementation is given in a
> >>> separate patch file.
> >>
> >> I would drop the last sentence and instead indicate that this is handled
> >> properly when the architecture does not support such a feature.
> >>
> >>>
> >>> The forwarding control modality is enabled by the
> >>> __KVM_HAVE_ARCH_KVM_VFIO_FORWARD define.
> >>>
> >>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> >>>
> >>> ---
> >>>
> >>> v1 -> v2:
> >>> - __KVM_HAVE_ARCH_KVM_VFIO renamed into __KVM_HAVE_ARCH_KVM_VFIO_FORWARD
> >>> - original patch file separated into 2 parts: generic part moved in vfio.c
> >>>   and ARM specific part(kvm_arch_set_fwd_state)
> >>> ---
> >>>  include/linux/kvm_host.h |  27 +++
> >>>  virt/kvm/vfio.c          | 452 ++++++++++++++++++++++++++++++++++++++++++++++-
> >>>  2 files changed, 477 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> >>> index a4c33b3..24350dc 100644
> >>> --- a/include/linux/kvm_host.h
> >>> +++ b/include/linux/kvm_host.h
> >>> @@ -1065,6 +1065,21 @@ struct kvm_device_ops {
> >>>  		      unsigned long arg);
> >>>  };
> >>>  
> >>> +enum kvm_fwd_irq_action {
> >>> +	KVM_VFIO_IRQ_SET_FORWARD,
> >>> +	KVM_VFIO_IRQ_SET_NORMAL,
> >>> +	KVM_VFIO_IRQ_CLEANUP,
> >>
> >> This is KVM internal API, so it would probably be good to document this.
> >> Especially the CLEANUP bit worries me, see below.
> > 
> > This also doesn't match the user API, which is simply FORWARD/UNFORWARD.
> Hi Alex,
> 
> will change that.
> > Extra states worry me too.
> 
> I tried to explained the 2 motivations behind. Please let me know if it
> makes sense.
> > 
> >>> +};
> >>> +
> >>> +/* internal structure describing a forwarded IRQ */
> >>> +struct kvm_fwd_irq {
> >>> +	struct list_head link;
> >>
> >> this list entry is local to the kvm vfio device, right? that means you
> >> probably want a struct with just the below fields, and then have a
> >> containing struct in the generic device file, private to it's logic.
> > 
> > Yes, this is part of the abstraction problem.
> OK will fix that.
> > 
> >>> +	__u32 index; /* platform device irq index */
> > 
> > This is a vfio_device irq_index, but vfio_devices support indexes and
> > sub-indexes.  At this level the API should match vfio, not the specifics
> > of platform devices not supporting sub-index.
> I will add sub-indexes then.
> > 
> >>> +	__u32 hwirq; /*physical IRQ */
> >>> +	__u32 gsi; /* virtual IRQ */
> >>> +	struct kvm_vcpu *vcpu; /* vcpu to inject into*/
> > 
> > Not sure I understand why vcpu is necessary.
> vcpu is used when providing the physical IRQ/virtual IRQ mapping to the
> virtual GIC. I can remove it from and add a vcpu struct * param to
> kvm_arch_set_fwd_state if you prefer.
> 
>   Also I see a 'get' in the code below, but not a 'put'.
> Sorry I do not understand your comment here? What 'get' do you mention?

he means kvm_get_vcpu(), but you are ok on that one, the kvm naming of
this function is unfortunate, because it doesn't increment any refcounts
but just resolves to an entry in the array.

> > 
> >>> +};
> >>> +
> >>>  void kvm_device_get(struct kvm_device *dev);
> >>>  void kvm_device_put(struct kvm_device *dev);
> >>>  struct kvm_device *kvm_device_from_filp(struct file *filp);
> >>> @@ -1075,6 +1090,18 @@ extern struct kvm_device_ops kvm_vfio_ops;
> >>>  extern struct kvm_device_ops kvm_arm_vgic_v2_ops;
> >>>  extern struct kvm_device_ops kvm_flic_ops;
> >>>  
> >>> +#ifdef __KVM_HAVE_ARCH_KVM_VFIO_FORWARD
> >>> +int kvm_arch_set_fwd_state(struct kvm_fwd_irq *pfwd,
> >>
> >> what's the 'p' in pfwd?
> > 
> > p is for pointer?
> yes it was ;-)
> > 
> >>> +			   enum kvm_fwd_irq_action action);
> >>> +
> >>> +#else
> >>> +static inline int kvm_arch_set_fwd_state(struct kvm_fwd_irq *pfwd,
> >>> +					 enum kvm_fwd_irq_action action)
> >>> +{
> >>> +	return 0;
> >>> +}
> >>> +#endif
> >>> +
> >>>  #ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
> >>>  
> >>>  static inline void kvm_vcpu_set_in_spin_loop(struct kvm_vcpu *vcpu, bool val)
> >>> diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
> >>> index 76dc7a1..e4a81c4 100644
> >>> --- a/virt/kvm/vfio.c
> >>> +++ b/virt/kvm/vfio.c
> >>> @@ -18,14 +18,24 @@
> >>>  #include <linux/slab.h>
> >>>  #include <linux/uaccess.h>
> >>>  #include <linux/vfio.h>
> >>> +#include <linux/platform_device.h>
> >>>  
> >>>  struct kvm_vfio_group {
> >>>  	struct list_head node;
> >>>  	struct vfio_group *vfio_group;
> >>>  };
> >>>  
> >>> +struct kvm_vfio_device {
> >>> +	struct list_head node;
> >>> +	struct vfio_device *vfio_device;
> >>> +	/* list of forwarded IRQs for that VFIO device */
> >>> +	struct list_head fwd_irq_list;
> >>> +	int fd;
> >>> +};
> >>> +
> >>>  struct kvm_vfio {
> >>>  	struct list_head group_list;
> >>> +	struct list_head device_list;
> >>>  	struct mutex lock;
> >>>  	bool noncoherent;
> >>>  };
> >>> @@ -246,12 +256,441 @@ static int kvm_vfio_set_group(struct kvm_device *dev, long attr, u64 arg)
> >>>  	return -ENXIO;
> >>>  }
> >>>  
> >>> +/**
> >>> + * get_vfio_device - returns the vfio-device corresponding to this fd
> >>> + * @fd:fd of the vfio platform device
> >>> + *
> >>> + * checks it is a vfio device
> >>> + * increment its ref counter
> >>
> >> why the short lines?  Just write this out in proper English.
> >>
> >>> + */
> >>> +static struct vfio_device *kvm_vfio_get_vfio_device(int fd)
> >>> +{
> >>> +	struct fd f;
> >>> +	struct vfio_device *vdev;
> >>> +
> >>> +	f = fdget(fd);
> >>> +	if (!f.file)
> >>> +		return NULL;
> >>> +	vdev = kvm_vfio_device_get_external_user(f.file);
> >>> +	fdput(f);
> >>> +	return vdev;
> >>> +}
> >>> +
> >>> +/**
> >>> + * put_vfio_device: put the vfio platform device
> >>> + * @vdev: vfio_device to put
> >>> + *
> >>> + * decrement the ref counter
> >>> + */
> >>> +static void kvm_vfio_put_vfio_device(struct vfio_device *vdev)
> >>> +{
> >>> +	kvm_vfio_device_put_external_user(vdev);
> >>> +}
> >>> +
> >>> +/**
> >>> + * kvm_vfio_find_device - look for the device in the assigned
> >>> + * device list
> >>> + * @kv: the kvm-vfio device
> >>> + * @vdev: the vfio_device to look for
> >>> + *
> >>> + * returns the associated kvm_vfio_device if the device is known,
> >>> + * meaning at least 1 IRQ is forwarded for this device.
> >>> + * in the device is not registered, returns NULL.
> >>> + */
> > 
> > Why are we talking about forwarded IRQs already, this is a simple lookup
> > function, who knows what other users it will have in the future.
> I will correct
> > 
> >>
> >> are these functions meant to be exported?  Otherwise they should be
> >> static, and the documentation on these simple list iteration wrappers
> >> seems like overkill imho.
> >>
> >>> +struct kvm_vfio_device *kvm_vfio_find_device(struct kvm_vfio *kv,
> >>> +					     struct vfio_device *vdev)
> >>> +{
> >>> +	struct kvm_vfio_device *kvm_vdev_iter;
> >>> +
> >>> +	list_for_each_entry(kvm_vdev_iter, &kv->device_list, node) {
> >>> +		if (kvm_vdev_iter->vfio_device == vdev)
> >>> +			return kvm_vdev_iter;
> >>> +	}
> >>> +	return NULL;
> >>> +}
> >>> +
> >>> +/**
> >>> + * kvm_vfio_find_irq - look for a an irq in the device IRQ list
> >>> + * @kvm_vdev: the kvm_vfio_device
> >>> + * @irq_index: irq index
> >>> + *
> >>> + * returns the forwarded irq struct if it exists, NULL in the negative
> >>> + */
> >>> +struct kvm_fwd_irq *kvm_vfio_find_irq(struct kvm_vfio_device *kvm_vdev,
> >>> +				      int irq_index)
> > 
> > +sub-index
> OK
> > 
> > probably important to note on both of these that they need to be called
> > with kv->lock
> OK
> > 
> >>> +{
> >>> +	struct kvm_fwd_irq *fwd_irq_iter;
> >>> +
> >>> +	list_for_each_entry(fwd_irq_iter, &kvm_vdev->fwd_irq_list, link) {
> >>> +		if (fwd_irq_iter->index == irq_index)
> >>> +			return fwd_irq_iter;
> >>> +	}
> >>> +	return NULL;
> >>> +}
> >>> +
> >>> +/**
> >>> + * validate_forward - checks whether forwarding a given IRQ is meaningful
> >>> + * @vdev:  vfio_device the IRQ belongs to
> >>> + * @fwd_irq: user struct containing the irq_index to forward
> >>> + * @kvm_vdev: if a forwarded IRQ already exists for that VFIO device,
> >>> + * kvm_vfio_device that holds it
> >>> + * @hwirq: irq numberthe irq index corresponds to
> >>> + *
> >>> + * checks the vfio-device is a platform vfio device
> >>> + * checks the irq_index corresponds to an actual hwirq and
> >>> + * checks this hwirq is not already forwarded
> >>> + * returns < 0 on following errors:
> >>> + * not a platform device, bad irq index, already forwarded
> >>> + */
> >>> +static int kvm_vfio_validate_forward(struct kvm_vfio *kv,
> >>> +			    struct vfio_device *vdev,
> >>> +			    struct kvm_arch_forwarded_irq *fwd_irq,
> >>> +			    struct kvm_vfio_device **kvm_vdev,
> >>> +			    int *hwirq)
> >>> +{
> >>> +	struct device *dev = kvm_vfio_external_base_device(vdev);
> >>> +	struct platform_device *platdev;
> >>> +
> >>> +	*hwirq = -1;
> >>> +	*kvm_vdev = NULL;
> >>> +	if (strcmp(dev->bus->name, "platform") == 0) {
> > 
> > Should be testing dev->bus_type == &platform_bus_type, and ideally
> > creating a dev_is_platform() macro to make that even cleaner.
> OK
> > 
> > However, we're being sort of sneaky here that we're actually doing
> > something platform device specific here.  Why?  Don't we just need to
> > make sure that kvm-vfio doesn't have any record of this forward
> > (-EEXIST) and let the platform device code error out later for this
> > case?
> After having answered to Christoffer's comments, I think I should check
> whether the IRQ is not already mapped at VGIC level. In that case I
> would need to split the validate function into 2 parts:
> - generic part only checks the vfio_device/irq_index is not already
> recorded. I do not need the hwirq for that.
> - arm specific part checks no GIC mapping does exist (need the hwirq)
> 
> Would it be OK for both of you?

the latter being in the arch specific code it sounds like, but sure,
there's a lot of cleanup to be made here, so go with that appraoch and
get a second version out soon, then we can have another look.

> > 
> >>> +		platdev = to_platform_device(dev);
> >>> +		*hwirq = platform_get_irq(platdev, fwd_irq->index);
> >>> +		if (*hwirq < 0) {
> >>> +			kvm_err("%s incorrect index\n", __func__);
> >>> +			return -EINVAL;
> >>> +		}
> >>> +	} else {
> >>> +		kvm_err("%s not a platform device\n", __func__);
> >>> +		return -EINVAL;
> >>> +	}
> >>
> >> need some spaceing here, also, I would turn this around, first check if
> >> the strcmp fails, and then error out, then do you next check etc., to
> >> avoid so many nested statements.
> >>
> >>> +	/* is a ref to this device already owned by the KVM-VFIO device? */
> >>
> >> this comment is not particularly helpful in its current form, it would
> >> be helpful if you specified that we're checking whether that particular
> >> device/irq combo is already registered.
> >>
> >>> +	*kvm_vdev = kvm_vfio_find_device(kv, vdev);
> >>> +	if (*kvm_vdev) {
> >>> +		if (kvm_vfio_find_irq(*kvm_vdev, fwd_irq->index)) {
> >>> +			kvm_err("%s irq %d already forwarded\n",
> >>> +				__func__, *hwirq);
> > 
> > Why didn't we do this first?
> see above comment
> > 
> >> don't flood the kernel log because of a user error, just allocate an
> >> error code for this purpose and document it in the ABI, -EEXIST or
> >> something.
> >>
> >>> +			return -EINVAL;
> >>> +		}
> >>> +	}
> >>> +	return 0;
> >>> +}
> >>> +
> >>> +/**
> >>> + * validate_unforward: check a deassignment is meaningful
> >>> + * @kv: the kvm_vfio device
> >>> + * @vdev: the vfio_device whose irq to deassign belongs to
> >>> + * @fwd_irq: the user struct that contains the fd and irq_index of the irq
> >>> + * @kvm_vdev: the kvm_vfio_device the forwarded irq belongs to, if
> >>> + * it exists
> >>> + *
> >>> + * returns 0 if the provided irq effectively is forwarded
> >>> + * (a ref to this vfio_device is hold and this irq belongs to
> >>                                     held
> >>> + * the forwarded irq of this device)
> >>> + * returns -EINVAL in the negative
> >>
> >>                ENOENT should be returned if you don't have an entry.
> >> 	       EINVAL could be used if you supply an fd that isn't a
> >> 	       VFIO device file descriptor, for example.  Again,
> >> 	       consider documenting all this in the API.
> >>
> >>> + */
> >>> +static int kvm_vfio_validate_unforward(struct kvm_vfio *kv,
> >>> +			      struct vfio_device *vdev,
> >>> +			      struct kvm_arch_forwarded_irq *fwd_irq,
> >>> +			      struct kvm_vfio_device **kvm_vdev)
> >>> +{
> >>> +	struct kvm_fwd_irq *pfwd;
> >>> +
> >>> +	*kvm_vdev = kvm_vfio_find_device(kv, vdev);
> >>> +	if (!kvm_vdev) {
> >>> +		kvm_err("%s no forwarded irq for this device\n", __func__);
> >>
> >> don't flood the kernel log
> >>
> >>> +		return -EINVAL;
> >>> +	}
> >>> +	pfwd = kvm_vfio_find_irq(*kvm_vdev, fwd_irq->index);
> >>> +	if (!pfwd) {
> >>> +		kvm_err("%s irq %d is not forwarded\n", __func__, fwd_irq->fd);
> >>
> >>> +		return -EINVAL;
> >>
> >> same here
> I do not understand. With current functions I need to first retrieve the
> device and then iterate on IRQs of that device.
> >>

I'm just saying you shouldn't print to the kernel log because the user
did something stupid.

-Christoffer
