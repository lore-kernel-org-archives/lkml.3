Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933778AbaJaDgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 23:36:06 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:57460 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751050AbaJaDgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 23:36:04 -0400
X-Listener-Flag: 11101
Subject: Re: [PATCH 3/3] ARM: dts: mt8135: Add Reset Controller for
 MediaTek SoC
From: Flora Fu <flora.fu@mediatek.com>
To: Philipp Zabel <p.zabel@pengutronix.de>, Rob Herring <robh+dt@kernel.org>
CC: Matthias Brugger <matthias.bgg@gmail.com>, <arm@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <srv_heupstream@mediatek.com>, Sascha Hauer <kernel@pengutronix.de>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <flora.fu@mediatek.com>
In-Reply-To: <1414659745.3069.2.camel@pengutronix.de>
References: <1414638733-10080-1-git-send-email-flora.fu@mediatek.com>
	 <1414638733-10080-4-git-send-email-flora.fu@mediatek.com>
	 <1414659745.3069.2.camel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 31 Oct 2014 11:35:55 +0800
Message-ID: <1414726555.25409.38.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Philipp,

On Thu, 2014-10-30 at 10:02 +0100, Philipp Zabel wrote:
> Since the reset controller driver accesses registers solely through the
> syscon regmap, I'd prefer to keep with the device tree control graph
> concept and make the reset-controller nodes children of the syscon
> nodes. I've brought this up before: https://lkml.org/lkml/2014/5/27/422,
> and I think this is another case where child node support for syscon
> makes sense:
> 
>         infracfg: syscon@10001000 {
>                 compatible = "mediatek,mt8135-infracfg", "syscon";
>                 reg = <0 0x10001000 0 0x1000>;
>                 
>                 infrarst: reset-controller@30 {
>                         #reset-cells = <1>;
>                         compatible = "mediatek,mt8135-infracfg-reset", "mediatek,reset";
>                         reg = <0x30 0x8>;
>                 };
>         };
> 
>         pericfg: syscon@10003000 {
>                 compatible = "mediatek,mt8135-pericfg", "syscon";
>                 reg = <0 0x10003000 0 0x1000>;
> 
>                 perirst: reset-controller@00 {                                                                                               
>                         #reset-cells = <1>;
>                         compatible = "mediatek,mt8135-pericfg-reset", "mediatek,reset";
>                         reg = <0x00 0x8>;
>                 };
>         };
> 
> regards
> Philipp
> 

Yes, such dts arrangement looks better to me. Implementation in this
version is trying to doing the same thing as your proposal. The new
property "mediatek,syscon-reset = <&infracfg 0x30 0x8>;" specifies base
address of reset and byte width for controlling resets.

If https://lkml.org/lkml/2014/5/27/422 is adopt into kernel release, it
will be well organized to configure reset controller as child of regmap
which is compatible to syscon.

In reset driver, it is able to get syscon regmap from parent node and
retrieve the address offset and byte with for controlling resets.
--- 
syscon_np = of_get_parent(np);
data->regmap = syscon_node_to_regmap(syscon_np);
if (IS_ERR(data->regmap)) {
	dev_err(&pdev->dev, "couldn't get syscon-reset regmap\n");
	return PTR_ERR(data->regmap);
}
ret = of_property_read_u32_array(np, "reg", reg, 2);
if (ret) {
	dev_err(&pdev->dev, "couldn't read reset base from syscon!\n");
	return -EINVAL;
}

---


Thanks,
Flora



