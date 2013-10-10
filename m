Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab3JJITP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 04:19:15 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55417 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957Ab3JJITK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 04:19:10 -0400
Message-ID: <525662F5.3090600@ti.com>
Date: Thu, 10 Oct 2013 11:19:01 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Marek Belisko <marek@goldelico.com>
CC: <plagnioj@jcrosoft.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        "H. Nikolaus Schaller" <hns@goldelico.com>
Subject: Re: [PATCH] omapdss: Add new panel driver for Topolly td028ttec1
 LCD.
References: <1381352915-17219-1-git-send-email-marek@goldelico.com>
In-Reply-To: <1381352915-17219-1-git-send-email-marek@goldelico.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="xwP8kGPUAAUJjdXwnnQmLVTHRwOXMER5J"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--xwP8kGPUAAUJjdXwnnQmLVTHRwOXMER5J
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 10/10/13 00:08, Marek Belisko wrote:
> For communicating with driver is used gpio bitbanging because TD028 doe=
s
> not have a standard compliant SPI interface. It is a 3-wire thing with
> direction reversal.

Isn't that SPI_3WIRE?

> Communication with display is used only during panel enable/disable so =
it's
> not performance issue.
>=20
> Signed-off-by: Marek Belisko <marek@goldelico.com>
> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> ---
>  drivers/video/omap2/displays-new/Kconfig           |   6 +
>  drivers/video/omap2/displays-new/Makefile          |   1 +
>  .../omap2/displays-new/panel-tpo-td028ttec1.c      | 537 +++++++++++++=
++++++++
>  include/video/omap-panel-data.h                    |  22 +
>  4 files changed, 566 insertions(+)
>  create mode 100644 drivers/video/omap2/displays-new/panel-tpo-td028tte=
c1.c
>=20
> diff --git a/drivers/video/omap2/displays-new/Kconfig b/drivers/video/o=
map2/displays-new/Kconfig
> index 6c90885..3f86432 100644
> --- a/drivers/video/omap2/displays-new/Kconfig
> +++ b/drivers/video/omap2/displays-new/Kconfig
> @@ -56,6 +56,11 @@ config DISPLAY_PANEL_SHARP_LS037V7DW01
>          help
>            LCD Panel used in TI's SDP3430 and EVM boards
> =20
> +config DISPLAY_PANEL_TPO_TD028TTEC1
> +        tristate "TPO TD028TTEC1 LCD Panel"
> +        help
> +          LCD panel used by Openmoko.
> +
>  config DISPLAY_PANEL_TPO_TD043MTEA1
>          tristate "TPO TD043MTEA1 LCD Panel"
>          depends on SPI
> @@ -70,4 +75,5 @@ config DISPLAY_PANEL_NEC_NL8048HL11
>  		This NEC NL8048HL11 panel is TFT LCD used in the
>  		Zoom2/3/3630 sdp boards.
> =20
> +

Extra change.

>  endmenu
> diff --git a/drivers/video/omap2/displays-new/Makefile b/drivers/video/=
omap2/displays-new/Makefile
> index 5aeb11b..0323a8a 100644
> --- a/drivers/video/omap2/displays-new/Makefile
> +++ b/drivers/video/omap2/displays-new/Makefile
> @@ -8,5 +8,6 @@ obj-$(CONFIG_DISPLAY_PANEL_DSI_CM) +=3D panel-dsi-cm.o
>  obj-$(CONFIG_DISPLAY_PANEL_SONY_ACX565AKM) +=3D panel-sony-acx565akm.o=

>  obj-$(CONFIG_DISPLAY_PANEL_LGPHILIPS_LB035Q02) +=3D panel-lgphilips-lb=
035q02.o
>  obj-$(CONFIG_DISPLAY_PANEL_SHARP_LS037V7DW01) +=3D panel-sharp-ls037v7=
dw01.o
> +obj-$(CONFIG_DISPLAY_PANEL_TPO_TD028TTEC1) +=3D panel-tpo-td028ttec1.o=

