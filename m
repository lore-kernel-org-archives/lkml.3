Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbaC1NU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 09:20:27 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:35056 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbaC1NUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 09:20:25 -0400
MIME-Version: 1.0
In-Reply-To: <2775124.TXohNNxBKa@avalon>
References: <1391191965-31102-1-git-send-email-balbi@ti.com>
	<2775124.TXohNNxBKa@avalon>
Date: Fri, 28 Mar 2014 14:20:24 +0100
X-Google-Sender-Auth: HJiEUvU4p8nS0fPotpCCD6TUV3M
Message-ID: <CAMuHMdWMiEnpdMgFtAuq70TUxDGWje6thc_Rnaptnua0XTBOMw@mail.gmail.com>
Subject: Re: [RFC/PATCH] base: platform: add generic clock handling for platform-bus
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@linaro.org>,
        Tero Kristo <t-kristo@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Wed, Mar 12, 2014 at 4:37 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Friday 31 January 2014 12:12:45 Felipe Balbi wrote:
>> Still TODO a commit log. Not for merging!!!!!
>>
>> NYET-Signed-off-by: Felipe Balbi <balbi@ti.com>
>> ---
>>
>> This patch is an idea I've had recently in order to combine several
>> different PM implementations into the platform-bus.
>>
>> This patch is bare minimum for platforms which need to handle functional and
>> interface clocks but the whole thing is made optional.
>>
>> Note that this patch makes sure that by the time a platform_driver's probe
>> is called, we already have clocks enabled and pm_runtime_set_active() has
>> been called, thus making sure that a device driver's pm_runtime_get_sync()
>> will solely increase the pm usage counter.
>>
>> I have *NOT* tested this anywhere *YET*, but I suppose it shouldn't cause
>> any issues since the clock API has ref counting too.
>>
>> Would really like to get some review from several folks involved with ARM
>> SoC PM so that's the reason for the wide audience. If I have missed
>> anybody, please add them to Cc.
>>
>> As mentioned above, this is *NOT* meant for merging, but serves as a
>> starting point for discussing some convergence of several PM domain
>> implementations on different arch/arm/mach-* directories.
>>
>> For OMAP, this has the added benefit of removing clock handling from
>> omap_device/omap_hwmod and, thus, dropping the need for so many DT_CLK()
>> tables under drivers/clk/ti/
>>
>>  drivers/base/platform.c         | 169 +++++++++++++++++++++++++++++++++++--
>>  include/linux/platform_device.h |   9 +++
>>  2 files changed, 173 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
>> index 3a94b79..86aeb5b 100644
>> --- a/drivers/base/platform.c
>> +++ b/drivers/base/platform.c
>> @@ -484,6 +484,21 @@ static int platform_drv_probe(struct device *_dev)
>>       if (ACPI_HANDLE(_dev))
>>               acpi_dev_pm_attach(_dev, true);
>>
>> +     dev->fck = devm_clk_get(_dev, "fck");
>> +     dev->ick = devm_clk_get(_dev, "ick");
>
> My concern with this that some devices might want to handle their functional
> and interface clocks manually if they have exotic requirements. They would
> thus need a way to signal that the platform bus core should not try to perform
> clock management on its own.
>
> One possible way would be to name the clocks differently for those devices,
> but we might then have a backward compatibility issue with DT.
>
> Another concern is how to handle the DT backward compatibility for devices
> that would benefit from core management of their functional and interface
> clocks, but that currently don't name those clocks "fck" and "ick". Renaming
> those clocks in DT wouldn't be a problem for the future, but backward
> compatibility needs to be handled. Maybe platforms could provide aliases in
> that case.

IIUC, on OMAP the "fck" and "ick" clock names are also not present in DT.

Device nodes have "ti,hwmods" properties, while the board code uses
struct omap_hwmod to match the "ti,hwmods" values with clock names, and
creates fck aliases for them, right?

Thanks for your answer!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
