Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040AbaLHMYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 07:24:15 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:42623 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695AbaLHMYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 07:24:12 -0500
Message-ID: <54859818.8050507@linaro.org>
Date: Mon, 08 Dec 2014 13:22:48 +0100
From: Eric Auger <eric.auger@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: eric.auger@st.com, christoffer.dall@linaro.org, marc.zyngier@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, joel.schopp@amd.com, kim.phillips@freescale.com,
        paulus@samba.org, gleb@kernel.org, pbonzini@redhat.com, agraf@suse.de,
        linux-kernel@vger.kernel.org, patches@linaro.org, will.deacon@arm.com,
        a.motakis@virtualopensystems.com, a.rigo@virtualopensystems.com,
        john.liuli@huawei.com, ming.lei@canonical.com, feng.wu@intel.com
Subject: Re: [PATCH v3 7/8] KVM: kvm-vfio: generic forwarding control
References: <1416767760-14487-1-git-send-email-eric.auger@linaro.org>		 <1416767760-14487-8-git-send-email-eric.auger@linaro.org>	 <1416862573.11825.83.camel@bling.home> <5474C86D.8000007@linaro.org> <1416942020.11825.134.camel@bling.home>
In-Reply-To: <1416942020.11825.134.camel@bling.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2014 08:00 PM, Alex Williamson wrote:
> On Tue, 2014-11-25 at 19:20 +0100, Eric Auger wrote:
>> On 11/24/2014 09:56 PM, Alex Williamson wrote:
>>> On Sun, 2014-11-23 at 19:35 +0100, Eric Auger wrote:
>>>> This patch introduces a new KVM_DEV_VFIO_DEVICE group.
>>>>
>>>> This is a new control channel which enables KVM to cooperate with
>>>> viable VFIO devices.
>>>>
>>>> Functions are introduced to check the validity of a VFIO device
>>>> file descriptor, increment/decrement the ref counter of the VFIO
>>>> device.
>>>>
>>>> The patch introduces 2 attributes for this new device group:
>>>> KVM_DEV_VFIO_DEVICE_FORWARD_IRQ, KVM_DEV_VFIO_DEVICE_UNFORWARD_IRQ.
>>>> Their purpose is to turn a VFIO device IRQ into a forwarded IRQ and
>>>> unset respectively unset the feature.
>>>>
>>>> The VFIO device stores a list of registered forwarded IRQs. The reference
>>>> counter of the device is incremented each time a new IRQ is forwarded.
>>>> Reference counter is decremented when the IRQ forwarding is unset.
>>>>
>>>> The forwarding programmming is architecture specific, implemented in
>>>> kvm_arch_set_fwd_state function. Architecture specific implementation is
>>>> enabled when __KVM_HAVE_ARCH_KVM_VFIO_FORWARD is set. When not set those
>>>> functions are void.
>>>>
>>>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>>>>
>>>> ---
>>>>
>>>> v2 -> v3:
>>>> - add API comments in kvm_host.h
>>>> - improve the commit message
>>>> - create a private kvm_vfio_fwd_irq struct
>>>> - fwd_irq_action replaced by a bool and removal of VFIO_IRQ_CLEANUP. This
>>>>   latter action will be handled in vgic.
>>>> - add a vfio_device handle argument to kvm_arch_set_fwd_state. The goal is
>>>>   to move platform specific stuff in architecture specific code.
>>>> - kvm_arch_set_fwd_state renamed into kvm_arch_vfio_set_forward
>>>> - increment the ref counter each time we do an IRQ forwarding and decrement
>>>>   this latter each time one IRQ forward is unset. Simplifies the whole
>>>>   ref counting.
>>>> - simplification of list handling: create, search, removal
>>>>
>>>> v1 -> v2:
>>>> - __KVM_HAVE_ARCH_KVM_VFIO renamed into __KVM_HAVE_ARCH_KVM_VFIO_FORWARD
>>>> - original patch file separated into 2 parts: generic part moved in vfio.c
>>>>   and ARM specific part(kvm_arch_set_fwd_state)
>>>> ---
>>>>  include/linux/kvm_host.h |  28 ++++++
>>>>  virt/kvm/vfio.c          | 249 ++++++++++++++++++++++++++++++++++++++++++++++-
>>>>  2 files changed, 274 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>>>> index ea53b04..0b9659d 100644
>>>> --- a/include/linux/kvm_host.h
>>>> +++ b/include/linux/kvm_host.h
>>>> @@ -1076,6 +1076,15 @@ struct kvm_device_ops {
>>>>  		      unsigned long arg);
>>>>  };
>>>>  
>>>> +/* internal self-contained structure describing a forwarded IRQ */
>>>> +struct kvm_fwd_irq {
>>>> +	struct kvm *kvm; /* VM to inject the GSI into */
>>>> +	struct vfio_device *vdev; /* vfio device the IRQ belongs to */
>>>> +	__u32 index; /* VFIO device IRQ index */
>>>> +	__u32 subindex; /* VFIO device IRQ subindex */
>>>> +	__u32 gsi; /* gsi, ie. virtual IRQ number */
>>>> +};
>>>> +
>>>>  void kvm_device_get(struct kvm_device *dev);
>>>>  void kvm_device_put(struct kvm_device *dev);
>>>>  struct kvm_device *kvm_device_from_filp(struct file *filp);
>>>> @@ -1085,6 +1094,25 @@ void kvm_unregister_device_ops(u32 type);
>>>>  extern struct kvm_device_ops kvm_mpic_ops;
>>>>  extern struct kvm_device_ops kvm_xics_ops;
>>>>  
>>>> +#ifdef __KVM_HAVE_ARCH_KVM_VFIO_FORWARD
>>>> +/**
>>>> + * kvm_arch_vfio_set_forward - changes the forwarded state of an IRQ
>>>> + *
>>>> + * @fwd_irq: handle to the forwarded irq struct
>>>> + * @forward: true means forwarded, false means not forwarded
>>>> + * returns 0 on success, < 0 on failure
>>>> + */
>>>> +int kvm_arch_vfio_set_forward(struct kvm_fwd_irq *fwd_irq,
>>>> +			      bool forward);
>>>
>>> We could add a struct device* to the args list or into struct
>>> kvm_fwd_irq so that arch code doesn't need to touch the vdev.  arch code
>>> has no business dealing with references to the vfio_device.
>> Hi Alex,
>>
>> Currently It can't put struct device* into the kvm_fwd_irq struct since
>> I need to release the vfio_device with
>> vfio_device_put_external_user(struct vfio_device *vdev)
>> typically in kvm_vfio_clean_fwd_irq. So I need to store the pointers to
>> the vfio_device somewhere.
>>
>> I see 2 solutions: change the proto of
>> vfio_device_put_external_user(struct vfio_device *vdev) and pass a
>> struct device* (??)
>>
>> or change the proto of kvm_arch_vfio_set_forward into
>>
>> kvm_arch_vfio_set_forward(struct kvm *kvm, struct device *dev, int
>> index, [int subindex], int gsi, bool forward) or using index/start/count
>> but loosing the interest of having a self-contained internal struct.
> 
> The latter is sort of what I was assuming, I think the interface between
> VFIO and KVM-VFIO is good, we just don't need to expose VFIO-isms out to
> the arch KVM code.  KVM-VFIO should be the barrier layer.  In that
> spirit, maybe it should be kvm_arch_set_forward() and the KVM-VFIO code
> should do the processing of index/subindex sort of like how Feng did for
> PCI devices.

