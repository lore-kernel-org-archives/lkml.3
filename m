Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759101Ab3BGRWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 12:22:52 -0500
Received: from vaxjo.synopsys.com ([198.182.60.75]:57825 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758916Ab3BGRWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 12:22:50 -0500
Message-ID: <5113E2E2.70706@synopsys.com>
Date: Thu, 7 Feb 2013 21:22:42 +0400
From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michal Simek <monstr@monstr.eu>, Arnd Bergmann <arnd@arndb.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>,
        <dahinds@users.sourceforge.net>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16
 with generic iowrite(read)8/16(be)
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com> <201302041724.47331.arnd@arndb.de> <1360031367.14701.47.camel@pasglop> <CAHTX3dL4dScmzgGyqbvPH-7UQvFrjQhHu2zh0iZyzWB=spZS+Q@mail.gmail.com> <1360066756.4529.6.camel@pasglop> <CAHTX3dLJy314mv39hprkmZ5XdzYiYGz1ngTERp7w6aAYud+Riw@mail.gmail.com> <51111133.7000105@synopsys.com> <1360098004.4529.13.camel@pasglop> <511178AC.7080304@synopsys.com> <1360105635.2707.7.camel@pasglop> <CACxGe6u=zhGXm0AO_h354g8OOkAQgdczdw_gCCRxL+=r8hM+-g@mail.gmail.com> <1360186550.2650.4.camel@pasglop> <CACxGe6uaVsng79Kni=0O_YK330vuqMuPO6=y9Bj=UZpZ0ozaDg@mail.gmail.com> <CACxGe6v3ZUEQhi764ivQqE9i2wGzJGcoC0sTVohb_6MQ9sE+hQ@mail.gmail.com> <5113C459.8000602@synopsys.com> <CACxGe6uHx4KdZRgAyL-wQ2GurojAH0eTa6YRCoSuCg89BAvBTA@mail.gmail.com> <5113C818.9050307@synopsys.com> <CACxGe6srNmX+qL+5BBFOzTHtQLRcw+4Aqjexy0Y=Vbh3XqPWPA@mail.gmail.com> <5113DCC1.7040902@synopsys.com> <CACxGe6tMW_YpTfFn_gKu1YS9VzkOHfzJ1Ai6jVE7UiQQeZD-eg@mail.gmail.com>
In-Reply-To: <CACxGe6tMW_YpTfFn_gKu1YS9VzkOHfzJ1Ai6jVE7UiQQeZD-eg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.121.8.160]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2013 09:16 PM, Grant Likely wrote:
> On Thu, Feb 7, 2013 at 4:56 PM, Alexey Brodkin
> <Alexey.Brodkin@synopsys.com> wrote:
>> On 02/07/2013 08:44 PM, Grant Likely wrote:
>>> So, if I'm correct that means that for the data port (specifically
>>> copying between RAM and the data port) using ioread16/iowrite16 on the
>>> data port results in the correct behaviour. It also means that LE
>>> support in the current driver is broken.
>>
>> That matches my earlier note when I wrote that for correct work on LE (note
>> I'm on ARC, not PPC/MB) I needed to use "io{read|write}16" in
>> "ace_data{in|out}_le16".
>>
>> With original "io{read|write}16be" instead data was corrupted.
>
> In which case your bug-fix patch should drop the
> ace_datain_le16/ace_dataout_le16 variants entirely and use the be16
> ones for both (renaming appropriately).
>
> g.
>
> --
> Grant Likely, B.Sc., P.Eng.
> Secret Lab Technologies Ltd.
>

Sorry, do you mean to replace original lines:
=======
static void ace_datain_be16(struct ace_device *ace)
{
	int i = ACE_FIFO_SIZE / 2;
	u16 *dst = ace->data_ptr;
	while (i--)
		*dst++ = in_le16(ace->baseaddr + 0x40);
	ace->data_ptr = dst;
}

static void ace_dataout_be16(struct ace_device *ace)
{
	int i = ACE_FIFO_SIZE / 2;
	u16 *src = ace->data_ptr;
	while (i--)
		ioread16(*src++, ace->baseaddr + 0x40);
	ace->data_ptr = src;
}
=======

with something like:
=======
static void ace_datain_16(struct ace_device *ace)
{
	int i = ACE_FIFO_SIZE / 2;
	u16 *dst = ace->data_ptr;
	while (i--)
		*dst++ = in_le16(ace->baseaddr + 0x40);
	ace->data_ptr = dst;
}

static void ace_dataout_16(struct ace_device *ace)
{
	int i = ACE_FIFO_SIZE / 2;
	u16 *src = ace->data_ptr;
	while (i--)
		iowrite16(*src++, ace->baseaddr + 0x40);
	ace->data_ptr = src;
}
=======

and then the next patch should replace "io{read|write}16" with 
"io{read|write}16_rep" I guess, correct?

-Alexey
