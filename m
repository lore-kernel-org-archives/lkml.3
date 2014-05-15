Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbaEORc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:32:58 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:60176 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622AbaEORcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:32:52 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-27-5374fa413876
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tushar Behera <tushar.behera@linaro.org>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Mark Brown <broonie@kernel.org>, Tomasz Figa <tomasz.figa@gmail.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH RFC 0/4] Add support for Exynos clock output configuration
Date: Thu, 15 May 2014 19:32:27 +0200
Message-id: <1400175151-27779-1-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprALMWRmVeSWpSXmKPExsVy+t/xq7qOv0qCDX49ZLeY+vAJm8X8I+dY
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZLH2yF12i6XXLzJZPJ1wkc1i0dYv7BZTFh1mtWjde4Td
	Yv2M1ywWq3b9YbRo/7uXzYHfY828NYweO2fdZffYtKqTzePOtT1sHpuX1Hv0bVnF6PF5k1wA
	exSXTUpqTmZZapG+XQJXxo8v69gK7vBXfHiynK2B8RJ3FyMnh4SAicTC5VsYIWwxiQv31rN1
	MXJxCAksZZT4uf4+E4TTxyRxaccHFpAqNgE1ic8Nj9hAbBEBVYnPbQvYQYqYBaaxSKxa1s4O
	khAW8JLYu2AdE4jNAlT04nEbmM0r4CTRfPw2E8Q6OYn/L1cwTWDkXsDIsIpRNLU0uaA4KT3X
	UK84Mbe4NC9dLzk/dxMjJBS/7GBcfMzqEKMAB6MSD2/H/uJgIdbEsuLK3EOMEhzMSiK85s9L
	goV4UxIrq1KL8uOLSnNSiw8xMnFwSjUw6jItib/g1VVXscLsQ92zmXsf+C1OZWjsnBO9h72f
	Te/J4SWfbuy4ybp9hWzjFvmGxEAm+SYRl9cirHz8P3z3vxBreLjDaxbTqbxpWY5uyrIvI/0i
	rCZEvZsha9ToLJj/Ufoj46az7/hv5XKbJ71ZPn2XXfr3b1ZlXU53LwVk+e1p37i+rPyiEktx
	RqKhFnNRcSIA+fidtCMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On all Exynos SoCs there is a dedicated CLKOUT pin that allows many of
internal SoC clocks to be output from the SoC. The hardware structure
of CLKOUT related clocks looks as follows:

	CMU	|---> clock0 --------->	|	PMU	|
		|			|		|
    several	|---> clock1 ---------> |	mux	|
    muxes	|			|	+	|---> CLKOUT
    dividers	|       ...		|	gate	|
    and gates	|			|		|
		|---> clockN ---------> |		|

Since the block responsible for handling the pin is PMU, not CMU,
a separate driver, that binds to PMU node is required and acquires
all input clocks by standard DT clock look-up. This way we don't need
any cross-IP block drivers and cross-driver register sharing or
nodes for fake devices.

To represent the PMU mux/gate clock, generic composite clock is registered.

Tested on Odroid U3, with HSIC/USB hub using CLKOUT as reference clock,
with some additional patches.

Depends on:
[PATCHv4 0/4] Enable usbphy and hsotg for exynos4
(http://thread.gmane.org/gmane.linux.kernel.samsung-soc/30631)
for Exynos4210/4x12 PMU DT nodes.

Tomasz Figa (4):
  clk: samsung: exynos4: Add missing DMC clock hierarchy
  clk: samsung: exynos4: Add CLKOUT clock hierarchy
  clk: samsung: Add driver to control CLKOUT line on Exynos SoCs
  ARM: dts: exynos: Update PMU node with CLKOUT related data

 .../devicetree/bindings/arm/samsung/pmu.txt        |  18 +++
 arch/arm/boot/dts/exynos4210.dtsi                  |  10 ++
 arch/arm/boot/dts/exynos4x12.dtsi                  |   7 +
 arch/arm/boot/dts/exynos5250.dtsi                  |   3 +
 arch/arm/boot/dts/exynos5420.dtsi                  |   3 +
 drivers/clk/samsung/Makefile                       |   1 +
 drivers/clk/samsung/clk-exynos4.c                  | 156 +++++++++++++++++++++
 drivers/clk/samsung/exynos-clkout.c                | 107 ++++++++++++++
 include/dt-bindings/clock/exynos4.h                |   6 +
 9 files changed, 311 insertions(+)
 create mode 100644 drivers/clk/samsung/exynos-clkout.c

-- 
1.9.2

