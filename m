Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018Ab3HZQFw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 12:05:52 -0400
Received: from mail-qe0-f51.google.com ([209.85.128.51]:38792 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756952Ab3HZQFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 12:05:49 -0400
MIME-Version: 1.0
In-Reply-To: <521B1A87.4000500@samsung.com>
References: <1377188348-3418-1-git-send-email-dianders@chromium.org>
	<1377188348-3418-3-git-send-email-dianders@chromium.org>
	<001201cea215$8c125e30$a4371a90$%jun@samsung.com>
	<521B1A87.4000500@samsung.com>
Date: Mon, 26 Aug 2013 09:05:48 -0700
X-Google-Sender-Auth: LKCdv1y-JDkx9d_2E7VKyFyOfT8
Message-ID: <CAD=FV=WYMyGVmG-DXk1ke-yQCrfF74KDaZAUCW3qzf+Xfp-tpQ@mail.gmail.com>
Subject: Re: [PATCH v6 2/3] mmc: dw_mmc: Honor requests to set the clock to 0
 (turn off clock)
From: Doug Anderson <dianders@chromium.org>
To: Jaehoon Chung <jh80.chung@samsung.com>
Cc: Seungwon Jeon <tgih.jun@samsung.com>, Chris Ball <cjb@laptop.org>,
        James Hogan <james.hogan@imgtec.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Olof Johansson <olof@lixom.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaehoon / Seungwon,

On Mon, Aug 26, 2013 at 2:06 AM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
> On 08/26/2013 01:34 PM, Seungwon Jeon wrote:
>> On Fri, August 23, 2013, Doug Anderson wrote:
>>> Previously the dw_mmc driver would ignore any requests to disable the
>>> card's clock.  This doesn't seem like a good thing in general, but had
>>> one extra bad side effect in the following situtation:
>>> * mmc core would set clk to 400kHz at boot time while initting
>>> * mmc core would set clk to 0 since no card, but it would be ignored.
>>> * suspend to ram and resume; clocks in the dw_mmc IP block are now 0
>>>   but dw_mmc thinks that they're 400kHz (it ignored the set to 0).
>>> * insert card
>>> * mmc core would set clk to 400kHz which would be considered a no-op.
>>>
>>> Note that if there is no card in the slot and we do a suspend/resume
>>> cycle, we _do_ still end up with differences in a dw_mmc register
>>> dump, but the differences are clock related and we've got the clock
>>> disabled both before and after, so this should be OK.
>>>
>>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>>> ---
>>> Changes in v6:
>>> - Replaces previous pathes that ensured saving/restoring clocks.
>>>
>>>  drivers/mmc/host/dw_mmc.c | 21 +++++++++++----------
>>>  1 file changed, 11 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
>>> index ee5f167..f6c7545 100644
>>> --- a/drivers/mmc/host/dw_mmc.c
>>> +++ b/drivers/mmc/host/dw_mmc.c
>>> @@ -635,7 +635,11 @@ static void dw_mci_setup_bus(struct dw_mci_slot *slot, bool force_clkinit)
>>>      u32 div;
>>>      u32 clk_en_a;
>>>
>>> -    if (slot->clock != host->current_speed || force_clkinit) {
>>> +    if (slot->clock == 0) {
>>> +            mci_writel(host, CLKENA, 0);
>>> +            mci_send_cmd(slot,
>>> +                         SDMMC_CMD_UPD_CLK | SDMMC_CMD_PRV_DAT_WAIT, 0);
>> Basically dw_mmc driver uses host's low power mode(auto clock gating)
>> So, how about keeping origin code rather than programming clock setting to '0'?
> Right, Dw-mmc controller can use the Low-power mode.
> This mode is functionality like clock-gating. Well, i didn't know what benefit we get, if set to 0.

Ah, right.  ...so it's unlikely that we'd save any power because we're
already gating the clock.

I'd really still rather honor the MMC subsystem's request.  It
shouldn't _hurt_ to turn the clock off when the subsystem requests it,
right?  One reason to honor the mmc core is that it will make things
cleaner if/when we support a voltage change operation.  The MMC core
has the logic for the voltage change, and part of that involves
turning off the clock.  We'll already need a bunch of special case
code in dw_mmc for voltage change, but it would be nice to avoid one
extra bit.

Another option would be to add a core MMC quirk to disable MMC_CLKGATE
on a per-driver basis.  In the "single zImage" world that seems like
the right thing to do, since the MMC_CLKGATE description seems to
indicate that enabling that won't really work on all drivers anyway.

-Doug
