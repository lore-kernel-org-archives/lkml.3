Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaKQK54 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 05:57:56 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:57090 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaKQK5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 05:57:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@lists.ozlabs.org
Cc: Yijing Wang <wangyijing@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Liviu Dudau <liviu@dudau.co.uk>, Tony Luck <tony.luck@intel.com>,
        Russell King <linux@arm.linux.org.uk>, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Xinwei Hu <huxinwei@huawei.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Suravee.Suthikulpanit@amd.com, linux-ia64@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Wuyun <wuyun.wu@huawei.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 07/16] PCI: Separate pci_host_bridge creation out of pci_create_root_bus()
Date: Mon, 17 Nov 2014 11:56:36 +0100
Message-ID: <2507218.mHliopJb05@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1416219710-26088-8-git-send-email-wangyijing@huawei.com>
References: <1416219710-26088-1-git-send-email-wangyijing@huawei.com> <1416219710-26088-8-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:74Ao8sf4MHnuNzGHJvdjs3pqAhq/JP8hFBSt6Y/Ru2i
 GO9Fm4IpuF8LeHVNGHYYbtRxFadyyhBzYhYuuPoabTBSBvkqLf
 GimrD1UMW/oxcSjmfLTnuUz6kAp4vQ0kwszrpzEE/PDlc2bl4N
 dG/V1NV1Els+HNybzpUMujHcZRHluC7D0QDssZZGJqQNjMKpVe
 3fAUx+0vWhVRx5LDyZfj80Hq+GZQfugWAm0IAIhjgZLlTY13qy
 RVzbMIVSkcCNo9+Z5FRcAfH7GgKORtHMZBSHWwwqxRuhsmHdrB
 cBxtMpxergzRx3e+7Elvm67CJX0hE6rJIgyZ0Y9A56idzwCMFp
 rzcMDkabBVrr4h3lza1Y=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 November 2014 18:21:41 Yijing Wang wrote:
> There are some common PCI infos like domain, msi_controller, these
> infos are saved in arch PCI sysdata, and lots arch specific functions
> like pci_domain_nr() and pcibios_msi_controller() required.
> We could separate pci_host_bridge creation out of pci_create_root_bus(),
> then we could put the common infos in, then we could eliminate
> the arch specifc functions.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> ---
>  drivers/pci/host-bridge.c |   99 +++++++++++++++++++++++++++++++++
>  drivers/pci/probe.c       |  134 ++++++++++++++++----------------------------
>  include/linux/pci.h       |   11 +++-
>  3 files changed, 158 insertions(+), 86 deletions(-)
> 
> diff --git a/drivers/pci/host-bridge.c b/drivers/pci/host-bridge.c
> index 0e5f3c9..e31604f 100644
> --- a/drivers/pci/host-bridge.c
> +++ b/drivers/pci/host-bridge.c
> @@ -8,6 +8,105 @@
>  
>  #include "pci.h"
>  
> +LIST_HEAD(pci_host_bridge_list);
> +DECLARE_RWSEM(pci_host_bridge_sem);

Unless the pci_host_bridge_sem is accessed thousands of times per second,
it's normally better to use a simple mutex instead.

> +static struct resource busn_resource = {
> +	.name	= "PCI busn",
> +	.start	= 0,
> +	.end	= 255,
> +	.flags	= IORESOURCE_BUS,
> +};

I think it would be better to require callers to pass the bus resource
down to the function.

> +struct pci_host_bridge *pci_create_host_bridge(
> +		struct device *parent, u32 db, 
> +		struct pci_ops *ops, void *sysdata, 
> +		struct list_head *resources)
> +{

Do we still need to pass the 'sysdata' in here? If we are guaranteed to
have a device pointer, we should always be able to get the driver
private data from dev_get_drvdata(host->dev->parent).

> +	host = kzalloc(sizeof(*host), GFP_KERNEL);
> +	if (!host)
> +		return NULL;

devm_kzalloc maybe?

> +	if (!resources) {
> +		/* Use default IO/MEM/BUS resources*/
> +		pci_add_resource(&host->windows, &ioport_resource);
> +		pci_add_resource(&host->windows, &iomem_resource);
> +		pci_add_resource(&host->windows, &busn_resource);
> +	} else {
> +		list_for_each_entry_safe(window, n, resources, list)
> +			list_move_tail(&window->list, &host->windows);
> +	}

I think we should assume that the correct resources are passed. You
could add a wrapper around this function to convert old platforms
though.

> +EXPORT_SYMBOL(pci_create_host_bridge);

EXPORT_SYMBOL_GPL() maybe?

> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 8b11b38..daa7f40 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -402,7 +402,12 @@ struct pci_host_bridge_window {
>  struct pci_host_bridge {
>  	struct device dev;
>  	struct pci_bus *bus;		/* root bus */
> +	struct list_head list;
>  	struct list_head windows;	/* pci_host_bridge_windows */
> +	int busnum;

The busnum should already be implied through the bus resource.

	Arnd
