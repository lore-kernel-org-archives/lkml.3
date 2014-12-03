Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699AbaLCF1E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 00:27:04 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:38499 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaLCF1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 00:27:00 -0500
Date: Tue, 2 Dec 2014 16:03:32 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "jeffrey.lin" <yajohn@gmail.com>
Cc: rydberg@euromail.se, shc_work@mail.ru, bleung@chromium.org,
        lee.jones@linaro.org, charliemooney@chromium.org, KP.li@rad-ic.com,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        "jeffrey.lin" <jeffrey.lin@rad-ic.com>
Subject: Re: [PATCH] driver: input: touchscreen: add Raydium i2c touchscreen
 driver
Message-ID: <20141203000332.GD6207@localhost>
References: <1417429031-4576-1-git-send-email-jeffrey.lin@rad-ic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417429031-4576-1-git-send-email-jeffrey.lin@rad-ic.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI Jeffrey,

On Mon, Dec 01, 2014 at 06:17:11PM +0800, jeffrey.lin wrote:
> From: "jeffrey.lin" <jeffrey.lin@rad-ic.com>
> 
> This patch is porting Raydium I2C touch driver. Developer can enable
> raydium touch driver by modifying define "CONFIG_TOUCHSCREEN_RM_TS".

Thank you for making the changes requested earlier.

> 
> Change-Id: I5f33cfdf0e895de6e7d535c11dd4b3ce8b49fa48
> Signed-off-by: jeffrey.lin@rad-ic.com
> ---
>  drivers/input/touchscreen/Kconfig      |  12 +
>  drivers/input/touchscreen/Makefile     |   1 +
>  drivers/input/touchscreen/rm31100_ts.c | 968 +++++++++++++++++++++++++++++++++
>  include/linux/input/rm31100_ts.h       |  60 ++
>  4 files changed, 1041 insertions(+)
>  create mode 100644 drivers/input/touchscreen/rm31100_ts.c
>  create mode 100644 include/linux/input/rm31100_ts.h
> 
> diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
> index 3ce9181..d0324d2 100644
> --- a/drivers/input/touchscreen/Kconfig
> +++ b/drivers/input/touchscreen/Kconfig
> @@ -955,4 +955,16 @@ config TOUCHSCREEN_ZFORCE
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called zforce_ts.
>  
> +config TOUCHSCREEN_RM_TS
> +	tristate "Raydium I2C Touchscreen"
> +	depends on I2C
> +	help
> +	  Say Y here if you have Raydium series I2C touchscreen,
> +	  such as RM31100 , connected to your system.
> +
> +	  If unsure, say N.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called rm31100_ts.
> +
>  endif
> diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
> index 687d5a7..aae4af2 100644
> --- a/drivers/input/touchscreen/Makefile
> +++ b/drivers/input/touchscreen/Makefile
> @@ -78,3 +78,4 @@ obj-$(CONFIG_TOUCHSCREEN_WM97XX_ZYLONITE)	+= zylonite-wm97xx.o
>  obj-$(CONFIG_TOUCHSCREEN_W90X900)	+= w90p910_ts.o
>  obj-$(CONFIG_TOUCHSCREEN_TPS6507X)	+= tps6507x-ts.o
>  obj-$(CONFIG_TOUCHSCREEN_ZFORCE)	+= zforce_ts.o
> +obj-$(CONFIG_TOUCHSCREEN_RM_TS)	+= rm31100_ts.o
> diff --git a/drivers/input/touchscreen/rm31100_ts.c b/drivers/input/touchscreen/rm31100_ts.c
> new file mode 100644
> index 0000000..6cb09a4
> --- /dev/null
> +++ b/drivers/input/touchscreen/rm31100_ts.c
> @@ -0,0 +1,968 @@
> +/* Source for:
> + * Raydium rm31100_ts Prototype touchscreen driver.
> + * drivers/input/touchscreen/rm31100_ts.c

No need for the file name. And we know it is a source. So just say:

Raydium RM31100 touchscreen driver.

Why does it say it's a prototype?

> + *
> + * Copyright (C) 2012,

Whose copyright is this?

> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2, and only version 2, as published by the
> + * Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * Raydium reserves the right to make changes without further notice
> + * to the materials described herein. Raydium does not assume any
> + * liability arising out of the application described herein.
> + *
> + * Contact Raydium Semiconductor Corporation at www.rad-ic.com
> + *
> + * History:
> + *			(C) 2012 Raydium - Update for GPL distribution
> + *			(C) 2009 Enea - Original prototype
> + *
> + */
> +#include <linux/async.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/i2c.h>
> +#include <linux/input.h>
> +#include <linux/slab.h>
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
> +#include <linux/gpio.h>
> +#include <linux/workqueue.h>

We are not using workier anymore, please remove.

> +#include <linux/mutex.h>
> +#include <linux/delay.h>
> +#include <linux/input/rm31100_ts.h>
> +#include <linux/pm.h>
> +#include <linux/pm_runtime.h>
> +/*#include <plat/gpio-cfg.h>*/
> +#ifdef CONFIG_MISC_DEV
> +#include <linux/miscdevice.h>
> +#endif
> +/*#include <asm/uaccess.h> copy_to_user() */
> +#include <linux/uaccess.h>
> +
> +#define rm31100	0x0
> +#define rm3110x	0x1
> +
> +#define INVALID_DATA	0xff
> +#define MAX_REPORT_TOUCHED_POINTS	10
> +
> +#define TOUCHSCREEN_TIMEOUT	(msecs_to_jiffies(10))

