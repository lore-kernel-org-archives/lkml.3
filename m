Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbaJGNcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 09:32:35 -0400
Received: from mx0.aculab.com ([213.249.233.131]:48594 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753539AbaJGNcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 09:32:33 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: =?utf-8?B?J0xvdGhhciBXYcOfbWFubic=?= <LW@KARO-electronics.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "David S. Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Frank Li <Frank.Li@freescale.com>,
        "Fabio Estevam" <fabio.estevam@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: fec: fix regression on i.MX28 introduced by
 rx_copybreak support
Thread-Topic: [PATCH] net: fec: fix regression on i.MX28 introduced by
 rx_copybreak support
Thread-Index: AQHP4jE2m8o16PSYfUeOu2GPn2nYPZwkoTOQ
Date: Tue, 7 Oct 2014 13:31:01 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D174C6025@AcuExch.aculab.com>
References: <1412687977-11742-1-git-send-email-LW@KARO-electronics.de>
In-Reply-To: <1412687977-11742-1-git-send-email-LW@KARO-electronics.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s97DWirD016731

From: Lothar WaÃŸmann
> commit 1b7bde6d659d ("net: fec: implement rx_copybreak to improve rx performance")
> introduced a regression for i.MX28. The swap_buffer() function doing
> the endian conversion of the received data on i.MX28 may access memory
> beyond the actual packet size in the DMA buffer. fec_enet_copybreak()
> does not copy those bytes, so that the last bytes of a packet may be
> filled with invalid data after swapping.
> This will likely lead to checksum errors on received packets.
> E.g. when trying to mount an NFS rootfs:
> UDP: bad checksum. From 192.168.1.225:111 to 192.168.100.73:44662 ulen 36
> 
> Do the byte swapping and copying to the new skb in one go if
> necessary.

ISTM that if you need to do the 'swap' you should copy the data regardless
of the length.

	David

> 
> Signed-off-by: Lothar Wamann <LW@KARO-electronics.de>
> ---
>  drivers/net/ethernet/freescale/fec_main.c |   25 +++++++++++++++++++++----
>  1 file changed, 21 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index 87975b5..eaaebad 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -339,6 +339,18 @@ static void *swap_buffer(void *bufaddr, int len)
>  	return bufaddr;
>  }
> 
> +static void *swap_buffer2(void *dst_buf, void *src_buf, int len)
> +{
> +	int i;
> +	unsigned int *src = src_buf;
> +	unsigned int *dst = dst_buf;
> +
> +	for (i = 0; i < DIV_ROUND_UP(len, 4); i++, src++, dst++)
> +		*dst = cpu_to_be32(*src);
> +
> +	return dst_buf;
> +}
> +
>  static void fec_dump(struct net_device *ndev)
>  {
>  	struct fec_enet_private *fep = netdev_priv(ndev);
> @@ -1348,7 +1360,7 @@ fec_enet_new_rxbdp(struct net_device *ndev, struct bufdesc *bdp, struct sk_buff
>  }
> 
>  static bool fec_enet_copybreak(struct net_device *ndev, struct sk_buff **skb,
> -			       struct bufdesc *bdp, u32 length)
> +			       struct bufdesc *bdp, u32 length, int swap)
>  {
>  	struct  fec_enet_private *fep = netdev_priv(ndev);
>  	struct sk_buff *new_skb;
> @@ -1363,7 +1375,10 @@ static bool fec_enet_copybreak(struct net_device *ndev, struct sk_buff **skb,
>  	dma_sync_single_for_cpu(&fep->pdev->dev, bdp->cbd_bufaddr,
>  				FEC_ENET_RX_FRSIZE - fep->rx_align,
>  				DMA_FROM_DEVICE);
> -	memcpy(new_skb->data, (*skb)->data, length);
> +	if (!swap)
> +		memcpy(new_skb->data, (*skb)->data, length);
> +	else
> +		swap_buffer2(new_skb->data, (*skb)->data, length);
>  	*skb = new_skb;
> 
>  	return true;
> @@ -1393,6 +1408,7 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
>  	u16	vlan_tag;
>  	int	index = 0;
>  	bool	is_copybreak;
> +	bool need_swap = id_entry->driver_data & FEC_QUIRK_SWAP_FRAME;
> 
>  #ifdef CONFIG_M532x
>  	flush_cache_all();
> @@ -1456,7 +1472,8 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
>  		 * include that when passing upstream as it messes up
>  		 * bridging applications.
>  		 */
> -		is_copybreak = fec_enet_copybreak(ndev, &skb, bdp, pkt_len - 4);
> +		is_copybreak = fec_enet_copybreak(ndev, &skb, bdp, pkt_len - 4,
> +						  need_swap);
>  		if (!is_copybreak) {
>  			skb_new = netdev_alloc_skb(ndev, FEC_ENET_RX_FRSIZE);
>  			if (unlikely(!skb_new)) {
> @@ -1471,7 +1488,7 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
>  		prefetch(skb->data - NET_IP_ALIGN);
>  		skb_put(skb, pkt_len - 4);
>  		data = skb->data;
> -		if (id_entry->driver_data & FEC_QUIRK_SWAP_FRAME)
> +		if (!is_copybreak && need_swap)
>  			swap_buffer(data, pkt_len);
> 
>  		/* Extract the enhanced buffer descriptor */
> --
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
