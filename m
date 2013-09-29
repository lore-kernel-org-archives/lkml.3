Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab3I2BiB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 21:38:01 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:49014 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab3I2Bh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 21:37:58 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Yadwinder Singh Brar <yadi.brar01@gmail.com>
Cc: Tomasz Figa <t.figa@samsung.com>,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree <devicetree@vger.kernel.org>,
        Yadwinder Singh <yadi.brar@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>, Rob Landley <rob@landley.net>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, ijc+devicetree@hellion.org.uk,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, ben-linux@fluff.org,
        s.nawrocki@samsung.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/3] clk: samsung: Add clock driver for s5pc100
Date: Sun, 29 Sep 2013 03:37:53 +0200
Message-ID: <3513015.7YVkGL6tMp@flatron>
User-Agent: KMail/4.11.1 (Linux/3.11.1-gentoo; KDE/4.11.1; x86_64; ; )
In-Reply-To: <CAKew6eXvXZ==auq8E9bYnHsrrVgqKsK7A9ad12ERBPR++cQUHg@mail.gmail.com>
References: <1380041605-15736-1-git-send-email-m.krawczuk@partner.samsung.com> <3392871.UAAWoO4asY@amdc1227> <CAKew6eXvXZ==auq8E9bYnHsrrVgqKsK7A9ad12ERBPR++cQUHg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 of September 2013 18:37:56 Yadwinder Singh Brar wrote:
> Hi Tomasz,
> 
> On Thu, Sep 26, 2013 at 7:30 PM, Tomasz Figa <t.figa@samsung.com> wrote:
> > Hi Yadwinder,
> > 
> > I haven't reviewed this series yet, but let me clarify some things
> > from
> > your comments.
> > 
> > On Thursday 26 of September 2013 17:38:58 Yadwinder Singh Brar wrote:
> >> > +
> >> > +/* Helper macros to define clock arrays. */
> >> > +#define FIXED_RATE_CLOCKS(name)        \
> >> > +               static struct samsung_fixed_rate_clock name[]
> >> > +#define MUX_CLOCKS(name)       \
> >> > +               static struct samsung_mux_clock name[]
> >> > +#define DIV_CLOCKS(name)       \
> >> > +               static struct samsung_div_clock name[]
> >> > +#define GATE_CLOCKS(name)      \
> >> > +               static struct samsung_gate_clock name[]
> >> > +
> >> 
> >> These macros seems little bit odd in our common practice,
> >> perhaps these are making code harder to read below.
> > 
> > They allow array declaration to fit into single line. I agree that it
> > is not particularly easy to read at first sight, but shouldn't really
> > be much of nuisance.
> 
> Defining a macro just to use once/twice, especially hiding the
> definition of some array, doesn't looks justified.

If it makes the code look better, then I believe it's justified. If this 
really looks that scary for you then I won't insist to keep it, though ;).

> >In addition, most of this driver is based on macros
> >
> > like this, e.g. GATE(), MUX(), PNAME(), etc.
> > 
> >> > +PNAME(mout_i2s_2_p) = {
> >> > +       "fout_epll",
> >> > +       "i2scdclk0",
> >> > +       "dout_audio0",
> >> > +       "none"
> >> > +};
> >> > +
> >> 
> >> Using one line per parent isn't increasing length of file
> >> unnecessarily?> 
> > I believe this improves readability. Do we really care about size of
> > source code that much, over readability?
> 
> yes, its looks little bit clean but in this case I felt, its making
> the traversability in file difficult due to length of file.

Most modern editors (like vim or emacs) have symbol browsers, so I don't 
think this is an issue. Instead it's easy to look up which parent has 
which index and any further correction will not cause merge conflicts, due 
to having only one entry per line.

> >> > +       ALIAS(SCLK_AUDIO0, "soc-audio.0", "sclk_audio"),
> >> > +       ALIAS(SCLK_AUDIO1, "soc-audio.1", "sclk_audio"),
> >> > +       ALIAS(SCLK_AUDIO2, "soc-audio.2", "sclk_audio"),
> >> > +       ALIAS(KEYIF, NULL, "keypad"),
> >> > +
> >> > +       ALIAS(MFC, "s5p-mfc", "sclk_mfc"),
> >> > +       ALIAS(G2D, "s5p-g2d", "fimg2d"),
> >> > +
> >> > +};
> >> > +
> >> 
> >> Any reason/hidden advantage for using a separate of ALIAS,
> >> instead of using MUX_A/GATE_A ?
> > 
> > Yes, not even hidden. Alias is not a property of clock. One clock can
> > have multiple aliases, e.g. the same clock being input to multiple
> > devices.
> 
> Yes, its required if same clk has different alias for different devices,
> but while using same alias for different(all, in this case) devices,
> doesn't seems advantageous.

An alias (technically clkdev lookup) is an existence separate from a 
clock. It's a binding of controller's clock output and device's clock 
input. Even if sometimes there is a 1:1 mapping of clocks and devices, 
there is no reason to mix them together. Moreover, since there is a need 
to provide more than one alias per clock, there is even less reason to 
provide two different ways of defining them.

This way makes the code easier to read, because in clock tables you just 
have data internal to common clock framework and in alias tables you have 
data that belongs to clkdev.

Best regards,
Tomasz

