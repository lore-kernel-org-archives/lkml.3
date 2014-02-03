Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbaBCGVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 01:21:18 -0500
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:21267 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaBCGVQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 01:21:16 -0500
From: Sathya Perla <Sathya.Perla@Emulex.Com>
To: Alexander Gordeev <agordeev@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Subramanian Seetharaman <subbu.seetharaman@Emulex.Com>,
        Ajit Khaparde <Ajit.Khaparde@Emulex.Com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: RE: [PATCH 11/34] benet: Use pci_enable_msix_range()
Thread-Topic: [PATCH 11/34] benet: Use pci_enable_msix_range()
Thread-Index: AQHPHpfZI+qji0QSN02dZL6JyPB1TpqjEtWw
Date: Mon, 3 Feb 2014 06:21:12 +0000
Message-ID: <e0310928-327b-4318-99dc-66730e261eb7@CMEXHTCAS2.ad.emulex.com>
References: <cover.1391172839.git.agordeev@redhat.com>
 <0ab74b1142006d2e7a8065ec8a2d3ba48fc3ec0c.1391172839.git.agordeev@redhat.com>
In-Reply-To: <0ab74b1142006d2e7a8065ec8a2d3ba48fc3ec0c.1391172839.git.agordeev@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [138.239.141.147]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: netdev-owner@vger.kernel.org [mailto:netdev-owner@vger.kernel.org] On Behalf
> Of Alexander Gordeev
> 
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range() and pci_enable_msix_range()
> interfaces.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>

Acked-by: Sathya Perla < sathya.perla@emulex.com>

> ---
>  drivers/net/ethernet/emulex/benet/be_main.c |   31 +++++++++++---------------
>  1 files changed, 13 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/net/ethernet/emulex/benet/be_main.c
> b/drivers/net/ethernet/emulex/benet/be_main.c
> index 04ac9c6..f55c09b 100644
> --- a/drivers/net/ethernet/emulex/benet/be_main.c
> +++ b/drivers/net/ethernet/emulex/benet/be_main.c
> @@ -2505,7 +2505,7 @@ static void be_msix_disable(struct be_adapter *adapter)
> 
>  static int be_msix_enable(struct be_adapter *adapter)
>  {
> -	int i, status, num_vec;
> +	int i, num_vec;
>  	struct device *dev = &adapter->pdev->dev;
> 
>  	/* If RoCE is supported, program the max number of NIC vectors that
> @@ -2521,24 +2521,11 @@ static int be_msix_enable(struct be_adapter *adapter)
>  	for (i = 0; i < num_vec; i++)
>  		adapter->msix_entries[i].entry = i;
> 
> -	status = pci_enable_msix(adapter->pdev, adapter->msix_entries, num_vec);
> -	if (status == 0) {
> -		goto done;
> -	} else if (status >= MIN_MSIX_VECTORS) {
> -		num_vec = status;
> -		status = pci_enable_msix(adapter->pdev, adapter->msix_entries,
> -					 num_vec);
> -		if (!status)
> -			goto done;
> -	}
> +	num_vec = pci_enable_msix_range(adapter->pdev, adapter->msix_entries,
> +					MIN_MSIX_VECTORS, num_vec);
> +	if (num_vec < 0)
> +		goto fail;
> 
> -	dev_warn(dev, "MSIx enable failed\n");
> -
> -	/* INTx is not supported in VFs, so fail probe if enable_msix fails */
> -	if (!be_physfn(adapter))
> -		return status;
> -	return 0;
> -done:
>  	if (be_roce_supported(adapter) && num_vec > MIN_MSIX_VECTORS) {
>  		adapter->num_msix_roce_vec = num_vec / 2;
>  		dev_info(dev, "enabled %d MSI-x vector(s) for RoCE\n",
> @@ -2550,6 +2537,14 @@ done:
>  	dev_info(dev, "enabled %d MSI-x vector(s) for NIC\n",
>  		 adapter->num_msix_vec);
>  	return 0;
> +
> +fail:
> +	dev_warn(dev, "MSIx enable failed\n");
> +
> +	/* INTx is not supported in VFs, so fail probe if enable_msix fails */
> +	if (!be_physfn(adapter))
> +		return num_vec;
> +	return 0;
>  }
> 
>  static inline int be_msix_vec_get(struct be_adapter *adapter,
> --
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
