Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbaCKRUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 13:20:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:3315 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439AbaCKRUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 13:20:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,632,1389772800"; 
   d="scan'208";a="470340744"
Date: Tue, 11 Mar 2014 10:15:24 -0700
From: Jon Mason <jon.mason@intel.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 4/4] ntb: Use pci_enable_msix_range() instead of
 pci_enable_msix()
Message-ID: <20140311171524.GB26040@jonmason-lab>
References: <cover.1392996332.git.agordeev@redhat.com>
 <0afccb5cf0710f980b47e57c4e9b27eeb3033955.1392996332.git.agordeev@redhat.com>
 <20140311160034.GB25638@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140311160034.GB25638@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 05:00:35PM +0100, Alexander Gordeev wrote:
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range()  or pci_enable_msi_exact()
> and pci_enable_msix_range() or pci_enable_msix_exact()
> interfaces.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Jon Mason <jon.mason@intel.com>

Looks good.  I will include it in my next release of the NTB driver
(e.g. 3.15).

Thanks,
Jon

> Cc: linux-pci@vger.kernel.org
> ---
>  drivers/ntb/ntb_hw.c |   20 +++++---------------
>  1 files changed, 5 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
> index 1f8decd..ff5c0a3 100644
> --- a/drivers/ntb/ntb_hw.c
> +++ b/drivers/ntb/ntb_hw.c
> @@ -1088,11 +1088,9 @@ static int ntb_setup_snb_msix(struct ntb_device *ndev, int msix_entries)
>  	if (msix_entries < ndev->limits.msix_cnt)
>  		return -ENOSPC;
>  
> -	rc = pci_enable_msix(pdev, ndev->msix_entries, msix_entries);
> +	rc = pci_enable_msix_exact(pdev, ndev->msix_entries, msix_entries);
>  	if (rc < 0)
>  		return rc;
> -	else if (rc > 0)
> -		return -ENOSPC;
>  
>  	for (i = 0; i < msix_entries; i++) {
>  		msix = &ndev->msix_entries[i];
> @@ -1138,18 +1136,10 @@ static int ntb_setup_bwd_msix(struct ntb_device *ndev, int msix_entries)
>  	struct msix_entry *msix;
>  	int rc, i;
>  
> -retry:
> -	rc = pci_enable_msix(pdev, ndev->msix_entries, msix_entries);
> -	if (rc < 0)
> -		return rc;
> -	else if (rc > 0) {
> -		dev_warn(&pdev->dev,
> -			 "Only %d MSI-X vectors. "
> -			 "Limiting the number of queues to that number.\n",
> -			 rc);
> -		msix_entries = rc;
> -		goto retry;
> -	}
> +	msix_entries = pci_enable_msix_range(pdev, ndev->msix_entries,
> +					     1, msix_entries);
> +	if (msix_entries < 0)
> +		return msix_entries;
>  
>  	for (i = 0; i < msix_entries; i++) {
>  		msix = &ndev->msix_entries[i];
> -- 
> 1.7.7.6
> 
> -- 
> Regards,
> Alexander Gordeev
> agordeev@redhat.com
