Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab3I2Nwj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 09:52:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671Ab3I2Nwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 09:52:35 -0400
Message-ID: <1380462748.2674.57.camel@ul30vt.home>
Subject: Re: [RFC PATCH 3/3] kvm: Add VFIO device for handling IOMMU cache
 coherency
From: Alex Williamson <alex.williamson@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: kvm@vger.kernel.org, aik@ozlabs.ru, benh@kernel.crashing.org,
        bsd@redhat.com, linux-kernel@vger.kernel.org, mst@redhat.com
Date: Sun, 29 Sep 2013 07:52:28 -0600
In-Reply-To: <20130929131627.GU17294@redhat.com>
References: <20130912211401.8542.82932.stgit@bling.home>
	 <20130912212314.8542.9692.stgit@bling.home>
	 <20130929131627.GU17294@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-09-29 at 16:16 +0300, Gleb Natapov wrote:
> On Thu, Sep 12, 2013 at 03:23:15PM -0600, Alex Williamson wrote:
> > So far we've succeeded at making KVM and VFIO mostly unaware of each
> > other, but there's any important point where that breaks down.  Intel
> > VT-d hardware may or may not support snoop control.  When snoop
> > control is available, intel-iommu promotes No-Snoop transactions on
> > PCIe to be cache coherent.  That allows KVM to handle things like the
> > x86 WBINVD opcode as a nop.  When the hardware does not support this,
> > KVM must implement a hardware visible WBINVD for the guest.
> > 
> > We could simply let userspace tell KVM how to handle WBINVD, but it's
> > privileged for a reason.  Allowing an arbitrary user to enable
> > physical WBINVD gives them a more access to the hardware.  Previously,
> > this has only been enabled for guests supporting legacy PCI device
> > assignment.  In such cases it's necessary for proper guest execution.
> > We therefore create a new KVM-VFIO virtual device.  The user can add
> > and remove VFIO groups to this device via file descriptors.  KVM
> > makes use of the VFIO external user interface to validate that the
> > user has access to physical hardware and gets the coherency state of
> > the IOMMU from VFIO.  This provides equivalent functionality to
> > legacy KVM assignment, while keeping (nearly) all the bits isolated.
> > 
> Looks good overall to me, one things though: to use legacy device
> assignment one needs root permission, so only root user can enable
> WBINVD emulation.

That's not entirely accurate, legacy device assignment can be used by a
non-root user, libvirt does this all the time.  The part that requires
root access is opening the pci-sysfs config file, the rest can be
managed via file permissions on the remaining sysfs files.

>  Who does this permission checking here? Is only root
> allowed to create non coherent group with vfio?

With vfio the user is granted permission by giving them access to the
vfio group file (/dev/vfio/$GROUP) and binding all the devices in the
group to vfio.  That enables the user to create a container (~iommu
domain) with the group attached to it.  Only then will the vfio external
user interface provide a reference to the group and enable this wbinvd
support.  So, wbinvd emulation should only be available to a user that
"own" a vfio group and has it configured for use with this interface.
Thanks,

Alex

