Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbaJGO1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 10:27:18 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:50870 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbaJGO1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 10:27:16 -0400
Message-ID: <1412692034.11091.122.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] net: fec: fix regression on i.MX28 introduced by
 rx_copybreak support
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Lothar =?ISO-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Frank Li <Frank.Li@freescale.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 07 Oct 2014 07:27:14 -0700
In-Reply-To: <1412687977-11742-1-git-send-email-LW@KARO-electronics.de>
References: <1412687977-11742-1-git-send-email-LW@KARO-electronics.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-07 at 15:19 +0200, Lothar Waßmann wrote:
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
> 
> Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
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

No need for the DIV :

	for (i = 0; i < len; i += sizeof(*dst), src++, dst++)
		*dst = cpu_to_be32(*src);

Also are you sure both src/dst are aligned to word boundaries, or is
this architecture OK with possible misalignment ?



