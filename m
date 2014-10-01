Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526AbaJAOD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 10:03:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbaJAOD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:03:58 -0400
Message-ID: <1412172233.7360.203.camel@ul30vt.home>
Subject: Re: [PATCH 1/1] vfio-pci: Add SR-IOV VF configuration via sysfs
From: Alex Williamson <alex.williamson@redhat.com>
To: Andre Richter <andre.o.richter@gmail.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 01 Oct 2014 08:03:53 -0600
In-Reply-To: <1412170733-7187-1-git-send-email-andre.o.richter@gmail.com>
References: <1412170733-7187-1-git-send-email-andre.o.richter@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-01 at 15:38 +0200, Andre Richter wrote:
> If a PCIe device bound to vfio-pci happens to be SR-IOV capabale,
> there is no possibility to bring up/shutdown the device's VFs.
> 
> This patch adds a generic callback for the sysfs sriov_numvfs attribute.
> The attribute will only show up for SR-IOV devices. Additionally,
> each utilized pci_* function checks if the device is a PF.
> 
> Signed-off-by: Andre Richter <andre.o.richter@gmail.com>
> ---
>  drivers/vfio/pci/vfio_pci.c | 25 ++++++++++++++++++++-----
>  1 file changed, 20 insertions(+), 5 deletions(-)

I don't understand why you'd want to do this.  The PF is typically
managed by a host driver.  By allowing vfio-pci to manage SR-IOV, don't
we potentially have assign-able PFs managing assign-able VFs?  That
seems like a bad idea.  What use case do you have in mind?  Thanks,

Alex

> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index f782533..2f6dfb3 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -919,12 +919,27 @@ static struct pci_error_handlers vfio_err_handlers = {
>  	.error_detected = vfio_pci_aer_err_detected,
>  };
>  
> +static int vfio_pci_sriov_configure(struct pci_dev *pdev, int num_vfs)
> +{
> +	int ret = 0;
> +
> +	if (num_vfs > 0) {
> +		ret = pci_enable_sriov(pdev, num_vfs);
> +		if (!ret)
> +			ret = pci_num_vf(pdev);
> +	} else
> +		pci_disable_sriov(pdev);
> +
> +	return ret;
> +}
> +
>  static struct pci_driver vfio_pci_driver = {
> -	.name		= "vfio-pci",
> -	.id_table	= NULL, /* only dynamic ids */
> -	.probe		= vfio_pci_probe,
> -	.remove		= vfio_pci_remove,
> -	.err_handler	= &vfio_err_handlers,
> +	.name			= "vfio-pci",
> +	.id_table		= NULL, /* only dynamic ids */
> +	.probe			= vfio_pci_probe,
> +	.remove			= vfio_pci_remove,
> +	.sriov_configure	= vfio_pci_sriov_configure,
> +	.err_handler		= &vfio_err_handlers,
>  };
>  
>  /*



