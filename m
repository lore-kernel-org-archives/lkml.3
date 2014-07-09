Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461AbaGIQyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 12:54:19 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:21058 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106AbaGIQyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 12:54:03 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-53-53bd73a8034f
Message-id: <53BD7387.8040200@samsung.com>
Date: Wed, 09 Jul 2014 18:53:27 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Daniel Drake <drake@endlessm.com>, Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH v2 0/4] Add support for Exynos clock output configuration
References: <1403626107-12073-1-git-send-email-t.figa@samsung.com>
In-reply-to: <1403626107-12073-1-git-send-email-t.figa@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsVy+t/xq7orivcGG8yaz2cx9eETNotH8x8z
	W/QuuMpmsenxNVaLy7vmsFnMOL+PyWLtkbvsFkuvX2SyeDrhIpvFoq1f2C2mLDrMatG69wi7
	xeE37awWq3b9YXTg81gzbw2jx6LvWR47Z91l99i0qpPN4861PWwem5fUe/RtWcXo8XmTXABH
	FJdNSmpOZllqkb5dAlfG9mc8BZMlK5b3T2FpYGwR7mLk5JAQMJH4e+EIE4QtJnHh3nq2LkYu
	DiGBpYwS0568h3I+M0p8u9LIAlLFK6Al8evzH1YQm0VAVWLujE6wOJuAmsTnhkdsIDY/UM2a
	putAcQ4OUYEIiccXhCBaBSV+TL4HVi4CVN6zeCsjiM0s8JNZovcwJ4gtLOArcWjnTLAaIQEn
	ieV754PVcAo4S0w6dogNol5HYn/rNChbXmLzmrfMExgFZyFZMQtJ2SwkZQsYmVcxiqaWJhcU
	J6XnGukVJ+YWl+al6yXn525ihMTW1x2MS49ZHWIU4GBU4uF9sXtPsBBrYllxZe4hRgkOZiUR
	Xp3kvcFCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGEVMSkw8nn5e/Vn3rEWPUg3Tde2UKJ6GxSek
	G8+tYZtx9oPbdK09WtYPX1mYbts0197f17M3o2j/C+cH92u+VhhfdJ6rax3+fV/7LG+ZophV
	WlPq4s+qPZnHMOeL2ZkI1a1PY41du5UWzeRVejpn0RFf/in55b/u9/MV8Gi53uo4ynvIPrOC
	WYmlOCPRUIu5qDgRAGL3IDeLAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kukjin,

On 24.06.2014 18:08, Tomasz Figa wrote:
> On all Exynos SoCs there is a dedicated CLKOUT pin that allows many of
> internal SoC clocks to be output from the SoC. The hardware structure
> of CLKOUT related clocks looks as follows:
> 
> 	CMU	|---> clock0 --------->	|	PMU	|
> 		|			|		|
>     several	|---> clock1 ---------> |	mux	|
>     muxes	|			|	+	|---> CLKOUT
>     dividers	|       ...		|	gate	|
>     and gates	|			|		|
> 		|---> clockN ---------> |		|
> 
> Since the block responsible for handling the pin is PMU, not CMU,
> a separate driver, that binds to PMU node is required and acquires
> all input clocks by standard DT clock look-up. This way we don't need
> any cross-IP block drivers and cross-driver register sharing or
> nodes for fake devices.
> 
> To represent the PMU mux/gate clock, generic composite clock is registered.
> 
> Tested on Odroid U3, with HSIC/USB hub using CLKOUT as reference clock,
> with some additional patches.
> 
> Changes since v1:
> (http://www.spinics.net/lists/arm-kernel/msg333276.html)
>  - rebased onto next-20140624,
>  - fixed #clock-cells values in exynos5250.dtsi and exynos5420.dtsi,
>  - temporarily removed ISP CLKOUT clocks on Exynos4x12, until ISP clock
>    domain handling gets fixed in Exynos4 clock driver.
> Changes since RFC v1:
> (https://lkml.org/lkml/2014/5/15/506)
>  - rebased onto v5 of "Enable usbphy and hsotg for exynos4" series and
>    current HEAD of samsung-clk tree,
>  - added handling of suspend/resume in the driver,
>  - added missing CPU clocks on Exynos4,
>  - added CLK_SET_RATE_PARENT to CMU CLKOUT gates on Exynos4,
>  - fixed bit field width on Exynos4,
>  - added CLKOUT CMU registers of Exynos4 to save/restore list,
>  - added CLK_SET_RATE_PARENT and CLK_SET_RATE_NO_REPARENT to clkout clock,
>  - changed the binding to use 1-cell clock specifier to allow extension
>    with further PMU clocks in future, if needed.
> 
> Tomasz Figa (4):
>   clk: samsung: exynos4: Add missing CPU/DMC clock hierarchy
>   clk: samsung: exynos4: Add CLKOUT clock hierarchy
>   clk: samsung: Add driver to control CLKOUT line on Exynos SoCs
>   ARM: dts: exynos: Update PMU node with CLKOUT related data
> 
>  .../devicetree/bindings/arm/samsung/pmu.txt        |  30 ++++
>  arch/arm/boot/dts/exynos4210.dtsi                  |  10 ++
>  arch/arm/boot/dts/exynos4x12.dtsi                  |   7 +
>  arch/arm/boot/dts/exynos5250.dtsi                  |   3 +
>  arch/arm/boot/dts/exynos5420.dtsi                  |   3 +
>  drivers/clk/samsung/Makefile                       |   1 +
>  drivers/clk/samsung/clk-exynos-clkout.c            | 153 +++++++++++++++++++
>  drivers/clk/samsung/clk-exynos4.c                  | 166 ++++++++++++++++++++-
>  include/dt-bindings/clock/exynos4.h                |   5 +
>  9 files changed, 374 insertions(+), 4 deletions(-)
>  create mode 100644 drivers/clk/samsung/clk-exynos-clkout.c
> 

Is there any progress with consulting this with hardware guys? Could I
have your Ack for this series, so I could put it in my tree and let
other patches base on it (especially on patches 1 and 2)? Thanks in advance.

Best regards,
Tomasz
