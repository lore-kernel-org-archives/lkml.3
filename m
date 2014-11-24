Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbaKXU1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 15:27:13 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:59654 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbaKXU1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 15:27:08 -0500
MIME-Version: 1.0
In-Reply-To: <6261300.I132f1jLqB@wuerfel>
References: <1416859808-18503-1-git-send-email-geert+renesas@glider.be>
	<6261300.I132f1jLqB@wuerfel>
Date: Mon, 24 Nov 2014 21:27:06 +0100
X-Google-Sender-Auth: WsxBNznXs_gsfkEVqCREtOX37SM
Message-ID: <CAMuHMdVjpL-QgS0aAdMo4EHXibhpKCJC73yY+HDY=+Ae=LMigA@mail.gmail.com>
Subject: Re: [PATCH RFC 0/3] Add "Simple" / Renesas Bus State Controller Driver
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Mon, Nov 24, 2014 at 9:15 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 24 November 2014 21:10:05 Geert Uytterhoeven wrote:
>> As this minimal BSC driver isn't hardware-specific at all, I'm wondering
>> if there's a simpler way to do this?
>>   - Should the driver be renamed to "simple-bus", and match "simple-bus"?
>>   - Should this be moved to core code, without an explicit driver for
>>     "simple-bus"? I.e. should the driver core just enable runtime PM for
>>     all devices not bound to a driver, as they may represent buses with
>>     child devices that do rely on runtime PM?
>>
>> Thanks for your comments and suggestions!
>
> My understanding of simple-bus is that it's something that does
> not have any power-management capabilities, and I'd rather not
> add clocks or interrupts to it.

OK.

> What I think makes more sense is to have a bus driver for it
> in drivers/bus, remove the "simple-bus" compatibility value
> and have the driver take care of registering the power domain
> and probing the child devices using of_platform_populate on
> itself.

Registering power domains is already handled by the core code.

So compared to my RFC code, I only have to
  1. Drop "simple-bus" from the compatible property in the .dtsi,
  2. Call of_platform_populate() from renesas_bsc_probe(), to
     register the child devices, now the core code no longer does that.

I find it a bit strange having to add _more_ code, as the core code handles
registering child devices fine. Doing it from my bus driver only protects
against people trying to run a kernel without my bus driver included
(which currently works fine, as long as no PM domain or clock is involved,
 e.g. if the clock is forgotten in the SoC's .dtsi :-).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
