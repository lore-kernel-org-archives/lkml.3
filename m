Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbaJ1NEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 09:04:20 -0400
Received: from mx0.aculab.com ([213.249.233.131]:48518 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751437AbaJ1NER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 09:04:17 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: =?utf-8?B?J0xvdGhhciBXYcOfbWFubic=?= <LW@KARO-electronics.de>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Frank Li <Frank.Li@freescale.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCHv2 6/6] net: fec: fix regression on i.MX28 introduced by
 rx_copybreak support
Thread-Topic: [PATCHv2 6/6] net: fec: fix regression on i.MX28 introduced by
 rx_copybreak support
Thread-Index: AQHP8p5eP0jGHGIUnUypcxZpFUTH1pxFWcXAgAAYfoCAAAW9AA==
Date: Tue, 28 Oct 2014 13:01:57 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1C9E06B0@AcuExch.aculab.com>
References: <1414494104-27943-1-git-send-email-LW@KARO-electronics.de>
	<1414494104-27943-7-git-send-email-LW@KARO-electronics.de>
	<063D6719AE5E284EB5DD2968C1650D6D1C9E04C0@AcuExch.aculab.com>
 <20141028133609.2bf6c745@ipc1.ka-ro>
In-Reply-To: <20141028133609.2bf6c745@ipc1.ka-ro>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9SD4S8O025153

From: Lothar WaÃŸmann
> David Laight wrote:
> > From: Lothar WaÃŸmann
> > > commit 1b7bde6d659d ("net: fec: implement rx_copybreak to improve rx performance")
> > > introduced a regression for i.MX28. The swap_buffer() function doing
> > > the endian conversion of the received data on i.MX28 may access memory
> > > beyond the actual packet size in the DMA buffer. fec_enet_copybreak()
> > > does not copy those bytes, so that the last bytes of a packet may be
> > > filled with invalid data after swapping.
> > > This will likely lead to checksum errors on received packets.
> > > E.g. when trying to mount an NFS rootfs:
> > > UDP: bad checksum. From 192.168.1.225:111 to 192.168.100.73:44662 ulen 36
> > >
> > > Do the byte swapping and copying to the new skb in one go if
> > > necessary.
> > >
> > > Signed-off-by: Lothar Wamann <LW@KARO-electronics.de>
> > > ---
> > >  drivers/net/ethernet/freescale/fec_main.c |   25 +++++++++++++++++++++----
> > >  1 file changed, 21 insertions(+), 4 deletions(-)
> > >
> > > @@ -1455,7 +1472,7 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
> > >  		prefetch(skb->data - NET_IP_ALIGN);
> > >  		skb_put(skb, pkt_len - 4);
> > >  		data = skb->data;
> > > -		if (fep->quirks & FEC_QUIRK_SWAP_FRAME)
> > > +		if (!is_copybreak && need_swap)
> > >  			swap_buffer(data, pkt_len);
> >
> > It has to be better to set the 'copybreak' limit to be larger than the
> > maximum frame size and so always go through the 'copybreak' paths.
> >
> Since the copybreak support is all about performance optimistation, we
> should IMO buy the additional advantage for i.MX28 by not having to
> access the buffer twice (once for copying and once again for swapping).

You definitely want to do the byteswap at the same time as the copy.

The point I'm trying to make that if you need to do the byteswap you
probably might as well copy the data to an skb of the correct size at
the same time.
Certainly I'd expect the 'break even' length will be much higher.

	David


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
