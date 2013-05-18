Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab3EROsj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 10:48:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:47439 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752537Ab3EROsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 10:48:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,700,1363158000"; 
   d="scan'208";a="243460022"
Date: Sat, 18 May 2013 07:48:36 -0700
From: Jon Mason <jon.mason@intel.com>
To: Jonghwan Choi <jhbird.choi@gmail.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: Re: [PATCH 3.9-table] NTB: Correctly handle receive buffers of the
 minimal size
Message-ID: <20130518144836.GE29066@jonmason-lab>
References: <1368845379-4177-1-git-send-email-jhbird.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368845379-4177-1-git-send-email-jhbird.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 18, 2013 at 11:49:39AM +0900, Jonghwan Choi wrote:
> From: Jon Mason <jon.mason@intel.com>
> 
> This patch looks like it should be in the 3.9-stable tree, should we apply
> it?

Yes, thanks.

> 
> ------------------
> 
> From: "Jon Mason <jon.mason@intel.com>"
> 
> commit c9d534c8cbaedbb522a1d2cb037c6c394f610317 upstream
> 
> The ring logic of the NTB receive buffer/transmit memory window requires
> there to be at least 2 payload sized allotments.  For the minimal size
> case, split the buffer into two and set the transport_mtu to the
> appropriate size.
> 
> Cc: <stable@vger.kernel.org> # 3.9.x: ad3e2751: ntb: off by one
> Cc: <stable@vger.kernel.org> # 3.9.x: cc0f868d: NTB: fix pointer math
> Cc: <stable@vger.kernel.org> # 3.9.x: 113fc505: NTB: Handle 64bit BAR
> Cc: <stable@vger.kernel.org> # 3.9.x: b77b2637: NTB: Link toggle memory
> Cc: <stable@vger.kernel.org> # 3.9.x: 90f9e934: NTB: reset tx_index on
> Signed-off-by: Jon Mason <jon.mason@intel.com>
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> ---
>  drivers/ntb/ntb_transport.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
> index 0828124..a288a26 100644
> --- a/drivers/ntb/ntb_transport.c
> +++ b/drivers/ntb/ntb_transport.c
> @@ -490,11 +490,12 @@ static void ntb_transport_setup_qp_mw(struct ntb_transport *nt,
>  	rx_size -= sizeof(struct ntb_rx_info);
>  
>  	qp->rx_buff = qp->remote_rx_info + 1;
> -	qp->rx_max_frame = min(transport_mtu, rx_size);
> +	/* Due to housekeeping, there must be atleast 2 buffs */
> +	qp->rx_max_frame = min(transport_mtu, rx_size / 2);
>  	qp->rx_max_entry = rx_size / qp->rx_max_frame;
>  	qp->rx_index = 0;
>  
> -	qp->remote_rx_info->entry = qp->rx_max_entry;
> +	qp->remote_rx_info->entry = qp->rx_max_entry - 1;
>  
>  	/* setup the hdr offsets with 0's */
>  	for (i = 0; i < qp->rx_max_entry; i++) {
> @@ -818,7 +819,8 @@ static void ntb_transport_init_queue(struct ntb_transport *nt,
>  	tx_size -= sizeof(struct ntb_rx_info);
>  
>  	qp->tx_mw = qp->rx_info + 1;
> -	qp->tx_max_frame = min(transport_mtu, tx_size);
> +	/* Due to housekeeping, there must be atleast 2 buffs */
> +	qp->tx_max_frame = min(transport_mtu, tx_size / 2);
>  	qp->tx_max_entry = tx_size / qp->tx_max_frame;
>  
>  	if (nt->debugfs_dir) {
> -- 
> 1.8.1.2
> 
