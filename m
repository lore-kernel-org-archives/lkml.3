Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaBXIZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 03:25:13 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:50844 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaBXIZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 03:25:10 -0500
MIME-Version: 1.0
In-Reply-To: <CANqRtoRLcac3x55N+VHK+n6RvcgT0v9==9mt1rhVda-zwCYTCg@mail.gmail.com>
References: <1392907779-22053-1-git-send-email-geert@linux-m68k.org>
	<1392907779-22053-5-git-send-email-geert@linux-m68k.org>
	<CANqRtoQQ9cn55Ct7pva2Bo7461WbZG0=Y5f9zLwfKhyU2=QFZw@mail.gmail.com>
	<CAMuHMdWMJFpV_uvi4mNZYc9R8qVWqQf3QGRhdPyc+hj=6XMoJw@mail.gmail.com>
	<CANqRtoRLcac3x55N+VHK+n6RvcgT0v9==9mt1rhVda-zwCYTCg@mail.gmail.com>
Date: Mon, 24 Feb 2014 09:25:08 +0100
X-Google-Sender-Auth: DLCCo5VZ-p8yImwauC1KflD3IdM
Message-ID: <CAMuHMdWDtDqmarg-p+LFv4ZtzF7Rv=KzLQA3rnSa_dS2PkVmfA@mail.gmail.com>
Subject: Re: [PATCH 04/11] ARM: shmobile: lager legacy: Add MSIOF support
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Simon Horman <horms@verge.net.au>, SH-Linux <linux-sh@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus,

On Mon, Feb 24, 2014 at 3:09 AM, Magnus Damm <magnus.damm@gmail.com> wrote:
> On Fri, Feb 21, 2014 at 1:18 AM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>> On Thu, Feb 20, 2014 at 4:48 PM, Magnus Damm <magnus.damm@gmail.com> wrote:
>>> Since only MSIOF1 is used on Lager (correct me if i'm wrong), isn't it
>>> best to omit the unused resources from above? In case of DT I think it
>>> makes sense to define all channels in the SoC.dtsi and let the
>>> SoC-board.dts just enable the channels that are used. But in this case
>>> with legacy code  I think we should keep thing simple and small and
>>> just enable the bits that are used on the particular board.
>>>
>>> The same obviously applies to the Koelsch legacy code as well. =)
>>
>> Note that while all resources are present, only MSIOF1 is registered on
>> Lager (MSIOF0 on Koelsch). This is similar to i2c on Koelsch, which also
>> has all resources, but only registers active devices.
>
> Ok, I understand. Thanks for brining this to my attention.
>
> I'd like to avoid having unused resources so I'll cook up a patch to
> rework that myself.
>
>> It's your preference, though, so I can adapt if you want.
>
> Thanks.
>
> Please rework this patch to only register a single MSIOF channel. I
> think it makes sense to only enable hardware that is being used.

Ehrm, I already register a single MSIOF channel only.
Perhaps you mean't "remove the unused resources"?

> Another question: How about "bus_num" and the platform device id
> mapping? I'd like them to be the same if possible, but you are having
> this "(idx+1)" bit in your code which I assume is to add offset for
> the QSPI bus.

"bus_num" is the SPI-specific numbering of SPI masters, which is filled
in by spi-sh-msiof.c based on platform_device.id (i.e. the numeric suffix
of e.g. "spi_r8a7790_msiof.1").
It's used for matching SPI slaves in spi_board_info with SPI masters.
As QSPI ("qspi.0") has SPI bus_num 0, the MSIOF SPI masters use
bus_num 1 to 4, hence the "idx+1", and the platform device names
"spi_r8a7790_msiof.1" to "spi_r8a7790_msiof.4".

(Can't spi-sh-msiof.c use "bus_num = pdev->id + 1", so we can have
 MSIOF0 as "spi_r8a7790_msiof.0"? No, as that would impact numbering
 on all SoCs with MSIOF.)

With DT, all of this doesn't matter, and life is easier, as the SPI slaves
are child nodes of the SPI masters and thus don't need numerical bus
references. So MSIOF0 can be called "msiof0" there.
We still have the offsets in the "spi%u" aliases, though.

> Regarding the PFC configuration, can you please double check that the
> PIN_MAP_MUX_GROUP_DEFAULT() is in sync with the platform device id? Is
> it the "bus_num" or the platform device id that is being used in case
> of SPI?

"bus_num" is SPI-specific. Pinctrl uses the actual device's name:

/**
 * struct pinctrl_map - boards/machines shall provide this map for devices
 * @dev_name: the name of the device using this specific mapping, the name
 *      must be the same as in your struct device*. If this name is set to the
 *      same name as the pin controllers own dev_name(), the map entry will be
 *      hogged by the driver itself upon registration

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
