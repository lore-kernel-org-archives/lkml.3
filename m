Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933181Ab3GKO1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:27:45 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:61849 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933019Ab3GKO1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:27:41 -0400
Message-ID: <1373552859.1349.9.camel@x61.thuisdomein>
Subject: Re: [PATCH -v2 2/3] PCI,pciehp: avoid add a device already exist
 before suspend during resume
From: Paul Bolle <pebolle@tiscali.nl>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Rafael <rjw@sisk.pl>,
        Hanjun Guo <guohanjun@huawei.com>, jiang.liu@huawei.com,
        Oliver Neukum <oneukum@suse.de>, Gu Zheng <guz.fnst@cn.fujitsu.com>
Date: Thu, 11 Jul 2013 16:27:39 +0200
In-Reply-To: <1373535825-49972-3-git-send-email-wangyijing@huawei.com>
References: <1373535825-49972-1-git-send-email-wangyijing@huawei.com>
	 <1373535825-49972-3-git-send-email-wangyijing@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jul 2013 14:27:39.0479 (UTC) FILETIME=[CBF05670:01CE7E42]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-11 at 17:43 +0800, Yijing Wang wrote:
> Currently, pciehp_resume() try to hot add device if the slot adapter
> status return true. But if there are already some devices exist,
> namely list_empty(bus->devices) return false. We should not add the device
> again, because the device add action will fail. Also print some uncomfortable
> messages like this:
> 	pciehp 0000:00:1c.1:pcie04: Device 0000:03:00.0 already exists at 0000:03:00, cannot hot-add
> 	pciehp 0000:00:1c.1:pcie04: Cannot add device at 0000:03:00
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> Cc: Paul Bolle <pebolle@tiscali.nl>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: Oliver Neukum <oneukum@suse.de>
> Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>
> Cc: linux-pci@vger.kernel.org
> ---
>  drivers/pci/hotplug/pciehp_core.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
> index 7d72c5e..1542735 100644
> --- a/drivers/pci/hotplug/pciehp_core.c
> +++ b/drivers/pci/hotplug/pciehp_core.c
[...]
> @@ -311,10 +312,12 @@ static int pciehp_resume (struct pcie_device *dev)
>  
>  	/* Check if slot is occupied */
>  	pciehp_get_adapter_status(slot, &status);
> -	if (status)
> -		pciehp_enable_slot(slot);
> -	else
> +	if (status) {
> +		if (list_empty(&pbus->devices))
> +			pciehp_enable_slot(slot);
> +	} else if (!list_empty(&pbus->devices))
>  		pciehp_disable_slot(slot);
> +

Coding style: braces for the "else if" branch too? Or change the first
test to "if (status && list_empty([...]))" and drop the braces?

>  	return 0;
>  }
>  #endif /* PM */


Paul Bolle

