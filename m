Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbaK0Mft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 07:35:49 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:59085 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045AbaK0Mfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 07:35:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kgene.kim@samsung.com,
        mark.rutland@arm.com, olof@lixom.net, catalin.marinas@arm.com,
        will.deacon@arm.com, tomasz.figa@gmail.com, thomas.abraham@linaro.org,
        linus.walleij@linaro.org, kyungmin.park@samsung.com,
        inki.dae@samsung.com, chanho61.park@samsung.com,
        geunsik.lim@samsung.com, sw0312.kim@samsung.com,
        jh80.chung@samsung.com, a.kesavan@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 11/19] clk: samsung: exynos5433: Add clocks for CMU_BUS{0|1|2} domains
Date: Thu, 27 Nov 2014 13:35:29 +0100
Message-ID: <3556463.Me1EFEY7Zb@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54771518.1010004@samsung.com>
References: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com> <54771173.6090408@samsung.com> <54771518.1010004@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:l0Z175gLrUk2RjOe2YawD1oSQ1UnNWQXzel9CMeRr63
 mLF7l15hwiVcrnqHHox70o+SxikHHW+iOkym4hnhSMGqweSZco
 rT9DXyam0Bx5FpARdtlozGB7zLdrEsHymTtWHqEvQ7RHhwrMjm
 gQKHjEw0+26D4N/A5EpgnJJ5fcVoTQxw+idO0lomE+M/TdcqAf
 cbstuhOj5C45opXU0XD2Xe94cymGCrGYN25aMbjjD2UTkjjOVf
 6T2y/L1tfEQCIwArppEMjLs3JfZGmLWyYYdhEQlxVaI6gpnxi2
 ubviABa7ks8IgwJlS+jlx2UFpo8TJ5It+5NMaZQDUTSW3kx8rJ
 oa08cI/cKoNbPWha/q1M=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 November 2014 13:12:08 Sylwester Nawrocki wrote:
> On 27/11/14 12:56, Chanwoo Choi wrote:
> > On 11/27/2014 08:41 PM, Arnd Bergmann wrote:
> >> > On Thursday 27 November 2014 16:35:08 Chanwoo Choi wrote:
> >>> >> +  - "samsung,exynos5433-cmu-bus0", "samsung,exynos5433-cmu-bus1"
> >>> >> +    and "samsung,exynos5433-cmu-bus2" - clock controller compatible for CMU_BUS
> >>> >> +    which generates global data buses clock and global peripheral buses clock.
> >>> >>  
> >>> >>  - reg: physical base address of the controller and length of memory mapped
> >>> >>    region.
> >>> >>
> >> > 
> >> > This looks like you are duplicating the bindings and the code, but
> >> > it's really the same hardware multiple times with minor variations
> >> > that you should be able to describe properly here. Why not make
> >> > three nodes with the same compatible string and have them handled
> >> > by the same code?
> >
> > Each CMU_BUSx domain of Exynos5433 have different base address as following:
> > - CMU_BUS0's base address and range : 0x1360_0000 ~ 0x1360_0b04
> > - CMU_BUS1's base address and range : 0x1480_0000 ~ 0x1480_0b04
> > - CMU_BUS2's base address and range : 0x1340_0000 ~ 0x1340_0b04
> > 
> > So, I implement CMU_BUSx domain which has each compatible string.

But the base address is in the reg property, not in the compatible
property. What I mean is to have multiple nodes like

	clock-controller@113600000 {
		reg = <0 0x113600000 0 0x1000>;
		compatible = "samsung,exynos5433-cmu";
		#clock-cells = <1>;
	};

	clock-controller@114800000 {
		reg = <0 0x114800000 0 0x1000>;
		compatible = "samsung,exynos5433-cmu";
		#clock-cells = <1>;
	};

The code will just map the local registers for each instance and then
provide the clocks of the right instance when asked for it.

> You can always have multiple entries in the reg property. I've done
> something like this for the exynos4415 CMU_ISPx units:
> 
>         cmu_isp: clock-controller@12060000 {
>                 compatible = "samsung,exynos4415-cmu-isp";
>                 reg = <0x12060000 0xB10>, <0x12070000 0xB10>;
>                 #clock-cells = <1>;
> 
>                 assigned-clocks = <&cmu CLK_FOUT_ISP_PLL>;
>                 assigned-clock-rates = <300000000>;
>         };

This is a different problem, this is a clock controller with multiple
sets of registers that are all different. In case of the cmu, it seems
that they are all the same, you just have multiple copies at different
locations, and they are connected to different devices.

	Arnd