>  obj-$(CONFIG_DISPLAY_PANEL_TPO_TD043MTEA1) +=3D panel-tpo-td043mtea1.o=

>  obj-$(CONFIG_DISPLAY_PANEL_NEC_NL8048HL11) +=3D panel-nec-nl8048hl11.o=

> diff --git a/drivers/video/omap2/displays-new/panel-tpo-td028ttec1.c b/=
drivers/video/omap2/displays-new/panel-tpo-td028ttec1.c
> new file mode 100644
> index 0000000..b63586e
> --- /dev/null
> +++ b/drivers/video/omap2/displays-new/panel-tpo-td028ttec1.c
> @@ -0,0 +1,537 @@
> +/*
> + * Toppoly TD028TTEC1 panel support
> + *
> + * Copyright (C) 2008 Nokia Corporation
> + * Author: Tomi Valkeinen <tomi.valkeinen@nokia.com>
> + *
> + * Neo 1973 code (jbt6k74.c):
> + * Copyright (C) 2006-2007 by OpenMoko, Inc.
> + * Author: Harald Welte <laforge@openmoko.org>
> + *
> + * Ported and adapted from Neo 1973 U-Boot by:
> + * H. Nikolaus Schaller <hns@goldelico.com>
> + *
> + * This program is free software; you can redistribute it and/or modif=
y it
> + * under the terms of the GNU General Public License version 2 as publ=
ished by
> + * the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but=
 WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY =
or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public Licen=
se for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License a=
long with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/delay.h>
> +#include <linux/platform_device.h>
> +#include <linux/gpio.h>
> +#include <video/omapdss.h>
> +#include <video/omap-panel-data.h>
> +
> +struct panel_drv_data {
> +	struct omap_dss_device dssdev;
> +	struct omap_dss_device *in;
> +
> +	int data_lines;
> +
> +	struct omap_video_timings videomode;
> +
> +	int cs_gpio;
> +	int scl_gpio;
> +	int din_gpio;
> +	int dout_gpio;

Three wires, but four gpios? What am I missing here...

> +	u_int16_t tx_buf[4];

Hmm, what's wrong with "u16"?

> +};
> +
> +static struct omap_video_timings td028ttec1_panel_timings =3D {
> +	.x_res		=3D 480,
> +	.y_res		=3D 640,
> +	.pixel_clock	=3D 22153,
> +	.hfp		=3D 24,
> +	.hsw		=3D 8,
> +	.hbp		=3D 8,
> +	.vfp		=3D 4,
> +	.vsw		=3D 2,
> +	.vbp		=3D 2,
> +
> +	.vsync_level	=3D OMAPDSS_SIG_ACTIVE_LOW,
> +	.hsync_level	=3D OMAPDSS_SIG_ACTIVE_LOW,
> +
> +	.data_pclk_edge	=3D OMAPDSS_DRIVE_SIG_FALLING_EDGE,
> +	.de_level	=3D OMAPDSS_SIG_ACTIVE_HIGH,
> +	.sync_pclk_edge	=3D OMAPDSS_DRIVE_SIG_OPPOSITE_EDGES,
> +};
> +
> +#define JBT_COMMAND	0x000
> +#define JBT_DATA	0x100
> +
> +/* 150uS minimum clock cycle, we have two of this plus our other
> + * instructions */
> +
> +#define SPI_DELAY()	udelay(200)

Would usleep_range work here?

See Documentation/timers/timers-howto.txt

> +static int jbt_spi_xfer(struct panel_drv_data *data, int wordnum, int =
bitlen)

Hmm, if it's not SPI, maybe it shouldn't be called SPI?

