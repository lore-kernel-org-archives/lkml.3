Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbaC1QrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 12:47:21 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:36397 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbaC1QrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 12:47:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, mturquette@linaro.org,
        mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org, t.figa@samsung.com,
        sw0312.kim@samsung.com, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, robh+dt@kernel.org, galak@codeaurora.org,
        grant.likely@linaro.org, m.szyprowski@samsung.com, t-kristo@ti.com
Subject: Re: [PATCH RFC v3 2/2] clk: Add handling of clk parent and rate assigned from DT
Date: Fri, 28 Mar 2014 17:49:16 +0100
Message-ID: <5456863.skuFAcRA98@avalon>
User-Agent: KMail/4.11.5 (Linux/3.12.13-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53343D9C.6040605@samsung.com>
References: <1395922579-28547-1-git-send-email-s.nawrocki@samsung.com> <46532903.ghnH4Us8Zz@avalon> <53343D9C.6040605@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sylwester,

On Thursday 27 March 2014 16:02:52 Sylwester Nawrocki wrote:
> On 27/03/14 15:08, Laurent Pinchart wrote:
> > On Thursday 27 March 2014 14:57:56 Sylwester Nawrocki wrote:
> >> On 27/03/14 14:24, Laurent Pinchart wrote:
> >>> On Thursday 27 March 2014 13:16:19 Sylwester Nawrocki wrote:
> >>>> This function adds a helper function to configure clock parents and
> >>>> rates as specified in clock-parents, clock-rates DT properties for a
> >>>> consumer device and a call to it before driver is bound to a device.
> >>>> 
> >>>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> >>>> ---
> >> 
> >> [...]
> >> 
> >>>>  .../devicetree/bindings/clock/clock-bindings.txt   |   26 ++++++
> >>>>  drivers/base/dd.c                                  |    7 ++
> >>>>  drivers/clk/Makefile                               |    1 +
> >>>>  drivers/clk/clk-conf.c                             |   87 ++++++++++++
> >>>>  drivers/clk/clk.c                                  |   10 ++-
> >>>>  include/linux/clk/clk-conf.h                       |   19 +++++
> >>>>  6 files changed, 149 insertions(+), 1 deletion(-)
> >>>>  create mode 100644 drivers/clk/clk-conf.c
> >>>>  create mode 100644 include/linux/clk/clk-conf.h
> >>>> 
> >>>> diff --git a/Documentation/devicetree/bindings/clock/clock-bindings.txt
> >>>> b/Documentation/devicetree/bindings/clock/clock-bindings.txt index
> >>>> 7c52c29..b452f80 100644
> >>>> --- a/Documentation/devicetree/bindings/clock/clock-bindings.txt
> >>>> +++ b/Documentation/devicetree/bindings/clock/clock-bindings.txt
> >>>> @@ -115,3 +115,29 @@ clock signal, and a UART.
> >>>>    ("pll" and "pll-switched").
> >>>>  
> >>>>  * The UART has its baud clock connected the external oscillator and
> >>>>    its register clock connected to the PLL clock (the "pll-switched"
> >>>>    signal)
> >>>> 
> >>>> +
> >>>> +==Assigned clock parents and rates==
> >>>> +
> >>>> +Some platforms require static initial configuration of parts of the
> >>>> clocks
> >>>> +controller. Such a configuration can be specified in a clock consumer
> >>>> node
> >>>> +through clock-parents and clock-rates DT properties. The former should
> >>>> contain
> >>>> +a list of parent clocks in form of phandle and clock specifier pairs,
> >>>> the
> >>>> +latter the list of assigned clock frequency values (one cell each).
> >>>> +
> >>>> +    uart@a000 {
> >>>> +        compatible = "fsl,imx-uart";
> >>>> +        reg = <0xa000 0x1000>;
> >>>> +        ...
> >>>> +        clocks = <&clkcon 0>, <&clkcon 3>;
> >>>> +        clock-names = "baud", "mux";
> >>>> +
> >>>> +        clock-parents = <0>, <&pll 1>;
> >>>> +        clock-rates = <460800>;
> >>>> +    };
> >>>> +
> >>>> +In this example the pll is set as parent of "mux" clock and frequency
> >>>> of "baud"
> >>>> +clock is specified as 460800 Hz.
> >>> 
> >>> I'm curious, what should happen when two devices have conflicting
> >>> requirements ? If a different device required the <&clkcon 3> parent to
> >>> be set to <&pll 2> for instance, who should win ? Shouldn't a warning be
> >>> printed ?
> >> 
> >> In general, the assumption is that the <&clkcon 3> clock would be used
> >> only by the uart@a000 device.
> > 
> > OK. Removing the problem is a simple way to fix it :-) What about stating
> > this explicitly in the documentation then ? Maybe by prefixing your
> > proposed explanation below with something like
> > 
> > "Configuring a clock parent and rate through the device node that uses the
> > clock is only supported for clocks that have a single user."
> 
> Looks good, we could add it. Or perhaps something like:
> 
> "Configuring a clock parent and rate through the device node that uses the
>  clock should be only done for clocks that have a single user. If a clock
>  is shared and conflicting parent or rate configuration is specified in
>  multiple consumer nodes a resulting configuration is undefined." ?
> 
> Not sure if it is acceptable to inject such an unpredictability to the
> kernel from DT though. Might be more reasonable to go with a clarification
> as you proposed.

