Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab3J2LHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 07:07:37 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41253 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054Ab3J2LHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 07:07:34 -0400
Message-ID: <526F96ED.906@ti.com>
Date: Tue, 29 Oct 2013 13:07:25 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Marek Belisko <marek@goldelico.com>
CC: <plagnioj@jcrosoft.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        "H. Nikolaus Schaller" <hns@goldelico.com>
Subject: Re: [PATCH v2] omapdss: Add new panel driver for Topolly td028ttec1
 LCD.
References: <1382019258-21000-1-git-send-email-marek@goldelico.com>
In-Reply-To: <1382019258-21000-1-git-send-email-marek@goldelico.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="iXjLGFov2aTQBSfAQacKKcTSjd2wrjFGN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--iXjLGFov2aTQBSfAQacKKcTSjd2wrjFGN
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 17/10/13 17:14, Marek Belisko wrote:
> Signed-off-by: Marek Belisko <marek@goldelico.com>
> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> ---
>=20
> changes from v1:
> - reworked to be spi driver instead platform with custom spi bitbang
>   this configuration was tested with spi_gpio bitbang driver on gta04 b=
oard
>   and works fine (thanks Tomi and Lars-Peter for comments)
> - address previous comments
>=20
>  drivers/video/omap2/displays-new/Kconfig           |   6 +
>  drivers/video/omap2/displays-new/Makefile          |   1 +
>  .../omap2/displays-new/panel-tpo-td028ttec1.c      | 486 +++++++++++++=
++++++++
>  include/video/omap-panel-data.h                    |  13 +
>  4 files changed, 506 insertions(+)
>  create mode 100644 drivers/video/omap2/displays-new/panel-tpo-td028tte=
c1.c
>=20
> diff --git a/drivers/video/omap2/displays-new/Kconfig b/drivers/video/o=
map2/displays-new/Kconfig
> index 6c90885..1054249 100644
> --- a/drivers/video/omap2/displays-new/Kconfig
> +++ b/drivers/video/omap2/displays-new/Kconfig
> @@ -56,6 +56,12 @@ config DISPLAY_PANEL_SHARP_LS037V7DW01
>          help
>            LCD Panel used in TI's SDP3430 and EVM boards
> =20
> +config DISPLAY_PANEL_TPO_TD028TTEC1
> +        tristate "TPO TD028TTEC1 LCD Panel"
> +        depends on SPI
> +        help
> +          LCD panel used in Openmoko.
> +
>  config DISPLAY_PANEL_TPO_TD043MTEA1
>          tristate "TPO TD043MTEA1 LCD Panel"
>          depends on SPI
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
> index 0000000..5a44d30
> --- /dev/null
> +++ b/drivers/video/omap2/displays-new/panel-tpo-td028ttec1.c
> @@ -0,0 +1,486 @@
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
> +#include <linux/spi/spi.h>
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
> +	struct spi_device *spi_dev;
> +
> +	u16 tx_buf[4];

Is there some particular reason to have tx_buf in the driver data? It
looks to me that it would fit better as a local variable for the funcs
that need it.

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
> +int jbt_reg_write_nodata(struct panel_drv_data *ddata, u8 reg)
> +{
> +	int rc;
> +
> +	ddata->tx_buf[0] =3D JBT_COMMAND | reg;
> +	rc =3D spi_write(ddata->spi_dev, (u8 *)ddata->tx_buf,
> +			1*sizeof(u16));
> +	if (rc !=3D 0)
> +		dev_err(&ddata->spi_dev->dev,
> +			"jbt_reg_write_nodata spi_write ret %d\n", rc);
> +
> +	return rc;
> +}
> +
> +int jbt_reg_write(struct panel_drv_data *ddata, u8 reg, u8 data)

Perhaps name this jbt_reg_write8 to be in line with the jbt_reg_write16.
Or is it obvious that the function without a suffix works on bytes?

Just a side note, on DSI side I have used suffixes _0, _1, _2 to
represent transmission without data, with one byte and with 2 bytes.

