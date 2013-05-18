Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab3EROsv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 10:48:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:48173 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140Ab3EROsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 10:48:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,700,1363158000"; 
   d="scan'208";a="315796327"
Date: Sat, 18 May 2013 07:48:49 -0700
From: Jon Mason <jon.mason@intel.com>
To: Jonghwan Choi <jhbird.choi@gmail.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: Re: [PATCH 3.9-stable] NTB: memcpy lockup workaround
Message-ID: <20130518144849.GF29066@jonmason-lab>
References: <1368845537-4250-1-git-send-email-jhbird.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368845537-4250-1-git-send-email-jhbird.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 18, 2013 at 11:52:17AM +0900, Jonghwan Choi wrote:
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
> commit c336acd3331dcc191a97dbc66a557d47741657c7 upstream
> 
> The system will appear to lockup for long periods of time due to the NTB
> driver spending too much time in memcpy.  Avoid this by reducing the
> number of packets that can be serviced on a given interrupt.
> 
> Cc: <stable@vger.kernel.org> # 3.9.x: ad3e2751: ntb: off by one
> Cc: <stable@vger.kernel.org> # 3.9.x: cc0f868d: NTB: fix pointer math
> Cc: <stable@vger.kernel.org> # 3.9.x: 113fc505: NTB: Handle 64bit BAR
> Cc: <stable@vger.kernel.org> # 3.9.x: b77b2637: NTB: Link toggle memory
> Cc: <stable@vger.kernel.org> # 3.9.x: 90f9e934: NTB: reset tx_index on
> Cc: <stable@vger.kernel.org> # 3.9.x: c9d534c8: NTB: Correctly handle receive
> Signed-off-by: Jon Mason <jon.mason@intel.com>
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> ---
>  drivers/ntb/ntb_transport.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
> index a288a26..0f66daa 100644
> --- a/drivers/ntb/ntb_transport.c
> +++ b/drivers/ntb/ntb_transport.c
> @@ -1034,11 +1034,16 @@ out:
>  static void ntb_transport_rx(unsigned long data)
>  {
>  	struct ntb_transport_qp *qp = (struct ntb_transport_qp *)data;
> -	int rc;
> +	int rc, i;
>  
> -	do {
> +	/* Limit the number of packets processed in a single interrupt to
> +	 * provide fairness to others
> +	 */
> +	for (i = 0; i < qp->rx_max_entry; i++) {
>  		rc = ntb_process_rxc(qp);
> -	} while (!rc);
> +		if (rc)
> +			break;
> +	}
>  }
>  
>  static void ntb_transport_rxc_db(void *data, int db_num)
> -- 
> 1.8.1.2
> 
