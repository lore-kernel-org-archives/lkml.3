Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaAMTM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 14:12:28 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:65147 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaAMTMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 14:12:24 -0500
Date: Mon, 13 Jan 2014 12:12:20 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        linux-ide@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 3/7] ahci: Use new interfaces for MSI/MSI-X enablement
Message-ID: <20140113191220.GA6525@google.com>
References: <cover.1389103215.git.agordeev@redhat.com>
 <7fe2a5563efac19c87213a48b58cae6b4d76c91d.1389103215.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fe2a5563efac19c87213a48b58cae6b4d76c91d.1389103215.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 07:05:38PM +0100, Alexander Gordeev wrote:
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  drivers/ata/ahci.c |   15 ++++++---------
>  1 files changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> index 8516f4d..cfdb079 100644
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
> @@ -1098,13 +1098,13 @@ static inline void ahci_gtf_filter_workaround(struct ata_host *host)
>  int ahci_init_interrupts(struct pci_dev *pdev, unsigned int n_ports,
>  			 struct ahci_host_priv *hpriv)
>  {
> -	int rc, nvec;
> +	int nvec;
>  
>  	if (hpriv->flags & AHCI_HFLAG_NO_MSI)
>  		goto intx;
>  
> -	rc = pci_msi_vec_count(pdev);
> -	if (rc < 0)
> +	nvec = pci_msi_vec_count(pdev);
> +	if (nvec < 0)
>  		goto intx;
>  
>  	/*
> @@ -1112,19 +1112,16 @@ int ahci_init_interrupts(struct pci_dev *pdev, unsigned int n_ports,
>  	 * Message mode could be enforced. In this case assume that advantage
>  	 * of multipe MSIs is negated and use single MSI mode instead.
>  	 */
> -	if (rc < n_ports)
> +	if (nvec < n_ports)
>  		goto single_msi;
>  
> -	nvec = rc;
> -	rc = pci_enable_msi_block(pdev, nvec);
> -	if (rc)
> +	if (pci_enable_msi_range(pdev, nvec, nvec) < 0)
>  		goto intx;
>  
>  	return nvec;
>  
>  single_msi:
> -	rc = pci_enable_msi(pdev);
> -	if (rc)
> +	if (pci_enable_msi_range(pdev, 1, 1) < 0)

This part doesn't seem like an improvement.  There are a hundred or so
callers of pci_enable_msi() that only want a single MSI.  Is there any
benefit in changing them to use pci_enable_msi_range()?

I guess I agreed (maybe even suggested) to deprecate pci_enable_msi(),
but it doesn't suffer from the tri-state return value problem, and I'm
having second thoughts.

>  		goto intx;
>  	return 1;
>  
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