> +{
> +	int rc;
> +
> +	ddata->tx_buf[0] =3D JBT_COMMAND | reg;
> +	ddata->tx_buf[1] =3D JBT_DATA | data;
> +	rc =3D spi_write(ddata->spi_dev, (u8 *)ddata->tx_buf,
> +			2*sizeof(u16));
> +	if (rc !=3D 0)
> +		dev_err(&ddata->spi_dev->dev,
> +			"jbt_reg_write spi_write ret %d\n", rc);
> +
> +	return rc;
> +}
> +
> +int jbt_reg_write16(struct panel_drv_data *ddata, u8 reg, u16 data)
> +{
> +	int rc;
> +
> +	ddata->tx_buf[0] =3D JBT_COMMAND | reg;
> +	ddata->tx_buf[1] =3D JBT_DATA | (data >> 8);
> +	ddata->tx_buf[2] =3D JBT_DATA | (data & 0xff);
> +
> +	rc =3D spi_write(ddata->spi_dev, (u8 *)ddata->tx_buf,
> +			3*sizeof(u16));
> +
> +	if (rc !=3D 0)
> +		dev_err(&ddata->spi_dev->dev,
> +			"jbt_reg_write16 spi_write ret %d\n", rc);
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
> +	/*
> +	 * according to data sheet: wait 50ms (Tpos of LCM). However, 50ms
> +	 * seems unreliable with later LCM batches, increasing to 90ms
> +	 */
> +	msleep(90);

Wait for what?

> +
> +	/* three times command zero */
> +	r |=3D jbt_reg_write_nodata(ddata, 0x00);
> +	msleep(1000);
> +	r |=3D jbt_reg_write_nodata(ddata, 0x00);
> +	msleep(1000);
> +	r |=3D jbt_reg_write_nodata(ddata, 0x00);
> +	msleep(1000);

Three _seconds_? That's a huge delay when enabling a panel. Is this
really required?

> +
> +	if (r) {
> +		dev_warn(dssdev->dev, "transfer error\n");
> +		goto transfer_err;
> +	}
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
> +
> +	r |=3D jbt_reg_write16(ddata, JBT_REG_HCLOCK_VGA, 0x1f0);
> +	r |=3D jbt_reg_write(ddata, JBT_REG_BLANK_CONTROL, 0x02);
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
> +transfer_err:
> +
> +	return r ? -EIO : 0;
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

I don't know about this particular panel, but usually you should first
send a DISPLAY_OFF command, and only afterwards disable the DPI output.
Otherwise the panels I know will show garbage on the screen, as the
video stream has ended.

That would also be reverse of the enable sequence.

 Tomi



--iXjLGFov2aTQBSfAQacKKcTSjd2wrjFGN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSb5btAAoJEPo9qoy8lh71c94P/3/YGvBg9GHzg32X35JYAMto
CFCHiPVts5b/pLHz9uGfdsisolcjxLZaoK7uBoA0Ml8v3xO5p/kkZHR/loV/gkD/
HaZodaUYlSHseySWtYhzFfExEw7BgcNhR6JiSA0e/FV54Q06Qi+uAk9OmB2QXKzt
qF26D0m2XFfmp4uWEyHn0/DX1+g0zMR7L5ZSQG/D6HAWMwYLRbh03Iv0WTYD+3Ko
SDijIK0sSFGBs0b1JB4TeRrlOjiPpJ2MGOzgCgZwI7v16TtQLNBA1l3kA74KGUBo
+gtAmYGb2Igf/ho32D+UOD3gMVEZhFXBeUvgnQmJhwjBH3Ued9DYNVSJMpvQqWPv
QoAE+GZTOxbky3YCleECNFGT0LEgrrALTpIwycBB62iQfzgNYOaOgMmAwWL+isTI
Iy0yNbkTbyy7wrVnw0S9QWjqxyoQc8y7A1LpGOxOenW+szmUsbEdbGfq1HSpqJo0
mHuS7H2cBGNt8a2bXFy1w7OsaAifHcfGQaMMly/soVuEXI7rCQX+s+93pV/Kzb32
XpVnkDNloy0pHx0Na/gLmQs2mGUK/qgtl3NFlNWSIGcEDHvqqW0RY767aNXF1ZFX
g6XXeXHahmTP/B14y/4i+tPC1CbU7dia+Fg4oP++BcA5dC2eI96xLfLbJLdz/Pbq
QLUTCFjXuAa1jBwY8NNb
=xeh+
-----END PGP SIGNATURE-----

--iXjLGFov2aTQBSfAQacKKcTSjd2wrjFGN--
