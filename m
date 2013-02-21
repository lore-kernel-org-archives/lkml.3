Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab3BURTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 12:19:41 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:40563 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538Ab3BURTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 12:19:39 -0500
Message-ID: <51265727.8090501@gmail.com>
Date: Thu, 21 Feb 2013 12:19:35 -0500
From: Vlad Yasevich <vyasevich@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Roberts, Lee A." <lee.roberts@hp.com>
CC: "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] sctp: fix association hangs due to reneging packets
 below the cumulative TSN ACK point
References: <D64EC45690EF85409BA6C4730E0162244310DEFE@G4W3231.americas.hpqcorp.net>
In-Reply-To: <D64EC45690EF85409BA6C4730E0162244310DEFE@G4W3231.americas.hpqcorp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2013 11:44 AM, Roberts, Lee A. wrote:
> From: Lee A. Roberts <lee.roberts@hp.com>
>
> Resolve SCTP association hangs observed during SCTP stress
> testing.  Observable symptoms include communications hangs
> with data being held in the association reassembly and/or lobby
> (ordering) queues.  Close examination of reassembly queue shows
> missing packets.
>
> In sctp_ulpq_renege_list(), do not renege packets below the
> cumulative TSN ACK point.
>
> Patch applies to linux-3.8 kernel.
>
> Signed-off-by: Lee A. Roberts <lee.roberts@hp.com>

Acked-by: Vlad Yasevich <vyasevich@gmail.com>

-vlad

> ---
>   net/sctp/ulpqueue.c |    9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff -uprN -X linux-3.8-vanilla/Documentation/dontdiff linux-3.8-SCTP+1/net/sctp/ulpqueue.c linux-3.8-SCTP+2/net/sctp/ulpqueue.c
> --- linux-3.8-SCTP+1/net/sctp/ulpqueue.c	2013-02-18 16:58:34.000000000 -0700
> +++ linux-3.8-SCTP+2/net/sctp/ulpqueue.c	2013-02-21 07:39:40.888281496 -0700
> @@ -969,11 +969,16 @@ static __u16 sctp_ulpq_renege_list(struc
>
>   	tsnmap = &ulpq->asoc->peer.tsn_map;
>
> -	while ((skb = __skb_dequeue_tail(list)) != NULL) {
> -		freed += skb_headlen(skb);
> +	while ((skb = skb_peek_tail(list)) != NULL) {
>   		event = sctp_skb2event(skb);
>   		tsn = event->tsn;
>
> +		/* Don't renege below the Cumulative TSN ACK Point. */
> +		if (TSN_lte(tsn, sctp_tsnmap_get_ctsn(tsnmap)))
> +			break;
> +
> +		__skb_unlink(skb, list);
> +		freed += skb_headlen(skb);
>   		sctp_ulpevent_free(event);
>   		sctp_tsnmap_renege(tsnmap, tsn);
>   		if (freed >= needed)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

