Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab3J2Lgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 07:36:49 -0400
Received: from mail-qe0-f48.google.com ([209.85.128.48]:57554 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574Ab3J2Lgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 07:36:46 -0400
MIME-Version: 1.0
In-Reply-To: <526F96ED.906@ti.com>
References: <1382019258-21000-1-git-send-email-marek@goldelico.com>
	<526F96ED.906@ti.com>
Date: Tue, 29 Oct 2013 12:36:45 +0100
Message-ID: <CAAfyv36JMmNQUAmvD9H2CgtkMdNSnXnfbfRLu4GuVtOWkopAvg@mail.gmail.com>
Subject: Re: [PATCH v2] omapdss: Add new panel driver for Topolly td028ttec1 LCD.
From: Belisko Marek <marek.belisko@gmail.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-fbdev@vger.kernel.org,
        "H. Nikolaus Schaller" <hns@goldelico.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi,

On Tue, Oct 29, 2013 at 12:07 PM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> On 17/10/13 17:14, Marek Belisko wrote:
>> Signed-off-by: Marek Belisko <marek@goldelico.com>
>> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
>> ---
>>
>> changes from v1:
>> - reworked to be spi driver instead platform with custom spi bitbang
>>   this configuration was tested with spi_gpio bitbang driver on gta04 board
>>   and works fine (thanks Tomi and Lars-Peter for comments)
>> - address previous comments
>>
>>  drivers/video/omap2/displays-new/Kconfig           |   6 +
>>  drivers/video/omap2/displays-new/Makefile          |   1 +
>>  .../omap2/displays-new/panel-tpo-td028ttec1.c      | 486 +++++++++++++++++++++
>>  include/video/omap-panel-data.h                    |  13 +
>>  4 files changed, 506 insertions(+)
>>  create mode 100644 drivers/video/omap2/displays-new/panel-tpo-td028ttec1.c
>>
>> diff --git a/drivers/video/omap2/displays-new/Kconfig b/drivers/video/omap2/displays-new/Kconfig
>> index 6c90885..1054249 100644
>> --- a/drivers/video/omap2/displays-new/Kconfig
>> +++ b/drivers/video/omap2/displays-new/Kconfig
>> @@ -56,6 +56,12 @@ config DISPLAY_PANEL_SHARP_LS037V7DW01
>>          help
>>            LCD Panel used in TI's SDP3430 and EVM boards
>>
>> +config DISPLAY_PANEL_TPO_TD028TTEC1
>> +        tristate "TPO TD028TTEC1 LCD Panel"
>> +        depends on SPI
>> +        help
>> +          LCD panel used in Openmoko.
>> +
>>  config DISPLAY_PANEL_TPO_TD043MTEA1
>>          tristate "TPO TD043MTEA1 LCD Panel"
>>          depends on SPI
>> diff --git a/drivers/video/omap2/displays-new/Makefile b/drivers/video/omap2/displays-new/Makefile
>> index 5aeb11b..0323a8a 100644
>> --- a/drivers/video/omap2/displays-new/Makefile
>> +++ b/drivers/video/omap2/displays-new/Makefile
>> @@ -8,5 +8,6 @@ obj-$(CONFIG_DISPLAY_PANEL_DSI_CM) += panel-dsi-cm.o
>>  obj-$(CONFIG_DISPLAY_PANEL_SONY_ACX565AKM) += panel-sony-acx565akm.o
>>  obj-$(CONFIG_DISPLAY_PANEL_LGPHILIPS_LB035Q02) += panel-lgphilips-lb035q02.o
>>  obj-$(CONFIG_DISPLAY_PANEL_SHARP_LS037V7DW01) += panel-sharp-ls037v7dw01.o
>> +obj-$(CONFIG_DISPLAY_PANEL_TPO_TD028TTEC1) += panel-tpo-td028ttec1.o
>>  obj-$(CONFIG_DISPLAY_PANEL_TPO_TD043MTEA1) += panel-tpo-td043mtea1.o
>>  obj-$(CONFIG_DISPLAY_PANEL_NEC_NL8048HL11) += panel-nec-nl8048hl11.o
>> diff --git a/drivers/video/omap2/displays-new/panel-tpo-td028ttec1.c b/drivers/video/omap2/displays-new/panel-tpo-td028ttec1.c
>> new file mode 100644
>> index 0000000..5a44d30
>> --- /dev/null
>> +++ b/drivers/video/omap2/displays-new/panel-tpo-td028ttec1.c
>> @@ -0,0 +1,486 @@
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
>> +#include <linux/spi/spi.h>
>> +#include <linux/gpio.h>
>> +#include <video/omapdss.h>
>> +#include <video/omap-panel-data.h>
>> +
>> +struct panel_drv_data {
>> +     struct omap_dss_device dssdev;
>> +     struct omap_dss_device *in;
>> +
>> +     int data_lines;
>> +
>> +     struct omap_video_timings videomode;
>> +
>> +     struct spi_device *spi_dev;
>> +
>> +     u16 tx_buf[4];
>
> Is there some particular reason to have tx_buf in the driver data? It
> looks to me that it would fit better as a local variable for the funcs
> that need it.
Yes that's true. I'll remove from driver data.
>
>> +};
>> +
>> +static struct omap_video_timings td028ttec1_panel_timings = {
>> +     .x_res          = 480,
>> +     .y_res          = 640,
>> +     .pixel_clock    = 22153,
>> +     .hfp            = 24,
>> +     .hsw            = 8,
>> +     .hbp            = 8,
>> +     .vfp            = 4,
>> +     .vsw            = 2,
>> +     .vbp            = 2,
>> +
>> +     .vsync_level    = OMAPDSS_SIG_ACTIVE_LOW,
>> +     .hsync_level    = OMAPDSS_SIG_ACTIVE_LOW,
>> +
>> +     .data_pclk_edge = OMAPDSS_DRIVE_SIG_FALLING_EDGE,
>> +     .de_level       = OMAPDSS_SIG_ACTIVE_HIGH,
>> +     .sync_pclk_edge = OMAPDSS_DRIVE_SIG_OPPOSITE_EDGES,
>> +};
>> +
>> +#define JBT_COMMAND  0x000
>> +#define JBT_DATA     0x100
>> +
>> +int jbt_reg_write_nodata(struct panel_drv_data *ddata, u8 reg)
>> +{
>> +     int rc;
>> +
>> +     ddata->tx_buf[0] = JBT_COMMAND | reg;
>> +     rc = spi_write(ddata->spi_dev, (u8 *)ddata->tx_buf,
>> +                     1*sizeof(u16));
>> +     if (rc != 0)
>> +             dev_err(&ddata->spi_dev->dev,
>> +                     "jbt_reg_write_nodata spi_write ret %d\n", rc);
>> +
>> +     return rc;
>> +}
>> +
>> +int jbt_reg_write(struct panel_drv_data *ddata, u8 reg, u8 data)
>
> Perhaps name this jbt_reg_write8 to be in line with the jbt_reg_write16.
> Or is it obvious that the function without a suffix works on bytes?
>
> Just a side note, on DSI side I have used suffixes _0, _1, _2 to
> represent transmission without data, with one byte and with 2 bytes.
OK sounds reasonable. I'll update.
>
>> +{
>> +     int rc;
>> +
>> +     ddata->tx_buf[0] = JBT_COMMAND | reg;
>> +     ddata->tx_buf[1] = JBT_DATA | data;
>> +     rc = spi_write(ddata->spi_dev, (u8 *)ddata->tx_buf,
>> +                     2*sizeof(u16));
>> +     if (rc != 0)
>> +             dev_err(&ddata->spi_dev->dev,
>> +                     "jbt_reg_write spi_write ret %d\n", rc);
>> +
>> +     return rc;
>> +}
>> +
>> +int jbt_reg_write16(struct panel_drv_data *ddata, u8 reg, u16 data)
>> +{
>> +     int rc;
>> +
>> +     ddata->tx_buf[0] = JBT_COMMAND | reg;
>> +     ddata->tx_buf[1] = JBT_DATA | (data >> 8);
>> +     ddata->tx_buf[2] = JBT_DATA | (data & 0xff);
>> +
>> +     rc = spi_write(ddata->spi_dev, (u8 *)ddata->tx_buf,
>> +                     3*sizeof(u16));
>> +
>> +     if (rc != 0)
>> +             dev_err(&ddata->spi_dev->dev,
>> +                     "jbt_reg_write16 spi_write ret %d\n", rc);
>> +
>> +     return rc;
>> +}
>> +
>> +enum jbt_register {
>> +     JBT_REG_SLEEP_IN                = 0x10,
>> +     JBT_REG_SLEEP_OUT               = 0x11,
>> +
>> +     JBT_REG_DISPLAY_OFF             = 0x28,
>> +     JBT_REG_DISPLAY_ON              = 0x29,
>> +
>> +     JBT_REG_RGB_FORMAT              = 0x3a,
>> +     JBT_REG_QUAD_RATE               = 0x3b,
>> +
>> +     JBT_REG_POWER_ON_OFF            = 0xb0,
>> +     JBT_REG_BOOSTER_OP              = 0xb1,
>> +     JBT_REG_BOOSTER_MODE            = 0xb2,
>> +     JBT_REG_BOOSTER_FREQ            = 0xb3,
>> +     JBT_REG_OPAMP_SYSCLK            = 0xb4,
>> +     JBT_REG_VSC_VOLTAGE             = 0xb5,
>> +     JBT_REG_VCOM_VOLTAGE            = 0xb6,
>> +     JBT_REG_EXT_DISPL               = 0xb7,
>> +     JBT_REG_OUTPUT_CONTROL          = 0xb8,
>> +     JBT_REG_DCCLK_DCEV              = 0xb9,
>> +     JBT_REG_DISPLAY_MODE1           = 0xba,
>> +     JBT_REG_DISPLAY_MODE2           = 0xbb,
>> +     JBT_REG_DISPLAY_MODE            = 0xbc,
>> +     JBT_REG_ASW_SLEW                = 0xbd,
>> +     JBT_REG_DUMMY_DISPLAY           = 0xbe,
>> +     JBT_REG_DRIVE_SYSTEM            = 0xbf,
>> +
>> +     JBT_REG_SLEEP_OUT_FR_A          = 0xc0,
>> +     JBT_REG_SLEEP_OUT_FR_B          = 0xc1,
>> +     JBT_REG_SLEEP_OUT_FR_C          = 0xc2,
>> +     JBT_REG_SLEEP_IN_LCCNT_D        = 0xc3,
>> +     JBT_REG_SLEEP_IN_LCCNT_E        = 0xc4,
>> +     JBT_REG_SLEEP_IN_LCCNT_F        = 0xc5,
>> +     JBT_REG_SLEEP_IN_LCCNT_G        = 0xc6,
>> +
>> +     JBT_REG_GAMMA1_FINE_1           = 0xc7,
>> +     JBT_REG_GAMMA1_FINE_2           = 0xc8,
>> +     JBT_REG_GAMMA1_INCLINATION      = 0xc9,
>> +     JBT_REG_GAMMA1_BLUE_OFFSET      = 0xca,
>> +
>> +     JBT_REG_BLANK_CONTROL           = 0xcf,
>> +     JBT_REG_BLANK_TH_TV             = 0xd0,
>> +     JBT_REG_CKV_ON_OFF              = 0xd1,
>> +     JBT_REG_CKV_1_2                 = 0xd2,
>> +     JBT_REG_OEV_TIMING              = 0xd3,
>> +     JBT_REG_ASW_TIMING_1            = 0xd4,
>> +     JBT_REG_ASW_TIMING_2            = 0xd5,
>> +
>> +     JBT_REG_HCLOCK_VGA              = 0xec,
>> +     JBT_REG_HCLOCK_QVGA             = 0xed,
>> +};
>> +
>> +#define to_panel_data(p) container_of(p, struct panel_drv_data, dssdev)
>> +
>> +static int td028ttec1_panel_connect(struct omap_dss_device *dssdev)
>> +{
>> +     struct panel_drv_data *ddata = to_panel_data(dssdev);
>> +     struct omap_dss_device *in = ddata->in;
>> +     int r;
>> +
>> +     if (omapdss_device_is_connected(dssdev))
>> +             return 0;
>> +
>> +     r = in->ops.dpi->connect(in, dssdev);
>> +     if (r)
>> +             return r;
>> +
>> +     return 0;
>> +}
>> +
>> +static void td028ttec1_panel_disconnect(struct omap_dss_device *dssdev)
>> +{
>> +     struct panel_drv_data *ddata = to_panel_data(dssdev);
>> +     struct omap_dss_device *in = ddata->in;
>> +
>> +     if (!omapdss_device_is_connected(dssdev))
>> +             return;
>> +
>> +     in->ops.dpi->disconnect(in, dssdev);
>> +}
>> +
>> +static int td028ttec1_panel_enable(struct omap_dss_device *dssdev)
>> +{
>> +     struct panel_drv_data *ddata = to_panel_data(dssdev);
>> +     struct omap_dss_device *in = ddata->in;
>> +     int r;
>> +
>> +     if (!omapdss_device_is_connected(dssdev))
>> +             return -ENODEV;
>> +
>> +     if (omapdss_device_is_enabled(dssdev))
>> +             return 0;
>> +
>> +     in->ops.dpi->set_data_lines(in, ddata->data_lines);
>> +     in->ops.dpi->set_timings(in, &ddata->videomode);
>> +
>> +     r = in->ops.dpi->enable(in);
>> +     if (r)
>> +             return r;
>> +
>> +     dev_dbg(dssdev->dev, "td028ttec1_panel_enable() - state %d\n",
>> +             dssdev->state);
>> +
>> +     /*
>> +      * according to data sheet: wait 50ms (Tpos of LCM). However, 50ms
>> +      * seems unreliable with later LCM batches, increasing to 90ms
>> +      */
>> +     msleep(90);
>
> Wait for what?
>
>> +
>> +     /* three times command zero */
>> +     r |= jbt_reg_write_nodata(ddata, 0x00);
>> +     msleep(1000);
>> +     r |= jbt_reg_write_nodata(ddata, 0x00);
>> +     msleep(1000);
>> +     r |= jbt_reg_write_nodata(ddata, 0x00);
>> +     msleep(1000);
>
> Three _seconds_? That's a huge delay when enabling a panel. Is this
> really required?
I checked old driver and there is same but wait for 1ms only not 1 sec [1].
I'll check if 1ms will be enough.
>
>> +
>> +     if (r) {
>> +             dev_warn(dssdev->dev, "transfer error\n");
>> +             goto transfer_err;
>> +     }
>> +
>> +     /* deep standby out */
>> +     r |= jbt_reg_write(ddata, JBT_REG_POWER_ON_OFF, 0x17);
>> +
>> +     /* RGB I/F on, RAM write off, QVGA through, SIGCON enable */
>> +     r |= jbt_reg_write(ddata, JBT_REG_DISPLAY_MODE, 0x80);
>> +
>> +     /* Quad mode off */
>> +     r |= jbt_reg_write(ddata, JBT_REG_QUAD_RATE, 0x00);
>> +
>> +     /* AVDD on, XVDD on */
>> +     r |= jbt_reg_write(ddata, JBT_REG_POWER_ON_OFF, 0x16);
>> +
>> +     /* Output control */
>> +     r |= jbt_reg_write16(ddata, JBT_REG_OUTPUT_CONTROL, 0xfff9);
>> +
>> +     /* Sleep mode off */
>> +     r |= jbt_reg_write_nodata(ddata, JBT_REG_SLEEP_OUT);
>> +
>> +     /* at this point we have like 50% grey */
>> +
>> +     /* initialize register set */
>> +     r |= jbt_reg_write(ddata, JBT_REG_DISPLAY_MODE1, 0x01);
>> +     r |= jbt_reg_write(ddata, JBT_REG_DISPLAY_MODE2, 0x00);
>> +     r |= jbt_reg_write(ddata, JBT_REG_RGB_FORMAT, 0x60);
>> +     r |= jbt_reg_write(ddata, JBT_REG_DRIVE_SYSTEM, 0x10);
>> +     r |= jbt_reg_write(ddata, JBT_REG_BOOSTER_OP, 0x56);
>> +     r |= jbt_reg_write(ddata, JBT_REG_BOOSTER_MODE, 0x33);
>> +     r |= jbt_reg_write(ddata, JBT_REG_BOOSTER_FREQ, 0x11);
>> +     r |= jbt_reg_write(ddata, JBT_REG_BOOSTER_FREQ, 0x11);
>> +     r |= jbt_reg_write(ddata, JBT_REG_OPAMP_SYSCLK, 0x02);
>> +     r |= jbt_reg_write(ddata, JBT_REG_VSC_VOLTAGE, 0x2b);
>> +     r |= jbt_reg_write(ddata, JBT_REG_VCOM_VOLTAGE, 0x40);
>> +     r |= jbt_reg_write(ddata, JBT_REG_EXT_DISPL, 0x03);
>> +     r |= jbt_reg_write(ddata, JBT_REG_DCCLK_DCEV, 0x04);
>> +     /*
>> +      * default of 0x02 in JBT_REG_ASW_SLEW responsible for 72Hz requirement
>> +      * to avoid red / blue flicker
>> +      */
>> +     r |= jbt_reg_write(ddata, JBT_REG_ASW_SLEW, 0x04);
>> +     r |= jbt_reg_write(ddata, JBT_REG_DUMMY_DISPLAY, 0x00);
>> +
>> +     r |= jbt_reg_write(ddata, JBT_REG_SLEEP_OUT_FR_A, 0x11);
>> +     r |= jbt_reg_write(ddata, JBT_REG_SLEEP_OUT_FR_B, 0x11);
>> +     r |= jbt_reg_write(ddata, JBT_REG_SLEEP_OUT_FR_C, 0x11);
>> +     r |= jbt_reg_write16(ddata, JBT_REG_SLEEP_IN_LCCNT_D, 0x2040);
>> +     r |= jbt_reg_write16(ddata, JBT_REG_SLEEP_IN_LCCNT_E, 0x60c0);
>> +     r |= jbt_reg_write16(ddata, JBT_REG_SLEEP_IN_LCCNT_F, 0x1020);
>> +     r |= jbt_reg_write16(ddata, JBT_REG_SLEEP_IN_LCCNT_G, 0x60c0);
>> +
>> +     r |= jbt_reg_write16(ddata, JBT_REG_GAMMA1_FINE_1, 0x5533);
>> +     r |= jbt_reg_write(ddata, JBT_REG_GAMMA1_FINE_2, 0x00);
>> +     r |= jbt_reg_write(ddata, JBT_REG_GAMMA1_INCLINATION, 0x00);
>> +     r |= jbt_reg_write(ddata, JBT_REG_GAMMA1_BLUE_OFFSET, 0x00);
>> +
>> +     r |= jbt_reg_write16(ddata, JBT_REG_HCLOCK_VGA, 0x1f0);
>> +     r |= jbt_reg_write(ddata, JBT_REG_BLANK_CONTROL, 0x02);
>> +     r |= jbt_reg_write16(ddata, JBT_REG_BLANK_TH_TV, 0x0804);
>> +
>> +     r |= jbt_reg_write(ddata, JBT_REG_CKV_ON_OFF, 0x01);
>> +     r |= jbt_reg_write16(ddata, JBT_REG_CKV_1_2, 0x0000);
>> +
>> +     r |= jbt_reg_write16(ddata, JBT_REG_OEV_TIMING, 0x0d0e);
>> +     r |= jbt_reg_write16(ddata, JBT_REG_ASW_TIMING_1, 0x11a4);
>> +     r |= jbt_reg_write(ddata, JBT_REG_ASW_TIMING_2, 0x0e);
>> +
>> +     r |= jbt_reg_write_nodata(ddata, JBT_REG_DISPLAY_ON);
>> +
>> +     dssdev->state = OMAP_DSS_DISPLAY_ACTIVE;
>> +
>> +transfer_err:
>> +
>> +     return r ? -EIO : 0;
>> +}
>> +
>> +static void td028ttec1_panel_disable(struct omap_dss_device *dssdev)
>> +{
>> +     struct panel_drv_data *ddata = to_panel_data(dssdev);
>> +     struct omap_dss_device *in = ddata->in;
>> +
>> +     if (!omapdss_device_is_enabled(dssdev))
>> +             return;
>> +
>> +     dev_dbg(dssdev->dev, "td028ttec1_panel_disable()\n");
>> +
>> +     in->ops.dpi->disable(in);
>> +
>> +     jbt_reg_write_nodata(ddata, JBT_REG_DISPLAY_OFF);
>> +     jbt_reg_write16(ddata, JBT_REG_OUTPUT_CONTROL, 0x8002);
>> +     jbt_reg_write_nodata(ddata, JBT_REG_SLEEP_IN);
>> +     jbt_reg_write(ddata, JBT_REG_POWER_ON_OFF, 0x00);
>
> I don't know about this particular panel, but usually you should first
> send a DISPLAY_OFF command, and only afterwards disable the DPI output.
> Otherwise the panels I know will show garbage on the screen, as the
> video stream has ended.
>
> That would also be reverse of the enable sequence.
OK will check. Thanks.
>
>  Tomi
>
>

BR,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
