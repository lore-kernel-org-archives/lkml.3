Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbaJATbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 15:31:36 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:37705 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbaJATbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 15:31:34 -0400
MIME-Version: 1.0
In-Reply-To: <23953734.KObJ4iLFUI@vostro.rjw.lan>
References: <1412188697-15317-1-git-send-email-geert+renesas@glider.be>
	<23953734.KObJ4iLFUI@vostro.rjw.lan>
Date: Wed, 1 Oct 2014 21:31:32 +0200
X-Google-Sender-Auth: PYtjNYiJoM1zYInXkqu9msu0h68
Message-ID: <CAMuHMdVY+vTmSBmH6LOfRdDCk6VRk7tcYfr5EWo0zwaKtP49ag@mail.gmail.com>
Subject: Re: [PATCH] PM / clock_ops: Fix crash in clocks management code if !CONFIG_PM_RUNTIME
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Wed, Oct 1, 2014 at 9:47 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Wednesday, October 01, 2014 08:38:17 PM Geert Uytterhoeven wrote:
>> Unlike the clocks management code for runtime PM, the code used for
>> system suspend does not check the pm_clock_entry.status field.
>> If pm_clk_acquire() failed, ce->status will be PCE_STATUS_ERROR, and
>> ce->clk will be a negative error code (e.g. 0xfffffffe = -2 = -ENOENT).
>>
>> Depending on the clock implementation, suspend or resume may crash with:
>>
>>     Unable to handle kernel NULL pointer dereference at virtual address 00000026
>>
>> (CCF clk_disable() has an IS_ERR_OR_NULL() check, while CCF clk_enable()
>>  only has a NULL check; pre-CCF implementations may behave differently)
>>
>> While just checking for PCE_STATUS_ERROR would be sufficient, it doesn't
>> hurt to use the same state machine as is done for runtime PM, as this
>> makes the two versions more similar, and eligible for a future
>> consolidation.
>>
>> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>> ---
>> This crash started to happen on armadillo-legacy during s2ram if
>> CONFIG_PM_RUNTIME is not set after applying "[PATCH v2 07/11] ARM:
>> shmobile: r8a7740/armadillo legacy: Add A4MP pm domain support"
>> (http://www.spinics.net/linux/lists/arm-kernel/msg365438.html), as
>> there's no NULL clock for the HDMI device.
>>
>> Most existing code calling pm_clk_suspend()/pm_clk_resume() is protected
>> by a check for CONFIG_PM_RUNTIME (davinci, keystone, omap1,
>> drivers/sh/pm_runtime.c), so it was not affected by this bug.
>>
>> Exceptions are:
>>   - arch/arm/mach-shmobile/pm-r8a7779.c (marzen),
>>   - arch/arm/mach-shmobile/pm-rmobile.c (r8a7740/armadillo and
>>     sh7372/mackerel),
>> but it's difficult to assess from the code whether the bug is really
>> triggered on these platforms.
>>
>> Grygorii Strashko's "[PATCH v1 2/4] ARM: keystone: pm: switch to use
>> generic pm domains" is not affected, as pm_clk_add_clk() is only called
>> for existing clocks.
>>
>> If it crashes on marzen or mackerel, I think this fix needs to be
>> applied to stable, too. I don't have access to marzen or mackerel boards,
>> though.
>>
>> How to test:
>>   - Build a kernel with CONFIG_PM_SLEEP/CONFIG_SUSPEND enabled, but
>>     CONFIG_PM_RUNTIME disabled,
>>   - echo 0 > /sys/module/printk/parameters/console_suspend,
>>   - echo mem > /sys/power/state,
>>   - wake up using e.g. gpio-keys or serial console activity.
>
> Do I think correctly that this would be 3.18 material?

Yes indeed, so Simon can queue up the R-Mobile PM domain bits that will
trigger this on armadillo for 3.19.

If it can be triggered on marzen or mackerel now, I think we need it in
stable, too.

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
