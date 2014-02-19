Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021AbaBSSJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 13:09:49 -0500
Received: from mga09.intel.com ([134.134.136.24]:29587 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754954AbaBSSJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 13:09:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,507,1389772800"; 
   d="scan'208";a="458256056"
Date: Wed, 19 Feb 2014 11:09:27 -0700
From: Jon Mason <jon.mason@intel.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] ntb: Use pci_enable_msix_range() instead of
 pci_enable_msix()
Message-ID: <20140219180926.GA1333@jonmason-lab>
References: <1392804931-30671-1-git-send-email-agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392804931-30671-1-git-send-email-agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 11:15:21AM +0100, Alexander Gordeev wrote:
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range() and pci_enable_msix_range()
> interfaces.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Jon Mason <jon.mason@intel.com>
> Cc: linux-pci@vger.kernel.org
> ---
>  drivers/ntb/ntb_hw.c |   43 ++++++++++++++++---------------------------
>  drivers/ntb/ntb_hw.h |    2 --
>  2 files changed, 16 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
> index 170e8e6..fda37eb 100644
> --- a/drivers/ntb/ntb_hw.c
> +++ b/drivers/ntb/ntb_hw.c
> @@ -1085,21 +1085,15 @@ static int ntb_setup_msix(struct ntb_device *ndev)
>  	struct msix_entry *msix;
>  	int msix_entries;
>  	int rc, i;
> -	u16 val;
>  
> -	if (!pdev->msix_cap) {
> -		rc = -EIO;
> -		goto err;
> -	}
> -
> -	rc = pci_read_config_word(pdev, pdev->msix_cap + PCI_MSIX_FLAGS, &val);
> -	if (rc)
> +	rc = pci_msix_vec_count(pdev);

Nit, you should probably use msix_entries instead of rc in this case.

> +	if (rc < 0) {
>  		goto err;
> -
> -	msix_entries = msix_table_size(val);
> -	if (msix_entries > ndev->limits.msix_cnt) {
> +	} else if (rc > ndev->limits.msix_cnt) {
>  		rc = -EINVAL;
>  		goto err;
> +	} else {
> +		msix_entries = rc;
>  	}

Style Nit.  Braces with only one line.  If you make the change above,
then it is moot.

>  
>  	ndev->msix_entries = kmalloc(sizeof(struct msix_entry) * msix_entries,
> @@ -1112,26 +1106,21 @@ static int ntb_setup_msix(struct ntb_device *ndev)
>  	for (i = 0; i < msix_entries; i++)
>  		ndev->msix_entries[i].entry = i;
>  
> -	rc = pci_enable_msix(pdev, ndev->msix_entries, msix_entries);
> -	if (rc < 0)
> -		goto err1;
> -	if (rc > 0) {
> +	if (ndev->hw_type != BWD_HW)
>  		/* On SNB, the link interrupt is always tied to 4th vector.  If
>  		 * we can't get all 4, then we can't use MSI-X.
>  		 */
> -		if (ndev->hw_type != BWD_HW) {
> -			rc = -EIO;
> -			goto err1;
> -		}
> -
> -		dev_warn(&pdev->dev,
> -			 "Only %d MSI-X vectors.  Limiting the number of queues to that number.\n",
> -			 rc);
> +		rc = pci_enable_msix_range(pdev, ndev->msix_entries,
> +					   msix_entries, msix_entries);
> +	else
> +		rc = pci_enable_msix_range(pdev, ndev->msix_entries,
> +					   1, msix_entries);

Actually, this must be 2 for the min.  One for the Data and one for
the Link.  If you look a few lines after this in the original code,
there is a grabbing of the last vector for the link.  I realize there
is currently no check for this in the driver and a potential error
case occurs.  I can make a separate patch to correct this issue if
this patch is not going through my tree.

Thanks,
Jon


> +	if (rc < 0)
> +		goto err1;
> +	else if (rc < msix_entries) {
> +		dev_warn(&pdev->dev, "Only %d MSI-X vectors. "
> +			 "Limiting the number of queues to that number.\n", rc);
>  		msix_entries = rc;
> -
> -		rc = pci_enable_msix(pdev, ndev->msix_entries, msix_entries);
> -		if (rc)
> -			goto err1;
>  	}
>  
>  	for (i = 0; i < msix_entries; i++) {
> diff --git a/drivers/ntb/ntb_hw.h b/drivers/ntb/ntb_hw.h
> index bbdb7ed..d307107 100644
> --- a/drivers/ntb/ntb_hw.h
> +++ b/drivers/ntb/ntb_hw.h
> @@ -60,8 +60,6 @@
>  #define PCI_DEVICE_ID_INTEL_NTB_SS_HSX		0x2F0F
>  #define PCI_DEVICE_ID_INTEL_NTB_B2B_BWD		0x0C4E
>  
> -#define msix_table_size(control)	((control & PCI_MSIX_FLAGS_QSIZE)+1)
> -
>  #ifndef readq
>  static inline u64 readq(void __iomem *addr)
>  {
> -- 
> 1.7.7.6
> 
