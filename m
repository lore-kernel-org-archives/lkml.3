Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbbAAK6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 05:58:41 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:55331 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbbAAK6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 05:58:37 -0500
Message-ID: <54A52859.5000802@kernel.org>
Date: Thu, 01 Jan 2015 10:58:33 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Irina Tirdea <irina.tirdea@intel.com>, linux-iio@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Vlad Dogaru <vlad.dogaru@intel.com>,
        Daniel Baluta <daniel.baluta@intel.com>,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>
Subject: Re: [PATCH 7/8] iio: accel: mma9551: split driver to expose mma955x
 api
References: <1419029879-12024-1-git-send-email-irina.tirdea@intel.com> <1419029879-12024-8-git-send-email-irina.tirdea@intel.com>
In-Reply-To: <1419029879-12024-8-git-send-email-irina.tirdea@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/12/14 22:57, Irina Tirdea wrote:
> Freescale has the MMA955xL family of devices that use the
> same communication protocol (based on i2c messages):
> http://www.freescale.com/files/sensors/doc/data_sheet/MMA955xL.pdf.
> 
> To support more devices from this family, we need to split the
> mma9551 driver so we can export the common functions that will
> be used by other mma955x drivers.
> 
> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
> Reviewed-by: Vlad Dogaru <vlad.dogaru@intel.com>
Sorry, didn't get this far the other day.

Anyhow, other than a query on the depends and a suggestion that some
documentation of locking semantics might be good (perhaps in some
general kernel doc for the exported functions) - this looks good to
me.

