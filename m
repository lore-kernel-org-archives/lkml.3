Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567AbaKFHHd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 02:07:33 -0500
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:40897 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaKFHHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 02:07:32 -0500
Message-ID: <545B1E27.3080302@lab.ntt.co.jp>
Date: Thu, 06 Nov 2014 16:07:19 +0900
From: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Su-Hyun Park <suhyun.park@ahnlab.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>
CC: bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bridge: missing null bridge device check causing null
 pointer dereference (bugfix)
References: <1415255192-13584-1-git-send-email-suhyun.park@ahnlab.com>
In-Reply-To: <1415255192-13584-1-git-send-email-suhyun.park@ahnlab.com>
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/06 15:26, Su-Hyun Park wrote:
> the bridge device can be null if the bridge is being deleted while processing 
> the packet, which causes the null pointer dereference in switch statement.

How can this happen??
It is guarded by rcu.
netdev_rx_handler_unregister() ensures rx_handler_data is non NULL.

Thanks,
Toshiaki Makita

> 
> crash dump snippet:
> 
> <1>BUG: unable to handle kernel NULL pointer dereference at 0000000000000021
> <1>IP: [<ffffffff814179f6>] br_handle_frame+0xe6/0x270
> 
> <0>Code: 4c 0f 44 f0 89 f8 66 33 15 32 52 24 00 66 33 05 29 52 24 00 09 c2 89 
> f0 66 33 05 22 52 24 00 80 e4 f0 66 09 c2 0f 84 eb 00 00 00 <41> 0f b6 46 21 
> 3c 02 74 61 3c 03 74 1d 48 89 df e8 d5 bc f0 ff
> ---
>  net/bridge/br_input.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
> index 6fd5522..7e899ca 100644
> --- a/net/bridge/br_input.c
> +++ b/net/bridge/br_input.c
> @@ -176,6 +176,8 @@ rx_handler_result_t br_handle_frame(struct sk_buff **pskb)
>  		return RX_HANDLER_CONSUMED;
>  
>  	p = br_port_get_rcu(skb->dev);
> +	if (!p)
> +		goto drop;
>  
>  	if (unlikely(is_link_local_ether_addr(dest))) {
>  		u16 fwd_mask = p->br->group_fwd_mask_required;
> 

