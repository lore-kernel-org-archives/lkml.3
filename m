Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762544Ab3ECKi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 06:38:26 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33617 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755491Ab3ECKiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 06:38:24 -0400
Date: Fri, 3 May 2013 11:38:19 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Russell King <linux@arm.linux.org.uk>,
        Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH 3/4] mmc: mmci: Ensure return value of regulator_enable()
 is checked
Message-ID: <20130503103819.GE24153@gmail.com>
References: <1367509690-24022-1-git-send-email-lee.jones@linaro.org>
 <1367509690-24022-4-git-send-email-lee.jones@linaro.org>
 <CAPDyKFr60-nuh-BFsWtFhNeqUmswKC4hL4mw-gDhiqLmarvEDA@mail.gmail.com>
 <20130503081633.GD24153@gmail.com>
 <CAPDyKFqKP0sSBwZtcnH4tfPxSik5+GOVE-6tTBYaK5Qhvr3=4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPDyKFqKP0sSBwZtcnH4tfPxSik5+GOVE-6tTBYaK5Qhvr3=4A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 May 2013, Ulf Hansson wrote:

> On 3 May 2013 10:16, Lee Jones <lee.jones@linaro.org> wrote:
> > On Fri, 03 May 2013, Ulf Hansson wrote:
> >
> >> On 2 May 2013 17:48, Lee Jones <lee.jones@linaro.org> wrote:
> >> > This patch suppresses the warning below:
> >> >
> >> > drivers/mmc/host/mmci.c: In function ‘mmci_set_ios’:
> >> > drivers/mmc/host/mmci.c:1165:20: warning: ignoring return value of
> >> >         ‘regulator_enable’, declared with attribute warn_unused_result
> >> >         [-Wunused-result]
> >> >
> >> > Cc: Russell King <linux@arm.linux.org.uk>
> >> > Cc: Chris Ball <cjb@laptop.org>
> >> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> >> > ---
> >> >  drivers/mmc/host/mmci.c |    9 +++++++--
> >> >  1 file changed, 7 insertions(+), 2 deletions(-)
> >> >
> >> > diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
> >> > index 375c109..f4f3038 100644
> >> > --- a/drivers/mmc/host/mmci.c
> >> > +++ b/drivers/mmc/host/mmci.c
> >> > @@ -1130,6 +1130,7 @@ static void mmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
> >> >         struct variant_data *variant = host->variant;
> >> >         u32 pwr = 0;
> >> >         unsigned long flags;
> >> > +       int ret;
> >> >
> >> >         pm_runtime_get_sync(mmc_dev(mmc));
> >> >
> >> > @@ -1161,8 +1162,12 @@ static void mmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
> >> >                 break;
> >> >         case MMC_POWER_ON:
> >> >                 if (!IS_ERR(mmc->supply.vqmmc) &&
> >> > -                   !regulator_is_enabled(mmc->supply.vqmmc))
> >>
> >> I realize that we actually have a bug here (and in the MMC_POWER_OFF
> >> mode as well).
> >>
> >> We shall not use regulator_is_enabled API as a trigger to enable/fetch
> >> a reference to the regulator, since it will only tell us if the
> >> regulator is enabled - hw wise.
> >> Instead we need a local variable in the mmci host struct keeping track
> >> if we have enabled the regulator. Do you mind fix this up in this
> >> patch as well since it is tightly coupled to the regulator handling!?
> >
> > IMHO I think that should be taken care of in a separate patch. This
> > patch only touches the line containing regulator_is_enabled() to
> > encompass a multi-line comparison result.
> >
> > Care to write that patch? I have so much on my TODO already. :|
> 
> Sure, I can fix it.
> 
> I guess this patch will be going through Russell's patch tracker?

Yeah, I'll queue this and another one I have in a bit.

> >> Otherwise it looks good to me.
> >>
> >> Kind regards
> >> Ulf Hansson
> >>
> >> > -                       regulator_enable(mmc->supply.vqmmc);
> >> > +                   !regulator_is_enabled(mmc->supply.vqmmc)) {
> >> > +                       ret = regulator_enable(mmc->supply.vqmmc);
> >> > +                       if (ret < 0)
> >> > +                               dev_err(mmc_dev(mmc),
> >> > +                                       "failed to enable vqmmc regulator\n");
> >> > +               }
> >> >
> >> >                 pwr |= MCI_PWR_ON;
> >> >                 break;
> >> >
> >

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
