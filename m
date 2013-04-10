Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965106Ab3DJRCH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 13:02:07 -0400
Received: from mail.active-venture.com ([67.228.131.205]:53079 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759268Ab3DJRCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 13:02:04 -0400
X-Originating-IP: 108.223.40.66
Date: Wed, 10 Apr 2013 10:02:12 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Kevin Strasser <kevin.strasser@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Michael Brunner <michael.brunner@kontron.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Wolfram Sang <wsa@the-dreams.de>,
        Ben Dooks <ben-linux@fluff.org>, linux-i2c@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        Darren Hart <dvhart@linux.intel.com>, Michael Brunner <mibru@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/4] i2c: Kontron PLD i2c bus driver
Message-ID: <20130410170212.GB19533@roeck-us.net>
References: <1365441321-21952-1-git-send-email-kevin.strasser@linux.intel.com>
 <1365441321-21952-2-git-send-email-kevin.strasser@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365441321-21952-2-git-send-email-kevin.strasser@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 10:15:19AM -0700, Kevin Strasser wrote:
> From: Michael Brunner <michael.brunner@kontron.com>
> 
> Add i2c support for the on-board PLD found on some Kontron embedded
> modules.
> 
> Signed-off-by: Michael Brunner <michael.brunner@kontron.com>
> Signed-off-by: Kevin Strasser <kevin.strasser@linux.intel.com>

Overall well written, though I have a couple of nitpicks.

I would prefer two separate drivers, one for the mux and one for the i2c bus.
If that is possible, it would help getting rid of the #ifdef in the code, which
is frowned upon in the kernel.

I dislike unnecessary ( ). Maintainer's call, though.

Couple of places have missing spaces around operators (checkpatch doesn't catch
all those).

As far as I know, devm_ functions are supposed to print an error message on
failure, so it should be unnecessary to print another one if that happens (this
might need some confirmation).

Thanks,
Guenter

