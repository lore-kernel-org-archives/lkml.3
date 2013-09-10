Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab3IJMsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 08:48:52 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:54742 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab3IJMsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 08:48:50 -0400
Message-ID: <522F14F8.2000101@redhat.com>
Date: Tue, 10 Sep 2013 14:47:52 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Chris Metcalf <cmetcalf@tilera.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH v3 3/3] tile: enable VIRTIO support for KVM
References: <20130826120445.GD8218@redhat.com> <54dadfbf688618a900310d10363b9c395fa3d322.1377736306.git.cmetcalf@tilera.com>
In-Reply-To: <54dadfbf688618a900310d10363b9c395fa3d322.1377736306.git.cmetcalf@tilera.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 28/08/2013 22:58, Chris Metcalf ha scritto:
> This change enables support for a virtio-based console,
> network support, and block driver support.
> 
> We remove some debug code in relocate_kernel_64.S that made raw
> calls to the hv_console_putc Tilera hypervisor API, since everything
> now should funnel through the early_hv_write() API.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

Why couldn't this use the "regular" virtio-mmio interface?

> diff --git a/arch/tile/include/asm/kvm_virtio.h b/arch/tile/include/asm/kvm_virtio.h
> new file mode 100644
> index 0000000..8faa959
> --- /dev/null
> +++ b/arch/tile/include/asm/kvm_virtio.h
> @@ -0,0 +1,26 @@
> +/*
> + * Copyright 2013 Tilera Corporation. All Rights Reserved.
> + *
> + *   This program is free software; you can redistribute it and/or
> + *   modify it under the terms of the GNU General Public License
> + *   as published by the Free Software Foundation, version 2.
> + *
> + *   This program is distributed in the hope that it will be useful, but
> + *   WITHOUT ANY WARRANTY; without even the implied warranty of
> + *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
> + *   NON INFRINGEMENT.  See the GNU General Public License for
> + *   more details.
> + */
> +#ifndef _ASM_TILE_KVM_VIRTIO_H
> +#define _ASM_TILE_KVM_VIRTIO_H
> +
> +#include <uapi/asm/kvm_virtio.h>
> +
> +
> +struct kvm_device {
> +	struct virtio_device vdev;
> +	struct kvm_device_desc *desc;
> +	unsigned long desc_pa;
> +};
> +
> +#endif /* _ASM_TILE_KVM_VIRTIO_H */
> diff --git a/arch/tile/include/uapi/asm/Kbuild b/arch/tile/include/uapi/asm/Kbuild
> index 89022a5..f07cc24 100644
> --- a/arch/tile/include/uapi/asm/Kbuild
> +++ b/arch/tile/include/uapi/asm/Kbuild
> @@ -8,6 +8,7 @@ header-y += cachectl.h
>  header-y += hardwall.h
>  header-y += kvm.h
>  header-y += kvm_para.h
> +header-y += kvm_virtio.h
>  header-y += mman.h
>  header-y += ptrace.h
>  header-y += setup.h
> diff --git a/arch/tile/include/uapi/asm/kvm.h b/arch/tile/include/uapi/asm/kvm.h
> index aa7b97f..4346520 100644
> --- a/arch/tile/include/uapi/asm/kvm.h
> +++ b/arch/tile/include/uapi/asm/kvm.h
> @@ -149,6 +149,9 @@
>   */
>  #define KVM_OTHER_HCALL                  128
>  
> +/* Hypercall index for virtio. */
> +#define KVM_HCALL_virtio                 128
> +
>  /* One greater than the maximum hypercall number. */
>  #define KVM_NUM_HCALLS                   256
>  
> @@ -256,6 +259,8 @@ struct kvm_sync_regs {
>  	KVM_EMULATE(get_ipi_pte) \
>  	KVM_EMULATE(set_pte_super_shift) \
>  	KVM_EMULATE(set_speed) \
> +	/* For others */ \
> +	USER_HCALL(virtio)

Ah, here it is. :)