I would go further and forbid it.

"Configuring a clock parent and rate through the device node that uses the
clock can be done only for clocks that have a single user. Specifying 
conflicting parent or rate configuration in multiple consumer nodes for a 
shared clock is forbidden."

> >> If a clock is shared I'd say it shouldn't be put in a multiple consumer
> >> device nodes. Instead it should be put in a clock provider node, as I was
> >> trying to explain in the sentence below.
> >> 
> >> A warning could be useful, but it could complicate the code. We would
> >> need, for example, to store information about already configured clocks
> >> in a list and scan it before actually altering any clock parent or rate.
> > 
> > I'm fine with implementing that later if needed, we can keep the initial
> > implementation simple.
> 
> OK.
> 
> >>>> +For clocks which are not directly connected to any consumer device
> >>>> similarly
> >>>> +clocks, clock-parents and/or clock-rates properties should be
> >>>> specified in
> >>>> +assigned-clocks subnode of a clock controller DT node.
> >>> 
> >>> It might be that I'm not familiar enough with the clock framework, but
> >>> this sounds unclear to me. I'm not sure what you mean exactly.
> >> 
> >> Sorry about not being precise here, would something like below be more
> >> clear ?
> >> 
> >> "Configuration of common clocks, which affect multiple consumer devices
> >> can be specified in a dedicated 'assigned-clocks' subnode of a clock
> >> 
> >> provider node, e.g.:
> >>     clkcon {
> >>         ...
> >>         #clock-cells = <1>;
> >>         assigned-clocks {
> >>             clocks = <&clkcon 16>, <&clkcon 17>;
> >>             clock-parents = <0>, <&clkcon 1>;
> >>             clock-rates = <200000>;
> >>         };
> >>     };
> >> "
> > 
> > That's clearer indeed. Can the parents and rates depend on the board, or
> > on the SoC only ? We might be getting dangerously close to specifying
> > platform configuration instead of describing the hardware. A real example
> > might be nice to support the discussion.
> 
> The clock parent and rates could be board specific, otherwise this API would
> become much less useful. The configuration often depends on what external
> devices are attached to an SoC.
> 
> I don't have a real life example for the "global" configuration of shared
> clocks at the moment. I added this after seeing Tero's patches [1], maybe
> he could talk about some real use cases (just realized I missed to Cc him.
> fixing this mistake now).

Sascha has posted a nice example of an assigned-clocks node, let's discuss 
this in replies to his e-mail.

> >> Naturally it's this just an RFC, any critics or suggestions are
> >> welcome.:)
>
> [1] http://www.spinics.net/lists/linux-omap/msg103069.html

-- 
Regards,

Laurent Pinchart

