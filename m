Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbaJ1MgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 08:36:17 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:64703 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbaJ1MgP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 08:36:15 -0400
Date: Tue, 28 Oct 2014 13:36:09 +0100
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: David Laight <David.Laight@ACULAB.COM>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Frank Li <Frank.Li@freescale.com>,
        "Fabio Estevam" <fabio.estevam@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv2 6/6] net: fec: fix regression on i.MX28 introduced by
 rx_copybreak support
Message-ID: <20141028133609.2bf6c745@ipc1.ka-ro>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1C9E04C0@AcuExch.aculab.com>
References: <1414494104-27943-1-git-send-email-LW@KARO-electronics.de>
	<1414494104-27943-7-git-send-email-LW@KARO-electronics.de>
	<063D6719AE5E284EB5DD2968C1650D6D1C9E04C0@AcuExch.aculab.com>
Organization: Ka-Ro electronics GmbH
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

David Laight wrote:
> From: Lothar Waßmann
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
> > @@ -1455,7 +1472,7 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
> >  		prefetch(skb->data - NET_IP_ALIGN);
> >  		skb_put(skb, pkt_len - 4);
> >  		data = skb->data;
> > -		if (fep->quirks & FEC_QUIRK_SWAP_FRAME)
> > +		if (!is_copybreak && need_swap)
> >  			swap_buffer(data, pkt_len);
> 
> It has to be better to set the 'copybreak' limit to be larger than the
> maximum frame size and so always go through the 'copybreak' paths.
> 
Since the copybreak support is all about performance optimistation, we
should IMO buy the additional advantage for i.MX28 by not having to
access the buffer twice (once for copying and once again for swapping).


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
