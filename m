Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686AbbAYUrm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 15:47:42 -0500
Received: from gloria.sntech.de ([95.129.55.99]:42861 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbbAYUrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 15:47:40 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: tglx@linutronix.de, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: Re: [PATCH V2] clockevents: rockchip: Add rockchip timer for rk3288
Date: Sun, 25 Jan 2015 21:52:39 +0100
Message-ID: <2285293.ZBcGIuxxDo@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <1422178979-12382-1-git-send-email-daniel.lezcano@linaro.org>
References: <1422178979-12382-1-git-send-email-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

one big request and some more style nitpicks :-)

With the nitpicks fixed
Reviewed-by: Heiko Stuebner <heiko@sntech.de>


Before applying this patch could you drop the rk3288.dtsi change please?
Instead I'd like to add the following patch separately to _my_ devicetree
branch for 3.20.

I already wasn't fast enough to prevent the ethernet controller changes
going through the network tree and would like to prevent a third tree sending
changes for the same dts area to Linus - merge conflicts and all.


I don't think that neither the nitpicks nor dropping the dtsi segment need
another submission though.


Heiko


----- 8< -----------
From: Daniel Lezcano <daniel.lezcano@linaro.org>
Date: Sun, 25 Jan 2015 10:42:59 +0100
Subject: [PATCH] ARM: dts: rockchip: Add rockchip timer node for rk3288

The rk3288 board uses the architected timers and these ones are shutdown when
the cpu is powered down. There is a need of a broadcast timer in this case to
ensure proper wakeup when the cpus are in sleep mode and a timer expires.

Add the timer node for the broadcast timer.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 arch/arm/boot/dts/rk3288.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index c7235fa..37847c1 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -149,6 +149,14 @@
 		clock-frequency = <24000000>;
 	};
 
+	timer: timer@ff810000 {
+		compatible = "rockchip,rk3288-timer";
+		reg = <0xff810000 0x20>;
+		interrupts = <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&xin24m>, <&cru PCLK_TIMER>;
+		clock-names = "timer", "pclk";
+	};
+
 	display-subsystem {
 		compatible = "rockchip,display-subsystem";
 		ports = <&vopl_out>, <&vopb_out>;
-- 
2.1.1

------- 8< -----------

Am Sonntag, 25. Januar 2015, 10:42:59 schrieb Daniel Lezcano:

[...]

> diff --git a/drivers/clocksource/rockchip_timer.c
> b/drivers/clocksource/rockchip_timer.c new file mode 100644
> index 0000000..5ea290d
> --- /dev/null
> +++ b/drivers/clocksource/rockchip_timer.c
> @@ -0,0 +1,180 @@
> +/*
> + * Rockchip timer support
> + *
> + * Copyright (C) Daniel Lezcano <daniel.lezcano@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#include <linux/clk.h>
> +#include <linux/clockchips.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/of_irq.h>
> +
> +#define TIMER_NAME "rk_timer"
> +
> +#define TIMER_LOAD_COUNT0               0x00
> +#define TIMER_LOAD_COUNT1               0x04
> +#define TIMER_CONTROL_REG               0x10
> +#define TIMER_INT_STATUS                0x18
> +
> +#define TIMER_DISABLE                   0x0
> +#define TIMER_ENABLE                    0x1
> +#define TIMER_MODE_FREE_RUNNING         (0 << 1)
> +#define TIMER_MODE_USER_DEFINED_COUNT   (1 << 1)
> +#define TIMER_INT_UNMASK                (1 << 2)

the above constants are aligned using spaces
I guess either simply use 1 space, or align using tabs?

[...]

> +static void __init rk_timer_init(struct device_node *np)
> +{
> +	struct clock_event_device *ce = &bc_timer.ce;
> +	struct clk *timer_clk;
> +	struct clk *pclk;
> +	int ret, irq;
> +
> +	bc_timer.base = of_iomap(np, 0);
> +	if (!bc_timer.base) {
> +		pr_err("Failed to get base address for '%s'\n", TIMER_NAME);
> +		return;
> +	}
> +
> +        pclk = of_clk_get_by_name(np, "pclk");
> +        if (IS_ERR(pclk)) {

the above 2 lines are indented using spaces instead of tabs

> +		pr_err("Failed to get pclk for '%s'\n", TIMER_NAME);
> +		return;
> +	}
> +
> +	if (clk_prepare_enable(pclk)) {
> +		pr_err("Failed to enable pclk for '%s'\n", TIMER_NAME);
> +		return;
> +	}
> +
> +        timer_clk = of_clk_get_by_name(np, "timer");
> +        if (IS_ERR(timer_clk)) {

same here


