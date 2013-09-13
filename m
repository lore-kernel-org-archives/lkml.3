Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab3IMWe0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 18:34:26 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46525 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529Ab3IMWeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 18:34:24 -0400
Message-ID: <523392EA.6050909@wwwdotorg.org>
Date: Fri, 13 Sep 2013 16:34:18 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Xiubo Li <Li.Xiubo@freescale.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: r65073@freescale.com, thierry.reding@gmail.com, s.hauer@pengutronix.de,
        t.figa@samsung.com, grant.likely@linaro.org, linux@arm.linux.org.uk,
        rob@landley.net, ian.campbell@citrix.com, mark.rutland@arm.com,
        pawel.moll@arm.com, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCHv4 4/4] Documentation: Add device tree bindings for Freescale
 FTM PWM.
References: <1379051922-4930-1-git-send-email-Li.Xiubo@freescale.com> <1379051922-4930-5-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1379051922-4930-5-git-send-email-Li.Xiubo@freescale.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 11:58 PM, Xiubo Li wrote:
> This adds the Document for Freescale FTM PWM driver under
> Documentation/devicetree/bindings/pwm/.

> diff --git a/Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt b/Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt

> +Required properties:

> +- clock-names : Includes the following module clock source entries:
> +    "ftm0" (system clock),
> +    "ftm0_fix_sel" (fixed frequency clock),
> +    "ftm0_ext_sel" (external clock)
> +- clocks : Must contain an entry list for entries in clock-names.

s/an entry list/a clock specifier/
s/for entries/for each entry/

> +- fsl,pwm-counter-clk: The FTM PWM counter clock source, should be one of the
> +  entries in clock-names.

So the IP block has 3 input clocks, and also a mux to select which one
to use? That sounds slightly unusual, but possible.

If there is really only 1 clock input to the IP block, and the mux is
part of some other module, then this binding should have only 1 entry in
clocks.

> +- For each channel's pinctrl, the "chN-active" and "chN-idle" states should be
> +  implemented at the same time.

I still don't believe that multiple pinctrl states active at once is
something that the pinctrl bindings conceptually support. CC+=LinusW, do
we want to allow this?

Assuming this is allowed, you'd want to write something more like the
following:

pinctrl-names: Must include "chN-active" and "chN-idle" for each channel
ID N in range 0..7.
pinctrl-NNN: One property must exist for each entry in pinctrl-names.
See ../pinctrl/pinctrl-bindings.txt for details of the property values.
> +Example:
> +
> +pwm0: pwm@40038000 {
> +		compatible = "fsl,vf610-ftm-pwm";
> +		reg = <0x40038000 0x1000>;
> +		#pwm-cells = <3>;
> +		clock-names = "ftm0", "ftm0_fix_sel", "ftm0_ext_sel";
> +		clocks = <&clks VF610_CLK_FTM0>,
> +			<&clks VF610_CLK_FTM0_FIX_SEL>,
> +			<&clks VF610_CLK_FTM0_EXT_SEL>;
> +		pinctrl-names = "ch0-active", "ch0-idle", "ch1-active", "ch1-idle",
> +		....;
> +		pinctrl-0 = <&pinctrl_pwm0_ch0_active>;
> +		pinctrl-1 = <&pinctrl_pwm0_ch0_idle>;
> +		pinctrl-2 = <&pinctrl_pwm0_ch1_active>;
> +		pinctrl-3 = <&pinctrl_pwm0_ch1_idle>;
> +		...
> +		fsl,pwm-counter-clk = "ftm0_ext_sel";
> +};

