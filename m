Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117Ab3EPWZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 18:25:20 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:34883 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821Ab3EPWZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 18:25:18 -0400
MIME-Version: 1.0
In-Reply-To: <1483058.pKLP2TAAG6@flatron>
References: <1368724352-10849-1-git-send-email-dianders@chromium.org>
	<1368724352-10849-3-git-send-email-dianders@chromium.org>
	<1483058.pKLP2TAAG6@flatron>
Date: Thu, 16 May 2013 15:25:15 -0700
X-Google-Sender-Auth: GK3tr2Q93VrWaXm6SWoOth-wCrI
Message-ID: <CAD=FV=V=QWg8fYX7iZeG6RoQQFGtsQhd7ZLodyVVuYWYZ9fRFg@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: exynos: fix eint wakeup by using irq_set_wake()
From: Doug Anderson <dianders@chromium.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Prathyush K <prathyush.k@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz,

On Thu, May 16, 2013 at 12:26 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> On Thursday 16 of May 2013 10:12:32 Doug Anderson wrote:
>> From: Prathyush K <prathyush.k@samsung.com>
>>
>> Add the irq_set_wake function for exynos pinctrl to configure the
>> external interrupt wakeup mask register.
>>
>> [dianders: minor nit fixes; port to ToT]
>>
>> Signed-off-by: Prathyush K <prathyush.k@samsung.com>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> ---
>>  drivers/pinctrl/pinctrl-exynos.c  | 45
>> ++++++++++++++++++++++++++++-----------
>> drivers/pinctrl/pinctrl-exynos.h  |  3 ++-
>>  drivers/pinctrl/pinctrl-samsung.h |  2 ++
>>  3 files changed, 37 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/pinctrl/pinctrl-exynos.c
>> b/drivers/pinctrl/pinctrl-exynos.c index ac74281..3ebb2ff 100644
>> --- a/drivers/pinctrl/pinctrl-exynos.c
>> +++ b/drivers/pinctrl/pinctrl-exynos.c
>> @@ -30,6 +30,8 @@
>>  #include <linux/spinlock.h>
>>  #include <linux/err.h>
>>
>> +#include <plat/pm.h>
>> +
>
> This is not going to work with CONFIG_MULTIPLATFORM.

Hmm, this sounds like it might be a bit of a long path, especially
since I haven't been keeping up with what's been going on with
MULTIPLATFORM and I'm currently midway through making 3.8 work (which
has no MULTIPLATFORM).

Perhaps for this patch it makes more sense for you to post your
version and I can review it?  We may end up just keeping our version
of this patch for 3.8 and pick up yours when we do our next rebase.
Does that sound OK?


>> -#define EXYNOS_PIN_BANK_EINTW(pins, reg, id, offs)   \
>> +#define EXYNOS_PIN_BANK_EINTW(pins, reg, id, offs, base)\
>>       {                                               \
>>               .type           = &bank_type_alive,     \
>>               .pctl_offset    = reg,                  \
>>               .nr_pins        = pins,                 \
>>               .eint_type      = EINT_TYPE_WKUP,       \
>>               .eint_offset    = offs,                 \
>> +             .eint_base      = base,                 \
>
> I can't look at my patch at the moment, but I think I have managed to get
> EINT index without adding this extra field.

It looks like this is always 2 * eint_offset in the code above.  Maybe
you just multiplied?  The multiplication works fine although I think
specifying eint_base like this might be more generic and handle future
chips better?  Ya never know...

-Doug
