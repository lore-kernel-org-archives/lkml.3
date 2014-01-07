Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbaAGNkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 08:40:35 -0500
Received: from mailout4.w2.samsung.com ([211.189.100.14]:18881 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbaAGNk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 08:40:26 -0500
X-AuditID: cbfec372-b7fa96d000006a7b-8b-52cc03c88382
Date: Tue, 07 Jan 2014 11:40:19 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Ding Tianhong <dingtianhong@huawei.com>
Cc: linux-media@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/21] media: dvb_core: slight optimization of addr compare
Message-id: <20140107114019.2f8eb534@samsung.com>
In-reply-to: <52B7C5CB.5000709@huawei.com>
References: <52B7C5CB.5000709@huawei.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJLMWRmVeSWpSXmKPExsVy+t/hEN0TzGeCDG4/NLJ4c3QHm8XlXXPY
	LHo2bGV1YPZoOfKW1ePzJrkApigum5TUnMyy1CJ9uwSujO9futgLZolXPGi4zd7AOEGoi5GT
	Q0LARKLj3hw2CFtM4sK99UA2F4eQwBJGiWt7pkI5PUwSf0/9YAapYhFQlTi3dgMriM0mYCTx
	qrEFzBYR0JZ4d2UaC4jNLJAgcXPubHYQW1jAX6KtbSojiM0rYCjxe9dJsG2cAloSB+YtA6rn
	AFqgKdH2iAPElBBwkth9QAqiWlDix+R7UBO1JDZva2KFsOUlNq95yzyBUWAWkrJZSMpmISlb
	wMi8ilG0tDi5oDgpPddQrzgxt7g0L10vOT93EyMkOIt2MD7bYHWIUYCDUYmHd8LuU0FCrIll
	xZW5hxglOJiVRHiZb5wOEuJNSaysSi3Kjy8qzUktPsTIxMEp1cB4cumKu++W/veLiH3uamOY
	qjE76r+Fbn3h3k+rNHt1y49v9Hy7SjnebUF5Z6FC/OUwvb5Ghc93Ehb2b24/arpUQEV2rT7b
	oV3yqcd5g6/N1eaq7b65gv/Br6yJRT+59mydElK/Orzy2NKlrZ1qOx/k8WaciVvj65jsFntU
	UWRTZm19g4/9jTNKLMUZiYZazEXFiQCzIBCmLAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 23 Dec 2013 13:10:35 +0800
Ding Tianhong <dingtianhong@huawei.com> escreveu:

> Use the recently added and possibly more efficient
> ether_addr_equal_unaligned to instead of memcmp.

I'm ok with this change, but I prefer if you could merge it together with the
other patches, as I don't have the patch that added 
ether_addr_equal_unaligned() on my tree yet.
> 
> Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>

Acked-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

> Cc: linux-media@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
> ---
>  drivers/media/dvb-core/dvb_net.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
> index f91c80c..ff00f97 100644
> --- a/drivers/media/dvb-core/dvb_net.c
> +++ b/drivers/media/dvb-core/dvb_net.c
> @@ -179,7 +179,7 @@ static __be16 dvb_net_eth_type_trans(struct sk_buff *skb,
>  	eth = eth_hdr(skb);
>  
>  	if (*eth->h_dest & 1) {
> -		if(memcmp(eth->h_dest,dev->broadcast, ETH_ALEN)==0)
> +		if(ether_addr_equal_unaligned(eth->h_dest, dev->broadcast))
>  			skb->pkt_type=PACKET_BROADCAST;
>  		else
>  			skb->pkt_type=PACKET_MULTICAST;
> @@ -674,11 +674,11 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
>  					if (priv->rx_mode != RX_MODE_PROMISC) {
>  						if (priv->ule_skb->data[0] & 0x01) {
>  							/* multicast or broadcast */
> -							if (memcmp(priv->ule_skb->data, bc_addr, ETH_ALEN)) {
> +							if (!ether_addr_equal_unaligned(priv->ule_skb->data, bc_addr)) {
>  								/* multicast */
>  								if (priv->rx_mode == RX_MODE_MULTI) {
>  									int i;
> -									for(i = 0; i < priv->multi_num && memcmp(priv->ule_skb->data, priv->multi_macs[i], ETH_ALEN); i++)
> +									for(i = 0; i < priv->multi_num && !ether_addr_equal_unaligned(priv->ule_skb->data, priv->multi_macs[i]); i++)
>  										;
>  									if (i == priv->multi_num)
>  										drop = 1;
> @@ -688,7 +688,7 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
>  							}
>  							/* else: broadcast */
>  						}
> -						else if (memcmp(priv->ule_skb->data, dev->dev_addr, ETH_ALEN))
> +						else if (!ether_addr_equal_unaligned(priv->ule_skb->data, dev->dev_addr))
>  							drop = 1;
>  						/* else: destination address matches the MAC address of our receiver device */
>  					}
> @@ -837,7 +837,7 @@ static void dvb_net_sec(struct net_device *dev,
>  	}
>  	if (pkt[5] & 0x02) {
>  		/* handle LLC/SNAP, see rfc-1042 */
> -		if (pkt_len < 24 || memcmp(&pkt[12], "\xaa\xaa\x03\0\0\0", 6)) {
> +		if (pkt_len < 24 || !ether_addr_equal_unaligned(&pkt[12], "\xaa\xaa\x03\0\0\0")) {
>  			stats->rx_dropped++;
>  			return;
>  		}


-- 

Cheers,
Mauro
