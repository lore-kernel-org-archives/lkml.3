Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267AbaJGQHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 12:07:07 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:58209 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482AbaJGQHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 12:07:04 -0400
Message-ID: <54340FA4.509@cogentembedded.com>
Date: Tue, 07 Oct 2014 20:07:00 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: =?UTF-8?B?TG90aGFyIFdhw59tYW5u?= <LW@KARO-electronics.de>,
        netdev@vger.kernel.org
CC: "David S. Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Frank Li <Frank.Li@freescale.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: fec: fix regression on i.MX28 introduced by rx_copybreak
 support
References: <1412687977-11742-1-git-send-email-LW@KARO-electronics.de>
In-Reply-To: <1412687977-11742-1-git-send-email-LW@KARO-electronics.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 10/07/2014 05:19 PM, Lothar Waßmann wrote:

> commit 1b7bde6d659d ("net: fec: implement rx_copybreak to improve rx performance")
> introduced a regression for i.MX28. The swap_buffer() function doing
> the endian conversion of the received data on i.MX28 may access memory
> beyond the actual packet size in the DMA buffer. fec_enet_copybreak()
> does not copy those bytes, so that the last bytes of a packet may be
> filled with invalid data after swapping.
> This will likely lead to checksum errors on received packets.
> E.g. when trying to mount an NFS rootfs:
> UDP: bad checksum. From 192.168.1.225:111 to 192.168.100.73:44662 ulen 36

> Do the byte swapping and copying to the new skb in one go if
> necessary.

> Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
> ---
>   drivers/net/ethernet/freescale/fec_main.c |   25 +++++++++++++++++++++----
>   1 file changed, 21 insertions(+), 4 deletions(-)

> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index 87975b5..eaaebad 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
[...]
> @@ -1348,7 +1360,7 @@ fec_enet_new_rxbdp(struct net_device *ndev, struct bufdesc *bdp, struct sk_buff
>   }
>
>   static bool fec_enet_copybreak(struct net_device *ndev, struct sk_buff **skb,
> -			       struct bufdesc *bdp, u32 length)
> +			       struct bufdesc *bdp, u32 length, int swap)

    'bool swap' perhaps?

> @@ -1393,6 +1408,7 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
>   	u16	vlan_tag;
>   	int	index = 0;
>   	bool	is_copybreak;
> +	bool need_swap = id_entry->driver_data & FEC_QUIRK_SWAP_FRAME;

    ... especially talking this into account...

WBR, Sergei

