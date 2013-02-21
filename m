Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab3BURSn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 12:18:43 -0500
Received: from mail-ve0-f177.google.com ([209.85.128.177]:52865 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857Ab3BURSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 12:18:40 -0500
Message-ID: <512656E7.3060908@gmail.com>
Date: Thu, 21 Feb 2013 12:18:31 -0500
From: Vlad Yasevich <vyasevich@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Roberts, Lee A." <lee.roberts@hp.com>
CC: "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] sctp: fix association hangs due to off-by-one errors
 in sctp_tsnmap_grow()
References: <D64EC45690EF85409BA6C4730E0162244310DEE7@G4W3231.americas.hpqcorp.net>
In-Reply-To: <D64EC45690EF85409BA6C4730E0162244310DEE7@G4W3231.americas.hpqcorp.net>
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
> with data being held in the association lobby (ordering)
> queue.  Close examination of reassembly/ordering queues shows
> duplicated packets.
>
> In sctp_tsnmap_grow(), correct off-by-one errors when copying
> and resizing the tsnmap.  If max_tsn_seen is in the LSB of the
> word, this bit can be lost, causing the corresponding packet
> to be transmitted again and to be entered as a duplicate into
> the SCTP reassembly/ordering queues.
>
> Patch applies to linux-3.8 kernel.
>
> Signed-off-by: Lee A. Roberts <lee.roberts@hp.com>
> ---
>   net/sctp/tsnmap.c |    5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff -uprN -X linux-3.8-vanilla/Documentation/dontdiff linux-3.8-vanilla/net/sctp/tsnmap.c linux-3.8-SCTP+1/net/sctp/tsnmap.c
> --- linux-3.8-vanilla/net/sctp/tsnmap.c	2013-02-18 16:58:34.000000000 -0700
> +++ linux-3.8-SCTP+1/net/sctp/tsnmap.c	2013-02-20 08:01:02.555223259 -0700
> @@ -369,14 +369,15 @@ static int sctp_tsnmap_grow(struct sctp_
>   	if (gap >= SCTP_TSN_MAP_SIZE)

No that I think about this a bit more, this should be gap + 1.  If you 
do that, you might as well call sctp_tsnmap_grow() with gap+1 as 
argument and then can just use the 'gap' everywhere inside.

>   		return 0;
>
> -	inc = ALIGN((gap - map->len),BITS_PER_LONG) + SCTP_TSN_MAP_INCREMENT;
> +	inc = ALIGN((gap - map->len + 1), BITS_PER_LONG)
> +		+ SCTP_TSN_MAP_INCREMENT;
>   	len = min_t(u16, map->len + inc, SCTP_TSN_MAP_SIZE);
>
>   	new = kzalloc(len>>3, GFP_ATOMIC);
>   	if (!new)
>   		return 0;
>
> -	bitmap_copy(new, map->tsn_map, map->max_tsn_seen - map->base_tsn);
> +	bitmap_copy(new, map->tsn_map, map->max_tsn_seen - map->base_tsn + 1);

Can simplify that this by using map->cumulative_tsn_ack_point instead of 
base_tsn.

-vlad

>   	kfree(map->tsn_map);
>   	map->tsn_map = new;
>   	map->len = len;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

