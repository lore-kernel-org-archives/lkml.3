Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688AbaAaRWG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 12:22:06 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:7456 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236AbaAaRWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 12:22:04 -0500
Message-ID: <52EBDBB7.9010503@solarflare.com>
Date: Fri, 31 Jan 2014 17:21:59 +0000
From: Shradha Shah <sshah@solarflare.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>
CC: <linux-kernel@vger.kernel.org>,
        Solarflare maintainers <linux-net-drivers@solarflare.com>,
        <netdev@vger.kernel.org>, <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 31/34] efx: Use pci_enable_msix_range()
References: <cover.1391172839.git.agordeev@redhat.com> <433fe68f834c10679986274f4bb605aa4ed5eaf3.1391172839.git.agordeev@redhat.com>
In-Reply-To: <433fe68f834c10679986274f4bb605aa4ed5eaf3.1391172839.git.agordeev@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.135]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20472.005
X-TM-AS-Result: No--7.867500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2014 03:08 PM, Alexander Gordeev wrote:
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range() and pci_enable_msix_range()
> interfaces.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>

Acked-by: Shradha Shah <sshah@solarflare.com>

> ---
>  drivers/net/ethernet/sfc/efx.c |   20 +++++++++-----------
>  1 files changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
> index 83d4643..297b97a 100644
> --- a/drivers/net/ethernet/sfc/efx.c
> +++ b/drivers/net/ethernet/sfc/efx.c
> @@ -1346,20 +1346,23 @@ static int efx_probe_interrupts(struct efx_nic *efx)
>  
>  		for (i = 0; i < n_channels; i++)
>  			xentries[i].entry = i;
> -		rc = pci_enable_msix(efx->pci_dev, xentries, n_channels);
> -		if (rc > 0) {
> +		rc = pci_enable_msix_range(efx->pci_dev,
> +					   xentries, 1, n_channels);
> +		if (rc < 0) {
> +			/* Fall back to single channel MSI */
> +			efx->interrupt_mode = EFX_INT_MODE_MSI;
> +			netif_err(efx, drv, efx->net_dev,
> +				  "could not enable MSI-X\n");
> +		} else if (rc < n_channels) {
>  			netif_err(efx, drv, efx->net_dev,
>  				  "WARNING: Insufficient MSI-X vectors"
>  				  " available (%d < %u).\n", rc, n_channels);
>  			netif_err(efx, drv, efx->net_dev,
>  				  "WARNING: Performance may be reduced.\n");
> -			EFX_BUG_ON_PARANOID(rc >= n_channels);
>  			n_channels = rc;
> -			rc = pci_enable_msix(efx->pci_dev, xentries,
> -					     n_channels);
>  		}
>  
> -		if (rc == 0) {
> +		if (rc > 0) {
>  			efx->n_channels = n_channels;
>  			if (n_channels > extra_channels)
>  				n_channels -= extra_channels;
> @@ -1375,11 +1378,6 @@ static int efx_probe_interrupts(struct efx_nic *efx)
>  			for (i = 0; i < efx->n_channels; i++)
>  				efx_get_channel(efx, i)->irq =
>  					xentries[i].vector;
> -		} else {
> -			/* Fall back to single channel MSI */
> -			efx->interrupt_mode = EFX_INT_MODE_MSI;
> -			netif_err(efx, drv, efx->net_dev,
> -				  "could not enable MSI-X\n");
>  		}
>  	}
>  
> 
