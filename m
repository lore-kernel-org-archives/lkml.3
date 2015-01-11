Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbbAKNxD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 08:53:03 -0500
Received: from mga02.intel.com ([134.134.136.20]:47082 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbbAKNxA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 08:53:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,737,1413270000"; 
   d="scan'208";a="668005601"
From: "Tirdea, Irina" <irina.tirdea@intel.com>
To: Jonathan Cameron <jic23@kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Dogaru, Vlad" <vlad.dogaru@intel.com>,
        "Baluta, Daniel" <daniel.baluta@intel.com>,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        "Peter Meerwald" <pmeerw@pmeerw.net>
Subject: RE: [PATCH 7/8] iio: accel: mma9551: split driver to expose mma955x
 api
Thread-Topic: [PATCH 7/8] iio: accel: mma9551: split driver to expose
 mma955x api
Thread-Index: AQHQJbHq0K48SO2YrUmhFj3gEaz9h5y6/shg
Date: Sun, 11 Jan 2015 13:52:54 +0000
Deferred-Delivery: Sun, 11 Jan 2015 13:52:00 +0000
Message-ID: <1F3AC3675D538145B1661F571FE1805F199FDDFA@irsmsx105.ger.corp.intel.com>
References: <1419029879-12024-1-git-send-email-irina.tirdea@intel.com>
 <1419029879-12024-8-git-send-email-irina.tirdea@intel.com>
 <54A52859.5000802@kernel.org>
In-Reply-To: <54A52859.5000802@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.181]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jonathan Cameron [mailto:jic23@kernel.org]
> Sent: 01 January, 2015 12:59
> To: Tirdea, Irina; linux-iio@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; Dogaru, Vlad; Baluta, Daniel; Hartmut Knaack; Lars-Peter Clausen; Peter Meerwald
> Subject: Re: [PATCH 7/8] iio: accel: mma9551: split driver to expose mma955x api
> 
> On 19/12/14 22:57, Irina Tirdea wrote:
> > Freescale has the MMA955xL family of devices that use the
> > same communication protocol (based on i2c messages):
> > http://www.freescale.com/files/sensors/doc/data_sheet/MMA955xL.pdf.
> >
> > To support more devices from this family, we need to split the
> > mma9551 driver so we can export the common functions that will
> > be used by other mma955x drivers.
> >
> > Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
> > Reviewed-by: Vlad Dogaru <vlad.dogaru@intel.com>
> Sorry, didn't get this far the other day.
> 
> Anyhow, other than a query on the depends and a suggestion that some
> documentation of locking semantics might be good (perhaps in some
> general kernel doc for the exported functions) - this looks good to
> me.
> 
> Jonathan
> > ---
> >  drivers/iio/accel/Kconfig        |    6 +
> >  drivers/iio/accel/Makefile       |    4 +-
> >  drivers/iio/accel/mma9551.c      |  443 +-------------------------------------
> >  drivers/iio/accel/mma9551_core.c |  443 ++++++++++++++++++++++++++++++++++++++
> >  drivers/iio/accel/mma9551_core.h |   74 +++++++
> >  5 files changed, 530 insertions(+), 440 deletions(-)
> >  create mode 100644 drivers/iio/accel/mma9551_core.c
> >  create mode 100644 drivers/iio/accel/mma9551_core.h
> >
> > diff --git a/drivers/iio/accel/Kconfig b/drivers/iio/accel/Kconfig
> > index d80616d..0600798 100644
> > --- a/drivers/iio/accel/Kconfig
> > +++ b/drivers/iio/accel/Kconfig
> > @@ -105,9 +105,15 @@ config KXCJK1013
> >  	  To compile this driver as a module, choose M here: the module will
> >  	  be called kxcjk-1013.
> >
> > +config MMA9551_CORE
> > +	tristate
> > +	depends on MMA9551
> Why depend here?  THis isn't visible (due to lack of help) and in theory
> an out of tree driver might want to use it.  Hence don't think you want this.

Right. Will remove this.

