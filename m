Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030264AbaDJQEP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 12:04:15 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:63543 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965535AbaDJQEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 12:04:08 -0400
MIME-Version: 1.0
In-Reply-To: <1397042790-10636-3-git-send-email-s.nawrocki@samsung.com>
References: <1397042790-10636-1-git-send-email-s.nawrocki@samsung.com>
	<1397042790-10636-3-git-send-email-s.nawrocki@samsung.com>
Date: Thu, 10 Apr 2014 11:04:07 -0500
Message-ID: <CAL_JsqKDJ_yFxFYnrTtmzMPoxO2rmypiujybwbhUh35y1LS-Mw@mail.gmail.com>
Subject: Re: [PATCH RFC v5 2/2] clk: Add handling of clk parent and rate
 assigned from DT
From: Rob Herring <robherring2@gmail.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tero Kristo <t-kristo@ti.com>, sw0312.kim@samsung.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 9, 2014 at 6:26 AM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> This patch adds a helper function to configure clock parents and
> rates as specified in clock-parents, clock-rates DT properties
> for a consumer device and a call to it before driver is bound to
> a device.
>
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> ---
> Changes since v4:
>  - added note explaining how to skip setting parent and rate
>    of a clock,
>  - moved of_clk_dev_init() calls to the platform bus,
>  - added missing call to of_node_put(),
>  - dropped debug traces.
>
> Changes since v3:
>  - added detailed description of the assigned-clocks subnode,
>  - added missing 'static inline' to the function stub definition,
>  - clk-conf.c is now excluded when CONFIG_OF is not set,
>  - s/of_clk_device_setup/of_clk_device_init.
>
> Changes since v2:
>  - edited in clock-bindings.txt, added note about 'assigned-clocks'
>    subnode which may be used to specify "global" clocks configuration
>    at a clock provider node,
>  - moved of_clk_device_setup() function declaration from clk-provider.h
>    to clk-conf.h so required function stubs are available when
>    CONFIG_COMMON_CLK is not enabled,
>
> Changes since v1:
>  - the helper function to parse and set assigned clock parents and
>    rates made public so it is available to clock providers to call
>    directly;
>  - dropped the platform bus notification and call of_clk_device_setup()
>    is is now called from the driver core, rather than from the
>    notification callback;
>  - s/of_clk_get_list_entry/of_clk_get_by_property.
> ---
>  .../devicetree/bindings/clock/clock-bindings.txt   |   44 ++++++++++
>  drivers/base/platform.c                            |    5 ++
>  drivers/clk/Makefile                               |    3 +
>  drivers/clk/clk-conf.c                             |   85 ++++++++++++++++++++
>  drivers/clk/clk.c                                  |   12 ++-
>  include/linux/clk/clk-conf.h                       |   19 +++++
>  6 files changed, 167 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/clk/clk-conf.c
>  create mode 100644 include/linux/clk/clk-conf.h
>
> diff --git a/Documentation/devicetree/bindings/clock/clock-bindings.txt b/Documentation/devicetree/bindings/clock/clock-bindings.txt
> index 700e7aa..93513fc 100644
> --- a/Documentation/devicetree/bindings/clock/clock-bindings.txt
> +++ b/Documentation/devicetree/bindings/clock/clock-bindings.txt
> @@ -132,3 +132,47 @@ clock signal, and a UART.
>    ("pll" and "pll-switched").
>  * The UART has its baud clock connected the external oscillator and its
>    register clock connected to the PLL clock (the "pll-switched" signal)
> +
> +==Assigned clock parents and rates==
> +
> +Some platforms require static initial configuration of parts of the clocks
> +controller. Such a configuration can be specified in a clock consumer node
> +through clock-parents and clock-rates DT properties. The former should
> +contain a list of parent clocks in form of phandle and clock specifier pairs,
> +the latter the list of assigned clock frequency values (one cell each).
> +To skip setting parent or rate of a clock its corresponding entry should be
> +set to 0, or can be omitted if it is not followed by any non-zero entry.
> +
> +    uart@a000 {
> +        compatible = "fsl,imx-uart";
> +        reg = <0xa000 0x1000>;
> +        ...
> +        clocks = <&clkcon 0>, <&clkcon 3>;
> +        clock-names = "baud", "mux";
> +
> +        clock-parents = <0>, <&pll 1>;
> +        clock-rates = <460800>;

Is this the input frequency or serial baud rate? Looks like a baud
rate, but the clock framework needs input (to the uart) frequency. I
would say this should be clock-frequency and specify the max baud rate
as is being done with i2c bindings. The uart driver should know how to
convert between input clock freq and baud rate.

> +    };
> +
> +In this example the pll is set as parent of "mux" clock and frequency of "baud"
> +clock is specified as 460800 Hz.

I don't really like clock-parents. The parent information is part of
the clock source, not the consumer.

We've somewhat decided against having every single clock defined in DT
and rather only describe a clock controller with leaf clocks to
devices. That is not a hard rule, but for complex clock trees that is
the norm. Doing something like this will require all levels of the
clock tree to be described. You may have multiple layers of parents
that have to be configured correctly. How are you configuring the rest
of the tree?

> +
> +Configuring a clock's parent and rate through the device node that uses
> +the clock can be done only for clocks that have a single user. Specifying
> +conflicting parent or rate configuration in multiple consumer nodes for
> +a shared clock is forbidden.
> +
> +Configuration of common clocks, which affect multiple consumer devices
> +can be specified in a dedicated 'assigned-clocks' subnode of a clock
> +provider node, e.g.:

This seems like a work-around due to having clock-parents in the
consumer node. If (I'm not convinced we should) we have a binding for
parent config, it needs to be a single binding that works for both
cases.

> +
> +    clkcon {
> +        ...
> +        #clock-cells = <1>;
> +
> +        assigned-clocks {
> +            clocks = <&clkcon 16>, <&clkcon 17>;
> +            clock-parents = <0>, <&clkcon 1>;
> +            clock-rates = <200000>;
> +        };
> +    };

Rob