>  
>  #endif
>  
> diff --git a/arch/tile/include/uapi/asm/kvm_virtio.h b/arch/tile/include/uapi/asm/kvm_virtio.h
> new file mode 100644
> index 0000000..d94f535
> --- /dev/null
> +++ b/arch/tile/include/uapi/asm/kvm_virtio.h
> @@ -0,0 +1,60 @@
> +/*
> + * Copyright 2013 Tilera Corporation. All Rights Reserved.
> + *
> + *   This program is free software; you can redistribute it and/or
> + *   modify it under the terms of the GNU General Public License
> + *   as published by the Free Software Foundation, version 2.
> + *
> + *   This program is distributed in the hope that it will be useful, but
> + *   WITHOUT ANY WARRANTY; without even the implied warranty of
> + *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
> + *   NON INFRINGEMENT.  See the GNU General Public License for
> + *   more details.
> + */
> +
> +#ifndef _UAPI_ASM_TILE_KVM_VIRTIO_H
> +#define _UAPI_ASM_TILE_KVM_VIRTIO_H
> +
> +#include <linux/types.h>
> +
> +#define KVM_VIRTIO_UNKNOWN	0
> +#define KVM_VIRTIO_NOTIFY	1
> +#define KVM_VIRTIO_RESET	2
> +#define KVM_VIRTIO_SET_STATUS	3
> +
> +struct kvm_device_desc {
> +	/* The device type: console, network, disk etc.  Type 0 terminates. */
> +	__u8 type;
> +	/* The number of virtqueues (first in config array) */
> +	__u8 num_vq;
> +	/*
> +	 * The number of bytes of feature bits.  Multiply by 2: one for host
> +	 * features and one for Guest acknowledgements.
> +	 */
> +	__u8 feature_len;
> +	/* The number of bytes of the config array after virtqueues. */
> +	__u8 config_len;
> +	/* A status byte, written by the Guest. */
> +	__u8 status;
> +	__u64 config[0];
> +};
> +
> +struct kvm_vqinfo {
> +	/* Pointer to the information contained in the device config. */
> +	struct kvm_vqconfig *config;
> +	/* The address where we mapped the virtio ring, so we can unmap it. */
> +	void *pages;
> +};
> +
> +struct kvm_vqconfig {
> +	/* The physical address of the virtio ring */
> +	__u64 pa;
> +	/* The number of entries in the virtio_ring */
> +	__u64 num;
> +	/* The interrupt we get when something happens. Set by the guest. */
> +	__u32 irq;
> +
> +};
> +
> +
> +#endif /* _UAPI_ASM_TILE_KVM_VIRTIO_H */
> diff --git a/arch/tile/kernel/Makefile b/arch/tile/kernel/Makefile
> index b7c8b5e..b638d3e 100644
> --- a/arch/tile/kernel/Makefile
> +++ b/arch/tile/kernel/Makefile
> @@ -29,5 +29,6 @@ obj-$(CONFIG_TILE_USB)		+= usb.o
>  obj-$(CONFIG_TILE_HVGLUE_TRACE)	+= hvglue_trace.o
>  obj-$(CONFIG_FUNCTION_TRACER)	+= ftrace.o mcount_64.o
>  obj-$(CONFIG_KPROBES)		+= kprobes.o
> +obj-$(CONFIG_KVM_GUEST)		+= kvm_virtio.o
>  
>  obj-y				+= vdso/
> diff --git a/arch/tile/kernel/early_printk.c b/arch/tile/kernel/early_printk.c
> index b608e00..53f2be4 100644
> --- a/arch/tile/kernel/early_printk.c
> +++ b/arch/tile/kernel/early_printk.c
> @@ -18,11 +18,26 @@
>  #include <linux/string.h>
>  #include <linux/irqflags.h>
>  #include <linux/printk.h>
> +#ifdef CONFIG_KVM_GUEST
> +#include <linux/virtio_console.h>
> +#include <linux/kvm_para.h>
> +#include <asm/kvm_virtio.h>
> +#endif
>  #include <asm/setup.h>
>  #include <hv/hypervisor.h>
>  
>  static void early_hv_write(struct console *con, const char *s, unsigned n)
>  {
> +#ifdef CONFIG_KVM_GUEST
> +	char buf[512];
> +
> +	if (n > sizeof(buf) - 1)
> +		n = sizeof(buf) - 1;
> +	memcpy(buf, s, n);
> +	buf[n] = '\0';
> +
> +	hcall_virtio(KVM_VIRTIO_NOTIFY, __pa(buf));

How can userspace know the difference between KVM_VIRTIO_NOTIFY with a
string buffer, and KVM_VIRTIO_NOTIFY with a config space pointer?

In fact, this looks like a completely separate hypercall, why not keep
hv_console_putc?

> index 0000000..c6b6c6a
> --- /dev/null
> +++ b/arch/tile/kernel/kvm_virtio.c
> @@ -0,0 +1,430 @@
> +/*
> + * Copyright 2013 Tilera Corporation. All Rights Reserved.
> + *
> + *   This program is free software; you can redistribute it and/or
> + *   modify it under the terms of the GNU General Public License
> + *   as published by the Free Software Foundation, version 2.
> + *
> + *   This program is distributed in the hope that it will be useful, but
> + *   WITHOUT ANY WARRANTY; without even the implied warranty of
> + *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
> + *   NON INFRINGEMENT.  See the GNU General Public License for
> + *   more details.
> + */
> +
> +/* Referred lguest & s390 implemenation */
> +/*
> + * kvm_virtio.c - virtio for kvm on s390
> + *
> + * Copyright IBM Corp. 2008
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License (version 2 only)
> + * as published by the Free Software Foundation.
> + *
> + *    Author(s): Christian Borntraeger <borntraeger@de.ibm.com>
> + */

This has the same problem as the old s390 implementation (there is a new
one that emulates the usual s390 I/O instead of using
paravirtualization); it doesn't raise an interrupt on config space writes.

Apart from this it looks good, but I'm not sure why it is necessary.

> +#include <linux/bootmem.h>
> +#include <linux/io.h>
> +#include <linux/vmalloc.h>
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
> +#include <linux/export.h>
> +#include <linux/virtio.h>
> +#include <linux/virtio_config.h>
> +#include <linux/virtio_console.h>
> +#include <linux/virtio_ring.h>
> +#include <linux/virtio_pci.h>
> +
> +#include <linux/kvm_para.h>
> +#include <asm/kvm_virtio.h>
> +
> +static void *kvm_devices;
> +
> +/*
> + * TODO: We actually does not use PCI virtio here. We use this
> + * because qemu: virtqueue_init() uses VIRTIO_PCI_VRING_ALIGN.
> + * Maybe we should change them to generic definitions in both qemu & Linux.
> + * Besides, Let's check whether the alignment value (4096, i.e. default
> + * x86 page size) affects performance later.
> + */
> +#define KVM_TILE_VIRTIO_RING_ALIGN	VIRTIO_PCI_VRING_ALIGN
> +#define to_kvmdev(vd)	container_of(vd, struct kvm_device, vdev)
> +
> +/*
> + * memory layout: (Total: PAGE_SIZE)
> + * <device 0>
> + * - kvm device descriptor
> + *        struct kvm_device_desc
> + * - vqueue configuration (totally desc->num_vq)
> + *        struct kvm_vqconfig
> + *        ......
> + *        struct kvm_vqconfig
> + * - feature bits (size: desc->feature_len * 2)
> + * - config space (size: desc->config_len)
> + * <device 1>
> + * ......
> + */
> +static struct kvm_vqconfig *kvm_vq_config(const struct kvm_device_desc *desc)
> +{
> +	return (struct kvm_vqconfig *)(desc + 1);
> +}
> +
> +static u8 *kvm_vq_features(const struct kvm_device_desc *desc)
> +{
> +	return (u8 *)(kvm_vq_config(desc) + desc->num_vq);
> +}
> +
> +static u8 *kvm_vq_configspace(const struct kvm_device_desc *desc)
> +{
> +	return kvm_vq_features(desc) + desc->feature_len * 2;
> +}
> +
> +/*
> + * The total size of the config page used by this device (incl. desc)
> + */
> +static unsigned desc_size(const struct kvm_device_desc *desc)
> +{
> +	return sizeof(*desc)
> +		+ desc->num_vq * sizeof(struct kvm_vqconfig)
> +		+ desc->feature_len * 2
> +		+ desc->config_len;
> +}
> +
> +/* This gets the device's feature bits. */
> +static u32 kvm_get_features(struct virtio_device *vdev)
> +{
> +	unsigned int i;
> +	u32 features = 0;
> +	struct kvm_device_desc *desc = to_kvmdev(vdev)->desc;
> +	u8 *in_features = kvm_vq_features(desc);
> +
> +	for (i = 0; i < min(desc->feature_len * 8, 32); i++)
> +		if (in_features[i / 8] & (1 << (i % 8)))
> +			features |= (1 << i);
> +	return features;
> +}
> +
> +static void kvm_finalize_features(struct virtio_device *vdev)
> +{
> +	unsigned int i, bits;
> +	struct kvm_device_desc *desc = to_kvmdev(vdev)->desc;
> +	/* Second half of bitmap is features we accept. */
> +	u8 *out_features = kvm_vq_features(desc) + desc->feature_len;
> +
> +	/* Give virtio_ring a chance to accept features. */
> +	vring_transport_features(vdev);
> +
> +	memset(out_features, 0, desc->feature_len);
> +	bits = min_t(unsigned, desc->feature_len, sizeof(vdev->features)) * 8;
> +	for (i = 0; i < bits; i++) {
> +		if (test_bit(i, vdev->features))
> +			out_features[i / 8] |= (1 << (i % 8));
> +	}
> +}
> +
> +/*
> + * Reading and writing elements in config space
> + */
> +static void kvm_get(struct virtio_device *vdev, unsigned int offset,
> +		   void *buf, unsigned len)
> +{
> +	struct kvm_device_desc *desc = to_kvmdev(vdev)->desc;
> +
> +	BUG_ON(offset + len > desc->config_len);
> +	memcpy(buf, kvm_vq_configspace(desc) + offset, len);
> +}
> +
> +static void kvm_set(struct virtio_device *vdev, unsigned int offset,
> +		   const void *buf, unsigned len)
> +{
> +	struct kvm_device_desc *desc = to_kvmdev(vdev)->desc;
> +
> +	BUG_ON(offset + len > desc->config_len);
> +	memcpy(kvm_vq_configspace(desc) + offset, buf, len);
> +}
> +
> +/*
> + * The operations to get and set the status word just access
> + * the status field of the device descriptor. set_status will also
> + * make a hypercall to the host, to tell about status changes
> + */
> +static u8 kvm_get_status(struct virtio_device *vdev)
> +{
> +	return to_kvmdev(vdev)->desc->status;
> +}
> +
> +static void kvm_set_status(struct virtio_device *vdev, u8 status)
> +{
> +	BUG_ON(!status);
> +	to_kvmdev(vdev)->desc->status = status;
> +	hcall_virtio(KVM_VIRTIO_SET_STATUS, to_kvmdev(vdev)->desc_pa);
> +}
> +
> +/*
> + * To reset the device, we use the KVM_VIRTIO_RESET hypercall, using the
> + * descriptor address. The Host will zero the status and all the
> + * features.
> + */
> +static void kvm_reset(struct virtio_device *vdev)
> +{
> +	hcall_virtio(KVM_VIRTIO_RESET, to_kvmdev(vdev)->desc_pa);
> +}
> +
> +/*
> + * When the virtio_ring code wants to notify the Host, it calls us here and we
> + * make a hypercall.  We hand the address  of the virtqueue so the Host
> + * knows which virtqueue we're talking about.
> + */
> +static void kvm_notify(struct virtqueue *vq)
> +{
> +	struct kvm_vqinfo *vqi = vq->priv;
> +
> +	hcall_virtio(KVM_VIRTIO_NOTIFY, vqi->config->pa);
> +}
> +
> +/*
> + * Must set some caching mode to keep set_pte() happy.
> + * It doesn't matter what we choose, because the PFN
> + * is illegal, so we're going to take a page fault anyway.
> + */
> +static inline pgprot_t io_prot(void)
> +{
> +	return hv_pte_set_mode(PAGE_KERNEL, HV_PTE_MODE_UNCACHED);
> +}
> +
> +/*
> + * This routine finds the first virtqueue described in the configuration of
> + * this device and sets it up.
> + */
> +static struct virtqueue *kvm_find_vq(struct virtio_device *vdev,
> +				     unsigned index,
> +				     void (*callback)(struct virtqueue *vq),
> +				     const char *name)
> +{
> +	struct kvm_device *kdev = to_kvmdev(vdev);
> +	struct kvm_vqinfo *vqi;
> +	struct kvm_vqconfig *config;
> +	struct virtqueue *vq;
> +	long irq;
> +	int err = -EINVAL;
> +
> +	if (index >= kdev->desc->num_vq)
> +		return ERR_PTR(-ENOENT);
> +
> +	vqi = kzalloc(sizeof(*vqi), GFP_KERNEL);
> +	if (!vqi)
> +		return ERR_PTR(-ENOMEM);
> +
> +	config = kvm_vq_config(kdev->desc)+index;
> +
> +	vqi->config = config;
> +	vqi->pages = generic_remap_prot(config->pa,
> +				vring_size(config->num,
> +					KVM_TILE_VIRTIO_RING_ALIGN),
> +					0, io_prot());
> +	if (!vqi->pages) {
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +
> +	vq = vring_new_virtqueue(index, config->num, KVM_TILE_VIRTIO_RING_ALIGN,
> +				 vdev, 0, vqi->pages,
> +				 kvm_notify, callback, name);
> +	if (!vq) {
> +		err = -ENOMEM;
> +		goto unmap;
> +	}
> +
> +	/*
> +	 * Trigger the IPI interrupt in SW way.
> +	 * TODO: We do not need to create one irq for each vq. A bit wasteful.
> +	 */
> +	irq = create_irq();
> +	if (irq < 0) {
> +		err = -ENXIO;
> +		goto del_virtqueue;
> +	}
> +
> +	tile_irq_activate(irq, TILE_IRQ_SW_CLEAR);
> +
> +	if (request_irq(irq, vring_interrupt, 0, dev_name(&vdev->dev), vq)) {
> +		err = -ENXIO;
> +		destroy_irq(irq);
> +		goto del_virtqueue;
> +	}
> +
> +	config->irq = irq;
> +
> +	vq->priv = vqi;
> +	return vq;
> +
> +del_virtqueue:
> +	vring_del_virtqueue(vq);
> +unmap:
> +	vunmap(vqi->pages);
> +out:
> +	return ERR_PTR(err);
> +}
> +
> +static void kvm_del_vq(struct virtqueue *vq)
> +{
> +	struct kvm_vqinfo *vqi = vq->priv;
> +
> +	vring_del_virtqueue(vq);
> +	vunmap(vqi->pages);
> +	kfree(vqi);
> +}
> +
> +static void kvm_del_vqs(struct virtio_device *vdev)
> +{
> +	struct virtqueue *vq, *n;
> +
> +	list_for_each_entry_safe(vq, n, &vdev->vqs, list)
> +		kvm_del_vq(vq);
> +}
> +
> +static int kvm_find_vqs(struct virtio_device *vdev, unsigned nvqs,
> +			struct virtqueue *vqs[],
> +			vq_callback_t *callbacks[],
> +			const char *names[])
> +{
> +	struct kvm_device *kdev = to_kvmdev(vdev);
> +	int i;
> +
> +	/* We must have this many virtqueues. */
> +	if (nvqs > kdev->desc->num_vq)
> +		return -ENOENT;
> +
> +	for (i = 0; i < nvqs; ++i) {
> +		vqs[i] = kvm_find_vq(vdev, i, callbacks[i], names[i]);
> +		if (IS_ERR(vqs[i]))
> +			goto error;
> +	}
> +	return 0;
> +
> +error:
> +	kvm_del_vqs(vdev);
> +	return PTR_ERR(vqs[i]);
> +}
> +
> +/*
> + * The config ops structure as defined by virtio config
> + */
> +static struct virtio_config_ops kvm_vq_config_ops = {
> +	.get_features = kvm_get_features,
> +	.finalize_features = kvm_finalize_features,
> +	.get = kvm_get,
> +	.set = kvm_set,
> +	.get_status = kvm_get_status,
> +	.set_status = kvm_set_status,
> +	.reset = kvm_reset,
> +	.find_vqs = kvm_find_vqs,
> +	.del_vqs = kvm_del_vqs,
> +};
> +
> +/*
> + * The root device for the kvm virtio devices.
> + * This makes them appear as /sys/devices/kvm_tile/0,1,2 not /sys/devices/0,1,2.
> + */
> +static struct device *kvm_root;
> +
> +/*
> + * adds a new device and register it with virtio
> + * appropriate drivers are loaded by the device model
> + */
> +static void add_kvm_device(struct kvm_device_desc *d, unsigned int offset)
> +{
> +	struct kvm_device *kdev;
> +
> +	kdev = kzalloc(sizeof(*kdev), GFP_KERNEL);
> +	if (!kdev) {
> +		pr_emerg("Cannot allocate kvm dev %u type %u\n",
> +			 offset, d->type);
> +		return;
> +	}
> +
> +	kdev->vdev.dev.parent = kvm_root;
> +	kdev->vdev.id.device = d->type;
> +	kdev->vdev.config = &kvm_vq_config_ops;
> +	kdev->desc = d;
> +	kdev->desc_pa = PFN_PHYS(max_pfn) + offset;
> +
> +	if (register_virtio_device(&kdev->vdev) != 0) {
> +		pr_err("Failed to register kvm device %u type %u\n",
> +		       offset, d->type);
> +		kfree(kdev);
> +	}
> +}
> +
> +/*
> + * scan_devices() simply iterates through the device page.
> + * The type 0 is reserved to mean "end of devices".
> + */
> +static void scan_devices(void)
> +{
> +	unsigned int i;
> +	struct kvm_device_desc *d;
> +
> +	for (i = 0; i < PAGE_SIZE; i += desc_size(d)) {
> +		d = kvm_devices + i;
> +
> +		if (d->type == 0)
> +			break;
> +
> +		add_kvm_device(d, i);
> +	}
> +}
> +
> +/*
> + * Init function for virtio.
> + * devices are in a single page above the top of "normal" mem.
> + */
> +static int __init kvm_devices_init(void)
> +{
> +	int rc = -ENOMEM;
> +
> +	kvm_root = root_device_register("kvm_tile");
> +	if (IS_ERR(kvm_root)) {
> +		rc = PTR_ERR(kvm_root);
> +		pr_err("Could not register kvm_tile root device");
> +		return rc;
> +	}
> +
> +	kvm_devices = generic_remap_prot(PFN_PHYS(max_pfn), PAGE_SIZE,
> +					 0, io_prot());
> +	if (!kvm_devices) {
> +		kvm_devices = NULL;
> +		root_device_unregister(kvm_root);
> +		return rc;
> +	}
> +
> +	scan_devices();
> +	return 0;
> +}
> +
> +/* code for early console output with virtio_console */
> +static __init int early_put_chars(u32 vtermno, const char *buf, int len)
> +{
> +	char scratch[512];
> +
> +	if (len > sizeof(scratch) - 1)
> +		len = sizeof(scratch) - 1;
> +	scratch[len] = '\0';
> +	memcpy(scratch, buf, len);
> +	hcall_virtio(KVM_VIRTIO_NOTIFY, __pa(scratch));
> +
> +	return len;
> +}
> +
> +static int __init tile_virtio_console_init(void)
> +{
> +	return virtio_cons_early_init(early_put_chars);
> +}
> +console_initcall(tile_virtio_console_init);
> +
> +/*
> + * We do this after core stuff, but before the drivers.
> + */
> +postcore_initcall(kvm_devices_init);
> diff --git a/arch/tile/kernel/relocate_kernel_64.S b/arch/tile/kernel/relocate_kernel_64.S
> index 1c09a4f..02bc446 100644
> --- a/arch/tile/kernel/relocate_kernel_64.S
> +++ b/arch/tile/kernel/relocate_kernel_64.S
> @@ -34,11 +34,11 @@ STD_ENTRY(relocate_new_kernel)
>  	addi	sp, sp, -8
>  	/* we now have a stack (whether we need one or not) */
>  
> +#ifdef RELOCATE_NEW_KERNEL_VERBOSE
>  	moveli	r40, hw2_last(hv_console_putc)
>  	shl16insli r40, r40, hw1(hv_console_putc)
>  	shl16insli r40, r40, hw0(hv_console_putc)
>  
> -#ifdef RELOCATE_NEW_KERNEL_VERBOSE
>  	moveli	r0, 'r'
>  	jalr	r40
>  
> @@ -176,10 +176,12 @@ STD_ENTRY(relocate_new_kernel)
>  
>  	/* we should not get here */
>  
> +#ifdef RELOCATE_NEW_KERNEL_VERBOSE
>  	moveli	r0, '?'
>  	jalr	r40
>  	moveli	r0, '\n'
>  	jalr	r40
> +#endif
>  
>  	j	.Lhalt
>  
> @@ -237,7 +239,9 @@ STD_ENTRY(relocate_new_kernel)
>  	j	.Lloop
>  
>  
> -.Lerr:	moveli	r0, 'e'
> +.Lerr:
> +#ifdef RELOCATE_NEW_KERNEL_VERBOSE
> +	moveli	r0, 'e'
>  	jalr	r40
>  	moveli	r0, 'r'
>  	jalr	r40
> @@ -245,6 +249,7 @@ STD_ENTRY(relocate_new_kernel)
>  	jalr	r40
>  	moveli	r0, '\n'
>  	jalr	r40
> +#endif
>  .Lhalt:
>  	moveli r41, hw2_last(hv_halt)
>  	shl16insli r41, r41, hw1(hv_halt)
> 

