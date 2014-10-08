Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbaJHEoI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 00:44:08 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:51454 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbaJHEoH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 00:44:07 -0400
Date: Wed, 8 Oct 2014 06:43:42 +0200
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, rmk+kernel@arm.linux.org.uk,
        Frank.Li@freescale.com, fabio.estevam@freescale.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: fec: fix regression on i.MX28 introduced by
 rx_copybreak support
Message-ID: <20141008064342.5d4db175@ipc1.ka-ro>
In-Reply-To: <20141007.131507.635415594538460008.davem@davemloft.net>
References: <1412687977-11742-1-git-send-email-LW@KARO-electronics.de>
	<20141007.131507.635415594538460008.davem@davemloft.net>
Organization: Ka-Ro electronics GmbH
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

David Miller wrote:
> From: Lothar Waßmann <LW@KARO-electronics.de>
> Date: Tue,  7 Oct 2014 15:19:37 +0200
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
> > 
> > Do the byte swapping and copying to the new skb in one go if
> > necessary.
> > 
> > Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
> 
> Why don't you just round up the length fec_enet_copybreak() uses when
> need_swap is true?  Then you will end up mimicking the original behavior
> and not require this new helper function.
> 
I wanted to eliminate the need to access the buffer twice (once for
copying and once for swapping).

> And in any case I agree with Sergei that if you do retain your approach,
> the new 'swap' argument to fec_enet_copybreak() should be a 'bool'.
> 
Right.

> I'm really surprised there isn't a control register bit to adjust the
> endianness of the data DMA'd to/from the network.
>
This is a "feature" of the i.MX28.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