Does not seem to be used.

> +#define INITIAL_DELAY		(msecs_to_jiffies(25000))

Does not seem to be used.

> +
> +#define EVAL_REPORT_RATE    1
> +
> +#define I2C_CLIENT_ADDR         0x39
> +#define I2C_DMA_CLIENT_ADDR     0x5A
> +#undef CONFIG_PM

What on earth is this????

> +struct rm31100_ts_data {
> +	u8 x_index;
> +	u8 y_index;
> +	u8 z_index;
> +	u8 id_index;
> +	u8 touch_index;
> +	u8 data_reg;
> +	u8 status_reg;
> +	u8 data_size;
> +	u8 touch_bytes;
> +	u8 update_data;
> +	u8 touch_meta_data;
> +	u8 finger_size;
> +};
> +
> +static struct rm31100_ts_data devices[] = {
> +	[0] = {
> +		.x_index = 2,
> +		.y_index = 4,
> +		.z_index = 6,
> +		.id_index = 1,
> +		.data_reg = 0x1,
> +		.status_reg = 0,
> +		.update_data = 0x0,/*0x4*/
> +		.touch_bytes = 6,
> +		.touch_meta_data = 1,
> +		.finger_size = 70,
> +	},
> +};
> +
> +struct rm31100_ts {
> +	struct i2c_client *client;
> +	struct input_dev *input;
> +	struct delayed_work work;

We are not using work anymore, please remove.

> +	struct rm3110x_ts_platform_data *pdata;
> +	struct rm31100_ts_data *dd;
> +	u8 *touch_data;
> +	u8 device_id;
> +	u8 prev_touches;
> +	bool is_suspended;
> +	bool int_pending;
> +	struct mutex sus_lock;
> +	struct mutex access_lock;
> +	u32 pen_irq;
> +};
> +
> +struct rm31100_ts *pts;
> +/*
> +static inline u16 join_bytes(u8 a, u8 b)
> +{
> +	u16 ab = 0;
> +	ab = ab | a;
> +	ab = ab << 8 | b;
> +	return ab;
> +}
> +*/
> +static s32 rm31100_ts_write_reg_u8(struct i2c_client *client, u8 reg, u8 val)
> +{
> +	s32 data;
> +
> +	data = i2c_smbus_write_byte_data(client, reg, val);
> +	if (data < 0)
> +		dev_err(&client->dev, "error %d in writing reg 0x%x\n",
> +						 data, reg);
> +
> +	return data;
> +}
> +
> +static s32 rm31100_ts_read_reg_u8(struct i2c_client *client, u8 reg)
> +{
> +	s32 data;
> +
> +	data = i2c_smbus_read_byte_data(client, reg);
> +	if (data < 0)
> +		dev_err(&client->dev, "error %d in reading reg 0x%x\n",
> +						 data, reg);
> +
> +	return data;
> +}
> +
> +static int rm31100_ts_read(struct i2c_client *client, u8 reg, u8 *buf, int num)
> +{
> +	struct i2c_msg xfer_msg[2];
> +
> +	xfer_msg[0].addr = client->addr;
> +	xfer_msg[0].len = 1;
> +	xfer_msg[0].flags = 0;
> +	xfer_msg[0].buf = &reg;
> +
> +	xfer_msg[1].addr = client->addr;
> +	xfer_msg[1].len = num;
> +	xfer_msg[1].flags = I2C_M_RD;
> +	xfer_msg[1].buf = buf;
> +
> +	return i2c_transfer(client->adapter, xfer_msg, 2);
> +}
> +
> +static int rm31100_ts_write(struct i2c_client *client, u8 *buf, int num)
> +{
> +	struct i2c_msg xfer_msg[1];
> +
> +	xfer_msg[0].addr = client->addr;
> +	xfer_msg[0].len = num;
> +	xfer_msg[0].flags = 0;
> +	xfer_msg[0].buf = buf;
> +
> +	return i2c_transfer(client->adapter, xfer_msg, 1);
> +}
> +
> +#ifdef CONFIG_MISC_DEV
> +static int dev_open(struct inode *inode, struct file *filp)
> +{
> +	mutex_lock(&pts->access_lock);
> +	return 0;
> +}
> +
> +static int dev_release(struct inode *inode, struct file *filp)
> +{
> +	mutex_unlock(&pts->access_lock);
> +	return 0;
> +}
> +static ssize_t
> +dev_read(struct file *filp, char __user *buf, size_t count, loff_t *pos)
> +{
> +	u8 *kbuf;
> +	struct i2c_msg xfer_msg;
> +	/*static char out[] = "1234567890";*/
> +	/*static int idx;*//*= 0; remove by checkpatch*/
> +	int i;
> +
> +	kbuf = kmalloc(count, GFP_KERNEL);
> +	if (kbuf == NULL)
> +		return -ENOMEM;
> +
> +	/*xfer_msg.addr = pts->client->addr;*/
> +	xfer_msg.addr = I2C_CLIENT_ADDR;
> +	xfer_msg.len = count;
> +	xfer_msg.flags = I2C_M_RD;
> +	xfer_msg.buf = kbuf;
> +
> +	i2c_transfer(pts->client->adapter, &xfer_msg, 1);
> +
> +	if (copy_to_user(buf, kbuf, count) == 0)
> +		return count;
> +	else
> +		return -EFAULT;
> +}
> +
> +static ssize_t
> +dev_write(struct file *filp, const char __user *buf, size_t count, loff_t *pos)
> +{
> +	u8 *kbuf;
> +	ssize_t status = 0;
> +	int i;
> +
> +	kbuf = kmalloc(count, GFP_KERNEL);
> +	if (kbuf == NULL) {
> +		dev_err("kmalloc() fail\n");
> +		return -ENOMEM;
> +	}
> +
> +	if (copy_from_user(kbuf, buf, count) == 0) {
> +		pts->client->addr = I2C_CLIENT_ADDR;
> +		if (rm31100_ts_write(pts->client, kbuf, count) < 0)
> +			status = -EFAULT;
> +		else
> +			status = count;
> +	} else {
> +		dev_err("copy_from_user() fail\n");
> +		status = -EFAULT;
> +	}
> +
> +	kfree(kbuf);
> +	return status;
> +}
> +
> +static struct file_operations dev_fops = {
> +	.owner = THIS_MODULE,
> +	.open = dev_open,
> +	.release = dev_release,
> +	.read = dev_read,
> +	.write = dev_write,
> +	/*.unlocked_ioctl = dev_ioctl,*/
> +};
> +
> +static struct miscdevice raydium_ts_miscdev = {
> +	.minor = MISC_DYNAMIC_MINOR,
> +	.name = "raydium_ts",
> +	.fops = &dev_fops,
> +};
> +#endif
> +
> +
> +ssize_t show(struct device_driver *drv, char *buff)
> +{
> +	struct i2c_msg xfer_msg;
> +	int num = 10;
> +	char buf[100];
> +	/*int i;*/
> +
> +	xfer_msg.addr = pts->client->addr;
> +	xfer_msg.len = num;
> +	xfer_msg.flags = I2C_M_RD;
> +	xfer_msg.buf = buf;
> +	pts->client->addr = I2C_CLIENT_ADDR;
> +	i2c_transfer(pts->client->adapter, &xfer_msg, 1);
> +
> +	return 0;
> +}
> +
> +ssize_t store(struct device_driver *drv, const char *buf, size_t count)
> +{
> +	/*unsigned char pkt[] = { 0xF2, 5, 1, 1 };*/
> +	unsigned char pkt[] = { 0xF1, 5, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0};
> +
> +	pts->client->addr = I2C_CLIENT_ADDR;
> +	rm31100_ts_write(pts->client, pkt, sizeof(pkt));
> +
> +	return sizeof(pkt);
> +}
> +
> +DRIVER_ATTR(myAttr, 0x777, show, store);
> +
> +static void report_data(struct rm31100_ts *ts, u16 x, u16 y, u8 pressure, u8 id)
> +{
> +	if (ts->pdata->swap_xy)
> +		swap(x, y);
> +
> +	/* handle inverting coordinates */
> +	if (ts->pdata->invert_x)
> +		x = ts->pdata->res_x - x;
> +	if (ts->pdata->invert_y)
> +		y = ts->pdata->res_y - y;
> +/*
> +	input_report_abs(ts->input, ABS_MT_TRACKING_ID, id);
> +	input_report_abs(ts->input, ABS_MT_POSITION_X, x);
> +	input_report_abs(ts->input, ABS_MT_POSITION_Y, y);
> +	input_report_abs(ts->input, ABS_MT_TOUCH_MAJOR, pressure);
> +	input_report_abs(ts->input, ABS_MT_WIDTH_MAJOR, ts->dd->finger_size);
> +	input_mt_sync(ts->input);
> +*/
> +/*For protocol B*/
> +	input_mt_slot(ts->input_dev, id);
> +	input_mt_report_slot_state(ts->input_dev, MT_TOOL_FINGER, true);
> +	input_report_abs(ts->input_dev, ABS_MT_POSITION_X, x);
> +	input_report_abs(ts->input_dev, ABS_MT_POSITION_Y, y);
> +	input_report_abs(ts->input_dev, ABS_MT_PRESSURE, pressure);

We do not need to use both A and B protocols, A is obsolete, please only use B.

> +/*
> +	dev_dbg("%s(): id =%2hhd, x =%4hd, y =%4hd, pressure = %hhd\n",
> +		__func__, id, x, y, pressure);
> +*/
> +}
> +
> +static void process_rm31100_data(struct RM31100_ts *ts)
> +{
> +	u8 id, pressure, touches, i;
> +	u16 x, y;
> +
> +	touches = ts->touch_data[ts->dd->touch_index];
> +
> +	if (touches > 0) {
> +		for (i = 0; i < touches; i++) {
> +			id = ts->touch_data[i * ts->dd->touch_bytes +
> +				ts->dd->id_index];
> +			pressure = ts->touch_data[i * ts->dd->touch_bytes +
> +				ts->dd->z_index];
> +			/*
> +			x = join_bytes(ts->touch_data[i * ts->dd->touch_bytes +
> +				ts->dd->x_index + 1],
> +			ts->touch_data[i * ts->dd->touch_bytes +
> +				ts->dd->x_index]);
> +			y = join_bytes(ts->touch_data[i * ts->dd->touch_bytes +
> +				ts->dd->y_index + 1],
> +			ts->touch_data[i * ts->dd->touch_bytes +
> +				ts->dd->y_index]);
> +			*/
> +			x = get_unaligned_le16(ts->touch_data[i * ts->dd->
> +				touch_bytes + ts->dd->x_index]);
> +			y = get_unaligned_le16(ts->touch_data[i * ts->dd->
> +				touch_bytes + ts->dd->y_index]);
> +			report_data(ts, x, y, pressure, id);
> +		}
> +	} else
> +		input_mt_sync(ts->input);
> +
> +	ts->prev_touches = touches;
> +	input_report_key(ts->input, BTN_TOUCH, 1);
> +	input_sync(ts->input);
> +}
> +
> +static void rm31100_ts_xy_worker(struct work_struct *work)

