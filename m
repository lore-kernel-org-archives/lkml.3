Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760853Ab3LIIi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 03:38:26 -0500
Received: from mga02.intel.com ([134.134.136.20]:15406 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754336Ab3LIIiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 03:38:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,856,1378882800"; 
   d="scan'208";a="449060849"
Date: Mon, 9 Dec 2013 10:38:15 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Sergei Ianovich <ynvich@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Cameron <quozl@laptop.org>,
        Russell King <linux@arm.linux.org.uk>, Jiri Slaby <jslaby@suse.cz>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Zhou Zhu <zzhu3@marvell.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Stefan Seyfried <seife+kernel@b1-systems.com>,
        John Crispin <blogic@openwrt.org>, Paul Bolle <pebolle@tiscali.nl>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2] serial: rewrite pxa2xx-uart to use 8250_core
Message-ID: <20131209083815.GA5231@xps8300>
References: <1386286149-2855-1-git-send-email-ynvich@gmail.com>
 <1386321003-8960-1-git-send-email-ynvich@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386321003-8960-1-git-send-email-ynvich@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Dec 06, 2013 at 01:09:31PM +0400, Sergei Ianovich wrote:
> pxa2xx-uart was a separate uart platform driver. It was declaring
> the same device names and numbers as 8250 driver. As a result,
> it was impossible to use 8250 driver on PXA SoCs.
> 
> Upon closer examination pxa2xx-uart turned out to be a clone of
> 8250_core driver.
> 
> Workaround for Erratum #19 according to Marvel(R) PXA270M Processor
> Specification Update (April 19, 2010) is dropped. 8250_core reads
> from FIFO immediately after checking DR bit in LSR.
> 
> Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
> CC: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CC: James Cameron <quozl@laptop.org>
> ---
>  changes v1..v2
>  * actually implement workaround for E74 in dl_write as spooted
>    by James Cameron
>  * added comment about E19 in commit message

Nice job Sergei! I have a few minor nitpicks below, but if they are
the only comments, don't bother with v3. I'm fine with this. For what
it's worth:

Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

>  arch/arm/configs/am200epdkit_defconfig    |   3 +-
>  arch/arm/configs/cm_x2xx_defconfig        |   3 +-
>  arch/arm/configs/cm_x300_defconfig        |   3 +-
>  arch/arm/configs/colibri_pxa270_defconfig |   3 +-
>  arch/arm/configs/colibri_pxa300_defconfig |   3 +-
>  arch/arm/configs/corgi_defconfig          |   4 +-
>  arch/arm/configs/em_x270_defconfig        |   3 +-
>  arch/arm/configs/ezx_defconfig            |   3 +-
>  arch/arm/configs/h5000_defconfig          |   3 +-
>  arch/arm/configs/imote2_defconfig         |   3 +-
>  arch/arm/configs/lpd270_defconfig         |   3 +-
>  arch/arm/configs/lubbock_defconfig        |   3 +-
>  arch/arm/configs/mainstone_defconfig      |   3 +-
>  arch/arm/configs/mmp2_defconfig           |   3 +-
>  arch/arm/configs/pcm027_defconfig         |   3 +-
>  arch/arm/configs/pxa168_defconfig         |   3 +-
>  arch/arm/configs/pxa255-idp_defconfig     |   3 +-
>  arch/arm/configs/pxa3xx_defconfig         |   3 +-
>  arch/arm/configs/pxa910_defconfig         |   3 +-
>  arch/arm/configs/raumfeld_defconfig       |   3 +-
>  arch/arm/configs/spitz_defconfig          |   4 +-
>  arch/arm/configs/trizeps4_defconfig       |   3 +-
>  arch/arm/configs/viper_defconfig          |   4 +-
>  arch/arm/configs/xcep_defconfig           |   3 +-
>  drivers/tty/serial/8250/8250_pxa.c        | 189 ++++++
>  drivers/tty/serial/8250/Kconfig           |   9 +
>  drivers/tty/serial/8250/Makefile          |   1 +
>  drivers/tty/serial/Kconfig                |  23 -
>  drivers/tty/serial/Makefile               |   1 -
>  drivers/tty/serial/pxa.c                  | 971 ------------------------------
>  30 files changed, 247 insertions(+), 1022 deletions(-)
>  create mode 100644 drivers/tty/serial/8250/8250_pxa.c
>  delete mode 100644 drivers/tty/serial/pxa.c

<snip>