> > The one intrusion is the resulting flag indicating the coherency
> > state.  For this RFC it's placed on the x86 kvm_arch struct, however
> > I know POWER has interest in using the VFIO external user interface,
> > and I'm hoping we can share a common KVM-VFIO device.  Perhaps they
> > care about No-Snoop handling as well or the code can be #ifdef'd.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> >  Documentation/virtual/kvm/devices/vfio.txt |   22 +++
> >  arch/x86/include/asm/kvm_host.h            |    1 
> >  arch/x86/kvm/Makefile                      |    2 
> >  arch/x86/kvm/vmx.c                         |    5 -
> >  arch/x86/kvm/x86.c                         |    5 -
> >  include/linux/kvm_host.h                   |    1 
> >  include/uapi/linux/kvm.h                   |    4 
> >  virt/kvm/kvm_main.c                        |    3 
> >  virt/kvm/vfio.c                            |  237 ++++++++++++++++++++++++++++
> >  9 files changed, 275 insertions(+), 5 deletions(-)
> >  create mode 100644 Documentation/virtual/kvm/devices/vfio.txt
> >  create mode 100644 virt/kvm/vfio.c
> > 
> > diff --git a/Documentation/virtual/kvm/devices/vfio.txt b/Documentation/virtual/kvm/devices/vfio.txt
> > new file mode 100644
> > index 0000000..831e6a6
> > --- /dev/null
> > +++ b/Documentation/virtual/kvm/devices/vfio.txt
> > @@ -0,0 +1,22 @@
> > +VFIO virtual device
> > +===================
> > +
> > +Device types supported:
> > +  KVM_DEV_TYPE_VFIO
> > +
> > +Only one VFIO instance may be created per VM.  The created device
> > +tracks VFIO groups in use by the VM and features of those groups
> > +important to the correctness and acceleration of the VM.  As groups
> > +are enabled and disabled for use by the VM, KVM should be updated
> > +about their presence.  When registered with KVM, a reference to the
> > +VFIO-group is held by KVM.
> > +
> > +Groups:
> > +  KVM_DEV_VFIO_ADD_GROUP
> > +  KVM_DEV_VFIO_DEL_GROUP
> > +
> > +Each takes a int32_t file descriptor for kvm_device_attr.addr and
> > +does not support any group device kvm_device_attr.attr.
> > +
> > +RFC - Should we use Group KVM_DEV_VFIO_GROUP with Attributes
> > +      KVM_DEV_VFIO_GROUP_ADD & DEL?
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index c76ff74..5b9350d 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -588,6 +588,7 @@ struct kvm_arch {
> >  
> >  	spinlock_t pvclock_gtod_sync_lock;
> >  	bool use_master_clock;
> > +	bool vfio_noncoherent;
> >  	u64 master_kernel_ns;
> >  	cycle_t master_cycle_now;
> >  
> > diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> > index bf4fb04..25d22b2 100644
> > --- a/arch/x86/kvm/Makefile
> > +++ b/arch/x86/kvm/Makefile
> > @@ -9,7 +9,7 @@ KVM := ../../../virt/kvm
> >  
> >  kvm-y			+= $(KVM)/kvm_main.o $(KVM)/ioapic.o \
> >  				$(KVM)/coalesced_mmio.o $(KVM)/irq_comm.o \
> > -				$(KVM)/eventfd.o $(KVM)/irqchip.o
> > +				$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o
> >  kvm-$(CONFIG_KVM_DEVICE_ASSIGNMENT)	+= $(KVM)/assigned-dev.o $(KVM)/iommu.o
> >  kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
> >  
> > diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> > index 1f1da43..94f7786 100644
> > --- a/arch/x86/kvm/vmx.c
> > +++ b/arch/x86/kvm/vmx.c
> > @@ -7395,8 +7395,9 @@ static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> >  	 */
> >  	if (is_mmio)
> >  		ret = MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;
> > -	else if (vcpu->kvm->arch.iommu_domain &&
> > -		!(vcpu->kvm->arch.iommu_flags & KVM_IOMMU_CACHE_COHERENCY))
> > +	else if (vcpu->kvm->arch.vfio_noncoherent ||
> > +		 vcpu->kvm->arch.iommu_domain &&
> > +		 !(vcpu->kvm->arch.iommu_flags & KVM_IOMMU_CACHE_COHERENCY))
> >  		ret = kvm_get_guest_memory_type(vcpu, gfn) <<
> >  		      VMX_EPT_MT_EPTE_SHIFT;
> >  	else
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index e5ca72a..406ba6f 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -2715,8 +2715,9 @@ static void wbinvd_ipi(void *garbage)
> >  
> >  static bool need_emulate_wbinvd(struct kvm_vcpu *vcpu)
> >  {
> > -	return vcpu->kvm->arch.iommu_domain &&
> > -		!(vcpu->kvm->arch.iommu_flags & KVM_IOMMU_CACHE_COHERENCY);
> > +	return vcpu->kvm->arch.vfio_noncoherent ||
> > +	       (vcpu->kvm->arch.iommu_domain &&
> > +		!(vcpu->kvm->arch.iommu_flags & KVM_IOMMU_CACHE_COHERENCY));
> >  }
> >  
> >  void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index ca645a0..615f0c3 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -1065,6 +1065,7 @@ struct kvm_device *kvm_device_from_filp(struct file *filp);
> >  
> >  extern struct kvm_device_ops kvm_mpic_ops;
> >  extern struct kvm_device_ops kvm_xics_ops;
> > +extern struct kvm_device_ops kvm_vfio_ops;
> >  
> >  #ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
> >  
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index 99c2533..8869616 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -843,6 +843,10 @@ struct kvm_device_attr {
> >  #define KVM_DEV_TYPE_FSL_MPIC_20	1
> >  #define KVM_DEV_TYPE_FSL_MPIC_42	2
> >  #define KVM_DEV_TYPE_XICS		3
> > +#define KVM_DEV_TYPE_VFIO		4
> > +
> > +#define KVM_DEV_VFIO_ADD_GROUP		1
> > +#define KVM_DEV_VFIO_DEL_GROUP		2
> >  
> >  /*
> >   * ioctls for VM fds
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index d9cad4d..1a20425 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -2269,6 +2269,9 @@ static int kvm_ioctl_create_device(struct kvm *kvm,
> >  		ops = &kvm_xics_ops;
> >  		break;
> >  #endif
> > +	case KVM_DEV_TYPE_VFIO:
> > +		ops = &kvm_vfio_ops;
> > +		break;
> >  	default:
> >  		return -ENODEV;
> >  	}
> > diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
> > new file mode 100644
> > index 0000000..9a2faff
> > --- /dev/null
> > +++ b/virt/kvm/vfio.c
> > @@ -0,0 +1,237 @@
> > +/*
> > + * VFIO bridge
> > + *
> > + * Copyright (C) 2013 Red Hat, Inc.  All rights reserved.
> > + *     Author: Alex Williamson <alex.williamson@redhat.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +#include <linux/errno.h>
> > +#include <linux/file.h>
> > +#include <linux/kvm_host.h>
> > +#include <linux/list.h>
> > +#include <linux/module.h>
> > +#include <linux/mutex.h>
> > +#include <linux/slab.h>
> > +#include <linux/vfio.h>
> > +
> > +struct kvm_vfio_group {
> > +	struct list_head node;
> > +	struct vfio_group *vfio_group;
> > +};
> > +
> > +struct kvm_vfio {
> > +	struct list_head group_list;
> > +	struct mutex lock;
> > +};
> > +
> > +static struct vfio_group *kvm_vfio_group_get_external_user(struct file *filep)
> > +{
> > +	struct vfio_group *vfio_group;
> > +	struct vfio_group *(*fn)(struct file *);
> > +
> > +	fn = symbol_get(vfio_group_get_external_user);
> > +	if (!fn)
> > +		return ERR_PTR(-EINVAL);
> > +
> > +	vfio_group = fn(filep);
> > +
> > +	symbol_put(vfio_group_get_external_user);
> > +
> > +	return vfio_group;
> > +}
> > +
> > +static void kvm_vfio_group_put_external_user(struct vfio_group *vfio_group)
> > +{
> > +	void (*fn)(struct vfio_group *);
> > +
> > +	fn = symbol_get(vfio_group_put_external_user);
> > +	if (!fn)
> > +		return;
> > +
> > +	fn(vfio_group);
> > +
> > +	symbol_put(vfio_group_put_external_user);
> > +}
> > +
> > +static int kvm_vfio_external_user_check_extension(struct vfio_group *vfio_group,
> > +						  unsigned long arg)
> > +{
> > +	int (*fn)(struct vfio_group *, unsigned long);
> > +	int ret;
> > +
> > +	fn = symbol_get(vfio_external_user_check_extension);
> > +	if (!fn)
> > +		return -EINVAL;
> > +
> > +	ret = fn(vfio_group, arg);
> > +
> > +	symbol_put(vfio_group_put_external_user);
> > +
> > +	return ret;
> > +}
> > +
> > +static void kvm_vfio_update_iommu_coherency(struct kvm_device *dev)
> > +{
> > +	struct kvm_vfio *kv = dev->private;
> > +	bool coherent = true;
> > +	struct kvm_vfio_group *kvg;
> > +
> > +	mutex_lock(&kv->lock);
> > +
> > +	list_for_each_entry(kvg, &kv->group_list, node) {
> > +		if (!kvm_vfio_external_user_check_extension(kvg->vfio_group,
> > +					VFIO_IOMMU_CAP_CACHE_COHERENCY)) {
> > +			coherent = false;
> > +			break;
> > +		}
> > +	}
> > +
> > +	mutex_unlock(&kv->lock);
> > +
> > +	dev->kvm->arch.vfio_noncoherent = !coherent;
> > +}
> > +
> > +static int kvm_vfio_set_attr(struct kvm_device *dev,
> > +			     struct kvm_device_attr *attr)
> > +{
> > +	struct kvm_vfio *kv = dev->private;
> > +	struct fd f;
> > +	struct vfio_group *vfio_group;
> > +	struct kvm_vfio_group *kvg;
> > +	int ret;
> > +
> > +	switch (attr->group) {
> > +	case KVM_DEV_VFIO_ADD_GROUP:
> > +		f = fdget(attr->addr);
> > +		if (!f.file)
> > +			return -EBADF;
> > +
> > +		vfio_group = kvm_vfio_group_get_external_user(f.file);
> > +		fdput(f);
> > +
> > +		if (IS_ERR(vfio_group))
> > +			return PTR_ERR(vfio_group);
> > +
> > +		mutex_lock(&kv->lock);
> > +
> > +		list_for_each_entry(kvg, &kv->group_list, node) {
> > +			if (kvg->vfio_group == vfio_group) {
> > +				mutex_unlock(&kv->lock);
> > +				kvm_vfio_group_put_external_user(vfio_group);
> > +				return -EEXIST;
> > +			}
> > +		}
> > +
> > +		kvg = kzalloc(sizeof(*kvg), GFP_KERNEL);
> > +		if (!kvg) {
> > +			mutex_unlock(&kv->lock);
> > +			kvm_vfio_group_put_external_user(vfio_group);
> > +			return -ENOMEM;
> > +		}
> > +
> > +		list_add_tail(&kvg->node, &kv->group_list);
> > +		kvg->vfio_group = vfio_group;
> > +
> > +		mutex_unlock(&kv->lock);
> > +
> > +		kvm_vfio_update_iommu_coherency(dev);
> > +
> > +		return 0;
> > +
> > +	case KVM_DEV_VFIO_DEL_GROUP:
> > +		f = fdget(attr->addr);
> > +		if (!f.file)
> > +			return -EBADF;
> > +
> > +		vfio_group = kvm_vfio_group_get_external_user(f.file);
> > +		fdput(f);
> > +
> > +		if (IS_ERR(vfio_group))
> > +			return PTR_ERR(vfio_group);
> > +
> > +		ret = -ENOENT;
> > +
> > +		mutex_lock(&kv->lock);
> > +
> > +		list_for_each_entry(kvg, &kv->group_list, node) {
> > +			if (kvg->vfio_group != vfio_group)
> > +				continue;
> > +
> > +			list_del(&kvg->node);
> > +			kvm_vfio_group_put_external_user(kvg->vfio_group);
> > +			kfree(kvg);
> > +			ret = 0;
> > +			break;
> > +		}
> > +
> > +		mutex_unlock(&kv->lock);
> > +		kvm_vfio_group_put_external_user(vfio_group);
> > +
> > +		kvm_vfio_update_iommu_coherency(dev);
> > +
> > +		return ret;
> > +	}
> > +
> > +	return -ENXIO;
> > +}
> > +
> > +static int kvm_vfio_has_attr(struct kvm_device *dev,
> > +				   struct kvm_device_attr *attr)
> > +{
> > +	switch (attr->group) {
> > +	case KVM_DEV_VFIO_ADD_GROUP:
> > +	case KVM_DEV_VFIO_DEL_GROUP:
> > +		return 0;
> > +	}
> > +
> > +	return -ENXIO;
> > +}
> > +
> > +static void kvm_vfio_destroy(struct kvm_device *dev)
> > +{
> > +	struct kvm_vfio *kv = dev->private;
> > +	struct kvm_vfio_group *kvg, *tmp;
> > +
> > +	list_for_each_entry_safe(kvg, tmp, &kv->group_list, node) {
> > +		kvm_vfio_group_put_external_user(kvg->vfio_group);
> > +		list_del(&kvg->node);
> > +		kfree(kvg);
> > +	}
> > +
> > +	dev->kvm->arch.vfio_noncoherent = false;
> > +	kfree(kv);
> > +}
> > +
> > +static int kvm_vfio_create(struct kvm_device *dev, u32 type)
> > +{
> > +	struct kvm_device *tmp;
> > +	struct kvm_vfio *kv;
> > +
> > +	/* Only one VFIO "device" per VM */
> > +	list_for_each_entry(tmp, &dev->kvm->devices, vm_node)
> > +		if (tmp->ops == &kvm_vfio_ops)
> > +			return -EBUSY;
> > +
> > +	kv = kzalloc(sizeof(*kv), GFP_KERNEL);
> > +	if (!kv)
> > +		return -ENOMEM;
> > +
> > +	INIT_LIST_HEAD(&kv->group_list);
> > +	mutex_init(&kv->lock);
> > +
> > +	dev->private = kv;
> > +
> > +	return 0;
> > +}
> > +
> > +struct kvm_device_ops kvm_vfio_ops = {
> > +	.name = "kvm-vfio",
> > +	.create = kvm_vfio_create,
> > +	.destroy = kvm_vfio_destroy,
> > +	.set_attr = kvm_vfio_set_attr,
> > +	.has_attr = kvm_vfio_has_attr,
> > +};
> 
> --
> 			Gleb.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



