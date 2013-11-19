Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab3KSCCg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 21:02:36 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:43936 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab3KSCCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 21:02:32 -0500
Message-ID: <528AC4F2.40708@huawei.com>
Date: Tue, 19 Nov 2013 09:54:58 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
CC: Yinghai Lu <yinghai@kernel.org>, Andreas Noever <andreas.noever@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [3.11.4] Thunderbolt/PCI unplug oops in pci_pme_list_scan
References: <CAMxnaaUim-MCDpaTiLmBqN3wfxjn9V6XE_n4SMfuO=vqeT6rVA@mail.gmail.com> <CAErSpo4KU9VAC=SnKuYH3EPz8NuozixAhUQBKv+=Y=76wywdTg@mail.gmail.com> <20131015024452.GA31951@srcf.ucam.org> <20131016202123.GA17866@google.com> <CAMxnaaV1DhaxKo6h85Upa8sPQz2jSYSaW1OJ7+JtvR5F9sAYZw@mail.gmail.com> <CAErSpo4q0rcvkHX3_L2rcJrwT-Ofu4My8JXxtxH8gyULLxTDEw@mail.gmail.com> <CAE9FiQUMKSak4tWiyZ-N1_50M5ytUp-JAhb7GTG29Y1aRBPuSQ@mail.gmail.com> <CAErSpo5yhg1EgJmmOtJeh0myd50tJuu6qVMdVnwR276WTxL8kg@mail.gmail.com> <20131115115235.GA2281@intel.com> <20131119013343.GA17294@google.com>
In-Reply-To: <20131119013343.GA17294@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The pcie_portdrv .probe() method calls pci_enable_device() once, in
> pcie_port_device_register(), but the .remove() method calls
> pci_disable_device() twice, in pcie_port_device_remove() and in
> pcie_portdrv_remove().
> 
> That causes a "disabling already-disabled device" warning when removing a
> PCIe port device.  This happens all the time when removing Thunderbolt
> devices, but is also easy to reproduce with, e.g.,
> "echo 0000:00:1c.3 > /sys/bus/pci/drivers/pcieport/unbind"
> 
> This patch removes the disable from pcie_portdrv_remove().
> 
> [bhelgaas: changelog, tag for stable]
> Reported-by: David Bulkow <David.Bulkow@stratus.com>
> Reported-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> CC: stable@vger.kernel.org	# v2.6.32+

Hi Bjorn,
   This issue in X86 seems to be introduced after commit 928bea9 "PCI: Delay enabling bridges until they're needed"
So this patch needs to back port to 2.6.32+ ?

> ---
>  drivers/pci/pcie/portdrv_pci.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
> index cd1e57e51aa7..0d8fdc48e642 100644
> --- a/drivers/pci/pcie/portdrv_pci.c
> +++ b/drivers/pci/pcie/portdrv_pci.c
> @@ -223,7 +223,6 @@ static int pcie_portdrv_probe(struct pci_dev *dev,
>  static void pcie_portdrv_remove(struct pci_dev *dev)
>  {
>  	pcie_port_device_remove(dev);
> -	pci_disable_device(dev);
>  }
>  
>  static int error_detected_iter(struct device *device, void *data)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> .
> 


-- 
Thanks!
Yijing

