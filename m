Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbaGBEdy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 00:33:54 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:40570 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbaGBEdw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 00:33:52 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        "Javier Martinez Canillas" <javier@dowhile0.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <53B0FC27.5040002@ti.com>
Cc: "Grant Likely" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Linux Kernel" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        ldewangan@nvidia.com, linux-doc@vger.kernel.org,
        "Nishanth Menon" <nm@ti.com>, "Rob Herring" <robh+dt@kernel.org>
References: <1403848871-26519-1-git-send-email-peter.ujfalusi@ti.com>
 <1403848871-26519-3-git-send-email-peter.ujfalusi@ti.com>
 <CABxcv=metB4=eoT=fAh7S-b_mhAvHcJtn2wrV8v8koSyKMxNNw@mail.gmail.com>
 <53B0FC27.5040002@ti.com>
Message-ID: <20140702043338.23338.31600@quantum>
User-Agent: alot/0.3.5
Subject: Re: [RESEND 2/2] clk: Add driver for Palmas clk32kg and clk32kgaudio clocks
Date: Tue, 01 Jul 2014 21:33:38 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Peter Ujfalusi (2014-06-29 22:56:55)
> Hi Javier,
> 
> On 06/27/2014 09:23 PM, Javier Martinez Canillas wrote:
> > Hello Peter,
> > 
> > On Fri, Jun 27, 2014 at 8:01 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> >> Palmas class of devices can provide 32K clock(s) to be used by other devices
> >> on the board. Depending on the actual device the provided clocks can be:
> >> CLK32K_KG and CLK32K_KGAUDIO
> >> or only one:
> >> CLK32K_KG (TPS659039 for example)
> >>
> >> Use separate compatible flags for the two 32K clock.
> >> A system which needs or have only one of the 32k clock from
> >> Palmas will need to add node(s) for each clock as separate section
> >> in the dts file.
> >> The two compatible property is:
> >> "ti,palmas-clk32kg" for clk32kg clock
> >> "ti,palmas-clk32kgaudio" for clk32kgaudio clock
> >>
> >> Apart from the register control of the clocks - which is done via
> >> the clock API there is a posibility to enable the external sleep
> >> control. In this way the clock can be enabled/disabled on demand by the
> >> user of the clock.
> >>
> >> See the documentation for more details.
> >>
> >> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> >> Reviewed-by: Nishanth Menon <nm@ti.com>
> 
> >> +static unsigned long palmas_clks_recalc_rate(struct clk_hw *hw,
> >> +                                            unsigned long parent_rate)
> >> +{
> >> +       return 32768;
> >> +}
> > 
> > I see that other clock drivers using a constant rate return 0 if the
> > clock has not been enabled.
> 
> and there are examples when similar fixed clock drivers returns only the clock
> value, like clk-max77686. I can not find clear guidelines neither in the
> documentation or around the header/c files for this.
> Mike, what is the appropriate way of handling the recalc_rate?

You are right that there are no guidelines stating, "don't do that", but
please, "don't do that" ;-)

clk_enable and clk_set_rate are entirely unrelated operations from the
perspective of the Linux clock framework, and mixing these two classes
of operations is a recipe for pain.

> 
> > So maybe is more correct to have something
> > like the following?
> > 
> > if (__clk_is_enabled(hw->clk))
> >         return 32768;
> > else
> >         return 0;

So what happens here if this is gateable clock and later on we call
clk_enable on it? The clocks rate will still be zero since
clk_enable/clk_disable do not touch the rate at all.

Regards,
Mike

> > 
> > Best regards,
> > Javier
> > 
> 
> 
> -- 
> Péter
