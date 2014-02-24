Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbaBXIof (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 03:44:35 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:54297 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaBXIod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 03:44:33 -0500
MIME-Version: 1.0
In-Reply-To: <CAMuHMdWDtDqmarg-p+LFv4ZtzF7Rv=KzLQA3rnSa_dS2PkVmfA@mail.gmail.com>
References: <1392907779-22053-1-git-send-email-geert@linux-m68k.org>
	<1392907779-22053-5-git-send-email-geert@linux-m68k.org>
	<CANqRtoQQ9cn55Ct7pva2Bo7461WbZG0=Y5f9zLwfKhyU2=QFZw@mail.gmail.com>
	<CAMuHMdWMJFpV_uvi4mNZYc9R8qVWqQf3QGRhdPyc+hj=6XMoJw@mail.gmail.com>
	<CANqRtoRLcac3x55N+VHK+n6RvcgT0v9==9mt1rhVda-zwCYTCg@mail.gmail.com>
	<CAMuHMdWDtDqmarg-p+LFv4ZtzF7Rv=KzLQA3rnSa_dS2PkVmfA@mail.gmail.com>
Date: Mon, 24 Feb 2014 17:44:31 +0900
Message-ID: <CANqRtoQ9ZuAhqmaKU5NLsJBNc0iN7uNdQMS6uCrp0enkFUzrqQ@mail.gmail.com>
Subject: Re: [PATCH 04/11] ARM: shmobile: lager legacy: Add MSIOF support
From: Magnus Damm <magnus.damm@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Simon Horman <horms@verge.net.au>, SH-Linux <linux-sh@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert!

On Mon, Feb 24, 2014 at 5:25 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Hi Magnus,
>
> On Mon, Feb 24, 2014 at 3:09 AM, Magnus Damm <magnus.damm@gmail.com> wrote:
>> On Fri, Feb 21, 2014 at 1:18 AM, Geert Uytterhoeven
>> <geert@linux-m68k.org> wrote:
>>> On Thu, Feb 20, 2014 at 4:48 PM, Magnus Damm <magnus.damm@gmail.com> wrote:
>>>> Since only MSIOF1 is used on Lager (correct me if i'm wrong), isn't it
>>>> best to omit the unused resources from above? In case of DT I think it
>>>> makes sense to define all channels in the SoC.dtsi and let the
>>>> SoC-board.dts just enable the channels that are used. But in this case
>>>> with legacy code  I think we should keep thing simple and small and
>>>> just enable the bits that are used on the particular board.
>>>>
>>>> The same obviously applies to the Koelsch legacy code as well. =)
>>>
>>> Note that while all resources are present, only MSIOF1 is registered on
>>> Lager (MSIOF0 on Koelsch). This is similar to i2c on Koelsch, which also
>>> has all resources, but only registers active devices.
>>
>> Ok, I understand. Thanks for brining this to my attention.
>>
>> I'd like to avoid having unused resources so I'll cook up a patch to
>> rework that myself.
>>
>>> It's your preference, though, so I can adapt if you want.
>>
>> Thanks.
>>
>> Please rework this patch to only register a single MSIOF channel. I
>> think it makes sense to only enable hardware that is being used.
>
> Ehrm, I already register a single MSIOF channel only.
> Perhaps you mean't "remove the unused resources"?

Yes, exactly. My apologies for the unclear reply.

>> Another question: How about "bus_num" and the platform device id
>> mapping? I'd like them to be the same if possible, but you are having
>> this "(idx+1)" bit in your code which I assume is to add offset for
>> the QSPI bus.
>
> "bus_num" is the SPI-specific numbering of SPI masters, which is filled
> in by spi-sh-msiof.c based on platform_device.id (i.e. the numeric suffix
> of e.g. "spi_r8a7790_msiof.1").
> It's used for matching SPI slaves in spi_board_info with SPI masters.
> As QSPI ("qspi.0") has SPI bus_num 0, the MSIOF SPI masters use
> bus_num 1 to 4, hence the "idx+1", and the platform device names
> "spi_r8a7790_msiof.1" to "spi_r8a7790_msiof.4".
>
> (Can't spi-sh-msiof.c use "bus_num = pdev->id + 1", so we can have
>  MSIOF0 as "spi_r8a7790_msiof.0"? No, as that would impact numbering
>  on all SoCs with MSIOF.)

Yeah, the bus number that is commonly used for SPI and I2C behaves
like that so I agree with what you're saying. I guess historically we
usually only have one I2C master and one SPI master which makes it
easy to use direct mapping between bus num and pdev->id.

Now on Lager we have multiple SPI masters (both QSPI and MSIOF unless
I'm mistaken), so the question is how to allocate the ranges of
bus_num for each SPI master. I believe your current allocation works
well but I'm a bit confused by it I must confess.

I'm used to one of the two schemes:
1) single master with pdev->id equals bus_num
2) compact board specific bus allocation

I believe you introduce something similar to 1) but for two SPI
masters which is totally fine! For some unknown reason I expected 2)
with bus_num 0 for QSPI and bus_num 1 for MSIOF1, but I think your
allocation scheme is reusable across multiple boards with the same SoC
so I think your current code is better when I think about it a bit
more.

> With DT, all of this doesn't matter, and life is easier, as the SPI slaves
> are child nodes of the SPI masters and thus don't need numerical bus
> references. So MSIOF0 can be called "msiof0" there.
> We still have the offsets in the "spi%u" aliases, though.

Right all this goes away with DT which is nice.

>> Regarding the PFC configuration, can you please double check that the
>> PIN_MAP_MUX_GROUP_DEFAULT() is in sync with the platform device id? Is
>> it the "bus_num" or the platform device id that is being used in case
>> of SPI?
>
> "bus_num" is SPI-specific. Pinctrl uses the actual device's name:
>
> /**
>  * struct pinctrl_map - boards/machines shall provide this map for devices
>  * @dev_name: the name of the device using this specific mapping, the name
>  *      must be the same as in your struct device*. If this name is set to the
>  *      same name as the pin controllers own dev_name(), the map entry will be
>  *      hogged by the driver itself upon registration

Right. I was just confused seeing the pdev->id set to 2 on MSIOF1, but
I now understand that it is your intentional design to have bus_num 0
as QSPI, bus_num1 as unused MSIOF0 and bus_num 2 as MSIOF1.

It just takes some time for me to grasp. =)

Cheers,

/ magnus
