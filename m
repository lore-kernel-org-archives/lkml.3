Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557AbaKCJkN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 04:40:13 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40044 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaKCJkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 04:40:10 -0500
Message-ID: <1415007592.3060.5.camel@pengutronix.de>
Subject: Re: [PATCH v2 2/3] dt-bindings: Add Reset Controller for MediaTek
 SoC
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Flora Fu <flora.fu@mediatek.com>
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
Date: Mon, 03 Nov 2014 10:39:52 +0100
In-Reply-To: <1415005371-4323-3-git-send-email-flora.fu@mediatek.com>
References: <1415005371-4323-1-git-send-email-flora.fu@mediatek.com>
	 <1415005371-4323-3-git-send-email-flora.fu@mediatek.com>
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

Hi Flora,

Am Montag, den 03.11.2014, 17:02 +0800 schrieb Flora Fu:
> Add device tree bindings.
> 
> Signed-off-by: Flora Fu <flora.fu@mediatek.com>
> ---
>  .../devicetree/bindings/reset/mediatek,reset.txt   | 45 ++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/reset/mediatek,reset.txt
> 
> diff --git a/Documentation/devicetree/bindings/reset/mediatek,reset.txt b/Documentation/devicetree/bindings/reset/mediatek,reset.txt
> new file mode 100644
> index 0000000..3c5687b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/reset/mediatek,reset.txt
> @@ -0,0 +1,45 @@
> +MediaTek SoC Reset Controller
> +======================================
> +The reset controller driver accesses registers through the syscon regmap. It
> +is a child node of syscon.
> +
> +Required properties:
> +- compatible : "mediatek,reset"
> +- #reset-cells: 1
> +- reg: The register region can be accessed from syscon. The first parameter is
> +  reset base address offset. The second parameter is byte width of reset registers.
> +
> +example:
> +infracfg: syscon@10001000 {
> +	#address-cells = <1>;
> +	#size-cells = <0>;

Since we use reg = <0x30 0x8> below, #size-cells should be set to <1>.

I have updated the syscon child support patch and fixed the binding
documentation to allow this. Previously I had only thought about
children that use a single register or just a bitfield in a single
register.

With that change, feel free to consider this patch
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

> +	compatible = "mediatek,mt8135-infracfg", "syscon";
> +	reg = <0 0x10001000 0 0x1000>;
> +
> +	infrarst: reset-controller@30 {
> +		#reset-cells = <1>;
> +		compatible = "mediatek,mt8135-infracfg-reset", "mediatek,reset";
> +		reg = <0x30 0x8>;
> +	};
> +};
> +
> +Specifying reset lines connected to IP modules
> +==============================================
> +
> +The reset controller(mtk-reset) manages various reset sources. Those device nodes should
> +specify the reset line on the rstc in their resets property, containing a phandle to the
> +rstc device node and a RESET_INDEX specifying which module to reset, as described in
> +reset.txt.
> +
> +For MediaTek SoC, RESET_INDEX is reset bit defined in INFRACFG or PERICFG registers.
> +
> +example:
> +pwrap: pwrap@1000f000 {
> +	compatible = "mediatek,mt8135-pwrap";
> +	reg = <0 0x1000f000 0 0x1000>,
> +		<0 0x11017000 0 0x1000>;
> +	reg-names = "pwrap-base",
> +		"pwrap-bridge-base";
> +	resets = <&infrarst 7>, <&perirst 34>;

Maybe it would be useful to add a header with #defines for these reset
bit indices?

> +	reset-names = "infrarst", "perirst";
> +};

regards
Philipp

