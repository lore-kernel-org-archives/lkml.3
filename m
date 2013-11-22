Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab3KVL4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 06:56:40 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43852 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab3KVL4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 06:56:38 -0500
Date: Fri, 22 Nov 2013 06:56:12 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Chang Xiangzhong <changxiangzhong@gmail.com>
Cc: vyasevich@gmail.com, davem@davemloft.net, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sctp: find the correct highest_new_tsn in sack
Message-ID: <20131122115612.GA27391@hmsreliant.think-freely.org>
References: <1385070988-29554-1-git-send-email-changxiangzhong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385070988-29554-1-git-send-email-changxiangzhong@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 10:56:28PM +0100, Chang Xiangzhong wrote:
> Function sctp_check_transmitted(transport t, ...) would iterate all of
> transport->transmitted queue and looking for the highest __newly__ acked tsn.
> The original algorithm would depend on the order of the assoc->transport_list
> (in function sctp_outq_sack line 1215 - 1226). The result might not be the
> expected due to the order of the tranport_list.
> 
> Solution: checking if the exising is smaller than the new one before assigning
> 
> Signed-off-by: Chang Xiangzhong <changxiangzhong@gmail.com>
> ---
>  net/sctp/outqueue.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
> index ef9e2bb..1b494fa 100644
> --- a/net/sctp/outqueue.c
> +++ b/net/sctp/outqueue.c
> @@ -1397,7 +1397,8 @@ static void sctp_check_transmitted(struct sctp_outq *q,
>  			 */
>  			if (!tchunk->tsn_gap_acked) {
>  				tchunk->tsn_gap_acked = 1;
> -				*highest_new_tsn_in_sack = tsn;
> +				if (TSN_lt(*highest_new_tsn_in_sack, tsn))
> +					*highest_new_tsn_in_sack = tsn;
>  				bytes_acked += sctp_data_size(tchunk);
>  				if (!tchunk->transport)
>  					migrate_bytes += sctp_data_size(tchunk);
> -- 
> 1.8.4.3
> 
> 

Acked-by: Neil Horman <nhorman@tuxdriver.com>
