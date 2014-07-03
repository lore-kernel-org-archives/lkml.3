Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbaGCAPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 20:15:09 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:47355 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaGCAPG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 20:15:06 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Kukjin Kim <kgene.kim@samsung.com>, "'Tomasz Figa'" <t.figa@samsung.com>,
        linux-samsung-soc@vger.kernel.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <026001cf9061$5fef9d00$1fced700$@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        "'Mark Rutland'" <mark.rutland@arm.com>,
        "'Pankaj Dubey'" <pankaj.dubey@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Mark Brown'" <broonie@kernel.org>,
        "'Sylwester Nawrocki'" <s.nawrocki@samsung.com>,
        "'Daniel Drake'" <drake@endlessm.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>
References: <1403626107-12073-1-git-send-email-t.figa@samsung.com>
 <026001cf9061$5fef9d00$1fced700$@samsung.com>
Message-ID: <20140703001452.7440.8476@quantum>
User-Agent: alot/0.3.5
Subject: RE: [PATCH v2 0/4] Add support for Exynos clock output configuration
Date: Wed, 02 Jul 2014 17:14:52 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kukjin Kim (2014-06-25 03:36:51)
> Tomasz Figa wrote:
> > 
> Hi Tomasz,
> 
> > On all Exynos SoCs there is a dedicated CLKOUT pin that allows many of
> > internal SoC clocks to be output from the SoC. The hardware structure
> 
> Yeah, because the CLKOUT pin is used for measure of the clock for debug on all
> of exynos SoCs commonly.
> 
> > of CLKOUT related clocks looks as follows:
> > 
> >       CMU     |---> clock0 ---------> |       PMU     |
> >               |                       |               |
> >     several   |---> clock1 ---------> |       mux     |
> >     muxes     |                       |       +       |---> CLKOUT
> >     dividers  |       ...             |       gate    |
> >     and gates |                       |               |
> >               |---> clockN ---------> |               |
> > 
> > Since the block responsible for handling the pin is PMU, not CMU,
> > a separate driver, that binds to PMU node is required and acquires
> > all input clocks by standard DT clock look-up. This way we don't need
> > any cross-IP block drivers and cross-driver register sharing or
> > nodes for fake devices.
> > 
> BTW, upcoming exynos5 SoCs have two muxs for CLKOUT and each mux is controlled
> by CMU and PMU, so
> 
> The mux1 for CLKOUT in CMU is used to decide which clock in each sub-domain
> will be out and the mux2 in PMU is used to decide which sub-domain will be out
> via CLKOUT. So I want you to consider of all of exynos SoCs including upcoming
> SoCs.

clkout for debug is very useful indeed. For SoCs with high speed clocks
that I have worked with, I have often observed that the clkout logic
introduces buffers or dividers. This is needed so that you can get a
(relatively) clean clock signal on your oscilloscope. Otherwise that
2GHz ARM clk is just going to be noise ;-)

These divider values can modeled in the clk framework. Do you know if
you have such stuff on your chip?

Regards,
Mike

> 
> Thanks,
> Kukjin
> 
> > To represent the PMU mux/gate clock, generic composite clock is registered.
> > 
> > Tested on Odroid U3, with HSIC/USB hub using CLKOUT as reference clock,
> > with some additional patches.
> > 
> > Changes since v1:
> > (http://www.spinics.net/lists/arm-kernel/msg333276.html)
> >  - rebased onto next-20140624,
> >  - fixed #clock-cells values in exynos5250.dtsi and exynos5420.dtsi,
> >  - temporarily removed ISP CLKOUT clocks on Exynos4x12, until ISP clock
> >    domain handling gets fixed in Exynos4 clock driver.
> > Changes since RFC v1:
> > (https://lkml.org/lkml/2014/5/15/506)
> >  - rebased onto v5 of "Enable usbphy and hsotg for exynos4" series and
> >    current HEAD of samsung-clk tree,
> >  - added handling of suspend/resume in the driver,
> >  - added missing CPU clocks on Exynos4,
> >  - added CLK_SET_RATE_PARENT to CMU CLKOUT gates on Exynos4,
> >  - fixed bit field width on Exynos4,
> >  - added CLKOUT CMU registers of Exynos4 to save/restore list,
> >  - added CLK_SET_RATE_PARENT and CLK_SET_RATE_NO_REPARENT to clkout clock,
> >  - changed the binding to use 1-cell clock specifier to allow extension
> >    with further PMU clocks in future, if needed.
> > 
> > Tomasz Figa (4):
> >   clk: samsung: exynos4: Add missing CPU/DMC clock hierarchy
> >   clk: samsung: exynos4: Add CLKOUT clock hierarchy
> >   clk: samsung: Add driver to control CLKOUT line on Exynos SoCs
> >   ARM: dts: exynos: Update PMU node with CLKOUT related data
> > 
> >  .../devicetree/bindings/arm/samsung/pmu.txt        |  30 ++++
> >  arch/arm/boot/dts/exynos4210.dtsi                  |  10 ++
> >  arch/arm/boot/dts/exynos4x12.dtsi                  |   7 +
> >  arch/arm/boot/dts/exynos5250.dtsi                  |   3 +
> >  arch/arm/boot/dts/exynos5420.dtsi                  |   3 +
> >  drivers/clk/samsung/Makefile                       |   1 +
> >  drivers/clk/samsung/clk-exynos-clkout.c            | 153 +++++++++++++++++++
> >  drivers/clk/samsung/clk-exynos4.c                  | 166
> ++++++++++++++++++++-
> >  include/dt-bindings/clock/exynos4.h                |   5 +
> >  9 files changed, 374 insertions(+), 4 deletions(-)
> >  create mode 100644 drivers/clk/samsung/clk-exynos-clkout.c
> > 
> > --
> > 1.9.3
> 
