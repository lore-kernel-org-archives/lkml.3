Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070AbbATLWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:22:23 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:39426 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048AbbATLWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:22:20 -0500
MIME-Version: 1.0
In-Reply-To: <54BE108F.8090506@samsung.com>
References: <1420681257-3078-1-git-send-email-cw00.choi@samsung.com>
	<1420681257-3078-3-git-send-email-cw00.choi@samsung.com>
	<CAL_Jsq+5sdsm_-VW-ta+qV-NBao-XTHvsYWcbMdZmbP0Nw43Cw@mail.gmail.com>
	<CAKohpomqosqxeDANC=NLBVmOUHyUoqd7Zhph7r6f7+ufYN48EQ@mail.gmail.com>
	<54BE108F.8090506@samsung.com>
Date: Tue, 20 Jan 2015 16:52:19 +0530
Message-ID: <CAKohpokSuVhH3hHFF+mLtJXvjt=bmJy1oZRBOttCNXORBS1Y0A@mail.gmail.com>
Subject: Re: [PATCHv3 2/8] devfreq: exynos: Add documentation for generic
 exynos memory bus frequency driver
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Rob Herring <robherring2@gmail.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>, Kukjin Kim <kgene@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Mark Rutland <mark.rutland@arm.com>, a.kesavan@samsung.com,
        Tomasz Figa <tomasz.figa@gmail.com>,
        =?UTF-8?Q?Krzysztof_Koz=C5=82owski?= <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, InKi Dae <inki.dae@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 January 2015 at 13:53, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> But, the frequency of OPPs is only used for devfreq ondemand governor.
> After deciding the proper frequency of memory bus on ondemand governor,
> exynos-bus.c (exynos memory bus frequency driver) use the frequency table
> of memory bus blocks on below to change the clock rate of memory bus block.

> Firs of all,
> I explain the hierarchy of Exynos memory buses.
>
> For example of Exynos3250 memory bus,
> This patch divide the memory bus group according to power rail (regulator).
> - MIF (Memory Interface ) memory bus group uses the VDD_MIF regulator.
> - INT (Internal) memory bus group uses the VDD_INT regulator.
>
> Each memory bus group contains only one power rail(regulator) and one more memory bus blocks as follwing:
>
> - MIF memory bus group
> power rail(VDD_MIF)-->|--- memory bus for DMC (Dynamic Memory Controller) block (dmc clock)
>
> - INT memory bus group
>                       |--- memory bus for PERI block (aclk_100 clock)
>                       |
>                       |--- memory bus for DISPLAY block (aclk_160 clock)
>                       |
>                       |--- memory bus for ISP block (aclk_200 clock)
>                       |
>                       |--- memory bus for GPS block (aclk_266 clock)
> power rail(VDD_INT)-->|
>                       |--- memory bus for MCUISP block (aclk_400_mcuisp clock)
>                       |
>                       |--- memory bus for Leftbus block (gdl clock)
>                       |
>                       |--- memory bus for Rightbus block (gdr clock)
>                       |
>                       |--- memory bus for MFC block (mfc clock)
>
>
> Exynos3250 has following table for INT memory bus group:
> All clocks of INT memory bus group have to contain the same entry count
> againt the number of 'virtual freqw'. So, each memory bus clock could have duplicate clocks.
>
> ------------------------------------------------------------------------
> Level|virtual freq|PERI's clk|Display's clk|ISP's clk|GPS's clk| voltage|
> ------------------------------------------------------------------------
> L6   |400000      |100000    |200000       |200000   |300000   | 95000  |
> L5   |200000      |100000    |160000       |200000   |200000   | 95000  |
> L4   |133000      |100000    |100000       |100000   |133000   | 92500  |
> L3   |100000      |100000    |80000        |80000    |100000   | 85000  |
> L2   |80000       |50000     |80000        |50000    |50000    | 85000  |
> L1   |50000       |50000     |50000        |50000    |50000    | 85000  |
> -------------------------------------------------------------------------
> (Except for mcuisp, leftbus, rightbus, mfc block)
>
> This table is used for devfreq ondemand governor as following:
> 1. ondemand governor in devfreq use the 'virtual freq' to devcide the proper
>    frequency for memory bus.
> 2. ondemand governor executes the *_target() function to set clock rate and voltage.
> 3. *_target() function in exynos-bus.c changes the clock rate of {PERIS|Display|ISP|GPS} clk
>    according to decided 'Level' by devfreq ondemand governor.

I see..

Please confirm if my understanding is correct.
- mem-bus-group: all blocks sharing a regulator
- mem-bus-block: individual blocks managing their clock rate

What you do in kernel is register group as a device (with virtual OPPs)
and then manage blocks within the driver. And so you need to do this
dummy mapping of virtual to physical frequencies.

It *may* not have done it this way, if I was to design this driver.

Each bus-block is a separately controllable device and so must be registered
separately. In that case all bus-blocks will have separate OPP tables and
all this dummy-v2p mapping will go away.

I believe that you are over complicating stuff without any need..

--
viresh
