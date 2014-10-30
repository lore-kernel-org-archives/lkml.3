Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757AbaJ3JDO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 05:03:14 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43468 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579AbaJ3JDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 05:03:13 -0400
Message-ID: <1414659745.3069.2.camel@pengutronix.de>
Subject: Re: [PATCH 3/3] ARM: dts: mt8135: Add Reset Controller for MediaTek
 SoC
From: Philipp Zabel <p.zabel@pengutronix.de>
To: flora.fu@mediatek.com
Cc: Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>, arm@kernel.org,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        srv_heupstream@mediatek.com, Sascha Hauer <kernel@pengutronix.de>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
Date: Thu, 30 Oct 2014 10:02:25 +0100
In-Reply-To: <1414638733-10080-4-git-send-email-flora.fu@mediatek.com>
References: <1414638733-10080-1-git-send-email-flora.fu@mediatek.com>
	 <1414638733-10080-4-git-send-email-flora.fu@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.6-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am Donnerstag, den 30.10.2014, 11:12 +0800 schrieb
flora.fu@mediatek.com:
> From: Flora Fu <flora.fu@mediatek.com>
> 
> Add reset controller to MT8135 board dts.
> 
> Signed-off-by: Flora Fu <flora.fu@mediatek.com>
> ---
>  arch/arm/boot/dts/mt8135.dtsi | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/mt8135.dtsi b/arch/arm/boot/dts/mt8135.dtsi
> index 90a56ad..0b1ddc9 100644
> --- a/arch/arm/boot/dts/mt8135.dtsi
> +++ b/arch/arm/boot/dts/mt8135.dtsi
> @@ -102,6 +102,28 @@
>  			clock-names = "system-clk", "rtc-clk";
>  		};
>  
> +		infracfg: syscon@10001000 {
> +			compatible = "mediatek,mt8135-infracfg", "syscon";
> +			reg = <0 0x10001000 0 0x1000>;
> +		};
> +
> +		pericfg: syscon@10003000 {
> +			compatible = "mediatek,mt8135-pericfg", "syscon";
> +			reg = <0 0x10003000 0 0x1000>;
> +		};
> +
> +		infrarst: reset-controller@10001030 {
> +			#reset-cells = <1>;
> +			compatible = "mediatek,mt8135-infracfg-reset", "mediatek,reset";
> +			mediatek,syscon-reset = <&infracfg 0x30 0x8>;
> +		};
> +
> +		perirst: reset-controller@10003000 {
> +			#reset-cells = <1>;
> +			compatible = "mediatek,mt8135-pericfg-reset", "mediatek,reset";
> +			mediatek,syscon-reset = <&pericfg 0x00 0x8>;
> +		};
> +

Since the reset controller driver accesses registers solely through the
syscon regmap, I'd prefer to keep with the device tree control graph
concept and make the reset-controller nodes children of the syscon
nodes. I've brought this up before: https://lkml.org/lkml/2014/5/27/422,
and I think this is another case where child node support for syscon
makes sense:

        infracfg: syscon@10001000 {
                compatible = "mediatek,mt8135-infracfg", "syscon";
                reg = <0 0x10001000 0 0x1000>;
                
                infrarst: reset-controller@30 {
                        #reset-cells = <1>;
                        compatible = "mediatek,mt8135-infracfg-reset", "mediatek,reset";
                        reg = <0x30 0x8>;
                };
        };

        pericfg: syscon@10003000 {
                compatible = "mediatek,mt8135-pericfg", "syscon";
                reg = <0 0x10003000 0 0x1000>;

                perirst: reset-controller@00 {                                                                                               
                        #reset-cells = <1>;
                        compatible = "mediatek,mt8135-pericfg-reset", "mediatek,reset";
                        reg = <0x00 0x8>;
                };
        };

regards
Philipp

