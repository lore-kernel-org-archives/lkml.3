Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbaA2VhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 16:37:24 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:60943 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbaA2VhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 16:37:20 -0500
Date: Wed, 29 Jan 2014 14:37:16 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 9/9] wil6210: Use pci_enable_msi_range()
Message-ID: <20140129213716.GD16825@google.com>
References: <cover.1389904166.git.agordeev@redhat.com>
 <aedc9b7eb82232204a7d65b4c7d3302ba6ba3892.1389904167.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aedc9b7eb82232204a7d65b4c7d3302ba6ba3892.1389904167.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 05:02:23PM +0100, Alexander Gordeev wrote:
> As result deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range() and pci_enable_msix_range()
> interfaces.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Acked-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

Applied to my pci/msi branch, thanks!

> ---
>  drivers/net/wireless/ath/wil6210/pcie_bus.c |   36 ++++++++++++++------------
>  1 files changed, 19 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
> index eeceab3..4e1bf54 100644
> --- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
> +++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
> @@ -41,30 +41,32 @@ static int wil_if_pcie_enable(struct wil6210_priv *wil)
>  	switch (use_msi) {
>  	case 3:
>  	case 1:
> +		wil_dbg_misc(wil, "Setup %d MSI interrupts\n", use_msi);
> +		break;
>  	case 0:
> +		wil_dbg_misc(wil, "MSI interrupts disabled, use INTx\n");
>  		break;
>  	default:
> -		wil_err(wil, "Invalid use_msi=%d, default to 1\n",
> -			use_msi);
> +		wil_err(wil, "Invalid use_msi=%d, default to 1\n", use_msi);
>  		use_msi = 1;
>  	}
> -	wil->n_msi = use_msi;
> -	if (wil->n_msi) {
> -		wil_dbg_misc(wil, "Setup %d MSI interrupts\n", use_msi);
> -		rc = pci_enable_msi_block(pdev, wil->n_msi);
> -		if (rc && (wil->n_msi == 3)) {
> -			wil_err(wil, "3 MSI mode failed, try 1 MSI\n");
> -			wil->n_msi = 1;
> -			rc = pci_enable_msi_block(pdev, wil->n_msi);
> -		}
> -		if (rc) {
> -			wil_err(wil, "pci_enable_msi failed, use INTx\n");
> -			wil->n_msi = 0;
> -		}
> -	} else {
> -		wil_dbg_misc(wil, "MSI interrupts disabled, use INTx\n");
> +
> +	switch (use_msi) {
> +	case 3:
> +		if (pci_enable_msi_range(pdev, 3, 3) > 0)
> +			break;
> +		wil_err(wil, "3 MSI mode failed, try 1 MSI\n");
> +		use_msi = 1;
> +		/* fallthrough */
> +	case 1:
> +		if (!pci_enable_msi(pdev))
> +			break;
> +		wil_err(wil, "pci_enable_msi failed, use INTx\n");
> +		use_msi = 0;
>  	}
>  
> +	wil->n_msi = use_msi;
> +
>  	rc = wil6210_init_irq(wil, pdev->irq);
>  	if (rc)
>  		goto stop_master;
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
