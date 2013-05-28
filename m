Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749Ab3E1DPW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:15:22 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:40403 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758717Ab3E1DPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:15:21 -0400
Message-ID: <51A42137.9090908@huawei.com>
Date: Tue, 28 May 2013 11:15:03 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>, Jon Mason <jdmason@kudzu.us>
CC: Yijing Wang <wangyijing@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, Yijing Wang <wangyijing0307@gmail.com>,
        Hanjun Guo <guohanjun@huawei.com>, <jiang.liu@huawei.com>,
        Joe Jin <joe.jin@oracle.com>
Subject: Re: [PATCH] PCI: update device mps when doing pci hotplug
References: <1360036520-31032-1-git-send-email-wangyijing@huawei.com>
In-Reply-To: <1360036520-31032-1-git-send-email-wangyijing@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn and Jon,
   I'm sorry to disturb you. This patch is sent so long, but nobody seems had comment about it.
Do you have any comment with this patch?

This patch try to update device mps in following case:
1) target device under root port
   Because root port can split TLP, so target device mps greatr than root port mps is ok.
   But if root port mps greater than target device mps, it's bad, because target device cannot
   receive TLP payload size greater than its MPS. So if a target device under a root port, I think
   we should assign its mps greater than or equal root port mps.
2) target device under non root port
   We assume the target device both is a transmitter and receiver, so the safest way is to assign target
   device mps equal to its parent device.

Any comments about this patch is welcome!

Thanks!
Yijing.

On 2013/2/5 11:55, Yijing Wang wrote:
> Currently we dont't update device's mps vaule when doing
> pci device hot-add. The hot-added device's mps will be set
> to default value (128B). But the upstream port device's mps
> may be larger than 128B which was set by firmware during
> system bootup. In this case the new added device may not
> work normally.
> 
> The reference discussion at
> http://marc.info/?l=linux-pci&m=135420434508910&w=2
> and
> http://marc.info/?l=linux-pci&m=134815603407842&w=2
> 
> Reported-by: Joe Jin <joe.jin@oracle.com>
> Reported-by: Yijing Wang <wangyijing@huawei.com>
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> Cc: Jon Mason <jdmason@kudzu.us>
> ---
>  drivers/pci/probe.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 49 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index bbe4be7..57d9a5b 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1556,6 +1556,52 @@ static int pcie_bus_configure_set(struct pci_dev *dev, void *data)
>  	return 0;
>  }
>  
> +static int pcie_bus_update_set(struct pci_dev *dev, void *data)
> +{
> +	int mps, p_mps;
> +
> +	if (!pci_is_pcie(dev) || !dev->bus->self)
> +		return 0;
> +
> +	mps = pcie_get_mps(dev);
> +	p_mps = pcie_get_mps(dev->bus->self);
> +
> +	if (pci_pcie_type(dev->bus->self) != PCI_EXP_TYPE_ROOT_PORT) {
> +		/* update mps when current device mps is not equal to upstream mps */
> +		if (mps != p_mps)
> +			goto update;
> +	} else {
> +		/* update mps when current device mps is smaller than upstream mps */
> +		if (mps < p_mps)
> +			goto update;
> +	}
> +
> +	return 0;
> +
> +update:
> +	/* If current mpss is lager than upstream, use upstream mps to update
> +	 * current mps, otherwise print warning info.
> +	 */
> +	if ((128 << dev->pcie_mpss) >= p_mps)
> +		pcie_write_mps(dev, p_mps);
> +	else
> +		dev_warn(&dev->dev, "MPS %d MPSS %d both smaller than upstream MPS %d\n"
> +				"If necessary, use \"pci=pcie_bus_peer2peer\" boot parameter to avoid this problem\n",
> +				mps, 128 << dev->pcie_mpss, p_mps);
> +	return 0;
> +}
> +
> +static void pcie_bus_update_setting(struct pci_bus *bus)
> +{
> +
> +	/*
> +	 * After hot added a pci device, the device's mps will set to default
> +	 * vaule(128 bytes). But the upstream port mps may be larger than 128B.
> +	 * In this case, we should update this device's mps for better performance.
> +	 */
> +	pci_walk_bus(bus, pcie_bus_update_set, NULL);
> +}
> +
>  /* pcie_bus_configure_settings requires that pci_walk_bus work in a top-down,
>   * parents then children fashion.  If this changes, then this code will not
>   * work as designed.
> @@ -1566,6 +1612,9 @@ void pcie_bus_configure_settings(struct pci_bus *bus, u8 mpss)
>  
>  	if (!pci_is_pcie(bus->self))
>  		return;
> +
> +	/* update mps setting for newly hot added device */
> +	pcie_bus_update_setting(bus);
>  
>  	if (pcie_bus_config == PCIE_BUS_TUNE_OFF)
>  		return;
> 


-- 
Thanks!
Yijing

