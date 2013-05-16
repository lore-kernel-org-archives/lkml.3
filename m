Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab3EPWhm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 18:37:42 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:40648 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab3EPWhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 18:37:40 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Prathyush K <prathyush.k@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] pinctrl: exynos: fix eint wakeup by using irq_set_wake()
Date: Fri, 17 May 2013 00:37:37 +0200
Message-ID: <8199419.ooBeNM55eX@flatron>
User-Agent: KMail/4.10.3 (Linux/3.9.2-gentoo; KDE/4.10.3; x86_64; ; )
In-Reply-To: <CAD=FV=V=QWg8fYX7iZeG6RoQQFGtsQhd7ZLodyVVuYWYZ9fRFg@mail.gmail.com>
References: <1368724352-10849-1-git-send-email-dianders@chromium.org> <1483058.pKLP2TAAG6@flatron> <CAD=FV=V=QWg8fYX7iZeG6RoQQFGtsQhd7ZLodyVVuYWYZ9fRFg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 of May 2013 15:25:15 Doug Anderson wrote:
> Tomasz,
> 
> On Thu, May 16, 2013 at 12:26 PM, Tomasz Figa <tomasz.figa@gmail.com> 
wrote:
> > On Thursday 16 of May 2013 10:12:32 Doug Anderson wrote:
> >> From: Prathyush K <prathyush.k@samsung.com>
> >> 
> >> Add the irq_set_wake function for exynos pinctrl to configure the
> >> external interrupt wakeup mask register.
> >> 
> >> [dianders: minor nit fixes; port to ToT]
> >> 
> >> Signed-off-by: Prathyush K <prathyush.k@samsung.com>
> >> Signed-off-by: Doug Anderson <dianders@chromium.org>
> >> ---
> >> 
> >>  drivers/pinctrl/pinctrl-exynos.c  | 45
> >> 
> >> ++++++++++++++++++++++++++++-----------
> >> drivers/pinctrl/pinctrl-exynos.h  |  3 ++-
> >> 
> >>  drivers/pinctrl/pinctrl-samsung.h |  2 ++
> >>  3 files changed, 37 insertions(+), 13 deletions(-)
> >> 
> >> diff --git a/drivers/pinctrl/pinctrl-exynos.c
> >> b/drivers/pinctrl/pinctrl-exynos.c index ac74281..3ebb2ff 100644
> >> --- a/drivers/pinctrl/pinctrl-exynos.c
> >> +++ b/drivers/pinctrl/pinctrl-exynos.c
> >> @@ -30,6 +30,8 @@
> >> 
> >>  #include <linux/spinlock.h>
> >>  #include <linux/err.h>
> >> 
> >> +#include <plat/pm.h>
> >> +
> > 
> > This is not going to work with CONFIG_MULTIPLATFORM.
> 
> Hmm, this sounds like it might be a bit of a long path, especially
> since I haven't been keeping up with what's been going on with
> MULTIPLATFORM and I'm currently midway through making 3.8 work (which
> has no MULTIPLATFORM).

Well, to make long story short, including headers from plat/ and mach/ 
from files outside plat/ or mach/ is no longer valid with 
CONFIG_MULTIPLATFORM, because more than one plat and/or mach can be 
enabled at the same time. In addition to this, care must be taken for code 
to not break platforms other than written for, when compiled into the 
resulting kernel.

> Perhaps for this patch it makes more sense for you to post your
> version and I can review it?  We may end up just keeping our version
> of this patch for 3.8 and pick up yours when we do our next rebase.
> Does that sound OK?

Fine. I will also send a patch adding save and restore for several EINT 
registers that need it.

> >> -#define EXYNOS_PIN_BANK_EINTW(pins, reg, id, offs)   \
> >> +#define EXYNOS_PIN_BANK_EINTW(pins, reg, id, offs, base)\
> >> 
> >>       {                                               \
> >>       
> >>               .type           = &bank_type_alive,     \
> >>               .pctl_offset    = reg,                  \
> >>               .nr_pins        = pins,                 \
> >>               .eint_type      = EINT_TYPE_WKUP,       \
> >>               .eint_offset    = offs,                 \
> >> 
> >> +             .eint_base      = base,                 \
> > 
> > I can't look at my patch at the moment, but I think I have managed to
> > get EINT index without adding this extra field.
> 
> It looks like this is always 2 * eint_offset in the code above.  Maybe
> you just multiplied?  The multiplication works fine although I think
> specifying eint_base like this might be more generic and handle future
> chips better?  Ya never know...

Since EINT handling is highly SoC-specific (i.e. done in pinctrl-exynos, 
not pinctrl-samsung), such assumption wouldn't be a problem. Let me see 
how I solved this problem in my version tomorrow at work.

Best regards,
Tomasz

