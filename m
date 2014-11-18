Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbaKRPDz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:03:55 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:42824 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647AbaKRPDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 10:03:50 -0500
Date: Tue, 18 Nov 2014 11:03:37 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Caesar Wang <caesar.wang@rock-chips.com>
Cc: heiko@sntech.de, rui.zhang@intel.com, zyf@rock-chips.com,
        dianders@chromium.org, linux-rockchip@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, cf@rock-chips.com,
        dmitry.torokhov@gmail.com, huangtao@rock-chips.com, fzf@rock-chips.com
Subject: Re: [PATCH v18 2/5] thermal: rockchip: add driver for thermal
Message-ID: <20141118150333.GA18579@developer>
References: <1415768562-9155-1-git-send-email-caesar.wang@rock-chips.com>
 <1415768562-9155-3-git-send-email-caesar.wang@rock-chips.com>
 <546AF828.7050806@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
In-Reply-To: <546AF828.7050806@rock-chips.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hello Caesar,

On Tue, Nov 18, 2014 at 03:41:28PM +0800, Caesar Wang wrote:
> Hello edubezval,
>=20
> I saw your latest patch[0].
> I need send the new patch to fit the of-thermal Sensors API.
> Right?
>=20
> [0]: https://patchwork.kernel.org/patch/5324371/
>=20

Right. I've just posted a new version of it.
https://patchwork.kernel.org/patch/5329801/

But the main idea remains. So please, update you driver on top of it.


