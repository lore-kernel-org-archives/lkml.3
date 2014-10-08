Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbaJHI4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 04:56:35 -0400
Received: from mx0.aculab.com ([213.249.233.131]:36100 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754636AbaJHI4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 04:56:32 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Sergei Shtylyov'" <sergei.shtylyov@cogentembedded.com>,
        =?utf-8?B?TG90aGFyIFdhw59tYW5u?= <LW@KARO-electronics.de>,
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
Thread-Index: AQHP4ki5m8o16PSYfUeOu2GPn2nYPZwl5YHA
Date: Wed, 8 Oct 2014 08:54:58 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D174C6C14@AcuExch.aculab.com>
References: <1412687977-11742-1-git-send-email-LW@KARO-electronics.de>
 <54340FA4.509@cogentembedded.com>
In-Reply-To: <54340FA4.509@cogentembedded.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id s988ugZu023135

From: Sergei Shtylyov
> On 10/07/2014 05:19 PM, Lothar Wamann wrote:
> 
> > commit 1b7bde6d659d ("net: fec: implement rx_copybreak to improve rx performance")
> > introduced a regression for i.MX28. The swap_buffer() function doing
> > the endian conversion of the received data on i.MX28 may access memory
> > beyond the actual packet size in the DMA buffer. fec_enet_copybreak()
> > does not copy those bytes, so that the last bytes of a packet may be
> > filled with invalid data after swapping.
> > This will likely lead to checksum errors on received packets.
> > E.g. when trying to mount an NFS rootfs:
> > UDP: bad checksum. From 192.168.1.225:111 to 192.168.100.73:44662 ulen 36
> 
> > Do the byte swapping and copying to the new skb in one go if
> > necessary.
> 
> > Signed-off-by: Lothar Wamann <LW@KARO-electronics.de>
> > ---
> >   drivers/net/ethernet/freescale/fec_main.c |   25 +++++++++++++++++++++----
> >   1 file changed, 21 insertions(+), 4 deletions(-)
> 
> > diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> > index 87975b5..eaaebad 100644
> > --- a/drivers/net/ethernet/freescale/fec_main.c
> > +++ b/drivers/net/ethernet/freescale/fec_main.c
> [...]
> > @@ -1348,7 +1360,7 @@ fec_enet_new_rxbdp(struct net_device *ndev, struct bufdesc *bdp, struct
> sk_buff
> >   }
> >
> >   static bool fec_enet_copybreak(struct net_device *ndev, struct sk_buff **skb,
> > -			       struct bufdesc *bdp, u32 length)
> > +			       struct bufdesc *bdp, u32 length, int swap)
> 
>     'bool swap' perhaps?
> 
> > @@ -1393,6 +1408,7 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
> >   	u16	vlan_tag;
> >   	int	index = 0;
> >   	bool	is_copybreak;
> > +	bool need_swap = id_entry->driver_data & FEC_QUIRK_SWAP_FRAME;
> 
>     ... especially talking this into account...

Hmmm... in that case you may not want the compiler to convert the bit value
to a 'bool' at all.

Passing 'id_entry->driver_data' through (that doesn't look like a field name for
'quirk flags) would generate better code.

Even better would be to reference the flag directly from 'ndev'.
A pointer indirection for the test if probably faster then passing another argument.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
