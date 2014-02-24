Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbaBXJsa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 04:48:30 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50837 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbaBXJs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 04:48:27 -0500
MIME-Version: 1.0
In-Reply-To: <20140222032700.GX25940@sirena.org.uk>
References: <1392907389-21798-1-git-send-email-geert@linux-m68k.org>
	<1392907389-21798-9-git-send-email-geert@linux-m68k.org>
	<20140222032700.GX25940@sirena.org.uk>
Date: Mon, 24 Feb 2014 10:48:26 +0100
X-Google-Sender-Auth: zwWPIsBK8mxBR-Ry1-DqewQANpg
Message-ID: <CAMuHMdWF5BnPPFoWPqASQjc+9GCYZQEVcWRZaLNFzdz0rAt0_A@mail.gmail.com>
Subject: Re: [PATCH 08/10] spi: sh-msiof: Move clock management to (un)prepare_message()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>, Magnus Damm <magnus.damm@gmail.com>
Cc: Takashi Yoshii <takasi-y@ops.dti.ne.jp>,
        linux-spi <linux-spi@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark, Magnus,

On Sat, Feb 22, 2014 at 4:27 AM, Mark Brown <broonie@kernel.org> wrote:
> On Thu, Feb 20, 2014 at 03:43:07PM +0100, Geert Uytterhoeven wrote:
>
>> +     if (!test_and_set_bit(0, &p->flags)) {
>> +             pm_runtime_get_sync(&p->pdev->dev);
>> +             clk_enable(p->clk);
>> +     }
>
> That test_and_set_bit() is a bit odd - what's going on there, perhaps a
> comment is in order?  I'd also like to see return value checks, though

My first guess was to support multiple CS, but you can't have multiple
active SPI slaves at the same time.

Perhaps it's because the bitbang core may call the .chipselect() callback
multiple times with is_on == BITBANG_CS_ACTIVE, and obviously the
clock should be enabled/disabled only once?
The current code doesn't seem to do that, but perhaps it was different when
the sh-msiof driver was written?

Ah, there's also the initial .chipselect(..., BITBANG_CS_INACTIVE) call
in spi_bitbang_setup(), which should not disable the clock.
But it should still call sh_msiof_spi_set_pin_regs() and set the optional
GPIO CS. Which is no longer done after my series. I'll fix that.

Magnus, do you remember the rationale for the test_and_set_bit()?

Anyway, it seems safe to remove it, as .(un)prepare_message() is
guaranteed to be called in matching pairs.

> the original didn't have them so it's not a blocker, and ideally that
> should be clk_prepare_enable().  I guess the clock stuff could even be
> moved inside the runtime PM callbacks?  Again not a blocker if the
> existing code doesn't have things but it'd be nice to do.
>
> There's also auto_runtime_pm in the SPI core which will do the runtime
> PM for you if you can do it unconditionally.

As you mention yourself, all of this code existed before. It just got moved,
to make the conversion to the SPI core message handling easier.
If you don't mind, I'd like to defer these, and tackle runtime PM later.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
