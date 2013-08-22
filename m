Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab3HVAy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 20:54:58 -0400
Received: from mail-qe0-f45.google.com ([209.85.128.45]:41494 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab3HVAy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 20:54:56 -0400
MIME-Version: 1.0
In-Reply-To: <000c01ce972b$9ba23590$d2e6a0b0$%jun@samsung.com>
References: <1373470926-19314-1-git-send-email-dianders@chromium.org>
	<1375825071-20922-1-git-send-email-dianders@chromium.org>
	<1375825071-20922-2-git-send-email-dianders@chromium.org>
	<001801ce9504$d9976ab0$8cc64010$%jun@samsung.com>
	<CAD=FV=VmtoxnRzjsKF1rVTwvkJRAxKGUvNZHAEwuWaeVokzSZA@mail.gmail.com>
	<000c01ce972b$9ba23590$d2e6a0b0$%jun@samsung.com>
Date: Wed, 21 Aug 2013 17:54:55 -0700
X-Google-Sender-Auth: 7bqIWHS0Kh2dDl0G7KCY2sLgLgM
Message-ID: <CAD=FV=WVFGwG7KGBritORUMvWUVH19uaoMLyQufnL5D-Rd76Ww@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] mmc: dw_mmc: Invalidate cache of current_speed
 after suspend/resume
From: Doug Anderson <dianders@chromium.org>
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>,
        Olof Johansson <olof@lixom.net>, James Hogan <james.hogan@imgtec.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seungwon,

On Mon, Aug 12, 2013 at 12:14 AM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> On Sat, August 10, 2013, Doug Anderson wrote:
>> Seungwon and Jaehoon,
>>
>> On Fri, Aug 9, 2013 at 6:32 AM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
>> > On Wed, August 07, 2013, Doug Anderson wrote:
>> >> The dw_mmc driver keeps a cache of the current slot->clock in order to
>> >> avoid doing a whole lot of work every time set_ios() is called.
>> >> However, after suspend/resume the register values are bogus so we need
>> >> to ensure that the cached value is invalidated.
>> > This mismatch comes only in case MMC_PM_KEEP_POWER, right?
>>
>> Actually, no.  I saw problems with the SD Card slot, which doesn't
>> have MMC_KEEP_POWER.  Problems showed up when no card was inserted
>> across suspend/resume.  In other words:
>>
>> 1. At boot time, slot is all setup and configured to 400kHz.
>>
>> 2. Suspend
>>
>> 3. Resume; clock registers are reset (by suspend/resume) and not
>> restored since dw_mmc still thinks slot is configured for 400kHz due
>> to host->current_speed cache.
>>
>> 4. Insert card.
>>
>> 5. No code sees any need to change the clock for detecting the card,
>> since everyone thinks it's at 400kHz.  ...but it's not.
>
> Doug, your analysis is right.
> But, let me suggest another approach.
> After step #1, core layer actually call mmc_power_off because slot is empthy(get_cd() is '0').
> Then, set_ios is requested with 'ios->clock'.
> However, because current implementation doesn't update current_speed in case ios->clock is '0'.
> It causes current_speed has invalid clock rate in resume of dw-mmc.
>
> So, if we can update slot->clock properly, it will be fixed.
>
> -static void dw_mci_setup_bus(struct dw_mci_slot *slot, bool force_clkinit)
> +static void dw_mci_setup_bus(struct dw_mci_slot *slot)
>  {
>         struct dw_mci *host = slot->host;
>         u32 div;
>         u32 clk_en_a;
>
> -       if (slot->clock != host->current_speed || force_clkinit) {
> +       if (slot->clock && (slot->clock != host->current_speed)) {
>
>
> @@ -807,13 +807,11 @@ static void dw_mci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
>
>         mci_writel(slot->host, UHS_REG, regs);
>
> -       if (ios->clock) {
> -               /*
> -                * Use mirror of ios->clock to prevent race with mmc
> -                * core ios update when finding the minimum.
> -                */
> -               slot->clock = ios->clock;
> -       }
> +       /*
> +        * Use mirror of ios->clock to prevent race with mmc
> +        * core ios update when finding the minimum.
> +        */
> +       slot->clock = ios->clock;

So this scares me a little bit but you're correct that it's probably
the right thing.  Mostly it scares me to remove code that someone
clearly added on purpose without understanding why they originally
added it and why that reason is not valid (or is no longer valid due
to other changes).

I've actually got a change similar to this as part of my WIP SDIO 3.0
series that I haven't had time to finish (I've been saying that a lot
recently...) at
<https://gerrit.chromium.org/gerrit/#/c/61942/1/drivers/mmc/host/dw_mmc.c>.
 I see a bunch of patches that seem related to SDIO 3.0 from you that
were just posted.  I'll have to look them over if I can find the
time...

I've come up with a new patch that's a little bit more than just your
patch.  It actually does something in the case of a zero clock (it
turns the clock off).  My patch seems to work OK on my 3.8 branch but
I want to do a little more testing tomorrow.  ...but booting on ToT
linux seems broken now on the ARM chromebook (it fails in several
different ways and sometimes works).  Sigh.

In any case, I'll post up tomorrow.  It won't have as much testing as
my old series (which I'm using every day since it's landed in our
tree), but I'll do some basic testing and we'll deal with any issues
that come up.

-Doug
