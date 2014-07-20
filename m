Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbaGTRJu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 13:09:50 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:32949 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbaGTRJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 13:09:48 -0400
Date: Sun, 20 Jul 2014 13:09:47 -0400
From: Jerome Glisse <j.glisse@gmail.com>
To: Oded Gabbay <oded.gabbay@amd.com>
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexdeucher@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel.daenzer@amd.com>,
        linux-kernel@vger.kernel.org, Evgeny Pinchuk <Evgeny.Pinchuk@amd.com>,
        Alexey Skidanov <Alexey.Skidanov@amd.com>,
        dri-devel@lists.freedesktop.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Subject: Re: [PATCH v2 09/25] amdkfd: Add amdkfd skeleton driver
Message-ID: <20140720170945.GC3068@gmail.com>
References: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
 <1405603773-32688-10-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405603773-32688-10-git-send-email-oded.gabbay@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 04:29:16PM +0300, Oded Gabbay wrote:
> This patch adds the amdkfd skeleton driver. The driver does nothing except
> define a /dev/kfd device.
> 
> It returns -ENODEV on all amdkfd IOCTLs.
> 
> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
> ---
>  drivers/gpu/drm/radeon/Kconfig              |   2 +
>  drivers/gpu/drm/radeon/Makefile             |   2 +
>  drivers/gpu/drm/radeon/amdkfd/Kconfig       |  10 ++
>  drivers/gpu/drm/radeon/amdkfd/Makefile      |   9 ++
>  drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c | 203 ++++++++++++++++++++++++++++
>  drivers/gpu/drm/radeon/amdkfd/kfd_device.c  | 129 ++++++++++++++++++
>  drivers/gpu/drm/radeon/amdkfd/kfd_module.c  |  98 ++++++++++++++
>  drivers/gpu/drm/radeon/amdkfd/kfd_priv.h    |  81 +++++++++++
>  8 files changed, 534 insertions(+)
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/Kconfig
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/Makefile
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_device.c
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_module.c
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
> 
> diff --git a/drivers/gpu/drm/radeon/Kconfig b/drivers/gpu/drm/radeon/Kconfig
> index 970f8e9..b697321 100644
> --- a/drivers/gpu/drm/radeon/Kconfig
> +++ b/drivers/gpu/drm/radeon/Kconfig
> @@ -6,3 +6,5 @@ config DRM_RADEON_UMS
>  
>  	  Userspace modesetting is deprecated for quite some time now, so
>  	  enable this only if you have ancient versions of the DDX drivers.
> +
> +source "drivers/gpu/drm/radeon/amdkfd/Kconfig"
> diff --git a/drivers/gpu/drm/radeon/Makefile b/drivers/gpu/drm/radeon/Makefile
> index a1c913d..50823a1 100644
> --- a/drivers/gpu/drm/radeon/Makefile
> +++ b/drivers/gpu/drm/radeon/Makefile
> @@ -112,4 +112,6 @@ radeon-$(CONFIG_ACPI) += radeon_acpi.o
>  
>  obj-$(CONFIG_DRM_RADEON)+= radeon.o
>  
> +obj-$(CONFIG_HSA_RADEON)+= amdkfd/
> +
>  CFLAGS_radeon_trace_points.o := -I$(src)
> diff --git a/drivers/gpu/drm/radeon/amdkfd/Kconfig b/drivers/gpu/drm/radeon/amdkfd/Kconfig
> new file mode 100644
> index 0000000..900bb34
> --- /dev/null
> +++ b/drivers/gpu/drm/radeon/amdkfd/Kconfig
> @@ -0,0 +1,10 @@
> +#
> +# Heterogenous system architecture configuration
> +#
> +
> +config HSA_RADEON
> +	tristate "HSA kernel driver for AMD Radeon devices"
> +	depends on DRM_RADEON && AMD_IOMMU_V2 && X86_64
> +	default m
> +	help
> +	  Enable this if you want to use HSA features on AMD radeon devices.
> diff --git a/drivers/gpu/drm/radeon/amdkfd/Makefile b/drivers/gpu/drm/radeon/amdkfd/Makefile
> new file mode 100644
> index 0000000..9564e75
> --- /dev/null
> +++ b/drivers/gpu/drm/radeon/amdkfd/Makefile
> @@ -0,0 +1,9 @@
> +#
> +# Makefile for Heterogenous System Architecture support for AMD radeon devices
> +#
> +
> +ccflags-y := -Iinclude/drm
> +
> +amdkfd-y	:= kfd_module.o kfd_device.o kfd_chardev.o
> +
> +obj-$(CONFIG_HSA_RADEON)	+= amdkfd.o
> diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c b/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
> new file mode 100644
> index 0000000..b98bcb7
> --- /dev/null
> +++ b/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
> @@ -0,0 +1,203 @@
> +/*
> + * Copyright 2014 Advanced Micro Devices, Inc.
> + *
> + * Permission is hereby granted, free of charge, to any person obtaining a
> + * copy of this software and associated documentation files (the "Software"),
> + * to deal in the Software without restriction, including without limitation
> + * the rights to use, copy, modify, merge, publish, distribute, sublicense,
> + * and/or sell copies of the Software, and to permit persons to whom the
> + * Software is furnished to do so, subject to the following conditions:
> + *
> + * The above copyright notice and this permission notice shall be included in
> + * all copies or substantial portions of the Software.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
> + * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
> + * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
> + * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
> + * OTHER DEALINGS IN THE SOFTWARE.
> + */
> +
> +#include <linux/device.h>
> +#include <linux/export.h>
> +#include <linux/err.h>
> +#include <linux/fs.h>
> +#include <linux/sched.h>
> +#include <linux/slab.h>
> +#include <linux/uaccess.h>
> +#include <linux/compat.h>
> +#include <uapi/linux/kfd_ioctl.h>
> +#include <linux/time.h>
> +#include <linux/mm.h>
> +#include <linux/uaccess.h>
> +#include <uapi/asm-generic/mman-common.h>
> +#include <asm/processor.h>
> +#include "kfd_priv.h"
> +
> +static long kfd_ioctl(struct file *, unsigned int, unsigned long);
> +static int kfd_open(struct inode *, struct file *);
> +
> +static const char kfd_dev_name[] = "kfd";
> +
> +static const struct file_operations kfd_fops = {
> +	.owner = THIS_MODULE,
> +	.unlocked_ioctl = kfd_ioctl,
> +	.compat_ioctl = kfd_ioctl,
> +	.open = kfd_open,
> +};
> +
> +static int kfd_char_dev_major = -1;
> +static struct class *kfd_class;
> +struct device *kfd_device;
> +
> +int kfd_chardev_init(void)
> +{
> +	int err = 0;
> +
> +	kfd_char_dev_major = register_chrdev(0, kfd_dev_name, &kfd_fops);
> +	err = kfd_char_dev_major;
> +	if (err < 0)
> +		goto err_register_chrdev;
> +
> +	kfd_class = class_create(THIS_MODULE, kfd_dev_name);
> +	err = PTR_ERR(kfd_class);
> +	if (IS_ERR(kfd_class))
> +		goto err_class_create;
> +
> +	kfd_device = device_create(kfd_class, NULL, MKDEV(kfd_char_dev_major, 0), NULL, kfd_dev_name);
> +	err = PTR_ERR(kfd_device);
> +	if (IS_ERR(kfd_device))
> +		goto err_device_create;
> +
> +	return 0;
> +
> +err_device_create:
> +	class_destroy(kfd_class);
> +err_class_create:
> +	unregister_chrdev(kfd_char_dev_major, kfd_dev_name);
> +err_register_chrdev:
> +	return err;
> +}
> +
> +void kfd_chardev_exit(void)
> +{
> +	device_destroy(kfd_class, MKDEV(kfd_char_dev_major, 0));
> +	class_destroy(kfd_class);
> +	unregister_chrdev(kfd_char_dev_major, kfd_dev_name);
> +}
> +
> +struct device *kfd_chardev(void)
> +{
> +	return kfd_device;
> +}
> +
> +
> +static int kfd_open(struct inode *inode, struct file *filep)
> +{
> +	if (iminor(inode) != 0)
> +		return -ENODEV;
> +
> +	return 0;
> +}
> +
> +static long kfd_ioctl_create_queue(struct file *filep, struct kfd_process *p, void __user *arg)
> +{
> +	return -ENODEV;
> +}
> +
> +static int kfd_ioctl_destroy_queue(struct file *filp, struct kfd_process *p, void __user *arg)
> +{
> +	return -ENODEV;
> +}
> +
> +static int kfd_ioctl_update_queue(struct file *filp, struct kfd_process *p, void __user *arg)
> +{
> +	return -ENODEV;
> +}
> +
> +static long kfd_ioctl_set_memory_policy(struct file *filep, struct kfd_process *p, void __user *arg)
> +{
> +	return -ENODEV;
> +}
> +
> +static long kfd_ioctl_get_clock_counters(struct file *filep, struct kfd_process *p, void __user *arg)
> +{
> +	return -ENODEV;
> +}
> +
> +
> +static int kfd_ioctl_get_process_apertures(struct file *filp, struct kfd_process *p, void __user *arg)
> +{
> +	return -ENODEV;
> +}
> +
> +static long kfd_ioctl_pmc_acquire_access(struct file *filp, struct kfd_process *p, void __user *arg)
> +{
> +	return -ENODEV;
> +}
> +
> +static long kfd_ioctl_pmc_release_access(struct file *filp, struct kfd_process *p, void __user *arg)
> +{
> +	return -ENODEV;
> +}
> +
> +static long kfd_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
> +{
> +	struct kfd_process *process;
> +	long err = -EINVAL;
> +
> +	dev_dbg(kfd_device,
> +		"ioctl cmd 0x%x (#%d), arg 0x%lx\n",
> +		cmd, _IOC_NR(cmd), arg);
> +
> +	/* TODO: add function that retrieves process */
> +	process = NULL;
> +
> +	switch (cmd) {
> +	case KFD_IOC_CREATE_QUEUE:
> +		err = kfd_ioctl_create_queue(filep, process, (void __user *)arg);
> +		break;
> +
> +	case KFD_IOC_DESTROY_QUEUE:
> +		err = kfd_ioctl_destroy_queue(filep, process, (void __user *)arg);
> +		break;
> +
> +	case KFD_IOC_SET_MEMORY_POLICY:
> +		err = kfd_ioctl_set_memory_policy(filep, process, (void __user *)arg);
> +		break;
> +
> +	case KFD_IOC_GET_CLOCK_COUNTERS:
> +		err = kfd_ioctl_get_clock_counters(filep, process, (void __user *)arg);
> +		break;
> +
> +	case KFD_IOC_GET_PROCESS_APERTURES:
> +		err = kfd_ioctl_get_process_apertures(filep, process, (void __user *)arg);
> +		break;
> +
> +	case KFD_IOC_UPDATE_QUEUE:
> +		err = kfd_ioctl_update_queue(filep, process, (void __user *)arg);
> +		break;
> +
> +	case KFD_IOC_PMC_ACQUIRE_ACCESS:
> +		err = kfd_ioctl_pmc_acquire_access(filep, process, (void __user *) arg);
> +		break;
> +
> +	case KFD_IOC_PMC_RELEASE_ACCESS:
> +		err = kfd_ioctl_pmc_release_access(filep, process, (void __user *) arg);
> +		break;
> +
> +	default:
> +		dev_err(kfd_device,
> +			"unknown ioctl cmd 0x%x, arg 0x%lx)\n",
> +			cmd, arg);
> +		err = -EINVAL;
> +		break;
> +	}
> +
> +	if (err < 0)
> +		dev_err(kfd_device, "ioctl error %ld\n", err);
> +
> +	return err;
> +}
> diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_device.c b/drivers/gpu/drm/radeon/amdkfd/kfd_device.c
> new file mode 100644
> index 0000000..dd63ce09
> --- /dev/null
> +++ b/drivers/gpu/drm/radeon/amdkfd/kfd_device.c
> @@ -0,0 +1,129 @@
> +/*
> + * Copyright 2014 Advanced Micro Devices, Inc.
> + *
> + * Permission is hereby granted, free of charge, to any person obtaining a
> + * copy of this software and associated documentation files (the "Software"),
> + * to deal in the Software without restriction, including without limitation
> + * the rights to use, copy, modify, merge, publish, distribute, sublicense,
> + * and/or sell copies of the Software, and to permit persons to whom the
> + * Software is furnished to do so, subject to the following conditions:
> + *
> + * The above copyright notice and this permission notice shall be included in
> + * all copies or substantial portions of the Software.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
> + * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
> + * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
> + * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
> + * OTHER DEALINGS IN THE SOFTWARE.
> + */
> +
> +#include <linux/amd-iommu.h>
> +#include <linux/bsearch.h>
> +#include <linux/pci.h>
> +#include <linux/slab.h>
> +#include "kfd_priv.h"
> +
> +static const struct kfd_device_info kaveri_device_info = {
> +	.max_pasid_bits = 16,
> +};
> +
> +struct kfd_deviceid {
> +	unsigned short did;
> +	const struct kfd_device_info *device_info;
> +};
> +
> +/* Please keep this sorted by increasing device id. */
> +static const struct kfd_deviceid supported_devices[] = {
> +	{ 0x1304, &kaveri_device_info },	/* Kaveri */
> +	{ 0x1305, &kaveri_device_info },	/* Kaveri */
> +	{ 0x1306, &kaveri_device_info },	/* Kaveri */
> +	{ 0x1307, &kaveri_device_info },	/* Kaveri */
> +	{ 0x1309, &kaveri_device_info },	/* Kaveri */
> +	{ 0x130A, &kaveri_device_info },	/* Kaveri */
> +	{ 0x130B, &kaveri_device_info },	/* Kaveri */
> +	{ 0x130C, &kaveri_device_info },	/* Kaveri */
> +	{ 0x130D, &kaveri_device_info },	/* Kaveri */
> +	{ 0x130E, &kaveri_device_info },	/* Kaveri */
> +	{ 0x130F, &kaveri_device_info },	/* Kaveri */
> +	{ 0x1310, &kaveri_device_info },	/* Kaveri */
> +	{ 0x1311, &kaveri_device_info },	/* Kaveri */
> +	{ 0x1312, &kaveri_device_info },	/* Kaveri */
> +	{ 0x1313, &kaveri_device_info },	/* Kaveri */
> +	{ 0x1315, &kaveri_device_info },	/* Kaveri */
> +	{ 0x1316, &kaveri_device_info },	/* Kaveri */
> +	{ 0x1317, &kaveri_device_info },	/* Kaveri */
> +	{ 0x1318, &kaveri_device_info },	/* Kaveri */
> +	{ 0x131B, &kaveri_device_info },	/* Kaveri */
> +	{ 0x131C, &kaveri_device_info },	/* Kaveri */
> +	{ 0x131D, &kaveri_device_info },	/* Kaveri */
> +};
> +
> +static const struct kfd_device_info *lookup_device_info(unsigned short did)
> +{
> +	size_t i;
> +
> +	for (i = 0; i < ARRAY_SIZE(supported_devices); i++) {
> +		if (supported_devices[i].did == did) {
> +			BUG_ON(supported_devices[i].device_info == NULL);
> +			return supported_devices[i].device_info;
> +		}
> +	}
> +
> +	return NULL;
> +}
> +
> +struct kfd_dev *kgd2kfd_probe(struct kgd_dev *kgd, struct pci_dev *pdev)
> +{
> +	struct kfd_dev *kfd;
> +
> +	const struct kfd_device_info *device_info = lookup_device_info(pdev->device);
> +
> +	if (!device_info)
> +		return NULL;
> +
> +	kfd = kzalloc(sizeof(*kfd), GFP_KERNEL);
> +	if (!kfd)
> +		return NULL;
> +
> +	kfd->kgd = kgd;
> +	kfd->device_info = device_info;
> +	kfd->pdev = pdev;
> +
> +	return kfd;
> +}
> +
> +bool kgd2kfd_device_init(struct kfd_dev *kfd,
> +			 const struct kgd2kfd_shared_resources *gpu_resources)
> +{
> +	kfd->shared_resources = *gpu_resources;
> +
> +	kfd->init_complete = true;
> +	dev_info(kfd_device, "added device (%x:%x)\n", kfd->pdev->vendor,
> +		 kfd->pdev->device);
> +
> +	return true;
> +}
> +
> +void kgd2kfd_device_exit(struct kfd_dev *kfd)
> +{
> +	kfree(kfd);
> +}
> +
> +void kgd2kfd_suspend(struct kfd_dev *kfd)
> +{
> +	BUG_ON(kfd == NULL);
> +}
> +
> +int kgd2kfd_resume(struct kfd_dev *kfd)
> +{
> +	BUG_ON(kfd == NULL);
> +
> +	return 0;
> +}
> +
> +void kgd2kfd_interrupt(struct kfd_dev *dev, const void *ih_ring_entry)
> +{
> +}
> diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_module.c b/drivers/gpu/drm/radeon/amdkfd/kfd_module.c
> new file mode 100644
> index 0000000..c7faac6
> --- /dev/null
> +++ b/drivers/gpu/drm/radeon/amdkfd/kfd_module.c
> @@ -0,0 +1,98 @@
> +/*
> + * Copyright 2014 Advanced Micro Devices, Inc.
> + *
> + * Permission is hereby granted, free of charge, to any person obtaining a
> + * copy of this software and associated documentation files (the "Software"),
> + * to deal in the Software without restriction, including without limitation
> + * the rights to use, copy, modify, merge, publish, distribute, sublicense,
> + * and/or sell copies of the Software, and to permit persons to whom the
> + * Software is furnished to do so, subject to the following conditions:
> + *
> + * The above copyright notice and this permission notice shall be included in
> + * all copies or substantial portions of the Software.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
> + * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
> + * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
> + * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
> + * OTHER DEALINGS IN THE SOFTWARE.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/sched.h>
> +#include <linux/notifier.h>
> +#include <linux/moduleparam.h>
> +#include <linux/device.h>
> +#include "kfd_priv.h"
> +
> +#define KFD_DRIVER_AUTHOR	"AMD Inc. and others"
> +
> +#define KFD_DRIVER_DESC		"Standalone HSA driver for AMD's GPUs"
> +#define KFD_DRIVER_DATE		"20140710"
> +#define KFD_DRIVER_MAJOR	0
> +#define KFD_DRIVER_MINOR	6
> +#define KFD_DRIVER_PATCHLEVEL	2
> +
> +const struct kfd2kgd_calls *kfd2kgd;
> +static const struct kgd2kfd_calls kgd2kfd = {
> +	.exit		= kgd2kfd_exit,
> +	.probe		= kgd2kfd_probe,
> +	.device_init	= kgd2kfd_device_init,
> +	.device_exit	= kgd2kfd_device_exit,
> +	.interrupt	= kgd2kfd_interrupt,
> +	.suspend	= kgd2kfd_suspend,
> +	.resume		= kgd2kfd_resume,
> +};
> +
> +bool kgd2kfd_init(unsigned interface_version,
> +		  const struct kfd2kgd_calls *f2g,
> +		  const struct kgd2kfd_calls **g2f)
> +{
> +	/* Only one interface version is supported, no kfd/kgd version skew allowed. */
> +	if (interface_version != KFD_INTERFACE_VERSION)
> +		return false;

