Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbaHHM20 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 08:28:26 -0400
Received: from sym2.noone.org ([178.63.92.236]:48087 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756234AbaHHM2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 08:28:24 -0400
Date: Fri, 8 Aug 2014 14:28:20 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: linux-kernel@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org,
        gregkh@linuxfoundation.org, jslaby@suse.cz, grant.likely@linaro.org,
        alan@linux.intel.com, varkabhadram@gmail.com, heiko@sntech.de,
        yingjoe.chen@gmail.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH v3 1/2] tty: serial: 8250: Add Mediatek UART driver
Message-ID: <20140808122820.GF29832@distanz.ch>
References: <1407497524-26535-1-git-send-email-matthias.bgg@gmail.com>
 <1407497524-26535-2-git-send-email-matthias.bgg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407497524-26535-2-git-send-email-matthias.bgg@gmail.com>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-08-08 at 13:32:03 +0200, Matthias Brugger <matthias.bgg@gmail.com> wrote:
> This patch adds support for the UART block found on Mediatek SoCs.
> The device has a highspeed register which influences the calcualtion of the
> divisor. The chip lacks support for some baudrates. When requested, we set the
> divisor to the next smaller baudrate and adjust the c_cflag accordingly.
> 
> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
> ---
>  drivers/tty/serial/8250/8250_mtk.c |  296 ++++++++++++++++++++++++++++++++++++
>  drivers/tty/serial/8250/Kconfig    |    7 +
>  drivers/tty/serial/8250/Makefile   |    1 +
>  3 files changed, 304 insertions(+)
>  create mode 100644 drivers/tty/serial/8250/8250_mtk.c
> 
> diff --git a/drivers/tty/serial/8250/8250_mtk.c b/drivers/tty/serial/8250/8250_mtk.c
> new file mode 100644
> index 0000000..d63080b
> --- /dev/null
> +++ b/drivers/tty/serial/8250/8250_mtk.c
> @@ -0,0 +1,296 @@

[...]

> +static int mtk8250_probe(struct platform_device *pdev)
> +{
> +	struct uart_8250_port uart = {};
> +	struct resource *regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	struct resource *irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +	struct mtk8250_data *data;
> +	int err;
> +
> +	if (!regs || !irq) {
> +		dev_err(&pdev->dev, "no registers/irq defined\n");
> +		return -EINVAL;
> +	}
> +
> +	spin_lock_init(&uart.port.lock);
> +	uart.port.mapbase = regs->start;
> +	uart.port.irq = irq->start;
> +	uart.port.pm = mtk8250_do_pm;
> +	uart.port.type = PORT_16550;
> +	uart.port.flags = UPF_BOOT_AUTOCONF | UPF_FIXED_PORT;
> +	uart.port.dev = &pdev->dev;
> +
> +	uart.port.membase = devm_ioremap(&pdev->dev, regs->start,
> +					 resource_size(regs));
> +	if (!uart.port.membase)
> +		return -ENOMEM;

You can use devm_ioremap_resource here and get rid of the check for
!regs above, since devm_ioremap_resource already does that.

	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);

	...

	uart.port.membase = devm_ioremap_resource(&pdev->dev, regs);
	if (IS_ERR(uart.port.membase))
		return PTR_ERR(uart.port.membase);

> +
> +	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;

I'd suggest to move this kzalloc and the ioremap before the uart.port
initialization part above, so you can error out early in case of any
failure.

> +
> +	uart.port.iotype = UPIO_MEM32;
> +	uart.port.regshift = 2;
> +	uart.port.private_data = data;
> +	uart.port.set_termios = mtk8250_set_termios;
> +
> +	if (pdev->dev.of_node) {
> +		err = mtk8250_probe_of(&uart.port, data);
> +		if (err)
> +			return err;
> +	} else
> +		return -ENODEV;

This could also be moved up, directly below devm_kzalloc.

> +
> +	/* Disable Rate Fix function */
> +	writel(0x0, uart.port.membase +
> +			(MTK_UART_RATE_FIX << uart.port.regshift));
> +
> +	data->line = serial8250_register_8250_port(&uart);
> +	if (data->line < 0)
> +		return data->line;
> +
> +	platform_set_drvdata(pdev, data);
> +
> +	pm_runtime_set_active(&pdev->dev);
> +	pm_runtime_enable(&pdev->dev);
> +
> +	return 0;
> +}
> +
> +static int mtk8250_remove(struct platform_device *pdev)
> +{
> +	struct mtk8250_data *data = platform_get_drvdata(pdev);
> +
> +	pm_runtime_get_sync(&pdev->dev);
> +
> +	serial8250_unregister_port(data->line);
> +	if (!IS_ERR(data->clk)) {
> +		clk_disable_unprepare(data->clk);
> +		clk_put(data->clk);
> +	}
> +
> +	pm_runtime_disable(&pdev->dev);
> +	pm_runtime_put_noidle(&pdev->dev);
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int mtk8250_suspend(struct device *dev)
> +{
> +	struct mtk8250_data *data = dev_get_drvdata(dev);
> +
> +	serial8250_suspend_port(data->line);
> +
> +	return 0;
> +}
> +
> +static int mtk8250_resume(struct device *dev)
> +{
> +	struct mtk8250_data *data = dev_get_drvdata(dev);
> +
> +	serial8250_resume_port(data->line);
> +
> +	return 0;
> +}
> +#endif /* CONFIG_PM_SLEEP */
> +
> +#ifdef CONFIG_PM_RUNTIME
> +static int mtk8250_runtime_suspend(struct device *dev)
> +{
> +	struct mtk8250_data *data = dev_get_drvdata(dev);
> +
> +	if (!IS_ERR(data->clk))
> +		clk_disable_unprepare(data->clk);
> +
> +	return 0;
> +}
> +
> +static int mtk8250_runtime_resume(struct device *dev)
> +{
> +	struct mtk8250_data *data = dev_get_drvdata(dev);
> +
> +	if (!IS_ERR(data->clk))
> +		clk_prepare_enable(data->clk);
> +
> +	return 0;
> +}
> +#endif
> +
> +static const struct dev_pm_ops mtk8250_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(mtk8250_suspend, mtk8250_resume)
> +	SET_RUNTIME_PM_OPS(mtk8250_runtime_suspend, mtk8250_runtime_resume,
> +				NULL)
> +};
> +
> +static const struct of_device_id mtk8250_of_match[] = {
> +	{ .compatible = "mediatek,mt6577-uart" },
> +	{ /* Sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, mtk8250_of_match);
> +
> +static struct platform_driver mtk8250_platform_driver = {
> +	.driver = {
> +		.name		= "mt6577-uart",
> +		.owner		= THIS_MODULE,

This doesn't need to be set here,
module_platform_driver/platform_driver_register take care of setting it.

> +		.pm		= &mtk8250_pm_ops,
> +		.of_match_table	= mtk8250_of_match,
> +	},
> +	.probe			= mtk8250_probe,
> +	.remove			= mtk8250_remove,
> +};
> +module_platform_driver(mtk8250_platform_driver);
> +
> +MODULE_AUTHOR("Matthias Brugger");
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("Mediatek 8250 serial port driver");
