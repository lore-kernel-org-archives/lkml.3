Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbaBTMmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 07:42:13 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:48236 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733AbaBTMmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 07:42:09 -0500
MIME-Version: 1.0
In-Reply-To: <20140211184749.254574462@linuxfoundation.org>
References: <20140211184748.191276235@linuxfoundation.org>
	<20140211184749.254574462@linuxfoundation.org>
Date: Thu, 20 Feb 2014 13:42:08 +0100
X-Google-Sender-Auth: NldrFmPp9zorRP0e1rdTsxJvxqs
Message-ID: <CAMuHMdWVRTPSeVEAPTM7KLME4db0vfBYuH6N7pNoUwNPb0aZ7w@mail.gmail.com>
Subject: Re: [PATCH 3.12 037/107] spidev: fix hang when transfer_one_message fails
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        Mark Brown <broonie@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 8:05 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> 3.12-stable review patch.  If anyone has any objections, please let me know.

Sorry for not noticing this was queued up for stable before, but this
patch was reverted in mainline:

commit 1f802f8249a0da536877842c43c7204064c4de8b
Author: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Date:   Tue Jan 28 10:33:03 2014 +0100

    spi: Fix crash with double message finalisation on error handling

    This reverts commit e120cc0dcf2880a4c5c0a6cb27b655600a1cfa1d.

    It causes a NULL pointer dereference with drivers using the generic
    spi_transfer_one_message(), which always calls
    spi_finalize_current_message(), which zeroes master->cur_msg.

    Drivers implementing transfer_one_message() theirselves must always call
    spi_finalize_current_message(), even if the transfer failed:

     * @transfer_one_message: the subsystem calls the driver to transfer a singl
     *      message while queuing transfers that arrive in the meantime. When th
     *      driver is finished with this message, it must call
     *      spi_finalize_current_message() so the subsystem can issue the next
     *      transfer

    Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
    Signed-off-by: Mark Brown <broonie@linaro.org>

> ------------------
>
> From: Daniel Santos <daniel.santos@pobox.com>
>
> commit e120cc0dcf2880a4c5c0a6cb27b655600a1cfa1d upstream.
>
> This corrects a problem in spi_pump_messages() that leads to an spi
> message hanging forever when a call to transfer_one_message() fails.
> This failure occurs in my MCP2210 driver when the cs_change bit is set
> on the last transfer in a message, an operation which the hardware does
> not support.
>
> Rationale
> Since the transfer_one_message() returns an int, we must presume that it
> may fail.  If transfer_one_message() should never fail, it should return
> void.  Thus, calls to transfer_one_message() should properly manage a
> failure.
>
> Fixes: ffbbdd21329f3 (spi: create a message queueing infrastructure)
> Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
> Signed-off-by: Mark Brown <broonie@linaro.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
>  drivers/spi/spi.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> --- a/drivers/spi/spi.c
> +++ b/drivers/spi/spi.c
> @@ -600,7 +600,9 @@ static void spi_pump_messages(struct kth
>         ret = master->transfer_one_message(master, master->cur_msg);
>         if (ret) {
>                 dev_err(&master->dev,
> -                       "failed to transfer one message from queue\n");
> +                       "failed to transfer one message from queue: %d\n", ret);
> +               master->cur_msg->status = ret;
> +               spi_finalize_current_message(master);
>                 return;
>         }
>  }

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
