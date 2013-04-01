Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578Ab3DAPQP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 11:16:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758362Ab3DAPQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 11:16:13 -0400
Message-ID: <1364829361.2882.26.camel@bling.home>
Subject: Re: [PATCH] PCI/VFIO: use pcie_flags_reg instead of access PCI-E
 Capabilities Register
From: Alex Williamson <alex.williamson@redhat.com>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Hanjun Guo <guohanjun@huawei.com>, jiang.liu@huawei.com
Date: Mon, 01 Apr 2013 09:16:01 -0600
In-Reply-To: <1364375140-6388-1-git-send-email-wangyijing@huawei.com>
References: <1364375140-6388-1-git-send-email-wangyijing@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-27 at 17:05 +0800, Yijing Wang wrote:
> Currently, we use pcie_flags_reg to cache PCI-E Capabilities Register,
> because PCI-E Capabilities Register bits are almost read-only. This patch
> use pcie_flags_reg instead of another access PCI-E Capabilities Register.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> ---
>  drivers/vfio/pci/vfio_pci_config.c |    6 +-----
>  1 files changed, 1 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index aeb00fc..afc6ca4 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -1017,13 +1017,9 @@ static int vfio_cap_len(struct vfio_pci_device *vdev, u8 cap, u8 pos)
>  		return byte;
>  	case PCI_CAP_ID_EXP:
>  		/* length based on version */
> -		ret = pci_read_config_word(pdev, pos + PCI_EXP_FLAGS, &word);
> -		if (ret)
> -			return pcibios_err_to_errno(ret);
> -
>  		vdev->extended_caps = true;
>  
> -		if ((word & PCI_EXP_FLAGS_VERS) == 1)
> +		if ((pdev->pcie_flags_reg & PCI_EXP_FLAGS_VERS) == 1)

It looks like we should be using pcie_caps_reg(pdev) here instead of
directly accessing pcie_flags_reg.  Thanks,

Alex

>  			return PCI_CAP_EXP_ENDPOINT_SIZEOF_V1;
>  		else
>  			return PCI_CAP_EXP_ENDPOINT_SIZEOF_V2;



