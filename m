Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751102AbaIKFGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 01:06:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbaIKFGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 01:06:45 -0400
Message-ID: <1410411949.2982.284.camel@ul30vt.home>
Subject: Re: [RFC v2 8/9] KVM: KVM-VFIO: generic KVM_DEV_VFIO_DEVICE command
 and IRQ forwarding control
From: Alex Williamson <alex.williamson@redhat.com>
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, eric.auger@st.com,
        marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, joel.schopp@amd.com,
        kim.phillips@freescale.com, paulus@samba.org, gleb@kernel.org,
        pbonzini@redhat.com, linux-kernel@vger.kernel.org, patches@linaro.org,
        will.deacon@arm.com, a.motakis@virtualopensystems.com,
        a.rigo@virtualopensystems.com, john.liuli@huawei.com
Date: Wed, 10 Sep 2014 23:05:49 -0600
In-Reply-To: <20140911031026.GI2784@lvm>
References: <1409575968-5329-1-git-send-email-eric.auger@linaro.org>
	 <1409575968-5329-9-git-send-email-eric.auger@linaro.org>
	 <20140911031026.GI2784@lvm>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-11 at 05:10 +0200, Christoffer Dall wrote:
> On Mon, Sep 01, 2014 at 02:52:47PM +0200, Eric Auger wrote:
> > This patch introduces a new KVM_DEV_VFIO_DEVICE attribute.
> > 
> > This is a new control channel which enables KVM to cooperate with
> > viable VFIO devices.
> > 
> > The kvm-vfio device now holds a list of devices (kvm_vfio_device)
> > in addition to a list of groups (kvm_vfio_group). The new
> > infrastructure enables to check the validity of the VFIO device
> > file descriptor, get and hold a reference to it.
> > 
> > The first concrete implemented command is IRQ forward control:
> > KVM_DEV_VFIO_DEVICE_FORWARD_IRQ, KVM_DEV_VFIO_DEVICE_UNFORWARD_IRQ.
> > 
> > It consists in programing the VFIO driver and KVM in a consistent manner
> > so that an optimized IRQ injection/completion is set up. Each
> > kvm_vfio_device holds a list of forwarded IRQ. When putting a
> > kvm_vfio_device, the implementation makes sure the forwarded IRQs
> > are set again in the normal handling state (non forwarded).
> 
> 'putting a kvm_vfio_device' sounds to like you're golf'ing :)
> 
> When a kvm_vfio_device is released?
> 
> > 
> > The forwarding programmming is architecture specific, embodied by the
> > kvm_arch_set_fwd_state function. Its implementation is given in a
> > separate patch file.
> 
> I would drop the last sentence and instead indicate that this is handled
> properly when the architecture does not support such a feature.
> 
> > 
> > The forwarding control modality is enabled by the
> > __KVM_HAVE_ARCH_KVM_VFIO_FORWARD define.
> > 
> > Signed-off-by: Eric Auger <eric.auger@linaro.org>
> > 
> > ---
> > 
> > v1 -> v2:
> > - __KVM_HAVE_ARCH_KVM_VFIO renamed into __KVM_HAVE_ARCH_KVM_VFIO_FORWARD
> > - original patch file separated into 2 parts: generic part moved in vfio.c
> >   and ARM specific part(kvm_arch_set_fwd_state)
> > ---
> >  include/linux/kvm_host.h |  27 +++
> >  virt/kvm/vfio.c          | 452 ++++++++++++++++++++++++++++++++++++++++++++++-
> >  2 files changed, 477 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index a4c33b3..24350dc 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -1065,6 +1065,21 @@ struct kvm_device_ops {
> >  		      unsigned long arg);
> >  };
> >  
> > +enum kvm_fwd_irq_action {
> > +	KVM_VFIO_IRQ_SET_FORWARD,
> > +	KVM_VFIO_IRQ_SET_NORMAL,
> > +	KVM_VFIO_IRQ_CLEANUP,
> 
> This is KVM internal API, so it would probably be good to document this.
> Especially the CLEANUP bit worries me, see below.

This also doesn't match the user API, which is simply FORWARD/UNFORWARD.
Extra states worry me too.

> > +};
> > +
> > +/* internal structure describing a forwarded IRQ */
> > +struct kvm_fwd_irq {
> > +	struct list_head link;
> 
> this list entry is local to the kvm vfio device, right? that means you
> probably want a struct with just the below fields, and then have a
> containing struct in the generic device file, private to it's logic.

Yes, this is part of the abstraction problem.

> > +	__u32 index; /* platform device irq index */

This is a vfio_device irq_index, but vfio_devices support indexes and
sub-indexes.  At this level the API should match vfio, not the specifics
of platform devices not supporting sub-index.

> > +	__u32 hwirq; /*physical IRQ */
> > +	__u32 gsi; /* virtual IRQ */
> > +	struct kvm_vcpu *vcpu; /* vcpu to inject into*/

Not sure I understand why vcpu is necessary.  Also I see a 'get' in the
code below, but not a 'put'.

> > +};
> > +
> >  void kvm_device_get(struct kvm_device *dev);
> >  void kvm_device_put(struct kvm_device *dev);
> >  struct kvm_device *kvm_device_from_filp(struct file *filp);
> > @@ -1075,6 +1090,18 @@ extern struct kvm_device_ops kvm_vfio_ops;
> >  extern struct kvm_device_ops kvm_arm_vgic_v2_ops;
> >  extern struct kvm_device_ops kvm_flic_ops;
> >  
> > +#ifdef __KVM_HAVE_ARCH_KVM_VFIO_FORWARD
> > +int kvm_arch_set_fwd_state(struct kvm_fwd_irq *pfwd,
> 
> what's the 'p' in pfwd?

p is for pointer?

> > +			   enum kvm_fwd_irq_action action);
> > +
> > +#else
> > +static inline int kvm_arch_set_fwd_state(struct kvm_fwd_irq *pfwd,
> > +					 enum kvm_fwd_irq_action action)
> > +{
> > +	return 0;
> > +}
> > +#endif
> > +
> >  #ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
> >  
> >  static inline void kvm_vcpu_set_in_spin_loop(struct kvm_vcpu *vcpu, bool val)
> > diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
> > index 76dc7a1..e4a81c4 100644
> > --- a/virt/kvm/vfio.c
> > +++ b/virt/kvm/vfio.c
> > @@ -18,14 +18,24 @@
> >  #include <linux/slab.h>
> >  #include <linux/uaccess.h>
> >  #include <linux/vfio.h>
> > +#include <linux/platform_device.h>
> >  
> >  struct kvm_vfio_group {
> >  	struct list_head node;
> >  	struct vfio_group *vfio_group;
> >  };
> >  
> > +struct kvm_vfio_device {
> > +	struct list_head node;
> > +	struct vfio_device *vfio_device;
> > +	/* list of forwarded IRQs for that VFIO device */
> > +	struct list_head fwd_irq_list;
> > +	int fd;
> > +};
> > +
> >  struct kvm_vfio {
> >  	struct list_head group_list;
> > +	struct list_head device_list;
> >  	struct mutex lock;
> >  	bool noncoherent;
> >  };
> > @@ -246,12 +256,441 @@ static int kvm_vfio_set_group(struct kvm_device *dev, long attr, u64 arg)
> >  	return -ENXIO;
> >  }
> >  
> > +/**
> > + * get_vfio_device - returns the vfio-device corresponding to this fd
> > + * @fd:fd of the vfio platform device
> > + *
> > + * checks it is a vfio device
> > + * increment its ref counter
> 
> why the short lines?  Just write this out in proper English.
> 
> > + */
> > +static struct vfio_device *kvm_vfio_get_vfio_device(int fd)
> > +{
> > +	struct fd f;
> > +	struct vfio_device *vdev;
> > +
> > +	f = fdget(fd);
> > +	if (!f.file)
> > +		return NULL;
> > +	vdev = kvm_vfio_device_get_external_user(f.file);
> > +	fdput(f);
> > +	return vdev;
> > +}
> > +
> > +/**
> > + * put_vfio_device: put the vfio platform device
> > + * @vdev: vfio_device to put
> > + *
> > + * decrement the ref counter
> > + */
> > +static void kvm_vfio_put_vfio_device(struct vfio_device *vdev)
> > +{
> > +	kvm_vfio_device_put_external_user(vdev);
> > +}
> > +
> > +/**
> > + * kvm_vfio_find_device - look for the device in the assigned
> > + * device list
> > + * @kv: the kvm-vfio device
> > + * @vdev: the vfio_device to look for
> > + *
> > + * returns the associated kvm_vfio_device if the device is known,
> > + * meaning at least 1 IRQ is forwarded for this device.
> > + * in the device is not registered, returns NULL.
> > + */

