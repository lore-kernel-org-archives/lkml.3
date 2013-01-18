Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab3ARQQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 11:16:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541Ab3ARQQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 11:16:45 -0500
Message-ID: <50F9755B.5090900@redhat.com>
Date: Fri, 18 Jan 2013 11:16:27 -0500
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121116 Thunderbird/10.0.11
MIME-Version: 1.0
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
CC: linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Khalid Aziz <khalid.aziz@hp.com>
Subject: Re: [PATCH 4/5] PCI: don't touch enable_cnt in pci_device_shutdown()
References: <20130118113019.6698.25941.stgit@zurg> <20130118114225.6698.42016.stgit@zurg>
In-Reply-To: <20130118114225.6698.42016.stgit@zurg>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2013 06:42 AM, Konstantin Khlebnikov wrote:
> comment in commit b566a22c23327f18ce941ffad0ca907e50a53d41
> ("PCI: disable Bus Master on PCI device shutdown") says:
>
> | Disable Bus Master bit on the device in pci_device_shutdown() to ensure PCI
> | devices do not continue to DMA data after shutdown.  This can cause memory
> | corruption in case of a kexec where the current kernel shuts down and
> | transfers control to a new kernel while a PCI device continues to DMA to
> | memory that does not belong to it any more in the new kernel.
>
> Seems like pci_clear_master() must be used here instead of pci_disable_device(),
> because it disables Bus Muster unconditionally and doesn't changes enable_cnt.
>
> Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
> Cc: linux-pci@vger.kernel.org
> Cc: Bjorn Helgaas<bhelgaas@google.com>
> Cc: Khalid Aziz<khalid.aziz@hp.com>

Hmmm.... wondering if this was the problem why kexec folks
said that device_shutdown() didn't work on all systems (when
trying to stop DMA, esp. on IOMMU-enabled systems...).

Bjorn: do you have a list &/or contact in kexec space to try this
patch vs the "reset every PCI bus" strategy that is currently
being pushed for kexec's method to halt DMA from a PCI device ?

> ---
>   drivers/pci/pci-driver.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index 030dbf0..853d605 100644
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -392,7 +392,7 @@ static void pci_device_shutdown(struct device *dev)
>   	 * Turn off Bus Master bit on the device to tell it to not
>   	 * continue to do DMA
>   	 */
> -	pci_disable_device(pci_dev);
> +	pci_clear_master(pci_dev);
>   }
>
>   #ifdef CONFIG_PM
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

