Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788AbaDVLgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 07:36:16 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:45436 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680AbaDVLgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 07:36:12 -0400
MIME-Version: 1.0
In-Reply-To: <000801cf5e19$07613c40$1623b4c0$%jun@samsung.com>
References: <000c01cf5df8$1fecf810$5fc6e830$%jun@samsung.com>
	<CAPDyKFoMOJ_Eb3O5B-Sy-fF0Yx7Mp==3-Wyff=rTVNCO3YxCFg@mail.gmail.com>
	<000801cf5e19$07613c40$1623b4c0$%jun@samsung.com>
Date: Tue, 22 Apr 2014 13:36:11 +0200
Message-ID: <CAPDyKFpe4_3BXFB8jxHhZknfmT2UrO6ddCcOpq2whN3ayEO6Dg@mail.gmail.com>
Subject: Re: [PATCH] linux-next: rsi: fix using of removed stuff from mmc
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Fariya Fatima <fariyaf@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <chris@printf.net>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 April 2014 12:53, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> On Tue, April 22, 2014, Ulf Hansson wrote:
>> On 22 April 2014 08:57, Seungwon Jeon <tgih.jun@samsung.com> wrote:
>> > As commit 3957848(mmc: drop the speed mode of card's state) applies,
>> > this change should be followed.
>> >
>> > drivers/net/wireless/rsi/rsi_91x_sdio.c:288:20: error: 'MMC_STATE_HIGHSPEED' undeclared (first use
>> in this function)
>> > drivers/net/wireless/rsi/rsi_91x_sdio.c:299:4: error: implicit declaration of function
>> 'mmc_card_set_highspeed' [-Werror=implicit-function-declaration]
>> > drivers/net/wireless/rsi/rsi_91x_sdio.c:306:2: error: implicit declaration of function
>> 'mmc_card_highspeed' [-Werror=implicit-function-declaration]
>> >
>> > Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
>>
>> Hi Seungwon,
>>
>> Thanks for responding quickly!
>>
>> > ---
>> >  drivers/net/wireless/rsi/rsi_91x_sdio.c |    4 +---
>> >  1 files changed, 1 insertions(+), 3 deletions(-)
>> >
>> > diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
>> > index 2e39d38..46e7af4 100644
>> > --- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
>> > +++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
>> > @@ -285,7 +285,6 @@ static void rsi_reset_card(struct sdio_func *pfunction)
>> >                 if (err) {
>> >                         rsi_dbg(ERR_ZONE, "%s: CCCR speed reg read failed: %d\n",
>> >                                 __func__, err);
>> > -                       card->state &= ~MMC_STATE_HIGHSPEED;
>> >                 } else {
>> >                         err = rsi_cmd52writebyte(card,
>> >                                                  SDIO_CCCR_SPEED,
>> > @@ -296,14 +295,13 @@ static void rsi_reset_card(struct sdio_func *pfunction)
>> >                                         __func__, err);
>> >                                 return;
>> >                         }
>> > -                       mmc_card_set_highspeed(card);
>> >                         host->ios.timing = MMC_TIMING_SD_HS;
>> >                         host->ops->set_ios(host, &host->ios);
>> >                 }
>> >         }
>> >
>> >         /* Set clock */
>> > -       if (mmc_card_highspeed(card))
>> > +       if (mmc_card_hs(card))
>> >                 clock = 50000000;
>> >         else
>> >                 clock = card->cis.max_dtr;
>> > --
>> > 1.7.0.4
>> >
>> >
>>
>> I am not sure it's safe to carry this patch through Chris' mmc tree
>> due to merge conflicts with John's wireless tree.
>>
>> Though, since you have changed the mmc_card_highspeed() function to be
>> named to mmc_card_hs(), we need to work out the dependency.
>>
>> We have some options to handle this, I suggest the following.
>>
>> Re-spin this patch to keep using mmc_card_highspeed() and let John
>> take it through his wireless tree. Thus  you also need to keep the
> It would be better if this patch can be handled in Chris's.
> Because if the rest of changes of this patch with keeping "mmc_card_highspeed" is applied,
> high-speed SDIO will be ignored in John's tree.

You are right Seungwon!

Please re-spin the patchset on the mmc core an squash the code from
this patch, into the patch "mmc: drop the speed mode of card's state".
We then need to get acks from John and Fariya.

BTW, I had a look at the rsi_reset_card() function
(drivers/net/wireless/rsi/rsi_91x_sdio.c), which handles a complete
SDIO re-initialization and I think performs "layering violations"
while doing that.  I suppose it's because of lack of documentation
about the mmc/sdio core, but I really don't think an SDIO func driver
should be doing that kind of stuff by itself. There are APIs to use to
perform an SDIO reset. Two options exists:

a) Use pm_runtime_get|put in combination with a MMC_CAP_POWER_OFF_CARD
enabled host.
b) Invoke mmc_power_save|restore_host() API.

Kind regards
Ulf Hansson

>
> Thanks,
> Seungwon Jeon
>
>> name mmc_card_highspeed() function from the patches to the mmc core -
>> could you please re-spin and post new version of those patches as
>> well!?
>>
>> Kind regards
>> Ulf Hansson
>