Please rename now that it's not a worker anymore.

> +{
> +	int rc;
> +	u8 DMAAddress[4];
> +	struct rm31100_ts *ts;
> +#if EVAL_REPORT_RATE
> +	static struct timeval tv_start;
> +	struct timeval tv_now;
> +	static int cnt = -1;
> +	int us;
> +#endif /* EVAL_REPORT_RATE*/
> +
> +	/*dev_dbg("****rm31100_ts_xy_worker******\n");*/
> +	mutex_lock(&ts->sus_lock);
> +	if (ts->is_suspended == true) {
> +		dev_dbg(&ts->client->dev, "TS is supended\n");
> +		ts->int_pending = true;
> +		mutex_unlock(&ts->sus_lock);
> +		return;
> +	}
> +	mutex_unlock(&ts->sus_lock);

Now that we do not need worker to worry about, simply disable interrupt in suspend
and get rid of this checks/locks here.

> +
> +	mutex_lock(&ts->access_lock);
> +	/* read data from DATA_REG */
> +	/*RM31100 DMA Mode*/
> +	/*T010 OR w001+T012*/
> +	DMAAddress[0] = 0x0F;
> +	DMAAddress[1] = 0x00;
> +	DMAAddress[2] = 0x20;
> +	DMAAddress[3] = 0x81;/* Turn on DMA Mode*/

What does it mean "DMA mode"?

> +	ts->client->addr = I2C_DMA_CLIENT_ADDR;
> +	rc = rm31100_ts_write(ts->client, DMAAddress, 0x04);
> +	if (rc < 0) {
> +		dev_err(&ts->client->dev, "write failed\n");
> +		goto schedule;
> +	}
> +	ts->client->addr = I2C_CLIENT_ADDR;

Do we really need to mess up with different I2C addresses here?

> +	rc = rm31100_ts_read(ts->client, ts->dd->data_reg, ts->touch_data,
> +	ts->dd->data_size);
> +
> +	if (rc < 0) {
> +		dev_err(&ts->client->dev, "read failed\n");
> +		goto schedule;
> +	}
> +
> +	if (ts->touch_data[ts->dd->touch_index] == INVALID_DATA)
> +		goto schedule;
> +
> +	/* write to STATUS_REG to release lock */
> +	rc = rm31100_ts_write_reg_u8(ts->client,
> +		ts->dd->status_reg, ts->dd->update_data);
> +	if (rc < 0) {
> +		dev_err(&ts->client->dev, "write failed, try once more\n");
> +
> +		rc = rm31100_ts_write_reg_u8(ts->client,
> +			ts->dd->status_reg, ts->dd->update_data);
> +		if (rc < 0)
> +			dev_err(&ts->client->dev, "write failed, exiting\n");
> +	}
> +
> +	process_rm31100_data(ts);
> +
> +#if EVAL_REPORT_RATE
> +	cnt++;
> +
> +	if (cnt == 0)/* first time this function is executed.*/
> +		do_gettimeofday(&tv_start);
> +	else if (cnt == 100) {
> +		do_gettimeofday(&tv_now);
> +		us = 1000000 * (tv_now.tv_sec - tv_start.tv_sec)
> +			+ tv_now.tv_usec - tv_start.tv_usec;
> +		tv_start.tv_sec = tv_now.tv_sec;
> +		tv_start.tv_usec = tv_now.tv_usec;
> +		cnt = 0;
> +	}
> +#endif /* EVAL_REPORT_RATE*/

Why do we need this?

> +schedule:
> +
> +	mutex_unlock(&ts->access_lock);
> +	/*dev_dbg("****Leave rm31100_ts_xy_worker******\n");*/

Please remove the commented out bits of code used during development.

> +}
> +
> +static irqreturn_t rm31100_ts_irq(int irq, void *dev_id)
> +{
> +	struct rm31100_ts *ts = dev_id;
> +
> +/*For protocol B*/
> +	input_sync(g_input_dev);

Why do we need the sync here for protocol B? This does not make sense.

> +
> +	rm31100_ts_xy_worker(&ts->work);
> +	return IRQ_HANDLED;
> +}
> +
> +static int rm31100_ts_init_ts(struct i2c_client *client, struct rm31100_ts *ts)
> +{
> +	struct input_dev *input_device;
> +	int rc = 0;
> +
> +	ts->dd = &devices[ts->device_id];
> +
> +	if (!ts->pdata->nfingers) {
> +		dev_err(&client->dev, "Touches information not specified\n");
> +		return -EINVAL;
> +	}
> +
> +	if (ts->device_id == rm3110x) {
> +		if (ts->pdata->nfingers > 2) {
> +			dev_err(&client->dev, "Touches >=1 & <= 2\n");
> +			return -EINVAL;
> +		}
> +		ts->dd->data_size = ts->dd->touch_bytes;
> +		ts->dd->touch_index = 0x0;
> +	} else if (ts->device_id == rm31100) {
> +		if (ts->pdata->nfingers > 10) {
> +			dev_err(&client->dev, "Touches >=1 & <= 10\n");
> +			return -EINVAL;
> +		}
> +		ts->dd->data_size = ts->pdata->nfingers * ts->dd->touch_bytes +
> +						ts->dd->touch_meta_data;
> +		ts->dd->touch_index = 0x0;
> +	}
> +	/* w001 */
> +	else {
> +		ts->dd->data_size = ts->pdata->nfingers * ts->dd->touch_bytes +
> +		ts->dd->touch_meta_data;
> +		ts->dd->touch_index = 0x0;
> +	}
> +
> +	ts->touch_data = kzalloc(ts->dd->data_size, GFP_KERNEL);
> +	if (!ts->touch_data) {
> +		pr_err("%s: Unable to allocate memory\n", __func__);
> +		return -ENOMEM;
> +	}
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int rm31100_ts_suspend(struct device *dev)
> +{
> +	struct rm31100_ts *ts = dev_get_drvdata(dev);
> +	int rc = 0, i;
> +
> +	if (device_may_wakeup(dev)) {
> +		/* mark suspend flag */
> +		mutex_lock(&ts->sus_lock);
> +		ts->is_suspended = true;
> +		mutex_unlock(&ts->sus_lock);
> +
> +		enable_irq_wake(ts->pen_irq);
> +	} else {
> +		disable_irq_nosync(ts->pen_irq);

Why nosync?

> +/*For protocol B*/
> +	for (i = 0; i < MAX_REPORT_TOUCHED_POINTS; i++) {
> +		input_mt_slot(ts->input_dev, i);
> +
> +		input_mt_report_slot_state(
> +			ts->input_dev,
> +			MT_TOOL_FINGER, false);
> +
> +		input_report_key(
> +			ts->input_dev,
> +			BTN_TOOL_RUBBER, false);
> +	}
> +	input_sync(ts->input_dev);

This is weird indentation.

> +
> +		if (rc) {
> +			/* missed the worker, write to STATUS_REG to
> +			   acknowledge interrupt */

How would we miss a worker?

> +			rc = rm31100_ts_write_reg_u8(ts->client,
> +				ts->dd->status_reg, ts->dd->update_data);
> +			if (rc < 0) {
> +				dev_err(&ts->client->dev,
> +					"write failed, try once more\n");
> +
> +				rc = rm31100_ts_write_reg_u8(ts->client,
> +					ts->dd->status_reg,
> +					ts->dd->update_data);
> +				if (rc < 0)
> +					dev_err(&ts->client->dev,
> +						"write failed, exiting\n");
> +			}
> +
> +			enable_irq(ts->pen_irq);
> +		}
> +
> +		gpio_free(ts->pdata->irq_gpio);
> +
> +		if (ts->pdata->power_on) {
> +			rc = ts->pdata->power_on(0);
> +			if (rc) {
> +				dev_err(dev, "unable to goto suspend\n");
> +				return rc;
> +			}
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int rm31100_ts_resume(struct device *dev)
> +{
> +	struct rm31100_ts *ts = dev_get_drvdata(dev);
> +
> +	int rc = 0;
> +
> +	if (device_may_wakeup(dev)) {
> +		disable_irq_wake(ts->pen_irq);
> +
> +		mutex_lock(&ts->sus_lock);
> +		ts->is_suspended = false;
> +
> +		if (ts->int_pending == true)
> +			ts->int_pending = false;
> +
> +		mutex_unlock(&ts->sus_lock);
> +
> +	} else {
> +		if (ts->pdata->power_on) {
> +			rc = ts->pdata->power_on(1);
> +			if (rc) {
> +				dev_err(dev, "unable to resume\n");
> +				return rc;
> +			}
> +		}
> +
> +		/* configure touchscreen interrupt gpio */
> +		rc = gpio_request(ts->pdata->irq_gpio, "rm31100_irq_gpio");
> +		if (rc) {
> +			pr_err("%s: unable to request gpio %d\n",
> +				__func__, ts->pdata->irq_gpio);
> +			goto err_power_off;
> +		}
> +		if (ts->pdata->irq_cfg) {
> +			s3c_gpio_cfgpin(ts->pdata->irq_gpio,
> +				ts->pdata->irq_cfg);
> +			s3c_gpio_setpull(ts->pdata->irq_gpio,
> +				S3C_GPIO_PULL_NONE);
> +		}
> +
> +		rc = gpio_direction_input(ts->pdata->irq_gpio);
> +		if (rc) {
> +			pr_err("%s: unable to set direction for gpio %d\n",
> +				__func__, ts->pdata->irq_gpio);
> +			goto err_gpio_free;
> +		}

Why do we need to reconfigure the gpio on resume? Anyway, it should all be done
by board code/OF code.

> +
> +		enable_irq(ts->pen_irq);
> +
> +		/* Clear the status register of the TS controller */
> +		rc = rm31100_ts_write_reg_u8(ts->client,
> +			ts->dd->status_reg, ts->dd->update_data);
> +		if (rc < 0) {
> +			dev_err(&ts->client->dev,
> +				"write failed, try once more\n");
> +
> +			rc = rm31100_ts_write_reg_u8(ts->client,
> +				ts->dd->status_reg,
> +				ts->dd->update_data);
> +			if (rc < 0)
> +				dev_err(&ts->client->dev,
> +					"write failed, exiting\n");
> +		}
> +	}
> +
> +	return 0;
> +err_gpio_free:
> +	gpio_free(ts->pdata->irq_gpio);
> +err_power_off:
> +	if (ts->pdata->power_on)
> +		rc = ts->pdata->power_on(0);
> +	return rc;
> +}
> +
> +static struct dev_pm_ops rm31100_ts_pm_ops = {
> +	.suspend = rm31100_ts_suspend,
> +	.resume = rm31100_ts_resume,
> +};
> +#endif
> +
> +static int rm_input_dev_create(struct rm31100_ts *ts)
> +{
> +	struct input_dev *input_device;
> +	int rc = 0;
> +	ts->prev_touches = 0;
> +
> +	input_device = input_allocate_device();
> +	if (!input_device) {
> +		rc = -ENOMEM;
> +		goto error_alloc_dev;
> +	}
> +
> +	ts->input = input_device;
> +	input_device->name = "raydium_ts"/*ts->pdata->ts_name*/;
> +	input_device->id.bustype = BUS_I2C;
> +	input_device->dev.parent = &client->dev;
> +	input_set_drvdata(input_device, ts);
> +
> +	__set_bit(EV_ABS, input_device->evbit);
> +	__set_bit(INPUT_PROP_DIRECT, input_device->propbit);
> +	/*__set_bit(EV_SYN, input_device->evbit);*/
> +	/*__set_bit(BTN_TOUCH, input_device->keybit);*/
> +
> +
> +	if (ts->device_id == rm31100) {
> +		/* set up virtual key */
> +		__set_bit(EV_KEY, input_device->evbit);
> +		/* set dummy key to make driver work with virtual keys */
> +		input_set_capability(input_device, EV_KEY, KEY_PROG1);

I have no idea what virtual keys are, we are not emitting KEY_PROG1 event
and so we should not be setting this capability.

> +	}
> +	/*For protocol B*/
> +	input_mt_init_slots(input_device,
> +		MAX_REPORT_TOUCHED_POINTS,
> +		0);
> +	input_set_abs_params(input_device, ABS_MT_POSITION_X,
> +		ts->pdata->dis_min_x, ts->pdata->dis_max_x, 0, 0);
> +	input_set_abs_params(input_device, ABS_MT_POSITION_Y,
> +		ts->pdata->dis_min_y, ts->pdata->dis_max_y, 0, 0);
> +	input_set_abs_params(input_device, ABS_MT_PRESSURE,
> +		0, 0xFF, 0, 0);
> +	/*input_set_abs_params(input_device, ABS_MT_TRACKING_ID,
> +			ts->pdata->min_tid, ts->pdata->max_tid, 0, 0);*/
> +	rc = input_register_device(input_device);
> +	if (rc)
> +		goto error_unreg_device;
> +
> +	return 0;
> +
> +error_unreg_device:
> +error_wq_create:
> +	input_free_device(input_device);
> +error_alloc_dev:
> +	kfree(ts->touch_data);

This function did not allocate ts->touch_data, why does it try to free it?

> +	return rc;
> +}
> +
> +static int rm31100_initialize(struct i2c_client *client)
> +{
> +	struct rm31100_ts *ts = i2c_get_clientdata(client);
> +	int rc = 0, retry_cnt = 0, temp_reg;
> +	/* power on the device */
> +	if (ts->pdata->power_on) {
> +		rc = ts->pdata->power_on(1);
> +		if (rc) {
> +			pr_err("%s: Unable to power on the device\n", __func__);
> +			goto error_dev_setup;
> +		}
> +	}
> +
> +	/* read one byte to make sure i2c device exists */
> +	if (ts->device_id == rm3110x)
> +		temp_reg = 0x01;
> +	else if (ts->device_id == rm31100)
> +		temp_reg = 0x00;
> +	else
> +		temp_reg = 0x05;
> +
> +	rc = rm31100_ts_read_reg_u8(client, temp_reg);
> +	if (rc < 0) {
> +		dev_err(&client->dev, "i2c sanity check failed\n");
> +		goto error_power_on;
> +	}
> +
> +	rc = rm31100_ts_init_ts(client, ts);
> +	if (rc < 0) {
> +		dev_err(&client->dev, "rm31100_ts init failed\n");
> +		goto error_mutex_destroy;
> +	}
> +
> +	if (ts->pdata->resout_gpio < 0)
> +		goto config_irq_gpio;

Why do we need resout_gpio? I do not see the driver actually using it.  Also I
do not see config_irq_gpio label defined. Does this driver even compile?

> +
> +	/* configure touchscreen reset out gpio */
> +	rc = gpio_request(ts->pdata->resout_gpio, "rm31100_resout_gpio");
> +	if (rc) {
> +		pr_err("%s: unable to request gpio %d\n",
> +			__func__, ts->pdata->resout_gpio);
> +		goto error_uninit_ts;
> +	}
> +
> +	rc = gpio_direction_output(ts->pdata->resout_gpio, 0);
> +	if (rc) {
> +		pr_err("%s: unable to set direction for gpio %d\n",
> +			__func__, ts->pdata->resout_gpio);
> +		goto error_resout_gpio_dir;
> +	}
> +	/* reset gpio stabilization time */
> +	msleep(20);
> +
> +	return 0;
> +error_resout_gpio_dir:
> +	if (ts->pdata->resout_gpio >= 0)
> +		gpio_free(ts->pdata->resout_gpio);
> +error_uninit_ts:
> +	input_unregister_device(ts->input);
> +	kfree(ts->touch_data);
> +error_mutex_destroy:
> +	mutex_destroy(&ts->sus_lock);
> +	mutex_destroy(&ts->access_lock);
> +error_power_on:
> +/*	if (ts->pdata->power_on)
> +		ts->pdata->power_on(0);*/
> +error_dev_setup:
> +	if (ts->pdata->dev_setup)
> +		ts->pdata->dev_setup(0);
> +
> +}
> +
> +static void rm_initialize_async(void *data, async_cookie_t cookie)
> +{
> +	struct rm31100_ts *ts = data;
> +	struct i2c_client *client = ts->client;
> +	unsigned long irqflags;
> +	int err = 0;
> +
> +	mutex_lock(&ts->sus_lock);
> +
> +	err = rm31100_initialize(client);
> +	if (err < 0) {
> +		dev_err(&client->dev, "probe failed! unbind device.\n");
> +		goto error_free_mem;
> +	}
> +
> +	err = rm_input_dev_create(ts);
> +	if (err) {
> +		dev_err(&client->dev, "%s crated failed, %d\n", __func__, err);
> +		goto err_release;
> +	}
> +
> +	irqflags = client->dev.of_node ? 0 : IRQF_TRIGGER_FALLING;
> +
> +	err = request_threaded_irq(ts->pen_irq, NULL,
> +				   rm31100_ts_irq,
> +				   irqflags | IRQF_ONESHOT,
> +				   ts->client->dev.driver->name, ts);
> +	if (err) {
> +		dev_err(&client->dev, "Failed to register interrupt\n");
> +		goto err_release;
> +	}
> +
> +	mutex_unlock(&ts->sus_lock);
> +
> +	return;
> +err_release:
> +error_free_mem:
> +	kfree(ts);
> +	mutex_unlock(&ts->sus_lock);
> +	rm31100_ts_remove(client);
> +	return;
> +}
> +
> +
> +/*static int __devinit rm31100_ts_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)*/
> +static int rm31100_ts_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)
> +{
> +	struct rm31100_ts *ts;
> +	struct rm3110x_ts_platform_data *pdata = client->dev.platform_data;
> +	int rc/*, temp_reg*/;
> +
> +	if (!pdata) {
> +		dev_err(&client->dev, "platform data is required!\n");
> +		return -EINVAL;
> +	}
> +
> +	if (!i2c_check_functionality(client->adapter,
> +		I2C_FUNC_SMBUS_READ_WORD_DATA)) {
> +		dev_err(&client->dev, "I2C functionality not supported\n");
> +		return -EIO;
> +	}
> +	/* Make sure there is something at this address */
> +	if (i2c_smbus_xfer(client->adapter, client->addr, 0,
> +		I2C_SMBUS_READ, 0, I2C_SMBUS_BYTE, &dummy) < 0)
> +		return -ENODEV;
> +
> +	ts = kzalloc(sizeof(*ts), GFP_KERNEL);
> +	if (!ts)
> +		return -ENOMEM;
> +	pts = ts;
> +
> +	/* Enable runtime PM ops, start in ACTIVE mode */
> +	rc = pm_runtime_set_active(&client->dev);
> +	if (rc < 0)
> +		dev_warn(&client->dev, "unable to set runtime pm state\n");
> +	pm_runtime_enable(&client->dev);
> +
> +	ts->client = client;
> +	ts->pdata = pdata;
> +	i2c_set_clientdata(client, ts);
> +	ts->device_id = id->driver_data;
> +
> +	if (ts->pdata->dev_setup) {
> +		rc = ts->pdata->dev_setup(1);
> +		if (rc < 0) {
> +			dev_err(&client->dev, "dev setup failed\n");
> +			goto error_touch_data_alloc;
> +		}
> +	}
> +
> +
> +	ts->is_suspended = false;
> +	ts->int_pending = false;
> +	mutex_init(&ts->sus_lock);
> +	mutex_init(&ts->access_lock);
> +
> +	async_schedule(rm_initialize_async, ts);

If you want to do async initialization you need to make sure you done before
trying to remove the driver, which you don't. For mainline I'd recommend
sticking to synchronous initialization - we'll have proper async probing done
by driver core soon. 

> +
> +	device_init_wakeup(&client->dev, ts->pdata->wakeup);
> +	return 0;
> +error_reg_misc_dev:
> +error_req_irq_fail:
> +
> +error_resout_gpio_dir:
> +	if (ts->pdata->resout_gpio >= 0)
> +		gpio_free(ts->pdata->resout_gpio);
> +error_uninit_ts:
> +	input_unregister_device(ts->input);
> +	kfree(ts->touch_data);
> +error_mutex_destroy:
> +	mutex_destroy(&ts->sus_lock);
> +	mutex_destroy(&ts->access_lock);
> +error_power_on:
> +/*	if (ts->pdata->power_on)
> +		ts->pdata->power_on(0);*/
> +error_dev_setup:
> +	if (ts->pdata->dev_setup)
> +		ts->pdata->dev_setup(0);
> +error_touch_data_alloc:
> +	pm_runtime_set_suspended(&client->dev);
> +	pm_runtime_disable(&client->dev);
> +	kfree(ts);
> +	return rc;
> +}
> +
> +/*static int __devexit RM31100_ts_remove(struct i2c_client *client)*/
> +static int __exit rm31100_ts_remove(struct i2c_client *client)
> +{
> +	struct rm31100_ts *ts = i2c_get_clientdata(client);
> +
> +	pm_runtime_set_suspended(&client->dev);
> +	pm_runtime_disable(&client->dev);
> +
> +	device_init_wakeup(&client->dev, 0);
> +	free_irq(ts->pen_irq, ts);
> +
> +	gpio_free(ts->pdata->irq_gpio);
> +
> +	if (ts->pdata->resout_gpio >= 0)
> +		gpio_free(ts->pdata->resout_gpio);
> +	input_unregister_device(ts->input);
> +
> +	mutex_destroy(&ts->sus_lock);
> +	mutex_destroy(&ts->access_lock);
> +
> +	if (ts->pdata->power_on)
> +		ts->pdata->power_on(0);
> +
> +	if (ts->pdata->dev_setup)
> +		ts->pdata->dev_setup(0);
> +
> +	kfree(ts->touch_data);
> +	kfree(ts);
> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id rm31100_ts_id[] = {
> +	{"RM31100", rm31100},
> +	{"RM3110x", rm3110x},
> +	{}
> +};
> +MODULE_DEVICE_TABLE(i2c, RM31100_ts_id);
> +
> +
> +static struct i2c_driver rm31100_ts_driver = {
> +	.driver = {
> +		.name = "raydium_ts",/*rm31100_ts*/
> +		.owner = THIS_MODULE,
> +#ifdef CONFIG_PM
> +		.pm = &rm31100_ts_pm_ops,
> +#endif
> +	},
> +	.probe = rm31100_ts_probe,
> +	/*.remove		= __devexit_p(RM31100_ts_remove),*/
> +	.remove = __exit_p(rm31100_ts_remove),

No, it can't be __exit_p() at all.

> +	.id_table = rm31100_ts_id,
> +};
> +
> +static int __init rm31100_ts_init(void)
> +{
> +	int rc;
> +	int rc2;
> +
> +	rc = i2c_add_driver(&rm31100_ts_driver);
> +
> +	rc2 = driver_create_file(&rm31100_ts_driver.driver,
> +		&driver_attr_myAttr);
> +
> +	return rc;
> +}
> +/* Making this as late init to avoid power fluctuations
> + * during LCD initialization.
> + */
> +late_initcall(RM31100_ts_init);

Hmm, this is unusual. Why do you have such big power fluctuations? How will yo
handle the case when both drivers are built as modules?

> +
> +static void __exit rm31100_ts_exit(void)
> +{
> +	return i2c_del_driver(&RM31100_ts_driver);
> +}
> +module_exit(RM31100_ts_exit);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("rm31100-rm3110x touchscreen controller driver");
> +MODULE_AUTHOR("Raydium");
> +MODULE_ALIAS("platform:rm31100_ts");
> diff --git a/include/linux/input/rm31100_ts.h b/include/linux/input/rm31100_ts.h
> new file mode 100644
> index 0000000..2397436
> --- /dev/null
> +++ b/include/linux/input/rm31100_ts.h
> @@ -0,0 +1,60 @@
> +/* Header file for:
> + * Raydium rm31100 Prototype touchscreen driver.
> + *
> + * Copyright (C) 2012, Raydium Semiconductor, Inc.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2, and only version 2, as published by the
> + * Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * Raydium reserves the right to make changes without further notice
> + * to the materials described herein. Raydium does not assume any
> + * liability arising out of the application described herein.
> + *
> + * Contact Raydium Semiconductor at www.rad-ic.com
> + *
> + * History:
> + *			(C) 2012 Raydium - Update for GPL distribution
> + *			(C) 2009 Enea - Original prototype
> + *
> + */
> +#ifndef __RM3110xTS_H__
> +#define __RM3110xTS_H__
> +
> +
> +/* rm3110x platform data
> + */
> +struct rm3110x_ts_platform_data {
> +	int (*power_on)(int on);
> +	int (*dev_setup)(bool on);
> +	const char *ts_name;
> +	u32 dis_min_x; /* display resoltion */
> +	u32 dis_max_x;
> +	u32 dis_min_y;
> +	u32 dis_max_y;
> +	u32 min_touch; /* no.of touches supported */
> +	u32 max_touch;
> +	u32 min_tid; /* track id */
> +	u32 max_tid;
> +	u32 min_width;/* size of the finger */
> +	u32 max_width;
> +	u32 res_x; /* TS resolution */
> +	u32 res_y;

Why do we have separate display and touchscreen resolutions?

> +	u32 swap_xy;
> +	u32 flags;

What are the flags?

> +	u16 invert_x;
> +	u16 invert_y;

This should probable be done by userspace...

> +	u8 nfingers;
> +	u32 irq_gpio;
> +	int resout_gpio;
> +	bool wakeup;
> +	u32 irq_cfg;
> +};
> +
> +#endif
> -- 
> 2.1.2
> 

Thanks.

-- 
Dmitry
