Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815AbaAHNp6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 08:45:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20045 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755903AbaAHNpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:45:54 -0500
Message-ID: <1389188753.3209.156.camel@bling.home>
Subject: Re: [PATCH v2 5/7] vfio: Use new interfaces for MSI/MSI-X enablement
From: Alex Williamson <alex.williamson@redhat.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org
Date: Wed, 08 Jan 2014 06:45:53 -0700
In-Reply-To: <20140108075757.GB20157@dhcp-26-207.brq.redhat.com>
References: <cover.1389103215.git.agordeev@redhat.com>
	 <1c2ab7cdd9f18f98ee86c73b182f4ee0697f7495.1389103215.git.agordeev@redhat.com>
	 <1389119653.3209.124.camel@bling.home>
	 <20140108074224.GA20157@dhcp-26-207.brq.redhat.com>
	 <20140108075757.GB20157@dhcp-26-207.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-08 at 08:57 +0100, Alexander Gordeev wrote:
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

Based on your description, this is a user visible API change.  We now
return success so long as we allocated at least a single vector and the
user has no way to know that they didn't get all the vectors they
requested.  That's unacceptable, userspace expects the old API - setup
the requested vectors or setup none and tell me how many to retry with.
To maintain the same API exposed to userspace, I'd think we need
something like:

if (ret != nvec) {
	if (ret > 0)
		pci_disable...
	kfree(...
	kfree(...
	return ret;
}

Thanks,
Alex

