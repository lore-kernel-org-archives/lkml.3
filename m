Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031132AbaLLRqv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 12:46:51 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54115 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030970AbaLLRqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 12:46:49 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 1/3] TTY: add support for "tty slave" devices.
To: NeilBrown <neilb@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>, Jiri Slaby <jslaby@suse.cz>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20141211215943.4127.24792.stgit@notabene.brown>
References: <20141211214801.4127.93914.stgit@notabene.brown>
	<20141211215943.4127.24792.stgit@notabene.brown>
Date: Fri, 12 Dec 2014 11:59:20 +0000
Message-Id: <20141212115920.4277AC408F1@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Dec 2014 08:59:44 +1100
, NeilBrown <neilb@suse.de>
 wrote:
> A "tty slave" is a device connected via UART.
> It may need a driver to, for example, power the device on
> when the tty is opened, and power it off when the tty
> is released.

Some nit picking below, mostly about avoiding nasty surprises on devices
that may already have child nodes below the tty node.

> 
> A "tty slave" is a platform device which is declared as a
> child of the uart in device-tree:

As far as the binding is concerned, talking about platform devices isn't
relevant. That's an implementation detail. They are just devices.

Using a platform device is somewhat problematic for the kernel because
the DT could specify pretty much *any* platform device compatible value
here and the kernel will happily bind a driver to it. I strongly
recommend a separate bus type so that the pool of drivers remains
separate. It would be a good time to look at platform_bus_type and see
if more of it can be generalized so that subsystems can have custom bus
types without very much code at all.

> 
> &uart1 {
> 	bluetooth {
> 		compatible = "tty,regulator";
> 		vdd-supply = <&vaux4>;
> 	};

The example here isn't great. The compatible value should specify the
specific device, not a generic "tty,regulator" type binding. The
expectation is the driver understands the attachment and understands how
to do PM on the device.

> };
> 
> runtime power management is used to power-up the device
> on tty_open() and  power-down on tty_release().

What about devices that need to stay powered up even if the tty is not
opened? The runtime PM model needs to be better described for tty slaves.

> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>  .../devicetree/bindings/serial/of-serial.txt       |    4 ++++
>  drivers/tty/tty_io.c                               |   22 ++++++++++++++++++++
>  2 files changed, 26 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/serial/of-serial.txt b/Documentation/devicetree/bindings/serial/of-serial.txt
> index 8c4fd0332028..b59501ee2f21 100644
> --- a/Documentation/devicetree/bindings/serial/of-serial.txt
> +++ b/Documentation/devicetree/bindings/serial/of-serial.txt
> @@ -39,6 +39,10 @@ Optional properties:
>    driver is allowed to detect support for the capability even without this
>    property.
>  
> +Optional child node:
> +- a platform device listed as a child node will be probed and
> +  powered-on whenever the tty is in use (open).
> +

The biggest concern I have is what happens to nodes that already have
child devices that /don't/ match this use case? It is possible that some
UART nodes already have a child node used to store other data. There are
two ways to handle this; 1) add a new bool property that indicates the
child nodes are tty slave devices, or 2) Make each uart driver
explicitly enable the feature so that driver authors can check if it is
a problem for that device. I personally would suggest #1 because then it
can be enabled in generic code.

>  Example:
>  
>  	uart@80230000 {
> diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
> index 0508a1d8e4cd..7acdc6f093f4 100644
> --- a/drivers/tty/tty_io.c
> +++ b/drivers/tty/tty_io.c
> @@ -95,6 +95,8 @@
>  #include <linux/seq_file.h>
>  #include <linux/serial.h>
>  #include <linux/ratelimit.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/of_platform.h>
>  
>  #include <linux/uaccess.h>
>  
> @@ -1683,6 +1685,17 @@ static int tty_release_checks(struct tty_struct *tty, struct tty_struct *o_tty,
>  	return 0;
>  }
>  
> +static int open_child(struct device *dev, void *data)
> +{
> +	pm_runtime_get_sync(dev);
> +	return 0;
> +}
> +static int release_child(struct device *dev, void *data)
> +{
> +	pm_runtime_put_autosuspend(dev);
> +	return 0;
> +}
> +
>  /**
>   *	tty_release		-	vfs callback for close
>   *	@inode: inode of tty
> @@ -1712,6 +1725,8 @@ int tty_release(struct inode *inode, struct file *filp)
>  	long	timeout = 0;
>  	int	once = 1;
>  
> +	if (tty->dev)
> +		device_for_each_child(tty->dev, NULL, release_child);
>  	if (tty_paranoia_check(tty, inode, __func__))
>  		return 0;
>  
> @@ -2118,6 +2133,8 @@ retry_open:
>  		__proc_set_tty(current, tty);
>  	spin_unlock_irq(&current->sighand->siglock);
>  	tty_unlock(tty);
> +	if (tty->dev)
> +		device_for_each_child(tty->dev, NULL, open_child);
>  	mutex_unlock(&tty_mutex);
>  	return 0;
>  err_unlock:
> @@ -3207,6 +3224,11 @@ struct device *tty_register_device_attr(struct tty_driver *driver,
>  	retval = device_register(dev);
>  	if (retval)
>  		goto error;
> +	if (device && device->of_node)
> +		/* Children are platform devices and will be
> +		 * runtime_pm managed by this tty.
> +		 */
> +		of_platform_populate(device->of_node, NULL, NULL, dev);

Also need to remove all the tty slaves on driver unbind.

>  
>  	return dev;
>  
> 
> 