Why are we talking about forwarded IRQs already, this is a simple lookup
function, who knows what other users it will have in the future.

> 
> are these functions meant to be exported?  Otherwise they should be
> static, and the documentation on these simple list iteration wrappers
> seems like overkill imho.
> 
> > +struct kvm_vfio_device *kvm_vfio_find_device(struct kvm_vfio *kv,
> > +					     struct vfio_device *vdev)
> > +{
> > +	struct kvm_vfio_device *kvm_vdev_iter;
> > +
> > +	list_for_each_entry(kvm_vdev_iter, &kv->device_list, node) {
> > +		if (kvm_vdev_iter->vfio_device == vdev)
> > +			return kvm_vdev_iter;
> > +	}
> > +	return NULL;
> > +}
> > +
> > +/**
> > + * kvm_vfio_find_irq - look for a an irq in the device IRQ list
> > + * @kvm_vdev: the kvm_vfio_device
> > + * @irq_index: irq index
> > + *
> > + * returns the forwarded irq struct if it exists, NULL in the negative
> > + */
> > +struct kvm_fwd_irq *kvm_vfio_find_irq(struct kvm_vfio_device *kvm_vdev,
> > +				      int irq_index)

+sub-index

probably important to note on both of these that they need to be called
with kv->lock

> > +{
> > +	struct kvm_fwd_irq *fwd_irq_iter;
> > +
> > +	list_for_each_entry(fwd_irq_iter, &kvm_vdev->fwd_irq_list, link) {
> > +		if (fwd_irq_iter->index == irq_index)
> > +			return fwd_irq_iter;
> > +	}
> > +	return NULL;
> > +}
> > +
> > +/**
> > + * validate_forward - checks whether forwarding a given IRQ is meaningful
> > + * @vdev:  vfio_device the IRQ belongs to
> > + * @fwd_irq: user struct containing the irq_index to forward
> > + * @kvm_vdev: if a forwarded IRQ already exists for that VFIO device,
> > + * kvm_vfio_device that holds it
> > + * @hwirq: irq numberthe irq index corresponds to
> > + *
> > + * checks the vfio-device is a platform vfio device
> > + * checks the irq_index corresponds to an actual hwirq and
> > + * checks this hwirq is not already forwarded
> > + * returns < 0 on following errors:
> > + * not a platform device, bad irq index, already forwarded
> > + */
> > +static int kvm_vfio_validate_forward(struct kvm_vfio *kv,
> > +			    struct vfio_device *vdev,
> > +			    struct kvm_arch_forwarded_irq *fwd_irq,
> > +			    struct kvm_vfio_device **kvm_vdev,
> > +			    int *hwirq)
> > +{
> > +	struct device *dev = kvm_vfio_external_base_device(vdev);
> > +	struct platform_device *platdev;
> > +
> > +	*hwirq = -1;
> > +	*kvm_vdev = NULL;
> > +	if (strcmp(dev->bus->name, "platform") == 0) {

Should be testing dev->bus_type == &platform_bus_type, and ideally
creating a dev_is_platform() macro to make that even cleaner.

However, we're being sort of sneaky here that we're actually doing
something platform device specific here.  Why?  Don't we just need to
make sure that kvm-vfio doesn't have any record of this forward
(-EEXIST) and let the platform device code error out later for this
case?

> > +		platdev = to_platform_device(dev);
> > +		*hwirq = platform_get_irq(platdev, fwd_irq->index);
> > +		if (*hwirq < 0) {
> > +			kvm_err("%s incorrect index\n", __func__);
> > +			return -EINVAL;
> > +		}
> > +	} else {
> > +		kvm_err("%s not a platform device\n", __func__);
> > +		return -EINVAL;
> > +	}
> 
> need some spaceing here, also, I would turn this around, first check if
> the strcmp fails, and then error out, then do you next check etc., to
> avoid so many nested statements.
> 
> > +	/* is a ref to this device already owned by the KVM-VFIO device? */
> 
> this comment is not particularly helpful in its current form, it would
> be helpful if you specified that we're checking whether that particular
> device/irq combo is already registered.
> 
> > +	*kvm_vdev = kvm_vfio_find_device(kv, vdev);
> > +	if (*kvm_vdev) {
> > +		if (kvm_vfio_find_irq(*kvm_vdev, fwd_irq->index)) {
> > +			kvm_err("%s irq %d already forwarded\n",
> > +				__func__, *hwirq);

Why didn't we do this first?

> don't flood the kernel log because of a user error, just allocate an
> error code for this purpose and document it in the ABI, -EEXIST or
> something.
> 
> > +			return -EINVAL;
> > +		}
> > +	}
> > +	return 0;
> > +}
> > +
> > +/**
> > + * validate_unforward: check a deassignment is meaningful
> > + * @kv: the kvm_vfio device
> > + * @vdev: the vfio_device whose irq to deassign belongs to
> > + * @fwd_irq: the user struct that contains the fd and irq_index of the irq
> > + * @kvm_vdev: the kvm_vfio_device the forwarded irq belongs to, if
> > + * it exists
> > + *
> > + * returns 0 if the provided irq effectively is forwarded
> > + * (a ref to this vfio_device is hold and this irq belongs to
>                                     held
> > + * the forwarded irq of this device)
> > + * returns -EINVAL in the negative
> 
>                ENOENT should be returned if you don't have an entry.
> 	       EINVAL could be used if you supply an fd that isn't a
> 	       VFIO device file descriptor, for example.  Again,
> 	       consider documenting all this in the API.
> 
> > + */
> > +static int kvm_vfio_validate_unforward(struct kvm_vfio *kv,
> > +			      struct vfio_device *vdev,
> > +			      struct kvm_arch_forwarded_irq *fwd_irq,
> > +			      struct kvm_vfio_device **kvm_vdev)
> > +{
> > +	struct kvm_fwd_irq *pfwd;
> > +
> > +	*kvm_vdev = kvm_vfio_find_device(kv, vdev);
> > +	if (!kvm_vdev) {
> > +		kvm_err("%s no forwarded irq for this device\n", __func__);
> 
> don't flood the kernel log
> 
> > +		return -EINVAL;
> > +	}
> > +	pfwd = kvm_vfio_find_irq(*kvm_vdev, fwd_irq->index);
> > +	if (!pfwd) {
> > +		kvm_err("%s irq %d is not forwarded\n", __func__, fwd_irq->fd);
> 
> > +		return -EINVAL;
> 
> same here
> 
> > +	}
> > +	return 0;
> > +}
> > +
> > +/**
> > + * kvm_vfio_forward - set a forwarded IRQ
> > + * @kdev: the kvm device
> > + * @vdev: the vfio device the IRQ belongs to
> > + * @fwd_irq: the user struct containing the irq_index and guest irq
> > + * @must_put: tells the caller whether the vfio_device must be put after
> > + * the call (ref must be released in case a ref onto this device was
> > + * already hold or in case of new device and failure)
> > + *
> > + * validate the injection, activate forward and store the information
>       Validate
> > + * about which irq and which device is concerned so that on deassign or
> > + * kvm-vfio destruction everuthing can be cleaned up.
>                            everything
> 
> I'm not sure I understand this explanation.  Do we have concerned
> devices?
> 
> I think you want to say something along the lines of: If userspace passed
> a valid vfio device and irq handle and the architecture supports
> forwarding this combination, register the vfio_device and irq
> combination in the ....
> 
> > + */
> > +static int kvm_vfio_forward(struct kvm_device *kdev,
> > +			    struct vfio_device *vdev,
> > +			    struct kvm_arch_forwarded_irq *fwd_irq,
> > +			    bool *must_put)
> > +{
> > +	int ret;
> > +	struct kvm_fwd_irq *pfwd = NULL;
> > +	struct kvm_vfio_device *kvm_vdev = NULL;
> > +	struct kvm_vfio *kv = kdev->private;
> > +	int hwirq;
> > +
> > +	*must_put = true;
> > +	ret = kvm_vfio_validate_forward(kv, vdev, fwd_irq,
> > +					&kvm_vdev, &hwirq);
> > +	if (ret < 0)
> > +		return -EINVAL;
> > +
> > +	pfwd = kzalloc(sizeof(*pfwd), GFP_KERNEL);
> 
> seems a bit pointless to zero-out the memory if you're setting all
> fields below.
> 
> > +	if (!pfwd)
> > +		return -ENOMEM;
> > +	pfwd->index = fwd_irq->index;
> > +	pfwd->gsi = fwd_irq->gsi;
> > +	pfwd->hwirq = hwirq;
> > +	pfwd->vcpu = kvm_get_vcpu(kdev->kvm, 0);
> > +	ret = kvm_arch_set_fwd_state(pfwd, KVM_VFIO_IRQ_SET_FORWARD);
> > +	if (ret < 0) {
> > +		kvm_arch_set_fwd_state(pfwd, KVM_VFIO_IRQ_CLEANUP);
> 
> this whole thing feels incredibly broken to me.  Setting a forward
> should either work or not work, not something in between that leaves
> something to be cleaned up.  Why this two-stage thingy here?

Yep, I agree.  I also don't see the point of the validate function, just
open code it here and push the platform_get_irq test into
kvm_arch_set_fwd_state.  kvm-vfio doesn't care about the hwirq.

> > +		kfree(pfwd);
> 
> probably want to move your free-and-return-error to the end of the
> function.
> 
> > +		return ret;
> > +	}
> > +
> > +	if (!kvm_vdev) {
> > +		/* create & insert the new device and keep the ref */
> > +		kvm_vdev = kzalloc(sizeof(*kvm_vdev), GFP_KERNEL);
> 
> again, no need for zeroing out the memory.

I think you also want to allocate this before you setup the forward so
you can eliminate any complicated teardown later.

> > +		if (!kvm_vdev) {
> > +			kvm_arch_set_fwd_state(pfwd, false);

false?  The function takes an enum.

> > +			kfree(pfwd);
> > +			return -ENOMEM;
> > +		}
> > +
> > +		kvm_vdev->vfio_device = vdev;
> > +		kvm_vdev->fd = fwd_irq->fd;
> > +		INIT_LIST_HEAD(&kvm_vdev->fwd_irq_list);
> > +		list_add(&kvm_vdev->node, &kv->device_list);
> > +		/*
> > +		 * the only case where we keep the ref:
> > +		 * new device and forward setting successful
> > +		 */
> > +		*must_put = false;
> > +	}
> > +
> > +	list_add(&pfwd->link, &kvm_vdev->fwd_irq_list);
> > +
> > +	kvm_debug("forwarding set for fd=%d, hwirq=%d, gsi=%d\n",
> > +	fwd_irq->fd, hwirq, fwd_irq->gsi);
> 
> please indent this to align with the opening parenthesis.
> 
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * remove_assigned_device - put a given device from the list
> 
> this isn't a 'put', at least not *just* a put.
> 
> > + * @kv: the kvm-vfio device
> > + * @vdev: the vfio-device to remove
> > + *
> > + * change the state of all forwarded IRQs, free the forwarded IRQ list,
> > + * remove the corresponding kvm_vfio_device from the assigned device
> > + * list.
> > + * returns true if the device could be removed, false in the negative
> > + */
> > +bool remove_assigned_device(struct kvm_vfio *kv,
> > +			    struct vfio_device *vdev)
> > +{
> > +	struct kvm_vfio_device *kvm_vdev_iter, *tmp_vdev;
> > +	struct kvm_fwd_irq *fwd_irq_iter, *tmp_irq;
> > +	bool removed = false;
> > +	int ret;
> > +
> > +	list_for_each_entry_safe(kvm_vdev_iter, tmp_vdev,
> > +				 &kv->device_list, node) {
> > +		if (kvm_vdev_iter->vfio_device == vdev) {
> > +			/* loop on all its forwarded IRQ */
> > +			list_for_each_entry_safe(fwd_irq_iter, tmp_irq,
> > +						 &kvm_vdev_iter->fwd_irq_list,
> > +						 link) {
> 
> hmm, seems this function is only called when you have no more forwarded
> IRQs, so isn't all of this completely dead (and unnecessary) code?
> 
> > +				ret = kvm_arch_set_fwd_state(fwd_irq_iter,
> > +						KVM_VFIO_IRQ_SET_NORMAL);
> > +				if (ret < 0)
> > +					return ret;
> 
> you're returning an error code to a bool function, which means you'll
> return true when there was an error.  Is this your intention? ;)
> 
> if we have an error here, this would be a very very bad situation wouldn't it?
> 
> > +				list_del(&fwd_irq_iter->link);
> > +				kfree(fwd_irq_iter);
> > +			}
> > +			/* all IRQs could be deassigned */
> > +			list_del(&kvm_vdev_iter->node);
> > +			kvm_vfio_device_put_external_user(
> > +				kvm_vdev_iter->vfio_device);
> > +			kfree(kvm_vdev_iter);
> > +			removed = true;
> > +			break;
> > +		}
> > +	}
> > +	return removed;
> > +}
> > +
> > +
> > +/**
> > + * remove_fwd_irq - remove a forwarded irq
> > + *
> > + * @kv: kvm-vfio device
> > + * kvm_vdev: the kvm_vfio_device the IRQ belongs to
> > + * irq_index: the index of the IRQ
> > + *
> > + * change the forwarded state of the IRQ, remove the IRQ from
> > + * the device forwarded IRQ list. In case it is the last one,
> > + * put the device
> > + */
> > +int remove_fwd_irq(struct kvm_vfio *kv,
> > +		   struct kvm_vfio_device *kvm_vdev,
> > +		   int irq_index)
> > +{
> > +	struct kvm_fwd_irq *fwd_irq_iter, *tmp_irq;
> > +	int ret = -1;
> > +
> > +	list_for_each_entry_safe(fwd_irq_iter, tmp_irq,
> > +				 &kvm_vdev->fwd_irq_list, link) {
> 
> hmmm, you can only forward one irq for a specific device once, right?
> And you already have a lookup function, so why not call that, and then
> remove it?
> 
> I'm confused.

Me too, this and the previous function need some more consideration.

> > +		if (fwd_irq_iter->index == irq_index) {
> > +			ret = kvm_arch_set_fwd_state(fwd_irq_iter,
> > +						KVM_VFIO_IRQ_SET_NORMAL);
> > +			if (ret < 0)
> > +				break;
> > +			list_del(&fwd_irq_iter->link);
> > +			kfree(fwd_irq_iter);
> > +			ret = 0;
> > +			break;
> > +		}
> > +	}
> > +	if (list_empty(&kvm_vdev->fwd_irq_list))
> > +		remove_assigned_device(kv, kvm_vdev->vfio_device);
> > +
> > +	return ret;
> > +}
> > +
> > +/**
> > + * kvm_vfio_unforward - remove a forwarded IRQ
> > + * @kdev: the kvm device
> > + * @vdev: the vfio_device
> > + * @fwd_irq: user struct
> > + * after checking this IRQ effectively is forwarded, change its state,
> > + * remove it from the corresponding kvm_vfio_device list
> > + */
> > +static int kvm_vfio_unforward(struct kvm_device *kdev,
> > +				     struct vfio_device *vdev,
> > +				     struct kvm_arch_forwarded_irq *fwd_irq)
> > +{
> > +	struct kvm_vfio *kv = kdev->private;
> > +	struct kvm_vfio_device *kvm_vdev;
> > +	int ret;
> > +
> > +	ret = kvm_vfio_validate_unforward(kv, vdev, fwd_irq, &kvm_vdev);
> > +	if (ret < 0)
> > +		return -EINVAL;
> 
> why do you override the return value?  Propagate it.
> 
> > +
> > +	ret = remove_fwd_irq(kv, kvm_vdev, fwd_irq->index);
> > +	if (ret < 0)
> > +		kvm_err("%s fail unforwarding (fd=%d, index=%d)\n",
> > +			__func__, fwd_irq->fd, fwd_irq->index);
> > +	else
> > +		kvm_debug("%s unforwarding IRQ (fd=%d, index=%d)\n",
> > +			  __func__, fwd_irq->fd, fwd_irq->index);
> 
> again with the kernel log here.
> 
> 
> 
> > +	return ret;
> > +}
> > +
> > +
> > +
> > +
> > +/**
> > + * kvm_vfio_set_device - the top function for interracting with a vfio
> 
>                                 top?             interacting
> 
> > + * device
> > + */
> 
> probably just skip this comment
> 
> > +static int kvm_vfio_set_device(struct kvm_device *kdev, long attr, u64 arg)
> > +{
> > +	struct kvm_vfio *kv = kdev->private;
> > +	struct vfio_device *vdev;
> > +	struct kvm_arch_forwarded_irq fwd_irq; /* user struct */
> > +	int32_t __user *argp = (int32_t __user *)(unsigned long)arg;
> > +
> > +	switch (attr) {
> > +#ifdef __KVM_HAVE_ARCH_KVM_VFIO_FORWARD
> > +	case KVM_DEV_VFIO_DEVICE_FORWARD_IRQ:{
> > +		bool must_put;
> > +		int ret;
> > +
> > +		if (copy_from_user(&fwd_irq, argp, sizeof(fwd_irq)))
> > +			return -EFAULT;
> > +		vdev = kvm_vfio_get_vfio_device(fwd_irq.fd);
> > +		if (IS_ERR(vdev))
> > +			return PTR_ERR(vdev);
> 
> seems like this whole block of code is replicated below, needs
> refactoring.
> 
> > +		mutex_lock(&kv->lock);
> > +		ret = kvm_vfio_forward(kdev, vdev, &fwd_irq, &must_put);
> > +		if (must_put)
> > +			kvm_vfio_put_vfio_device(vdev);
> 
> this must_put looks plain weird.  I think you want to balance your
> get/put's always; can't you just get an extra reference in
> kvm_vfio_forward() ?

Yeah, this is very broken.  Every forwarded IRQ should hold a reference
to the vfio_device.  Every unforward should drop a reference.  Trying to
maintain a single reference is a non-goal.

> 
> > +		mutex_unlock(&kv->lock);
> > +		return ret;
> > +		}
> > +	case KVM_DEV_VFIO_DEVICE_UNFORWARD_IRQ: {
> > +		int ret;
> > +
> > +		if (copy_from_user(&fwd_irq, argp, sizeof(fwd_irq)))
> > +			return -EFAULT;
> > +		vdev = kvm_vfio_get_vfio_device(fwd_irq.fd);
> > +		if (IS_ERR(vdev))
> > +			return PTR_ERR(vdev);
> > +
> > +		kvm_vfio_device_put_external_user(vdev);
> 
> you're dropping the reference to the device but referencing it in your
> unfoward call below?
> 
> > +		mutex_lock(&kv->lock);
> > +		ret = kvm_vfio_unforward(kdev, vdev, &fwd_irq);
> > +		mutex_unlock(&kv->lock);
> > +		return ret;
> > +	}
> > +#endif
> > +	default:
> > +		return -ENXIO;
> > +	}
> > +}
> > +
> > +/**
> > + * kvm_vfio_put_all_devices - cancel forwarded IRQs and put all devices
> > + * @kv: kvm-vfio device
> > + *
> > + * loop on all got devices and their associated forwarded IRQs
> 
> 'loop on all got' ?
> 
> Restore the non-forwarded state for all registered devices and ...
> 
> > + * restore the non forwarded state, remove IRQs and their devices from
> > + * the respective list, put the vfio platform devices
> > + *
> > + * When this function is called, the vcpu already are destroyed. No
>                                     the VPUCs are already destroyed.
> > + * vgic manipulation can happen hence the KVM_VFIO_IRQ_CLEANUP
> > + * kvm_arch_set_fwd_state action
> 
> this last bit didn't make any sense to me.  Also, why are we referring
> to the vgic in generic code?
> 
> > + */
> > +int kvm_vfio_put_all_devices(struct kvm_vfio *kv)
> > +{
> > +	struct kvm_fwd_irq *fwd_irq_iter, *tmp_irq;
> > +	struct kvm_vfio_device *kvm_vdev_iter, *tmp_vdev;
> > +
> > +	/* loop on all the assigned devices */
> 
> unnecessary comment
> 
> > +	list_for_each_entry_safe(kvm_vdev_iter, tmp_vdev,
> > +				 &kv->device_list, node) {
> > +
> > +		/* loop on all its forwarded IRQ */
> 
> same
> 
> > +		list_for_each_entry_safe(fwd_irq_iter, tmp_irq,
> > +					 &kvm_vdev_iter->fwd_irq_list, link) {
> > +			kvm_arch_set_fwd_state(fwd_irq_iter,
> > +						KVM_VFIO_IRQ_CLEANUP);
> > +			list_del(&fwd_irq_iter->link);
> > +			kfree(fwd_irq_iter);
> > +		}


Ugh, how many of these cleanup functions do we need?

> > +		list_del(&kvm_vdev_iter->node);
> > +		kvm_vfio_device_put_external_user(kvm_vdev_iter->vfio_device);
> > +		kfree(kvm_vdev_iter);
> > +	}
> > +	return 0;
> > +}
> > +
> > +
> >  static int kvm_vfio_set_attr(struct kvm_device *dev,
> >  			     struct kvm_device_attr *attr)
> >  {
> >  	switch (attr->group) {
> >  	case KVM_DEV_VFIO_GROUP:
> >  		return kvm_vfio_set_group(dev, attr->attr, attr->addr);
> > +	case KVM_DEV_VFIO_DEVICE:
> > +		return kvm_vfio_set_device(dev, attr->attr, attr->addr);
> >  	}
> >  
> >  	return -ENXIO;
> > @@ -267,10 +706,17 @@ static int kvm_vfio_has_attr(struct kvm_device *dev,
> >  		case KVM_DEV_VFIO_GROUP_DEL:
> >  			return 0;
> >  		}
> > -
> >  		break;
> > +#ifdef __KVM_HAVE_ARCH_KVM_VFIO_FORWARD
> > +	case KVM_DEV_VFIO_DEVICE:
> > +		switch (attr->attr) {
> > +		case KVM_DEV_VFIO_DEVICE_FORWARD_IRQ:
> > +		case KVM_DEV_VFIO_DEVICE_UNFORWARD_IRQ:
> > +			return 0;
> > +		}
> > +		break;
> > +#endif
> >  	}
> > -
> >  	return -ENXIO;
> >  }
> >  
> > @@ -284,6 +730,7 @@ static void kvm_vfio_destroy(struct kvm_device *dev)
> >  		list_del(&kvg->node);
> >  		kfree(kvg);
> >  	}
> > +	kvm_vfio_put_all_devices(kv);
> >  
> >  	kvm_vfio_update_coherency(dev);
> >  
> > @@ -306,6 +753,7 @@ static int kvm_vfio_create(struct kvm_device *dev, u32 type)
> >  		return -ENOMEM;
> >  
> >  	INIT_LIST_HEAD(&kv->group_list);
> > +	INIT_LIST_HEAD(&kv->device_list);
> >  	mutex_init(&kv->lock);
> >  
> >  	dev->private = kv;
> > -- 
> > 1.9.1
> > 



