Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711AbaGKUfE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 16:35:04 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:44931 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbaGKUfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 16:35:01 -0400
Date: Fri, 11 Jul 2014 16:34:56 -0400
From: Jerome Glisse <j.glisse@gmail.com>
To: Oded Gabbay <oded.gabbay@gmail.com>
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>,
        Evgeny Pinchuk <evgeny.pinchuk@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>, Ben Goz <ben.goz@amd.com>,
        Alexey Skidanov <Alexey.Skidanov@amd.com>, linux-api@vger.kernel.org
Subject: Re: [PATCH 32/83] hsa/radeon: implementing IOCTL for clock counters
Message-ID: <20140711203455.GR1870@gmail.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
 <1405029279-6894-4-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405029279-6894-4-git-send-email-oded.gabbay@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 12:53:48AM +0300, Oded Gabbay wrote:
> From: Evgeny Pinchuk <evgeny.pinchuk@amd.com>
> 
> Implemented new IOCTL to query the CPU and GPU clock counters.
> 
> Signed-off-by: Evgeny Pinchuk <evgeny.pinchuk@amd.com>
> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
> ---
>  drivers/gpu/hsa/radeon/kfd_chardev.c | 37 ++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/kfd_ioctl.h       |  9 +++++++++
>  2 files changed, 46 insertions(+)
> 
> diff --git a/drivers/gpu/hsa/radeon/kfd_chardev.c b/drivers/gpu/hsa/radeon/kfd_chardev.c
> index ddaf357..d6fa980 100644
> --- a/drivers/gpu/hsa/radeon/kfd_chardev.c
> +++ b/drivers/gpu/hsa/radeon/kfd_chardev.c
> @@ -28,6 +28,7 @@
>  #include <linux/slab.h>
>  #include <linux/uaccess.h>
>  #include <uapi/linux/kfd_ioctl.h>
> +#include <linux/time.h>
>  #include "kfd_priv.h"
>  #include "kfd_scheduler.h"
>  
> @@ -284,6 +285,38 @@ out:
>  	return err;
>  }
>  
> +static long
> +kfd_ioctl_get_clock_counters(struct file *filep, struct kfd_process *p, void __user *arg)
> +{
> +	struct kfd_ioctl_get_clock_counters_args args;
> +	struct kfd_dev *dev;
> +	struct timespec time;
> +
> +	if (copy_from_user(&args, arg, sizeof(args)))
> +		return -EFAULT;
> +
> +	dev = radeon_kfd_device_by_id(args.gpu_id);
> +	if (dev == NULL)
> +		return -EINVAL;
> +
> +	/* Reading GPU clock counter from KGD */
> +	args.gpu_clock_counter = kfd2kgd->get_gpu_clock_counter(dev->kgd);
> +
> +	/* No access to rdtsc. Using raw monotonic time */
> +	getrawmonotonic(&time);
> +	args.cpu_clock_counter = time.tv_nsec;

Is the GPU clock counter monotonic too ? Even after GPU reset (hard reset
included) what could go wrong if it rolls back ?

> +
> +	get_monotonic_boottime(&time);
> +	args.system_clock_counter = time.tv_nsec;
> +
> +	/* Since the counter is in nano-seconds we use 1GHz frequency */
> +	args.system_clock_freq = 1000000000;
> +
> +	if (copy_to_user(arg, &args, sizeof(args)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
>  
>  static long
>  kfd_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
> @@ -312,6 +345,10 @@ kfd_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
>  		err = kfd_ioctl_set_memory_policy(filep, process, (void __user *)arg);
>  		break;
>  
> +	case KFD_IOC_GET_CLOCK_COUNTERS:
> +		err = kfd_ioctl_get_clock_counters(filep, process, (void __user *)arg);
> +		break;
> +
>  	default:
>  		dev_err(kfd_device,
>  			"unknown ioctl cmd 0x%x, arg 0x%lx)\n",
> diff --git a/include/uapi/linux/kfd_ioctl.h b/include/uapi/linux/kfd_ioctl.h
> index 928e628..5b9517e 100644
> --- a/include/uapi/linux/kfd_ioctl.h
> +++ b/include/uapi/linux/kfd_ioctl.h
> @@ -70,12 +70,21 @@ struct kfd_ioctl_set_memory_policy_args {
>  	uint64_t alternate_aperture_size;	/* to KFD */
>  };
>  
> +struct kfd_ioctl_get_clock_counters_args {
> +	uint32_t gpu_id;		/* to KFD */
> +	uint64_t gpu_clock_counter;	/* from KFD */
> +	uint64_t cpu_clock_counter;	/* from KFD */
> +	uint64_t system_clock_counter;	/* from KFD */
> +	uint64_t system_clock_freq;	/* from KFD */
> +};
> +
>  #define KFD_IOC_MAGIC 'K'
>  
>  #define KFD_IOC_GET_VERSION	_IOR(KFD_IOC_MAGIC, 1, struct kfd_ioctl_get_version_args)
>  #define KFD_IOC_CREATE_QUEUE	_IOWR(KFD_IOC_MAGIC, 2, struct kfd_ioctl_create_queue_args)
>  #define KFD_IOC_DESTROY_QUEUE	_IOWR(KFD_IOC_MAGIC, 3, struct kfd_ioctl_destroy_queue_args)
>  #define KFD_IOC_SET_MEMORY_POLICY	_IOW(KFD_IOC_MAGIC, 4, struct kfd_ioctl_set_memory_policy_args)
> +#define KFD_IOC_GET_CLOCK_COUNTERS	_IOWR(KFD_IOC_MAGIC, 5, struct kfd_ioctl_get_clock_counters_args)
>  
>  #pragma pack(pop)
>  
> -- 
> 1.9.1
> 
