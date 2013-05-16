Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab3EPV11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 17:27:27 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:51670 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab3EPV1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 17:27:24 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Prathyush K <prathyush.k@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] pinctrl: samsung: fix suspend/resume functionality
Date: Thu, 16 May 2013 23:27:19 +0200
Message-ID: <2469545.4zh8j9i5RI@flatron>
User-Agent: KMail/4.10.3 (Linux/3.9.2-gentoo; KDE/4.10.3; x86_64; ; )
In-Reply-To: <CAD=FV=Wk4sib4RvgVqonSj_wANmUh6vftTqveFNn6X4ceFc6Gw@mail.gmail.com>
References: <1368724352-10849-1-git-send-email-dianders@chromium.org> <1944811.006SLH6aYj@flatron> <CAD=FV=Wk4sib4RvgVqonSj_wANmUh6vftTqveFNn6X4ceFc6Gw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 of May 2013 13:32:48 Doug Anderson wrote:
> Tomasz,
> 
> Thanks for the review!  I'll get a new patch out either today or
> tomorrow...

OK. I will be fine to go with your patches, after addressing the comments. 
In the end it's good that you posted them, as reviewing them allowed me to 
find even better ways of doing some things than I had in mine ;) .

[snip]
> 
> > I wonder if you couldn't do all the saving here in a single loop over
> > all> 
> > pin control types, like:
> >         unsigned int offsets = bank->type->reg_offsets;
> >         unsigned int widths = bank->type->fld_width;
> >         
> >         for (i = 0; i < PINCFG_TYPE_NUM; ++i)
> >         
> >                 if (widths[i])
> >                 
> >                         bank->pm_save[i] = readl(reg + offsets[i]);
> > 
> > The only thing not handled by this loop is second CON registers in
> > banks with two of them. I can't think of any better solution for this
> > other than just adding a special case after the loop.
> 
> Yes, that would work.  I think it wasn't possible when I first wrote
> the code against an older code base that didn't have the arrays.  I
> can give it a shot if it doesn't make restore too bad...

OK. I wonder if resume couldn't somehow benefit from this as well, but it 
probably depends on how much it can be altered without breaking the anti-
glitch functionality.

> > Now as I think of it, do CON_PDN and PUD_PDN really need to be saved?
> > I
> > couldn't find in the documentation if they are preserved or lost in
> > sleep mode. Do you have some information on this?
> 
> I remember it being important.  Running a test now.  Yes, it's
> important on exynos5250.  As an example:
> 
> [   62.220000] samsung-pinctrl 11400000.pinctrl: Restore gpa2@f0048040
> (0x22220000=>0x22123333 ch 0x0000ffff)
> [   62.220000] samsung-pinctrl 11400000.pinctrl: Restore gpb0@f0048060
> CON_PDN (0x00000000=>0x000002aa)
> [   62.220000] samsung-pinctrl 11400000.pinctrl: Restore gpb0@f0048060
> PUD_PDN (0x00000000=>0x00000155)

OK. It's good to know.

> > I wonder if the whole restoration procedure couldn't be simplified. I
> > don't remember my version being so complicated, but I don't have my
> > patch on my screen at the moment, so I might be wrong on this.
> 
> I debated about this a bunch.  Perhaps I should just delete it.  I saw
> that it was there in the old "2-bit" code and it also seemed quite
> reasonable, so I kept it.  Things seem to work OK without it, but most
> things are pretty tolerant to their lines glitching (or even driving
> high to low for a short period of time).
> 
> ...but your question made me check again.
> 
> From previous experimentation I'm pretty certain that most pins on the
> exynos are held in the powerdown state even during early bootup of the
> SoC.  The hope is that they are released from powerdown _after_ the
> GPIO init is called.  If not then we're already glitching somewhat as
> we transition from powerdown state to default state before this
> function finally gets called.
> 
> Looking at exynos, that's probably done in exynos_pm_resume(), maybe
> by mucking with the pad retention options?
> 
> Oh, that probably means taht no_irq() is too late and that I need to
> figure out how to get my code called earlier...  The
> exynos_pm_resume() is called by syscore.

How all of this works is basically a good question. I couldn't find any 
mention about pins switching from power down to normal mode in the 
documentation, but maybe there is a small side note somewhere, which I 
could miss.

On S3C6410, for example, there are two modes. State is switched to power 
down mode automatically, but can be switched out either automatically on 
wake-up (exact timing is unknown to me) or by clearing a special bit, 
depending on value of other special bit.

IMHO this is rather important, so we should find out how it work on other 
SoCs and make the code account for it.

Best regards,
Tomasz

