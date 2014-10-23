Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbaJWNKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 09:10:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755476AbaJWNJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 09:09:58 -0400
Message-ID: <5448FE1D.7080101@redhat.com>
Date: Thu, 23 Oct 2014 15:09:49 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: John McMaster <johndmcmaster@gmail.com>, linux-kernel@vger.kernel.org
CC: linux-media@vger.kernel.org, m.chehab@samsung.com
Subject: Re: [PATCH] [media] gspca_touptek: Add support for ToupTek UCMOS
 series USB cameras
References: <1412491401-5577-1-git-send-email-johndmcmaster@gmail.com>
In-Reply-To: <1412491401-5577-1-git-send-email-johndmcmaster@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/05/2014 08:43 AM, John McMaster wrote:
> Adds support for AmScope MU800 / ToupTek UCMOS08000KPB USB microscope camera.

First of all many thanks for writing this driver, and also for submitting it
upstream. We always appreciate it a lot when people put in the effort to
write a driver to support new "webcams", and it is also greatly appreciated
when people go the extra mile to make the driver clean enough to submit it
upstream!

Overall the driver looks fine, you've clearly spend a lot of time on this!

3 small remarks though:

1) Please replace all the pr_foo calls with calls to the gspca specific
PERR (v4l2_err wrapper) and PDEBUG (v4l2_dbg) macros. using PDEBUG will
allow you to specify one of the D_foo values as debug level and then at
runtime select which messages to log. The following levels are available:

#define D_PROBE  1

Use this for probing info, e.g. print which type of sensors / extra
features you've detected.

#define D_CONF   2

This is used to log configuration info, e.g. for format negotation,
typically this is used by the gspca core and not by your driver

#define D_STREAM 3

Use this to log debug messages at stream start / stop

#define D_FRAM   4

Use this to log debug messages occuring once each frame

#define D_PACK   5

Use this to log debug messages occuring once each video packet

#define D_USBI   6

Use this to log ctrl register reads

#define D_USBO   7

Use this to log ctrl register writes

When you use this, you can use the gspca_main.debug module parameter
to select a log level between 0 - 7.


2) As for the "XXX: seems done automaticly, should rmeove" bit, yes
controls are set automatically at the start of streaming, so please
remove this (and double check things still work with it removed).


3) In some places you do:

	rc = reg_w(gspca_dev, 0x0000, REG_SCALING_MODE);
	if (rc)
		return rc;
	rc = reg_w(gspca_dev, 0x0010, REG_SCALE_M);
	if (rc)
		return rc;
	rc = reg_w(gspca_dev, w, REG_X_OUTPUT_SIZE);
	if (rc)
		return rc;
	rc = reg_w(gspca_dev, gspca_dev->pixfmt.height, REG_Y_OUTPUT_SIZE);
	if (rc)
		return rc;

The way we typically handle this in gspca is through gspca_dev->usb_err
which you use in sd_s_ctrl but never set, here is an example of another reg_w
function indicating how this is typically used:

static void pac207_write_reg(struct gspca_dev *gspca_dev, u16 index, u16 value)
{
        struct usb_device *udev = gspca_dev->dev;
        int err;

        if (gspca_dev->usb_err < 0)
                return;

        err = usb_control_msg(udev, usb_sndctrlpipe(udev, 0), 0x00,
                        USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
                        value, index, NULL, 0, PAC207_CTRL_TIMEOUT);
        if (err) {
                pr_err("Failed to write a register (index 0x%04X, value 0x%02X,
                       index, value, err);
                gspca_dev->usb_err = err;
        }
}

And the above code would be changed into:

	gspca_dev->usb_err = 0;

	reg_w(gspca_dev, 0x0000, REG_SCALING_MODE);
	reg_w(gspca_dev, 0x0010, REG_SCALE_M);
	reg_w(gspca_dev, w, REG_X_OUTPUT_SIZE);
	reg_w(gspca_dev, gspca_dev->pixfmt.height, REG_Y_OUTPUT_SIZE);

	return gspca_dev->usb_err;

The idea being that we can simply chain as many reg_w calls as we need,
and the first one failing turns all the next ones into nops, and at the
end we simply return gspca_dev->usb_err which on success is still 0.

If you make this change then the return of gspca_dev->usb_err at the end
of sd_s_ctrl also actually starts making sense :)

If you can fix these 3 issues then I'll happily merge this driver for
3.19.

Regards,

Hans


