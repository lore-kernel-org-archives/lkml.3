Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbaKSQo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:44:56 -0500
Received: from svenfoo.org ([82.94.215.22]:50937 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066AbaKSQow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:44:52 -0500
Message-ID: <546CC900.8000506@zonque.org>
Date: Wed, 19 Nov 2014 17:44:48 +0100
From: Daniel Mack <daniel@zonque.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "jeffrey.lin" <yajohn@gmail.com>, dmitry.torokhov@gmail.com,
        rydberg@euromail.se, bleung@chromium.org, dh.herrmann@gmail.com,
        charliemooney@chromium.org, floe@butterbrot.org
CC: jeffrey.lin@rad-ic.com, roger.yang@rad-ic.com, KP.li@rad-ic.com,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        "jeffrey.lin" <jeffrey.lin@gmail.com>
Subject: Re: [PATCH] driver: input: touchscreen:  add Raydium i2c touchscreen
 driver
References: <1416411048-23526-1-git-send-email-jeffrey.lin@rad-ic.com>
In-Reply-To: <1416411048-23526-1-git-send-email-jeffrey.lin@rad-ic.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2014 04:30 PM, jeffrey.lin wrote:
> From: "jeffrey.lin" <jeffrey.lin@gmail.com>
> 
> this patch is porting Raydium I2C touch driver. Developer can enable
> raydium touch driver by modifying define "CONFIG_TOUCHSCREEN_RM_TS".
> 
> BUG: None
> TEST: built and test with peppy
> 
> Signed-off-by: jeffrey.lin@rad-ic.com
> Change-Id: I05d54e5ef29249d2a6eae97222c90bed11e839f9
> ---

Just some general remarks that IMO need to be addressed before a more
thorough review can happen:


* Please remove all dead code, such as code in comments and in #if 0
  blocks.

* Use the regmap framework to abstract the hardware access on the I2C
  layer (see drivers/input/keyboard/cap1106.c and many other drivers
  as an example, and check include/linux/regmap.h). That makes the code
  a lot shorter and more comprehensible to read.

* By using request_threaded_irq(), you don't have to manually control
  your worker and can simplify your code quite a bit.

* See if you can claim all the resources the driver needs by using
  devm_* variants.

* Don't use uppercase names for filenames, structs, functions and IDs

* Why do you need a miscdevice for this? Isn't the input event layer
  enough?

* Also, run scripts/checkpatch.pl on the new patch, which will help
  you find some more typical pitfalls.



Thanks,
Daniel


>  drivers/input/touchscreen/Kconfig   |  12 +
>  drivers/input/touchscreen/Makefile  |   1 +
>  drivers/input/touchscreen/RM31100.c | 972 ++++++++++++++++++++++++++++++++++++
>  include/linux/input/RM31100.h       |  60 +++
>  4 files changed, 1045 insertions(+)
>  create mode 100644 drivers/input/touchscreen/RM31100.c
>  create mode 100644 include/linux/input/RM31100.h
> 
> diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
> index 3ce9181..b692036 100644
> --- a/drivers/input/touchscreen/Kconfig
> +++ b/drivers/input/touchscreen/Kconfig
> @@ -98,6 +98,18 @@ config TOUCHSCREEN_ATMEL_MXT
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called atmel_mxt_ts.
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
> +	  module will be called RM31100.
> +
>  config TOUCHSCREEN_AUO_PIXCIR
>  	tristate "AUO in-cell touchscreen using Pixcir ICs"
>  	depends on I2C
> diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
> index 687d5a7..d991815 100644
> --- a/drivers/input/touchscreen/Makefile
> +++ b/drivers/input/touchscreen/Makefile
> @@ -73,6 +73,7 @@ wm97xx-ts-$(CONFIG_TOUCHSCREEN_WM9705)	+= wm9705.o
>  wm97xx-ts-$(CONFIG_TOUCHSCREEN_WM9712)	+= wm9712.o
>  wm97xx-ts-$(CONFIG_TOUCHSCREEN_WM9713)	+= wm9713.o
>  obj-$(CONFIG_TOUCHSCREEN_WM97XX_ATMEL)	+= atmel-wm97xx.o
> +obj-$(CONFIG_TOUCHSCREEN_RM_TS)	+= RM31100.o
>  obj-$(CONFIG_TOUCHSCREEN_WM97XX_MAINSTONE)	+= mainstone-wm97xx.o
>  obj-$(CONFIG_TOUCHSCREEN_WM97XX_ZYLONITE)	+= zylonite-wm97xx.o
>  obj-$(CONFIG_TOUCHSCREEN_W90X900)	+= w90p910_ts.o
> diff --git a/drivers/input/touchscreen/RM31100.c b/drivers/input/touchscreen/RM31100.c
> new file mode 100644
> index 0000000..78cc80d
> --- /dev/null
> +++ b/drivers/input/touchscreen/RM31100.c
> @@ -0,0 +1,972 @@
> +/* Source for:
> + * Raydium RM31100 Prototype touchscreen driver.
> + * drivers/input/touchscreen/RM31100.c
> + *
> + * Copyright (C) 2012,
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
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/i2c.h>
> +#include <linux/input.h>
> +#include <linux/slab.h>
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
> +#include <linux/gpio.h>
> +#include <linux/workqueue.h>
> +#include <linux/mutex.h>
> +#include <linux/delay.h>
> +#include <linux/input/RM31100.h>
> +#include <linux/pm.h>
> +#include <linux/pm_runtime.h>
> +/*#include <plat/gpio-cfg.h>*/
> +#include <linux/miscdevice.h>
> +/*#include <asm/uaccess.h> copy_to_user() */
> +#include <linux/uaccess.h>
> +
> +
> +#if 0/*defined(CONFIG_HAS_EARLYSUSPEND)*/
> +#include <linux/earlysuspend.h>
> +
> +/* Early-suspend level */
> +#define RM31100_TS_SUSPEND_LEVEL 1
> +#endif
> +
> +#define RM31100	    0x0
> +#define RM3110x	    0x1
> +
> +#define INVALID_DATA	0xff
> +
> +#define TOUCHSCREEN_TIMEOUT	(msecs_to_jiffies(10))
> +#define INITIAL_DELAY		(msecs_to_jiffies(25000))
> +
> +#define EVAL_REPORT_RATE    1
> +
> +#define I2C_CLIENT_ADDR         0x39
> +#define I2C_DMA_CLIENT_ADDR     0x5A
> +#undef CONFIG_PM
> +struct RM31100_ts_data {
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
> +static struct RM31100_ts_data devices[] = {
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
> +struct RM31100_ts {
> +	struct i2c_client *client;
> +	struct input_dev *input;
> +	struct delayed_work work;
> +	struct workqueue_struct *wq;
> +	struct RM3110x_ts_platform_data *pdata;
> +	struct RM31100_ts_data *dd;
> +	u8 *touch_data;
> +	u8 device_id;
> +	u8 prev_touches;
> +	bool is_suspended;
> +	bool int_pending;
> +	struct mutex sus_lock;
> +	struct mutex access_lock;
> +	u32 pen_irq;
> +#if 0/*defined(CONFIG_HAS_EARLYSUSPEND)*/
> +	struct early_suspend early_suspend;
> +#endif
> +};
> +
> +struct RM31100_ts *pts;
> +
> +static inline u16 join_bytes(u8 a, u8 b)
> +{
> +	u16 ab = 0;
> +	ab = ab | a;
> +	ab = ab << 8 | b;
> +	return ab;
> +}
> +
> +static s32 RM31100_ts_write_reg_u8(struct i2c_client *client, u8 reg, u8 val)
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
> +static s32 RM31100_ts_read_reg_u8(struct i2c_client *client, u8 reg)
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
> +static int RM31100_ts_read(struct i2c_client *client, u8 reg, u8 *buf, int num)
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
> +static int RM31100_ts_write(struct i2c_client *client, u8 *buf, int num)
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
> +
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
> +		if (RM31100_ts_write(pts->client, kbuf, count) < 0)
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
> +
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
> +	RM31100_ts_write(pts->client, pkt, sizeof(pkt));
> +
> +	return sizeof(pkt);
> +}
> +
> +DRIVER_ATTR(myAttr, 0x777, show, store);
> +
> +static void report_data(struct RM31100_ts *ts, u16 x, u16 y, u8 pressure, u8 id)
> +{
> +	if (ts->pdata->swap_xy)
> +		swap(x, y);
> +
> +	/* handle inverting coordinates */
> +	if (ts->pdata->invert_x)
> +		x = ts->pdata->res_x - x;
> +	if (ts->pdata->invert_y)
> +		y = ts->pdata->res_y - y;
> +
> +	input_report_abs(ts->input, ABS_MT_TRACKING_ID, id);
> +	input_report_abs(ts->input, ABS_MT_POSITION_X, x);
> +	input_report_abs(ts->input, ABS_MT_POSITION_Y, y);
> +	input_report_abs(ts->input, ABS_MT_TOUCH_MAJOR, pressure);
> +	input_report_abs(ts->input, ABS_MT_WIDTH_MAJOR, ts->dd->finger_size);
> +	input_mt_sync(ts->input);
> +
> +	/*dev_dbg("%s(): id =%2hhd, x =%4hd, y =%4hd, pressure = %hhd\n",
> +		__func__, id, x, y, pressure);*/
> +}
> +
> +static void process_RM31100_data(struct RM31100_ts *ts)
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
> +			x = join_bytes(ts->touch_data[i * ts->dd->touch_bytes +
> +				ts->dd->x_index + 1],
> +			ts->touch_data[i * ts->dd->touch_bytes +
> +				ts->dd->x_index]);
> +			y = join_bytes(ts->touch_data[i * ts->dd->touch_bytes +
> +				ts->dd->y_index + 1],
> +			ts->touch_data[i * ts->dd->touch_bytes +
> +				ts->dd->y_index]);
> +			report_data(ts, x, y, pressure, id);
> +		}
> +	} else
> +		input_mt_sync(ts->input);
> +
> +#if 0
> +	for (i = 0; i < ts->prev_touches - (char)touches; i++) {
> +		input_report_abs(ts->input, ABS_MT_TOUCH_MAJOR, 0);
> +		input_report_abs(ts->input, ABS_MT_WIDTH_MAJOR, 0);
> +		input_mt_sync(ts->input);
> +	}
> +#endif
> +
> +	ts->prev_touches = touches;
> +	input_report_key(ts->input, BTN_TOUCH, 1);
> +	input_sync(ts->input);
> +}
> +
> +static void RM31100_ts_xy_worker(struct work_struct *work)
> +{
> +	int rc;
> +	u8 DMAAddress[4];
> +	struct RM31100_ts *ts;
> +#if EVAL_REPORT_RATE
> +	static struct timeval tv_start;
> +	struct timeval tv_now;
> +	static int cnt = -1;
> +	int us;
> +#endif /* EVAL_REPORT_RATE*/
> +
> +
> +	ts = container_of(work, struct RM31100_ts,
> +		work.work);
> +	/*dev_dbg("****RM31100_ts_xy_worker******\n");*/
> +	mutex_lock(&ts->sus_lock);
> +	if (ts->is_suspended == true) {
> +		dev_dbg(&ts->client->dev, "TS is supended\n");
> +		ts->int_pending = true;
> +		mutex_unlock(&ts->sus_lock);
> +		return;
> +	}
> +	mutex_unlock(&ts->sus_lock);
> +
> +	mutex_lock(&ts->access_lock);
> +	/* read data from DATA_REG */
> +	/*RM31100 DMA Mode*/
> +#if 1 /*T010 OR w001+T012*/
> +	DMAAddress[0] = 0x0F;
> +	DMAAddress[1] = 0x00;
> +	DMAAddress[2] = 0x20;
> +	DMAAddress[3] = 0x81;/* Turn on DMA Mode*/
> +	ts->client->addr = I2C_DMA_CLIENT_ADDR;
> +	rc = RM31100_ts_write(ts->client, DMAAddress, 0x04);
> +	if (rc < 0) {
> +		dev_err(&ts->client->dev, "write failed\n");
> +		goto schedule;
> +	}
> +	ts->client->addr = I2C_CLIENT_ADDR;
> +	rc = RM31100_ts_read(ts->client, ts->dd->data_reg, ts->touch_data,
> +	ts->dd->data_size);
> +#endif
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
> +	rc = RM31100_ts_write_reg_u8(ts->client,
> +		ts->dd->status_reg, ts->dd->update_data);
> +	if (rc < 0) {
> +		dev_err(&ts->client->dev, "write failed, try once more\n");
> +
> +		rc = RM31100_ts_write_reg_u8(ts->client,
> +			ts->dd->status_reg, ts->dd->update_data);
> +		if (rc < 0)
> +			dev_err(&ts->client->dev, "write failed, exiting\n");
> +	}
> +
> +	process_RM31100_data(ts);
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
> +schedule:
> +
> +	mutex_unlock(&ts->access_lock);
> +	/*dev_dbg("****Leave RM31100_ts_xy_worker******\n");*/
> +	enable_irq(ts->pen_irq);
> +}
> +
> +static irqreturn_t RM31100_ts_irq(int irq, void *dev_id)
> +{
> +	struct RM31100_ts *ts = dev_id;
> +
> +	disable_irq_nosync(irq);
> +
> +	queue_delayed_work(ts->wq, &ts->work, 0);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int RM31100_ts_init_ts(struct i2c_client *client, struct RM31100_ts *ts)
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
> +	if (ts->device_id == RM3110x) {
> +		if (ts->pdata->nfingers > 2) {
> +			dev_err(&client->dev, "Touches >=1 & <= 2\n");
> +			return -EINVAL;
> +		}
> +		ts->dd->data_size = ts->dd->touch_bytes;
> +		ts->dd->touch_index = 0x0;
> +	} else if (ts->device_id == RM31100) {
> +		if (ts->pdata->nfingers > 10) {
> +			dev_err(&client->dev, "Touches >=1 & <= 10\n");
> +			return -EINVAL;
> +		}
> +		ts->dd->data_size = ts->pdata->nfingers * ts->dd->touch_bytes +
> +						ts->dd->touch_meta_data;
> +		ts->dd->touch_index = 0x0;
> +	}
> +#if 1 /* w001 */
> +	else {
> +		ts->dd->data_size = ts->pdata->nfingers * ts->dd->touch_bytes +
> +		ts->dd->touch_meta_data;
> +		ts->dd->touch_index = 0x0;
> +	}
> +#endif
> +	ts->touch_data = kzalloc(ts->dd->data_size, GFP_KERNEL);
> +	if (!ts->touch_data) {
> +		pr_err("%s: Unable to allocate memory\n", __func__);
> +		return -ENOMEM;
> +	}
> +
> +	ts->prev_touches = 0;
> +
> +	input_device = input_allocate_device();
> +	if (!input_device) {
> +		rc = -ENOMEM;
> +		goto error_alloc_dev;
> +	}
> +
> +	ts->input = input_device;
> +	input_device->name = ts->pdata->ts_name;
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
> +	if (ts->device_id == RM31100) {
> +		/* set up virtual key */
> +		__set_bit(EV_KEY, input_device->evbit);
> +		/* set dummy key to make driver work with virtual keys */
> +		input_set_capability(input_device, EV_KEY, KEY_PROG1);
> +	}
> +
> +	input_set_abs_params(input_device, ABS_MT_POSITION_X,
> +			ts->pdata->dis_min_x, ts->pdata->dis_max_x, 0, 0);
> +	input_set_abs_params(input_device, ABS_MT_POSITION_Y,
> +			ts->pdata->dis_min_y, ts->pdata->dis_max_y, 0, 0);
> +#if 0
> +	input_set_abs_params(input_device, ABS_MT_TOUCH_MAJOR,
> +			ts->pdata->min_touch, ts->pdata->max_touch, 0, 0);
> +	input_set_abs_params(input_device, ABS_MT_WIDTH_MAJOR,
> +			ts->pdata->min_width, ts->pdata->max_width, 0, 0);
> +#endif
> +	input_set_abs_params(input_device, ABS_MT_TRACKING_ID,
> +			ts->pdata->min_tid, ts->pdata->max_tid, 0, 0);
> +
> +	ts->wq = create_singlethread_workqueue("kworkqueue_ts");
> +	if (!ts->wq) {
> +		dev_err(&client->dev, "Could not create workqueue\n");
> +		goto error_wq_create;
> +	}
> +
> +	INIT_DELAYED_WORK(&ts->work, RM31100_ts_xy_worker);
> +
> +	rc = input_register_device(input_device);
> +	if (rc)
> +		goto error_unreg_device;
> +
> +	return 0;
> +
> +error_unreg_device:
> +	destroy_workqueue(ts->wq);
> +error_wq_create:
> +	input_free_device(input_device);
> +error_alloc_dev:
> +	kfree(ts->touch_data);
> +	return rc;
> +}
> +
> +#ifdef CONFIG_PM
> +static int RM31100_ts_suspend(struct device *dev)
> +{
> +	struct RM31100_ts *ts = dev_get_drvdata(dev);
> +	int rc = 0;
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
> +
> +		rc = cancel_delayed_work_sync(&ts->work);
> +
> +		if (rc) {
> +			/* missed the worker, write to STATUS_REG to
> +			   acknowledge interrupt */
> +			rc = RM31100_ts_write_reg_u8(ts->client,
> +				ts->dd->status_reg, ts->dd->update_data);
> +			if (rc < 0) {
> +				dev_err(&ts->client->dev,
> +					"write failed, try once more\n");
> +
> +				rc = RM31100_ts_write_reg_u8(ts->client,
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
> +static int RM31100_ts_resume(struct device *dev)
> +{
> +	struct RM31100_ts *ts = dev_get_drvdata(dev);
> +
> +	int rc = 0;
> +
> +	if (device_may_wakeup(dev)) {
> +		disable_irq_wake(ts->pen_irq);
> +
> +		mutex_lock(&ts->sus_lock);
> +		ts->is_suspended = false;
> +
> +		if (ts->int_pending == true) {
> +			ts->int_pending = false;
> +
> +			/* start a delayed work */
> +			queue_delayed_work(ts->wq, &ts->work, 0);
> +		}
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
> +		rc = gpio_request(ts->pdata->irq_gpio, "RM31100_irq_gpio");
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
> +
> +		enable_irq(ts->pen_irq);
> +
> +		/* Clear the status register of the TS controller */
> +		rc = RM31100_ts_write_reg_u8(ts->client,
> +			ts->dd->status_reg, ts->dd->update_data);
> +		if (rc < 0) {
> +			dev_err(&ts->client->dev,
> +				"write failed, try once more\n");
> +
> +			rc = RM31100_ts_write_reg_u8(ts->client,
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
> +#if 0/*def CONFIG_HAS_EARLYSUSPEND*/
> +static void RM31100_ts_early_suspend(struct early_suspend *h)
> +{
> +	struct RM31100_ts *ts =
> +		container_of(h, struct RM31100_ts, early_suspend);
> +
> +	RM31100_ts_suspend(&ts->client->dev);
> +}
> +
> +static void RM31100_ts_late_resume(struct early_suspend *h)
> +{
> +	struct RM31100_ts *ts = container_of(h,
> +		struct RM31100_ts, early_suspend);
> +
> +	RM31100_ts_resume(&ts->client->dev);
> +}
> +#endif
> +
> +static struct dev_pm_ops RM31100_ts_pm_ops = {
> +/*#ifndef CONFIG_HAS_EARLYSUSPEND*/
> +	.suspend = RM31100_ts_suspend,
> +	.resume = RM31100_ts_resume,
> +/*#endif*/
> +};
> +#endif
> +
> +/*static int __devinit RM31100_ts_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)*/
> +static int __init RM31100_ts_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)
> +{
> +	struct RM31100_ts *ts;
> +	struct RM3110x_ts_platform_data *pdata = client->dev.platform_data;
> +	int rc, temp_reg;
> +
> +	if (!pdata) {
> +		dev_err(&client->dev, "platform data is required!\n");
> +		return -EINVAL;
> +	}
> +	if (!i2c_check_functionality(client->adapter,
> +				     I2C_FUNC_SMBUS_READ_WORD_DATA)) {
> +		dev_err(&client->dev, "I2C functionality not supported\n");
> +		return -EIO;
> +	}
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
> +	if (id->driver_data == RM3110x)
> +		temp_reg = 0x01;
> +	else if (id->driver_data == RM31100)
> +		temp_reg = 0x00;
> +	else
> +		temp_reg = 0x05;
> +
> +	rc = RM31100_ts_read_reg_u8(client, temp_reg);
> +	if (rc < 0) {
> +		dev_err(&client->dev, "i2c sanity check failed\n");
> +		goto error_power_on;
> +	}
> +
> +	ts->is_suspended = false;
> +	ts->int_pending = false;
> +	mutex_init(&ts->sus_lock);
> +	mutex_init(&ts->access_lock);
> +
> +	rc = RM31100_ts_init_ts(client, ts);
> +	if (rc < 0) {
> +		dev_err(&client->dev, "RM31100 init failed\n");
> +		goto error_mutex_destroy;
> +	}
> +
> +	if (ts->pdata->resout_gpio < 0)
> +		goto config_irq_gpio;
> +
> +	/* configure touchscreen reset out gpio */
> +	rc = gpio_request(ts->pdata->resout_gpio, "RM31100_resout_gpio");
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
> +config_irq_gpio:
> +	/* configure touchscreen interrupt gpio */
> +	rc = gpio_request(ts->pdata->irq_gpio, "RM31100_irq_gpio");
> +	if (rc) {
> +		pr_err("%s: unable to request gpio %d\n",
> +			__func__, ts->pdata->irq_gpio);
> +		goto error_irq_gpio_req;
> +	}
> +
> +	rc = gpio_direction_input(ts->pdata->irq_gpio);
> +	if (rc) {
> +		pr_err("%s: unable to set direction for gpio %d\n",
> +			__func__, ts->pdata->irq_gpio);
> +		goto error_irq_gpio_dir;
> +	}
> +
> +	ts->pen_irq = gpio_to_irq(ts->pdata->irq_gpio);
> +	rc = request_irq(ts->pen_irq, RM31100_ts_irq,
> +				IRQF_TRIGGER_FALLING,
> +				ts->client->dev.driver->name, ts);
> +	if (rc) {
> +		dev_err(&ts->client->dev, "could not request irq\n");
> +		goto error_req_irq_fail;
> +	}
> +
> +	device_init_wakeup(&client->dev, ts->pdata->wakeup);
> +
> +#if 0/*def CONFIG_HAS_EARLYSUSPEND*/
> +	ts->early_suspend.level = EARLY_SUSPEND_LEVEL_BLANK_SCREEN +
> +						RM31100_TS_SUSPEND_LEVEL;
> +	ts->early_suspend.suspend = RM31100_ts_early_suspend;
> +	ts->early_suspend.resume = RM31100_ts_late_resume;
> +	register_early_suspend(&ts->early_suspend);
> +#endif
> +
> +	rc = misc_register(&raydium_ts_miscdev);
> +	if (rc) {
> +		dev_err(&ts->client->dev,
> +		"Raydium TS: cannot register miscdev:%d\n", rc);
> +		goto error_reg_misc_dev;
> +	}
> +
> +
> +	return 0;
> +error_reg_misc_dev:
> +error_req_irq_fail:
> +error_irq_gpio_dir:
> +	gpio_free(ts->pdata->irq_gpio);
> +error_irq_gpio_req:
> +error_resout_gpio_dir:
> +	if (ts->pdata->resout_gpio >= 0)
> +		gpio_free(ts->pdata->resout_gpio);
> +error_uninit_ts:
> +	destroy_workqueue(ts->wq);
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
> +static int __exit RM31100_ts_remove(struct i2c_client *client)
> +{
> +	struct RM31100_ts *ts = i2c_get_clientdata(client);
> +
> +#if 0/* defined(CONFIG_HAS_EARLYSUSPEND)*/
> +	unregister_early_suspend(&ts->early_suspend);
> +#endif
> +	pm_runtime_set_suspended(&client->dev);
> +	pm_runtime_disable(&client->dev);
> +
> +	device_init_wakeup(&client->dev, 0);
> +
> +	cancel_delayed_work_sync(&ts->work);
> +
> +	free_irq(ts->pen_irq, ts);
> +
> +	gpio_free(ts->pdata->irq_gpio);
> +
> +	if (ts->pdata->resout_gpio >= 0)
> +		gpio_free(ts->pdata->resout_gpio);
> +
> +	destroy_workqueue(ts->wq);
> +
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
> +static const struct i2c_device_id RM31100_ts_id[] = {
> +	{"RM31100", RM31100},
> +	{"RM3110x", RM3110x},
> +	{}
> +};
> +MODULE_DEVICE_TABLE(i2c, RM31100_ts_id);
> +
> +
> +static struct i2c_driver RM31100_ts_driver = {
> +	.driver = {
> +		.name = "RM31100_ts",
> +		.owner = THIS_MODULE,
> +#ifdef CONFIG_PM
> +		.pm = &RM31100_ts_pm_ops,
> +#endif
> +	},
> +	.probe = RM31100_ts_probe,
> +	/*.remove		= __devexit_p(RM31100_ts_remove),*/
> +	.remove = __exit_p(RM31100_ts_remove),
> +	.id_table = RM31100_ts_id,
> +};
> +
> +static int __init RM31100_ts_init(void)
> +{
> +	int rc;
> +	int rc2;
> +
> +	rc = i2c_add_driver(&RM31100_ts_driver);
> +
> +	rc2 = driver_create_file(&RM31100_ts_driver.driver,
> +		&driver_attr_myAttr);
> +
> +	return rc;
> +}
> +/* Making this as late init to avoid power fluctuations
> + * during LCD initialization.
> + */
> +late_initcall(RM31100_ts_init);
> +
> +static void __exit RM31100_ts_exit(void)
> +{
> +	return i2c_del_driver(&RM31100_ts_driver);
> +}
> +module_exit(RM31100_ts_exit);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("RM31100-RM3110x touchscreen controller driver");
> +MODULE_AUTHOR("Raydium");
> +MODULE_ALIAS("platform:RM31100_ts");
> diff --git a/include/linux/input/RM31100.h b/include/linux/input/RM31100.h
> new file mode 100644
> index 0000000..714a14b
> --- /dev/null
> +++ b/include/linux/input/RM31100.h
> @@ -0,0 +1,60 @@
> +/* Header file for:
> + * Raydium RM31100 Prototype touchscreen driver.
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
> +/* RM3110x platform data
> + */
> +struct RM3110x_ts_platform_data {
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
> +	u32 swap_xy;
> +	u32 flags;
> +	u16 invert_x;
> +	u16 invert_y;
> +	u8 nfingers;
> +	u32 irq_gpio;
> +	int resout_gpio;
> +	bool wakeup;
> +	u32 irq_cfg;
> +};
> +
> +#endif
> 