> +{
> +	u_int16_t tmpdout =3D 0;
> +	int   i, j;
> +
> +	gpio_set_value(data->cs_gpio, 0);
> +
> +	for (i =3D 0; i < wordnum; i++) {
> +		tmpdout =3D data->tx_buf[i];
> +
> +		for (j =3D 0; j < bitlen; j++) {
> +			gpio_set_value(data->scl_gpio, 0);
> +			if (tmpdout & (1 << (bitlen-1))) {
> +				gpio_set_value(data->dout_gpio, 1);
> +				if (gpio_get_value(data->din_gpio) =3D=3D 0)
> +					return 1;
> +			} else {
> +				gpio_set_value(data->dout_gpio, 0);
> +				if (gpio_get_value(data->din_gpio) !=3D 0)
> +					return 1;
> +			}
> +			SPI_DELAY();
> +			gpio_set_value(data->scl_gpio, 1);
> +			SPI_DELAY();
> +			tmpdout <<=3D 1;
> +		}
> +	}
> +
> +	gpio_set_value(data->cs_gpio, 1);
> +
> +	return 0;
> +}
> +
> +#define JBT_COMMAND	0x000
> +#define JBT_DATA	0x100
> +
> +int jbt_reg_write_nodata(struct panel_drv_data *ddata, u_int8_t reg)

What's wrong with "u8"? Have I missed a memo? =3D)

> +{
> +	int rc;
> +
> +	ddata->tx_buf[0] =3D JBT_COMMAND | reg;
> +
> +	rc =3D jbt_spi_xfer(ddata, 1, 9);
> +	if (rc)
> +		dev_warn(ddata->dssdev.dev, "Failed to write reg: %x\n", reg);
> +
> +	return rc;
> +}
> +
> +int jbt_reg_write(struct panel_drv_data *ddata, u_int8_t reg, u_int8_t=
 data)