> > +
> >  config MMA9551
> >  	tristate "Freescale MMA9551L Intelligent Motion-Sensing Platform Driver"
> >  	depends on I2C
> > +	select MMA9551_CORE
> > +
> >  	help
> >  	  Say yes here to build support for the Freescale MMA9551L
> >  	  Intelligent Motion-Sensing Platform Driver.
> > diff --git a/drivers/iio/accel/Makefile b/drivers/iio/accel/Makefile
> > index de5b9cb..8105316 100644
> > --- a/drivers/iio/accel/Makefile
> > +++ b/drivers/iio/accel/Makefile
> > @@ -9,7 +9,9 @@ obj-$(CONFIG_HID_SENSOR_ACCEL_3D) += hid-sensor-accel-3d.o
> >  obj-$(CONFIG_KXCJK1013) += kxcjk-1013.o
> >  obj-$(CONFIG_KXSD9)	+= kxsd9.o
> >  obj-$(CONFIG_MMA8452)	+= mma8452.o
> > -obj-$(CONFIG_MMA9551)	+= mma9551.o
> > +
> > +obj-$(CONFIG_MMA9551_CORE)	+= mma9551_core.o
> > +obj-$(CONFIG_MMA9551)		+= mma9551.o
> >
> >  obj-$(CONFIG_IIO_ST_ACCEL_3AXIS) += st_accel.o
> >  st_accel-y := st_accel_core.o
> > diff --git a/drivers/iio/accel/mma9551.c b/drivers/iio/accel/mma9551.c
> > index 34ee9d6..6031b5a 100644
> > --- a/drivers/iio/accel/mma9551.c
> > +++ b/drivers/iio/accel/mma9551.c
> > @@ -23,63 +23,13 @@
> >  #include <linux/iio/sysfs.h>
> >  #include <linux/iio/events.h>
> >  #include <linux/pm_runtime.h>
> > +#include "mma9551_core.h"
> >
> >  #define MMA9551_DRV_NAME		"mma9551"
> >  #define MMA9551_IRQ_NAME		"mma9551_event"
> >  #define MMA9551_GPIO_NAME		"mma9551_int"
> >  #define MMA9551_GPIO_COUNT		4
> >
> > -/* Applications IDs */
> > -#define MMA9551_APPID_VERSION		0x00
> > -#define MMA9551_APPID_GPIO		0x03
> > -#define MMA9551_APPID_AFE		0x06
> > -#define MMA9551_APPID_TILT		0x0B
> > -#define MMA9551_APPID_SLEEP_WAKE	0x12
> > -#define MMA9551_APPID_RESET		0x17
> > -#define MMA9551_APPID_NONE		0xff
> > -
> > -/* Command masks for mailbox write command */
> > -#define MMA9551_CMD_READ_VERSION_INFO	0x00
> > -#define MMA9551_CMD_READ_CONFIG		0x10
> > -#define MMA9551_CMD_WRITE_CONFIG	0x20
> > -#define MMA9551_CMD_READ_STATUS		0x30
> > -
[...]
> > diff --git a/drivers/iio/accel/mma9551_core.c b/drivers/iio/accel/mma9551_core.c
> > new file mode 100644
> > index 0000000..cab481b
> > --- /dev/null
> > +++ b/drivers/iio/accel/mma9551_core.c
> > @@ -0,0 +1,443 @@
> > +/*
> > + * Common code for Freescale MMA955x Intelligent Sensor Platform drivers
> > + * Copyright (c) 2014, Intel Corporation.
> > + *
> > + * This program is free software; you can redistribute it and/or modify it
> > + * under the terms and conditions of the GNU General Public License,
> > + * version 2, as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope it will be useful, but WITHOUT
> > + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> > + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> > + * more details.
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/i2c.h>
> > +#include <linux/delay.h>
> > +#include <linux/iio/iio.h>
> > +#include <linux/pm_runtime.h>
> > +#include "mma9551_core.h"
> > +
> > +/* Command masks for mailbox write command */
> > +#define MMA9551_CMD_READ_VERSION_INFO	0x00
> > +#define MMA9551_CMD_READ_CONFIG		0x10
> > +#define MMA9551_CMD_WRITE_CONFIG	0x20
> > +#define MMA9551_CMD_READ_STATUS		0x30
> > +
> > +/* Mailbox read command */
> > +#define MMA9551_RESPONSE_COCO		BIT(7)
> > +
> > +/* Error-Status codes returned in mailbox read command */
> > +#define MMA9551_MCI_ERROR_NONE			0x00
> > +#define MMA9551_MCI_ERROR_PARAM			0x04
> > +#define MMA9551_MCI_INVALID_COUNT		0x19
> > +#define MMA9551_MCI_ERROR_COMMAND		0x1C
> > +#define MMA9551_MCI_ERROR_INVALID_LENGTH	0x21
> > +#define MMA9551_MCI_ERROR_FIFO_BUSY		0x22
> > +#define MMA9551_MCI_ERROR_FIFO_ALLOCATED	0x23
> > +#define MMA9551_MCI_ERROR_FIFO_OVERSIZE		0x24
> > +
> > +/* GPIO Application */
> > +#define MMA9551_GPIO_POL_MSB		0x08
> > +#define MMA9551_GPIO_POL_LSB		0x09
> > +
> > +/* Sleep/Wake application */
> > +#define MMA9551_SLEEP_CFG		0x06
> > +#define MMA9551_SLEEP_CFG_SNCEN		BIT(0)
> > +#define MMA9551_SLEEP_CFG_FLEEN		BIT(1)
> > +#define MMA9551_SLEEP_CFG_SCHEN		BIT(2)
> > +
> > +/* AFE application */
> > +#define MMA9551_AFE_X_ACCEL_REG		0x00
> > +#define MMA9551_AFE_Y_ACCEL_REG		0x02
> > +#define MMA9551_AFE_Z_ACCEL_REG		0x04
> > +
> > +/*
> > + * A response is composed of:
> > + * - control registers: MB0-3
> > + * - data registers: MB4-31
> > + *
> > + * A request is composed of:
> > + * - mbox to write to (always 0)
> > + * - control registers: MB1-4
> > + * - data registers: MB5-31
> > + */
> > +#define MMA9551_MAILBOX_CTRL_REGS	4
> > +#define MMA9551_MAX_MAILBOX_DATA_REGS	28
> > +#define MMA9551_MAILBOX_REGS		32
> > +
> > +#define MMA9551_I2C_READ_RETRIES	5
> > +#define MMA9551_I2C_READ_DELAY	50	/* us */
> > +
> > +struct mma9551_mbox_request {
> > +	u8 start_mbox;		/* Always 0. */
> > +	u8 app_id;
> > +	/*
> > +	 * See Section 5.3.1 of the MMA955xL Software Reference Manual.
> > +	 *
> > +	 * Bit 7: reserved, always 0
> > +	 * Bits 6-4: command
> > +	 * Bits 3-0: upper bits of register offset
> > +	 */
> > +	u8 cmd_off;
> > +	u8 lower_off;
> > +	u8 nbytes;
> > +	u8 buf[MMA9551_MAX_MAILBOX_DATA_REGS - 1];
> > +} __packed;
> > +
> > +struct mma9551_mbox_response {
> > +	u8 app_id;
> > +	/*
> > +	 * See Section 5.3.3 of the MMA955xL Software Reference Manual.
> > +	 *
> > +	 * Bit 7: COCO
> > +	 * Bits 6-0: Error code.
> > +	 */
> > +	u8 coco_err;
> > +	u8 nbytes;
> > +	u8 req_bytes;
> > +	u8 buf[MMA9551_MAX_MAILBOX_DATA_REGS];
> > +} __packed;
> > +
> > +static int mma9551_transfer(struct i2c_client *client,
> > +			    u8 app_id, u8 command, u16 offset,
> > +			    u8 *inbytes, int num_inbytes,
> > +			    u8 *outbytes, int num_outbytes)
> > +{
> > +	struct mma9551_mbox_request req;
> > +	struct mma9551_mbox_response rsp;
> > +	struct i2c_msg in, out;
> > +	u8 req_len, err_code;
> > +	int ret, retries;
> > +
> > +	if (offset >= 1 << 12) {
> > +		dev_err(&client->dev, "register offset too large\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	req_len = 1 + MMA9551_MAILBOX_CTRL_REGS + num_inbytes;
> > +	req.start_mbox = 0;
> > +	req.app_id = app_id;
> > +	req.cmd_off = command | (offset >> 8);
> > +	req.lower_off = offset;
> > +
> > +	if (command == MMA9551_CMD_WRITE_CONFIG)
> > +		req.nbytes = num_inbytes;
> > +	else
> > +		req.nbytes = num_outbytes;
> > +	if (num_inbytes)
> > +		memcpy(req.buf, inbytes, num_inbytes);
> > +
> > +	out.addr = client->addr;
> > +	out.flags = 0;
> > +	out.len = req_len;
> > +	out.buf = (u8 *)&req;
> > +
> > +	ret = i2c_transfer(client->adapter, &out, 1);
> > +	if (ret < 0) {
> > +		dev_err(&client->dev, "i2c write failed\n");
> > +		return ret;
> > +	}
> > +
> > +	retries = MMA9551_I2C_READ_RETRIES;
> > +	do {
> > +		udelay(MMA9551_I2C_READ_DELAY);
> > +
> > +		in.addr = client->addr;
> > +		in.flags = I2C_M_RD;
> > +		in.len = sizeof(rsp);
> > +		in.buf = (u8 *)&rsp;
> > +
> > +		ret = i2c_transfer(client->adapter, &in, 1);
> > +		if (ret < 0) {
> > +			dev_err(&client->dev, "i2c read failed\n");
> > +			return ret;
> > +		}
> > +
> > +		if (rsp.coco_err & MMA9551_RESPONSE_COCO)
> > +			break;
> > +	} while (--retries > 0);
> > +
> > +	if (retries == 0) {
> > +		dev_err(&client->dev,
> > +			"timed out while waiting for command response\n");
> > +		return -ETIMEDOUT;
> > +	}
> > +
> > +	if (rsp.app_id != app_id) {
> > +		dev_err(&client->dev,
> > +			"app_id mismatch in response got %02x expected %02x\n",
> > +			rsp.app_id, app_id);
> > +		return -EINVAL;
> > +	}
> > +
> > +	err_code = rsp.coco_err & ~MMA9551_RESPONSE_COCO;
> > +	if (err_code != MMA9551_MCI_ERROR_NONE) {
> > +		dev_err(&client->dev, "read returned error %x\n", err_code);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (rsp.nbytes != rsp.req_bytes) {
> > +		dev_err(&client->dev,
> > +			"output length mismatch got %d expected %d\n",
> > +			rsp.nbytes, rsp.req_bytes);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (num_outbytes)
> > +		memcpy(outbytes, rsp.buf, num_outbytes);
> > +
> > +	return 0;
> > +}
> > +
> > +int mma9551_read_config_byte(struct i2c_client *client, u8 app_id,
> > +			     u16 reg, u8 *val)
> > +{
> > +	return mma9551_transfer(client, app_id, MMA9551_CMD_READ_CONFIG,
> > +				reg, NULL, 0, val, 1);
> > +}
> > +EXPORT_SYMBOL(mma9551_read_config_byte);
> > +
> > +int mma9551_write_config_byte(struct i2c_client *client, u8 app_id,
> > +			      u16 reg, u8 val)
> > +{
> > +	return mma9551_transfer(client, app_id, MMA9551_CMD_WRITE_CONFIG, reg,
> > +				&val, 1, NULL, 0);
> > +}
> > +EXPORT_SYMBOL(mma9551_write_config_byte);
> > +
> > +int mma9551_read_status_byte(struct i2c_client *client, u8 app_id,
> > +			     u16 reg, u8 *val)
> > +{
> > +	return mma9551_transfer(client, app_id, MMA9551_CMD_READ_STATUS,
> > +				reg, NULL, 0, val, 1);
> > +}
> > +EXPORT_SYMBOL(mma9551_read_status_byte);
> > +
> > +int mma9551_read_status_word(struct i2c_client *client, u8 app_id,
> > +			     u16 reg, u16 *val)
> > +{
> > +	int ret;
> > +	__be16 v;
> > +
> > +	ret = mma9551_transfer(client, app_id, MMA9551_CMD_READ_STATUS,
> > +			       reg, NULL, 0, (u8 *)&v, 2);
> > +	*val = be16_to_cpu(v);
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL(mma9551_read_status_word);
> > +
> I wonder if it's worth adding documentation to these functions - to point
> out that they should only be used under a lock. Might get forgotten as
> it's not readily apparent from the naming that locking is done externally
> rather than internally.
> 
Good point. Will add some kernel-doc comments to these functions.


> > +int mma9551_update_config_bits(struct i2c_client *client, u8 app_id,
> > +			       u16 reg, u8 mask, u8 val)
> > +{
> > +	int ret;
> > +	u8 tmp, orig;
> > +
> > +	ret = mma9551_read_config_byte(client, app_id, reg, &orig);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	tmp = orig & ~mask;
> > +	tmp |= val & mask;
> > +
> > +	if (tmp == orig)
> > +		return 0;
> > +
> > +	return mma9551_write_config_byte(client, app_id, reg, tmp);
> > +}
> > +EXPORT_SYMBOL(mma9551_update_config_bits);
[...]

