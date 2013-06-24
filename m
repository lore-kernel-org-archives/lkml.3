Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab3FXMS6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 08:18:58 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:34029 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab3FXMS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 08:18:57 -0400
MIME-Version: 1.0
In-Reply-To: <1371851554-4492-1-git-send-email-hanumant@codeaurora.org>
References: <1371851554-4492-1-git-send-email-hanumant@codeaurora.org>
Date: Mon, 24 Jun 2013 14:18:56 +0200
Message-ID: <CACRpkdbcscJYRgTQv_4SdR3i3PJwWfYQu=OonABz3xyLO+3Ubg@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: msm: Add support for MSM TLMM pinmux
From: Linus Walleij <linus.walleij@linaro.org>
To: Hanumant Singh <hanumant@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 11:52 PM, Hanumant Singh
<hanumant@codeaurora.org> wrote:

> Add a new device tree enabled pinctrl driver for
> Qualcomm MSM SoC's. This driver provides an extensible
> framework to interface all MSM's that use a TLMM pinmux,
> with the pinctrl subsytem.

This is really nice.

> +  The pin group node must additionally have a pin configuration node as its own
> +  child node. There can be more then one such configuration node for a pin group
> +  node. There can be one or more configurations within the configuration
> +  node. These configurations are applied to all pins mentoned above using the
> +  "qcom,pins" property. These configurations are specific to the pintype of the
> +  pins. The following pin configuration properties are supported by general
> +  purpose pins.
> +
> +  - qcom,gp-pull: Pull up/down configuration.
> +  - qcom,gp-drv: Drive strength configuration.
> +  - qcom,gp-dir: Pull up/down configuration in power down mode.

Rebase this to use the generic pin config mappings and parsing
code that can be found in the "devel" branch of the pinctrl tree.

> +  The following pin configurations are properties are supported by SDC pins
> +  - qcom,sdc1-clk-pull: Pull up/down configuration SDC1 clock pin.
> +  - qcom,sdc1-clk-drv: Drive strength configuration for SDC1 clock pin.
> +  - qcom,sdc1-cmd-pull: Pull up/down configuration for SDC1 command pin.
> +  - qcom,sdc1-cmd-drv: Drive strength configuration for SDC1 command pin.
> +  - qcom,sdc1-data-pull: Pull up/down configuration for SDC1 data pin.
> +  - qcom,sdc1-data-drv: Drive strength configuration for SDC1 data pin.
> +  - qcom,sdc2-clk-pull: Pull up/down configuration SDC2 clock pin.
> +  - qcom,sdc2-clk-drv: Drive strength configuration for SDC2 clock pin.
> +  - qcom,sdc2-cmd-pull: Pull up/down configuration for SDC2 command pin.
> +  - qcom,sdc2-cmd-drv: Drive strength configuration for SDC2 command pin.
> +  - qcom,sdc2-data-pull: Pull up/down configuration for SDC2 data pin.
> +  - qcom,sdc2-data-drv: Drive strength configuration for SDC2 data pin.

I don't understand why each sdc thing needs its own definition
for everything. Please use the generic pin config bindings, call the
generic parser function and then reject if someone tries to config
something that is not supported.

> +               spi-bus {
> +                       /*
> +                        * MOSI, MISO and CLK lines
> +                        * all sharing same function and config
> +                        * settings for each configuration node.
> +                        */
> +                       qcom,pins = <&gp 0>, <&gp 1>, <&gp 3>;
> +                       qcom,pin-func = <1>;
> +
> +                       /* Active configuration of bus pins */
> +                       spi-bus-active: spi-bus-active {
> +                               qcom,gp-drv = <3>; /* 8 MA */
> +                               qcom,gp-pull = <0>; /* No PULL */


This would be:

drive-strength = <8>;
bias-disable;

With the generic bindings I believe.

> +Example 4: Set up the default pin state for spi controller.
> +
> +       static inline int msm_spi_request_pins{struct msm_spi *dd)
> +       {
> +               /* ... */
> +               dd->pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
> +       }

Nowadays the device core will do this, so this is not any good
advice. (See commit ab78029ecc347debbd737f06688d788bd9d60c1d)

I will look closer at this when it uses generic pinconf and
generic pinconf DT bindings, let's target v3.12.

Yours,
Linus Walleij
