Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256AbbAIU5g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 15:57:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36433 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbbAIU5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 15:57:35 -0500
Date: Fri, 9 Jan 2015 12:57:34 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Dexuan Cui <decui@microsoft.com>
Subject: Re: [PATCH v2] Drivers: hv: vmbus: prevent cpu offlining on newer
 hypervisors
Message-ID: <20150109205734.GA25014@kroah.com>
References: <1417009942-10216-1-git-send-email-vkuznets@redhat.com>
 <1417431161-12845-1-git-send-email-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417431161-12845-1-git-send-email-vkuznets@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 11:52:41AM +0100, Vitaly Kuznetsov wrote:
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
> Acked-by: Dexuan Cui <decui@microsoft.com>
> 
> ---
> Changes since v1:
> - introduce hv_cpu_hotplug_quirk() function to not spread #ifdefs [Greg KH]
> - add pr_notice() message "hv_vmbus: CPU offlining is not supported by hypervisor"
> ---
>  drivers/hv/vmbus_drv.c | 33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
> 
> diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
> index 4d6b269..2e6b38e 100644
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
> @@ -671,6 +672,36 @@ static void vmbus_isr(void)
>  		tasklet_schedule(&msg_dpc);
>  }
>  
> +#ifdef CONFIG_HOTPLUG_CPU
> +static int hyperv_cpu_disable(void)
> +{
> +	return -1;
> +}
> +
> +static void hv_cpu_hotplug_quirk(bool vmbus_loaded)
> +{
> +	/*
> +	 * Offlining a CPU when running on newer hypervisors (WS2012R2, Win8,
> +	 * ...) is not supported at this moment as channel interrupts are
> +	 * distributed across all of them.
> +	 */
> +
> +	if ((vmbus_proto_version == VERSION_WS2008) ||
> +	    (vmbus_proto_version == VERSION_WIN7))
> +		return;
> +
> +	if (vmbus_loaded) {
> +		smp_ops.cpu_disable = hyperv_cpu_disable;
> +		pr_notice("CPU offlining is not supported by hypervisor");
> +	} else
> +		smp_ops.cpu_disable = native_cpu_disable;
> +}
> +#else
> +static void hv_cpu_hotplug_quirk(bool vmbus_loaded)
> +{
> +}
> +#endif
> +
>  /*
>   * vmbus_bus_init -Main vmbus driver initialization routine.
>   *
> @@ -711,6 +742,7 @@ static int vmbus_bus_init(int irq)
>  	if (ret)
>  		goto err_alloc;
>  
> +	hv_cpu_hotplug_quirk(true);
>  	vmbus_request_offers();
>  
>  	return 0;
> @@ -964,6 +996,7 @@ static void __exit vmbus_exit(void)
>  	bus_unregister(&hv_bus);
>  	hv_cleanup();
>  	acpi_bus_unregister_driver(&vmbus_acpi_driver);
> +	hv_cpu_hotplug_quirk(false);
>  }
>  
>  
> -- 
> 1.9.3

This breaks the build:
ERROR: "native_cpu_disable" [drivers/hv/hv_vmbus.ko] undefined!

Please test better.

greg k-h
