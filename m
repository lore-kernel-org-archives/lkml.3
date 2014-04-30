Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759584AbaD3VrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 17:47:22 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:51322 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759107AbaD3VrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 17:47:18 -0400
MIME-Version: 1.0
In-Reply-To: <7hoazpdldx.fsf@paris.lan>
References: <1398334403-26181-1-git-send-email-geert+renesas@glider.be>
	<1398334403-26181-4-git-send-email-geert+renesas@glider.be>
	<7hoazpdldx.fsf@paris.lan>
Date: Wed, 30 Apr 2014 23:47:14 +0200
X-Google-Sender-Auth: OaS_5iL-Fm5upuwvUNVqPYKcpi8
Message-ID: <CAMuHMdWAXDVtHN2bTW515eDqkob=nXm3YFd6SCjjYcmWy_OEyA@mail.gmail.com>
Subject: Re: [PATCH/RFC 3/4] of/clk: Register clocks suitable for Runtime PM
 with the PM core
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kevin Hilman <khilman@linaro.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Felipe Balbi <balbi@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

On Sat, Apr 26, 2014 at 1:44 AM, Kevin Hilman <khilman@linaro.org> wrote:
> Geert Uytterhoeven <geert+renesas@glider.be> writes:
>> When adding a device from DT, check if its clocks are suitable for Runtime
>> PM, and register them with the PM core.
>> If Runtime PM is disabled, just enable the clock.
>>
>> This allows the PM core to automatically manage gate clocks of devices for
>> Runtime PM.
>
> ...unless the device is already in an existing pm_domain, right?

At this point in the kernel boot process, the device cannot be in a
pm_domain yet.

> I like this approach, and it extends nicely what we already do on
> platforms using drivers/base/power/clock_ops.c into DT land.
>
> My only concern is how this will interact if it's used along with
> devices that have existing pm_domains.  I don't have any specific
> concerns (yet, because it's Friday, and my brain is turing off), but it
> just made me wonder if this will be potentially confusing.

Adding devices to pm_domains is done later, so it can be overridden.

> Also...
>
> [...]
>
>> +static int of_clk_register(struct device *dev, struct clk *clk)
>> +{
>> +     int error;
>> +
>> +     if (!dev->pm_domain) {
>> +             error = pm_clk_create(dev);
>> +             if (error)
>> +                     return error;
>> +
>> +             dev->pm_domain = &of_clk_pm_domain;
>> +     }
>> +
>> +     dev_dbg(dev, "Setting up clock for runtime PM management\n");
>> +     return pm_clk_add_clk(dev, clk);
>
> I would've expected these 2 lines to be inside the pm_domain check.
>
> What's the reason for doing the pm_clk_add() when the pm_domain isn't
> going to be used?  I suppose it's harmless, but it's a bit confusing.

Sorry, the !dev->pm_domain check does deserve a comment explaining this.
If there are multiple clocks suitable for pm_runtime, the pm_clk_create(dev)
should be done only once.

Currently e.g. davinci registers 3 clocks with pm_clk ("fck",
"master", and "slave").
Omap has 2 ("fck" and "ick").

BTW, keystone doesn't seem to set pm_clk_notifier_block.con_ids. From a quick
look, this will crash with a NULL-pointer dereference in pm_clk_notify()? Or am
I missing something here?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