> ---
>  drivers/i2c/busses/Kconfig      |   20 ++
>  drivers/i2c/busses/Makefile     |    1 +
>  drivers/i2c/busses/i2c-kempld.c |  679 +++++++++++++++++++++++++++++++++++++++
>  drivers/i2c/busses/i2c-kempld.h |   86 +++++
>  4 files changed, 786 insertions(+)
>  create mode 100644 drivers/i2c/busses/i2c-kempld.c
>  create mode 100644 drivers/i2c/busses/i2c-kempld.h
> 
> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> index adfee98..7aecd61 100644
> --- a/drivers/i2c/busses/Kconfig
> +++ b/drivers/i2c/busses/Kconfig
> @@ -494,6 +494,26 @@ config I2C_IOP3XX
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called i2c-iop3xx.
>  
> +config I2C_KEMPLD
> +	tristate "Kontron COM I2C"
> +	depends on MFD_KEMPLD
> +	help
> +	  This enables support for the I2C bus interface on some Kontron ETX
> +	  and COMexpress (ETXexpress) modules.
> +
> +	  This driver can also be built as a module. If so, the module
> +	  will be called i2c-kempld.
> +
> +config I2C_KEMPLD_MUX
> +	bool "Enable MUXed I2C ports (EXPERIMENTAL)"
> +	depends on I2C_KEMPLD && I2C_MUX
> +	default n
> +	help
> +	  This enables support for additional I2C ports available on some
> +	  modules. Usually those ports are for board internal usage and
> +	  not routed outside the module.
> +	  Do not use this option unless you know what you are doing!
> +
>  config I2C_MPC
>  	tristate "MPC107/824x/85xx/512x/52xx/83xx/86xx"
>  	depends on PPC
> diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
> index 8f4fc23..411b8ce 100644
> --- a/drivers/i2c/busses/Makefile
> +++ b/drivers/i2c/busses/Makefile
> @@ -48,6 +48,7 @@ obj-$(CONFIG_I2C_IBM_IIC)	+= i2c-ibm_iic.o
>  obj-$(CONFIG_I2C_IMX)		+= i2c-imx.o
>  obj-$(CONFIG_I2C_INTEL_MID)	+= i2c-intel-mid.o
>  obj-$(CONFIG_I2C_IOP3XX)	+= i2c-iop3xx.o
> +obj-$(CONFIG_I2C_KEMPLD)    += i2c-kempld.o
>  obj-$(CONFIG_I2C_MPC)		+= i2c-mpc.o
>  obj-$(CONFIG_I2C_MV64XXX)	+= i2c-mv64xxx.o
>  obj-$(CONFIG_I2C_MXS)		+= i2c-mxs.o
> diff --git a/drivers/i2c/busses/i2c-kempld.c b/drivers/i2c/busses/i2c-kempld.c
> new file mode 100644
> index 0000000..c6b44e7
> --- /dev/null
> +++ b/drivers/i2c/busses/i2c-kempld.c
> @@ -0,0 +1,679 @@
> +/*
> + *  i2c-kempld.c: I2C bus driver for Kontron COM modules
> + *
> + *  Copyright (c) 2010-2013 Kontron Europe GmbH
> + *  Author: Michael Brunner <michael.brunner@kontron.com>
> + *
> + *  The driver is based on the i2c-ocores driver by Peter Korsgaard.
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License 2 as published
> + *  by the Free Software Foundation.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; see the file COPYING.  If not, write to
> + *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/errno.h>
> +#include <linux/platform_device.h>
> +#include <linux/i2c.h>
> +#ifdef CONFIG_I2C_KEMPLD_MUX
> +#include <linux/i2c-mux.h>
> +#endif
> +#include <linux/delay.h>
> +#include <linux/slab.h>
> +#include <linux/mfd/kempld.h>
> +#include <linux/interrupt.h>
> +#include <linux/time.h>
> +
> +#include "i2c-kempld.h"
> +
> +static int scl_frequency;
> +static int i2c_bus = -1;
> +static int i2c_mx_bus = -1;
> +static bool force_polling;
> +static int i2c_gpio_mux = -1;
> +
> +#ifdef CONFIG_I2C_KEMPLD_MUX
> +static int kempld_i2cmux_select(struct i2c_adapter *adap, void *data, u32 chan)
> +{
> +	struct kempld_i2c_data *i2c = data;
> +	struct kempld_device_data *pld = i2c->pld;
> +	int ret = 0;
> +
> +	if ((i2c->state == STATE_DONE)
> +		|| (i2c->state == STATE_ERROR)) {
> +		if (i2c->mx != chan) {
> +			kempld_get_mutex_set_index(pld, KEMPLD_I2C_MX);
> +			i2c->mx = chan & 0x0f;
> +			kempld_write8(pld, KEMPLD_I2C_MX, i2c->mx);
> +			kempld_release_mutex(pld);
> +		}
> +
> +		/* Reset controller if the last transfer ended with an error */
> +		if (i2c->state == STATE_ERROR) {
> +			u8 ctrl;
> +
> +			kempld_get_mutex_set_index(pld, KEMPLD_I2C_CMD);
> +			ctrl = kempld_read8(pld, KEMPLD_I2C_CONTROL);
> +			ctrl &= ~OCI2C_CTRL_EN;
> +			kempld_write8(pld, KEMPLD_I2C_CONTROL, ctrl);
> +			kempld_write8(pld, KEMPLD_I2C_CMD, OCI2C_CMD_IACK);
> +			ctrl |= OCI2C_CTRL_EN;
> +			kempld_write8(pld, KEMPLD_I2C_CONTROL, ctrl);
> +			kempld_release_mutex(pld);
> +		}
> +
> +	} else
> +		ret = -EBUSY;
> +
> +	return ret;
> +}
> +
> +static void kempld_i2cmux_del(struct kempld_i2c_data *i2c)
> +{
> +	int i;
> +
> +	for (i = 0; i <= i2c->mx_max; i++) {
> +		if (i2c->mxadap[i]) {
> +			i2c_del_mux_adapter(i2c->mxadap[i]);
> +			i2c->mxadap[i] = NULL;
> +		}
> +	}
> +}
> +
> +static int kempld_i2cmux_add(struct kempld_i2c_data *i2c)
> +{
> +	struct kempld_device_data *pld = i2c->pld;
> +	int i;
> +	int ret = -ENODEV;
> +
> +	for (i = 0; (i <= (i2c->mx_max)); i++) {
> +		i2c->mxadap[i] = i2c_add_mux_adapter(&i2c->adap,
> +							NULL, i2c, 0, i, 0,
> +							kempld_i2cmux_select,
> +							NULL);
> +		if (!i2c->mxadap[i]) {
> +			ret = -ENODEV;
> +			dev_err(pld->dev,
> +				"Failed to register MUX adapter %d\n", i);
> +			goto add_mux_adapter_failed;
> +		}
> +	}
> +
> +	return 0;
> +
> +add_mux_adapter_failed:
> +	kempld_i2cmux_del(i2c);
> +
> +	return ret;
> +}
> +
> +#else
> +#define kempld_i2cmux_add(x) (0)
> +#define kempld_i2cmux_del(x) do {} while (0)
> +#endif
> +
> +static int kempld_i2c_process(struct kempld_i2c_data *i2c)
> +{
> +	struct kempld_device_data *pld = i2c->pld;
> +	struct i2c_msg *msg = i2c->msg;
> +	u8 stat = kempld_read8(pld, KEMPLD_I2C_STATUS);
> +
> +	/* ready? */
> +	if (stat & OCI2C_STAT_TIP)
> +		return -EBUSY;
> +
> +	if ((i2c->state == STATE_DONE) || (i2c->state == STATE_ERROR)) {
> +		/* stop has been sent */
> +		kempld_write8(pld, KEMPLD_I2C_CMD, OCI2C_CMD_IACK);
> +		if (i2c->irq)
> +			wake_up(&i2c->wait);
> +		if (i2c->state == STATE_ERROR)
> +			return -EIO;
> +		else
> +			return 0;
> +	}
> +
> +	/* error? */
> +	if (stat & OCI2C_STAT_ARBLOST) {
> +		i2c->state = STATE_ERROR;
> +		kempld_write8(pld, KEMPLD_I2C_CMD, OCI2C_CMD_STOP);
> +		return -EAGAIN;
> +	}
> +
> +	if (i2c->state == STATE_INIT) {
> +		/* check if bus is free */
> +		if (stat & OCI2C_STAT_BUSY)
> +			return -EBUSY;
> +
> +		i2c->state = STATE_ADDR;
> +	}
> +
> +	if (i2c->state == STATE_ADDR) {
> +		u8 addr;
> +		/* 10 bit address? */
> +		if (i2c->msg->flags & I2C_M_TEN) {
> +			addr = 0xf0 | ((i2c->msg->addr >> 7) & 0x6);
> +			i2c->state = STATE_ADDR10;
> +		} else {
> +			addr = (i2c->msg->addr << 1);
> +			i2c->state = STATE_START;
> +		}
> +
> +		/* set read bit if necessary */
> +		addr |= (i2c->msg->flags & I2C_M_RD) ? 1 : 0;
> +
> +		kempld_write8(pld, KEMPLD_I2C_DATA, addr);
> +		kempld_write8(pld, KEMPLD_I2C_CMD, OCI2C_CMD_START);
> +
> +		return 0;
> +	}
> +
> +	/* second part of 10 bit addressing */
> +	if (i2c->state == STATE_ADDR10) {
> +		kempld_write8(pld, KEMPLD_I2C_DATA, i2c->msg->addr & 0xff);
> +		kempld_write8(pld, KEMPLD_I2C_CMD, OCI2C_CMD_WRITE);
> +
> +		i2c->state = STATE_START;
> +		return 0;
> +	}
> +
> +	if ((i2c->state == STATE_START) || (i2c->state == STATE_WRITE)) {
> +		i2c->state =
> +			(msg->flags & I2C_M_RD) ? STATE_READ : STATE_WRITE;
> +
> +		if (stat & OCI2C_STAT_NACK) {
> +			i2c->state = STATE_ERROR;
> +			kempld_write8(pld, KEMPLD_I2C_CMD, OCI2C_CMD_STOP);
> +			return -ENXIO;
> +		}
> +	} else
> +		msg->buf[i2c->pos++] = kempld_read8(pld, KEMPLD_I2C_DATA);
> +
> +	/* end of msg? */
> +	if (i2c->pos >= msg->len) {
> +		i2c->nmsgs--;
> +		i2c->msg++;
> +		i2c->pos = 0;
> +		msg = i2c->msg;
> +
> +		if (i2c->nmsgs) {	/* end? */
> +			/* send start? */
> +			if (!(msg->flags & I2C_M_NOSTART)) {
> +				i2c->state = STATE_ADDR;
> +				if (i2c->irq)
> +					wake_up(&i2c->wait);
> +				return 0;
> +			} else
> +				i2c->state = (msg->flags & I2C_M_RD)
> +					? STATE_READ : STATE_WRITE;
> +		} else {
> +			i2c->state = STATE_DONE;
> +			kempld_write8(pld, KEMPLD_I2C_CMD, OCI2C_CMD_STOP);
> +			return 0;
> +		}
> +	}
> +
> +	if (i2c->state == STATE_READ) {
> +		kempld_write8(pld, KEMPLD_I2C_CMD, i2c->pos == (msg->len-1) ?
> +			OCI2C_CMD_READ_NACK : OCI2C_CMD_READ_ACK);
> +	} else {
> +		kempld_write8(pld, KEMPLD_I2C_DATA, msg->buf[i2c->pos++]);
> +		kempld_write8(pld, KEMPLD_I2C_CMD, OCI2C_CMD_WRITE);
> +	}
> +
> +	return 0;
> +}
> +
> +static irqreturn_t kempld_i2c_isr(int irq, void *dev_id)
> +{
> +	struct kempld_i2c_data *i2c = dev_id;
> +
> +	/* The actual ISR handler is put into a tasklet as it may block
> +	 * and therefore rescheduling must be possible */
> +	tasklet_schedule(&i2c->tasklet);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +void kempld_i2c_tasklet(unsigned long data)
> +{
> +	struct kempld_i2c_data *i2c = (struct kempld_i2c_data *)data;
> +	struct kempld_device_data *pld = i2c->pld;
> +
> +	kempld_get_mutex_set_index(pld, KEMPLD_I2C_STATUS);
> +	kempld_i2c_process(i2c);
> +	kempld_release_mutex(pld);
> +}
> +
> +static int kempld_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
> +			int num)
> +{
> +	struct kempld_i2c_data *i2c = i2c_get_adapdata(adap);
> +	struct kempld_device_data *pld = i2c->pld;
> +	unsigned long timeout = jiffies + HZ;
> +	int ret;
> +
> +	i2c->msg = msgs;
> +	i2c->pos = 0;
> +	i2c->nmsgs = num;
> +	i2c->state = STATE_INIT;
> +
> +	/* handle the transfer */
> +	while (time_before(jiffies, timeout)) {
> +		kempld_get_mutex_set_index(pld, KEMPLD_I2C_STATUS);
> +		ret = kempld_i2c_process(i2c);
> +		kempld_release_mutex(pld);
> +
> +		if (i2c->irq && ((i2c->state >= STATE_START)
> +				 || (i2c->state == STATE_ERROR))) {
> +			wait_event_timeout(i2c->wait,
> +					(i2c->state == STATE_ERROR) ||
> +					(i2c->state == STATE_DONE) ||
> +					(i2c->state == STATE_ADDR), HZ);
> +			if (i2c->state == STATE_ERROR)
> +				ret = -EIO;
> +		}
> +
> +		if ((i2c->state == STATE_DONE)
> +			|| (i2c->state == STATE_ERROR))
> +			return (i2c->state == STATE_DONE) ? num : ret;
> +
> +		if (ret == 0)
> +			timeout = jiffies + HZ;
> +
> +		usleep_range(5, 15);
> +	}
> +
> +	i2c->state = STATE_ERROR;
> +
> +	return -ETIMEDOUT;
> +}
> +
> +static void kempld_i2c_device_init(struct kempld_i2c_data *i2c)
> +{
> +	struct kempld_device_data *pld = i2c->pld;
> +	long prescale;
> +	u16 prescale_corr;
> +	u8 cfg;
> +	u8 ctrl;
> +	u8 stat;
> +	u8 mx;
> +
> +	kempld_get_mutex_set_index(pld, KEMPLD_I2C_CONTROL);
> +
> +	ctrl = kempld_read8(pld, KEMPLD_I2C_CONTROL);
> +	if (ctrl & OCI2C_CTRL_EN)
> +		i2c->was_active = 1;
> +
> +	/* set bus frequency */
> +	if (scl_frequency > 0) {
> +		/* make sure the device is disabled */
> +		ctrl &= ~(OCI2C_CTRL_EN|OCI2C_CTRL_IEN);
> +		kempld_write8(pld, KEMPLD_I2C_CONTROL, ctrl);
> +
> +		/* The clock frequency calculation has been changed a bit
> +		 * between the spec. revisions */
> +		if (pld->info.spec_major == 1)
> +			prescale = (pld->pld_clock / (scl_frequency*5)) - 1000;
> +		else
> +			prescale = (pld->pld_clock / (scl_frequency*4)) - 3000;
> +
> +		/* Prevent negative prescaler values */
> +		if (prescale < 0)
> +			prescale = 0;
> +
> +		/* Round to the best matching value */
> +		prescale_corr = prescale / 1000;
> +		if ((prescale % 1000) >= 500)
> +			prescale_corr++;
> +
> +		kempld_write8(pld, KEMPLD_I2C_PRELOW, prescale_corr & 0xff);
> +		kempld_write8(pld, KEMPLD_I2C_PREHIGH, prescale_corr >> 8);
> +	}
> +
> +	/* Activate I2C bus output on GPIO pins */
> +	if (i2c_gpio_mux > -1) {
> +		cfg = kempld_read8(pld, KEMPLD_CFG);
> +		if (i2c_gpio_mux)
> +			cfg |= KEMPLD_CFG_GPIO_I2C_MUX;
> +		else
> +			cfg &= ~KEMPLD_CFG_GPIO_I2C_MUX;
> +		kempld_write8(pld, KEMPLD_CFG, cfg);
> +	}
> +	cfg = kempld_read8(pld, KEMPLD_CFG);
> +	if (cfg & KEMPLD_CFG_GPIO_I2C_MUX)
> +		i2c->gpio_mux = 1;
> +	else
> +		i2c->gpio_mux = 0;
> +	if (((i2c_gpio_mux > 0) && (!i2c->gpio_mux))
> +		|| ((i2c_gpio_mux == 0) && (i2c->gpio_mux)))
> +		dev_warn(pld->dev, "Unable to change GPIO I2C MUX setting\n");
> +
> +	/* Check how much multiplexed I2C busses we have */
> +	mx = kempld_read8(pld, KEMPLD_I2C_MX);
> +	if (pld->info.spec_major > 1) {
> +		i2c->mx_max = KEMPLD_I2C_MX_GET_MAX(mx);
> +		if (i2c->mx_max == 0xf) /* No multiplexer available */
> +			i2c->mx_max = 0;
> +	} else
> +		i2c->mx_max = 1;
> +	/* 2 busses should be enough for all
> +	 * boards using specification revision 1 */
> +
> +	/* Check which MX setting should be set */
> +	if ((i2c_mx_bus == -1) || (i2c_mx_bus > i2c->mx_max)) {
> +		if (i2c_mx_bus > i2c->mx_max) {
> +			dev_err(pld->dev,
> +				"bus selected with i2c_mx_bus not available "
> +				"- leaving MX setting unchanged\n");
> +		}
> +		i2c->mx = mx & KEMPLD_I2C_MX_MASK;
> +	} else
> +		i2c->mx = i2c_mx_bus;
> +
> +	/* Connect the controller to the chosen bus output */
> +	kempld_write8(pld, KEMPLD_I2C_MX, i2c->mx);
> +
> +	/* enable the device */
> +	kempld_write8(pld, KEMPLD_I2C_CMD, OCI2C_CMD_IACK);
> +	ctrl |= OCI2C_CTRL_EN;
> +	kempld_write8(pld, KEMPLD_I2C_CONTROL, ctrl);
> +
> +	/* If bus is busy send a STOP signal to be sure the controller is
> +	 * not hanging... */
> +	stat = kempld_read8(pld, KEMPLD_I2C_STATUS);
> +	if (stat & OCI2C_STAT_BUSY) {
> +		dev_warn(pld->dev,
> +			 "I2C bus is busy - generating stop signal\n");
> +		kempld_write8(pld, KEMPLD_I2C_CMD, OCI2C_CMD_STOP);
> +	}
> +
> +	kempld_release_mutex(pld);
> +
> +	if ((pld->info.spec_major == 1) && (i2c->mx == 0xf))
> +		i2c->mx = 0;
> +}
> +
> +static void kempld_i2c_irq_enable(struct kempld_i2c_data *i2c)
> +{
> +	struct kempld_device_data *pld = i2c->pld;
> +	u8 irq, ctrl;
> +	int ret;
> +
> +	irq = i2c->irq;
> +
> +	/* This only has to be done once */
> +	if (i2c->irq == 0) {
> +		kempld_get_mutex_set_index(pld, KEMPLD_IRQ_I2C);
> +		irq = kempld_read8(pld, KEMPLD_IRQ_I2C);
> +		kempld_release_mutex(pld);
> +
> +		/* Leave if interrupts are not supported by the I2C core */
> +		if ((irq & 0xf0) == 0xf0)
> +			return;
> +		irq &= 0x0f;
> +		if (irq == 0)
> +			return;
> +
> +		/* Initialize interrupt handlers if not already done */
> +		init_waitqueue_head(&i2c->wait);
> +		tasklet_init(&i2c->tasklet, kempld_i2c_tasklet,
> +				(unsigned long)i2c);
> +
> +		ret = devm_request_irq(pld->dev, irq, kempld_i2c_isr,
> +					IRQF_SHARED, i2c->adap.name, i2c);
> +		if (ret) {
> +			dev_err(pld->dev,
> +				"Unable to claim IRQ - using polling mode\n");
> +			return;
> +		}
> +	}
> +
> +	/* Now enable interrupts in the controller */
> +	kempld_get_mutex_set_index(pld, KEMPLD_I2C_CONTROL);
> +	ctrl = kempld_read8(pld, KEMPLD_I2C_CONTROL);
> +	ctrl |= OCI2C_CTRL_IEN;
> +	kempld_write8(pld, KEMPLD_I2C_CONTROL, ctrl);
> +	kempld_release_mutex(pld);
> +
> +	i2c->irq = irq & 0x0f;
> +}
> +
> +static void kempld_i2c_irq_disable(struct kempld_i2c_data *i2c)
> +{
> +	struct kempld_device_data *pld = i2c->pld;
> +	u8 ctrl;
> +	int irq;
> +
> +	if (i2c->irq == 0)
> +		return;
> +
> +	irq = i2c->irq;
> +	i2c->irq = 0;
> +
> +	tasklet_kill(&i2c->tasklet);
> +
> +	kempld_get_mutex_set_index(pld, KEMPLD_I2C_CONTROL);
> +	ctrl = kempld_read8(pld, KEMPLD_I2C_CONTROL);
> +	ctrl &= ~OCI2C_CTRL_IEN;
> +	kempld_write8(pld, KEMPLD_I2C_CONTROL, ctrl);
> +	kempld_release_mutex(pld);
> +
> +	devm_free_irq(pld->dev, irq, i2c);
> +}
> +
> +static u32 kempld_i2c_func(struct i2c_adapter *adap)
> +{
> +	return I2C_FUNC_I2C | I2C_FUNC_10BIT_ADDR
> +		| I2C_FUNC_SMBUS_EMUL;
> +}
> +
> +static const struct i2c_algorithm kempld_i2c_algorithm = {
> +	.master_xfer	= kempld_i2c_xfer,
> +	.functionality	= kempld_i2c_func,
> +};
> +
> +static struct i2c_adapter kempld_i2c_adapter = {
> +	.owner		= THIS_MODULE,
> +	.name		= "i2c-kempld",
> +	.class		= I2C_CLASS_HWMON | I2C_CLASS_SPD,
> +	.algo		= &kempld_i2c_algorithm,
> +};
> +
> +static int kempld_i2c_get_scl_frequency(struct kempld_i2c_data *i2c)
> +{
> +	struct kempld_device_data *pld = i2c->pld;
> +	int frequency;
> +	u16 prescale;
> +
> +	kempld_get_mutex_set_index(pld, KEMPLD_I2C_PRELOW);
> +
> +	prescale = kempld_read8(pld, KEMPLD_I2C_PRELOW)
> +		| kempld_read8(pld, KEMPLD_I2C_PREHIGH)<<8;
> +
> +	kempld_release_mutex(pld);
> +
> +	/* The clock frequency calculation has been changed a bit
> +	 * between the spec. revisions */
> +	if (pld->info.spec_major == 1)
> +		frequency = (pld->pld_clock / (prescale + 1)) / 5000;
> +	else
> +		frequency = (pld->pld_clock / (prescale + 3)) / 4000;
> +
> +	return frequency;
> +}
> +
> +static int kempld_i2c_probe(struct platform_device *pdev)
> +{
> +	struct kempld_i2c_data *i2c;
> +	struct kempld_device_data *pld;
> +	int ret;
> +
> +	pld = dev_get_drvdata(pdev->dev.parent);
> +
> +	i2c = kzalloc(sizeof(*i2c), GFP_KERNEL);
> +	if (!i2c)
> +		return -ENOMEM;
> +
> +	i2c->pld = pld;
> +
> +	kempld_i2c_device_init(i2c);
> +
> +	/* hook up driver to tree */
> +	platform_set_drvdata(pdev, i2c);
> +	i2c->adap = kempld_i2c_adapter;
> +	i2c_set_adapdata(&i2c->adap, i2c);
> +	i2c->adap.dev.parent = &pdev->dev;
> +
> +	i2c->irq = 0;
> +	if (!force_polling)
> +		kempld_i2c_irq_enable(i2c);
> +
> +	/* add I2C adapter to I2C tree */
> +	i2c->adap.nr = i2c_bus;
> +	ret = i2c_add_numbered_adapter(&i2c->adap);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to add adapter\n");
> +		goto add_adapter_failed;
> +	}
> +
> +	ret = kempld_i2cmux_add(i2c);
> +	if (ret)
> +		goto add_mux_adapters_failed;
> +
> +	dev_info(pld->dev, "I2C bus initialized with %d kHz SCL frequency\n",
> +		 kempld_i2c_get_scl_frequency(i2c));
> +	dev_info(pld->dev, "I2C MUX connected to bus %d (available: %s%d)\n",
> +		 i2c->mx, i2c->mx_max ? "0-" : "", i2c->mx_max);
> +	dev_info(pld->dev, "I2C IRQs %s\n", i2c->irq ? "enabled" : "disabled");
> +	if (i2c->gpio_mux)
> +		dev_info(pld->dev, "GPIO I2C MUX pins enabled\n");
> +
> +	return 0;
> +
> +add_mux_adapters_failed:
> +	i2c_del_adapter(&i2c->adap);
> +add_adapter_failed:
> +	kfree(i2c);
> +
> +	return ret;
> +}
> +
> +static int kempld_i2c_remove(struct platform_device *pdev)
> +{
> +	struct kempld_i2c_data *i2c = platform_get_drvdata(pdev);
> +	struct kempld_device_data *pld = i2c->pld;
> +	u8 ctrl;
> +
> +	kempld_i2c_irq_disable(i2c);
> +
> +	if (!i2c->was_active) {
> +		/* disable I2C logic if it was not activated before the
> +		 * driver loaded */
> +		kempld_get_mutex_set_index(pld, KEMPLD_I2C_CONTROL);
> +		ctrl = kempld_read8(pld, KEMPLD_I2C_CONTROL);
> +		ctrl &= ~OCI2C_CTRL_EN;
> +		kempld_write8(pld, KEMPLD_I2C_CONTROL, ctrl);
> +		kempld_release_mutex(pld);
> +	}
> +
> +	/* remove adapter & data */
> +	kempld_i2cmux_del(i2c);
> +	i2c_del_adapter(&i2c->adap);
> +
> +	platform_set_drvdata(pdev, NULL);
> +
> +	kfree(i2c);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int kempld_i2c_suspend(struct platform_device *pdev, pm_message_t state)
> +{
> +	struct kempld_i2c_data *i2c = platform_get_drvdata(pdev);
> +	struct kempld_device_data *pld = i2c->pld;
> +	u8 ctrl;
> +
> +	kempld_i2c_irq_disable(i2c);
> +
> +	if (!i2c->was_active) {
> +		/* make sure the device is disabled */
> +		kempld_get_mutex_set_index(pld, KEMPLD_I2C_CONTROL);
> +		ctrl = kempld_read8(pld, KEMPLD_I2C_CONTROL);
> +		ctrl &= ~OCI2C_CTRL_EN;
> +		kempld_write8(pld, KEMPLD_I2C_CONTROL, ctrl);
> +		kempld_release_mutex(pld);
> +	}
> +
> +	return 0;
> +}
> +
> +static int kempld_i2c_resume(struct platform_device *pdev)
> +{
> +	struct kempld_i2c_data *i2c = platform_get_drvdata(pdev);
> +
> +	kempld_i2c_device_init(i2c);
> +	kempld_i2c_irq_enable(i2c);
> +
> +	return 0;
> +}
> +#else
> +#define kempld_i2c_suspend	NULL
> +#define kempld_i2c_resume	NULL
> +#endif
> +
> +static struct platform_driver kempld_i2c_driver = {
> +	.driver = {
> +		.name = "kempld-i2c",
> +		.owner = THIS_MODULE,
> +	},
> +	.probe		= kempld_i2c_probe,
> +	.remove		= kempld_i2c_remove,
> +	.suspend	= kempld_i2c_suspend,
> +	.resume		= kempld_i2c_resume,
> +};
> +
> +static int __init kempld_i2c_init(void)
> +{
> +	/* Check if a valid value for the i2c_mx_bus parameter is provided */
> +	if ((i2c_mx_bus != -1) && (i2c_mx_bus & ~KEMPLD_I2C_MX_MASK))
> +		return -EINVAL;
> +
> +	return platform_driver_register(&kempld_i2c_driver);
> +}
> +
> +static void __exit kempld_i2c_exit(void)
> +{
> +	platform_driver_unregister(&kempld_i2c_driver);
> +}
> +
> +module_init(kempld_i2c_init);
> +module_exit(kempld_i2c_exit);
> +
> +module_param(scl_frequency, int, 0);
> +module_param(i2c_bus, int, 0);
> +module_param(i2c_mx_bus, int, 0);
> +module_param(force_polling, bool, 0);
> +module_param(i2c_gpio_mux, int, 0);
> +
> +MODULE_DESCRIPTION("KEM PLD I2C Driver");
> +MODULE_AUTHOR("Michael Brunner <michael.brunner@kontron.com>");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:kempld_i2c");
> +MODULE_PARM_DESC(scl_frequency, "Set I2C SCL frequency (in kHz) default=0");
> +MODULE_PARM_DESC(i2c_bus, "Set I2C bus (-1 for dynamic assignment");
> +MODULE_PARM_DESC(i2c_mx_bus, "Set I2C MX bus (0-15, default=-1 (FW default))");
> +MODULE_PARM_DESC(force_polling, "Force polling mode");
> +MODULE_PARM_DESC(i2c_gpio_mux, "Enable I2C port on GPIO out");
> diff --git a/drivers/i2c/busses/i2c-kempld.h b/drivers/i2c/busses/i2c-kempld.h
> new file mode 100644
> index 0000000..2229662
> --- /dev/null
> +++ b/drivers/i2c/busses/i2c-kempld.h
> @@ -0,0 +1,86 @@
> +/*
> + *  i2c-kempld.h - Kontron PLD I2C driver definitions
> + *
> + *  Copyright (c) 2010-2012 Kontron Europe GmbH
> + *  Author: Michael Brunner <michael.brunner@kontron.com>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License 2 as published
> + *  by the Free Software Foundation.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; see the file COPYING.  If not, write to
> + *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#ifndef _KEMPLD_I2C_H_
> +#define _KEMPLD_I2C_H_
> +
> +struct kempld_i2c_data {
> +	struct i2c_adapter		adap;
> +	struct i2c_adapter		*mxadap[15];
> +	struct i2c_msg			*msg;
> +	int				pos;
> +	int				nmsgs;
> +	int				state; /* see STATE_ */
> +	int				was_active;
> +	int				mx;
> +	int				mx_max;
> +	int				gpio_mux;
> +	wait_queue_head_t		wait;
> +	struct tasklet_struct		tasklet;
> +	int				irq;
> +	struct kempld_device_data	*pld;
> +};
> +
> +/* I2C register definitions */
> +#define KEMPLD_I2C_PRELOW	0x0b
> +#define KEMPLD_I2C_PREHIGH	0x0c
> +#define KEMPLD_I2C_CONTROL	0x0d
> +#define KEMPLD_I2C_DATA		0x0e
> +#define KEMPLD_I2C_CMD		0x0f /* write only */
> +#define		KEMPLD_I2C_CMD_STA	0x80
> +#define		KEMPLD_I2C_CMD_STO	0x40
> +#define		KEMPLD_I2C_CMD_RD	0x20
> +#define		KEMPLD_I2C_CMD_WR	0x10
> +#define		KEMPLD_I2C_CMD_NACK	0x08
> +#define		KEMPLD_I2C_CMD_IACK	0x01
> +#define KEMPLD_I2C_STATUS	0x0f /* read only, same address as
> +					KEMPLD_I2C_CMD */
> +#define KEMPLD_I2C_MX		0x15
> +#define		KEMPLD_I2C_MX_GET_MAX(x)	((x & 0xf0)>>4)
> +#define		KEMPLD_I2C_MX_MASK		0x0f
> +
> +#define STATE_DONE		0
> +#define STATE_INIT		1
> +#define STATE_ADDR		2
> +#define STATE_ADDR10		3
> +#define STATE_START		4
> +#define STATE_WRITE		5
> +#define STATE_READ		6
> +#define STATE_ERROR		7
> +
> +/* defines taken from i2c-ocores */
> +#define OCI2C_CTRL_IEN		0x40
> +#define OCI2C_CTRL_EN		0x80
> +
> +#define OCI2C_CMD_START		0x91
> +#define OCI2C_CMD_STOP		0x41
> +#define OCI2C_CMD_READ		0x21
> +#define OCI2C_CMD_WRITE		0x11
> +#define OCI2C_CMD_READ_ACK	0x21
> +#define OCI2C_CMD_READ_NACK	0x29
> +#define OCI2C_CMD_IACK		0x01
> +
> +#define OCI2C_STAT_IF		0x01
> +#define OCI2C_STAT_TIP		0x02
> +#define OCI2C_STAT_ARBLOST	0x20
> +#define OCI2C_STAT_BUSY		0x40
> +#define OCI2C_STAT_NACK		0x80
> +
> +#endif /* _KEMPLD_I2C_H_ */
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
