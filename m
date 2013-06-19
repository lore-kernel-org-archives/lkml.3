Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934426Ab3FSM50 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 08:57:26 -0400
Received: from hermes.synopsys.com ([198.182.44.81]:48483 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756495Ab3FSM5Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 08:57:24 -0400
From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Michal Simek <monstr@monstr.eu>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>,
        "dahinds@users.sourceforge.net" <dahinds@users.sourceforge.net>,
        Mischa Jonker <Mischa.Jonker@synopsys.com>
Subject: Re: xsysace driver support on arches other than PPC/Microblaze
Thread-Topic: xsysace driver support on arches other than PPC/Microblaze
Thread-Index: AQHObMrbNBC9i1xSckWGhX+xeSwphw==
Date: Wed, 19 Jun 2013 12:56:37 +0000
Message-ID: <4881796E12491D4BB15146FE0209CE643F5F15DE@DE02WEMBXB.internal.synopsys.com>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
	<CACxGe6uHx4KdZRgAyL-wQ2GurojAH0eTa6YRCoSuCg89BAvBTA@mail.gmail.com>
	<CAHTX3dKPWg35Az8eE45AGriPZh2G6LLaQMynhFPKSZ+7UvM=9g@mail.gmail.com>
	<201302121725.07641.arnd@arndb.de>
	<4881796E12491D4BB15146FE0209CE643F5F0910@DE02WEMBXB.internal.synopsys.com>
 <CAHp75Vd_23-6F=U33GPwmKPrS==+a=qTodynUM12EiOBT-xBdQ@mail.gmail.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.121.8.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2013 04:13 PM, Andy Shevchenko wrote:
> On Wed, Jun 19, 2013 at 11:56 AM, Alexey Brodkin
> <Alexey.Brodkin@synopsys.com> wrote:
[]
> If you have a way to detect endianess run-time then you have to
> introduce kinda ops structure
>
> struct access {
>   .read = read_func(),
>   .write = write_func(),
> };
>
> ops_le = {...};
> ops_be = {...};
>
> And provide a pointer to the chosen structure.
>
> If there no posibility to get it run-time, use kernel config option.
>
> I wonder if there is any "modern" way to do such things.

Andy, if I understand your idea correctly then this kind of 
functionality is already there.

============
static struct ace_reg_ops ace_reg_be16_ops = {
	.in = ace_in_be16,
	.out = ace_out_be16,
	.datain = ace_datain_be16,
	.dataout = ace_dataout_be16,
};

static struct ace_reg_ops ace_reg_le16_ops = {
	.in = ace_in_le16,
	.out = ace_out_le16,
	.datain = ace_datain_le16,
	.dataout = ace_dataout_le16,
};
============
And in run-time we select which one to use. So no problem here.

The problem I'm facing there is a bit more complex.

Please refer to an extract below:
============
static void ace_out_be16(struct ace_device *ace, int reg, u16 val)
{
	out_be16(ace->baseaddr + reg, val);
}

static void ace_dataout_be16(struct ace_device *ace)
{
	int i = ACE_FIFO_SIZE / 2;
	u16 *src = ace->data_ptr;
	while (i--)
		out_le16(ace->baseaddr + 0x40, *src++);
	ace->data_ptr = src;
}
============

 From it you may see that one high-level big-endian accessor 
("ace_out_be16") uses big-endian low-level accessor ("out_be16") while 
another high-level big-endian accessor ("ace_dataout_be16") uses 
little-endian low-level accessor ("out_be16").

It seems like access to 16-bit data words should be done always with LE 
accessors (after all it's always just a window to a device's memory).

-Alexey




