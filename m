Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133AbaJ1LQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:16:37 -0400
Received: from mx0.aculab.com ([213.249.233.131]:45741 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932092AbaJ1LQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:16:35 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: =?utf-8?B?J0xvdGhhciBXYcOfbWFubic=?= <LW@KARO-electronics.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "David S. Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Frank Li <Frank.Li@freescale.com>,
        "Fabio Estevam" <fabio.estevam@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCHv2 6/6] net: fec: fix regression on i.MX28 introduced by
 rx_copybreak support
Thread-Topic: [PATCHv2 6/6] net: fec: fix regression on i.MX28 introduced by
 rx_copybreak support
Thread-Index: AQHP8p5eP0jGHGIUnUypcxZpFUTH1pxFWz/g
Date: Tue, 28 Oct 2014 11:14:15 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1C9E04DB@AcuExch.aculab.com>
References: <1414494104-27943-1-git-send-email-LW@KARO-electronics.de>
 <1414494104-27943-7-git-send-email-LW@KARO-electronics.de>
In-Reply-To: <1414494104-27943-7-git-send-email-LW@KARO-electronics.de>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9SBGgva024320

From:  Lothar WaÃŸmann
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
> Signed-off-by: Lothar Wamann <LW@KARO-electronics.de>
> ---
>  drivers/net/ethernet/freescale/fec_main.c |   25 +++++++++++++++++++++----
>  1 file changed, 21 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index 404fb9d..b92324c 100644
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
> +	for (i = 0; i < len; i += 4, src++, dst++)
> +		swab32s(src);
> +
> +	return dst_buf;
> +}
> +

Actually that is completely f*cked....

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
