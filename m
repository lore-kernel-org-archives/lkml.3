Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbaG2G6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 02:58:51 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:55698 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbaG2G6s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 02:58:48 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Tushar Behera <trblinux@gmail.com>, "Tushar Behera" <tushar.b@samsung.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <53BF81CE.60507@gmail.com>
Cc: "Mark Rutland" <mark.rutland@arm.com>,
        "ML Devicetree" <devicetree@vger.kernel.org>,
        "linux-samsung-soc" <linux-samsung-soc@vger.kernel.org>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Pawel Moll" <pawel.moll@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Tomasz Figa" <t.figa@samsung.com>,
        "lkml" <linux-kernel@vger.kernel.org>,
        "Kevin Hilman" <khilman@linaro.org>,
        "Doug Anderson" <dianders@google.com>,
        "Rob Herring" <robh+dt@kernel.org>,
        "Kumar Gala" <galak@codeaurora.org>,
        "Kukjin Kim" <kgene.kim@samsung.com>,
        "Shaik Ameer Basha" <shaik.ameer@samsung.com>,
        "ML Arch-Arm" <linux-arm-kernel@lists.infradead.org>
References: <1402464739-19044-1-git-send-email-tushar.b@samsung.com>
 <1402464739-19044-2-git-send-email-tushar.b@samsung.com>
 <20140611165027.6562.64928@quantum>
 <CAC5m3BwR9WhiiDqUw1A6FjmzAnQ02xCBxOeAaY2nt3CRqTz+oQ@mail.gmail.com>
 <20140612210920.6562.96815@quantum> <53BF81CE.60507@gmail.com>
Message-ID: <20140729065844.4906.7964@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH 1/3] clk: exynos-audss: Keep the parent of mout_audss always
 enabled
Date: Mon, 28 Jul 2014 23:58:44 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tushar Behera (2014-07-10 23:18:54)
> On 06/13/2014 02:39 AM, Mike Turquette wrote:
> > Quoting Tushar Behera (2014-06-12 00:29:23)
> >> On Wed, Jun 11, 2014 at 10:20 PM, Mike Turquette <mturquette@linaro.org> wrote:
> >>> Quoting Tushar Behera (2014-06-10 22:32:17)
> >>>> When the output clock of AUDSS mux is disabled, we are getting kernel
> >>>> oops while doing a clk_get() on other clocks provided by AUDSS. Though
> >>>> user manual doesn't specify this dependency, we came across this issue
> >>>> while disabling the parent of AUDSS mux clocks.
> >>>
> >>> Hi Tushar,
> >>>
> >>> Can you help me understand better what the actual problem is? What is
> >>> the root cause of the kernel oops?
> >>
> >> Currently AUDSS mux has two parents, XXTI crystal and MAU_EPLL clock.
> >> As per observation, when the output of AUDSS mux is gated, we are not
> >> able to do any operation on the clocks provided by MAU block (mostly
> >> the clocks used by ADMA and audio blocks).
> > 
> > I tried to get a datasheet for Exynos 54xx but could not find it. I even
> > looked at the public 5250 data sheet, but it is completely missing
> > Chapter 34, "Audio Subsystem", which apparently contains Figure 34-3,
> > "Clock names and clock tree diagram of MAUDIO_BLK".
> > 
> > So without any clue about your hardware (not for lack of trying) I would
> > guess that somewhere in the parent hierarchy you have an interface clock
> > which must be enabled in order for you to touch the registers pertaining
> > to the downstream audio clocks.
> > 
> 
> Yes, right. As per observation, we need to keep the output of AUDSS mux
> enabled to access the registers present in MAU block.
> 
> > The right way to handle this requires two steps:
> > 
> > 1) model your interface clock in the Linux clock framework if you
> > haven't already (I assume it is a gate clock, or the child of a gate
> > clock)
> > 
> 
> The interface clock is already part of the clock framework.

Great!

> 
> > 2) the clk_ops callbacks for the affected audio clocks should wrap their
> > operations (i.e. critical secion) with a clk_enable/clk_disable pair,
> > where the clock being enables/disable is the interface clock mentioned
> > above in #1
> > 
> > The CCF is reentrant, so you can do this by simply using the top-level
> > clk.h API from within your clk_ops callbacks.
> > 
> 
> Right now, the clocks are registered with clk_register_mux,
> clk_register_div and clk_register_gate calls which in turn set
> appropriate clk_ops callbacks. If I need to wrap the register access
> during these clk_ops callbacks with clk_enable/clk_disable of interface
> lock, I would have to reimplement the clk_ops callbacks in
> clk-exynos-audss driver.
> 
> Is that the approach that you are suggesting?

Is there another way? This is one of the reasons why I don't like the
basic clock types being subclassed by clock drivers. It's a brittle
design that tends to fall over as soon as the basic clock types don't do
what you need. And don't even get me started on how ugly clk-composite.c
is! ;-)

One hack you can do is to subclass the clk_ops for each of the basic
clock types you use and add .prepare and .unprepare callbacks to them
which enable/disable the interface clock. Some examples of this are
merged and it may be what your clock driver does already. However this
may not be very optimal if your consumer driver simply calls
clk_prepare_enable at probe-time and never turns the interface clock off
again...

> 
> > I might be totally wrong about the cause of the hang, but that's my best
> > guess based on everyone's bug reports.
> > 
> 
> There are 5 gate clocks within MAU block. While disabling the unused
> clocks, if CLK_MAU_EPLL is disabled first, then we are getting this
> system hang.

Right. Then your accesses to the clock control register need to be
protected by a clk_enable/clk_disable critical section.

Regards,
Mike

> 
> 
> > Regards,
> > Mike
> > 
> >>
> >>>
> >>> You mention calling clk_get on child clocks of the AUDSS mux fails, but
> >>> I cannot imagine why. How can the enable/disable state of a clock affect
> >>> the ability to clk_get other clocks?
> >>>
> >>
> >> I might have a little vogue while updating the commit message
> >> (mentioning about clk_get which surely is only a s/w operation), but
> >> there is definitely some issue with handling those clocks under given
> >> scenario.
> >>
> >> I am on leave till end of this week, so I will update you more with
> >> the logs on Monday.
> >>
> >> Thanks,
> >> --
> >> Tushar
> > 
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> > 
> 
> 
> -- 
> Tushar Behera
