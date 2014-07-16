Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbaGPVLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:11:31 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:60353 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660AbaGPVK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:10:56 -0400
Date: Wed, 16 Jul 2014 15:10:52 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: Frank Haverkamp <haver@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] misc/GenWQE: fix pci_enable_msi usage
Message-ID: <20140716211052.GC14366@google.com>
References: <alpine.LFD.2.11.1407091237030.1590@denkbrett>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1407091237030.1590@denkbrett>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc linux-pci]

On Wed, Jul 09, 2014 at 12:46:39PM +0200, Sebastian Ott wrote:
> GenWQE used to call pci_enable_msi_block to allocate a desired number
> of MSI's. If that was not possible pci_enable_msi_block returned with a
> smaller number which might be possible to allocate. GenWQE then called
> pci_enable_msi_block with that number.
> 
> Since commit a30d0108b
> "GenWQE: Use pci_enable_msi_exact() instead of pci_enable_msi_block()"
> pci_enable_msi_exact is used which fails if the desired number of MSI's
> was not possible to allocate. Change GenWQE to use pci_enable_msi_range
> to restore the old behavior.
> 
> Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>

Since this fixes a30d0108b09a, which we merged via my tree in v3.16-rc1, I
applied this with Alexander and Frank's acks to for-linus for v3.16,
thanks!

> ---
>  drivers/misc/genwqe/card_ddcb.c  |  4 +---
>  drivers/misc/genwqe/card_utils.c | 10 ++++++----
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/misc/genwqe/card_ddcb.c b/drivers/misc/genwqe/card_ddcb.c
> index c8046db..f66d43d 100644
> --- a/drivers/misc/genwqe/card_ddcb.c
> +++ b/drivers/misc/genwqe/card_ddcb.c
> @@ -1237,9 +1237,7 @@ int genwqe_setup_service_layer(struct genwqe_dev *cd)
>  	}
>  
>  	rc = genwqe_set_interrupt_capability(cd, GENWQE_MSI_IRQS);
> -	if (rc > 0)
> -		rc = genwqe_set_interrupt_capability(cd, rc);
> -	if (rc != 0) {
> +	if (rc) {
>  		rc = -ENODEV;
>  		goto stop_kthread;
>  	}
> diff --git a/drivers/misc/genwqe/card_utils.c b/drivers/misc/genwqe/card_utils.c
> index 62cc6bb..6abc437 100644
> --- a/drivers/misc/genwqe/card_utils.c
> +++ b/drivers/misc/genwqe/card_utils.c
> @@ -718,10 +718,12 @@ int genwqe_set_interrupt_capability(struct genwqe_dev *cd, int count)
>  	int rc;
>  	struct pci_dev *pci_dev = cd->pci_dev;
>  
> -	rc = pci_enable_msi_exact(pci_dev, count);
> -	if (rc == 0)
> -		cd->flags |= GENWQE_FLAG_MSI_ENABLED;
> -	return rc;
> +	rc = pci_enable_msi_range(pci_dev, 1, count);
> +	if (rc < 0)
> +		return rc;
> +
> +	cd->flags |= GENWQE_FLAG_MSI_ENABLED;
> +	return 0;
>  }
>  
>  /**
> -- 
> 1.9.3
> 
