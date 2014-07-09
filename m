Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbaGILeF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:34:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889AbaGILeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:34:03 -0400
Date: Wed, 9 Jul 2014 13:34:53 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: Frank Haverkamp <haver@linux.vnet.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] misc/GenWQE: fix pci_enable_msi usage
Message-ID: <20140709113452.GA30650@dhcp-26-207.brq.redhat.com>
References: <alpine.LFD.2.11.1407091237030.1590@denkbrett>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1407091237030.1590@denkbrett>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Reviewed-by: Alexander Gordeev <agordeev@redhat.com>

I am curious though why would you need convert error code to -ENODEV here
(and throughout the code in general)?

Thanks!

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
