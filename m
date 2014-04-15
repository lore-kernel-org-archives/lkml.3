Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbaDOMHF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:07:05 -0400
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:1475 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751052AbaDOMHD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:07:03 -0400
From: Shahed Shaikh <shahed.shaikh@qlogic.com>
To: Alexander Gordeev <agordeev@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: Dept-HSG Linux NIC Dev <Dept-HSGLinuxNICDev@qlogic.com>,
        netdev <netdev@vger.kernel.org>, linux-pci <linux-pci@vger.kernel.org>
Subject: RE: [PATCH] qlcnic: Fix MSI-X initialization code
Thread-Topic: [PATCH] qlcnic: Fix MSI-X initialization code
Thread-Index: AQHPWI4OPmjzFN8Ow0aTTNgnm8/JaZsSk9LA
Date: Tue, 15 Apr 2014 12:06:58 +0000
Message-ID: <262CB373A6D1F14F9B81E82F74F77D5A46F910CF@avmb2.qlogic.org>
References: <1397554634-26795-1-git-send-email-agordeev@redhat.com>
In-Reply-To: <1397554634-26795-1-git-send-email-agordeev@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.4.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7408 signatures=670416
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1402240000 definitions=main-1404150201
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Alexander Gordeev [mailto:agordeev@redhat.com]
> Sent: Tuesday, April 15, 2014 3:07 PM
> To: linux-kernel
> Cc: Alexander Gordeev; Shahed Shaikh; Dept-HSG Linux NIC Dev; netdev;
> linux-pci
> Subject: [PATCH] qlcnic: Fix MSI-X initialization code
> 
> Function qlcnic_setup_tss_rss_intr() might enter endless loop in case
> pci_enable_msix() contiguously returns a positive number of MSI-Xs that
> could have been allocated.
> Besides, the function contains 'err = -EIO;' assignment that never could be
> reached. This update fixes the aforementioned issues.
> 
> Cc: Shahed Shaikh <shahed.shaikh@qlogic.com>
> Cc: Dept-HSGLinuxNICDev@qlogic.com
> Cc: netdev@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>

Acked-by: Shahed Shaikh <shahed.shaikh@qlogic.com>

Thanks,
Shahed
> ---
>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c |   28 ++++++++++++-------
> --
>  1 files changed, 16 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
> b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
> index 309d056..2e615d5 100644
> --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
> +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
> @@ -670,7 +670,7 @@ int qlcnic_setup_tss_rss_intr(struct qlcnic_adapter
> *adapter)
>  	else
>  		num_msix += adapter->drv_tx_rings;
> 
> -	if (adapter->drv_rss_rings  > 0)
> +	if (adapter->drv_rss_rings > 0)
>  		num_msix += adapter->drv_rss_rings;
>  	else
>  		num_msix += adapter->drv_sds_rings;
> @@ -686,19 +686,15 @@ int qlcnic_setup_tss_rss_intr(struct qlcnic_adapter
> *adapter)
>  			return -ENOMEM;
>  	}
> 
> -restore:
>  	for (vector = 0; vector < num_msix; vector++)
>  		adapter->msix_entries[vector].entry = vector;
> 
> +restore:
>  	err = pci_enable_msix(pdev, adapter->msix_entries, num_msix);
> -	if (err == 0) {
> -		adapter->ahw->num_msix = num_msix;
> -		if (adapter->drv_tss_rings > 0)
> -			adapter->drv_tx_rings = adapter->drv_tss_rings;
> +	if (err > 0) {
> +		if (!adapter->drv_tss_rings && !adapter->drv_rss_rings)
> +			return -ENOSPC;
> 
> -		if (adapter->drv_rss_rings > 0)
> -			adapter->drv_sds_rings = adapter->drv_rss_rings;
> -	} else {
>  		netdev_info(adapter->netdev,
>  			    "Unable to allocate %d MSI-X vectors, Available
> vectors %d\n",
>  			    num_msix, err);
> @@ -716,12 +712,20 @@ restore:
>  			    "Restoring %d Tx, %d SDS rings for total %d
> vectors.\n",
>  			    adapter->drv_tx_rings, adapter->drv_sds_rings,
>  			    num_msix);
> -		goto restore;
> 
> -		err = -EIO;
> +		goto restore;
> +	} else if (err < 0) {
> +		return err;
>  	}
> 
> -	return err;
> +	adapter->ahw->num_msix = num_msix;
> +	if (adapter->drv_tss_rings > 0)
> +		adapter->drv_tx_rings = adapter->drv_tss_rings;
> +
> +	if (adapter->drv_rss_rings > 0)
> +		adapter->drv_sds_rings = adapter->drv_rss_rings;
> +
> +	return 0;
>  }
> 
>  int qlcnic_enable_msix(struct qlcnic_adapter *adapter, u32 num_msix)
> --
> 1.7.7.6

