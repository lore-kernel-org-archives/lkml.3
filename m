Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758415Ab3BGP2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 10:28:35 -0500
Received: from alvesta.synopsys.com ([198.182.60.77]:60356 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab3BGP2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 10:28:32 -0500
Message-ID: <5113C818.9050307@synopsys.com>
Date: Thu, 7 Feb 2013 19:28:24 +0400
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
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com> <1781360.cmQWHCW5SC@wuerfel> <CAHTX3dJpuTRa4Ff29k95quPMVDO2mBiayPoocnw5R15=5ovOHQ@mail.gmail.com> <201302041724.47331.arnd@arndb.de> <1360031367.14701.47.camel@pasglop> <CAHTX3dL4dScmzgGyqbvPH-7UQvFrjQhHu2zh0iZyzWB=spZS+Q@mail.gmail.com> <1360066756.4529.6.camel@pasglop> <CAHTX3dLJy314mv39hprkmZ5XdzYiYGz1ngTERp7w6aAYud+Riw@mail.gmail.com> <51111133.7000105@synopsys.com> <1360098004.4529.13.camel@pasglop> <511178AC.7080304@synopsys.com> <1360105635.2707.7.camel@pasglop> <CACxGe6u=zhGXm0AO_h354g8OOkAQgdczdw_gCCRxL+=r8hM+-g@mail.gmail.com> <1360186550.2650.4.camel@pasglop> <CACxGe6uaVsng79Kni=0O_YK330vuqMuPO6=y9Bj=UZpZ0ozaDg@mail.gmail.com> <CACxGe6v3ZUEQhi764ivQqE9i2wGzJGcoC0sTVohb_6MQ9sE+hQ@mail.gmail.com> <5113C459.8000602@synopsys.com> <CACxGe6uHx4KdZRgAyL-wQ2GurojAH0eTa6YRCoSuCg89BAvBTA@mail.gmail.com>
In-Reply-To: <CACxGe6uHx4KdZRgAyL-wQ2GurojAH0eTa6YRCoSuCg89BAvBTA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.121.8.160]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2013 07:23 PM, Grant Likely wrote:
> On Thu, Feb 7, 2013 at 3:12 PM, Alexey Brodkin
> <Alexey.Brodkin@synopsys.com> wrote:
>> On 02/07/2013 06:51 PM, Grant Likely wrote:
>>>
>>> On Thu, Feb 7, 2013 at 2:39 PM, Grant Likely <grant.likely@secretlab.ca>
>>> wrote:
>>>>
>>>> On Wed, Feb 6, 2013 at 9:35 PM, Benjamin Herrenschmidt
>>>> <benh@kernel.crashing.org> wrote:
>>>>>>
>>>>>>    In fact, the driver already knows about this and figures
>>>>>> out at runtime how the device is wired up to the bus. This is not the
>>>>>> problem.
>>>>>
>>>>>
>>>>> Except that this is very gross, especially when you observe that in the
>>>>> busted "big endian" case, it has to byteswap the bloody data port.
>>>>>
>>>>> So you end up having to do that gross hack with separate accessors for
>>>>> registers vs. data and not able to use the _rep variants, which also
>>>>> means that on platforms like ppc, you end up with a memory barrier on
>>>>> every access (or more), which is going to slow things down enormously.
>>>>
>>>>
>>>> I don't see why the _rep variants aren't usable here. The only reason
>>>> I didn't use them when I wrote the driver in the first place was I was
>>>> a n00b kernel hacker and I didn't know they were there.
>>>
>>>
>>> The 8-bit variant is different though because the hardware requires
>>> pingponging between odd and even byte addresses to flush the fifo.
>>> Reading a data port even address (0x40) gives the least significant
>>> byte. Reading from an odd address (0x41) give the MSB and pops the
>>> data off the FIFO. So, yes, the _rep variant can't be used in 8-bit
>>> mode. It should still be fine in 16-bit.
>>>
>>> page 45: http://www.xilinx.com/support/documentation/data_sheets/ds080.pdf
>>>
>>
>> Ok, so may I do a re-spin with these changes:
>
> There are two things here. 1) changing the accessors used. 2)
> switching the endianess as a bug fix. Any changes to the endian access
> should be a separate patch which a description of what is needed.
>
>> 1. In "ace_in_be16" use "ioread16be"
>> 2. In "ace_out_be16" use "iowrite16be"
>> 3. In "ace_in_le16" use "ioread16"
>> 4. In "ace_out_le16" use "iowrite16"
>
> Yes
>
>> 5. In "ace_datain_le16" use "ioread16_rep"
>> 6. In "ace_dataout_le16" use "iowrite16_rep"
>
> Maybe. In a separate patch. Hmmm... I guess there isn't an
> ioread16be_rep variant. Oh well. Check first with Michal on LE
> microblaze before making the change. If it doesn't work for him the
> more understanding is needed. I was pretty sure the LE variant already
> worked.
>
>> not sure about items for "ace_datain/out_be16" - what about _rep options
>> here?
>
> ioread16_rep should be fine. The ace_data{in,out}_be16 routines need
> to use the LE accessor. The existing code is definitely correct in
> this respect.

Well, if "ioread16_rep" is used in both "ace_data{in,out}_be16" and 
"ace_data{in,out}_le16" then what is a difference between them?
Whether there's a subtle difference still exists and I cannot see it or 
unified accessor could be used from now on at least for data access.

What do you think?

-Alexey
