Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422630AbaDQDfX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 23:35:23 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:61136 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756358AbaDQDfU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 23:35:20 -0400
Date: Thu, 17 Apr 2014 11:33:06 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Antoine =?UTF-8?B?VMOpbmFydA==?= 
	<antoine.tenart@free-electrons.com>
CC: "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "chris@printf.net" <chris@printf.net>,
        "anton@enomsg.org" <anton@enomsg.org>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] ARM: dts: berlin: add the SDHCI nodes for the BG2Q
Message-ID: <20140417113306.545ca4a7@xhacker>
In-Reply-To: <1397652011-21284-4-git-send-email-antoine.tenart@free-electrons.com>
References: <1397652011-21284-1-git-send-email-antoine.tenart@free-electrons.com>
	<1397652011-21284-4-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-17_01:2014-04-16,2014-04-17,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=2
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1404170059
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Antoine,

On Wed, 16 Apr 2014 05:40:10 -0700
Antoine Ténart <antoine.tenart@free-electrons.com> wrote:

> Add the SDHCI nodes for the Marvell Berlin BG2Q, using the berlin-sdhci
> driver.
> 
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
>  arch/arm/boot/dts/berlin2q.dtsi | 40
> ++++++++++++++++++++++++++++++++++++++++ 1 file changed, 40 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/berlin2q.dtsi
> b/arch/arm/boot/dts/berlin2q.dtsi index 5925e6a16749..8f897d461460 100644
> --- a/arch/arm/boot/dts/berlin2q.dtsi
> +++ b/arch/arm/boot/dts/berlin2q.dtsi
> @@ -67,6 +67,14 @@
>  		clock-div = <3>;
>  	};
>  
> +	sdio1clk: sdio1clk {
> +		compatible = "fixed-factor-clock";
> +		#clock-cells = <0>;
> +		clocks = <&syspll>;
> +		clock-mult = <1>;
> +		clock-div = <4>;
> +	};
> +
>  	soc {
>  		compatible = "simple-bus";
>  		#address-cells = <1>;
> @@ -75,6 +83,38 @@
>  		ranges = <0 0xf7000000 0x1000000>;
>  		interrupt-parent = <&gic>;
>  
> +		sdhci0: sdhci@ab0000 {
> +			compatible = "marvell,berlin2q-sdhci";
> +			reg = <0xab0000 0x200>;
> +			clocks = <&sdio1clk>;
> +			interrupts = <GIC_SPI 17 IRQ_TYPE_LEVEL_HIGH>;
> +			keep-power-in-suspend;
> +			enable-sdio-wakeup;
> +			broken-cd;
> +			status = "disabled";
> +		};
> +
> +		sdhci1: sdhci@ab0800 {
> +			compatible = "marvell,berlin2q-sdhci";
> +			reg = <0xab0800 0x200>;
> +			clocks = <&sdio1clk>;
> +			interrupts = <GIC_SPI 20 IRQ_TYPE_LEVEL_HIGH>;
> +			keep-power-in-suspend;
> +			enable-sdio-wakeup;
> +			status = "disabled";
> +		};
> +
> +		sdhci2: sdhci@ab1000 {
> +			compatible = "marvell,berlin2q-sdhci";
> +			reg = <0xab1000 0x200>;
> +			interrupts = <GIC_SPI 28 IRQ_TYPE_LEVEL_HIGH>;
> +			clocks = <&sdio1clk>;
> +			keep-power-in-suspend;
> +			enable-sdio-wakeup;
> +			broken-cd;
> +			status = "disabled";
> +		};

could we put sdhci@ab1000 at the first of sdhci lists? For two reasons:

1. sdhci@ab0000 and sdhci@ab0800 is called as sdhci1 and sdhci2 in mrvl
internal discussion, so this would make the name consistent when we
upgrade linux kernel to one mainline version.

2. sdhci@ab1000 is always used for emmc. if sdhci@ab0800 is put at the
head of sdhci@ab1000, and there's one sdcard in it, mmcblock0 would be
the sdcard rather than emmc.

I dunno whether there's elegant solutions for these two issues. alias? Could
anyone kindly help?

Thanks in advance,
Jisheng
