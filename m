Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbaJGRPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 13:15:12 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46557 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbaJGRPK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 13:15:10 -0400
Date: Tue, 07 Oct 2014 13:15:07 -0400 (EDT)
Message-Id: <20141007.131507.635415594538460008.davem@davemloft.net>
To: LW@KARO-electronics.de
Cc: netdev@vger.kernel.org, rmk+kernel@arm.linux.org.uk,
        Frank.Li@freescale.com, fabio.estevam@freescale.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: fec: fix regression on i.MX28 introduced by
 rx_copybreak support
From: David Miller <davem@davemloft.net>
In-Reply-To: <1412687977-11742-1-git-send-email-LW@KARO-electronics.de>
References: <1412687977-11742-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Oct 2014 10:15:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lothar Waﬂmann <LW@KARO-electronics.de>
Date: Tue,  7 Oct 2014 15:19:37 +0200

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
> Signed-off-by: Lothar Waﬂmann <LW@KARO-electronics.de>

Why don't you just round up the length fec_enet_copybreak() uses when
need_swap is true?  Then you will end up mimicking the original behavior
and not require this new helper function.

And in any case I agree with Sergei that if you do retain your approach,
the new 'swap' argument to fec_enet_copybreak() should be a 'bool'.

I'm really surprised there isn't a control register bit to adjust the
endianness of the data DMA'd to/from the network.
