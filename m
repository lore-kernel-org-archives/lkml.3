Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932873AbaAaSLv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 13:11:51 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:44611 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932619AbaAaSLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 13:11:48 -0500
Message-ID: <52EBF57F.1060804@cogentembedded.com>
Date: Fri, 31 Jan 2014 22:11:59 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org
CC: Ariel Elior <ariele@broadcom.com>, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 02/34] bnx2x: Use pci_enable_msix_range()
References: <cover.1391172839.git.agordeev@redhat.com> <911884c4e906af8acfa4c06ee3206387449f1d84.1391172839.git.agordeev@redhat.com>
In-Reply-To: <911884c4e906af8acfa4c06ee3206387449f1d84.1391172839.git.agordeev@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01/31/2014 06:08 PM, Alexander Gordeev wrote:

> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range() and pci_enable_msix_range()
> interfaces.

> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>   drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |   48 ++++++++++-------------
>   1 files changed, 21 insertions(+), 27 deletions(-)

> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> index 9d7419e..b396d74 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> @@ -1638,24 +1638,36 @@ int bnx2x_enable_msix(struct bnx2x *bp)
>   	DP(BNX2X_MSG_SP, "about to request enable msix with %d vectors\n",
>   	   msix_vec);
>
> -	rc = pci_enable_msix(bp->pdev, &bp->msix_table[0], msix_vec);
> -
> +	rc = pci_enable_msix_range(bp->pdev, &bp->msix_table[0],
> +				   BNX2X_MIN_MSIX_VEC_CNT(bp), msix_vec);
>   	/*
>   	 * reconfigure number of tx/rx queues according to available
>   	 * MSI-X vectors
>   	 */
> -	if (rc >= BNX2X_MIN_MSIX_VEC_CNT(bp)) {
> +	if (rc < 0) {
> +		BNX2X_DEV_INFO("MSI-X is not attainable rc %d\n", rc);
> +		goto no_msix;
> +	} else if (rc == -ENOSPC) {

    This branch is unreachable now. You should have put this check first.

> +		/* Get by with single vector */
> +		rc = pci_enable_msix_range(bp->pdev, &bp->msix_table[0], 1, 1);
> +		if (rc < 0) {
> +			BNX2X_DEV_INFO("Single MSI-X is not attainable rc %d\n",
> +				       rc);
> +			goto no_msix;
> +		}
> +
> +		BNX2X_DEV_INFO("Using single MSI-X vector\n");
> +		bp->flags |= USING_SINGLE_MSIX_FLAG;
> +
> +		BNX2X_DEV_INFO("set number of queues to 1\n");
> +		bp->num_ethernet_queues = 1;
> +		bp->num_queues = bp->num_ethernet_queues + bp->num_cnic_queues;
> +	} else if (rc < msix_vec) {

WBR, Sergei



