Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab3JJJev (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 05:34:51 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:37107 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab3JJJes convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 05:34:48 -0400
X-RZG-AUTH: :JGIXVUS7cutRB/49FwqZ7WcKdUCnXG6JabOfSXKWrat+gNPrzo0=
X-RZG-CLASS-ID: mo00
Subject: Re: [PATCH] omapdss: Add new panel driver for Topolly td028ttec1 LCD.
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <525662F5.3090600@ti.com>
Date: Thu, 10 Oct 2013 11:34:44 +0200
Cc: Marek Belisko <marek@goldelico.com>, <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <7FAC77D4-5E1E-4B11-B067-3A8233C69240@goldelico.com>
References: <1381352915-17219-1-git-send-email-marek@goldelico.com> <525662F5.3090600@ti.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi,

Am 10.10.2013 um 10:19 schrieb Tomi Valkeinen:

> Hi,
> 
> On 10/10/13 00:08, Marek Belisko wrote:
>> For communicating with driver is used gpio bitbanging because TD028 does
>> not have a standard compliant SPI interface. It is a 3-wire thing with
>> direction reversal.
> 
> Isn't that SPI_3WIRE?

Maybe - but we have no complete datasheet and I don't know an official spec of
a 3-wire SPI protocol to compare how 3-wire should work.

And I think (but I may be wrong) that SPI_3WIRE is an optional feature of the SoC
specific SPI drivers and in my understanding the OMAP has no such driver:

http://lxr.free-electrons.com/source/drivers/spi/spi-omap2-mcspi.c#L874

And spi-bitbang.c hasn't either.

So I would prefer to leave this as an area for optimizations for future work.
Maybe we can add some more comments on this.

> 
>> Communication with display is used only during panel enable/disable so it's
>> not performance issue.
>> 
>> Signed-off-by: Marek Belisko <marek@goldelico.com>
>> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
>> ---
>> drivers/video/omap2/displays-new/Kconfig           |   6 +
>> drivers/video/omap2/displays-new/Makefile          |   1 +
>> .../omap2/displays-new/panel-tpo-td028ttec1.c      | 537 +++++++++++++++++++++
>> include/video/omap-panel-data.h                    |  22 +
>> 4 files changed, 566 insertions(+)
>> create mode 100644 drivers/video/omap2/displays-new/panel-tpo-td028ttec1.c
>> 
>> diff --git a/drivers/video/omap2/displays-new/Kconfig b/drivers/video/omap2/displays-new/Kconfig
>> index 6c90885..3f86432 100644
>> --- a/drivers/video/omap2/displays-new/Kconfig
>> +++ b/drivers/video/omap2/displays-new/Kconfig
>> @@ -56,6 +56,11 @@ config DISPLAY_PANEL_SHARP_LS037V7DW01
>>         help
>>           LCD Panel used in TI's SDP3430 and EVM boards
>> 
>> +config DISPLAY_PANEL_TPO_TD028TTEC1
>> +        tristate "TPO TD028TTEC1 LCD Panel"
>> +        help
>> +          LCD panel used by Openmoko.
>> +
>> config DISPLAY_PANEL_TPO_TD043MTEA1
>>         tristate "TPO TD043MTEA1 LCD Panel"
>>         depends on SPI
>> @@ -70,4 +75,5 @@ config DISPLAY_PANEL_NEC_NL8048HL11
>> 		This NEC NL8048HL11 panel is TFT LCD used in the
>> 		Zoom2/3/3630 sdp boards.
>> 
>> +
> 
> Extra change.
> 
>> endmenu
>> diff --git a/drivers/video/omap2/displays-new/Makefile b/drivers/video/omap2/displays-new/Makefile
>> index 5aeb11b..0323a8a 100644
>> --- a/drivers/video/omap2/displays-new/Makefile
>> +++ b/drivers/video/omap2/displays-new/Makefile
>> @@ -8,5 +8,6 @@ obj-$(CONFIG_DISPLAY_PANEL_DSI_CM) += panel-dsi-cm.o
>> obj-$(CONFIG_DISPLAY_PANEL_SONY_ACX565AKM) += panel-sony-acx565akm.o
>> obj-$(CONFIG_DISPLAY_PANEL_LGPHILIPS_LB035Q02) += panel-lgphilips-lb035q02.o
>> obj-$(CONFIG_DISPLAY_PANEL_SHARP_LS037V7DW01) += panel-sharp-ls037v7dw01.o
>> +obj-$(CONFIG_DISPLAY_PANEL_TPO_TD028TTEC1) += panel-tpo-td028ttec1.o
>> obj-$(CONFIG_DISPLAY_PANEL_TPO_TD043MTEA1) += panel-tpo-td043mtea1.o
>> obj-$(CONFIG_DISPLAY_PANEL_NEC_NL8048HL11) += panel-nec-nl8048hl11.o
>> diff --git a/drivers/video/omap2/displays-new/panel-tpo-td028ttec1.c b/drivers/video/omap2/displays-new/panel-tpo-td028ttec1.c
>> new file mode 100644
>> index 0000000..b63586e
>> --- /dev/null
>> +++ b/drivers/video/omap2/displays-new/panel-tpo-td028ttec1.c
>> @@ -0,0 +1,537 @@
>> +/*
>> + * Toppoly TD028TTEC1 panel support
>> + *
>> + * Copyright (C) 2008 Nokia Corporation
>> + * Author: Tomi Valkeinen <tomi.valkeinen@nokia.com>
>> + *
>> + * Neo 1973 code (jbt6k74.c):
>> + * Copyright (C) 2006-2007 by OpenMoko, Inc.
>> + * Author: Harald Welte <laforge@openmoko.org>
>> + *
>> + * Ported and adapted from Neo 1973 U-Boot by:
>> + * H. Nikolaus Schaller <hns@goldelico.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License version 2 as published by
>> + * the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but WITHOUT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
>> + * more details.
>> + *
>> + * You should have received a copy of the GNU General Public License along with
>> + * this program.  If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/delay.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/gpio.h>
>> +#include <video/omapdss.h>
>> +#include <video/omap-panel-data.h>
>> +
>> +struct panel_drv_data {
>> +	struct omap_dss_device dssdev;
>> +	struct omap_dss_device *in;
>> +
>> +	int data_lines;
>> +
>> +	struct omap_video_timings videomode;
>> +
>> +	int cs_gpio;
>> +	int scl_gpio;
>> +	int din_gpio;
>> +	int dout_gpio;
> 
> Three wires, but four gpios? What am I missing here...

We have wired up the 3-wire SPI interface of the display
to 4 wires of the McSPI interface because we initially thought
that it could work in 4 wire mode as well.

The next step we did was to port the driver code from the
Openmoko Neo1973 U-Boot which used the gpio-bitbang
mechanism.

Since it worked and is used only for enabling/disabling the
display and for no other purpose we never felt it important
to check or modify the code to use SPI.

But you are right - we don't use the din_gpio really since
we never read registers from the chip. So 3 gpios could be
sufficient.

Or we must handle the case that din_gpio == dout_gpio
in panel_probe to avoid duplicate use of the same gpio.

> 
>> +	u_int16_t tx_buf[4];
> 
> Hmm, what's wrong with "u16"?

Nothing. Maybe a relict from taking years old u-boot code and not
recognising because the compiler did not complain...

> 
>> +};
>> +
>> +static struct omap_video_timings td028ttec1_panel_timings = {
>> +	.x_res		= 480,
>> +	.y_res		= 640,
>> +	.pixel_clock	= 22153,
>> +	.hfp		= 24,
>> +	.hsw		= 8,
>> +	.hbp		= 8,
>> +	.vfp		= 4,
>> +	.vsw		= 2,
>> +	.vbp		= 2,
>> +
>> +	.vsync_level	= OMAPDSS_SIG_ACTIVE_LOW,
>> +	.hsync_level	= OMAPDSS_SIG_ACTIVE_LOW,
>> +
>> +	.data_pclk_edge	= OMAPDSS_DRIVE_SIG_FALLING_EDGE,
>> +	.de_level	= OMAPDSS_SIG_ACTIVE_HIGH,
>> +	.sync_pclk_edge	= OMAPDSS_DRIVE_SIG_OPPOSITE_EDGES,
>> +};
>> +
>> +#define JBT_COMMAND	0x000
>> +#define JBT_DATA	0x100
>> +
>> +/* 150uS minimum clock cycle, we have two of this plus our other
>> + * instructions */
>> +
>> +#define SPI_DELAY()	udelay(200)
> 
> Would usleep_range work here?

Yes, I think that works as well.

The 150uS is a minimum and I think it would also work
much slower.

> 
> See Documentation/timers/timers-howto.txt
> 
>> +static int jbt_spi_xfer(struct panel_drv_data *data, int wordnum, int bitlen)
> 
> Hmm, if it's not SPI, maybe it shouldn't be called SPI?

Yes, we can remove the _spi_ in this name.

> 
>> +{
>> +	u_int16_t tmpdout = 0;
>> +	int   i, j;
>> +
>> +	gpio_set_value(data->cs_gpio, 0);
>> +
>> +	for (i = 0; i < wordnum; i++) {
>> +		tmpdout = data->tx_buf[i];
>> +
>> +		for (j = 0; j < bitlen; j++) {
>> +			gpio_set_value(data->scl_gpio, 0);
>> +			if (tmpdout & (1 << (bitlen-1))) {
>> +				gpio_set_value(data->dout_gpio, 1);
>> +				if (gpio_get_value(data->din_gpio) == 0)
>> +					return 1;
>> +			} else {
>> +				gpio_set_value(data->dout_gpio, 0);
>> +				if (gpio_get_value(data->din_gpio) != 0)
>> +					return 1;
>> +			}
>> +			SPI_DELAY();
>> +			gpio_set_value(data->scl_gpio, 1);
>> +			SPI_DELAY();
>> +			tmpdout <<= 1;
>> +		}
>> +	}
>> +
>> +	gpio_set_value(data->cs_gpio, 1);
>> +
>> +	return 0;
>> +}
>> +
>> +#define JBT_COMMAND	0x000
>> +#define JBT_DATA	0x100
>> +
>> +int jbt_reg_write_nodata(struct panel_drv_data *ddata, u_int8_t reg)
> 
> What's wrong with "u8"? Have I missed a memo? =)
> 
>> +{
>> +	int rc;
>> +
>> +	ddata->tx_buf[0] = JBT_COMMAND | reg;
>> +
>> +	rc = jbt_spi_xfer(ddata, 1, 9);
>> +	if (rc)
>> +		dev_warn(ddata->dssdev.dev, "Failed to write reg: %x\n", reg);
>> +
>> +	return rc;
>> +}
>> +
>> +int jbt_reg_write(struct panel_drv_data *ddata, u_int8_t reg, u_int8_t data)
>> +{
>> +	int rc;
>> +
>> +	ddata->tx_buf[0] = JBT_COMMAND | reg;
>> +	ddata->tx_buf[1] = JBT_DATA | data;
>> +
>> +	rc = jbt_spi_xfer(ddata, 2, 9);
>> +	if (rc)
>> +		dev_warn(ddata->dssdev.dev, "Failed to write reg: %x\n", reg);
>> +
>> +	return rc;
>> +}
>> +
>> +int jbt_reg_write16(struct panel_drv_data *ddata, u_int8_t reg, u_int16_t data)
>> +{
>> +	int rc;
>> +
>> +	ddata->tx_buf[0] = JBT_COMMAND | reg;
>> +	ddata->tx_buf[1] = JBT_DATA | (data >> 8);
>> +	ddata->tx_buf[2] = JBT_DATA | (data & 0xff);
>> +
>> +	rc = jbt_spi_xfer(ddata, 3, 9);
>> +	if (rc)
>> +		dev_warn(ddata->dssdev.dev, "Failed to write reg: %x\n", reg);
>> +
>> +	return rc;
>> +}
>> +
>> +enum jbt_register {
>> +	JBT_REG_SLEEP_IN		= 0x10,
>> +	JBT_REG_SLEEP_OUT		= 0x11,
>> +
>> +	JBT_REG_DISPLAY_OFF		= 0x28,
>> +	JBT_REG_DISPLAY_ON		= 0x29,
>> +
>> +	JBT_REG_RGB_FORMAT		= 0x3a,
>> +	JBT_REG_QUAD_RATE		= 0x3b,
>> +
>> +	JBT_REG_POWER_ON_OFF		= 0xb0,
>> +	JBT_REG_BOOSTER_OP		= 0xb1,
>> +	JBT_REG_BOOSTER_MODE		= 0xb2,
>> +	JBT_REG_BOOSTER_FREQ		= 0xb3,
>> +	JBT_REG_OPAMP_SYSCLK		= 0xb4,
>> +	JBT_REG_VSC_VOLTAGE		= 0xb5,
>> +	JBT_REG_VCOM_VOLTAGE		= 0xb6,
>> +	JBT_REG_EXT_DISPL		= 0xb7,
>> +	JBT_REG_OUTPUT_CONTROL		= 0xb8,
>> +	JBT_REG_DCCLK_DCEV		= 0xb9,
>> +	JBT_REG_DISPLAY_MODE1		= 0xba,
>> +	JBT_REG_DISPLAY_MODE2		= 0xbb,
>> +	JBT_REG_DISPLAY_MODE		= 0xbc,
>> +	JBT_REG_ASW_SLEW		= 0xbd,
>> +	JBT_REG_DUMMY_DISPLAY		= 0xbe,
>> +	JBT_REG_DRIVE_SYSTEM		= 0xbf,
>> +
>> +	JBT_REG_SLEEP_OUT_FR_A		= 0xc0,
>> +	JBT_REG_SLEEP_OUT_FR_B		= 0xc1,
>> +	JBT_REG_SLEEP_OUT_FR_C		= 0xc2,
>> +	JBT_REG_SLEEP_IN_LCCNT_D	= 0xc3,
>> +	JBT_REG_SLEEP_IN_LCCNT_E	= 0xc4,
>> +	JBT_REG_SLEEP_IN_LCCNT_F	= 0xc5,
>> +	JBT_REG_SLEEP_IN_LCCNT_G	= 0xc6,
>> +
>> +	JBT_REG_GAMMA1_FINE_1		= 0xc7,
>> +	JBT_REG_GAMMA1_FINE_2		= 0xc8,
>> +	JBT_REG_GAMMA1_INCLINATION	= 0xc9,
>> +	JBT_REG_GAMMA1_BLUE_OFFSET	= 0xca,
>> +
>> +	JBT_REG_BLANK_CONTROL		= 0xcf,
>> +	JBT_REG_BLANK_TH_TV		= 0xd0,
>> +	JBT_REG_CKV_ON_OFF		= 0xd1,
>> +	JBT_REG_CKV_1_2			= 0xd2,
>> +	JBT_REG_OEV_TIMING		= 0xd3,
>> +	JBT_REG_ASW_TIMING_1		= 0xd4,
>> +	JBT_REG_ASW_TIMING_2		= 0xd5,
>> +
>> +	JBT_REG_HCLOCK_VGA		= 0xec,
>> +	JBT_REG_HCLOCK_QVGA		= 0xed,
>> +};
>> +
>> +#define to_panel_data(p) container_of(p, struct panel_drv_data, dssdev)
>> +
>> +static int td028ttec1_panel_connect(struct omap_dss_device *dssdev)
>> +{
>> +	struct panel_drv_data *ddata = to_panel_data(dssdev);
>> +	struct omap_dss_device *in = ddata->in;
>> +	int r;
>> +
>> +	if (omapdss_device_is_connected(dssdev))
>> +		return 0;
>> +
>> +	r = in->ops.dpi->connect(in, dssdev);
>> +	if (r)
>> +		return r;
>> +
>> +	return 0;
>> +}
>> +
>> +static void td028ttec1_panel_disconnect(struct omap_dss_device *dssdev)
>> +{
>> +	struct panel_drv_data *ddata = to_panel_data(dssdev);
>> +	struct omap_dss_device *in = ddata->in;
>> +
>> +	if (!omapdss_device_is_connected(dssdev))
>> +		return;
>> +
>> +	in->ops.dpi->disconnect(in, dssdev);
>> +}
>> +
>> +static int td028ttec1_panel_enable(struct omap_dss_device *dssdev)
>> +{
>> +	struct panel_drv_data *ddata = to_panel_data(dssdev);
>> +	struct omap_dss_device *in = ddata->in;
>> +	int r;
>> +
>> +	if (!omapdss_device_is_connected(dssdev))
>> +		return -ENODEV;
>> +
>> +	if (omapdss_device_is_enabled(dssdev))
>> +		return 0;
>> +
>> +	in->ops.dpi->set_data_lines(in, ddata->data_lines);
>> +	in->ops.dpi->set_timings(in, &ddata->videomode);
>> +
>> +	r = in->ops.dpi->enable(in);
>> +	if (r)
>> +		return r;
>> +
>> +	dev_dbg(dssdev->dev, "td028ttec1_panel_enable() - state %d\n",
>> +		dssdev->state);
>> +
>> +	/* three times command zero */
>> +	r |= jbt_reg_write_nodata(ddata, 0x00);
>> +	udelay(1000);
> 
> These are big delays, and I guess the timing is not strict here, so
> maybe some sleep variant would be better.

Yes, good hint! We will look at it. And add some locks so that enabling
and disabling can't interfere.

> 
>> +	r |= jbt_reg_write_nodata(ddata, 0x00);
>> +	udelay(1000);
>> +	r |= jbt_reg_write_nodata(ddata, 0x00);
>> +	udelay(1000);
>> +
>> +	/* deep standby out */
>> +	r |= jbt_reg_write(ddata, JBT_REG_POWER_ON_OFF, 0x17);
>> +
>> +	/* RGB I/F on, RAM write off, QVGA through, SIGCON enable */
>> +	r |= jbt_reg_write(ddata, JBT_REG_DISPLAY_MODE, 0x80);
>> +
>> +	/* Quad mode off */
>> +	r |= jbt_reg_write(ddata, JBT_REG_QUAD_RATE, 0x00);
>> +
>> +	/* AVDD on, XVDD on */
>> +	r |= jbt_reg_write(ddata, JBT_REG_POWER_ON_OFF, 0x16);
>> +
>> +	/* Output control */
>> +	r |= jbt_reg_write16(ddata, JBT_REG_OUTPUT_CONTROL, 0xfff9);
>> +
>> +	/* Sleep mode off */
>> +	r |= jbt_reg_write_nodata(ddata, JBT_REG_SLEEP_OUT);
>> +
>> +	/* at this point we have like 50% grey */
>> +
>> +	/* initialize register set */
>> +	r |= jbt_reg_write(ddata, JBT_REG_DISPLAY_MODE1, 0x01);
>> +	r |= jbt_reg_write(ddata, JBT_REG_DISPLAY_MODE2, 0x00);
>> +	r |= jbt_reg_write(ddata, JBT_REG_RGB_FORMAT, 0x60);
>> +	r |= jbt_reg_write(ddata, JBT_REG_DRIVE_SYSTEM, 0x10);
>> +	r |= jbt_reg_write(ddata, JBT_REG_BOOSTER_OP, 0x56);
>> +	r |= jbt_reg_write(ddata, JBT_REG_BOOSTER_MODE, 0x33);
>> +	r |= jbt_reg_write(ddata, JBT_REG_BOOSTER_FREQ, 0x11);
>> +	r |= jbt_reg_write(ddata, JBT_REG_BOOSTER_FREQ, 0x11);
>> +	r |= jbt_reg_write(ddata, JBT_REG_OPAMP_SYSCLK, 0x02);
>> +	r |= jbt_reg_write(ddata, JBT_REG_VSC_VOLTAGE, 0x2b);
>> +	r |= jbt_reg_write(ddata, JBT_REG_VCOM_VOLTAGE, 0x40);
>> +	r |= jbt_reg_write(ddata, JBT_REG_EXT_DISPL, 0x03);
>> +	r |= jbt_reg_write(ddata, JBT_REG_DCCLK_DCEV, 0x04);
>> +	/*
>> +	 * default of 0x02 in JBT_REG_ASW_SLEW responsible for 72Hz requirement
>> +	 * to avoid red / blue flicker
>> +	 */
>> +	r |= jbt_reg_write(ddata, JBT_REG_ASW_SLEW, 0x04);
>> +	r |= jbt_reg_write(ddata, JBT_REG_DUMMY_DISPLAY, 0x00);
>> +
>> +	r |= jbt_reg_write(ddata, JBT_REG_SLEEP_OUT_FR_A, 0x11);
>> +	r |= jbt_reg_write(ddata, JBT_REG_SLEEP_OUT_FR_B, 0x11);
>> +	r |= jbt_reg_write(ddata, JBT_REG_SLEEP_OUT_FR_C, 0x11);
>> +	r |= jbt_reg_write16(ddata, JBT_REG_SLEEP_IN_LCCNT_D, 0x2040);
>> +	r |= jbt_reg_write16(ddata, JBT_REG_SLEEP_IN_LCCNT_E, 0x60c0);
>> +	r |= jbt_reg_write16(ddata, JBT_REG_SLEEP_IN_LCCNT_F, 0x1020);
>> +	r |= jbt_reg_write16(ddata, JBT_REG_SLEEP_IN_LCCNT_G, 0x60c0);
>> +
>> +	r |= jbt_reg_write16(ddata, JBT_REG_GAMMA1_FINE_1, 0x5533);
>> +	r |= jbt_reg_write(ddata, JBT_REG_GAMMA1_FINE_2, 0x00);
>> +	r |= jbt_reg_write(ddata, JBT_REG_GAMMA1_INCLINATION, 0x00);
>> +	r |= jbt_reg_write(ddata, JBT_REG_GAMMA1_BLUE_OFFSET, 0x00);
>> +	r |= jbt_reg_write(ddata, JBT_REG_GAMMA1_BLUE_OFFSET, 0x00);
>> +
>> +	r |= jbt_reg_write16(ddata, JBT_REG_HCLOCK_VGA, 0x1f0);
>> +	r |= jbt_reg_write(ddata, JBT_REG_BLANK_CONTROL, 0x02);
>> +	r |= jbt_reg_write16(ddata, JBT_REG_BLANK_TH_TV, 0x0804);
>> +	r |= jbt_reg_write16(ddata, JBT_REG_BLANK_TH_TV, 0x0804);
>> +
>> +	r |= jbt_reg_write(ddata, JBT_REG_CKV_ON_OFF, 0x01);
>> +	r |= jbt_reg_write16(ddata, JBT_REG_CKV_1_2, 0x0000);
>> +
>> +	r |= jbt_reg_write16(ddata, JBT_REG_OEV_TIMING, 0x0d0e);
>> +	r |= jbt_reg_write16(ddata, JBT_REG_ASW_TIMING_1, 0x11a4);
>> +	r |= jbt_reg_write(ddata, JBT_REG_ASW_TIMING_2, 0x0e);
>> +
>> +	r |= jbt_reg_write_nodata(ddata, JBT_REG_DISPLAY_ON);
>> +
>> +	dssdev->state = OMAP_DSS_DISPLAY_ACTIVE;
>> +
>> +	return r;
>> +}
>> +
>> +static void td028ttec1_panel_disable(struct omap_dss_device *dssdev)
>> +{
>> +	struct panel_drv_data *ddata = to_panel_data(dssdev);
>> +	struct omap_dss_device *in = ddata->in;
>> +
>> +	if (!omapdss_device_is_enabled(dssdev))
>> +		return;
>> +
>> +	dev_dbg(dssdev->dev, "td028ttec1_panel_disable()\n");
>> +
>> +	in->ops.dpi->disable(in);
>> +
>> +	jbt_reg_write_nodata(ddata, JBT_REG_DISPLAY_OFF);
>> +	jbt_reg_write16(ddata, JBT_REG_OUTPUT_CONTROL, 0x8002);
>> +	jbt_reg_write_nodata(ddata, JBT_REG_SLEEP_IN);
>> +	jbt_reg_write(ddata, JBT_REG_POWER_ON_OFF, 0x00);
>> +
>> +	dssdev->state = OMAP_DSS_DISPLAY_DISABLED;
>> +}
>> +
>> +static void td028ttec1_panel_set_timings(struct omap_dss_device *dssdev,
>> +		struct omap_video_timings *timings)
>> +{
>> +	struct panel_drv_data *ddata = to_panel_data(dssdev);
>> +	struct omap_dss_device *in = ddata->in;
>> +
>> +	ddata->videomode = *timings;
>> +	dssdev->panel.timings = *timings;
>> +
>> +	in->ops.dpi->set_timings(in, timings);
>> +}
>> +
>> +static void td028ttec1_panel_get_timings(struct omap_dss_device *dssdev,
>> +		struct omap_video_timings *timings)
>> +{
>> +	struct panel_drv_data *ddata = to_panel_data(dssdev);
>> +
>> +	*timings = ddata->videomode;
>> +}
>> +
>> +static int td028ttec1_panel_check_timings(struct omap_dss_device *dssdev,
>> +		struct omap_video_timings *timings)
>> +{
>> +	struct panel_drv_data *ddata = to_panel_data(dssdev);
>> +	struct omap_dss_device *in = ddata->in;
>> +
>> +	return in->ops.dpi->check_timings(in, timings);
>> +}
>> +
>> +static struct omap_dss_driver td028ttec1_ops = {
>> +	.connect	= td028ttec1_panel_connect,
>> +	.disconnect	= td028ttec1_panel_disconnect,
>> +
>> +	.enable		= td028ttec1_panel_enable,
>> +	.disable	= td028ttec1_panel_disable,
>> +
>> +	.set_timings	= td028ttec1_panel_set_timings,
>> +	.get_timings	= td028ttec1_panel_get_timings,
>> +	.check_timings	= td028ttec1_panel_check_timings,
>> +};
>> +
>> +static int td028ttec1_panel_probe_pdata(struct platform_device *pdev)
>> +{
>> +	const struct panel_tpo_td028tec1_platform_data *pdata;
>> +	struct panel_drv_data *ddata = platform_get_drvdata(pdev);
>> +	struct omap_dss_device *dssdev, *in;
>> +
>> +	pdata = dev_get_platdata(&pdev->dev);
>> +
>> +	in = omap_dss_find_output(pdata->source);
>> +	if (in == NULL) {
>> +		dev_err(&pdev->dev, "failed to find video source '%s'\n",
>> +				pdata->source);
>> +		return -EPROBE_DEFER;
>> +	}
>> +
>> +	ddata->in = in;
>> +
>> +	ddata->data_lines = pdata->data_lines;
>> +
>> +	dssdev = &ddata->dssdev;
>> +	dssdev->name = pdata->name;
>> +
>> +	ddata->cs_gpio = pdata->cs_gpio;
>> +	ddata->scl_gpio = pdata->scl_gpio;
>> +	ddata->din_gpio = pdata->din_gpio;
>> +	ddata->dout_gpio = pdata->dout_gpio;
>> +
>> +	return 0;
>> +}
>> +
>> +static int td028ttec1_panel_probe(struct platform_device *pdev)
>> +{
>> +	struct panel_drv_data *ddata;
>> +	struct omap_dss_device *dssdev;
>> +	int r;
>> +
>> +	ddata = devm_kzalloc(&pdev->dev, sizeof(*ddata), GFP_KERNEL);
>> +	if (ddata == NULL)
>> +		return -ENOMEM;
>> +
>> +	platform_set_drvdata(pdev, ddata);
>> +
>> +	if (dev_get_platdata(&pdev->dev)) {
>> +		r = td028ttec1_panel_probe_pdata(pdev);
>> +		if (r)
>> +			return r;
>> +	} else {
>> +		return -ENODEV;
>> +	}
>> +
>> +	if (gpio_is_valid(ddata->cs_gpio)) {
>> +		r = devm_gpio_request_one(&pdev->dev, ddata->cs_gpio,
>> +				GPIOF_OUT_INIT_HIGH, "lcd cs");
>> +		if (r)
>> +			goto err_gpio;
>> +	}
>> +
>> +	if (gpio_is_valid(ddata->scl_gpio)) {
>> +		r = devm_gpio_request_one(&pdev->dev, ddata->scl_gpio,
>> +				GPIOF_OUT_INIT_HIGH, "lcd scl");
>> +		if (r)
>> +			goto err_gpio;
>> +	}
>> +
>> +	if (gpio_is_valid(ddata->dout_gpio)) {
>> +		r = devm_gpio_request_one(&pdev->dev, ddata->dout_gpio,
>> +				GPIOF_OUT_INIT_LOW, "lcd dout");
>> +		if (r)
>> +			goto err_gpio;
>> +	}
>> +
>> +	if (gpio_is_valid(ddata->din_gpio)) {
>> +		r = devm_gpio_request_one(&pdev->dev, ddata->din_gpio,
>> +				GPIOF_IN, "lcd din");
>> +		if (r)
>> +			goto err_gpio;
>> +	}
>> +
>> +	/* according to data sheet: wait 50ms (Tpos of LCM). However, 50ms
>> +	 * seems unreliable with later LCM batches, increasing to 90ms */
>> +	mdelay(90);
> 
> What is this delay for? Usually sleeps/delays should be between two "HW
> actions". Here there's nothing below this line that would count as such
> an action.

I guess that this delay is intended to power on the display first, then wait some
time and after that delay enable the DSS clocks and signals and make the
controller chip in the panel initialize.

But this of course depends on the order the DSS components are probed
and enabled and how power is controlled (we don't interrupt power at all).

I think we can move this delay (sleep) to the beginning of 

td028ttec1_panel_enable() before /* three times command zero */

to make sure that a freshly powered display has enough time to do its
internal reset and initializations before registers are programmed.

> 
>> +	ddata->videomode = td028ttec1_panel_timings;
>> +
>> +	dssdev = &ddata->dssdev;
>> +	dssdev->dev = &pdev->dev;
>> +	dssdev->driver = &td028ttec1_ops;
>> +	dssdev->type = OMAP_DISPLAY_TYPE_DPI;
>> +	dssdev->owner = THIS_MODULE;
>> +	dssdev->panel.timings = ddata->videomode;
>> +	dssdev->phy.dpi.data_lines = ddata->data_lines;
>> +
>> +	r = omapdss_register_display(dssdev);
>> +	if (r) {
>> +		dev_err(&pdev->dev, "Failed to register panel\n");
>> +		goto err_reg;
>> +	}
>> +
>> +	return 0;
>> +
>> +err_reg:
>> +err_gpio:
>> +	omap_dss_put_device(ddata->in);
>> +	return r;
>> +}
>> +
> 
> Tomi

BR,
Nikolaus

