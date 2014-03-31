Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751204AbaCaUEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 16:04:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48388 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbaCaUEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 16:04:01 -0400
Date: Mon, 31 Mar 2014 13:06:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, mturquette@linaro.org,
        linux@arm.linux.org.uk, robh+dt@kernel.org, grant.likely@linaro.org,
        mark.rutland@arm.com, galak@codeaurora.org, kyungmin.park@samsung.com,
        sw0312.kim@samsung.com, m.szyprowski@samsung.com, t.figa@samsung.com,
        laurent.pinchart@ideasonboard.com, s.hauer@pengutronix.de
Subject: Re: [PATCH RFC v4 2/2] clk: Add handling of clk parent and rate
 assigned from DT
Message-ID: <20140331200620.GA13881@kroah.com>
References: <1396284116-19178-1-git-send-email-s.nawrocki@samsung.com>
 <1396284116-19178-3-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396284116-19178-3-git-send-email-s.nawrocki@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 06:41:56PM +0200, Sylwester Nawrocki wrote:
> This function adds a helper function to configure clock parents and rates
> as specified in clock-parents, clock-rates DT properties for a consumer
> device and a call to it before driver is bound to a device.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> ---
> Changes since v3:
>  - added detailed description of the assigned-clocks subnode,
>  - clk-conf.c is now excluded when CONFIG_OF is not set,
>  - s/of_clk_device_setup/of_clk_device_init,
>  - added missing 'static inline' to the function stub definition.
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
>  .../devicetree/bindings/clock/clock-bindings.txt   |   42 ++++++++++
>  drivers/base/dd.c                                  |    7 ++
>  drivers/clk/Makefile                               |    3 +
>  drivers/clk/clk-conf.c                             |   87 ++++++++++++++++++++
>  drivers/clk/clk.c                                  |   10 ++-
>  include/linux/clk/clk-conf.h                       |   19 +++++
>  6 files changed, 167 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/clk/clk-conf.c
>  create mode 100644 include/linux/clk/clk-conf.h
> 
> diff --git a/Documentation/devicetree/bindings/clock/clock-bindings.txt b/Documentation/devicetree/bindings/clock/clock-bindings.txt
> index 700e7aa..59fbb4e 100644
> --- a/Documentation/devicetree/bindings/clock/clock-bindings.txt
> +++ b/Documentation/devicetree/bindings/clock/clock-bindings.txt
> @@ -132,3 +132,45 @@ clock signal, and a UART.
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
> +    };
> +
> +In this example the pll is set as parent of "mux" clock and frequency of "baud"
> +clock is specified as 460800 Hz.
> +
> +Configuring a clock parent and rate through the device node that uses
> +the clock can be done only for clocks that have a single user. Specifying
> +conflicting parent or rate configuration in multiple consumer nodes for
> +a shared clock is forbidden.
> +
> +Configuration of common clocks, which affect multiple consumer devices
> +can be specified in a dedicated 'assigned-clocks' subnode of a clock
> +provider node, e.g.:
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
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 0605176..4c633e7 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -25,6 +25,7 @@
>  #include <linux/async.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/pinctrl/devinfo.h>
> +#include <linux/clk/clk-conf.h>
> 
>  #include "base.h"
>  #include "power/power.h"
> @@ -278,6 +279,12 @@ static int really_probe(struct device *dev, struct device_driver *drv)
>  	if (ret)
>  		goto probe_failed;
> 
> +	if (dev->of_node) {
> +		ret = of_clk_device_init(dev->of_node);
> +		if (ret)
> +			goto probe_failed;
> +	}
> +
>  	if (driver_sysfs_add(dev)) {
>  		printk(KERN_ERR "%s: driver_sysfs_add(%s) failed\n",
>  			__func__, dev_name(dev));


I don't understand why you need the driver core to initialize this one
type of thing?  That should be in a driver, or in a class, or at worse
case, the platform code.

What makes clocks so "unique" here?

greg k-h
