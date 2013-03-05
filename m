Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab3CEXsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 18:48:55 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:50588 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab3CEXsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 18:48:54 -0500
MIME-Version: 1.0
In-Reply-To: <1360957573-864-2-git-send-email-dianders@chromium.org>
References: <1360887677-20758-1-git-send-email-dianders@chromium.org>
 <1360957573-864-1-git-send-email-dianders@chromium.org> <1360957573-864-2-git-send-email-dianders@chromium.org>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Wed, 6 Mar 2013 08:48:33 +0900
Message-ID: <CAHfPSqAtxjYV79VvQZDLtzfyRxkYoMEc4=S2fN=KRNtYOEQ7ig@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] ARM: dts: Add i2c-arbitrator bus for exynos5250-snow
To: Doug Anderson <dianders@chromium.org>
Cc: Wolfram Sang <wsa@the-dreams.de>, Simon Glass <sjg@chromium.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Yuvaraj Kumar <yuvaraj.cd@gmail.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, u.kleine-koenig@pengutronix.de,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Girish Shivananjappa <girish.shivananjappa@linaro.org>,
        bhushan.r@samsung.com, sreekumar.c@samsung.com,
        Prashanth G <prashanth.g@samsung.com>, Olof Johansson <olof@lixom.net>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Grant Grundler <grundler@chromium.org>,
        Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 February 2013 04:46, Doug Anderson <dianders@chromium.org> wrote:
> We need to use the i2c-arbitrator to talk to any of the devices on i2c
> bus 4 on exynos5250-snow so that we don't confuse the embedded
> controller (EC).  Add the i2c-arbitrator to the device tree.  As we
> add future devices (keyboard, sbs, tps65090) we'll add them on top of
> this.
>
> The arbitrated bus is numbered 104 simply as a convenience to make it
> easier for people poking around to guess that it might have something
> to do with the physical bus 4.
>
> The addition is split between the cros5250-common and the snow device
> tree file since not all cros5250-class devices use arbitration.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
Tested-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
The patch set [v3] is tested on snow with test case which uses i2c-4 from both
EC and AP side continuously for a more than a couple of minutes.

> ---
> Changes in v3: None
> Changes in v2:
> - Use new device tree property names / compatible string.
> - Include that the GPIOs for arbitration are active low.
>
>  arch/arm/boot/dts/cros5250-common.dtsi |  5 ++++-
>  arch/arm/boot/dts/exynos5250-snow.dts  | 25 +++++++++++++++++++++++++
>  2 files changed, 29 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/boot/dts/cros5250-common.dtsi b/arch/arm/boot/dts/cros5250-common.dtsi
> index 46c0980..f451375 100644
> --- a/arch/arm/boot/dts/cros5250-common.dtsi
> +++ b/arch/arm/boot/dts/cros5250-common.dtsi
> @@ -58,7 +58,10 @@
>         };
>
>         i2c@12CA0000 {
> -               status = "disabled";
> +               samsung,i2c-sda-delay = <100>;
> +               samsung,i2c-max-bus-freq = <66000>;
> +               gpios = <&gpa2 0 3 3 0>,
> +                       <&gpa2 1 3 3 0>;
>         };
>
>         i2c@12CB0000 {
> diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
> index 17dd951..d2d4b48 100644
> --- a/arch/arm/boot/dts/exynos5250-snow.dts
> +++ b/arch/arm/boot/dts/exynos5250-snow.dts
> @@ -16,6 +16,10 @@
>         model = "Google Snow";
>         compatible = "google,snow", "samsung,exynos5250";
>
> +       aliases {
> +               i2c104 = &i2c_104;
> +       };
> +
>         gpio-keys {
>                 compatible = "gpio-keys";
>
> @@ -29,6 +33,27 @@
>                 };
>         };
>
> +       i2c-arbitrator {
> +               compatible = "i2c-arbitrator-cros-ec";
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +
> +               i2c-parent = <&{/i2c@12CA0000}>;
> +
> +               ap-claim-gpio = <&gpf0 3 1 0x10000 0>;
> +               ec-claim-gpio = <&gpe0 4 0 0x10003 0>;
> +               slew-delay-us = <10>;
> +               wait-retry-us = <3000>;
> +               wait-free-us = <50000>;
> +
> +               /* Use ID 104 as a hint that we're on physical bus 4 */
> +               i2c_104: i2c@0 {
> +                       reg = <0>;
> +                       #address-cells = <1>;
> +                       #size-cells = <0>;
> +               };
> +       };
> +
>         /*
>          * On Snow we've got SIP WiFi and so can keep drive strengths low to
>          * reduce EMI.
> --
> 1.8.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



--
Shine bright,
(: Nav :)
