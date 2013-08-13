Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab3HMFDi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 01:03:38 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:48955 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab3HMFDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 01:03:36 -0400
Date: Mon, 12 Aug 2013 22:03:34 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v1 09/14] clk: msm: Add support for MSM8960's global
 clock controller (GCC)
Message-ID: <20130813050334.GE14845@codeaurora.org>
References: <1374713022-6049-1-git-send-email-sboyd@codeaurora.org>
 <1374713022-6049-10-git-send-email-sboyd@codeaurora.org>
 <20130808170015.GE27325@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130808170015.GE27325@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08, Mark Rutland wrote:
> Hi Stephen,
> 
> On Thu, Jul 25, 2013 at 01:43:37AM +0100, Stephen Boyd wrote:
> > Fill in the data and wire up the global clock controller to the
> > MSM clock driver. This should allow most non-multimedia device
> > drivers to control their clocks on 8960 based platforms.
> > 
> > Cc: devicetree@vger.kernel.org
> > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> > ---
> >  .../devicetree/bindings/clock/qcom,gcc.txt         |  55 +++++++
> >  drivers/clk/msm/Kconfig                            |  10 ++
> >  drivers/clk/msm/Makefile                           |   2 +
> >  drivers/clk/msm/core.c                             |   3 +
> >  drivers/clk/msm/gcc-8960.c                         | 174 +++++++++++++++++++++
> >  drivers/clk/msm/internal.h                         |   2 +
> >  6 files changed, 246 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/clock/qcom,gcc.txt
> >  create mode 100644 drivers/clk/msm/gcc-8960.c
> > 
> > diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc.txt b/Documentation/devicetree/bindings/clock/qcom,gcc.txt
> > new file mode 100644
> > index 0000000..2311e1a
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/clock/qcom,gcc.txt
> > @@ -0,0 +1,55 @@
> > +MSM Global Clock Controller Binding
> > +-----------------------------------
> > +
> > +Required properties :
> > +- compatible : shall contain at least "qcom,gcc" and only one of the
> > +              following:
> > +
> > +                       "qcom,gcc-8660"
> > +                       "qcom,gcc-8960"
> > +
> > +- reg : shall contain base register location and length
> > +- clocks : shall contain clocks supplied by the clock controller
> > +
> > +Example:
> > +       clock-controller@900000 {
> > +               compatible = "qcom,gcc-8960", "qcom,gcc";
> > +               reg = <0x900000 0x4000>;
> > +
> > +               clocks {
> > +                       pxo: pxo {
> > +                               #clock-cells = <0>;
> > +                               compatible = "fixed-clock";
> > +                               clock-frequency = <27000000>;
> > +                       };
> > +
> > +                       pll8: pll8 {
> > +                               #clock-cells = <0>;
> > +                               compatible = "qcom,pll";
> > +                               clocks = <&pxo>;
> > +                       };
> > +
> > +                       vpll8: vpll8 {
> > +                               #clock-cells = <0>;
> > +                               compatible = "qcom,pll-vote";
> > +                               clocks = <&pll8>;
> > +                       };
> > +
> > +                       gsbi5_uart_rcg: gsbi5_uart_rcg {
> > +                               #clock-cells = <0>;
> > +                               compatible = "qcom,p2-mn16-clock";
> > +                               clocks = <&pxo>, <&vpll8>;
> > +                       };
> > +
> > +                       gsbi5_uart_clk: gsbi5_uart_cxc {
> > +                               #clock-cells = <0>;
> > +                               compatible = "qcom,cxc-clock";
> > +                               clocks = <&gsbi5_uart_rcg>;
> > +                       };
> > +
> > +                       gsbi5_uart_ahb: gsbi5_uart_ahb {
> > +                               #clock-cells = <0>;
> > +                               compatible = "qcom,cxc-hg-clock";
> > +                       };
> > +               };
> > +       };
> 
> I'm slightly confused by this. How is each of the clocks described in
> the clocks node related to a portion of the register set?

The registers to control clocks and determine their state are
scattered throughout the registers in the gcc (in this example
from 0x900000 to 0x903fff). If you match up gsbi5_uart_rcg with
its C struct counterpart you'll notice that there are multiple
registers used to configure the clock. It isn't as simple as one
reg property per clock even for the case where we're just
toggling a bit to turn a clock on and off either. And it isn't as
simple as saying the clock has a base register that we can offset
from because offsets are almost always different (we've tried
to correct this in future chip versions).

> 
> If the set of clocks is fixed, surely the gcc node gives you enough
> information alone, and the whole block can be modelled as a single
> provider of multiple clock outputs, or it's not fixed, and some linkage
> needs to be defined?
> 
> The code seems to imply the former, unless only a subset of clocks may
> be present? In that case, the set of clocks which might be present
> should be described in the binding.

The clock controller is hardware and the number of clock outputs
is fixed. Isn't all hardware fixed until you start talking about
FPGAs? The next minor revision of the clock controller may add
more clocks or remove clocks from that base design, but otherwise
the two are 90% the same and generally software compatible. It
isn't until we start a new generation of chips that we make major
changes to the design. Is that loose enough to qualify?

These bindings attempt to follow the regulator bindings. With
regulators there is a node for each regulator and we describe
physical characteristics of those regulators within the nodes but
we don't describe the software interface (bits, masks, shifts,
etc). I imagine we could extend these clock nodes to describe
physical characteristics such as min/max frequency or if the
bootloader has left the clocks on. Right now we're using the
nodes to describe what types of clocks there are and how the
clock tree is layed out.

Or perhaps you're talking about clock sharing? We share the clock
controller with multiple masters (processors running other OSes)
and the partitioning of the clocks is mostly predefined. We just
won't use some clocks because they're reserved for other
processors. They're still part of the same clock controller
hardware block but we don't want to control them on Linux because
we'll trample over other processors and most likely hang the
system. I wonder how this would work for hexagon and krait both
running linux on the same SoC. If all DT says is that there is a
gcc here at this address how are we supposed to know that we
shouldn't use some clock? In fact we have some clocks that are
"voteable" in the sense that each master has its own register to
vote for a clock to be on or off. The registers are all ORed
together by hardware to determine if the clock should be on or
not. I should probably rename those clocks to have a _krait or
_apps at the end so that it's clear we want to instantiate the
krait version of the clock and not the hexagon version. I suppose
the other solution there is to say we have gcc-8960-krait and
gcc-8960-hexagon so we know which voting registers to use or put
an ifdef ARCH_HEXAGON/ARCH_ARM. Is that the right solution?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