I am guessing this is for out of tree module ? Because otherwise this is
useless.

> +
> +	kfd2kgd = f2g;
> +	*g2f = &kgd2kfd;
> +
> +	return true;
> +}
> +EXPORT_SYMBOL(kgd2kfd_init);
> +
> +void kgd2kfd_exit(void)
> +{
> +}
> +
> +static int __init kfd_module_init(void)
> +{
> +	int err;
> +
> +	err = kfd_chardev_init();
> +	if (err < 0)
> +		goto err_ioctl;
> +
> +	dev_info(kfd_device, "Initialized module\n");
> +

Improve dev_info to provide some meaning full information like bus id, device name.

> +	return 0;
> +
> +err_ioctl:
> +	return err;
> +}
> +
> +static void __exit kfd_module_exit(void)
> +{
> +	kfd_chardev_exit();
> +	dev_info(kfd_device, "Removed module\n");
> +}

Same as for module_init, improve dev_info.

> +
> +module_init(kfd_module_init);
> +module_exit(kfd_module_exit);
> +
> +MODULE_AUTHOR(KFD_DRIVER_AUTHOR);
> +MODULE_DESCRIPTION(KFD_DRIVER_DESC);
> +MODULE_LICENSE("GPL and additional rights");

I would like to see all copyright header to reflect that ie to clearly
state that it could be either licensed under GPL or under the BSD license
that you are using.