> +{
> +	int rc;
> +
> +	ddata->tx_buf[0] =3D JBT_COMMAND | reg;
> +	ddata->tx_buf[1] =3D JBT_DATA | data;
> +
> +	rc =3D jbt_spi_xfer(ddata, 2, 9);
> +	if (rc)
> +		dev_warn(ddata->dssdev.dev, "Failed to write reg: %x\n", reg);
> +
> +	return rc;
> +}
> +
> +int jbt_reg_write16(struct panel_drv_data *ddata, u_int8_t reg, u_int1=
6_t data)
> +{
> +	int rc;
> +
> +	ddata->tx_buf[0] =3D JBT_COMMAND | reg;
> +	ddata->tx_buf[1] =3D JBT_DATA | (data >> 8);
> +	ddata->tx_buf[2] =3D JBT_DATA | (data & 0xff);
> +
> +	rc =3D jbt_spi_xfer(ddata, 3, 9);
> +	if (rc)
> +		dev_warn(ddata->dssdev.dev, "Failed to write reg: %x\n", reg);
> +
> +	return rc;
> +}
> +
> +enum jbt_register {
> +	JBT_REG_SLEEP_IN		=3D 0x10,
> +	JBT_REG_SLEEP_OUT		=3D 0x11,
> +
> +	JBT_REG_DISPLAY_OFF		=3D 0x28,
> +	JBT_REG_DISPLAY_ON		=3D 0x29,
> +
> +	JBT_REG_RGB_FORMAT		=3D 0x3a,
> +	JBT_REG_QUAD_RATE		=3D 0x3b,
> +
> +	JBT_REG_POWER_ON_OFF		=3D 0xb0,
> +	JBT_REG_BOOSTER_OP		=3D 0xb1,
> +	JBT_REG_BOOSTER_MODE		=3D 0xb2,
> +	JBT_REG_BOOSTER_FREQ		=3D 0xb3,
> +	JBT_REG_OPAMP_SYSCLK		=3D 0xb4,
> +	JBT_REG_VSC_VOLTAGE		=3D 0xb5,
> +	JBT_REG_VCOM_VOLTAGE		=3D 0xb6,
> +	JBT_REG_EXT_DISPL		=3D 0xb7,
> +	JBT_REG_OUTPUT_CONTROL		=3D 0xb8,
> +	JBT_REG_DCCLK_DCEV		=3D 0xb9,
> +	JBT_REG_DISPLAY_MODE1		=3D 0xba,
> +	JBT_REG_DISPLAY_MODE2		=3D 0xbb,
> +	JBT_REG_DISPLAY_MODE		=3D 0xbc,
> +	JBT_REG_ASW_SLEW		=3D 0xbd,
> +	JBT_REG_DUMMY_DISPLAY		=3D 0xbe,
> +	JBT_REG_DRIVE_SYSTEM		=3D 0xbf,
> +
> +	JBT_REG_SLEEP_OUT_FR_A		=3D 0xc0,
> +	JBT_REG_SLEEP_OUT_FR_B		=3D 0xc1,
> +	JBT_REG_SLEEP_OUT_FR_C		=3D 0xc2,
> +	JBT_REG_SLEEP_IN_LCCNT_D	=3D 0xc3,
> +	JBT_REG_SLEEP_IN_LCCNT_E	=3D 0xc4,
> +	JBT_REG_SLEEP_IN_LCCNT_F	=3D 0xc5,
> +	JBT_REG_SLEEP_IN_LCCNT_G	=3D 0xc6,
> +
> +	JBT_REG_GAMMA1_FINE_1		=3D 0xc7,
> +	JBT_REG_GAMMA1_FINE_2		=3D 0xc8,
> +	JBT_REG_GAMMA1_INCLINATION	=3D 0xc9,
> +	JBT_REG_GAMMA1_BLUE_OFFSET	=3D 0xca,
> +
> +	JBT_REG_BLANK_CONTROL		=3D 0xcf,
> +	JBT_REG_BLANK_TH_TV		=3D 0xd0,
> +	JBT_REG_CKV_ON_OFF		=3D 0xd1,
> +	JBT_REG_CKV_1_2			=3D 0xd2,
> +	JBT_REG_OEV_TIMING		=3D 0xd3,
> +	JBT_REG_ASW_TIMING_1		=3D 0xd4,
> +	JBT_REG_ASW_TIMING_2		=3D 0xd5,
> +
> +	JBT_REG_HCLOCK_VGA		=3D 0xec,
> +	JBT_REG_HCLOCK_QVGA		=3D 0xed,
> +};
> +
> +#define to_panel_data(p) container_of(p, struct panel_drv_data, dssdev=
)
> +
> +static int td028ttec1_panel_connect(struct omap_dss_device *dssdev)
> +{
> +	struct panel_drv_data *ddata =3D to_panel_data(dssdev);
> +	struct omap_dss_device *in =3D ddata->in;
> +	int r;
> +
> +	if (omapdss_device_is_connected(dssdev))
> +		return 0;
> +
> +	r =3D in->ops.dpi->connect(in, dssdev);
> +	if (r)
> +		return r;
> +
> +	return 0;
> +}
> +
> +static void td028ttec1_panel_disconnect(struct omap_dss_device *dssdev=
)
> +{
> +	struct panel_drv_data *ddata =3D to_panel_data(dssdev);
> +	struct omap_dss_device *in =3D ddata->in;
> +
> +	if (!omapdss_device_is_connected(dssdev))
> +		return;
> +
> +	in->ops.dpi->disconnect(in, dssdev);
> +}
> +
> +static int td028ttec1_panel_enable(struct omap_dss_device *dssdev)
> +{
> +	struct panel_drv_data *ddata =3D to_panel_data(dssdev);
> +	struct omap_dss_device *in =3D ddata->in;
> +	int r;
> +
> +	if (!omapdss_device_is_connected(dssdev))
> +		return -ENODEV;
> +
> +	if (omapdss_device_is_enabled(dssdev))
> +		return 0;
> +
> +	in->ops.dpi->set_data_lines(in, ddata->data_lines);
> +	in->ops.dpi->set_timings(in, &ddata->videomode);
> +
> +	r =3D in->ops.dpi->enable(in);
> +	if (r)
> +		return r;
> +
> +	dev_dbg(dssdev->dev, "td028ttec1_panel_enable() - state %d\n",
> +		dssdev->state);
> +
> +	/* three times command zero */
> +	r |=3D jbt_reg_write_nodata(ddata, 0x00);
> +	udelay(1000);

These are big delays, and I guess the timing is not strict here, so
maybe some sleep variant would be better.

> +	r |=3D jbt_reg_write_nodata(ddata, 0x00);
> +	udelay(1000);
> +	r |=3D jbt_reg_write_nodata(ddata, 0x00);
> +	udelay(1000);
> +
> +	/* deep standby out */
> +	r |=3D jbt_reg_write(ddata, JBT_REG_POWER_ON_OFF, 0x17);
> +
> +	/* RGB I/F on, RAM write off, QVGA through, SIGCON enable */
> +	r |=3D jbt_reg_write(ddata, JBT_REG_DISPLAY_MODE, 0x80);
> +
> +	/* Quad mode off */
> +	r |=3D jbt_reg_write(ddata, JBT_REG_QUAD_RATE, 0x00);
> +
> +	/* AVDD on, XVDD on */
> +	r |=3D jbt_reg_write(ddata, JBT_REG_POWER_ON_OFF, 0x16);
> +
> +	/* Output control */
> +	r |=3D jbt_reg_write16(ddata, JBT_REG_OUTPUT_CONTROL, 0xfff9);
> +
> +	/* Sleep mode off */
> +	r |=3D jbt_reg_write_nodata(ddata, JBT_REG_SLEEP_OUT);
> +
> +	/* at this point we have like 50% grey */
> +
> +	/* initialize register set */
> +	r |=3D jbt_reg_write(ddata, JBT_REG_DISPLAY_MODE1, 0x01);
> +	r |=3D jbt_reg_write(ddata, JBT_REG_DISPLAY_MODE2, 0x00);
> +	r |=3D jbt_reg_write(ddata, JBT_REG_RGB_FORMAT, 0x60);
> +	r |=3D jbt_reg_write(ddata, JBT_REG_DRIVE_SYSTEM, 0x10);
> +	r |=3D jbt_reg_write(ddata, JBT_REG_BOOSTER_OP, 0x56);
> +	r |=3D jbt_reg_write(ddata, JBT_REG_BOOSTER_MODE, 0x33);
> +	r |=3D jbt_reg_write(ddata, JBT_REG_BOOSTER_FREQ, 0x11);
> +	r |=3D jbt_reg_write(ddata, JBT_REG_BOOSTER_FREQ, 0x11);
> +	r |=3D jbt_reg_write(ddata, JBT_REG_OPAMP_SYSCLK, 0x02);
> +	r |=3D jbt_reg_write(ddata, JBT_REG_VSC_VOLTAGE, 0x2b);
> +	r |=3D jbt_reg_write(ddata, JBT_REG_VCOM_VOLTAGE, 0x40);
> +	r |=3D jbt_reg_write(ddata, JBT_REG_EXT_DISPL, 0x03);
> +	r |=3D jbt_reg_write(ddata, JBT_REG_DCCLK_DCEV, 0x04);
> +	/*
> +	 * default of 0x02 in JBT_REG_ASW_SLEW responsible for 72Hz requireme=
nt
> +	 * to avoid red / blue flicker
> +	 */
> +	r |=3D jbt_reg_write(ddata, JBT_REG_ASW_SLEW, 0x04);
> +	r |=3D jbt_reg_write(ddata, JBT_REG_DUMMY_DISPLAY, 0x00);
> +
> +	r |=3D jbt_reg_write(ddata, JBT_REG_SLEEP_OUT_FR_A, 0x11);
> +	r |=3D jbt_reg_write(ddata, JBT_REG_SLEEP_OUT_FR_B, 0x11);
> +	r |=3D jbt_reg_write(ddata, JBT_REG_SLEEP_OUT_FR_C, 0x11);
> +	r |=3D jbt_reg_write16(ddata, JBT_REG_SLEEP_IN_LCCNT_D, 0x2040);
> +	r |=3D jbt_reg_write16(ddata, JBT_REG_SLEEP_IN_LCCNT_E, 0x60c0);
> +	r |=3D jbt_reg_write16(ddata, JBT_REG_SLEEP_IN_LCCNT_F, 0x1020);
> +	r |=3D jbt_reg_write16(ddata, JBT_REG_SLEEP_IN_LCCNT_G, 0x60c0);
> +
> +	r |=3D jbt_reg_write16(ddata, JBT_REG_GAMMA1_FINE_1, 0x5533);
> +	r |=3D jbt_reg_write(ddata, JBT_REG_GAMMA1_FINE_2, 0x00);
> +	r |=3D jbt_reg_write(ddata, JBT_REG_GAMMA1_INCLINATION, 0x00);
> +	r |=3D jbt_reg_write(ddata, JBT_REG_GAMMA1_BLUE_OFFSET, 0x00);
> +	r |=3D jbt_reg_write(ddata, JBT_REG_GAMMA1_BLUE_OFFSET, 0x00);
> +
> +	r |=3D jbt_reg_write16(ddata, JBT_REG_HCLOCK_VGA, 0x1f0);
> +	r |=3D jbt_reg_write(ddata, JBT_REG_BLANK_CONTROL, 0x02);
> +	r |=3D jbt_reg_write16(ddata, JBT_REG_BLANK_TH_TV, 0x0804);
> +	r |=3D jbt_reg_write16(ddata, JBT_REG_BLANK_TH_TV, 0x0804);
> +
> +	r |=3D jbt_reg_write(ddata, JBT_REG_CKV_ON_OFF, 0x01);
> +	r |=3D jbt_reg_write16(ddata, JBT_REG_CKV_1_2, 0x0000);
> +
> +	r |=3D jbt_reg_write16(ddata, JBT_REG_OEV_TIMING, 0x0d0e);
> +	r |=3D jbt_reg_write16(ddata, JBT_REG_ASW_TIMING_1, 0x11a4);
> +	r |=3D jbt_reg_write(ddata, JBT_REG_ASW_TIMING_2, 0x0e);
> +
> +	r |=3D jbt_reg_write_nodata(ddata, JBT_REG_DISPLAY_ON);
> +
> +	dssdev->state =3D OMAP_DSS_DISPLAY_ACTIVE;
> +
> +	return r;
> +}
> +
> +static void td028ttec1_panel_disable(struct omap_dss_device *dssdev)
> +{
> +	struct panel_drv_data *ddata =3D to_panel_data(dssdev);
> +	struct omap_dss_device *in =3D ddata->in;
> +
> +	if (!omapdss_device_is_enabled(dssdev))
> +		return;
> +
> +	dev_dbg(dssdev->dev, "td028ttec1_panel_disable()\n");
> +
> +	in->ops.dpi->disable(in);
> +
> +	jbt_reg_write_nodata(ddata, JBT_REG_DISPLAY_OFF);
> +	jbt_reg_write16(ddata, JBT_REG_OUTPUT_CONTROL, 0x8002);
> +	jbt_reg_write_nodata(ddata, JBT_REG_SLEEP_IN);
> +	jbt_reg_write(ddata, JBT_REG_POWER_ON_OFF, 0x00);
> +
> +	dssdev->state =3D OMAP_DSS_DISPLAY_DISABLED;
> +}
> +
> +static void td028ttec1_panel_set_timings(struct omap_dss_device *dssde=
v,
> +		struct omap_video_timings *timings)
> +{
> +	struct panel_drv_data *ddata =3D to_panel_data(dssdev);
> +	struct omap_dss_device *in =3D ddata->in;
> +
> +	ddata->videomode =3D *timings;
> +	dssdev->panel.timings =3D *timings;
> +
> +	in->ops.dpi->set_timings(in, timings);
> +}
> +
> +static void td028ttec1_panel_get_timings(struct omap_dss_device *dssde=
v,
> +		struct omap_video_timings *timings)
> +{
> +	struct panel_drv_data *ddata =3D to_panel_data(dssdev);
> +
> +	*timings =3D ddata->videomode;
> +}
> +
> +static int td028ttec1_panel_check_timings(struct omap_dss_device *dssd=
ev,
> +		struct omap_video_timings *timings)
> +{
> +	struct panel_drv_data *ddata =3D to_panel_data(dssdev);
> +	struct omap_dss_device *in =3D ddata->in;
> +
> +	return in->ops.dpi->check_timings(in, timings);
> +}
> +
> +static struct omap_dss_driver td028ttec1_ops =3D {
> +	.connect	=3D td028ttec1_panel_connect,
> +	.disconnect	=3D td028ttec1_panel_disconnect,
> +
> +	.enable		=3D td028ttec1_panel_enable,
> +	.disable	=3D td028ttec1_panel_disable,
> +
> +	.set_timings	=3D td028ttec1_panel_set_timings,
> +	.get_timings	=3D td028ttec1_panel_get_timings,
> +	.check_timings	=3D td028ttec1_panel_check_timings,
> +};
> +
> +static int td028ttec1_panel_probe_pdata(struct platform_device *pdev)
> +{
> +	const struct panel_tpo_td028tec1_platform_data *pdata;
> +	struct panel_drv_data *ddata =3D platform_get_drvdata(pdev);
> +	struct omap_dss_device *dssdev, *in;
> +
> +	pdata =3D dev_get_platdata(&pdev->dev);
> +
> +	in =3D omap_dss_find_output(pdata->source);
> +	if (in =3D=3D NULL) {
> +		dev_err(&pdev->dev, "failed to find video source '%s'\n",
> +				pdata->source);
> +		return -EPROBE_DEFER;
> +	}
> +
> +	ddata->in =3D in;
> +
> +	ddata->data_lines =3D pdata->data_lines;
> +
> +	dssdev =3D &ddata->dssdev;
> +	dssdev->name =3D pdata->name;
> +
> +	ddata->cs_gpio =3D pdata->cs_gpio;
> +	ddata->scl_gpio =3D pdata->scl_gpio;
> +	ddata->din_gpio =3D pdata->din_gpio;
> +	ddata->dout_gpio =3D pdata->dout_gpio;
> +
> +	return 0;
> +}
> +
> +static int td028ttec1_panel_probe(struct platform_device *pdev)
> +{
> +	struct panel_drv_data *ddata;
> +	struct omap_dss_device *dssdev;
> +	int r;
> +
> +	ddata =3D devm_kzalloc(&pdev->dev, sizeof(*ddata), GFP_KERNEL);
> +	if (ddata =3D=3D NULL)
> +		return -ENOMEM;
> +
> +	platform_set_drvdata(pdev, ddata);
> +
> +	if (dev_get_platdata(&pdev->dev)) {
> +		r =3D td028ttec1_panel_probe_pdata(pdev);
> +		if (r)
> +			return r;
> +	} else {
> +		return -ENODEV;
> +	}
> +
> +	if (gpio_is_valid(ddata->cs_gpio)) {
> +		r =3D devm_gpio_request_one(&pdev->dev, ddata->cs_gpio,
> +				GPIOF_OUT_INIT_HIGH, "lcd cs");
> +		if (r)
> +			goto err_gpio;
> +	}
> +
> +	if (gpio_is_valid(ddata->scl_gpio)) {
> +		r =3D devm_gpio_request_one(&pdev->dev, ddata->scl_gpio,
> +				GPIOF_OUT_INIT_HIGH, "lcd scl");
> +		if (r)
> +			goto err_gpio;
> +	}
> +
> +	if (gpio_is_valid(ddata->dout_gpio)) {
> +		r =3D devm_gpio_request_one(&pdev->dev, ddata->dout_gpio,
> +				GPIOF_OUT_INIT_LOW, "lcd dout");
> +		if (r)
> +			goto err_gpio;
> +	}
> +
> +	if (gpio_is_valid(ddata->din_gpio)) {
> +		r =3D devm_gpio_request_one(&pdev->dev, ddata->din_gpio,
> +				GPIOF_IN, "lcd din");
> +		if (r)
> +			goto err_gpio;
> +	}
> +
> +	/* according to data sheet: wait 50ms (Tpos of LCM). However, 50ms
> +	 * seems unreliable with later LCM batches, increasing to 90ms */
> +	mdelay(90);

What is this delay for? Usually sleeps/delays should be between two "HW
actions". Here there's nothing below this line that would count as such
an action.

> +	ddata->videomode =3D td028ttec1_panel_timings;
> +
> +	dssdev =3D &ddata->dssdev;
> +	dssdev->dev =3D &pdev->dev;
> +	dssdev->driver =3D &td028ttec1_ops;
> +	dssdev->type =3D OMAP_DISPLAY_TYPE_DPI;
> +	dssdev->owner =3D THIS_MODULE;
> +	dssdev->panel.timings =3D ddata->videomode;
> +	dssdev->phy.dpi.data_lines =3D ddata->data_lines;
> +
> +	r =3D omapdss_register_display(dssdev);
> +	if (r) {
> +		dev_err(&pdev->dev, "Failed to register panel\n");
> +		goto err_reg;
> +	}
> +
> +	return 0;
> +
> +err_reg:
> +err_gpio:
> +	omap_dss_put_device(ddata->in);
> +	return r;
> +}
> +

 Tomi




