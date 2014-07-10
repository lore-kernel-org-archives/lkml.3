Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbaGJLZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 07:25:57 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:63965 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbaGJLZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 07:25:55 -0400
MIME-Version: 1.0
In-Reply-To: <CAFcVEC+-bM91WmfwweDdTvJ7KwH+dxKDLkzsT82snWKhukLeYQ@mail.gmail.com>
References: <1404982207-4707-1-git-send-email-harinik@xilinx.com>
	<1404982207-4707-2-git-send-email-harinik@xilinx.com>
	<CAMuHMdXO-PkQ+07F=aZEjvH1Kh7uhWK8i3V9w+1aHvvtg7wDoQ@mail.gmail.com>
	<CAFcVECJ93Lw1MRVU-=zLRbB6To--zmAxz8OLObu=mhV84-FTNA@mail.gmail.com>
	<CAMuHMdU2HyCwXBJTAyswyj7XqhzhHQ24MamGLLVgMwU4xi0kxQ@mail.gmail.com>
	<CAFcVEC+-bM91WmfwweDdTvJ7KwH+dxKDLkzsT82snWKhukLeYQ@mail.gmail.com>
Date: Thu, 10 Jul 2014 13:25:53 +0200
X-Google-Sender-Auth: uaZe5URpPRs4CbOD920gNUGErNs
Message-ID: <CAMuHMdVcBBNQfA--vOqwsyypwdL4HGs7YuR-SkZPttxeMeRn5g@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] spi: Add support for Zynq QSPI controller
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Harini Katakam <harinikatakamlinux@gmail.com>
Cc: Mark Brown <broonie@kernel.org>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        =?UTF-8?B?TWFyZWsgVmHFoXV0?= <marex@denx.de>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jingoo Han <jg1.han@samsung.com>, Sourav Poddar <sourav.poddar@ti.com>,
        "michals@xilinx.com" <michals@xilinx.com>,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harini,

On Thu, Jul 10, 2014 at 12:33 PM, Harini Katakam
<harinikatakamlinux@gmail.com> wrote:
> On Thu, Jul 10, 2014 at 3:12 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>> On Thu, Jul 10, 2014 at 11:31 AM, Harini Katakam
>> <harinikatakamlinux@gmail.com> wrote:
>>>>> +       master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_RX_DUAL | SPI_RX_QUAD |
>>>>> +                           SPI_TX_DUAL | SPI_TX_QUAD;
>>>>
>>>> Your driver advertises Dual/Quad SPI Transfer capabilities, but it doesn't
>>>> check spi_transfer.[tr]x_nbits? How can it determine when to enable Dual/Quad?
>>>
>>> Here the driver is just giving information that the controller support it.
>>> The MTD layer enables dual/quad based on what the flash supports; quad
>>> being the first priority
>>> I understand that the spi core reads rx, tx-bus-width property and
>>> master support flags and
>>> performs the necessary checks.
>>
>> That's correct: as long as the rx, tx-bus-width  properties do not indicate a
>> Dual or Quad wiring, it won't be used.
>>
>> However, based on schematics, someone may set the rx, tx-bus-width properties
>> to 4, which is correct, as DT describes the hardware. But this will fail to
>> work.
>> So I think it's safer not to announce Dual/Quad support in the driver until
>> the actual driver support is there.
>
> OK. Correct me if I'm wrong but announcing this support in master->flags is
> just to say the controller supports it - Like Punnaiah mentioned in the other
> mail, nothing specific needs to be done from the controller driver to enable
> dual/quad support. This is at the SOC/IP level.
> I agree it might or might not be supported at board-level.

IC. So this is not a generic SPI controller, but a controller meant for QSPI
FLASHes? I.e. if you would connect a different device, the controller may
unexpectedly use Dual or Quad mode if it sees a byte fly by that looks like
a Quad SPI FLASH read command?

> But that's based on the user's hardware. Should master->flags
> really take this into consideration?

You mean master->mode_bits?

> BTW, I dint see master->mode_bits being used anywhere at the moment.

It is used to match SPI controller and slave features, cfr. spi_setup() in
drivers/spi/spi.c.

If Dual/Quad is supported, the bits should be set. Else spi_setup() will
clear the bits in the SPI slave's mode field, disabling Dual/Quad transfers.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
