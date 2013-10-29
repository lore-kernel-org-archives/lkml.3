Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962Ab3J2PDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 11:03:19 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:54878 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977Ab3J2PDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 11:03:17 -0400
Message-ID: <1383058923.2837.33.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [PATCH v3 02/10] spmi: Linux driver framework for SPMI
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org, Gilad Avidov <gavidov@codeaurora.org>,
        linux-kernel@vger.kernel.org, Michael Bohan <mbohan@codeaurora.org>,
        Sagar Dharia <sdharia@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Date: Tue, 29 Oct 2013 17:02:03 +0200
In-Reply-To: <149bbfe89e37376cc176c3aeb6c1fab9e4fd2b91.1382985169.git.joshc@codeaurora.org>
References: <cover.1382985169.git.joshc@codeaurora.org>
	 <149bbfe89e37376cc176c3aeb6c1fab9e4fd2b91.1382985169.git.joshc@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Josh,

On Mon, 2013-10-28 at 13:12 -0500, Josh Cartwright wrote: 
> From: Kenneth Heitke <kheitke@codeaurora.org>
> 
> System Power Management Interface (SPMI) is a specification
> developed by the MIPI (Mobile Industry Process Interface) Alliance
> optimized for the real time control of Power Management ICs (PMIC).
> 
> SPMI is a two-wire serial interface that supports up to 4 master
> devices and up to 16 logical slaves.
> 
> The framework supports message APIs, multiple busses (1 controller
> per bus) and multiple clients/slave devices per controller.
> 
> Signed-off-by: Kenneth Heitke <kheitke@codeaurora.org>
> Signed-off-by: Michael Bohan <mbohan@codeaurora.org>
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> ---
>  drivers/Kconfig                 |   2 +
>  drivers/Makefile                |   1 +
>  drivers/spmi/Kconfig            |   9 +
>  drivers/spmi/Makefile           |   4 +
>  drivers/spmi/spmi.c             | 491 ++++++++++++++++++++++++++++++++++++++++
>  include/dt-bindings/spmi/spmi.h |  18 ++
>  include/linux/mod_devicetable.h |   8 +
>  include/linux/spmi.h            | 342 ++++++++++++++++++++++++++++
>  8 files changed, 875 insertions(+)
>  create mode 100644 drivers/spmi/Kconfig
>  create mode 100644 drivers/spmi/Makefile
>  create mode 100644 drivers/spmi/spmi.c
>  create mode 100644 include/dt-bindings/spmi/spmi.h
>  create mode 100644 include/linux/spmi.h
> 

<snip>

> +#ifdef CONFIG_PM_SLEEP
> +static int spmi_pm_suspend(struct device *dev)
> +{
> +	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;

This is what pm_generic_suspend() do. Do we really need this wrapper?

> +
> +	if (pm)
> +		return pm_generic_suspend(dev);
> +	else
> +		return 0;
> +}
> +
> +static int spmi_pm_resume(struct device *dev)
> +{
> +	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
> +
> +	if (pm)
> +		return pm_generic_resume(dev);
> +	else
> +		return 0;
> +}
> +#else
> +#define spmi_pm_suspend		NULL
> +#define spmi_pm_resume		NULL
> +#endif
> +
> +static const struct dev_pm_ops spmi_pm_ops = {
> +	.suspend	= spmi_pm_suspend,
> +	.resume		= spmi_pm_resume,
> +	SET_RUNTIME_PM_OPS(
> +		pm_generic_suspend,
> +		pm_generic_resume,
> +		pm_generic_runtime_idle
> +	)
> +};
> +

<snip>

> +
> +static int spmi_drv_probe(struct device *dev)
> +{
> +	const struct spmi_driver *sdrv = to_spmi_driver(dev->driver);
> +	int err = 0;
> +
> +	if (sdrv->probe)
> +		err = sdrv->probe(to_spmi_device(dev));
> +
> +	return err;
> +}
> +
> +static int spmi_drv_remove(struct device *dev)
> +{
> +	const struct spmi_driver *sdrv = to_spmi_driver(dev->driver);
> +	int err = 0;
> +
> +	if (sdrv->remove)
> +		err = sdrv->remove(to_spmi_device(dev));
> +
> +	return err;
> +}
> +
> +static void spmi_drv_shutdown(struct device *dev)
> +{
> +	const struct spmi_driver *sdrv = to_spmi_driver(dev->driver);
> +
> +	if (sdrv->shutdown)

If driver for device is not loaded this will cause kernel NULL
pointer dereference.

> +		sdrv->shutdown(to_spmi_device(dev));
> +}
> +
> +static struct bus_type spmi_bus_type = {
> +	.name		= "spmi",
> +	.match		= spmi_device_match,
> +	.pm		= &spmi_pm_ops,
> +	.probe		= spmi_drv_probe,
> +	.remove		= spmi_drv_remove,
> +	.shutdown	= spmi_drv_shutdown,
> +};
> +

<snip>

> +
> +static int of_spmi_register_devices(struct spmi_controller *ctrl)
> +{
> +	struct device_node *node;
> +	int err;
> +
> +	dev_dbg(&ctrl->dev, "of_spmi_register_devices\n");
> +
> +	if (!ctrl->dev.of_node)
> +		return -ENODEV;
> +
> +	dev_dbg(&ctrl->dev, "looping through children\n");
> +
> +	for_each_available_child_of_node(ctrl->dev.of_node, node) {
> +		struct spmi_device *sdev;
> +		u32 reg[2];
> +
> +		dev_dbg(&ctrl->dev, "adding child %s\n", node->full_name);
> +
> +		err = of_property_read_u32_array(node, "reg", reg, 2);
> +		if (err) {
> +			dev_err(&ctrl->dev,
> +				"node %s does not have 'reg' property\n",
> +				node->full_name);
> +			continue;

Shouldn't this be a fatal error?

> +		}
> +
> +		if (reg[1] != SPMI_USID) {
> +			dev_err(&ctrl->dev,
> +				"node %s contains unsupported 'reg' entry\n",
> +				node->full_name);
> +			continue;
> +		}
> +
> +		if (reg[0] > 0xF) {
> +			dev_err(&ctrl->dev,
> +				"invalid usid on node %s\n",
> +				node->full_name);
> +			continue;
> +		}
> +
> +		dev_dbg(&ctrl->dev, "read usid %02x\n", reg[0]);
> +
> +		sdev = spmi_device_alloc(ctrl);
> +		if (!sdev)
> +			continue;
> +
> +		sdev->dev.of_node = node;
> +		sdev->usid = (u8) reg[0];
> +
> +		err = spmi_device_add(sdev);
> +		if (err) {
> +			dev_err(&sdev->dev,
> +				"failure adding device. status %d\n", err);
> +			spmi_device_put(sdev);
> +			continue;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +int spmi_controller_add(struct spmi_controller *ctrl)
> +{
> +	int ret;
> +
> +	/* Can't register until after driver model init */
> +	if (WARN_ON(!spmi_bus_type.p))
> +		return -EAGAIN;
> +
> +	ret = device_add(&ctrl->dev);
> +	if (ret)
> +		return ret;
> +
> +	if (IS_ENABLED(CONFIG_OF))
> +		of_spmi_register_devices(ctrl);

Check for error code here?

> +
> +	dev_dbg(&ctrl->dev, "spmi-%d registered: dev:%p\n",
> +		ctrl->nr, &ctrl->dev);
> +
> +	return 0;
> +};
> +EXPORT_SYMBOL_GPL(spmi_controller_add);
> +


Regards,
Ivan

