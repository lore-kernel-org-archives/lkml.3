Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbaCYWy7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 18:54:59 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:37673 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbaCYWyz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 18:54:55 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <5331664E.2050008@samsung.com>
Cc: gregkh@linuxfoundation.org, linux@arm.linux.org.uk, robh+dt@kernel.org,
        grant.likely@linaro.org, mark.rutland@arm.com, galak@codeaurora.org,
        kyungmin.park@samsung.com, sw0312.kim@samsung.com,
        m.szyprowski@samsung.com, t.figa@samsung.com,
        linux-kernel@vger.kernel.org
References: <1393870533-20845-1-git-send-email-s.nawrocki@samsung.com>
 <1393870975-21020-1-git-send-email-s.nawrocki@samsung.com>
 <5331664E.2050008@samsung.com>
Message-ID: <20140325225446.5762.15937@quantum>
User-Agent: alot/0.3.5
Subject: Re: [RFC PATCH v2 2/2] clk: Add handling of clk parent and rate assigned
 from DT
Date: Tue, 25 Mar 2014 15:54:46 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sylwester Nawrocki (2014-03-25 04:19:42)
> On 03/03/14 19:22, Sylwester Nawrocki wrote:
> > This function adds a notifier callback run before a driver is bound
> > to a device. It will configure any parent clocks and clock frequencies
> > according to values of 'clock-parents' and 'clock-rates' DT properties
> > respectively.
> > 
> > Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> > Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> > Changes since v1:
> >  - the helper function to parse and set assigned clock parents and
> >    rates made public so it is available to clock providers to call
> >    directly;
> >  - dropped the platform bus notification and call of_clk_device_setup()
> >    is is now called from the driver core, rather than from the
> >    notification callback;
> >  - s/of_clk_get_list_entry/of_clk_get_by_property.
> > ---
> >  .../devicetree/bindings/clock/clock-bindings.txt   |   23 ++++++
> >  drivers/base/dd.c                                  |    5 ++
> >  drivers/clk/clk.c                                  |   77 ++++++++++++++++++++
> >  include/linux/clk-provider.h                       |    6 ++
> >  4 files changed, 111 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/clock/clock-bindings.txt b/Documentation/devicetree/bindings/clock/clock-bindings.txt
> > index 7c52c29..eb8d547 100644
> > --- a/Documentation/devicetree/bindings/clock/clock-bindings.txt
> > +++ b/Documentation/devicetree/bindings/clock/clock-bindings.txt
> > @@ -115,3 +115,26 @@ clock signal, and a UART.
> >    ("pll" and "pll-switched").
> >  * The UART has its baud clock connected the external oscillator and its
> >    register clock connected to the PLL clock (the "pll-switched" signal)
> > +
> > +==Assigned clock parents and rates==
> > +
> > +Some platforms require static configuration of (parts of) the clock controller
> > +often determined by the board design. Such a configuration can be specified in
> > +a clock consumer node through clock-parents and clock-rates DT properties.
> > +The former should contain list of parent clocks in form of phandle and clock
> > +specifier pairs, the latter the list of assigned clock frequency values
> > +(one cell each).
> > +
> > +    uart@a000 {
> > +        compatible = "fsl,imx-uart";
> > +        reg = <0xa000 0x1000>;
> > +        ...
> > +        clocks = <&clkcon 0>, <&clkcon 3>;
> > +        clock-names = "baud", "mux";
> > +
> > +        clock-parents = <0>, <&pll 1>;
> 
> I have some doubts here, i.e. the order in which clocks are being 
> configured may be important in some cases. Should the binding then be
> specifying that the clocks will be configured in a sequence exactly 
> as listed in the clock-parents property ?

That's a good point, and I think we should re-examine the role of a DT
binding for this purpose. From my limited experience with DT, it seems
to be really bad at anything involving sequencing. It doesn't give us
function pointers/callbacks in the way that the old board files used to.

So I think the binding you proposed is still a good idea, but only for
the very simple case. If your platform has some detailed integration
requirements that have corner cases like you describe below, then this
DT binding might not be a good place to put the info.

A platform that provides its own pm runtime backend could neatly manage
this by having a call to pm_runtime_get deal with these integration
details such that the driver does not have to be aware of them. (caveat:
that assumes in the example below that the only thing you want to do is
set up your clocks once and then never touch them again)

Regards,
Mike

> 
> E.g. consider part of a clock controller where one of frequencies fed to
> a consumer device cannot exceed given value:
> 
>                 mux1
>  200 MHz   0 .--------.
> ----->-------|--.     |
>              |   \____|__                    f1 
>  400 MHz   1 |        |  `-+------------------->--
> ----->-------|-       |    |
>              '--------'    |      mux2
>                            | 0 .---------.
>                            `---|--.      |   f2
>                                |   \_____|_,---->--
>                  100 MHz     1 |         |   (max. 200 MHz)
>                  ----->--------|         | 
>                                '---------'              
> 
> In this case we want to set frequency f1 to 400 MHz and f2 to 100 MHz.
> To ensure f2 doesn't exceed 200 MHz at any time, mux2 has to be switched 
> to position '1' first and then mux 1 to position '1'.
> 
> > +        clock-rates = <460800>;
> 
> For clock-rates it's a bit more complicated, since it might require
> setting up frequency of some clocks twice - first to a low and then 
> to a higher value. Such details could likely be handled by bindings 
> of individual devices. Also we could assume the clock tree 
> (re)configuration is being done when any consumer clocks are masked 
> at the consumer clock gates.
> 
> I'm no sure if we should sort the clocks to ensure any parents are set
> before the child clocks, or should we rely on the sequence specified 
> in devicetree ? I'd assume sorting it wouldn't hurt, there should not 
> be relatively many clocks in a single dt node.
> 
> > +    };
> > +
> > +In this example the pll is set as parent of "mux" clock and frequency of "baud"
> > +clock is specified as 460800 Hz.
> 
> --
> Thanks,
> Sylwester
