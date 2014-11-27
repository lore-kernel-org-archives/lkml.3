Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbaK0Iop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:44:45 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:51338 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbaK0Ion (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:44:43 -0500
MIME-Version: 1.0
In-Reply-To: <1415709535-31515-3-git-send-email-hongzhou.yang@mediatek.com>
References: <1415709535-31515-1-git-send-email-hongzhou.yang@mediatek.com>
	<1415709535-31515-3-git-send-email-hongzhou.yang@mediatek.com>
Date: Thu, 27 Nov 2014 09:44:42 +0100
Message-ID: <CACRpkdYSe_BH_qiHma2BA+c2otEi3wd0TBXy83t8vwrNL+3U2g@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] dt-bindings: Add pinctrl bindings for mt65xx/mt81xx.
From: Linus Walleij <linus.walleij@linaro.org>
To: Hongzhou Yang <hongzhou.yang@mediatek.com>
Cc: Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sascha Hauer <kernel@pengutronix.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        "Joe.C" <yingjoe.chen@mediatek.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        huang eddie <eddie.huang@mediatek.com>, dandan.he@mediatek.com,
        alan.cheng@mediatek.com, toby.liu@mediatek.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 1:38 PM, Hongzhou Yang
<hongzhou.yang@mediatek.com> wrote:

> +* Mediatek MT65XX Pin Controller
> +
> +The Mediatek's Pin controller is used to control GPIO pins.

It's not GPIO pins, since they are not always general purpose. It's just
pins. Say "control SoC pins".

> +Required properties:
> +- compatible: value should be either of the following.
> +    (a) "mediatek,mt8135-pinctrl", compatible with mt8135 pinctrl.
> +- mediatek,pctl-regmap: Should be a phandle of the syscfg node.
> +- gpio-controller : Marks the device node as a gpio controller.
> +- #gpio-cells: number of cells in GPIO specifier. Since the generic GPIO
> +  binding is used, the amount of cells must be specified as 2. See the below
> +  mentioned gpio binding representation for description of particular cells.
> +
> +       Eg: <&pio 6 0>
> +       <[phandle of the gpio controller node]
> +       [pin number within the gpio controller]

It's not a pin number really, it is a GPIO offset. But incidentally it's
the same as the pin number. (This is OK...)

> +- mediatek,pins: 2 integers array, represents gpio pinmux number and config
> +  setting. The format as following
> +
> +    node {
> +     mediatek,pins = <PIN_NUMBER_PINMUX>;
> +                     GENERIC_PINCONFIG;
> +    };

As suggested by Sacha, use just "pins" and define the binding as a patch
to Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
that is generic for multiplexing, so we get some order here.

I want you however to put pin multiplexing and pin configuration into
different nodes if possible. I don't like combines muxing and config
nodes. If necessary tag the node with something.

In the end we can also move the parsing functions to the pinctrl core, as
long as the bindings are correct (possibly as a refactoring later).

> +               i2c0_pins_a: i2c0@0 {
> +                       pins1 {
> +                               mediatek,pins = <MT8135_PIN_100_SDA0__FUNC_SDA0>,
> +                                               <MT8135_PIN_101_SCL0__FUNC_SCL0>;
> +                               bias-disable;
> +                       };
> +               };

I would split it up.

i2c0_pins_a: i2c0@0 {
        pins1 {
                pins = <MT8135_PIN_100_SDA0>;
                function = <MT8135_PIN_100_FUNC_SDA0>;
        };
        pins2 {
               pins = <MT8135_PIN_100_SDA0>;
               bias-disable;
        };
};

One node for the multiplexing, one node for the config. This is the
pattern used by most drivers, so I want to have this structure.

It is also easy to tell one node from the other: if it contains "function"
we know it's a multiplexing node, if it doesn't, it's a config node.

Yours,
Linus Walleij
