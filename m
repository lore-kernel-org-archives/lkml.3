Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933775AbaJ2PkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:40:22 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:36682 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933560AbaJ2PkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:40:20 -0400
MIME-Version: 1.0
In-Reply-To: <1414583525-17395-8-git-send-email-zyw@rock-chips.com>
References: <1414583525-17395-1-git-send-email-zyw@rock-chips.com>
	<1414583525-17395-8-git-send-email-zyw@rock-chips.com>
Date: Wed, 29 Oct 2014 08:40:19 -0700
X-Google-Sender-Auth: ywQ0xgJOPbv2DKiYfYoI4v5DIpo
Message-ID: <CAD=FV=XeGj63_MEPL5i1ihUORuHnwD1ktEjJN5x=B-tkHV088w@mail.gmail.com>
Subject: Re: [PATCH v6 7/7] ARM: dts: add suspend voltage setting for RK808
From: Doug Anderson <dianders@chromium.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Mike Turquette <mturquette@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kevin Hilman <khilman@kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Wed, Oct 29, 2014 at 4:52 AM, Chris Zhong <zyw@rock-chips.com> wrote:
> global_pwroff would be pull to high when RK3288 entering suspend,
> this pin is a sleep signal for RK808, so RK808 could goto sleep
> mode, and some regulators would be disable.
>
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
>
> ---
>
> Changes in v6: None
> Changes in v5: None
> Changes in v4: None
> Changes in v3: None
> Changes in v2: None
>
>  arch/arm/boot/dts/rk3288-evb-rk808.dts |   16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/boot/dts/rk3288-evb-rk808.dts b/arch/arm/boot/dts/rk3288-evb-rk808.dts
> index ff522f8..319fcb6 100644
> --- a/arch/arm/boot/dts/rk3288-evb-rk808.dts
> +++ b/arch/arm/boot/dts/rk3288-evb-rk808.dts
> @@ -27,7 +27,7 @@
>                 interrupt-parent = <&gpio0>;
>                 interrupts = <4 IRQ_TYPE_LEVEL_LOW>;
>                 pinctrl-names = "default";
> -               pinctrl-0 = <&pmic_int>;
> +               pinctrl-0 = <&pmic_int &global_pwroff>;
>                 rockchip,system-power-controller;
>                 wakeup-source;
>                 #clock-cells = <1>;
> @@ -46,6 +46,7 @@
>                                 regulator-min-microvolt = <750000>;
>                                 regulator-max-microvolt = <1300000>;
>                                 regulator-name = "vdd_arm";
> +                               regulator-suspend-mem-disabled;

NAK.  "regulator-suspend-mem-disabled" is a local property added by
local Chrome OS patches and doesn't belong in an upstream submission.

You should using the new patches from Chanwoo.

40e20d6 regulator: of: Add support for parsing regulator_state for suspend state
291d761 regulator: Document binding for regulator suspend state for PM state

In your case, it would look like:

regulator-state-mem {
  regulator-off-in-suspend;
};

> @@ -76,6 +80,7 @@
>                                 regulator-min-microvolt = <3300000>;
>                                 regulator-max-microvolt = <3300000>;
>                                 regulator-name = "vccio_pmu";
> +                               regulator-suspend-mem-microvolt = <3300000>;

Similarly this property isn't upstream.  You can see Javier's work on
this in <https://patchwork.kernel.org/patch/5106351/> and I think
you'll need an rk808-specific patch just like he needs an max77802
patch.  You probably want to wait for him to spin it first, though,
since Mark had feedback on his last patch.

-Doug
