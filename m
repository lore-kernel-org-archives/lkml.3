Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbaJGOnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 10:43:21 -0400
Received: from mx0.aculab.com ([213.249.233.131]:50372 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753862AbaJGOnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 10:43:19 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Eric Dumazet'" <eric.dumazet@gmail.com>,
        =?utf-8?B?TG90aGFyIFdhw59tYW5u?= <LW@KARO-electronics.de>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Frank Li <Frank.Li@freescale.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: fec: fix regression on i.MX28 introduced by
 rx_copybreak support
Thread-Topic: [PATCH] net: fec: fix regression on i.MX28 introduced by
 rx_copybreak support
Thread-Index: AQHP4jrJm8o16PSYfUeOu2GPn2nYPZwksznA
Date: Tue, 7 Oct 2014 14:41:49 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D174C6116@AcuExch.aculab.com>
References: <1412687977-11742-1-git-send-email-LW@KARO-electronics.de>
 <1412692034.11091.122.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1412692034.11091.122.camel@edumazet-glaptop2.roam.corp.google.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id s97EhQkM017205

From: Eric Dumazet
> On Tue, 2014-10-07 at 15:19 +0200, Lothar Wamann wrote:
> > commit 1b7bde6d659d ("net: fec: implement rx_copybreak to improve rx performance")
> > introduced a regression for i.MX28. The swap_buffer() function doing
> > the endian conversion of the received data on i.MX28 may access memory
> > beyond the actual packet size in the DMA buffer. fec_enet_copybreak()
> > does not copy those bytes, so that the last bytes of a packet may be
> > filled with invalid data after swapping.
> > This will likely lead to checksum errors on received packets.
> > E.g. when trying to mount an NFS rootfs:
> > UDP: bad checksum. From 192.168.1.225:111 to 192.168.100.73:44662 ulen 36
> >
> > Do the byte swapping and copying to the new skb in one go if
> > necessary.
> >
> > Signed-off-by: Lothar Wamann <LW@KARO-electronics.de>
> > ---
> >  drivers/net/ethernet/freescale/fec_main.c |   25 +++++++++++++++++++++----
> >  1 file changed, 21 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> > index 87975b5..eaaebad 100644
> > --- a/drivers/net/ethernet/freescale/fec_main.c
> > +++ b/drivers/net/ethernet/freescale/fec_main.c
> > @@ -339,6 +339,18 @@ static void *swap_buffer(void *bufaddr, int len)
> >  	return bufaddr;
> >  }
> >
> > +static void *swap_buffer2(void *dst_buf, void *src_buf, int len)
> > +{
> > +	int i;
> > +	unsigned int *src = src_buf;
> > +	unsigned int *dst = dst_buf;
> > +
> > +	for (i = 0; i < DIV_ROUND_UP(len, 4); i++, src++, dst++)
> > +		*dst = cpu_to_be32(*src);
> 
> No need for the DIV :
> 
> 	for (i = 0; i < len; i += sizeof(*dst), src++, dst++)
> 		*dst = cpu_to_be32(*src);
> 
> Also are you sure both src/dst are aligned to word boundaries, or is
> this architecture OK with possible misalignment ?

I wondered about that as well.
I wouldn't have expected ppc to support misaligned transfers, and you'd also
want to make sure that cpu_to_be(*src) was using a byte-swapping instruction.
Hmmm... cpu_to_be() doesn't sound like the right 'swap' macro name.

It looks as though this is processing an entire ethernet frame, in which
case the data (destination address) would normally be on an 4n+2 boundary.
The two bytes before the data can be safely copied (as can the rounding bytes at
the end) - so provided the pointers allow for this it should be fine.
OTOH I've NFI what the actual data is.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