> diff --git a/drivers/tty/serial/8250/8250_pxa.c b/drivers/tty/serial/8250/8250_pxa.c
> new file mode 100644
> index 0000000..88ae73c
> --- /dev/null
> +++ b/drivers/tty/serial/8250/8250_pxa.c
> @@ -0,0 +1,189 @@
> +/*
> + *  drivers/tty/serial/8250/8250_pxa.c -- driver for PXA on-board UARTS
> + *  Copyright:	(C) 2013 Sergei Ianovich <ynvich@gmail.com>
> + *
> + *  replaces drivers/serial/pxa.c by Nicolas Pitre
> + *  Created:	Feb 20, 2003
> + *  Copyright:	(C) 2003 Monta Vista Software, Inc.
> + *
> + *  Based on drivers/serial/8250.c by Russell King.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + */
> +
> +#include <linux/device.h>
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/serial_8250.h>
> +#include <linux/serial_core.h>
> +#include <linux/serial_reg.h>
> +#include <linux/of.h>
> +#include <linux/of_irq.h>
> +#include <linux/of_platform.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/clk.h>
> +#include <linux/pm_runtime.h>
> +
> +#include "8250.h"
> +
> +struct pxa8250_data {
> +	int			line;
> +	struct clk		*clk;
> +};
> +
> +#ifdef CONFIG_PM
> +static int serial_pxa_suspend(struct device *dev)
> +{
> +	struct pxa8250_data *data = dev_get_drvdata(dev);
> +
> +	serial8250_suspend_port(data->line);
> +
> +	return 0;
> +}
> +
> +static int serial_pxa_resume(struct device *dev)
> +{
> +	struct pxa8250_data *data = dev_get_drvdata(dev);
> +
> +	serial8250_resume_port(data->line);
> +
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops serial_pxa_pm_ops = {
> +	.suspend	= serial_pxa_suspend,
> +	.resume		= serial_pxa_resume,
> +};

If you leave this structure outside the ifdef CONFIG_PM and use
SET_SYSTEM_SLEEP_PM_OPS() macro, you don't need the ifdef when you set
the driver pm ops below.

> +#endif
> +
> +static struct of_device_id serial_pxa_dt_ids[] = {
> +	{ .compatible = "mrvl,pxa-uart", },
> +	{ .compatible = "mrvl,mmp-uart", },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(of, serial_pxa_dt_ids);
> +
> +/* Uart divisor latch write */
> +static void serial_pxa_dl_write(struct uart_8250_port *up, int value)
> +{
> +	unsigned int dll;
> +
> +	serial_out(up, UART_DLL, value & 0xff);
> +	/*
> +	 * work around Erratum #74 according to Marvel(R) PXA270M Processor
> +	 * Specification Update (April 19, 2010)
> +	 */
> +	dll = serial_in(up, UART_DLL);
> +	WARN_ON(dll != (value & 0xff));
> +
> +	serial_out(up, UART_DLM, value >> 8 & 0xff);
> +}
> +
> +
> +static void serial_pxa_pm(struct uart_port *port, unsigned int state,
> +	      unsigned int oldstate)
> +{
> +	struct pxa8250_data *data = port->private_data;
> +
> +	if (!state)
> +		clk_prepare_enable(data->clk);
> +	else
> +		clk_disable_unprepare(data->clk);
> +}
> +
> +static int serial_pxa_probe(struct platform_device *pdev)
> +{
> +	struct uart_8250_port uart = {};
> +	struct pxa8250_data *data;
> +	struct resource *mmres, *irqres;
> +	int ret;
> +
> +	mmres = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	irqres = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +	if (!mmres || !irqres)
> +		return -ENODEV;
> +
> +	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	data->clk = devm_clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(data->clk)) {
> +		ret = PTR_ERR(data->clk);
> +		goto err_free;

You can just return here.

> +	}
> +
> +	ret = clk_prepare(data->clk);
> +	if (ret)
> +		goto err_free_clk;

ditto

> +	uart.port.type = PORT_XSCALE;
> +	uart.port.iotype = UPIO_MEM32;
> +	uart.port.mapbase = mmres->start;
> +	uart.port.regshift = 2;
> +	uart.port.irq = irqres->start;
> +	uart.port.fifosize = 64;
> +	uart.port.flags = UPF_IOREMAP | UPF_SKIP_TEST;
> +	uart.port.dev = &pdev->dev;
> +	uart.port.uartclk = clk_get_rate(data->clk);
> +	uart.port.pm = serial_pxa_pm;
> +	uart.port.private_data = data;
> +	uart.dl_write = serial_pxa_dl_write;
> +
> +	ret = serial8250_register_8250_port(&uart);
> +	if (ret < 0)
> +		goto err_clk;
> +
> +	data->line = ret;
> +
> +	platform_set_drvdata(pdev, data);
> +
> +	return 0;
> +
> + err_clk:
> +	clk_unprepare(data->clk);
> + err_free_clk:
> +	devm_clk_put(&pdev->dev, data->clk);
> + err_free:
> +	devm_kfree(&pdev->dev, data);

And there labels could be dropped.

> +	return ret;
> +}
> +
> +static int serial_pxa_remove(struct platform_device *pdev)
> +{
> +	struct pxa8250_data *data = platform_get_drvdata(pdev);
> +
> +	serial8250_unregister_port(data->line);
> +
> +	clk_unprepare(data->clk);
> +	devm_clk_put(&pdev->dev, data->clk);
> +	devm_kfree(&pdev->dev, data);

You also don't need to call these resource freeing functions here.

> +	return 0;
> +}
> +
> +static struct platform_driver serial_pxa_driver = {
> +	.probe          = serial_pxa_probe,
> +	.remove         = serial_pxa_remove,
> +
> +	.driver		= {
> +		.name	= "pxa2xx-uart",
> +		.owner	= THIS_MODULE,
> +#ifdef CONFIG_PM
> +		.pm	= &serial_pxa_pm_ops,
> +#endif
> +		.of_match_table = serial_pxa_dt_ids,
> +	},
> +};
> +
> +module_platform_driver(serial_pxa_driver);
> +
> +MODULE_AUTHOR("Sergei Ianovich");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:pxa2xx-uart");


Thanks,

-- 
heikki
