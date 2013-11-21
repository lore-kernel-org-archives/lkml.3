Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab3KUWOJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 17:14:09 -0500
Received: from mail-yh0-f54.google.com ([209.85.213.54]:47307 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333Ab3KUWOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 17:14:05 -0500
Message-ID: <528E85A9.3000703@gmail.com>
Date: Thu, 21 Nov 2013 17:14:01 -0500
From: Vlad Yasevich <vyasevich@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Chang Xiangzhong <changxiangzhong@gmail.com>, nhorman@tuxdriver.com,
        davem@davemloft.net
CC: linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sctp: find the correct highest_new_tsn in sack
References: <1385070988-29554-1-git-send-email-changxiangzhong@gmail.com>
In-Reply-To: <1385070988-29554-1-git-send-email-changxiangzhong@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2013 04:56 PM, Chang Xiangzhong wrote:
> Function sctp_check_transmitted(transport t, ...) would iterate all of
> transport->transmitted queue and looking for the highest __newly__ acked tsn.
> The original algorithm would depend on the order of the assoc->transport_list
> (in function sctp_outq_sack line 1215 - 1226). The result might not be the
> expected due to the order of the tranport_list.
> 
> Solution: checking if the exising is smaller than the new one before assigning
> 
> Signed-off-by: Chang Xiangzhong <changxiangzhong@gmail.com>

Good find.  This has been around for since day 1.  It doesn't so much
depend on the order of the transport list, but on the order the
transports been used.  I agree it is a problem if chunks have been
distributed across multiple transports and a singe SACK acking them all.

Acked-by: Vlad Yasevich <vyasevich@gmail.com>

-vlad

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
> 

