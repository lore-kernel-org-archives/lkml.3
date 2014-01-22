Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbaAVU0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 15:26:16 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:54140 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbaAVU0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 15:26:14 -0500
MIME-Version: 1.0
In-Reply-To: <20140122191947.GQ20094@book.gsilab.sittig.org>
References: <1390317009-8292-1-git-send-email-geert@linux-m68k.org>
	<1390317009-8292-4-git-send-email-geert@linux-m68k.org>
	<20140121182130.GM17314@sirena.org.uk>
	<CAMuHMdWW1EsHe0u0o8XZuG4AzPKRqKL7ET5Ac2NkbeLRfW_foQ@mail.gmail.com>
	<20140122191947.GQ20094@book.gsilab.sittig.org>
Date: Wed, 22 Jan 2014 21:26:13 +0100
X-Google-Sender-Auth: 1qh1RmB11yRhuHBjYgN7xpcVQ2g
Message-ID: <CAMuHMdXir2hTk1dueo5F5zL=007ZVJg3eXVMN7xYmumOMNoeCQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] spi: Check that Quad/Dual is half duplex
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Gerhard Sittig <gsi@denx.de>
Cc: Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 8:19 PM, Gerhard Sittig <gsi@denx.de> wrote:
> On Tue, Jan 21, 2014 at 21:06 +0100, Geert Uytterhoeven wrote:
>> On Tue, Jan 21, 2014 at 7:21 PM, Mark Brown <broonie@kernel.org> wrote:
>> > On Tue, Jan 21, 2014 at 04:10:08PM +0100, Geert Uytterhoeven wrote:
>> >> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>> >> Quad and Dual SPI Transfers use all available data lines
>> >> (incl. MOSI/MISO), hence they must be half duplex. Add a
>> >> check that verify that.
>> >
>> > This is surprising to me - I had expected that there would be
>> > extra signals that would be used for these modes, not that
>> > the opposite direction data line would be one of the ones
>> > being reused.  On the other hand if this is what all the
>> > flash chips do then it would seem reasonable that controllers
>> > do the same.  Can you clarify please?
>>
>> Dual SPI works by aggregating the MOSI and MISO lines for 2-bit
>> unidirectional transfers.
>> Quad SPI aggregates MOSI, MISO, and 2 additional lines for 4-bit
>> unidirectional transfers.
>
> Does it help to only use the MOSI/MISO names for single data line
> transfers, and to explicitly mention the fact that multi data
> line transfers change the signals' meaning to "IO0 .. IO3", and
> that these "IOn" lines are used in half duplex ways?

Maybe. But both MOSI/MISO and IO0/IO1 are carried over the
same physical signal lines.

>> Hence Dual SPI uses the traditional 4-wire wiring, while Quad
>> SPI uses 6-wire.
>
> Be careful!  Just because the number of wires is identical, I
> would not want to refer to it as "the traditional 4-wire wiring"
> in the dual data line case.  Strictly speaking it's not that you
> connect MISO+MOSI with MISO+MOSI, insted you connect IO0+IO1 with
> IO0+IO1.  It just happens that the same pins are re-used, while
> the signals do change their meaning.

Sure you do, as typically the first transfer is a Single SPI write
to the slave, to tell it the next transfer will be Dual or Quad.

So you do connect both MISO+MOSI with MISO+MOSI, and
IO0+IO1 to IO0+IO1.

> Now add unidirectional transmitters (amplifiers and/or level
> shifters) to the picture instead of mere wires, and you cannot
> run all modes across these connections any longer as you may
> assume at the moment.

That should be reflected in the DT, using the spi-tx-bus-width and
spi-rx-bus-width properties of the SPI slave device, right?

> IO2 and IO3 in quad data line mode do change the meaning of the
> pins which they re-purpose, too (that's write protect and hold
> usually).  Which is why the features of the SPI controller and
> the flash chip alone may not be sufficient to determine which
> modes are available, as the board may add constraints as well.

Same here.

>> SPI FLASH chips handle it this way, and the Renesas QSPI
>> controller in the r8a7790/7791 SoCs, too.
>>
>> Typically the first transfer in a message is a Single Transfer
>> (e.g. read data command), while subsequent transfers can be
>> Dual or Quad Transfers (e.g.  the actual data read from the
>> FLASH).
>
> Please note that subsequent transfers may be single data line
> transfers as well. :)

Yes they can ;-)

> BTW am I trying to be strict about the above implicit assumption
> of "dual/quad" meaning the number of data lines.  To not confuse
> them with dual data rate transfers, which are orthogonal to the
> number of data lines in use, and are available in chips as well
> (see the S25FL256S data sheet that was referenced in the Quad-SPI
> discussion earlier).
> Let's be clear from the beginning, to not have to cleanup or
> guess afterwards.

Sure, that's why I try to always write "Dual SPI Transfers" or "Quad
SPI Transfers".

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