> 
> Signed-off-by: John McMaster <johndmcmaster@gmail.com>
> ---
>  drivers/media/usb/gspca/Kconfig   |   10 +
>  drivers/media/usb/gspca/Makefile  |    2 +
>  drivers/media/usb/gspca/touptek.c |  859 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 871 insertions(+)
>  create mode 100644 drivers/media/usb/gspca/touptek.c
> 
> diff --git a/drivers/media/usb/gspca/Kconfig b/drivers/media/usb/gspca/Kconfig
> index eed10d7..60af3b1 100644
> --- a/drivers/media/usb/gspca/Kconfig
> +++ b/drivers/media/usb/gspca/Kconfig
> @@ -395,6 +395,16 @@ config USB_GSPCA_TOPRO
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called gspca_topro.
>  
> +config USB_GSPCA_TOUPTEK
> +	tristate "Touptek USB Camera Driver"
> +	depends on VIDEO_V4L2 && USB_GSPCA
> +	help
> +	  Say Y here if you want support for cameras based on the ToupTek UCMOS
> +	  / AmScope MU series camera.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called gspca_touptek.
> +
>  config USB_GSPCA_TV8532
>  	tristate "TV8532 USB Camera Driver"
>  	depends on VIDEO_V4L2 && USB_GSPCA
> diff --git a/drivers/media/usb/gspca/Makefile b/drivers/media/usb/gspca/Makefile
> index f46975e..9f5ccec 100644
> --- a/drivers/media/usb/gspca/Makefile
> +++ b/drivers/media/usb/gspca/Makefile
> @@ -39,6 +39,7 @@ obj-$(CONFIG_USB_GSPCA_STK1135)  += gspca_stk1135.o
>  obj-$(CONFIG_USB_GSPCA_STV0680)  += gspca_stv0680.o
>  obj-$(CONFIG_USB_GSPCA_T613)     += gspca_t613.o
>  obj-$(CONFIG_USB_GSPCA_TOPRO)    += gspca_topro.o
> +obj-$(CONFIG_USB_GSPCA_TOUPTEK)  += gspca_touptek.o
>  obj-$(CONFIG_USB_GSPCA_TV8532)   += gspca_tv8532.o
>  obj-$(CONFIG_USB_GSPCA_VC032X)   += gspca_vc032x.o
>  obj-$(CONFIG_USB_GSPCA_VICAM)    += gspca_vicam.o
> @@ -86,6 +87,7 @@ gspca_stv0680-objs  := stv0680.o
>  gspca_sunplus-objs  := sunplus.o
>  gspca_t613-objs     := t613.o
>  gspca_topro-objs    := topro.o
> +gspca_touptek-objs  := touptek.o
>  gspca_tv8532-objs   := tv8532.o
>  gspca_vc032x-objs   := vc032x.o
>  gspca_vicam-objs    := vicam.o
> diff --git a/drivers/media/usb/gspca/touptek.c b/drivers/media/usb/gspca/touptek.c
> new file mode 100644
> index 0000000..a379f5f
> --- /dev/null
> +++ b/drivers/media/usb/gspca/touptek.c
> @@ -0,0 +1,859 @@
> +/*
> + * ToupTek UCMOS / AmScope MU series camera driver
> + * TODO: contrast with ScopeTek / AmScope MDC cameras
> + *
> + * Copyright (C) 2012-2014 John McMaster <JohnDMcMaster@gmail.com>
> + *
> + * Special thanks to Bushing for helping with the decrypt algorithm and
> + * Sean O'Sullivan / the Rensselaer Center for Open Source
> + * Software (RCOS) for helping me learn kernel development
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> + */
> +
> +#include "gspca.h"
> +
> +#define MODULE_NAME "touptek"
> +
> +MODULE_AUTHOR("John McMaster");
> +MODULE_DESCRIPTION("ToupTek UCMOS / Amscope MU microscope camera driver");
> +MODULE_LICENSE("GPL");
> +
> +/*
> +Exposure reg is linear with exposure time
> +Exposure (sec), E (reg)
> +0.000400, 0x0002
> +0.001000, 0x0005
> +0.005000, 0x0019
> +0.020000, 0x0064
> +0.080000, 0x0190
> +0.400000, 0x07D0
> +1.000000, 0x1388
> +2.000000, 0x2710
> +*/
> +
> +/*
> +Three gain stages
> +0x1000: master channel enable bit
> +0x007F: low gain bits
> +0x0080: medium gain bit
> +0x0100: high gain bit
> +gain = enable * (1 + regH) * (1 + regM) * z * regL
> +
> +Gain implementation
> +Goal: simple conversion for default gain at 1.00
> +Want to do something similar to mt9v011.c's set_balance
> +Problem: can lead to gains higher than possible
> +When this happens the gain is clipped and a debug warning is emitted
> +
> +green_gain = sd->global_gain
> +blue_gain = sd->global_gain +
> +	((uint32_t)sd->global_gain) * sd->blue_bal / GAIN_MAX;
> +red_gain = sd->global_gain +
> +	((uint32_t)sd->global_gain) * sd->blue_bal / GAIN_MAX;
> +
> +Want initial gain of 1.4 (since it works well for me ;) ):
> +-G: 128 => global_gain = 128
> +-B: 148 => blue_bal = 80
> +    148 = 128 + 128 * blue_bal / 511
> +-R: 202 => red_bal = 295
> +    202 = 128 + 128 * red_bal / 511
> +
> +Gain does not vary with resolution (checked 640x480 vs 1600x1200)
> +
> +
> +Constant derivation:
> +
> +Raw data:
> +Gain,   GTOP,   B,	  R,	  GBOT
> +1.00,   0x105C, 0x1068, 0x10C8, 0x105C
> +1.20,   0x106E, 0x107E, 0x10D6, 0x106E
> +1.40,   0x10C0, 0x10CA, 0x10E5, 0x10C0
> +1.60,   0x10C9, 0x10D4, 0x10F3, 0x10C9
> +1.80,   0x10D2, 0x10DE, 0x11C1, 0x10D2
> +2.00,   0x10DC, 0x10E9, 0x11C8, 0x10DC
> +2.20,   0x10E5, 0x10F3, 0x11CF, 0x10E5
> +2.40,   0x10EE, 0x10FE, 0x11D7, 0x10EE
> +2.60,   0x10F7, 0x11C4, 0x11DE, 0x10F7
> +2.80,   0x11C0, 0x11CA, 0x11E5, 0x11C0
> +3.00,   0x11C5, 0x11CF, 0x11ED, 0x11C5
> +
> +zR = 0.0069605943152454778
> +	about 3/431 = 0.0069605568445475635
> +zB = 0.0095695970695970703
> +	about 6/627 = 0.0095693779904306216
> +zG = 0.010889328063241107
> +	about 6/551 = 0.010889292196007259
> +about 10 bits for constant + 7 bits for value => at least 17 bit intermediate
> +with 32 bit ints should be fine for overflow etc
> +Essentially gains are in range 0-0x001FF
> +
> +However, V4L expects a main gain channel + R and B balance
> +To keep things simple for now saturate the values of balance is too high/low
> +This isn't really ideal but easy way to fit the Linux model
> +
> +Converted using gain model turns out to be quite linear:
> +Gain, GTOP, B, R, GBOT
> +1.00, 92, 104, 144, 92
> +1.20, 110, 126, 172, 110
> +1.40, 128, 148, 202, 128
> +1.60, 146, 168, 230, 146
> +1.80, 164, 188, 260, 164
> +2.00, 184, 210, 288, 184
> +2.20, 202, 230, 316, 202
> +2.40, 220, 252, 348, 220
> +2.60, 238, 272, 376, 238
> +2.80, 256, 296, 404, 256
> +3.00, 276, 316, 436, 276
> +
> +Maximum gain is 0x7FF * 2 * 2 => 0x1FFC (8188)
> +or about 13 effective bits of gain
> +The highest the commercial driver goes in my setup 436
> +However, because could *maybe* damage circuits
> +limit the gain until have a reason to go higher
> +*/
> +#define GAIN_MAX		511
> +
> +/* Frame sync is a short read */
> +#define BULK_SIZE		0x4000
> +
> +/* MT9E001 reg names to give a rough approximation */
> +#define REG_COARSE_INTEGRATION_TIME_	0x3012
> +#define REG_GROUPED_PARAMETER_HOLD_	0x3022
> +#define REG_MODE_SELECT			0x0100
> +#define REG_OP_SYS_CLK_DIV		0x030A
> +#define REG_VT_SYS_CLK_DIV		0x0302
> +#define REG_PRE_PLL_CLK_DIV		0x0304
> +#define REG_VT_PIX_CLK_DIV		0x0300
> +#define REG_OP_PIX_CLK_DIV		0x0308
> +#define REG_PLL_MULTIPLIER		0x0306
> +#define REG_COARSE_INTEGRATION_TIME_	0x3012
> +#define REG_FRAME_LENGTH_LINES		0x0340
> +#define REG_FRAME_LENGTH_LINES_		0x300A
> +#define REG_GREEN1_GAIN			0x3056
> +#define REG_GREEN2_GAIN			0x305C
> +#define REG_GROUPED_PARAMETER_HOLD	0x0104
> +#define REG_LINE_LENGTH_PCK_		0x300C
> +#define REG_MODE_SELECT			0x0100
> +#define REG_PLL_MULTIPLIER		0x0306
> +#define REG_READ_MODE			0x3040
> +#define REG_BLUE_GAIN			0x3058
> +#define REG_RED_GAIN			0x305A
> +#define REG_RESET_REGISTER		0x301A
> +#define REG_SCALE_M			0x0404
> +#define REG_SCALING_MODE		0x0400
> +#define REG_SOFTWARE_RESET		0x0103
> +#define REG_X_ADDR_END			0x0348
> +#define REG_X_ADDR_START		0x0344
> +#define REG_X_ADDR_START		0x0344
> +#define REG_X_OUTPUT_SIZE		0x034C
> +#define REG_Y_ADDR_END			0x034A
> +#define REG_Y_ADDR_START		0x0346
> +#define REG_Y_OUTPUT_SIZE		0x034E
> +
> +
> +/* specific webcam descriptor */
> +struct sd {
> +	struct gspca_dev gspca_dev;	/* !! must be the first item */
> +	/* How many bytes this frame */
> +	unsigned int this_f;
> +
> +	/*
> +	Device has separate gains for each Bayer quadrant
> +	V4L supports master gain which is referenced to G1/G2 and supplies
> +	individual balance controls for R/B
> +	*/
> +	struct v4l2_ctrl *blue;
> +	struct v4l2_ctrl *red;
> +};
> +
> +/* Used to simplify reg write error handling */
> +struct cmd {
> +	u16 value;
> +	u16 index;
> +};
> +
> +static const struct v4l2_pix_format vga_mode[] = {
> +	{800, 600,
> +		V4L2_PIX_FMT_SGRBG8,
> +		V4L2_FIELD_NONE,
> +		.bytesperline = 800,
> +		.sizeimage = 800 * 600,
> +		.colorspace = V4L2_COLORSPACE_SRGB},
> +	{1600, 1200,
> +		V4L2_PIX_FMT_SGRBG8,
> +		V4L2_FIELD_NONE,
> +		.bytesperline = 1600,
> +		.sizeimage = 1600 * 1200,
> +		.colorspace = V4L2_COLORSPACE_SRGB},
> +	{3264, 2448,
> +		V4L2_PIX_FMT_SGRBG8,
> +		V4L2_FIELD_NONE,
> +		.bytesperline = 3264,
> +		.sizeimage = 3264 * 2448,
> +		.colorspace = V4L2_COLORSPACE_SRGB},
> +};
> +
> +/*
> +As theres no known frame sync, the only way to keep synced is to try hard
> +to never miss any packets
> +*/
> +#if MAX_NURBS < 4
> +#error "Not enough URBs in the gspca table"
> +#endif
> +
> +static int val_reply(const char *reply, int rc)
> +{
> +	if (rc < 0) {
> +		pr_warn("reply has error %d", rc);
> +		return -EIO;
> +	}
> +	if (rc != 1) {
> +		pr_warn("Bad reply size %d", rc);
> +		return -EIO;
> +	}
> +	if (reply[0] != 0x08) {
> +		pr_warn("Bad reply 0x%02X", reply[0]);
> +		return -EIO;
> +	}
> +	return 0;
> +}
> +
> +static int reg_w(struct gspca_dev *gspca_dev, u16 value, u16 index)
> +{
> +	char buff[1];
> +	int rc;
> +
> +	pr_devel("reg_w bReq=0x0B, bReqT=0xC0, wVal=0x%04X, wInd=0x%04X\n",
> +	value, index);
> +	rc = usb_control_msg(gspca_dev->dev, usb_rcvctrlpipe(gspca_dev->dev, 0),
> +		0x0B, 0xC0, value, index, buff, 1, 500);
> +	pr_devel("rc=%d, ret={0x%02X}", rc, buff[0]);
> +	if (rc < 0) {
> +		pr_warn("Failed reg_w(0x0B, 0xC0, 0x%04X, 0x%04X) w/ rc %d\n",
> +			value, index, rc);
> +		return rc;
> +	}
> +	if (val_reply(buff, rc)) {
> +		pr_warn("Bad reply to reg_w(0x0B, 0xC0, 0x%04X, 0x%04X\n",
> +			value, index);
> +		return -EIO;
> +	}
> +	return 0;
> +}
> +
> +static int reg_w_buf(struct gspca_dev *gspca_dev,
> +		const struct cmd *p, int l)
> +{
> +	do {
> +		int rc = reg_w(gspca_dev, p->value, p->index);
> +
> +		if (rc < 0)
> +			return rc;
> +		p++;
> +	} while (--l > 0);
> +	return 0;
> +}
> +
> +static int setexposure(struct gspca_dev *gspca_dev, s32 val)
> +{
> +	int rc;
> +	u16 value;
> +	unsigned int w = gspca_dev->pixfmt.width;
> +
> +	if (w == 800)
> +		value = val * 5;
> +	else if (w == 1600)
> +		value = val * 3;
> +	else if (w == 3264)
> +		value = val * 3 / 2;
> +	else {
> +		pr_devel("Invalid width %u\n", w);
> +		return -EINVAL;
> +	}
> +	pr_devel("exposure: 0x%04X ms\n", value);
> +	/* Wonder if theres a good reason for sending it twice */
> +	/* probably not but leave it in because...why not */
> +	rc = reg_w(gspca_dev, value, REG_COARSE_INTEGRATION_TIME_);
> +	if (rc)
> +		return rc;
> +	rc = reg_w(gspca_dev, value, REG_COARSE_INTEGRATION_TIME_);
> +	if (rc)
> +		return rc;
> +
> +	return 0;
> +}
> +
> +static int gainify(int in)
> +{
> +	/*
> +	TODO: check if there are any issues with corner cases
> +	0x000 (0):0x07F (127): regL
> +	0x080 (128) - 0x0FF (255): regM, regL
> +	0x100 (256) - max: regH, regM, regL
> +	*/
> +	if (in <= 0x7F)
> +		return 0x1000 | in;
> +	else if (in <= 0xFF)
> +		return 0x1080 | in / 2;
> +	else
> +		return 0x1180 | in / 4;
> +}
> +
> +static int setggain(struct gspca_dev *gspca_dev, u16 global_gain)
> +{
> +	u16 normalized;
> +	int rc;
> +
> +	normalized = gainify(global_gain);
> +	pr_devel("gain G1/G2 (0x%04X): 0x%04X (src 0x%04X)\n",
> +		 REG_GREEN1_GAIN,
> +		 normalized, global_gain);
> +
> +	rc = reg_w(gspca_dev, normalized, REG_GREEN1_GAIN);
> +	if (rc)
> +		return rc;
> +	rc = reg_w(gspca_dev, normalized, REG_GREEN2_GAIN);
> +	if (rc)
> +		return rc;
> +	return 0;
> +}
> +
> +static int setbgain(struct gspca_dev *gspca_dev,
> +		u16 gain, u16 global_gain)
> +{
> +	u16 normalized;
> +	int rc;
> +
> +	normalized = global_gain +
> +		((uint32_t)global_gain) * gain / GAIN_MAX;
> +	if (normalized > GAIN_MAX) {
> +		pr_devel("Truncating blue 0x%04X w/ value 0x%04X\n",
> +			 GAIN_MAX, normalized);
> +		normalized = GAIN_MAX;
> +	}
> +	normalized = gainify(normalized);
> +	pr_devel("gain B (0x%04X): 0x%04X w/ source 0x%04X\n",
> +		 REG_BLUE_GAIN, normalized, gain);
> +
> +	rc = reg_w(gspca_dev, normalized, REG_BLUE_GAIN);
> +	if (rc)
> +		return rc;
> +
> +	return 0;
> +}
> +
> +static int setrgain(struct gspca_dev *gspca_dev,
> +		u16 gain, u16 global_gain)
> +{
> +	u16 normalized;
> +	int rc;
> +
> +	normalized = global_gain +
> +		((uint32_t)global_gain) * gain / GAIN_MAX;
> +	if (normalized > GAIN_MAX) {
> +		pr_devel("Truncating gain 0x%04X w/ value 0x%04X\n",
> +			 GAIN_MAX, normalized);
> +		normalized = GAIN_MAX;
> +	}
> +	normalized = gainify(normalized);
> +	pr_devel("gain R (0x%04X): 0x%04X w / source 0x%04X\n",
> +		 REG_RED_GAIN, normalized, gain);
> +
> +	rc = reg_w(gspca_dev, normalized, REG_RED_GAIN);
> +	if (rc)
> +		return rc;
> +
> +	return 0;
> +}
> +
> +static int configure_wh(struct gspca_dev *gspca_dev)
> +{
> +	unsigned int rc;
> +	int w = gspca_dev->pixfmt.width;
> +
> +	pr_devel("configure_wh\n");
> +
> +	if (w == 800) {
> +		static const struct cmd reg_init_res[] = {
> +			{0x0060, REG_X_ADDR_START},
> +			{0x0CD9, REG_X_ADDR_END},
> +			{0x0036, REG_Y_ADDR_START},
> +			{0x098F, REG_Y_ADDR_END},
> +			{0x07C7, REG_READ_MODE},
> +		};
> +
> +		rc = reg_w_buf(gspca_dev,
> +			       reg_init_res, ARRAY_SIZE(reg_init_res));
> +		if (rc < 0)
> +			return rc;
> +	} else if (w == 1600) {
> +		static const struct cmd reg_init_res[] = {
> +			{0x009C, REG_X_ADDR_START},
> +			{0x0D19, REG_X_ADDR_END},
> +			{0x0068, REG_Y_ADDR_START},
> +			{0x09C5, REG_Y_ADDR_END},
> +			{0x06C3, REG_READ_MODE},
> +		};
> +
> +		rc = reg_w_buf(gspca_dev,
> +			       reg_init_res, ARRAY_SIZE(reg_init_res));
> +		if (rc < 0)
> +			return rc;
> +	} else if (w == 3264) {
> +		static const struct cmd reg_init_res[] = {
> +			{0x00E8, REG_X_ADDR_START},
> +			{0x0DA7, REG_X_ADDR_END},
> +			{0x009E, REG_Y_ADDR_START},
> +			{0x0A2D, REG_Y_ADDR_END},
> +			{0x0241, REG_READ_MODE},
> +		};
> +
> +		rc = reg_w_buf(gspca_dev,
> +			       reg_init_res, ARRAY_SIZE(reg_init_res));
> +		if (rc < 0)
> +			return rc;
> +	} else {
> +		pr_devel("bad width %u\n", w);
> +		return -EINVAL;
> +	}
> +
> +	rc = reg_w(gspca_dev, 0x0000, REG_SCALING_MODE);
> +	if (rc)
> +		return rc;
> +	rc = reg_w(gspca_dev, 0x0010, REG_SCALE_M);
> +	if (rc)
> +		return rc;
> +	rc = reg_w(gspca_dev, w, REG_X_OUTPUT_SIZE);
> +	if (rc)
> +		return rc;
> +	rc = reg_w(gspca_dev, gspca_dev->pixfmt.height, REG_Y_OUTPUT_SIZE);
> +	if (rc)
> +		return rc;
> +
> +	if (w == 800) {
> +		rc = reg_w(gspca_dev, 0x0384, REG_FRAME_LENGTH_LINES_);
> +		if (rc)
> +			return rc;
> +		rc = reg_w(gspca_dev, 0x0960, REG_LINE_LENGTH_PCK_);
> +		if (rc)
> +			return rc;
> +	} else if (w == 1600) {
> +		rc = reg_w(gspca_dev, 0x0640, REG_FRAME_LENGTH_LINES_);
> +		if (rc)
> +			return rc;
> +		rc = reg_w(gspca_dev, 0x0FA0, REG_LINE_LENGTH_PCK_);
> +		if (rc)
> +			return rc;
> +	} else if (w == 3264) {
> +		rc = reg_w(gspca_dev, 0x0B4B, REG_FRAME_LENGTH_LINES_);
> +		if (rc)
> +			return rc;
> +		rc = reg_w(gspca_dev, 0x1F40, REG_LINE_LENGTH_PCK_);
> +		if (rc)
> +			return rc;
> +	} else {
> +		pr_devel("bad width %u\n", w);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +/* Packets that were encrypted, no idea if the grouping is significant */
> +static int configure_encrypted(struct gspca_dev *gspca_dev)
> +{
> +	struct sd *sd = (struct sd *) gspca_dev;
> +	unsigned int rc;
> +	u16 global_gain;
> +	static const struct cmd reg_init_begin[] = {
> +		{0x0100, REG_SOFTWARE_RESET},
> +		{0x0000, REG_MODE_SELECT},
> +		{0x0100, REG_GROUPED_PARAMETER_HOLD},
> +		{0x0004, REG_VT_PIX_CLK_DIV},
> +		{0x0001, REG_VT_SYS_CLK_DIV},
> +		{0x0008, REG_OP_PIX_CLK_DIV},
> +		{0x0001, REG_OP_SYS_CLK_DIV},
> +		{0x0004, REG_PRE_PLL_CLK_DIV},
> +		{0x0040, REG_PLL_MULTIPLIER},
> +		{0x0000, REG_GROUPED_PARAMETER_HOLD},
> +		{0x0100, REG_GROUPED_PARAMETER_HOLD},
> +	};
> +	static const struct cmd reg_init_end[] = {
> +		{0x0000, REG_GROUPED_PARAMETER_HOLD},
> +		{0x0301, 0x31AE},
> +		{0x0805, 0x3064},
> +		{0x0071, 0x3170},
> +		{0x10DE, REG_RESET_REGISTER},
> +		{0x0000, REG_MODE_SELECT},
> +		{0x0010, REG_PLL_MULTIPLIER},
> +		{0x0100, REG_MODE_SELECT},
> +	};
> +
> +	pr_devel("Encrypted begin, w = %u\n", gspca_dev->pixfmt.width);
> +	rc = reg_w_buf(gspca_dev, reg_init_begin, ARRAY_SIZE(reg_init_begin));
> +	if (rc < 0)
> +		return rc;
> +	rc = configure_wh(gspca_dev);
> +	if (rc < 0)
> +		return rc;
> +	rc = reg_w_buf(gspca_dev, reg_init_end, ARRAY_SIZE(reg_init_end));
> +	if (rc < 0)
> +		return rc;
> +
> +	pr_devel("setting exposure\n");
> +	rc = setexposure(gspca_dev, v4l2_ctrl_g_ctrl(gspca_dev->exposure));
> +	if (rc) {
> +		pr_devel("Failed to set exposure\n");
> +		return rc;
> +	}
> +
> +	rc = reg_w(gspca_dev, 0x0100, REG_GROUPED_PARAMETER_HOLD);
> +	if (rc)
> +		return rc;
> +
> +	/* XXX: seems done automaticly, should rmeove? */
> +	pr_devel("setting gain\n");
> +	global_gain = v4l2_ctrl_g_ctrl(gspca_dev->gain);
> +	rc = setggain(gspca_dev, global_gain);
> +	if (rc) {
> +		pr_devel("Failed to set green gain\n");
> +		return rc;
> +	}
> +	rc = setbgain(gspca_dev, v4l2_ctrl_g_ctrl(sd->blue), global_gain);
> +	if (rc) {
> +		pr_devel("Failed to set blue gain\n");
> +		return rc;
> +	}
> +	rc = setrgain(gspca_dev, v4l2_ctrl_g_ctrl(sd->red), global_gain);
> +	if (rc) {
> +		pr_devel("Failed to set red gain\n");
> +		return rc;
> +	}
> +
> +	rc = reg_w(gspca_dev, 0x0000, REG_GROUPED_PARAMETER_HOLD);
> +	if (rc)
> +		return rc;
> +
> +	pr_devel("Encrypted end\n");
> +	return 0;
> +}
> +
> +static int configure(struct gspca_dev *gspca_dev)
> +{
> +	uint8_t buff[4];
> +	unsigned int rc;
> +
> +	pr_devel("configure()\n");
> +
> +	/*
> +	First driver sets a sort of encryption key
> +	A number of futur requests of this type have wValue and wIndex encrypted
> +	as follows:
> +	-Compute key = this wValue rotate left by 4 bits
> +		(decrypt.py rotates right because we are decrypting)
> +	-Later packets encrypt packets by XOR'ing with key
> +		XOR encrypt/decrypt is symmetrical
> +		wValue, and wIndex are encrypted
> +		bRequest is not and bRequestType is always 0xC0
> +			This allows resyncing if key is unknown?
> +	By setting 0 we XOR with 0 and the shifting and XOR drops out
> +	*/
> +	rc = usb_control_msg(gspca_dev->dev, usb_rcvctrlpipe(gspca_dev->dev, 0),
> +			     0x16, 0xC0, 0x0000, 0x0000, buff, 2, 500);
> +	if (val_reply(buff, rc)) {
> +		pr_warn("failed key req");
> +		return -EIO;
> +	}
> +
> +	/*
> +	Next does some sort of 2 packet challenge / response
> +	evidence suggests its an Atmel I2C crypto part but nobody cares to look
> +	(to make sure its not cloned hardware?)
> +	Ignore: I want to work with their hardware, not clone it
> +	16 bytes out challenge, requestType: 0x40
> +	16 bytes in response, requestType: 0xC0
> +	*/
> +
> +	rc = usb_control_msg(gspca_dev->dev, usb_sndctrlpipe(gspca_dev->dev, 0),
> +			     0x01, 0x40, 0x0001, 0x000F, NULL, 0, 500);
> +	if (rc < 0) {
> +		pr_warn("failed to replay packet 176 w/ rc %d\n", rc);
> +		return rc;
> +	}
> +
> +	rc = usb_control_msg(gspca_dev->dev, usb_sndctrlpipe(gspca_dev->dev, 0),
> +			     0x01, 0x40, 0x0000, 0x000F, NULL, 0, 500);
> +	if (rc < 0) {
> +		pr_warn("failed to replay packet 178 w/ rc %d\n", rc);
> +		return rc;
> +	}
> +
> +	rc = usb_control_msg(gspca_dev->dev, usb_sndctrlpipe(gspca_dev->dev, 0),
> +			     0x01, 0x40, 0x0001, 0x000F, NULL, 0, 500);
> +	if (rc < 0) {
> +		pr_warn("failed to replay packet 180 w/ rc %d\n", rc);
> +		return rc;
> +	}
> +
> +	rc = usb_control_msg(gspca_dev->dev, usb_rcvctrlpipe(gspca_dev->dev, 0),
> +			     0x20, 0xC0, 0x0000, 0x0000, buff, 4, 500);
> +	/* Serial number?  cam1: \xE6\x0D\x00\x00, cam2: \x70\x19\x00\x00 */
> +	if (rc != 4) {
> +		pr_warn("failed to replay packet 182 w/ rc %d\n", rc);
> +		if (rc < 0)
> +			return rc;
> +		return -EIO;
> +	}
> +
> +	/* Large (EEPROM?) read, skip it since no idea what to do with it */
> +
> +	rc = configure_encrypted(gspca_dev);
> +	if (rc)
> +		return rc;
> +
> +	/* Omitted this by accident, does not work without it */
> +	rc = usb_control_msg(gspca_dev->dev, usb_sndctrlpipe(gspca_dev->dev, 0),
> +			     0x01, 0x40, 0x0003, 0x000F, NULL, 0, 500);
> +
> +	pr_devel("Configure complete\n");
> +	return 0;
> +}
> +
> +static int sd_config(struct gspca_dev *gspca_dev,
> +		     const struct usb_device_id *id)
> +{
> +	pr_devel("sd_config start\n");
> +	gspca_dev->cam.cam_mode = vga_mode;
> +	gspca_dev->cam.nmodes = ARRAY_SIZE(vga_mode);
> +	pr_devel("cam modes size: %d\n", gspca_dev->cam.nmodes);
> +
> +	pr_devel("Input flags: 0x%08X\n", gspca_dev->cam.input_flags);
> +	/* Yes we want URBs and we want them now! */
> +	gspca_dev->cam.no_urb_create = 0;
> +	/* TODO: considering increasing much higher */
> +	/* Without frame sync we need to make sure we never drop */
> +	pr_devel("Max nurbs: %d\n", MAX_NURBS);
> +	gspca_dev->cam.bulk_nurbs = 4;
> +	/* Largest size the windows driver uses */
> +	gspca_dev->cam.bulk_size = BULK_SIZE;
> +	/* Def need to use bulk transfers */
> +	gspca_dev->cam.bulk = 1;
> +
> +	pr_devel("sd_config end\n");
> +	return 0;
> +}
> +
> +static int sd_start(struct gspca_dev *gspca_dev)
> +{
> +	struct sd *sd = (struct sd *) gspca_dev;
> +	int rc;
> +
> +	pr_devel("sd_start()\n");
> +	sd->this_f = 0;
> +
> +	rc = configure(gspca_dev);
> +	if (rc < 0) {
> +		pr_warn("Failed configure");
> +		return rc;
> +	}
> +	/* First two frames have messed up gains
> +	Drop them to avoid special cases in user apps? */
> +	pr_devel("sd_start() end, status %d\n", gspca_dev->usb_err);
> +	return gspca_dev->usb_err;
> +}
> +
> +static void sd_pkt_scan(struct gspca_dev *gspca_dev,
> +			u8 *data,	/* isoc packet */
> +			int len)	/* iso packet length */
> +{
> +	struct sd *sd = (struct sd *) gspca_dev;
> +
> +	if (len != BULK_SIZE) {
> +		/* can we finish a frame? */
> +		if (sd->this_f + len == gspca_dev->pixfmt.sizeimage) {
> +			gspca_frame_add(gspca_dev, LAST_PACKET, data, len);
> +			pr_devel("finish frame sz %u/%u w/ len %u\n",
> +				 sd->this_f, gspca_dev->pixfmt.sizeimage, len);
> +		/* lost some data, discard the frame */
> +		} else {
> +			gspca_frame_add(gspca_dev, DISCARD_PACKET, NULL, 0);
> +			pr_devel("abort frame sz %u/%u w/ len %u\n",
> +				 sd->this_f, gspca_dev->pixfmt.sizeimage, len);
> +		}
> +		sd->this_f = 0;
> +	} else {
> +		if (sd->this_f == 0)
> +			gspca_frame_add(gspca_dev, FIRST_PACKET, data, len);
> +		else
> +			gspca_frame_add(gspca_dev, INTER_PACKET, data, len);
> +		sd->this_f += len;
> +	}
> +}
> +
> +static int sd_init(struct gspca_dev *gspca_dev)
> +{
> +	return 0;
> +}
> +
> +static int sd_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct gspca_dev *gspca_dev =
> +		container_of(ctrl->handler, struct gspca_dev, ctrl_handler);
> +	struct sd *sd = (struct sd *) gspca_dev;
> +
> +	gspca_dev->usb_err = 0;
> +
> +	if (!gspca_dev->streaming)
> +		return 0;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_EXPOSURE:
> +		setexposure(gspca_dev, ctrl->val);
> +		break;
> +	case V4L2_CID_GAIN:
> +		/* gspca_dev->gain automatically updated */
> +		setggain(gspca_dev, gspca_dev->gain->val);
> +		break;
> +	case V4L2_CID_BLUE_BALANCE:
> +		sd->blue->val = ctrl->val;
> +		setbgain(gspca_dev, sd->blue->val, gspca_dev->gain->val);
> +		break;
> +	case V4L2_CID_RED_BALANCE:
> +		sd->red->val = ctrl->val;
> +		setrgain(gspca_dev, sd->red->val, gspca_dev->gain->val);
> +		break;
> +	}
> +	return gspca_dev->usb_err;
> +}
> +
> +static const struct v4l2_ctrl_ops sd_ctrl_ops = {
> +	.s_ctrl = sd_s_ctrl,
> +};
> +
> +static int sd_init_controls(struct gspca_dev *gspca_dev)
> +{
> +	struct sd *sd = (struct sd *) gspca_dev;
> +	struct v4l2_ctrl_handler *hdl = &gspca_dev->ctrl_handler;
> +
> +	gspca_dev->vdev.ctrl_handler = hdl;
> +	v4l2_ctrl_handler_init(hdl, 4);
> +
> +	gspca_dev->exposure = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
> +	/* Mostly limited by URB timeouts */
> +	/* XXX: make dynamic based on frame rate? */
> +		V4L2_CID_EXPOSURE, 0, 800, 1, 350);
> +	gspca_dev->gain = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
> +			V4L2_CID_GAIN, 0, 511, 1, 128);
> +	sd->blue = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
> +			V4L2_CID_BLUE_BALANCE, 0, 511, 1, 80);
> +	sd->red = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
> +			V4L2_CID_RED_BALANCE, 0, 511, 1, 295);
> +
> +	if (hdl->error) {
> +		pr_err("Could not initialize controls\n");
> +		return hdl->error;
> +	}
> +	return 0;
> +}
> +
> +/* sub-driver description */
> +static const struct sd_desc sd_desc = {
> +	.name = MODULE_NAME,
> +	.config = sd_config,
> +	.config = sd_config,
> +	.init = sd_init,
> +	.init_controls = sd_init_controls,
> +	.start = sd_start,
> +	.pkt_scan = sd_pkt_scan,
> +};
> +
> +/* Table of supported USB devices */
> +static const struct usb_device_id device_table[] = {
> +	/* Commented out devices should be related */
> +	/* AS: AmScope, TT: ToupTek */
> +	/* { USB_DEVICE(0x0547, 0x6035) },  TT UCMOS00350KPA */
> +	/* { USB_DEVICE(0x0547, 0x6130) },  TT UCMOS01300KPA */
> +	/* { USB_DEVICE(0x0547, 0x6200) },  TT UCMOS02000KPA */
> +	/* { USB_DEVICE(0x0547, 0x6310) },  TT UCMOS03100KPA */
> +	/* { USB_DEVICE(0x0547, 0x6510) },  TT UCMOS05100KPA */
> +	/* { USB_DEVICE(0x0547, 0x6800) },  TT UCMOS08000KPA */
> +	/* { USB_DEVICE(0x0547, 0x6801) },  TT UCMOS08000KPB */
> +	{ USB_DEVICE(0x0547, 0x6801) }, /* TT UCMOS08000KPB, AS MU800 */
> +	/* { USB_DEVICE(0x0547, 0x6900) },  TT UCMOS09000KPA */
> +	/* { USB_DEVICE(0x0547, 0x6901) },  TT UCMOS09000KPB */
> +	/* { USB_DEVICE(0x0547, 0x6010) },  TT UCMOS10000KPA */
> +	/* { USB_DEVICE(0x0547, 0x6014) },  TT UCMOS14000KPA */
> +	/* { USB_DEVICE(0x0547, 0x6131) },  TT UCMOS01300KMA */
> +	/* { USB_DEVICE(0x0547, 0x6511) },  TT UCMOS05100KMA */
> +	/* { USB_DEVICE(0x0547, 0x8080) },  TT UHCCD00800KPA */
> +	/* { USB_DEVICE(0x0547, 0x8140) },  TT UHCCD01400KPA */
> +	/* { USB_DEVICE(0x0547, 0x8141) },  TT EXCCD01400KPA */
> +	/* { USB_DEVICE(0x0547, 0x8200) },  TT UHCCD02000KPA */
> +	/* { USB_DEVICE(0x0547, 0x8201) },  TT UHCCD02000KPB */
> +	/* { USB_DEVICE(0x0547, 0x8310) },  TT UHCCD03100KPA */
> +	/* { USB_DEVICE(0x0547, 0x8500) },  TT UHCCD05000KPA */
> +	/* { USB_DEVICE(0x0547, 0x8510) },  TT UHCCD05100KPA */
> +	/* { USB_DEVICE(0x0547, 0x8600) },  TT UHCCD06000KPA */
> +	/* { USB_DEVICE(0x0547, 0x8800) },  TT UHCCD08000KPA */
> +	/* { USB_DEVICE(0x0547, 0x8315) },  TT UHCCD03150KPA */
> +	/* { USB_DEVICE(0x0547, 0x7800) },  TT UHCCD00800KMA */
> +	/* { USB_DEVICE(0x0547, 0x7140) },  TT UHCCD01400KMA */
> +	/* { USB_DEVICE(0x0547, 0x7141) },  TT UHCCD01400KMB */
> +	/* { USB_DEVICE(0x0547, 0x7200) },  TT UHCCD02000KMA */
> +	/* { USB_DEVICE(0x0547, 0x7315) },  TT UHCCD03150KMA */
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(usb, device_table);
> +
> +static int sd_probe(struct usb_interface *intf,
> +		    const struct usb_device_id *id)
> +{
> +	int rc = 0;
> +	pr_devel("sd_probe()\n");
> +	rc = gspca_dev_probe(intf, id, &sd_desc, sizeof(struct sd),
> +			     THIS_MODULE);
> +	pr_devel("sd_probe() rc %d\n", rc);
> +	return rc;
> +}
> +
> +static struct usb_driver sd_driver = {
> +	.name = MODULE_NAME,
> +	.id_table = device_table,
> +	.probe = sd_probe,
> +	.disconnect = gspca_disconnect,
> +#ifdef CONFIG_PM
> +	.suspend = gspca_suspend,
> +	.resume = gspca_resume,
> +#endif
> +};
> +
> +static int __init sd_mod_init(void)
> +{
> +	int ret;
> +
> +	ret = usb_register(&sd_driver);
> +	if (ret < 0)
> +		return ret;
> +	return 0;
> +}
> +static void __exit sd_mod_exit(void)
> +{
> +	usb_deregister(&sd_driver);
> +}
> +
> +module_init(sd_mod_init);
> +module_exit(sd_mod_exit);
> +
> 
