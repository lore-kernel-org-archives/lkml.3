Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600Ab3G2Qhi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 12:37:38 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:61996 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135Ab3G2Qhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 12:37:36 -0400
MIME-Version: 1.0
In-Reply-To: <1374702089-2832-1-git-send-email-hanumant@codeaurora.org>
References: <1374702089-2832-1-git-send-email-hanumant@codeaurora.org>
Date: Mon, 29 Jul 2013 18:37:36 +0200
Message-ID: <CACRpkdZLFD-KAvZdUUvQKje3vAH1D0EJMW9PSK8VSp3Xs4eiGA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: msm: Add support for MSM TLMM pinmux
From: Linus Walleij <linus.walleij@linaro.org>
To: Hanumant Singh <hanumant@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bjorn Andersson <Bjorn.Andersson@sonymobile.com>,
        "Bird, Tim" <Tim.Bird@sonymobile.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        ext Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 11:41 PM, Hanumant Singh
<hanumant@codeaurora.org> wrote:

> Add a new device tree enabled pinctrl driver for
> Qualcomm MSM SoC's. This driver provides an extensible
> framework to interface all MSM's that use a TLMM pinmux,
> with the pinctrl subsytem.
>
> This driver is split into two parts: the pinctrl interface
> and the TLMM version specific implementation. The pinctrl
> interface parses the device tree and registers with the pinctrl
> subsytem. The TLMM version specific implementation supports
> pin configuration/register programming for the different
> pin types present on a given TLMM pinmux version.
>
> Add support only for TLMM version 3 pinmux right now,
> as well as, only two of the different pin types present on the
> TLMM v3 pinmux.
> Pintype 1: General purpose pins.
> Pintype 2: SDC pins.

I guess this is the v4 patch set?

Please include a small changelog so I can keep track of
things...


> Change-Id: I065d874cd2c6fd002d5b3cb4b355445bb6912bf4

This thing is not interesting to the kernel community.

> diff --git a/Documentation/devicetree/bindings/pinctrl/msm-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/msm-pinctrl.txt
> new file mode 100644
> index 0000000..0f17a94
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pinctrl/msm-pinctrl.txt

This needs to be broken out and sent for separate review on
the devicetree@vger.kernel.org mailing list.

> +Required Properties
> +  - qcom,pin-type-*: identifies the pin type. Pin types supported are
> +                       qcom,pin-type-gp (General purpose)
> +                       qcom,pin-type-sdc (SDC)

I am wondering if it it would not be simpler to split this
driver in two, one for the GP pins and one for the SDC pins.
Having this tag on each and every pin seems *very*
awkward.

If you have two drivers and two device tree nodes, one for
GP pins and one for SDC pins, just separated by different
compatible strings and different memory regs, things will
look simpler and be easier to maintain I think.

Unless there is some strong cross-dependency between
GP and SDC please explore this approach.

> +- Pin groups as child nodes: The pin mux (selecting pin function
> +  mode) and pin config (pull up/down, driver strength, direction) settings are
> +  represented as child nodes of the pin-controller node. There is no limit on
> +  the count of these child nodes.
> +
> +  Required Properties
> +    -qcom,pins: phandle specifying pin type and a pin number.
> +    -qcom,num-grp-pins: number of pins in the group.
> +    -label: name to to identify the pin group.
> +
> +  Optional Properties
> +    -qcom,pin-func: function setting for the pin group.

After some scratching my head I realize that you are trying
to reimplement parts of pinctrl-single.c.

I.e. you try to put all the definitions of groups and functions
into the devicetree instead of having this in the driver
as tables.

If this is what you want to do you should use pinctrl-single.c.
It might be possible to use pinctrl-single.c only for the
GP pins.

But if there is something complex about the hardware that
make pinctrl-single.c not fit the bill I advice you to encode
the lists of groups and functions into the driver instead.

Also, split this in a per-soc manner (compare the other
drivers) so you can support plugging one file per SoC
for the different MSM chips using this pin controller.

Yours,
Linus Walleij
