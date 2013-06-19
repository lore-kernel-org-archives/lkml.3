Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917Ab3FSOvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 10:51:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51836 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756724Ab3FSOvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 10:51:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Subject: Re: xsysace driver support on arches other than PPC/Microblaze
Date: Wed, 19 Jun 2013 16:51:37 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michal Simek <monstr@monstr.eu>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>,
        "dahinds@users.sourceforge.net" <dahinds@users.sourceforge.net>,
        Mischa Jonker <Mischa.Jonker@synopsys.com>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com> <CAHp75Vd_23-6F=U33GPwmKPrS==+a=qTodynUM12EiOBT-xBdQ@mail.gmail.com> <4881796E12491D4BB15146FE0209CE643F5F15DE@DE02WEMBXB.internal.synopsys.com>
In-Reply-To: <4881796E12491D4BB15146FE0209CE643F5F15DE@DE02WEMBXB.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306191651.37568.arnd@arndb.de>
X-Provags-ID: V02:K0:7/cMCHsUtk4u4R5BsaydjraBeczbgmnwFs0Yg9qGpcp
 KF5++lS7wprZ7ja4SibKyY/vhQk4dl9/e7l2mE7SXbY2IwP39X
 5FmKCxPTL59YYf0GFrMnpzgoWgHwVLiBC+I9UjiPiYXPgdtHOr
 cOEZdP3hrjYQ/3ffg3u9FYxV2IfPj43JPmA2Z4w4OJLmdAP6Av
 SzmHQpZpndpRd6UTAHH5J15qdBYO2X/3vb7MIvgw9PF9UZh5uE
 SI7dyD790znHqu0EmACZ3nhukfkKPuYvGUW2XNXbZJKRqXKnq9
 668K/t6KAz2R5yWlKI/3pOvk5hjp5VCzrofBrj2R2DhSVVIyag
 kpZTXyz6rYO1i1MWfVv0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 June 2013, Alexey Brodkin wrote:
> ============
> static void ace_out_be16(struct ace_device *ace, int reg, u16 val)
> {
>         out_be16(ace->baseaddr + reg, val);
> }
> 
> static void ace_dataout_be16(struct ace_device *ace)
> {
>         int i = ACE_FIFO_SIZE / 2;
>         u16 *src = ace->data_ptr;
>         while (i--)
>                 out_le16(ace->baseaddr + 0x40, *src++);
>         ace->data_ptr = src;
> }
> ============
> 
>  From it you may see that one high-level big-endian accessor 
> ("ace_out_be16") uses big-endian low-level accessor ("out_be16") while 
> another high-level big-endian accessor ("ace_dataout_be16") uses 
> little-endian low-level accessor ("out_be16").
> 
> It seems like access to 16-bit data words should be done always with LE 
> accessors (after all it's always just a window to a device's memory).

This is a very long story, but I think the code is right. The point is
that ace_out_be16 accesses a single register that is defined as big-endian,
while ace_dataout_be16 accesses a byte stream in 16-bit units but has to
copy each byte in the same order that they are stored in memory on the
CPU. It usually takes me half an hour to wrap my head around this,
but yes it is this crazy and a lot of drivers do the same thing.

To simplify the above, ace_dataout_be16 should just call ioread16_rep()
which does the loop in the right endianess, while ace_out_be16
could be changed to use iowrite16_be(), which is the similar to
out_be16 but more portable.

	Arnd