--xwP8kGPUAAUJjdXwnnQmLVTHRwOXMER5J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSVmL1AAoJEPo9qoy8lh71qmAP/3M6GV+xEJWQjjh5VsJIsDCW
A3k2I5Zl7DOOImrw0+/n41pdSuS0tPcWrDvFZ0/93l3paBDY+t0HSlxZ1NerRjGE
l9KzoW2qQv60JoizNw1ODPsTFRbeM7vAZIjxBSY4D6GZSUHVmpfC8WPm7d6rlwtb
008WTshF5zrBOOvZD8RRJO22DrekF39AkGZ8sk4kh8nPnTDEOtfzCOfOzUzueEXs
bhI9koXyUthq6fgo0skPD4yxGZmV8+Y4jS9BWdyppo7lLHGcLukL49x3xoEeq9BZ
8zpmYZZutoXWn/6mvgU8dIt5rhNI94QgCDce/9JXP1QavYwp/bXUOgPoHeZcnRwK
Trux1ztg4tH0+BDD+B93x6weAppOnoSY5Khz3+INBpr4fdFSZvdEWBgxxOam49bz
C/n8WFovhc1Dv2l8msWdr0hR4LkpCIWssmiB3RKvqSY9SqQit/D4yqXq9ENSDVLk
lrGB7rLANlSj6vbQbmqcuYJgvrjngpUbs0mLB9ZMe4gTzbE/ZteW+WJsNINsPeVn
Efh3T2ksMM4p4kAGDDNh9eQ8pj55Yd9xRLxQToNIiXbeZXRtvvd1gamocF7v4Jms
GPoGhLhAiSJbXMfXTW/OE/s4S3kcZiAbmRG28ExRn+K/AWAUoJmwUcKdCg3ww+R9
E+msVkylaLi1i3wyyacA
=y6Mh
-----END PGP SIGNATURE-----

--xwP8kGPUAAUJjdXwnnQmLVTHRwOXMER5J--
