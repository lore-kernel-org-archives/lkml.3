Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab3BHHph (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 02:45:37 -0500
Received: from mail-ia0-f177.google.com ([209.85.210.177]:56998 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab3BHHpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 02:45:36 -0500
MIME-Version: 1.0
In-Reply-To: <5113E2E2.70706@synopsys.com>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
 <201302041724.47331.arnd@arndb.de> <1360031367.14701.47.camel@pasglop>
 <CAHTX3dL4dScmzgGyqbvPH-7UQvFrjQhHu2zh0iZyzWB=spZS+Q@mail.gmail.com>
 <1360066756.4529.6.camel@pasglop> <CAHTX3dLJy314mv39hprkmZ5XdzYiYGz1ngTERp7w6aAYud+Riw@mail.gmail.com>
 <51111133.7000105@synopsys.com> <1360098004.4529.13.camel@pasglop>
 <511178AC.7080304@synopsys.com> <1360105635.2707.7.camel@pasglop>
 <CACxGe6u=zhGXm0AO_h354g8OOkAQgdczdw_gCCRxL+=r8hM+-g@mail.gmail.com>
 <1360186550.2650.4.camel@pasglop> <CACxGe6uaVsng79Kni=0O_YK330vuqMuPO6=y9Bj=UZpZ0ozaDg@mail.gmail.com>
 <CACxGe6v3ZUEQhi764ivQqE9i2wGzJGcoC0sTVohb_6MQ9sE+hQ@mail.gmail.com>
 <5113C459.8000602@synopsys.com> <CACxGe6uHx4KdZRgAyL-wQ2GurojAH0eTa6YRCoSuCg89BAvBTA@mail.gmail.com>
 <5113C818.9050307@synopsys.com> <CACxGe6srNmX+qL+5BBFOzTHtQLRcw+4Aqjexy0Y=Vbh3XqPWPA@mail.gmail.com>
 <5113DCC1.7040902@synopsys.com> <CACxGe6tMW_YpTfFn_gKu1YS9VzkOHfzJ1Ai6jVE7UiQQeZD-eg@mail.gmail.com>
 <5113E2E2.70706@synopsys.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 8 Feb 2013 07:45:14 +0000
X-Google-Sender-Auth: 4MHwWhCoLrOoclYgEntpRqN-Dxo
Message-ID: <CACxGe6sxm97=gBrPLX-ZRM1+zTJsHLba1i7Zc8ft=0tzitequg@mail.gmail.com>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16
 with generic iowrite(read)8/16(be)
To: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michal Simek <monstr@monstr.eu>, Arnd Bergmann <arnd@arndb.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        dahinds@users.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 7, 2013 at 5:22 PM, Alexey Brodkin
<Alexey.Brodkin@synopsys.com> wrote:
> On 02/07/2013 09:16 PM, Grant Likely wrote:
>>
>> On Thu, Feb 7, 2013 at 4:56 PM, Alexey Brodkin
>> <Alexey.Brodkin@synopsys.com> wrote:
>>>
>>> On 02/07/2013 08:44 PM, Grant Likely wrote:
>>>>
>>>> So, if I'm correct that means that for the data port (specifically
>>>> copying between RAM and the data port) using ioread16/iowrite16 on the
>>>> data port results in the correct behaviour. It also means that LE
>>>> support in the current driver is broken.
>>>
>>>
>>> That matches my earlier note when I wrote that for correct work on LE
>>> (note
>>> I'm on ARC, not PPC/MB) I needed to use "io{read|write}16" in
>>> "ace_data{in|out}_le16".
>>>
>>> With original "io{read|write}16be" instead data was corrupted.
>>
>>
>> In which case your bug-fix patch should drop the
>> ace_datain_le16/ace_dataout_le16 variants entirely and use the be16
>> ones for both (renaming appropriately).
>>
>> g.
>>
>> --
>> Grant Likely, B.Sc., P.Eng.
>> Secret Lab Technologies Ltd.
>>
>
> Sorry, do you mean to replace original lines:
> =======
>
> static void ace_datain_be16(struct ace_device *ace)
> {
>         int i = ACE_FIFO_SIZE / 2;
>         u16 *dst = ace->data_ptr;
>         while (i--)
>                 *dst++ = in_le16(ace->baseaddr + 0x40);
>         ace->data_ptr = dst;
>
> }
>
> static void ace_dataout_be16(struct ace_device *ace)
> {
>         int i = ACE_FIFO_SIZE / 2;
>         u16 *src = ace->data_ptr;
>         while (i--)
>                 ioread16(*src++, ace->baseaddr + 0x40);
>         ace->data_ptr = src;
> }
> =======
>
> with something like:
> =======
> static void ace_datain_16(struct ace_device *ace)
>
> {
>         int i = ACE_FIFO_SIZE / 2;
>         u16 *dst = ace->data_ptr;
>         while (i--)
>                 *dst++ = in_le16(ace->baseaddr + 0x40);
>         ace->data_ptr = dst;
> }
>
> static void ace_dataout_16(struct ace_device *ace)
>
> {
>         int i = ACE_FIFO_SIZE / 2;
>         u16 *src = ace->data_ptr;
>         while (i--)
>                 iowrite16(*src++, ace->baseaddr + 0x40);
>         ace->data_ptr = src;
> }

Ummm, I think you finger fumbled that because the above doesn't make sense.

I think that your original patch should be applied as-is first. It is
just a mechanical replacement of the ppc accessors with ioread/iowrite
variants. Nothing controversial there.

I was suggesting to use a second patch to drop
ace_datain_le16/ace_dataout_le16 and rename
ace_datain_be16/ace_dataout_be16 to ace_datain_16/ace_dataout_16.\,
and in that same patch you can switch the read loop to use
ioread16_rep/iowrite16_rep.

*However*... I think my first analysis is actually wrong for the BE
case. The current BE code works using ioread16() for the data port
which does a swap, but ioread16_rep() doesn't swap . I hadn't gone an
actually looked at how the _rep variants are implemented. (Thanks for
your help Ben). That means ioread16_rep will work fine for LE, but
we're still stuck with the slow loop on BE.

So, craft your bug fix for the LE case to use _rep variants for
ace_{datain,dataout}_le16() but don't change the BE support yet.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