> +MODULE_VERSION(__stringify(KFD_DRIVER_MAJOR) "."
> +	       __stringify(KFD_DRIVER_MINOR) "."
> +	       __stringify(KFD_DRIVER_PATCHLEVEL));
> diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
> new file mode 100644
> index 0000000..05e892f
> --- /dev/null
> +++ b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
> @@ -0,0 +1,81 @@
> +/*
> + * Copyright 2014 Advanced Micro Devices, Inc.
> + *
> + * Permission is hereby granted, free of charge, to any person obtaining a
> + * copy of this software and associated documentation files (the "Software"),
> + * to deal in the Software without restriction, including without limitation
> + * the rights to use, copy, modify, merge, publish, distribute, sublicense,
> + * and/or sell copies of the Software, and to permit persons to whom the
> + * Software is furnished to do so, subject to the following conditions:
> + *
> + * The above copyright notice and this permission notice shall be included in
> + * all copies or substantial portions of the Software.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
> + * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
> + * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
> + * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
> + * OTHER DEALINGS IN THE SOFTWARE.
> + */
> +
> +#ifndef KFD_PRIV_H_INCLUDED
> +#define KFD_PRIV_H_INCLUDED
> +
> +#include <linux/hashtable.h>
> +#include <linux/mmu_notifier.h>
> +#include <linux/mutex.h>
> +#include <linux/types.h>
> +#include <linux/atomic.h>
> +#include <linux/workqueue.h>
> +#include <linux/spinlock.h>
> +#include "../radeon_kfd.h"
> +
> +struct kfd_device_info {
> +	const struct kfd_scheduler_class *scheduler_class;
> +	unsigned int max_pasid_bits;
> +	size_t ih_ring_entry_size;
> +};
> +
> +struct kfd_dev {
> +	struct kgd_dev *kgd;
> +
> +	const struct kfd_device_info *device_info;
> +	struct pci_dev *pdev;
> +
> +	bool init_complete;
> +
> +	unsigned int id;		/* topology stub index */
> +
> +	struct kgd2kfd_shared_resources shared_resources;
> +};
> +
> +/* KGD2KFD callbacks */
> +void kgd2kfd_exit(void);
> +struct kfd_dev *kgd2kfd_probe(struct kgd_dev *kgd, struct pci_dev *pdev);
> +bool kgd2kfd_device_init(struct kfd_dev *kfd,
> +			 const struct kgd2kfd_shared_resources *gpu_resources);
> +void kgd2kfd_device_exit(struct kfd_dev *kfd);
> +
> +extern const struct kfd2kgd_calls *kfd2kgd;
> +
> +/* Character device interface */
> +int kfd_chardev_init(void);
> +void kfd_chardev_exit(void);
> +struct device *kfd_chardev(void);
> +
> +/* Process data */
> +struct kfd_process {
> +};
> +
> +extern struct device *kfd_device;
> +
> +/* Interrupts */
> +void kgd2kfd_interrupt(struct kfd_dev *dev, const void *ih_ring_entry);
> +
> +/* Power Management */
> +void kgd2kfd_suspend(struct kfd_dev *dev);
> +int kgd2kfd_resume(struct kfd_dev *dev);
> +
> +#endif
> -- 
> 1.9.1
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