Jonathan
> ---
>  drivers/iio/accel/Kconfig        |    6 +
>  drivers/iio/accel/Makefile       |    4 +-
>  drivers/iio/accel/mma9551.c      |  443 +-------------------------------------
>  drivers/iio/accel/mma9551_core.c |  443 ++++++++++++++++++++++++++++++++++++++
>  drivers/iio/accel/mma9551_core.h |   74 +++++++
>  5 files changed, 530 insertions(+), 440 deletions(-)
>  create mode 100644 drivers/iio/accel/mma9551_core.c
>  create mode 100644 drivers/iio/accel/mma9551_core.h
> 
> diff --git a/drivers/iio/accel/Kconfig b/drivers/iio/accel/Kconfig
> index d80616d..0600798 100644
> --- a/drivers/iio/accel/Kconfig
> +++ b/drivers/iio/accel/Kconfig
> @@ -105,9 +105,15 @@ config KXCJK1013
>  	  To compile this driver as a module, choose M here: the module will
>  	  be called kxcjk-1013.
>  
> +config MMA9551_CORE
> +	tristate
> +	depends on MMA9551
Why depend here?  THis isn't visible (due to lack of help) and in theory
an out of tree driver might want to use it.  Hence don't think you want this.
> +
>  config MMA9551
>  	tristate "Freescale MMA9551L Intelligent Motion-Sensing Platform Driver"
>  	depends on I2C
> +	select MMA9551_CORE
> +
>  	help
>  	  Say yes here to build support for the Freescale MMA9551L
>  	  Intelligent Motion-Sensing Platform Driver.
> diff --git a/drivers/iio/accel/Makefile b/drivers/iio/accel/Makefile
> index de5b9cb..8105316 100644
> --- a/drivers/iio/accel/Makefile
> +++ b/drivers/iio/accel/Makefile
> @@ -9,7 +9,9 @@ obj-$(CONFIG_HID_SENSOR_ACCEL_3D) += hid-sensor-accel-3d.o
>  obj-$(CONFIG_KXCJK1013) += kxcjk-1013.o
>  obj-$(CONFIG_KXSD9)	+= kxsd9.o
>  obj-$(CONFIG_MMA8452)	+= mma8452.o
> -obj-$(CONFIG_MMA9551)	+= mma9551.o
> +
> +obj-$(CONFIG_MMA9551_CORE)	+= mma9551_core.o
> +obj-$(CONFIG_MMA9551)		+= mma9551.o
>  
>  obj-$(CONFIG_IIO_ST_ACCEL_3AXIS) += st_accel.o
>  st_accel-y := st_accel_core.o
> diff --git a/drivers/iio/accel/mma9551.c b/drivers/iio/accel/mma9551.c
> index 34ee9d6..6031b5a 100644
> --- a/drivers/iio/accel/mma9551.c
> +++ b/drivers/iio/accel/mma9551.c
> @@ -23,63 +23,13 @@
>  #include <linux/iio/sysfs.h>
>  #include <linux/iio/events.h>
>  #include <linux/pm_runtime.h>
> +#include "mma9551_core.h"
>  
>  #define MMA9551_DRV_NAME		"mma9551"
>  #define MMA9551_IRQ_NAME		"mma9551_event"
>  #define MMA9551_GPIO_NAME		"mma9551_int"
>  #define MMA9551_GPIO_COUNT		4
>  
> -/* Applications IDs */
> -#define MMA9551_APPID_VERSION		0x00
> -#define MMA9551_APPID_GPIO		0x03
> -#define MMA9551_APPID_AFE		0x06
> -#define MMA9551_APPID_TILT		0x0B
> -#define MMA9551_APPID_SLEEP_WAKE	0x12
> -#define MMA9551_APPID_RESET		0x17
> -#define MMA9551_APPID_NONE		0xff
> -
> -/* Command masks for mailbox write command */
> -#define MMA9551_CMD_READ_VERSION_INFO	0x00
> -#define MMA9551_CMD_READ_CONFIG		0x10
> -#define MMA9551_CMD_WRITE_CONFIG	0x20
> -#define MMA9551_CMD_READ_STATUS		0x30
> -
> -enum mma9551_gpio_pin {
> -	mma9551_gpio6 = 0,
> -	mma9551_gpio7,
> -	mma9551_gpio8,
> -	mma9551_gpio9,
> -	mma9551_gpio_max = mma9551_gpio9,
> -};
> -
> -/* Mailbox read command */
> -#define MMA9551_RESPONSE_COCO		BIT(7)
> -
> -/* Error-Status codes returned in mailbox read command */
> -#define MMA9551_MCI_ERROR_NONE			0x00
> -#define MMA9551_MCI_ERROR_PARAM			0x04
> -#define MMA9551_MCI_INVALID_COUNT		0x19
> -#define MMA9551_MCI_ERROR_COMMAND		0x1C
> -#define MMA9551_MCI_ERROR_INVALID_LENGTH	0x21
> -#define MMA9551_MCI_ERROR_FIFO_BUSY		0x22
> -#define MMA9551_MCI_ERROR_FIFO_ALLOCATED	0x23
> -#define MMA9551_MCI_ERROR_FIFO_OVERSIZE		0x24
> -
> -/* GPIO Application */
> -#define MMA9551_GPIO_POL_MSB		0x08
> -#define MMA9551_GPIO_POL_LSB		0x09
> -
> -/* Sleep/Wake application */
> -#define MMA9551_SLEEP_CFG		0x06
> -#define MMA9551_SLEEP_CFG_SNCEN		BIT(0)
> -#define MMA9551_SLEEP_CFG_FLEEN		BIT(1)
> -#define MMA9551_SLEEP_CFG_SCHEN		BIT(2)
> -
> -/* AFE application */
> -#define MMA9551_AFE_X_ACCEL_REG		0x00
> -#define MMA9551_AFE_Y_ACCEL_REG		0x02
> -#define MMA9551_AFE_Z_ACCEL_REG		0x04
> -
>  /* Tilt application (inclination in IIO terms). */
>  #define MMA9551_TILT_XZ_ANG_REG		0x00
>  #define MMA9551_TILT_YZ_ANG_REG		0x01
> @@ -92,6 +42,8 @@ enum mma9551_gpio_pin {
>  #define MMA9551_TILT_CFG_REG		0x01
>  #define MMA9551_TILT_ANG_THRESH_MASK	GENMASK(3, 0)
>  
> +#define MMA9551_DEFAULT_SAMPLE_RATE	122	/* Hz */
> +
>  /* Tilt events are mapped to the first three GPIO pins. */
>  enum mma9551_tilt_axis {
>  	mma9551_x = 0,
> @@ -99,64 +51,6 @@ enum mma9551_tilt_axis {
>  	mma9551_z,
>  };
>  
> -/*
> - * A response is composed of:
> - * - control registers: MB0-3
> - * - data registers: MB4-31
> - *
> - * A request is composed of:
> - * - mbox to write to (always 0)
> - * - control registers: MB1-4
> - * - data registers: MB5-31
> - */
> -#define MMA9551_MAILBOX_CTRL_REGS	4
> -#define MMA9551_MAX_MAILBOX_DATA_REGS	28
> -#define MMA9551_MAILBOX_REGS		32
> -
> -#define MMA9551_I2C_READ_RETRIES	5
> -#define MMA9551_I2C_READ_DELAY	50	/* us */
> -
> -#define MMA9551_DEFAULT_SAMPLE_RATE	122	/* Hz */
> -#define MMA9551_AUTO_SUSPEND_DELAY_MS	2000
> -
> -struct mma9551_mbox_request {
> -	u8 start_mbox;		/* Always 0. */
> -	u8 app_id;
> -	/*
> -	 * See Section 5.3.1 of the MMA955xL Software Reference Manual.
> -	 *
> -	 * Bit 7: reserved, always 0
> -	 * Bits 6-4: command
> -	 * Bits 3-0: upper bits of register offset
> -	 */
> -	u8 cmd_off;
> -	u8 lower_off;
> -	u8 nbytes;
> -	u8 buf[MMA9551_MAX_MAILBOX_DATA_REGS - 1];
> -} __packed;
> -
> -struct mma9551_mbox_response {
> -	u8 app_id;
> -	/*
> -	 * See Section 5.3.3 of the MMA955xL Software Reference Manual.
> -	 *
> -	 * Bit 7: COCO
> -	 * Bits 6-0: Error code.
> -	 */
> -	u8 coco_err;
> -	u8 nbytes;
> -	u8 req_bytes;
> -	u8 buf[MMA9551_MAX_MAILBOX_DATA_REGS];
> -} __packed;
> -
> -struct mma9551_version_info {
> -	__be32 device_id;
> -	u8 rom_version[2];
> -	u8 fw_version[2];
> -	u8 hw_version[2];
> -	u8 fw_build[2];
> -};
> -
>  struct mma9551_data {
>  	struct i2c_client *client;
>  	struct mutex mutex;
> @@ -164,285 +58,6 @@ struct mma9551_data {
>  	int irqs[MMA9551_GPIO_COUNT];
>  };
>  
> -static int mma9551_transfer(struct i2c_client *client,
> -			    u8 app_id, u8 command, u16 offset,
> -			    u8 *inbytes, int num_inbytes,
> -			    u8 *outbytes, int num_outbytes)
> -{
> -	struct mma9551_mbox_request req;
> -	struct mma9551_mbox_response rsp;
> -	struct i2c_msg in, out;
> -	u8 req_len, err_code;
> -	int ret, retries;
> -
> -	if (offset >= 1 << 12) {
> -		dev_err(&client->dev, "register offset too large\n");
> -		return -EINVAL;
> -	}
> -
> -	req_len = 1 + MMA9551_MAILBOX_CTRL_REGS + num_inbytes;
> -	req.start_mbox = 0;
> -	req.app_id = app_id;
> -	req.cmd_off = command | (offset >> 8);
> -	req.lower_off = offset;
> -
> -	if (command == MMA9551_CMD_WRITE_CONFIG)
> -		req.nbytes = num_inbytes;
> -	else
> -		req.nbytes = num_outbytes;
> -	if (num_inbytes)
> -		memcpy(req.buf, inbytes, num_inbytes);
> -
> -	out.addr = client->addr;
> -	out.flags = 0;
> -	out.len = req_len;
> -	out.buf = (u8 *)&req;
> -
> -	ret = i2c_transfer(client->adapter, &out, 1);
> -	if (ret < 0) {
> -		dev_err(&client->dev, "i2c write failed\n");
> -		return ret;
> -	}
> -
> -	retries = MMA9551_I2C_READ_RETRIES;
> -	do {
> -		udelay(MMA9551_I2C_READ_DELAY);
> -
> -		in.addr = client->addr;
> -		in.flags = I2C_M_RD;
> -		in.len = sizeof(rsp);
> -		in.buf = (u8 *)&rsp;
> -
> -		ret = i2c_transfer(client->adapter, &in, 1);
> -		if (ret < 0) {
> -			dev_err(&client->dev, "i2c read failed\n");
> -			return ret;
> -		}
> -
> -		if (rsp.coco_err & MMA9551_RESPONSE_COCO)
> -			break;
> -	} while (--retries > 0);
> -
> -	if (retries == 0) {
> -		dev_err(&client->dev,
> -			"timed out while waiting for command response\n");
> -		return -ETIMEDOUT;
> -	}
> -
> -	if (rsp.app_id != app_id) {
> -		dev_err(&client->dev,
> -			"app_id mismatch in response got %02x expected %02x\n",
> -			rsp.app_id, app_id);
> -		return -EINVAL;
> -	}
> -
> -	err_code = rsp.coco_err & ~MMA9551_RESPONSE_COCO;
> -	if (err_code != MMA9551_MCI_ERROR_NONE) {
> -		dev_err(&client->dev, "read returned error %x\n", err_code);
> -		return -EINVAL;
> -	}
> -
> -	if (rsp.nbytes != rsp.req_bytes) {
> -		dev_err(&client->dev,
> -			"output length mismatch got %d expected %d\n",
> -			rsp.nbytes, rsp.req_bytes);
> -		return -EINVAL;
> -	}
> -
> -	if (num_outbytes)
> -		memcpy(outbytes, rsp.buf, num_outbytes);
> -
> -	return 0;
> -}
> -
> -static int mma9551_read_config_byte(struct i2c_client *client, u8 app_id,
> -				    u16 reg, u8 *val)
> -{
> -	return mma9551_transfer(client, app_id, MMA9551_CMD_READ_CONFIG,
> -				reg, NULL, 0, val, 1);
> -}
> -
> -static int mma9551_write_config_byte(struct i2c_client *client, u8 app_id,
> -				     u16 reg, u8 val)
> -{
> -	return mma9551_transfer(client, app_id, MMA9551_CMD_WRITE_CONFIG, reg,
> -				&val, 1, NULL, 0);
> -}
> -
> -static int mma9551_read_status_byte(struct i2c_client *client, u8 app_id,
> -				    u16 reg, u8 *val)
> -{
> -	return mma9551_transfer(client, app_id, MMA9551_CMD_READ_STATUS,
> -				reg, NULL, 0, val, 1);
> -}
> -
> -static int mma9551_read_status_word(struct i2c_client *client, u8 app_id,
> -				    u16 reg, u16 *val)
> -{
> -	int ret;
> -	__be16 v;
> -
> -	ret = mma9551_transfer(client, app_id, MMA9551_CMD_READ_STATUS,
> -			       reg, NULL, 0, (u8 *)&v, 2);
> -	*val = be16_to_cpu(v);
> -
> -	return ret;
> -}
> -
> -static int mma9551_update_config_bits(struct i2c_client *client, u8 app_id,
> -				      u16 reg, u8 mask, u8 val)
> -{
> -	int ret;
> -	u8 tmp, orig;
> -
> -	ret = mma9551_read_config_byte(client, app_id, reg, &orig);
> -	if (ret < 0)
> -		return ret;
> -
> -	tmp = orig & ~mask;
> -	tmp |= val & mask;
> -
> -	if (tmp == orig)
> -		return 0;
> -
> -	return mma9551_write_config_byte(client, app_id, reg, tmp);
> -}
> -
> -/*
> - * The polarity parameter is described in section 6.2.2, page 66, of the
> - * Software Reference Manual.  Basically, polarity=0 means the interrupt
> - * line has the same value as the selected bit, while polarity=1 means
> - * the line is inverted.
> - */
> -static int mma9551_gpio_config(struct i2c_client *client,
> -			       enum mma9551_gpio_pin pin,
> -			       u8 app_id, u8 bitnum, int polarity)
> -{
> -	u8 reg, pol_mask, pol_val;
> -	int ret;
> -
> -	if (pin > mma9551_gpio_max) {
> -		dev_err(&client->dev, "bad GPIO pin\n");
> -		return -EINVAL;
> -	}
> -
> -	/*
> -	 * Pin 6 is configured by regs 0x00 and 0x01, pin 7 by 0x02 and
> -	 * 0x03, and so on.
> -	 */
> -	reg = pin * 2;
> -
> -	ret = mma9551_write_config_byte(client, MMA9551_APPID_GPIO,
> -					reg, app_id);
> -	if (ret < 0) {
> -		dev_err(&client->dev, "error setting GPIO app_id\n");
> -		return ret;
> -	}
> -
> -	ret = mma9551_write_config_byte(client, MMA9551_APPID_GPIO,
> -					reg + 1, bitnum);
> -	if (ret < 0) {
> -		dev_err(&client->dev, "error setting GPIO bit number\n");
> -		return ret;
> -	}
> -
> -	switch (pin) {
> -	case mma9551_gpio6:
> -		reg = MMA9551_GPIO_POL_LSB;
> -		pol_mask = 1 << 6;
> -		break;
> -	case mma9551_gpio7:
> -		reg = MMA9551_GPIO_POL_LSB;
> -		pol_mask = 1 << 7;
> -		break;
> -	case mma9551_gpio8:
> -		reg = MMA9551_GPIO_POL_MSB;
> -		pol_mask = 1 << 0;
> -		break;
> -	case mma9551_gpio9:
> -		reg = MMA9551_GPIO_POL_MSB;
> -		pol_mask = 1 << 1;
> -		break;
> -	}
> -	pol_val = polarity ? pol_mask : 0;
> -
> -	ret = mma9551_update_config_bits(client, MMA9551_APPID_GPIO, reg,
> -					 pol_mask, pol_val);
> -	if (ret < 0)
> -		dev_err(&client->dev, "error setting GPIO polarity\n");
> -
> -	return ret;
> -}
> -
> -static int mma9551_read_version(struct i2c_client *client)
> -{
> -	struct mma9551_version_info info;
> -	int ret;
> -
> -	ret = mma9551_transfer(client, MMA9551_APPID_VERSION, 0x00, 0x00,
> -			       NULL, 0, (u8 *)&info, sizeof(info));
> -	if (ret < 0)
> -		return ret;
> -
> -	dev_info(&client->dev, "Device ID 0x%x, firmware version %02x.%02x\n",
> -		 be32_to_cpu(info.device_id), info.fw_version[0],
> -		 info.fw_version[1]);
> -
> -	return 0;
> -}
> -
> -/*
> - * Power on chip and enable doze mode.
> - * Use 'false' as the second parameter to cause the device to enter
> - * sleep.
> - */
> -static int mma9551_set_device_state(struct i2c_client *client, bool enable)
> -{
> -	return mma9551_update_config_bits(client, MMA9551_APPID_SLEEP_WAKE,
> -					  MMA9551_SLEEP_CFG,
> -					  MMA9551_SLEEP_CFG_SNCEN |
> -					  MMA9551_SLEEP_CFG_FLEEN |
> -					  MMA9551_SLEEP_CFG_SCHEN,
> -					  enable ? MMA9551_SLEEP_CFG_SCHEN |
> -					  MMA9551_SLEEP_CFG_FLEEN :
> -					  MMA9551_SLEEP_CFG_SNCEN);
> -}
> -
> -static int mma9551_set_power_state(struct i2c_client *client, bool on)
> -{
> -#ifdef CONFIG_PM
> -	int ret;
> -
> -	if (on)
> -		ret = pm_runtime_get_sync(&client->dev);
> -	else {
> -		pm_runtime_mark_last_busy(&client->dev);
> -		ret = pm_runtime_put_autosuspend(&client->dev);
> -	}
> -
> -	if (ret < 0) {
> -		dev_err(&client->dev,
> -			"failed to change power state to %d\n", on);
> -		if (on)
> -			pm_runtime_put_noidle(&client->dev);
> -
> -		return ret;
> -	}
> -#endif
> -
> -	return 0;
> -}
> -
> -static void mma9551_sleep(int freq)
> -{
> -	int sleep_val = 1000 / freq;
> -
> -	if (sleep_val < 20)
> -		usleep_range(sleep_val * 1000, 20000);
> -	else
> -		msleep_interruptible(sleep_val);
> -}
> -
>  static int mma9551_read_incli_chan(struct i2c_client *client,
>  				   const struct iio_chan_spec *chan,
>  				   int *val)
> @@ -497,46 +112,6 @@ out_poweroff:
>  	return ret;
>  }
>  
> -static int mma9551_read_accel_chan(struct i2c_client *client,
> -				   const struct iio_chan_spec *chan,
> -				   int *val, int *val2)
> -{
> -	u16 reg_addr;
> -	s16 raw_accel;
> -	int ret;
> -
> -	switch (chan->channel2) {
> -	case IIO_MOD_X:
> -		reg_addr = MMA9551_AFE_X_ACCEL_REG;
> -		break;
> -	case IIO_MOD_Y:
> -		reg_addr = MMA9551_AFE_Y_ACCEL_REG;
> -		break;
> -	case IIO_MOD_Z:
> -		reg_addr = MMA9551_AFE_Z_ACCEL_REG;
> -		break;
> -	default:
> -		return -EINVAL;
> -	}
> -
> -	ret = mma9551_set_power_state(client, true);
> -	if (ret < 0)
> -		return ret;
> -
> -	ret = mma9551_read_status_word(client, MMA9551_APPID_AFE,
> -				       reg_addr, &raw_accel);
> -	if (ret < 0)
> -		goto out_poweroff;
> -
> -	*val = raw_accel;
> -
> -	ret = IIO_VAL_INT;
> -
> -out_poweroff:
> -	mma9551_set_power_state(client, false);
> -	return ret;
> -}
> -
>  static int mma9551_read_raw(struct iio_dev *indio_dev,
>  			    struct iio_chan_spec const *chan,
>  			    int *val, int *val2, long mask)
> @@ -569,9 +144,7 @@ static int mma9551_read_raw(struct iio_dev *indio_dev,
>  	case IIO_CHAN_INFO_SCALE:
>  		switch (chan->type) {
>  		case IIO_ACCEL:
> -			*val = 0;
> -			*val2 = 2440;
> -			return IIO_VAL_INT_PLUS_MICRO;
> +			return mma9551_read_accel_scale(val, val2);
>  		default:
>  			return -EINVAL;
>  		}
> @@ -737,14 +310,6 @@ static const struct iio_event_spec mma9551_incli_event = {
>  	.mask_shared_by_type = BIT(IIO_EV_INFO_VALUE),
>  };
>  
> -#define MMA9551_ACCEL_CHANNEL(axis) {				\
> -	.type = IIO_ACCEL,					\
> -	.modified = 1,						\
> -	.channel2 = axis,					\
> -	.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),		\
> -	.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SCALE),	\
> -}
> -
>  #define MMA9551_INCLI_CHANNEL(axis) {				\
>  	.type = IIO_INCLI,					\
>  	.modified = 1,						\
> diff --git a/drivers/iio/accel/mma9551_core.c b/drivers/iio/accel/mma9551_core.c
> new file mode 100644
> index 0000000..cab481b
> --- /dev/null
> +++ b/drivers/iio/accel/mma9551_core.c
> @@ -0,0 +1,443 @@
> +/*
> + * Common code for Freescale MMA955x Intelligent Sensor Platform drivers
> + * Copyright (c) 2014, Intel Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/i2c.h>
> +#include <linux/delay.h>
> +#include <linux/iio/iio.h>
> +#include <linux/pm_runtime.h>
> +#include "mma9551_core.h"
> +
> +/* Command masks for mailbox write command */
> +#define MMA9551_CMD_READ_VERSION_INFO	0x00
> +#define MMA9551_CMD_READ_CONFIG		0x10
> +#define MMA9551_CMD_WRITE_CONFIG	0x20
> +#define MMA9551_CMD_READ_STATUS		0x30
> +
> +/* Mailbox read command */
> +#define MMA9551_RESPONSE_COCO		BIT(7)
> +
> +/* Error-Status codes returned in mailbox read command */
> +#define MMA9551_MCI_ERROR_NONE			0x00
> +#define MMA9551_MCI_ERROR_PARAM			0x04
> +#define MMA9551_MCI_INVALID_COUNT		0x19
> +#define MMA9551_MCI_ERROR_COMMAND		0x1C
> +#define MMA9551_MCI_ERROR_INVALID_LENGTH	0x21
> +#define MMA9551_MCI_ERROR_FIFO_BUSY		0x22
> +#define MMA9551_MCI_ERROR_FIFO_ALLOCATED	0x23
> +#define MMA9551_MCI_ERROR_FIFO_OVERSIZE		0x24
> +
> +/* GPIO Application */
> +#define MMA9551_GPIO_POL_MSB		0x08
> +#define MMA9551_GPIO_POL_LSB		0x09
> +
> +/* Sleep/Wake application */
> +#define MMA9551_SLEEP_CFG		0x06
> +#define MMA9551_SLEEP_CFG_SNCEN		BIT(0)
> +#define MMA9551_SLEEP_CFG_FLEEN		BIT(1)
> +#define MMA9551_SLEEP_CFG_SCHEN		BIT(2)
> +
> +/* AFE application */
> +#define MMA9551_AFE_X_ACCEL_REG		0x00
> +#define MMA9551_AFE_Y_ACCEL_REG		0x02
> +#define MMA9551_AFE_Z_ACCEL_REG		0x04
> +
> +/*
> + * A response is composed of:
> + * - control registers: MB0-3
> + * - data registers: MB4-31
> + *
> + * A request is composed of:
> + * - mbox to write to (always 0)
> + * - control registers: MB1-4
> + * - data registers: MB5-31
> + */
> +#define MMA9551_MAILBOX_CTRL_REGS	4
> +#define MMA9551_MAX_MAILBOX_DATA_REGS	28
> +#define MMA9551_MAILBOX_REGS		32
> +
> +#define MMA9551_I2C_READ_RETRIES	5
> +#define MMA9551_I2C_READ_DELAY	50	/* us */
> +
> +struct mma9551_mbox_request {
> +	u8 start_mbox;		/* Always 0. */
> +	u8 app_id;
> +	/*
> +	 * See Section 5.3.1 of the MMA955xL Software Reference Manual.
> +	 *
> +	 * Bit 7: reserved, always 0
> +	 * Bits 6-4: command
> +	 * Bits 3-0: upper bits of register offset
> +	 */
> +	u8 cmd_off;
> +	u8 lower_off;
> +	u8 nbytes;
> +	u8 buf[MMA9551_MAX_MAILBOX_DATA_REGS - 1];
> +} __packed;
> +
> +struct mma9551_mbox_response {
> +	u8 app_id;
> +	/*
> +	 * See Section 5.3.3 of the MMA955xL Software Reference Manual.
> +	 *
> +	 * Bit 7: COCO
> +	 * Bits 6-0: Error code.
> +	 */
> +	u8 coco_err;
> +	u8 nbytes;
> +	u8 req_bytes;
> +	u8 buf[MMA9551_MAX_MAILBOX_DATA_REGS];
> +} __packed;
> +
> +static int mma9551_transfer(struct i2c_client *client,
> +			    u8 app_id, u8 command, u16 offset,
> +			    u8 *inbytes, int num_inbytes,
> +			    u8 *outbytes, int num_outbytes)
> +{
> +	struct mma9551_mbox_request req;
> +	struct mma9551_mbox_response rsp;
> +	struct i2c_msg in, out;
> +	u8 req_len, err_code;
> +	int ret, retries;
> +
> +	if (offset >= 1 << 12) {
> +		dev_err(&client->dev, "register offset too large\n");
> +		return -EINVAL;
> +	}
> +
> +	req_len = 1 + MMA9551_MAILBOX_CTRL_REGS + num_inbytes;
> +	req.start_mbox = 0;
> +	req.app_id = app_id;
> +	req.cmd_off = command | (offset >> 8);
> +	req.lower_off = offset;
> +
> +	if (command == MMA9551_CMD_WRITE_CONFIG)
> +		req.nbytes = num_inbytes;
> +	else
> +		req.nbytes = num_outbytes;
> +	if (num_inbytes)
> +		memcpy(req.buf, inbytes, num_inbytes);
> +
> +	out.addr = client->addr;
> +	out.flags = 0;
> +	out.len = req_len;
> +	out.buf = (u8 *)&req;
> +
> +	ret = i2c_transfer(client->adapter, &out, 1);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "i2c write failed\n");
> +		return ret;
> +	}
> +
> +	retries = MMA9551_I2C_READ_RETRIES;
> +	do {
> +		udelay(MMA9551_I2C_READ_DELAY);
> +
> +		in.addr = client->addr;
> +		in.flags = I2C_M_RD;
> +		in.len = sizeof(rsp);
> +		in.buf = (u8 *)&rsp;
> +
> +		ret = i2c_transfer(client->adapter, &in, 1);
> +		if (ret < 0) {
> +			dev_err(&client->dev, "i2c read failed\n");
> +			return ret;
> +		}
> +
> +		if (rsp.coco_err & MMA9551_RESPONSE_COCO)
> +			break;
> +	} while (--retries > 0);
> +
> +	if (retries == 0) {
> +		dev_err(&client->dev,
> +			"timed out while waiting for command response\n");
> +		return -ETIMEDOUT;
> +	}
> +
> +	if (rsp.app_id != app_id) {
> +		dev_err(&client->dev,
> +			"app_id mismatch in response got %02x expected %02x\n",
> +			rsp.app_id, app_id);
> +		return -EINVAL;
> +	}
> +
> +	err_code = rsp.coco_err & ~MMA9551_RESPONSE_COCO;
> +	if (err_code != MMA9551_MCI_ERROR_NONE) {
> +		dev_err(&client->dev, "read returned error %x\n", err_code);
> +		return -EINVAL;
> +	}
> +
> +	if (rsp.nbytes != rsp.req_bytes) {
> +		dev_err(&client->dev,
> +			"output length mismatch got %d expected %d\n",
> +			rsp.nbytes, rsp.req_bytes);
> +		return -EINVAL;
> +	}
> +
> +	if (num_outbytes)
> +		memcpy(outbytes, rsp.buf, num_outbytes);
> +
> +	return 0;
> +}
> +
> +int mma9551_read_config_byte(struct i2c_client *client, u8 app_id,
> +			     u16 reg, u8 *val)
> +{
> +	return mma9551_transfer(client, app_id, MMA9551_CMD_READ_CONFIG,
> +				reg, NULL, 0, val, 1);
> +}
> +EXPORT_SYMBOL(mma9551_read_config_byte);
> +
> +int mma9551_write_config_byte(struct i2c_client *client, u8 app_id,
> +			      u16 reg, u8 val)
> +{
> +	return mma9551_transfer(client, app_id, MMA9551_CMD_WRITE_CONFIG, reg,
> +				&val, 1, NULL, 0);
> +}
> +EXPORT_SYMBOL(mma9551_write_config_byte);
> +
> +int mma9551_read_status_byte(struct i2c_client *client, u8 app_id,
> +			     u16 reg, u8 *val)
> +{
> +	return mma9551_transfer(client, app_id, MMA9551_CMD_READ_STATUS,
> +				reg, NULL, 0, val, 1);
> +}
> +EXPORT_SYMBOL(mma9551_read_status_byte);
> +
> +int mma9551_read_status_word(struct i2c_client *client, u8 app_id,
> +			     u16 reg, u16 *val)
> +{
> +	int ret;
> +	__be16 v;
> +
> +	ret = mma9551_transfer(client, app_id, MMA9551_CMD_READ_STATUS,
> +			       reg, NULL, 0, (u8 *)&v, 2);
> +	*val = be16_to_cpu(v);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(mma9551_read_status_word);
> +
I wonder if it's worth adding documentation to these functions - to point
out that they should only be used under a lock. Might get forgotten as
it's not readily apparent from the naming that locking is done externally
rather than internally.

> +int mma9551_update_config_bits(struct i2c_client *client, u8 app_id,
> +			       u16 reg, u8 mask, u8 val)
> +{
> +	int ret;
> +	u8 tmp, orig;
> +
> +	ret = mma9551_read_config_byte(client, app_id, reg, &orig);
> +	if (ret < 0)
> +		return ret;
> +
> +	tmp = orig & ~mask;
> +	tmp |= val & mask;
> +
> +	if (tmp == orig)
> +		return 0;
> +
> +	return mma9551_write_config_byte(client, app_id, reg, tmp);
> +}
> +EXPORT_SYMBOL(mma9551_update_config_bits);
> +
> +/*
> + * The polarity parameter is described in section 6.2.2, page 66, of the
> + * Software Reference Manual.  Basically, polarity=0 means the interrupt
> + * line has the same value as the selected bit, while polarity=1 means
> + * the line is inverted.
> + */
> +int mma9551_gpio_config(struct i2c_client *client, enum mma9551_gpio_pin pin,
> +			u8 app_id, u8 bitnum, int polarity)
> +{
> +	u8 reg, pol_mask, pol_val;
> +	int ret;
> +
> +	if (pin > mma9551_gpio_max) {
> +		dev_err(&client->dev, "bad GPIO pin\n");
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * Pin 6 is configured by regs 0x00 and 0x01, pin 7 by 0x02 and
> +	 * 0x03, and so on.
> +	 */
> +	reg = pin * 2;
> +
> +	ret = mma9551_write_config_byte(client, MMA9551_APPID_GPIO,
> +					reg, app_id);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "error setting GPIO app_id\n");
> +		return ret;
> +	}
> +
> +	ret = mma9551_write_config_byte(client, MMA9551_APPID_GPIO,
> +					reg + 1, bitnum);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "error setting GPIO bit number\n");
> +		return ret;
> +	}
> +
> +	switch (pin) {
> +	case mma9551_gpio6:
> +		reg = MMA9551_GPIO_POL_LSB;
> +		pol_mask = 1 << 6;
> +		break;
> +	case mma9551_gpio7:
> +		reg = MMA9551_GPIO_POL_LSB;
> +		pol_mask = 1 << 7;
> +		break;
> +	case mma9551_gpio8:
> +		reg = MMA9551_GPIO_POL_MSB;
> +		pol_mask = 1 << 0;
> +		break;
> +	case mma9551_gpio9:
> +		reg = MMA9551_GPIO_POL_MSB;
> +		pol_mask = 1 << 1;
> +		break;
> +	}
> +	pol_val = polarity ? pol_mask : 0;
> +
> +	ret = mma9551_update_config_bits(client, MMA9551_APPID_GPIO, reg,
> +					 pol_mask, pol_val);
> +	if (ret < 0)
> +		dev_err(&client->dev, "error setting GPIO polarity\n");
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(mma9551_gpio_config);
> +
> +int mma9551_read_version(struct i2c_client *client)
> +{
> +	struct mma9551_version_info info;
> +	int ret;
> +
> +	ret = mma9551_transfer(client, MMA9551_APPID_VERSION, 0x00, 0x00,
> +			       NULL, 0, (u8 *)&info, sizeof(info));
> +	if (ret < 0)
> +		return ret;
> +
> +	dev_info(&client->dev, "device ID 0x%x, firmware version %02x.%02x\n",
> +		 be32_to_cpu(info.device_id), info.fw_version[0],
> +		 info.fw_version[1]);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(mma9551_read_version);
> +
> +/*
> + * Power on chip and enable doze mode.
> + * Use 'false' as the second parameter to cause the device to enter
> + * sleep.
> + */
> +int mma9551_set_device_state(struct i2c_client *client, bool enable)
> +{
> +	return mma9551_update_config_bits(client, MMA9551_APPID_SLEEP_WAKE,
> +					  MMA9551_SLEEP_CFG,
> +					  MMA9551_SLEEP_CFG_SNCEN |
> +					  MMA9551_SLEEP_CFG_FLEEN |
> +					  MMA9551_SLEEP_CFG_SCHEN,
> +					  enable ? MMA9551_SLEEP_CFG_SCHEN |
> +					  MMA9551_SLEEP_CFG_FLEEN :
> +					  MMA9551_SLEEP_CFG_SNCEN);
> +}
> +EXPORT_SYMBOL(mma9551_set_device_state);
> +
> +int mma9551_set_power_state(struct i2c_client *client, bool on)
> +{
> +#ifdef CONFIG_PM
> +	int ret;
> +
> +	if (on)
> +		ret = pm_runtime_get_sync(&client->dev);
> +	else {
> +		pm_runtime_mark_last_busy(&client->dev);
> +		ret = pm_runtime_put_autosuspend(&client->dev);
> +	}
> +
> +	if (ret < 0) {
> +		dev_err(&client->dev,
> +			"failed to change power state to %d\n", on);
> +		if (on)
> +			pm_runtime_put_noidle(&client->dev);
> +
> +		return ret;
> +	}
> +#endif
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(mma9551_set_power_state);
> +
> +void mma9551_sleep(int freq)
> +{
> +	int sleep_val = 1000 / freq;
> +
> +	if (sleep_val < 20)
> +		usleep_range(sleep_val * 1000, 20000);
> +	else
> +		msleep_interruptible(sleep_val);
> +}
> +EXPORT_SYMBOL(mma9551_sleep);
> +
> +int mma9551_read_accel_chan(struct i2c_client *client,
> +			    const struct iio_chan_spec *chan,
> +			    int *val, int *val2)
> +{
> +	u16 reg_addr;
> +	s16 raw_accel;
> +	int ret;
> +
> +	switch (chan->channel2) {
> +	case IIO_MOD_X:
> +		reg_addr = MMA9551_AFE_X_ACCEL_REG;
> +		break;
> +	case IIO_MOD_Y:
> +		reg_addr = MMA9551_AFE_Y_ACCEL_REG;
> +		break;
> +	case IIO_MOD_Z:
> +		reg_addr = MMA9551_AFE_Z_ACCEL_REG;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	ret = mma9551_set_power_state(client, true);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = mma9551_read_status_word(client, MMA9551_APPID_AFE,
> +				       reg_addr, &raw_accel);
> +	if (ret < 0)
> +		goto out_poweroff;
> +
> +	*val = raw_accel;
> +
> +	ret = IIO_VAL_INT;
> +
> +out_poweroff:
> +	mma9551_set_power_state(client, false);
> +	return ret;
> +}
> +EXPORT_SYMBOL(mma9551_read_accel_chan);
> +
> +int mma9551_read_accel_scale(int *val, int *val2)
> +{
> +	*val = 0;
> +	*val2 = 2440;
> +	return IIO_VAL_INT_PLUS_MICRO;
> +}
> +EXPORT_SYMBOL(mma9551_read_accel_scale);
> +
> +MODULE_AUTHOR("Irina Tirdea <irina.tirdea@intel.com>");
> +MODULE_AUTHOR("Vlad Dogaru <vlad.dogaru@intel.com>");
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("MMA955xL sensors core");
> diff --git a/drivers/iio/accel/mma9551_core.h b/drivers/iio/accel/mma9551_core.h
> new file mode 100644
> index 0000000..0e1c9bb
> --- /dev/null
> +++ b/drivers/iio/accel/mma9551_core.h
> @@ -0,0 +1,74 @@
> +/*
> + * Common code for Freescale MMA955x Intelligent Sensor Platform drivers
> + * Copyright (c) 2014, Intel Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + */
> +
> +#ifndef _MMA9551_CORE_H_
> +#define _MMA9551_CORE_H_
> +
> +/* Applications IDs */
> +#define MMA9551_APPID_VERSION		0x00
> +#define MMA9551_APPID_GPIO		0x03
> +#define MMA9551_APPID_AFE		0x06
> +#define MMA9551_APPID_TILT		0x0B
> +#define MMA9551_APPID_SLEEP_WAKE	0x12
> +#define MMA9551_APPID_RESET		0x17
> +#define MMA9551_APPID_NONE		0xff
> +
> +#define MMA9551_AUTO_SUSPEND_DELAY_MS	2000
> +
> +enum mma9551_gpio_pin {
> +	mma9551_gpio6 = 0,
> +	mma9551_gpio7,
> +	mma9551_gpio8,
> +	mma9551_gpio9,
> +	mma9551_gpio_max = mma9551_gpio9,
> +};
> +
> +struct mma9551_version_info {
> +	__be32 device_id;
> +	u8 rom_version[2];
> +	u8 fw_version[2];
> +	u8 hw_version[2];
> +	u8 fw_build[2];
> +};
> +
> +#define MMA9551_ACCEL_CHANNEL(axis) {				\
> +	.type = IIO_ACCEL,					\
> +	.modified = 1,						\
> +	.channel2 = axis,					\
> +	.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),		\
> +	.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SCALE),	\
> +}
> +
> +int mma9551_read_config_byte(struct i2c_client *client, u8 app_id,
> +			     u16 reg, u8 *val);
> +int mma9551_write_config_byte(struct i2c_client *client, u8 app_id,
> +			      u16 reg, u8 val);
> +int mma9551_read_status_byte(struct i2c_client *client, u8 app_id,
> +			     u16 reg, u8 *val);
> +int mma9551_read_status_word(struct i2c_client *client, u8 app_id,
> +			     u16 reg, u16 *val);
> +int mma9551_update_config_bits(struct i2c_client *client, u8 app_id,
> +			       u16 reg, u8 mask, u8 val);
> +int mma9551_gpio_config(struct i2c_client *client, enum mma9551_gpio_pin pin,
> +			u8 app_id, u8 bitnum, int polarity);
> +int mma9551_read_version(struct i2c_client *client);
> +int mma9551_set_device_state(struct i2c_client *client, bool enable);
> +int mma9551_set_power_state(struct i2c_client *client, bool on);
> +void mma9551_sleep(int freq);
> +int mma9551_read_accel_chan(struct i2c_client *client,
> +			    const struct iio_chan_spec *chan,
> +			    int *val, int *val2);
> +int mma9551_read_accel_scale(int *val, int *val2);
> +
> +#endif /* _MMA9551_CORE_H_ */
> 

