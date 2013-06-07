Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab3FGMxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 08:53:54 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:62646 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab3FGMxw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 08:53:52 -0400
MIME-Version: 1.0
In-Reply-To: <201306062111.40983.heiko@sntech.de>
References: <201306062107.58875.heiko@sntech.de>
	<201306062111.40983.heiko@sntech.de>
Date: Fri, 7 Jun 2013 14:53:51 +0200
Message-ID: <CACRpkdZ97poa5HOP4baDnsdq5OjwO5S2=+pPH9ey84r=ZW43nA@mail.gmail.com>
Subject: Re: [PATCH v2 5/8] pinctrl: add pinctrl driver for Rockchip SoCs
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 6, 2013 at 9:11 PM, Heiko Stübner <heiko@sntech.de> wrote:

> This driver adds support the Cortex-A9 based SoCs from Rockchip,
> so at least the RK2928, RK3066 (a and b) and RK3188.
> Earlier Rockchip SoCs seem to use similar mechanics for gpio
> handling so should be supportable with relative small changes.
> Pull handling on the rk3188 is currently a stub, due to it being
> a bit different to the earlier SoCs.
>
> Pinmuxing as well as gpio (and interrupt-) handling tested on
> a rk3066a based machine.
>
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>

This basically looks fine.

(...)
> +Required properties for pin configuration node:
> +  - rockchip,pins: 4 integers array, represents a group of pins mux and config
> +    setting. The format is rockchip,pins = <PIN_BANK PIN_BANK_NUM MUX CONFIG>.
> +    The MUX 0 means gpio and MUX 1 to 3 mean the specific device function
> +
> +Bits used for CONFIG:
> +PULL_AUTO      (1 << 0): indicate this pin needs a pull setting for SoCs
> +                         that determine the pull up or down themselfs
> +PULL_UP                (1 << 1): indicate this pin needs a pull up
> +PULL_DOWN      (1 << 2): indicate this pin needs a pull down


So I would rather have these (as a separate patch) in
<dt-bindings/pinctrl/pinconfig.h>
The documentation in
Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
and the same bindings to be used for as many systems as
possible utilizing generic pin config.

I will be liberal in accepting patches creating this
infrastructure.

We need to realize that we will be setting example for everyone
else, and everyone else will be following that example.

> +       for (i = 0, j = 0; i < size; i += 4, j++) {
> +               unsigned long pinconf;
> +
> +               num = be32_to_cpu(*list++);
> +               bank = bank_num_to_bank(info, num);
> +               if (IS_ERR(bank))
> +                       return PTR_ERR(bank);
> +
> +               pin = be32_to_cpu(*list++);
> +               grp->pins[j] = bank->pin_base + pin;
> +               grp->func[j] = be32_to_cpu(*list++);
> +
> +               pinconf = be32_to_cpu(*list++);
> +               switch(pinconf) {
> +               case RK_PINCTRL_NONE:
> +                       bias = PIN_CONFIG_BIAS_DISABLE;
> +                       break;
> +               case RK_PINCTRL_PULL_PIN_DEFAULT:
> +                       bias = PIN_CONFIG_BIAS_PULL_PIN_DEFAULT;
> +                       break;
> +               case RK_PINCTRL_PULL_UP:
> +                       bias = PIN_CONFIG_BIAS_PULL_UP;
> +                       break;
> +               case RK_PINCTRL_PULL_DOWN:
> +                       bias = PIN_CONFIG_BIAS_PULL_DOWN;
> +                       break;
> +               }
> +
> +               grp->configs[j] = pinconf_to_config_packed(bias, 0);
> +       }

I would like this to be added to
drivers/pinctrl/pinconf-generic.c
as a utility function, with the header in
drivers/pinctrl/pinconf.h

Also in a separate patch.

> +++ b/include/dt-bindings/pinctrl/rockchip.h
(...)
> +#define RK_PINCTRL_NONE                        0
> +#define RK_PINCTRL_PULL_PIN_DEFAULT    (1 << 0)
> +#define RK_PINCTRL_PULL_UP             (1 << 1)
> +#define RK_PINCTRL_PULL_DOWN           (1 << 2)

So I'd like these moved to /include/dt-bindings/pinctrl/pinconfig.h
and used as a separete include. Drop the RK_* prefix as it
will be universal and use a PINCONFIG_* prefix instead
of PINCTRL_*.

I think that is the route we need to take.

Bonus if you implement more config options from
pinconf-generic.h but otherwise me and others will have
to do it.

Yours,
Linus Walleij
