Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbaK0DEQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 22:04:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46101 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbaK0DEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 22:04:15 -0500
Date: Wed, 26 Nov 2014 19:02:54 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Drivers: hv: vmbus: prevent cpu offlining on newer
 hypervisors
Message-ID: <20141127030254.GA28028@kroah.com>
References: <1417009942-10216-1-git-send-email-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417009942-10216-1-git-send-email-vkuznets@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 02:52:22PM +0100, Vitaly Kuznetsov wrote:
> When an SMP Hyper-V guest is running on top of 2012R2 Server and secondary
> cpus are sent offline (with echo 0 > /sys/devices/system/cpu/cpu$cpu/online)
> the system freeze is observed. This happens due to the fact that on newer
> hypervisors (Win8, WS2012R2, ...) vmbus channel handlers are distributed
> across all cpus (see init_vp_index() function in drivers/hv/channel_mgmt.c)
> and on cpu offlining nobody reassigns them to CPU0. Prevent cpu offlining
> when vmbus is loaded until the issue is fixed host-side.
> 
> This patch also disables hibernation but it is OK as it is also broken (MCE
> error is hit on resume). Suspend still works.
> 
> Tested with WS2008R2 and WS2012R2.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  drivers/hv/vmbus_drv.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
> index 4d6b269..9a82249 100644
> --- a/drivers/hv/vmbus_drv.c
> +++ b/drivers/hv/vmbus_drv.c
> @@ -32,6 +32,7 @@
>  #include <linux/completion.h>
>  #include <linux/hyperv.h>
>  #include <linux/kernel_stat.h>
> +#include <linux/cpu.h>
>  #include <asm/hyperv.h>
>  #include <asm/hypervisor.h>
>  #include <asm/mshyperv.h>
> @@ -671,6 +672,13 @@ static void vmbus_isr(void)
>  		tasklet_schedule(&msg_dpc);
>  }
>  
> +#ifdef CONFIG_HOTPLUG_CPU
> +static int hyperv_cpu_disable(void)
> +{
> +	return -1;
> +}
> +#endif
> +
>  /*
>   * vmbus_bus_init -Main vmbus driver initialization routine.
>   *
> @@ -711,6 +719,12 @@ static int vmbus_bus_init(int irq)
>  	if (ret)
>  		goto err_alloc;
>  
> +#ifdef CONFIG_HOTPLUG_CPU
> +	if ((vmbus_proto_version != VERSION_WS2008) &&
> +	    (vmbus_proto_version != VERSION_WIN7))
> +		smp_ops.cpu_disable = hyperv_cpu_disable;
> +#endif
> +
>  	vmbus_request_offers();
>  
>  	return 0;
> @@ -964,6 +978,11 @@ static void __exit vmbus_exit(void)
>  	bus_unregister(&hv_bus);
>  	hv_cleanup();
>  	acpi_bus_unregister_driver(&vmbus_acpi_driver);
> +#ifdef CONFIG_HOTPLUG_CPU
> +	if ((vmbus_proto_version != VERSION_WS2008) &&
> +	    (vmbus_proto_version != VERSION_WIN7))
> +		smp_ops.cpu_disable = native_cpu_disable;
> +#endif
>  }

#ifdef in a .c file is not a good idea to do if at all possible, please
only put this in one place, using a function call to "hide" the mess.

greg k-h