> =E5=9C=A8 2014=E5=B9=B411=E6=9C=8812=E6=97=A5 13:02, Caesar Wang =E5=86=
=99=E9=81=93:
> > Thermal is TS-ADC Controller module supports
> > user-defined mode and automatic mode.
> >
> > User-defined mode refers,TSADC all the control signals entirely by
> > software writing to register for direct control.
> >
> > Automaic mode refers to the module automatically poll TSADC output,
> > and the results were checked.If you find that the temperature High
> > in a period of time,an interrupt is generated to the processor
> > down-measures taken;If the temperature over a period of time High,
> > the resulting TSHUT gave CRU module,let it reset the entire chip,
> > or via GPIO give PMIC.
> >
> > Signed-off-by: zhaoyifeng <zyf@rock-chips.com>
> > Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
> > Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > ---
> >   drivers/thermal/Kconfig            |  10 +
> >   drivers/thermal/Makefile           |   1 +
> >   drivers/thermal/rockchip_thermal.c | 721 ++++++++++++++++++++++++++++=
+++++++++
> >   3 files changed, 732 insertions(+)
> >   create mode 100644 drivers/thermal/rockchip_thermal.c
> >
> > diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> > index ef5587f..527632d 100644
> > --- a/drivers/thermal/Kconfig
> > +++ b/drivers/thermal/Kconfig
> > @@ -133,6 +133,16 @@ config SPEAR_THERMAL
> >   	  Enable this to plug the SPEAr thermal sensor driver into the Linux
> >   	  thermal framework.
> >  =20
> > +config ROCKCHIP_THERMAL
> > +	tristate "Rockchip thermal driver"
> > +	depends on ARCH_ROCKCHIP
> > +	depends on RESET_CONTROLLER
> > +	help
> > +	  Rockchip thermal driver provides support for Temperature sensor
> > +	  ADC (TS-ADC) found on Rockchip SoCs. It supports one critical
> > +	  trip point. Cpufreq is used as the cooling device and will throttle
> > +	  CPUs when the Temperature crosses the passive trip point.
> > +
> >   config RCAR_THERMAL
> >   	tristate "Renesas R-Car thermal driver"
> >   	depends on ARCH_SHMOBILE || COMPILE_TEST
> > diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
> > index 31e232f..21da0a8 100644
> > --- a/drivers/thermal/Makefile
> > +++ b/drivers/thermal/Makefile
> > @@ -19,6 +19,7 @@ thermal_sys-$(CONFIG_CPU_THERMAL)	+=3D cpu_cooling.o
> >  =20
> >   # platform thermal drivers
> >   obj-$(CONFIG_SPEAR_THERMAL)	+=3D spear_thermal.o
> > +obj-$(CONFIG_ROCKCHIP_THERMAL)	+=3D rockchip_thermal.o
> >   obj-$(CONFIG_RCAR_THERMAL)	+=3D rcar_thermal.o
> >   obj-$(CONFIG_KIRKWOOD_THERMAL)  +=3D kirkwood_thermal.o
> >   obj-y				+=3D samsung/
> > diff --git a/drivers/thermal/rockchip_thermal.c b/drivers/thermal/rockc=
hip_thermal.c
> > new file mode 100644
> > index 0000000..524e3d6
> > --- /dev/null
> > +++ b/drivers/thermal/rockchip_thermal.c
> > @@ -0,0 +1,721 @@
> > +/*
> > + * Copyright (c) 2014, Fuzhou Rockchip Electronics Co., Ltd
> > + *
> > + * This program is free software; you can redistribute it and/or modif=
y it
> > + * under the terms and conditions of the GNU General Public License,
> > + * version 2, as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope it will be useful, but WITH=
OUT
> > + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY =
or
> > + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public Licen=
se for
> > + * more details.
> > + */
> > +
> > +#include <linux/clk.h>
> > +#include <linux/delay.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/io.h>
> > +#include <linux/module.h>
> > +#include <linux/of.h>
> > +#include <linux/of_address.h>
> > +#include <linux/of_irq.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/reset.h>
> > +#include <linux/thermal.h>
> > +
> > +/**
> > + * If the temperature over a period of time High,
> > + * the resulting TSHUT gave CRU module,let it reset the entire chip,
> > + * or via GPIO give PMIC.
> > + */
> > +enum tshut_mode {
> > +	TSHUT_MODE_CRU =3D 0,
> > +	TSHUT_MODE_GPIO,
> > +};
> > +
> > +/**
> > + * the system Temperature Sensors tshut(tshut) polarity
> > + * the bit 8 is tshut polarity.
> > + * 0: low active, 1: high active
> > + */
> > +enum tshut_polarity {
> > +	TSHUT_LOW_ACTIVE =3D 0,
> > +	TSHUT_HIGH_ACTIVE,
> > +};
> > +
> > +/**
> > + * The system has three Temperature Sensors.  channel 0 is reserved,
> > + * channel 1 is for CPU, and channel 2 is for GPU.
> > + */
> > +enum sensor_id {
> > +	SENSOR_CPU =3D 1,
> > +	SENSOR_GPU,
> > +};
> > +
> > +struct rockchip_tsadc_chip {
> > +	/* The hardware-controlled tshut property */
> > +	long tshut_temp;
> > +	enum tshut_mode tshut_mode;
> > +	enum tshut_polarity tshut_polarity;
> > +
> > +	/* Chip-wide methods */
> > +	void (*initialize)(void __iomem *reg, enum tshut_polarity p);
> > +	void (*irq_ack)(void __iomem *reg);
> > +	void (*control)(void __iomem *reg, bool on);
> > +
> > +	/* Per-sensor methods */
> > +	int (*get_temp)(int chn, void __iomem *reg, long *temp);
> > +	void (*set_alarm_temp)(int chn, void __iomem *reg, long temp);
> > +	void (*set_tshut_temp)(int chn, void __iomem *reg, long temp);
> > +	void (*set_tshut_mode)(int chn, void __iomem *reg, enum tshut_mode m);
> > +};
> > +
> > +struct rockchip_thermal_sensor {
> > +	struct rockchip_thermal_data *thermal;
> > +	struct thermal_zone_device *tzd;
> > +	enum sensor_id id;
> > +};
> > +
> > +#define NUM_SENSORS	2 /* Ignore unused sensor 0 */
> > +
> > +struct rockchip_thermal_data {
> > +	const struct rockchip_tsadc_chip *chip;
> > +	struct platform_device *pdev;
> > +	struct reset_control *reset;
> > +
> > +	struct rockchip_thermal_sensor sensors[NUM_SENSORS];
> > +
> > +	struct clk *clk;
> > +	struct clk *pclk;
> > +
> > +	void __iomem *regs;
> > +
> > +	long tshut_temp;
> > +	enum tshut_mode tshut_mode;
> > +	enum tshut_polarity tshut_polarity;
> > +};
> > +
> > +/* TSADC V2 Sensor info define: */
> > +#define TSADCV2_AUTO_CON			0x04
> > +#define TSADCV2_INT_EN				0x08
> > +#define TSADCV2_INT_PD				0x0c
> > +#define TSADCV2_DATA(chn)			(0x20 + (chn) * 0x04)
> > +#define TSADCV2_COMP_INT(chn)		        (0x30 + (chn) * 0x04)
> > +#define TSADCV2_COMP_SHUT(chn)		        (0x40 + (chn) * 0x04)
> > +#define TSADCV2_HIGHT_INT_DEBOUNCE		0x60
> > +#define TSADCV2_HIGHT_TSHUT_DEBOUNCE		0x64
> > +#define TSADCV2_AUTO_PERIOD			0x68
> > +#define TSADCV2_AUTO_PERIOD_HT			0x6c
> > +
> > +#define TSADCV2_AUTO_EN				BIT(0)
> > +#define TSADCV2_AUTO_DISABLE			~BIT(0)
> > +#define TSADCV2_AUTO_SRC_EN(chn)		BIT(4 + (chn))
> > +#define TSADCV2_AUTO_TSHUT_POLARITY_HIGH	BIT(8)
> > +#define TSADCV2_AUTO_TSHUT_POLARITY_LOW		~BIT(8)
> > +
> > +#define TSADCV2_INT_SRC_EN(chn)			BIT(chn)
> > +#define TSADCV2_SHUT_2GPIO_SRC_EN(chn)		BIT(4 + (chn))
> > +#define TSADCV2_SHUT_2CRU_SRC_EN(chn)		BIT(8 + (chn))
> > +
> > +#define TSADCV2_INT_PD_CLEAR			~BIT(8)
> > +
> > +#define TSADCV2_DATA_MASK			0xfff
> > +#define TSADCV2_HIGHT_INT_DEBOUNCE_COUNT	4
> > +#define TSADCV2_HIGHT_TSHUT_DEBOUNCE_COUNT	4
> > +#define TSADCV2_AUTO_PERIOD_TIME		250 /* msec */
> > +#define TSADCV2_AUTO_PERIOD_HT_TIME		50  /* msec */
> > +
> > +struct tsadc_table {
> > +	unsigned long code;
> > +	long temp;
> > +};
> > +
> > +static const struct tsadc_table v2_code_table[] =3D {
> > +	{TSADCV2_DATA_MASK, -40000},
> > +	{3800, -40000},
> > +	{3792, -35000},
> > +	{3783, -30000},
> > +	{3774, -25000},
> > +	{3765, -20000},
> > +	{3756, -15000},
> > +	{3747, -10000},
> > +	{3737, -5000},
> > +	{3728, 0},
> > +	{3718, 5000},
> > +	{3708, 10000},
> > +	{3698, 15000},
> > +	{3688, 20000},
> > +	{3678, 25000},
> > +	{3667, 30000},
> > +	{3656, 35000},
> > +	{3645, 40000},
> > +	{3634, 45000},
> > +	{3623, 50000},
> > +	{3611, 55000},
> > +	{3600, 60000},
> > +	{3588, 65000},
> > +	{3575, 70000},
> > +	{3563, 75000},
> > +	{3550, 80000},
> > +	{3537, 85000},
> > +	{3524, 90000},
> > +	{3510, 95000},
> > +	{3496, 100000},
> > +	{3482, 105000},
> > +	{3467, 110000},
> > +	{3452, 115000},
> > +	{3437, 120000},
> > +	{3421, 125000},
> > +	{0, 125000},
> > +};
> > +
> > +static u32 rk_tsadcv2_temp_to_code(long temp)
> > +{
> > +	int high, low, mid;
> > +
> > +	low =3D 0;
> > +	high =3D ARRAY_SIZE(v2_code_table) - 1;
> > +	mid =3D (high + low) / 2;
> > +
> > +	if (temp < v2_code_table[low].temp || temp > v2_code_table[high].temp)
> > +		return 0;
> > +
> > +	while (low <=3D high) {
> > +		if (temp =3D=3D v2_code_table[mid].temp)
> > +			return v2_code_table[mid].code;
> > +		else if (temp < v2_code_table[mid].temp)
> > +			high =3D mid - 1;
> > +		else
> > +			low =3D mid + 1;
> > +		mid =3D (low + high) / 2;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static long rk_tsadcv2_code_to_temp(u32 code)
> > +{
> > +	int high, low, mid;
> > +
> > +	low =3D 0;
> > +	high =3D ARRAY_SIZE(v2_code_table) - 1;
> > +	mid =3D (high + low) / 2;
> > +
> > +	if (code > v2_code_table[low].code || code < v2_code_table[high].code)
> > +		return 125000; /* No code available, return max temperature */
> > +
> > +	while (low <=3D high) {
> > +		if (code >=3D v2_code_table[mid].code && code <
> > +		    v2_code_table[mid - 1].code)
> > +			return v2_code_table[mid].temp;
> > +		else if (code < v2_code_table[mid].code)
> > +			low =3D mid + 1;
> > +		else
> > +			high =3D mid - 1;
> > +		mid =3D (low + high) / 2;
> > +	}
> > +
> > +	return 125000;
> > +}
> > +
> > +/**
> > + * rk_tsadcv2_initialize - initialize TASDC Controller
> > + * (1) Set TSADCV2_AUTO_PERIOD, configure the interleave between
> > + * every two accessing of TSADC in normal operation.
> > + * (2) Set TSADCV2_AUTO_PERIOD_HT, configure the interleave between
> > + * every two accessing of TSADC after the temperature is higher
> > + * than COM_SHUT or COM_INT.
> > + * (3) Set TSADCV2_HIGH_INT_DEBOUNCE and TSADC_HIGHT_TSHUT_DEBOUNCE,
> > + * if the temperature is higher than COMP_INT or COMP_SHUT for
> > + * "debounce" times, TSADC controller will generate interrupt or TSHUT.
> > + */
> > +static void rk_tsadcv2_initialize(void __iomem *regs,
> > +				  enum tshut_polarity tshut_polarity)
> > +{
> > +	if (tshut_polarity =3D=3D TSHUT_HIGH_ACTIVE)
> > +		writel_relaxed(0 | (TSADCV2_AUTO_TSHUT_POLARITY_HIGH),
> > +			       regs + TSADCV2_AUTO_CON);
> > +	else
> > +		writel_relaxed(0 | (TSADCV2_AUTO_TSHUT_POLARITY_LOW),
> > +			       regs + TSADCV2_AUTO_CON);
> > +
> > +	writel_relaxed(TSADCV2_AUTO_PERIOD_TIME, regs + TSADCV2_AUTO_PERIOD);
> > +	writel_relaxed(TSADCV2_HIGHT_INT_DEBOUNCE_COUNT,
> > +		       regs + TSADCV2_HIGHT_INT_DEBOUNCE);
> > +	writel_relaxed(TSADCV2_AUTO_PERIOD_HT_TIME,
> > +		       regs + TSADCV2_AUTO_PERIOD_HT);
> > +	writel_relaxed(TSADCV2_HIGHT_TSHUT_DEBOUNCE_COUNT,
> > +		       regs + TSADCV2_HIGHT_TSHUT_DEBOUNCE);
> > +}
> > +
> > +static void rk_tsadcv2_irq_ack(void __iomem *regs)
> > +{
> > +	u32 val;
> > +
> > +	val =3D readl_relaxed(regs + TSADCV2_INT_PD);
> > +	writel_relaxed(val & TSADCV2_INT_PD_CLEAR, regs + TSADCV2_INT_PD);
> > +}
> > +
> > +static void rk_tsadcv2_control(void __iomem *regs, bool enable)
> > +{
> > +	u32 val;
> > +
> > +	val =3D readl_relaxed(regs + TSADCV2_AUTO_CON);
> > +	if (enable)
> > +		val |=3D TSADCV2_AUTO_EN;
> > +	else
> > +		val &=3D ~TSADCV2_AUTO_EN;
> > +
> > +	writel_relaxed(val, regs + TSADCV2_AUTO_CON);
> > +}
> > +
> > +static int rk_tsadcv2_get_temp(int chn, void __iomem *regs, long *temp)
> > +{
> > +	u32 val;
> > +
> > +	/* the A/D value of the channel last conversion need some time */
> > +	val =3D readl_relaxed(regs + TSADCV2_DATA(chn));
> > +	if (val =3D=3D 0)
> > +		return -EAGAIN;
> > +
> > +	*temp =3D rk_tsadcv2_code_to_temp(val);
> > +
> > +	return 0;
> > +}
> > +
> > +static void rk_tsadcv2_alarm_temp(int chn, void __iomem *regs, long te=
mp)
> > +{
> > +	u32 alarm_value, int_en;
> > +
> > +	alarm_value =3D rk_tsadcv2_temp_to_code(temp);
> > +	writel_relaxed(alarm_value & TSADCV2_DATA_MASK,
> > +		       regs + TSADCV2_COMP_INT(chn));
> > +
> > +	int_en =3D readl_relaxed(regs + TSADCV2_INT_EN);
> > +	int_en |=3D TSADCV2_INT_SRC_EN(chn);
> > +	writel_relaxed(int_en, regs + TSADCV2_INT_EN);
> > +}
> > +
> > +static void rk_tsadcv2_tshut_temp(int chn, void __iomem *regs, long te=
mp)
> > +{
> > +	u32 tshut_value, val;
> > +
> > +	tshut_value =3D rk_tsadcv2_temp_to_code(temp);
> > +	writel_relaxed(tshut_value, regs + TSADCV2_COMP_SHUT(chn));
> > +
> > +	/* TSHUT will be valid */
> > +	val =3D readl_relaxed(regs + TSADCV2_AUTO_CON);
> > +	writel_relaxed(val | TSADCV2_AUTO_SRC_EN(chn), regs + TSADCV2_AUTO_CO=
N);
> > +}
> > +
> > +static void rk_tsadcv2_tshut_mode(int chn, void __iomem *regs,
> > +				  enum tshut_mode mode)
> > +{
> > +	u32 val;
> > +
> > +	val =3D readl_relaxed(regs + TSADCV2_INT_EN);
> > +	if (mode =3D=3D TSHUT_MODE_GPIO) {
> > +		val &=3D ~TSADCV2_SHUT_2CRU_SRC_EN(chn);
> > +		val |=3D TSADCV2_SHUT_2GPIO_SRC_EN(chn);
> > +	} else {
> > +		val &=3D ~TSADCV2_SHUT_2GPIO_SRC_EN(chn);
> > +		val |=3D TSADCV2_SHUT_2CRU_SRC_EN(chn);
> > +	}
> > +
> > +	writel_relaxed(val, regs + TSADCV2_INT_EN);
> > +}
> > +
> > +static const struct rockchip_tsadc_chip rk3288_tsadc_data =3D {
> > +	.tshut_mode =3D TSHUT_MODE_GPIO, /* default TSHUT via GPIO give PMIC =
*/
> > +	.tshut_polarity =3D TSHUT_LOW_ACTIVE, /* default TSHUT LOW ACTIVE */
> > +	.tshut_temp =3D 95000,
> > +
> > +	.initialize =3D rk_tsadcv2_initialize,
> > +	.irq_ack =3D rk_tsadcv2_irq_ack,
> > +	.control =3D rk_tsadcv2_control,
> > +	.get_temp =3D rk_tsadcv2_get_temp,
> > +	.set_alarm_temp =3D rk_tsadcv2_alarm_temp,
> > +	.set_tshut_temp =3D rk_tsadcv2_tshut_temp,
> > +	.set_tshut_mode =3D rk_tsadcv2_tshut_mode,
> > +};
> > +
> > +static const struct of_device_id of_rockchip_thermal_match[] =3D {
> > +	{
> > +		.compatible =3D "rockchip,rk3288-tsadc",
> > +		.data =3D (void *)&rk3288_tsadc_data,
> > +	},
> > +	{ /* end */ },
> > +};
> > +MODULE_DEVICE_TABLE(of, of_rockchip_thermal_match);
> > +
> > +static void
> > +rockchip_thermal_toggle_sensor(struct rockchip_thermal_sensor *sensor,=
 bool on)
> > +{
> > +	struct thermal_zone_device *tzd =3D sensor->tzd;
> > +
> > +	tzd->ops->set_mode(tzd,
> > +		on ? THERMAL_DEVICE_ENABLED : THERMAL_DEVICE_DISABLED);
> > +}
> > +
> > +static irqreturn_t rockchip_thermal_alarm_irq_thread(int irq, void *de=
v)
> > +{
> > +	struct rockchip_thermal_data *thermal =3D dev;
> > +	int i;
> > +
> > +	dev_dbg(&thermal->pdev->dev, "thermal alarm\n");
> > +
> > +	thermal->chip->irq_ack(thermal->regs);
> > +
> > +	for (i =3D 0; i < ARRAY_SIZE(thermal->sensors); i++)
> > +		thermal_zone_device_update(thermal->sensors[i].tzd);
> > +
> > +	return IRQ_HANDLED;
> > +}
> > +
> > +static int rockchip_thermal_set_trips(void *_sensor, long low, long hi=
gh)
> > +{
> > +	struct rockchip_thermal_sensor *sensor =3D _sensor;
> > +	struct rockchip_thermal_data *thermal =3D sensor->thermal;
> > +	const struct rockchip_tsadc_chip *tsadc =3D thermal->chip;
> > +
> > +	dev_dbg(&thermal->pdev->dev, "%s: sensor %d: low: %ld, high %ld\n",
> > +		__func__, sensor->id, low, high);
> > +
> > +	tsadc->set_alarm_temp(sensor->id, thermal->regs, high);
> > +
> > +	return 0;
> > +}
> > +
> > +static int rockchip_thermal_get_temp(void *_sensor, long *out_temp)
> > +{
> > +	struct rockchip_thermal_sensor *sensor =3D _sensor;
> > +	struct rockchip_thermal_data *thermal =3D sensor->thermal;
> > +	const struct rockchip_tsadc_chip *tsadc =3D sensor->thermal->chip;
> > +	int retval;
> > +
> > +	retval =3D tsadc->get_temp(sensor->id, thermal->regs, out_temp);
> > +	dev_dbg(&thermal->pdev->dev, "sensor %d - temp: %ld, retval: %d\n",
> > +		sensor->id, *out_temp, retval);
> > +
> > +	return retval;
> > +}
> > +
> > +static int rockchip_configure_from_dt(struct device *dev,
> > +				      struct device_node *np,
> > +				      struct rockchip_thermal_data *thermal)
> > +{
> > +	u32 shut_temp, tshut_mode, tshut_polarity;
> > +
> > +	if (of_property_read_u32(np, "rockchip,hw-tshut-temp", &shut_temp)) {
> > +		dev_warn(dev,
> > +			 "Missing tshut temp property, using default %ld\n",
> > +			 thermal->chip->tshut_temp);
> > +		thermal->tshut_temp =3D thermal->chip->tshut_temp;
> > +	} else {
> > +		thermal->tshut_temp =3D shut_temp;
> > +	}
> > +
> > +	if (thermal->tshut_temp > INT_MAX) {
> > +		dev_err(dev, "Invalid tshut temperature specified: %ld\n",
> > +			thermal->tshut_temp);
> > +		return -ERANGE;
> > +	}
> > +
> > +	if (of_property_read_u32(np, "rockchip,hw-tshut-mode", &tshut_mode)) {
> > +		dev_warn(dev,
> > +			 "Missing tshut mode property, using default (%s)\n",
> > +			 thermal->chip->tshut_mode =3D=3D TSHUT_MODE_GPIO ?
> > +				"gpio" : "cru");
> > +		thermal->tshut_mode =3D thermal->chip->tshut_mode;
> > +	} else {
> > +		thermal->tshut_mode =3D tshut_mode;
> > +	}
> > +
> > +	if (thermal->tshut_mode > 1) {
> > +		dev_err(dev, "Invalid tshut mode specified: %d\n",
> > +			thermal->tshut_mode);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (of_property_read_u32(np, "rockchip,hw-tshut-polarity",
> > +				 &tshut_polarity)) {
> > +		dev_warn(dev,
> > +			 "Missing tshut-polarity property, using default (%s)\n",
> > +			 thermal->chip->tshut_polarity =3D=3D TSHUT_LOW_ACTIVE ?
> > +				"low" : "high");
> > +		thermal->tshut_polarity =3D thermal->chip->tshut_polarity;
> > +	} else {
> > +		thermal->tshut_polarity =3D tshut_polarity;
> > +	}
> > +
> > +	if (thermal->tshut_polarity > 1) {
> > +		dev_err(dev, "Invalid tshut-polarity specified: %d\n",
> > +			thermal->tshut_polarity);
> > +		return -EINVAL;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int
> > +rockchip_thermal_register_sensor(struct platform_device *pdev,
> > +				 struct rockchip_thermal_data *thermal,
> > +				 struct rockchip_thermal_sensor *sensor,
> > +				 enum sensor_id id)
> > +{
> > +	const struct rockchip_tsadc_chip *tsadc =3D thermal->chip;
> > +	int error;
> > +
> > +	tsadc->set_tshut_mode(id, thermal->regs, thermal->tshut_mode);
> > +	tsadc->set_tshut_temp(id, thermal->regs, thermal->tshut_temp);
> > +
> > +	sensor->thermal =3D thermal;
> > +	sensor->id =3D id;
> > +	sensor->tzd =3D thermal_zone_of_sensor_register(&pdev->dev, id, senso=
r,
> > +						rockchip_thermal_get_temp,
> > +						NULL,
> > +						rockchip_thermal_set_trips);

The set_trips callback is not currently supported. And you also do not
mention about it. By having this dependency here, you either get the
patch, refresh it, and include in your patchset, or you would need to
wait until that change gets refreshed, reviewed, and merged.


> > +	if (IS_ERR(sensor->tzd)) {
> > +		error =3D PTR_ERR(sensor->tzd);
> > +		dev_err(&pdev->dev, "failed to register sensor %d: %d\n",
> > +			id, error);
> > +		return error;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +/*
> > + * Reset TSADC Controller, reset all tsadc registers.
> > + */
> > +static void rockchip_thermal_reset_controller(struct reset_control *re=
set)
> > +{
> > +	reset_control_assert(reset);
> > +	usleep_range(10, 20);
> > +	reset_control_deassert(reset);
> > +}
> > +
> > +static int rockchip_thermal_probe(struct platform_device *pdev)
> > +{
> > +	struct device_node *np =3D pdev->dev.of_node;
> > +	struct rockchip_thermal_data *thermal;
> > +	const struct of_device_id *match;
> > +	struct resource *res;
> > +	int irq;
> > +	int i;
> > +	int error;
> > +
> > +	match =3D of_match_node(of_rockchip_thermal_match, np);
> > +	if (!match)
> > +		return -ENXIO;
> > +
> > +	irq =3D platform_get_irq(pdev, 0);
> > +	if (irq < 0) {
> > +		dev_err(&pdev->dev, "no irq resource?\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	thermal =3D devm_kzalloc(&pdev->dev, sizeof(struct rockchip_thermal_d=
ata),
> > +			       GFP_KERNEL);
> > +	if (!thermal)
> > +		return -ENOMEM;
> > +
> > +	thermal->pdev =3D pdev;
> > +
> > +	thermal->chip =3D (const struct rockchip_tsadc_chip *)match->data;
> > +	if (!thermal->chip)
> > +		return -EINVAL;
> > +
> > +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	thermal->regs =3D devm_ioremap_resource(&pdev->dev, res);
> > +	if (IS_ERR(thermal->regs))
> > +		return PTR_ERR(thermal->regs);
> > +
> > +	thermal->reset =3D devm_reset_control_get(&pdev->dev, "tsadc-apb");
> > +	if (IS_ERR(thermal->reset)) {
> > +		error =3D PTR_ERR(thermal->reset);
> > +		dev_err(&pdev->dev, "failed to get tsadc reset: %d\n", error);
> > +		return error;
> > +	}
> > +
> > +	thermal->clk =3D devm_clk_get(&pdev->dev, "tsadc");
> > +	if (IS_ERR(thermal->clk)) {
> > +		error =3D PTR_ERR(thermal->clk);
> > +		dev_err(&pdev->dev, "failed to get tsadc clock: %d\n", error);
> > +		return error;
> > +	}
> > +
> > +	thermal->pclk =3D devm_clk_get(&pdev->dev, "apb_pclk");
> > +	if (IS_ERR(thermal->pclk)) {
> > +		error =3D PTR_ERR(thermal->clk);
> > +		dev_err(&pdev->dev, "failed to get apb_pclk clock: %d\n",
> > +			error);
> > +		return error;
> > +	}
> > +
> > +	error =3D clk_prepare_enable(thermal->clk);
> > +	if (error) {
> > +		dev_err(&pdev->dev, "failed to enable converter clock: %d\n",
> > +			error);
> > +		return error;
> > +	}
> > +
> > +	error =3D clk_prepare_enable(thermal->pclk);
> > +	if (error) {
> > +		dev_err(&pdev->dev, "failed to enable pclk: %d\n", error);
> > +		goto err_disable_clk;
> > +	}
> > +
> > +	rockchip_thermal_reset_controller(thermal->reset);
> > +
> > +	error =3D rockchip_configure_from_dt(&pdev->dev, np, thermal);
> > +	if (error) {
> > +		dev_err(&pdev->dev, "failed to parse device tree data: %d\n",
> > +			error);
> > +		goto err_disable_pclk;
> > +	}
> > +
> > +	thermal->chip->initialize(thermal->regs, thermal->tshut_polarity);
> > +
> > +	error =3D rockchip_thermal_register_sensor(pdev, thermal,
> > +						 &thermal->sensors[0],
> > +						 SENSOR_CPU);
> > +	if (error) {
> > +		dev_err(&pdev->dev,
> > +			"failed to register CPU thermal sensor: %d\n", error);
> > +		goto err_disable_pclk;
> > +	}
> > +
> > +	error =3D rockchip_thermal_register_sensor(pdev, thermal,
> > +						 &thermal->sensors[1],
> > +						 SENSOR_GPU);
> > +	if (error) {
> > +		dev_err(&pdev->dev,
> > +			"failed to register GPU thermal sensor: %d\n", error);
> > +		goto err_unregister_cpu_sensor;
> > +	}
> > +
> > +	error =3D devm_request_threaded_irq(&pdev->dev, irq, NULL,
> > +					  &rockchip_thermal_alarm_irq_thread,
> > +					  IRQF_ONESHOT,
> > +					  "rockchip_thermal", thermal);
> > +	if (error) {
> > +		dev_err(&pdev->dev,
> > +			"failed to request tsadc irq: %d\n", error);
> > +		goto err_unregister_gpu_sensor;
> > +	}
> > +
> > +	thermal->chip->control(thermal->regs, true);
> > +
> > +	for (i =3D 0; i < ARRAY_SIZE(thermal->sensors); i++)
> > +		rockchip_thermal_toggle_sensor(&thermal->sensors[i], true);
> > +
> > +	platform_set_drvdata(pdev, thermal);
> > +
> > +	return 0;
> > +
> > +err_unregister_gpu_sensor:
> > +	thermal_zone_of_sensor_unregister(&pdev->dev, thermal->sensors[1].tzd=
);
> > +err_unregister_cpu_sensor:
> > +	thermal_zone_of_sensor_unregister(&pdev->dev, thermal->sensors[0].tzd=
);
> > +err_disable_pclk:
> > +	clk_disable_unprepare(thermal->pclk);
> > +err_disable_clk:
> > +	clk_disable_unprepare(thermal->clk);
> > +
> > +	return error;
> > +}
> > +
> > +static int rockchip_thermal_remove(struct platform_device *pdev)
> > +{
> > +	struct rockchip_thermal_data *thermal =3D platform_get_drvdata(pdev);
> > +	int i;
> > +
> > +	for (i =3D 0; i < ARRAY_SIZE(thermal->sensors); i++) {
> > +		struct rockchip_thermal_sensor *sensor =3D &thermal->sensors[i];
> > +
> > +		rockchip_thermal_toggle_sensor(sensor, false);
> > +		thermal_zone_of_sensor_unregister(&pdev->dev, sensor->tzd);
> > +	}
> > +
> > +	thermal->chip->control(thermal->regs, false);
> > +
> > +	clk_disable_unprepare(thermal->pclk);
> > +	clk_disable_unprepare(thermal->clk);
> > +
> > +	return 0;
> > +}
> > +
> > +static int __maybe_unused rockchip_thermal_suspend(struct device *dev)
> > +{
> > +	struct platform_device *pdev =3D to_platform_device(dev);
> > +	struct rockchip_thermal_data *thermal =3D platform_get_drvdata(pdev);
> > +	int i;
> > +
> > +	for (i =3D 0; i < ARRAY_SIZE(thermal->sensors); i++)
> > +		rockchip_thermal_toggle_sensor(&thermal->sensors[i], false);
> > +
> > +	thermal->chip->control(thermal->regs, false);
> > +
> > +	clk_disable(thermal->pclk);
> > +	clk_disable(thermal->clk);
> > +
> > +	return 0;
> > +}
> > +
> > +static int __maybe_unused rockchip_thermal_resume(struct device *dev)
> > +{
> > +	struct platform_device *pdev =3D to_platform_device(dev);
> > +	struct rockchip_thermal_data *thermal =3D platform_get_drvdata(pdev);
> > +	int i;
> > +	int error;
> > +
> > +	error =3D clk_enable(thermal->clk);
> > +	if (error)
> > +		return error;
> > +
> > +	error =3D clk_enable(thermal->pclk);
> > +	if (error)
> > +		return error;
> > +
> > +	rockchip_thermal_reset_controller(thermal->reset);
> > +
> > +	thermal->chip->initialize(thermal->regs, thermal->tshut_polarity);
> > +
> > +	for (i =3D 0; i < ARRAY_SIZE(thermal->sensors); i++) {
> > +		enum sensor_id id =3D thermal->sensors[i].id;
> > +
> > +		thermal->chip->set_tshut_mode(id, thermal->regs,
> > +					      thermal->tshut_mode);
> > +		thermal->chip->set_tshut_temp(id, thermal->regs,
> > +					      thermal->tshut_temp);
> > +	}
> > +
> > +	thermal->chip->control(thermal->regs, true);
> > +
> > +	for (i =3D 0; i < ARRAY_SIZE(thermal->sensors); i++)
> > +		rockchip_thermal_toggle_sensor(&thermal->sensors[i], true);
> > +
> > +	return 0;
> > +}
> > +
> > +static SIMPLE_DEV_PM_OPS(rockchip_thermal_pm_ops,
> > +			 rockchip_thermal_suspend, rockchip_thermal_resume);
> > +
> > +static struct platform_driver rockchip_thermal_driver =3D {
> > +	.driver =3D {
> > +		.name =3D "rockchip-thermal",
> > +		.owner =3D THIS_MODULE,
> > +		.pm =3D &rockchip_thermal_pm_ops,
> > +		.of_match_table =3D of_rockchip_thermal_match,
> > +	},
> > +	.probe =3D rockchip_thermal_probe,
> > +	.remove =3D rockchip_thermal_remove,
> > +};
> > +
> > +module_platform_driver(rockchip_thermal_driver);
> > +
> > +MODULE_DESCRIPTION("ROCKCHIP THERMAL Driver");
> > +MODULE_AUTHOR("Rockchip, Inc.");
> > +MODULE_LICENSE("GPL v2");
> > +MODULE_ALIAS("platform:rockchip-thermal");
>=20
> --=20
> Best regards,
> Caesar
>=20
>=20

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUa1+8AAoJEMLUO4d9pOJWAHsH+wdCpdEsXnVeAi6C9psXibYY
7DZ3M9KAr+wFvn5HYDvsxtmOzKVxa1p3tEMwstKllEzGE6VOD3hcVkm/CsMY/ZDR
9f4k4rXDzK9YnN6DlybT0ZQcdtYbln6l9YmNWDfkuCKAv2oIQ9taIB0EZD2/2xmk
g1ccKowDf1leL9Bsr7D8hMh7TWu7/Y3mk32lu02wkB9VK4xC2WkEZcPz76BfrQEW
gJv8oBgsQmhC2x8skFftYYStlMuobpnvoHqN3e3bosFrclriKPYSixQEKKGvoEND
GXTkw9lvr+l0XAtMvSwBbwhQaBs3uGTKc/pPBXvofJO8sqtBiy4Zb7oYIyUOivk=
=XS04
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
