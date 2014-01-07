Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbaAGSeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 13:34:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349AbaAGSeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 13:34:14 -0500
Message-ID: <1389119653.3209.124.camel@bling.home>
Subject: Re: [PATCH 5/7] vfio: Use new interfaces for MSI/MSI-X enablement
From: Alex Williamson <alex.williamson@redhat.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org
Date: Tue, 07 Jan 2014 11:34:13 -0700
In-Reply-To: <1c2ab7cdd9f18f98ee86c73b182f4ee0697f7495.1389103215.git.agordeev@redhat.com>
References: <cover.1389103215.git.agordeev@redhat.com>
	 <1c2ab7cdd9f18f98ee86c73b182f4ee0697f7495.1389103215.git.agordeev@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-07 at 19:05 +0100, Alexander Gordeev wrote:
> This update also fixes a bug when deprecated pci_enable_msix()
> and pci_enable_msi_block() functions return a positive return
> value which indicats the number of interrupts that could have
> been allocated rather than a successful allocation. The driver
> misinterpreted this value and assumed MSI-X/MSIs are enabled,
> although in fact it were not.

No, the driver interpreted it correctly, which is why anything other
than zero is handled as an error.  This patch looks incorrect if the new
interfaces follow the same return convention.  Thanks,

Alex

> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  drivers/vfio/pci/vfio_pci_intrs.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> index 641bc87..66d1746 100644
> --- a/drivers/vfio/pci/vfio_pci_intrs.c
> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> @@ -482,15 +482,15 @@ static int vfio_msi_enable(struct vfio_pci_device *vdev, int nvec, bool msix)
>  		for (i = 0; i < nvec; i++)
>  			vdev->msix[i].entry = i;
>  
> -		ret = pci_enable_msix(pdev, vdev->msix, nvec);
> -		if (ret) {
> +		ret = pci_enable_msix_range(pdev, vdev->msix, nvec, nvec);
> +		if (ret < 0) {
>  			kfree(vdev->msix);
>  			kfree(vdev->ctx);
>  			return ret;
>  		}
>  	} else {
> -		ret = pci_enable_msi_block(pdev, nvec);
> -		if (ret) {
> +		ret = pci_enable_msi_range(pdev, nvec, nvec);
> +		if (ret < 0) {
>  			kfree(vdev->ctx);
>  			return ret;
>  		}



