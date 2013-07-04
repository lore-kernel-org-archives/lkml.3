Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab3GDOWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 10:22:23 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39611 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156Ab3GDOWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 10:22:21 -0400
Message-ID: <1372947703.21065.126.camel@cumari.coelho.fi>
Subject: Re: [PATCH v3 2/8] wlcore: set irq_flags in the board files instead
 of hiding behind a quirk
From: Luciano Coelho <coelho@ti.com>
To: Javier Martinez Canillas <martinez.javier@gmail.com>
CC: <linux-wireless@vger.kernel.org>, <tony@atomide.com>, <nsekhar@ti.com>,
        <mturquette@linaro.org>, <mark.rutland@arm.com>, <balbi@ti.com>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <nm@ti.com>
Date: Thu, 4 Jul 2013 17:21:43 +0300
In-Reply-To: <CAAwP0s3xkqUGnGvojfpyQq97qUmKCqY3BD4RyK1_uuX=pNy91g@mail.gmail.com>
References: <1372860209-3504-1-git-send-email-coelho@ti.com>
	 <1372860209-3504-3-git-send-email-coelho@ti.com>
	 <1372860925.21065.115.camel@cumari.coelho.fi>
	 <CAAwP0s3xkqUGnGvojfpyQq97qUmKCqY3BD4RyK1_uuX=pNy91g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-03 at 17:12 +0200, Javier Martinez Canillas wrote:
> On Wed, Jul 3, 2013 at 4:15 PM, Luciano Coelho <coelho@ti.com> wrote:
> > On Wed, 2013-07-03 at 17:03 +0300, Luciano Coelho wrote:
> >> The platform_quirk element in the platform data was used to change the
> >> way the IRQ is triggered.  When set, the EDGE_IRQ quirk would change
> >> the irqflags used and treat edge trigger differently from the rest.
> >>
> >> Instead of hiding this irq flag setting behind the quirk, have the
> >> board files set the flags during initialization.  This will be more
> >> meaningful than driver-specific quirks when we switch to DT.
> >>
> >> Additionally, fix missing gpio_request() calls in the boarding files
> >> (so that setting the flags actually works).
> >>
> >> Cc: Tony Lindgren <tony@atomide.com>
> >> Cc: Sekhar Nori <nsekhar@ti.com>
> >> Signed-off-by: Luciano Coelho <coelho@ti.com>
> >> ---
> >
> > [...]
> >
> >> @@ -5928,16 +5927,21 @@ static void wlcore_nvs_cb(const struct firmware *fw, void *context)
> >>       wlcore_adjust_conf(wl);
> >>
> >>       wl->irq = platform_get_irq(pdev, 0);
> >> -     wl->platform_quirks = pdata->platform_quirks;
> >>       wl->if_ops = pdev_data->if_ops;
> >>
> >> -     if (wl->platform_quirks & WL12XX_PLATFORM_QUIRK_EDGE_IRQ)
> >> -             irqflags = IRQF_TRIGGER_RISING;
> >> -     else
> >> -             irqflags = IRQF_TRIGGER_HIGH | IRQF_ONESHOT;
> >> +     irq_data = irq_get_irq_data(wl->irq);
> >> +     if (!irq_data) {
> >> +             wl1271_error("couldn't get irq data for irq %d\n", wl->irq);
> >> +             ret = -EINVAL;
> >> +             goto out_free_nvs;
> >> +     }
> >> +
> >> +     wl->irq_flags = irqd_get_trigger_type(irq_data);
> >
> > BTW, there seems to be a patch on its way to make reading the flags
> > easier (ie. no need to get the irq_data first):
> >
> > http://mid.gmane.org/1367945288-5625-1-git-send-email-javier@dowhile0.org
> >
> > I'm not sure if this is going to be taken in, but if it does, it would
> > be nice to change the code here to use the new irq_get_trigger_type()
> > function.

> That patch has been already merged in Linus tree as commit 1f6236bf
> ("genirq: Add irq_get_trigger_type() to get IRQ flags").
> 
> So yes, it would be better if you can use irq_get_trigger_type()
> instead calling irq_get_irq_data() + irqd_get_trigger_type().

That's great, thanks! I'll make this change as soon as I get your patch
into my tree (ie. after the merge window closes).

--
Luca.

