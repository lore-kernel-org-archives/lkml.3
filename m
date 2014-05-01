Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644AbaEASSD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 14:18:03 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:57554 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaEASR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 14:17:59 -0400
MIME-Version: 1.0
X-Originating-IP: [209.133.115.210]
In-Reply-To: <CAD=FV=WN4hVibiK_8+mpNfO7UQnd35ZT9EXA9fuw-mnBzzb1cA@mail.gmail.com>
References: <1397689950-1568-1-git-send-email-dianders@chromium.org>
	<1397689950-1568-5-git-send-email-dianders@chromium.org>
	<20140423115102.GO21613@lee--X1>
	<CAD=FV=WN4hVibiK_8+mpNfO7UQnd35ZT9EXA9fuw-mnBzzb1cA@mail.gmail.com>
Date: Thu, 1 May 2014 11:17:58 -0700
Message-ID: <CAOesGMiMiqk1mKcVF8SwePhUS-8cAmM3Ut3f+qRvjz27iw7CTA@mail.gmail.com>
Subject: Re: [PATCH v3 4/5] regulator: tps65090: Allow setting the overcurrent
 wait time
From: Olof Johansson <olof@lixom.net>
To: Doug Anderson <dianders@chromium.org>
Cc: Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@kernel.org>,
        Anton Vorontsov <anton@enomsg.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        AJAY KUMAR RAMAKRISHNA SHYMALAMMA <ajaykumar.rs@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Simon Glass <sjg@chromium.org>, Michael Spang <spang@chromium.org>,
        Sean Paul <seanpaul@chromium.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lee, Doug,

I've bisected a boot failure on Tegra Dalmore (which has a tps65090)
down to this patch. It started in -next 0501, so I guess Lee might
have pushed some patches out now even though the commit date is a
little while back?

The commit is:

commit 60e91b51b515b20f85697fcd397911fdb97bbdca
Author:     Doug Anderson <dianders@chromium.org>
AuthorDate: Wed Apr 16 16:12:28 2014 -0700
Commit:     Lee Jones <lee.jones@linaro.org>
CommitDate: Wed Apr 23 12:34:01 2014 +0100

    regulator: tps65090: Allow setting the overcurrent wait time

    The tps65090 regulator allows you to specify how long you want it to
    wait before detecting an overcurrent condition.  Allow specifying that
    through the device tree (or through platform data).

    Signed-off-by: Doug Anderson <dianders@chromium.org>
    Acked-by: Simon Glass <sjg@chromium.org>
    Acked-by: Michael Spang <spang@chromium.org>
    Acked-by: Sean Paul <seanpaul@chromium.org>
    Acked-by: Mark Brown <broonie@kernel.org>
    Signed-off-by: Lee Jones <lee.jones@linaro.org>


Panic is line 309:

303         for (num = 0; num < TPS65090_REGULATOR_MAX; num++) {
304                 tps_pdata = tps65090_pdata->reg_pdata[num];
305
306                 ri = &pmic[num];
307                 ri->dev = &pdev->dev;
308                 ri->desc = &tps65090_regulator_desc[num];
309                 ri->overcurrent_wait_valid =
tps_pdata->overcurrent_wait_valid;
310                 ri->overcurrent_wait = tps_pdata->overcurrent_wait;

so it looks like tps_pdata is NULL. Should likely be a check for it?


-Olof



On Wed, Apr 23, 2014 at 8:48 AM, Doug Anderson <dianders@chromium.org> wrote:
> Lee,
>
> On Wed, Apr 23, 2014 at 4:51 AM, Lee Jones <lee.jones@linaro.org> wrote:
>>> The tps65090 regulator allows you to specify how long you want it to
>>> wait before detecting an overcurrent condition.  Allow specifying that
>>> through the device tree (or through platform data).
>>>
>>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>>> Signed-off-by: Simon Glass <sjg@chromium.org>
>>> Signed-off-by: Michael Spang <spang@chromium.org>
>>> Signed-off-by: Sean Paul <seanpaul@chromium.org>
>>> ---
>>> Changes in v3:
>>> - Fixed kernel-doc notation for return
>>>
>>> Changes in v2:
>>> - Separated the overcurrent and retries changes into two patches.
>>> - Now set overcurrent at probe time since it doesn't change.
>>>
>>>  .../devicetree/bindings/regulator/tps65090.txt     |  4 ++
>>>  drivers/regulator/tps65090-regulator.c             | 56 ++++++++++++++++++++++
>>>  include/linux/mfd/tps65090.h                       |  5 ++
>>>  3 files changed, 65 insertions(+)
>>
>> Applied, thanks.
>
> Ummmm, Mark said that he had already applied this patch to his tree (I
> mentioned it in my recent summary and you can see it in this thread
> too).  I don't see it on git.kernel.org though
> <https://git.kernel.org/cgit/linux/kernel/git/broonie/regulator.git/log/?h=for-next>
>
> I'm worried this will cause a merge conflict if you both apply it.
>
> -Doug
