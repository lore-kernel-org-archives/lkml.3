Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965983AbaLKXc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 18:32:56 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:60948 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964971AbaLKXcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 18:32:54 -0500
Message-ID: <548A29A4.7060908@hurleysoftware.com>
Date: Thu, 11 Dec 2014 18:32:52 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>, Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>, Jiri Slaby <jslaby@suse.cz>
CC: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] TTY: add slave driver to power-on device via a regulator.
References: <20141211214801.4127.93914.stgit@notabene.brown> <20141211215944.4127.4186.stgit@notabene.brown>
In-Reply-To: <20141211215944.4127.4186.stgit@notabene.brown>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2014 04:59 PM, NeilBrown wrote:
> The regulator is identified in devicetree as 'vdd-supply'
> 
> Signed-off-by: NeilBrown <neilb@suse.de>

tty_* is only for tty core functions/data.

Regards,
Peter Hurley

> ---
>  .../devicetree/bindings/serial/slave-reg.txt       |   18 ++++
>  drivers/tty/Kconfig                                |    2 
>  drivers/tty/Makefile                               |    1 
>  drivers/tty/slaves/Kconfig                         |   12 ++
>  drivers/tty/slaves/Makefile                        |    2 
>  drivers/tty/slaves/tty-reg.c                       |  102 ++++++++++++++++++++
>  6 files changed, 137 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/serial/slave-reg.txt
>  create mode 100644 drivers/tty/slaves/Kconfig
>  create mode 100644 drivers/tty/slaves/Makefile
>  create mode 100644 drivers/tty/slaves/tty-reg.c
> 
> diff --git a/Documentation/devicetree/bindings/serial/slave-reg.txt b/Documentation/devicetree/bindings/serial/slave-reg.txt
> new file mode 100644
> index 000000000000..7896bce8dfe4
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/serial/slave-reg.txt
> @@ -0,0 +1,18 @@
> +Regulator powered UART-attached device
> +
> +Required properties:
> +- compatible: "tty,regulator"
> +- vdd-supply: regulator to power the device
> +
> +
> +This is listed as a child node of a UART.  When the
> +UART is opened, the device is powered.
> +
> +Example:
> +
> +&uart1 {
> +	bluetooth {
> +		compatible = "tty,regulator";
> +		vdd-supply = <&vaux4>;
> +	};
> +};
> diff --git a/drivers/tty/Kconfig b/drivers/tty/Kconfig
> index b24aa010f68c..ea3383c71701 100644
> --- a/drivers/tty/Kconfig
> +++ b/drivers/tty/Kconfig
> @@ -419,4 +419,6 @@ config DA_CONSOLE
>  	help
>  	  This enables a console on a Dash channel.
>  
> +source drivers/tty/slaves/Kconfig
> +
>  endif # TTY
> diff --git a/drivers/tty/Makefile b/drivers/tty/Makefile
> index 58ad1c05b7f8..45957d671e33 100644
> --- a/drivers/tty/Makefile
> +++ b/drivers/tty/Makefile
> @@ -13,6 +13,7 @@ obj-$(CONFIG_R3964)		+= n_r3964.o
>  obj-y				+= vt/
>  obj-$(CONFIG_HVC_DRIVER)	+= hvc/
>  obj-y				+= serial/
> +obj-$(CONFIG_TTY_SLAVE)		+= slaves/
>  
>  # tty drivers
>  obj-$(CONFIG_AMIGA_BUILTIN_SERIAL) += amiserial.o
> diff --git a/drivers/tty/slaves/Kconfig b/drivers/tty/slaves/Kconfig
> new file mode 100644
> index 000000000000..2dd1acf80f8c
> --- /dev/null
> +++ b/drivers/tty/slaves/Kconfig
> @@ -0,0 +1,12 @@
> +menuconfig TTY_SLAVE
> +	bool "TTY slave devices"
> +	help
> +	 Devices which attach via a uart, but need extra
> +	 driver support for power management etc.
> +
> +if TTY_SLAVE
> +
> +config TTY_SLAVE_REGULATOR
> +	tristate "TTY slave device powered by regulator"
> +
> +endif
> diff --git a/drivers/tty/slaves/Makefile b/drivers/tty/slaves/Makefile
> new file mode 100644
> index 000000000000..e636bf49f1cc
> --- /dev/null
> +++ b/drivers/tty/slaves/Makefile
> @@ -0,0 +1,2 @@
> +
> +obj-$(CONFIG_TTY_SLAVE_REGULATOR) += tty-reg.o
> diff --git a/drivers/tty/slaves/tty-reg.c b/drivers/tty/slaves/tty-reg.c
> new file mode 100644
> index 000000000000..613f8b10967c
> --- /dev/null
> +++ b/drivers/tty/slaves/tty-reg.c
> @@ -0,0 +1,102 @@
> +/*
> + * tty-reg:
> + *   Support for any device which needs a regulator turned on
> + *   when a tty is opened.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/err.h>
> +#include <linux/regulator/consumer.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/tty.h>
> +
> +struct tty_reg_data {
> +	struct regulator *reg;
> +	bool	reg_enabled;
> +};
> +
> +static int tty_reg_runtime_resume(struct device *slave)
> +{
> +	struct tty_reg_data *data = dev_get_drvdata(slave);
> +	if (!data->reg_enabled &&
> +	    regulator_enable(data->reg) == 0) {
> +		dev_dbg(slave, "power on\n");
> +		data->reg_enabled = true;
> +	}
> +	return 0;
> +}
> +
> +static int tty_reg_runtime_suspend(struct device *slave)
> +{
> +	struct tty_reg_data *data = dev_get_drvdata(slave);
> +
> +	if (data->reg_enabled &&
> +	    regulator_disable(data->reg) == 0) {
> +		dev_dbg(slave, "power off\n");
> +		data->reg_enabled = false;
> +	}
> +	return 0;
> +}
> +
> +static int tty_reg_probe(struct platform_device *pdev)
> +{
> +	struct tty_reg_data *data;
> +	struct regulator *reg;
> +	int err;
> +
> +	err = -ENODEV;
> +	if (pdev->dev.parent == NULL)
> +		goto out;
> +	reg = devm_regulator_get(&pdev->dev, "vdd");
> +	err = PTR_ERR(reg);
> +	if (IS_ERR(reg))
> +		goto out;
> +
> +	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
> +	err = -ENOMEM;
> +	if (!data)
> +		goto out;
> +	data->reg = reg;
> +	data->reg_enabled = false;
> +	pm_runtime_enable(&pdev->dev);
> +	platform_set_drvdata(pdev, data);
> +	err = 0;
> +out:
> +	return err;
> +}
> +
> +static struct of_device_id tty_reg_dt_ids[] = {
> +	{ .compatible = "tty,regulator", },
> +	{}
> +};
> +
> +static const struct dev_pm_ops tty_reg_pm_ops = {
> +	SET_RUNTIME_PM_OPS(tty_reg_runtime_suspend,
> +			   tty_reg_runtime_resume, NULL)
> +};
> +
> +static struct platform_driver tty_reg_driver = {
> +	.driver.name	= "tty-regulator",
> +	.driver.owner	= THIS_MODULE,
> +	.driver.of_match_table = tty_reg_dt_ids,
> +	.driver.pm	= &tty_reg_pm_ops,
> +	.probe		= tty_reg_probe,
> +};
> +
> +static int __init tty_reg_init(void)
> +{
> +	return platform_driver_register(&tty_reg_driver);
> +}
> +module_init(tty_reg_init);
> +
> +static void __exit tty_reg_exit(void)
> +{
> +	platform_driver_unregister(&tty_reg_driver);
> +}
> +module_exit(tty_reg_exit);
> +
> +MODULE_AUTHOR("NeilBrown <neilb@suse.de>");
> +MODULE_DESCRIPTION("Serial port device which requires a regulator when open.");
> +MODULE_LICENSE("GPL v2");