Hi Alex,

In Feng's series, host irq is retrieved in the generic part while in
mine it is retrieved in arch specific part, as encouraged at some point.
>From the above comment I understand the right API between generic and
arch specific parts may be <operation>(kvm, host_irq, guest_irq) in
which case I should revert the platform specific IRQ retrieval in the
generic part. Is it the correct understanding?

Thanks

Eric
> 
>>>
>>>> +
>>>> +#else
>>>> +static inline int kvm_arch_vfio_set_forward(struct kvm_fwd_irq *fwd_irq,
>>>> +					    bool forward)
>>>> +{
>>>> +	return 0;
>>>> +}
>>>> +#endif
>>>> +
>>>>  #ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
>>>>  
>>>>  static inline void kvm_vcpu_set_in_spin_loop(struct kvm_vcpu *vcpu, bool val)
>>>> diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
>>>> index 6f0cc34..af178bb 100644
>>>> --- a/virt/kvm/vfio.c
>>>> +++ b/virt/kvm/vfio.c
>>>> @@ -25,8 +25,16 @@ struct kvm_vfio_group {
>>>>  	struct vfio_group *vfio_group;
>>>>  };
>>>>  
>>>> +/* private linkable kvm_fwd_irq struct */
>>>> +struct kvm_vfio_fwd_irq_node {
>>>> +	struct list_head link;
>>>> +	struct kvm_fwd_irq fwd_irq;
>>>> +};
>>>> +
>>>>  struct kvm_vfio {
>>>>  	struct list_head group_list;
>>>> +	/* list of registered VFIO forwarded IRQs */
>>>> +	struct list_head fwd_node_list;
>>>>  	struct mutex lock;
>>>>  	bool noncoherent;
>>>>  };
>>>> @@ -247,12 +255,239 @@ static int kvm_vfio_set_group(struct kvm_device *dev, long attr, u64 arg)
>>>>  	return -ENXIO;
>>>>  }
>>>>  
>>>> +/**
>>>> + * kvm_vfio_get_vfio_device - Returns a handle to a vfio-device
>>>> + *
>>>> + * Checks it is a valid vfio device and increments its reference counter
>>>> + * @fd: file descriptor of the vfio platform device
>>>> + */
>>>> +static struct vfio_device *kvm_vfio_get_vfio_device(int fd)
>>>> +{
>>>> +	struct fd f = fdget(fd);
>>>> +	struct vfio_device *vdev;
>>>> +
>>>> +	if (!f.file)
>>>> +		return NULL;
>>>
>>> ERR_PTR(-EINVAL)?
>>>
>>> ie. propagate errors from the point where they're encountered so we
>>> don't need to make up an errno later.
>> yes thanks
>>>
>>>> +	vdev = kvm_vfio_device_get_external_user(f.file);
>>>> +	fdput(f);
>>>> +	return vdev;
>>>> +}
>>>> +
>>>> +/**
>>>> + * kvm_vfio_put_vfio_device: decrements the reference counter of the
>>>> + * vfio platform * device
>>>> + *
>>>> + * @vdev: vfio_device handle to release
>>>> + */
>>>> +static void kvm_vfio_put_vfio_device(struct vfio_device *vdev)
>>>> +{
>>>> +	kvm_vfio_device_put_external_user(vdev);
>>>> +}
>>>> +
>>>> +/**
>>>> + * kvm_vfio_find_fwd_irq - checks whether a forwarded IRQ already is
>>>> + * registered in the list of forwarded IRQs
>>>> + *
>>>> + * @kv: handle to the kvm-vfio device
>>>> + * @fwd: handle to the forwarded irq struct
>>>> + * In the positive returns the handle to its node in the kvm-vfio
>>>> + * forwarded IRQ list, returns NULL otherwise.
>>>> + * Must be called with kv->lock hold.
>>>> + */
>>>> +static struct kvm_vfio_fwd_irq_node *kvm_vfio_find_fwd_irq(
>>>> +				struct kvm_vfio *kv,
>>>> +				struct kvm_fwd_irq *fwd)
>>>> +{
>>>> +	struct kvm_vfio_fwd_irq_node *node;
>>>> +
>>>> +	list_for_each_entry(node, &kv->fwd_node_list, link) {
>>>> +		if ((node->fwd_irq.index == fwd->index) &&
>>>> +		    (node->fwd_irq.subindex == fwd->subindex) &&
>>>> +		    (node->fwd_irq.vdev == fwd->vdev))
>>>> +			return node;
>>>> +	}
>>>> +	return NULL;
>>>> +}
>>>> +/**
>>>> + * kvm_vfio_register_fwd_irq - Allocates, populates and registers a
>>>> + * forwarded IRQ
>>>> + *
>>>> + * @kv: handle to the kvm-vfio device
>>>> + * @fwd: handle to the forwarded irq struct
>>>> + * In case of success returns a handle to the new list node,
>>>> + * NULL otherwise.
>>>> + * Must be called with kv->lock hold.
>>>> + */
>>>> +static struct kvm_vfio_fwd_irq_node *kvm_vfio_register_fwd_irq(
>>>> +				struct kvm_vfio *kv,
>>>> +				struct kvm_fwd_irq *fwd)
>>>> +{
>>>> +	struct kvm_vfio_fwd_irq_node *node;
>>>> +
>>>> +	node = kmalloc(sizeof(*node), GFP_KERNEL);
>>>> +	if (!node)
>>>> +		return NULL;
>>>
>>> ERR_PTR(-ENOMEM)?
>>>
>> OK
>>>> +
>>>> +	node->fwd_irq = *fwd;
>>>> +
>>>> +	list_add(&node->link, &kv->fwd_node_list);
>>>> +
>>>> +	return node;
>>>> +}
>>>> +
>>>> +/**
>>>> + * kvm_vfio_unregister_fwd_irq - unregisters and frees a forwarded IRQ
>>>> + *
>>>> + * @node: handle to the node struct
>>>> + * Must be called with kv->lock hold.
>>>> + */
>>>> +static void kvm_vfio_unregister_fwd_irq(struct kvm_vfio_fwd_irq_node *node)
>>>> +{
>>>> +	list_del(&node->link);
>>>> +	kfree(node);
>>>> +}
>>>> +
>>>> +/**
>>>> + * kvm_vfio_set_forward - turns a VFIO device IRQ into a forwarded IRQ
>>>> + * @kv: handle to the kvm-vfio device
>>>> + * @fd: file descriptor of the vfio device the IRQ belongs to
>>>> + * @fwd: handle to the forwarded irq struct
>>>> + *
>>>> + * Registers an IRQ as forwarded and calls the architecture specific
>>>> + * implementation of set_forward. In case of operation failure, the IRQ
>>>> + * is unregistered. In case of success, the vfio device ref counter is
>>>> + * incremented.
>>>> + */
>>>> +static int kvm_vfio_set_forward(struct kvm_vfio *kv, int fd,
>>>> +				struct kvm_fwd_irq *fwd)
>>>> +{
>>>> +	int ret;
>>>> +	struct kvm_vfio_fwd_irq_node *node =
>>>> +			kvm_vfio_find_fwd_irq(kv, fwd);
>>>> +
>>>> +	if (node)
>>>> +		return -EINVAL;
>>>
>>> I assume you're saving -EBUSY for arch code for the case where the IRQ
>>> is already active?
>> yes. -EBUSY now corresponds to the case where the VFIO signaling is
>> already setup.
>>>
>>>> +	node = kvm_vfio_register_fwd_irq(kv, fwd);
>>>> +	if (!node)
>>>> +		return -ENOMEM;
>>>
>>> if (IS_ERR(node))
>>> 	return PTR_ERR(node);
>>>
>>>> +	ret = kvm_arch_vfio_set_forward(fwd, true);
>>>> +	if (ret < 0)  {
>>>> +		kvm_vfio_unregister_fwd_irq(node);
>>>> +		return ret;
>>>> +	}
>>>> +	/* increment the ref counter */
>>>> +	kvm_vfio_get_vfio_device(fd);
>>>
>>> Wouldn't it be easier if the reference counting were coupled with the
>>> register/unregister_fwd_irq?
>> ok
>>   I'd be tempted to pass your user_fwd_irq
>>> to this function instead of a kvm_fwd_irq.
>> Well in that case I would use kvm_arch_forwarded_irq for both set and
>> unset. Then comes the problem of kvm_vfio_clean_fwd_irq which
>> manipulates only internal structs.
>>
>>>> +	return ret;
>>>> +}
>>>> +
>>>> +/**
>>>> + * kvm_vfio_unset_forward - Sets a VFIO device IRQ as non forwarded
>>>> + * @kv: handle to the kvm-vfio device
>>>> + * @fwd: handle to the forwarded irq struct
>>>> + *
>>>> + * Calls the architecture specific implementation of set_forward and
>>>> + * unregisters the IRQ from the forwarded IRQ list. Decrements the vfio
>>>> + * device reference counter.
>>>> + */
>>>> +static int kvm_vfio_unset_forward(struct kvm_vfio *kv,
>>>> +				  struct kvm_fwd_irq *fwd)
>>>> +{
>>>> +	int ret;
>>>> +	struct kvm_vfio_fwd_irq_node *node =
>>>> +			kvm_vfio_find_fwd_irq(kv, fwd);
>>>> +	if (!node)
>>>> +		return -EINVAL;
>>>> +	ret = kvm_arch_vfio_set_forward(fwd, false);
>>>
>>> Whoa, if the unforward fails we continue to undo everything else?  How
>>> does userspace cleanup from this?  We need a guaranteed shutdown path
>>> for cleanup code, we can never trust userspace to do things in the
>>> correct order.  Can we really preclude the user calling unforward with
>>> an active IRQ?  Maybe _forward() and _unforward() need to be separate
>>> functions so that 'un' can be made void to indicate it can't fail.
>> If I accept an unforward while the VFIO signaling mechanism is set, the
>> wrong handler will be setup on VFIO driver. So should I put in place a
>> mechanism that changes the VFIO handler for that irq (causing VFIO
>> driver free_irq/request_irq), using another external API function?
> 
> Yep, it seems like we need to re-evaluate whether forwarding can be
> changed on a running IRQ.  Disallowing it doesn't appear to support KVM
> initiated shutdown, only user initiated configuration.  So the
> vfio-platform interrupt handler probably needs to be bi-modal.  Maybe
> the forwarding state of the IRQ can use RCU to avoid locks.
> 
>>>> +	kvm_vfio_unregister_fwd_irq(node);
>>>> +
>>>> +	/* decrement the ref counter */
>>>> +	kvm_vfio_put_vfio_device(fwd->vdev);
>>>
>>> Again, seems like the unregister should do this.
>> ok
>>>
>>>> +	return ret;
>>>> +}
>>>> +
>>>> +static int kvm_vfio_control_irq_forward(struct kvm_device *kdev, long attr,
>>>> +					int32_t __user *argp)
>>>> +{
>>>> +	struct kvm_arch_forwarded_irq user_fwd_irq;
>>>> +	struct kvm_fwd_irq fwd;
>>>> +	struct vfio_device *vdev;
>>>> +	struct kvm_vfio *kv = kdev->private;
>>>> +	int ret;
>>>> +
>>>> +	if (copy_from_user(&user_fwd_irq, argp, sizeof(user_fwd_irq)))
>>>> +		return -EFAULT;
>>>> +
>>>> +	vdev = kvm_vfio_get_vfio_device(user_fwd_irq.fd);
>>>> +	if (IS_ERR(vdev)) {
>>>> +		ret = PTR_ERR(vdev);
>>>> +		goto out;
>>>> +	}
>>>> +
>>>> +	fwd.vdev =  vdev;
>>>> +	fwd.kvm =  kdev->kvm;
>>>> +	fwd.index = user_fwd_irq.index;
>>>> +	fwd.subindex = user_fwd_irq.subindex;
>>>> +	fwd.gsi = user_fwd_irq.gsi;
>>>> +
>>>> +	switch (attr) {
>>>> +	case KVM_DEV_VFIO_DEVICE_FORWARD_IRQ:
>>>> +		mutex_lock(&kv->lock);
>>>> +		ret = kvm_vfio_set_forward(kv, user_fwd_irq.fd, &fwd);
>>>> +		mutex_unlock(&kv->lock);
>>>> +		break;
>>>> +	case KVM_DEV_VFIO_DEVICE_UNFORWARD_IRQ:
>>>> +		mutex_lock(&kv->lock);
>>>> +		ret = kvm_vfio_unset_forward(kv, &fwd);
>>>> +		mutex_unlock(&kv->lock);
>>>> +		break;
>>>> +	}
>>>> +out:
>>>> +	kvm_vfio_put_vfio_device(vdev);
>>>
>>> It might add a little extra code, but logically the reference being tied
>>> to the register/unregister feels a bit cleaner than this.
>> Sorry I do not catch your comment here. Since i called
>> kvm_vfio_get_vfio_device at the beg of the function, I need to release
>> at the end of the function, besides the ref counter incr/decr at
>> registration?
> 
> If we do reference counting on register/unregister, I'd think that the
> get/put in this function would go away.  Having the reference here seems
> redundant.
> 
>>>
>>>> +	return ret;
>>>> +}
>>>> +
>>>> +static int kvm_vfio_set_device(struct kvm_device *kdev, long attr, u64 arg)
>>>> +{
>>>> +	int32_t __user *argp = (int32_t __user *)(unsigned long)arg;
>>>> +	int ret;
>>>> +
>>>> +	switch (attr) {
>>>> +	case KVM_DEV_VFIO_DEVICE_FORWARD_IRQ:
>>>> +	case KVM_DEV_VFIO_DEVICE_UNFORWARD_IRQ:
>>>> +		ret = kvm_vfio_control_irq_forward(kdev, attr, argp);
>>>> +		break;
>>>> +	default:
>>>> +		ret = -ENXIO;
>>>> +	}
>>>> +	return ret;
>>>> +}
>>>> +
>>>> +/**
>>>> + * kvm_vfio_clean_fwd_irq - Unset forwarding state of all
>>>> + * registered forwarded IRQs and free their list nodes.
>>>> + * @kv: kvm-vfio device
>>>> + *
>>>> + * Loop on all registered device/IRQ combos, reset the non forwarded state,
>>>> + * void the lists and release the reference
>>>> + */
>>>> +static int kvm_vfio_clean_fwd_irq(struct kvm_vfio *kv)
>>>> +{
>>>> +	struct kvm_vfio_fwd_irq_node *node, *tmp;
>>>> +
>>>> +	list_for_each_entry_safe(node, tmp, &kv->fwd_node_list, link) {
>>>> +		kvm_vfio_unset_forward(kv, &node->fwd_irq);
>>>> +	}
>>>> +	return 0;
>>>
>>> This shouldn't be able to fail, make it void.
>> see above questioning? But you're right, I am too much virtualization
>> oriented. Currently my cleanup is even done in the virtual interrupt
>> controller when the VM dies because nobody unsets the VFIO signaling.
> 
> Yep, being a kernel interface it needs to be hardened against careless
> and malicious users.  The kernel should return to the correct state if
> we kill -9 QEMU at any point.  Thanks,
> 
> Alex
> 

