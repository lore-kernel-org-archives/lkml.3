Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbaJ0UQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 16:16:33 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:60383 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbaJ0UQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 16:16:20 -0400
Date: Mon, 27 Oct 2014 16:16:08 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, David Collins <collinsd@codeaurora.org>
Subject: Re: [PATCH v3] thermal: Add QPNP PMIC temperature alarm driver
Message-ID: <20141027201602.GC6088@developer>
References: <1412178817-20371-1-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UFHRwCdBEJvubb2X"
Content-Disposition: inline
In-Reply-To: <1412178817-20371-1-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UFHRwCdBEJvubb2X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Ivan

On Wed, Oct 01, 2014 at 06:53:37PM +0300, Ivan T. Ivanov wrote:
> Add support for the temperature alarm peripheral found inside
> Qualcomm plug-and-play (QPNP) PMIC chips.  The temperature alarm
> peripheral outputs a pulse on an interrupt line whenever the
> thermal over temperature stage value changes.  Implement an ISR
> to manage this interrupt.
>=20
> Register a thermal zone device in sysfs with multiple trip points
> corresponding to the physical threshold temperatures between over
> temperature stages.  The temperature reported by this thermal
> zone device should reflect the actual PMIC die temperature if an
> ADC is present on the given PMIC.  If no ADC is present, then the
> reported temperature should be estimated from the over
> temperature stage value.
>=20
> Send a notification to userspace via sysfs_notify() whenever the
> over temperature stage value changes.
>=20

Thanks for sending your driver.

> Cc: David Collins <collinsd@codeaurora.org>
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> ---
>=20
> Changes since v2:
>=20
> - Fixed review comments from Kiran Padwal
> - Files renamed from qpnp-* to qcom-spmi-* to be inline with
>   other PMIC sub-function drivers like qcom-spmi-iadc and
>   qcom-spmi-vadc.
>=20
> v2: http://www.gossamer-threads.com/lists/linux/kernel/2017366
>=20
>  .../bindings/thermal/qcom-spmi-temp-alarm.txt      |  26 ++
>  drivers/thermal/Kconfig                            |  13 +
>  drivers/thermal/Makefile                           |   1 +
>  drivers/thermal/qcom-spmi-temp-alarm.c             | 517 +++++++++++++++=
++++++
>  4 files changed, 557 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/thermal/qcom-spmi-t=
emp-alarm.txt
>  create mode 100644 drivers/thermal/qcom-spmi-temp-alarm.c
>=20
> diff --git a/Documentation/devicetree/bindings/thermal/qcom-spmi-temp-ala=
rm.txt b/Documentation/devicetree/bindings/thermal/qcom-spmi-temp-alarm.txt
> new file mode 100644
> index 0000000..afa908c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/thermal/qcom-spmi-temp-alarm.txt
> @@ -0,0 +1,26 @@
> +Qualcomm QPNP PMIC Temperature Alarm
> +
> +QPNP temperature alarm peripherals are found inside of Qualcomm PMIC chi=
ps
> +that utilize the Qualcomm SPMI implementation. These peripherals provide=
 an
> +interrupt signal and status register to identify high PMIC die temperatu=
re.
> +
> +Required properties:
> +- compatible:      Should contain "qcom,spmi-temp-alarm".
> +- reg:             Specifies the SPMI address and length of the controll=
er's
> +                   registers.
> +- interrupts:      PMIC temperature alarm interrupt
> +
> +Optional properties:
> +- io-channels:     Should contain IIO channel specifier for the ADC chan=
nel,
> +                   which report chip die temperature.
> +- io-channel-names: Should contain "thermal".
> +
> +Example:
> +
> +	thermal-alarm@2400 {
> +		compatible =3D "qcom,spmi-temp-alarm";
> +		reg =3D <0x2400 0x100>;
> +		interrupts =3D <0 0x24 0 IRQ_TYPE_EDGE_RISING>;
> +		io-channels =3D <&pm8941_vadc VADC_DIE_TEMP>;
> +		io-channel-names =3D "thermal";
> +	};
> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> index 693208e..6adb661 100644
> --- a/drivers/thermal/Kconfig
> +++ b/drivers/thermal/Kconfig
> @@ -248,4 +248,17 @@ depends on ARCH_STI && OF
>  source "drivers/thermal/st/Kconfig"
>  endmenu
> =20
> +config QCOM_SPMI_TEMP_ALARM
> +	tristate "Qualcomm SPMI PMIC Temperature Alarm"
> +	depends on OF && SPMI && IIO
> +	select REGMAP_SPMI
> +	help
> +	  This enables a thermal sysfs driver for Qualcomm plug-and-play (QPNP)
> +	  PMIC devices. It shows up in sysfs as a thermal zone with multiple
> +	  trip points. The temperature reported by the thermal zone reflects the
> +	  real time die temperature if an ADC is present or an estimate of the
> +	  temperature based upon the over temperature stage value. Enabling the
> +	  thermal zone device via the mode file results in shifting PMIC over
> +	  temperature shutdown control from hardware to software.
> +
>  endif
> diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
> index 31e232f..55f6c23 100644
> --- a/drivers/thermal/Makefile
> +++ b/drivers/thermal/Makefile
> @@ -33,3 +33,4 @@ obj-$(CONFIG_INTEL_SOC_DTS_THERMAL)	+=3D intel_soc_dts_=
thermal.o
>  obj-$(CONFIG_TI_SOC_THERMAL)	+=3D ti-soc-thermal/
>  obj-$(CONFIG_ACPI_INT3403_THERMAL)	+=3D int3403_thermal.o
>  obj-$(CONFIG_ST_THERMAL)	+=3D st/
> +obj-$(CONFIG_QCOM_SPMI_TEMP_ALARM)	+=3D qcom-spmi-temp-alarm.o
> diff --git a/drivers/thermal/qcom-spmi-temp-alarm.c b/drivers/thermal/qco=
m-spmi-temp-alarm.c
> new file mode 100644
> index 0000000..5ce0fef
> --- /dev/null
> +++ b/drivers/thermal/qcom-spmi-temp-alarm.c
> @@ -0,0 +1,517 @@
> +/*
> + * Copyright (c) 2011-2014, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/err.h>
> +#include <linux/iio/consumer.h>
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/platform_device.h>
> +#include <linux/regmap.h>
> +#include <linux/thermal.h>
> +
> +#define QPNP_TM_REG_TYPE		0x04
> +#define QPNP_TM_REG_SUBTYPE		0x05
> +#define QPNP_TM_REG_STATUS		0x08
> +#define QPNP_TM_REG_SHUTDOWN_CTRL1	0x40
> +#define QPNP_TM_REG_SHUTDOWN_CTRL2	0x42
> +#define QPNP_TM_REG_ALARM_CTRL		0x46
> +
> +#define QPNP_TM_TYPE			0x09
> +#define QPNP_TM_SUBTYPE			0x08
> +
> +#define STATUS_STAGE_MASK		0x03
> +
> +#define SHUTDOWN_CTRL1_OVERRIDE_STAGE3	0x80
> +#define SHUTDOWN_CTRL1_OVERRIDE_STAGE2	0x40
> +#define SHUTDOWN_CTRL1_THRESHOLD_MASK	0x03
> +
> +#define SHUTDOWN_CTRL2_CLEAR_STAGE3	0x80
> +#define SHUTDOWN_CTRL2_CLEAR_STAGE2	0x40
> +
> +#define ALARM_CTRL_FORCE_ENABLE		0x80
> +#define ALARM_CTRL_FOLLOW_HW_ENABLE	0x01
> +
> +/*
> + * Trip point values based on threshold control
> + * 0 =3D {105 C, 125 C, 145 C}
> + * 1 =3D {110 C, 130 C, 150 C}
> + * 2 =3D {115 C, 135 C, 155 C}
> + * 3 =3D {120 C, 140 C, 160 C}
> +*/
> +#define TEMP_STAGE_STEP			20000	/* Stage step: 20.000 C */
> +#define TEMP_STAGE_HYSTERESIS		2000
> +
> +#define TEMP_THRESH_MIN			105000	/* Threshold Min: 105 C */
> +#define TEMP_THRESH_STEP		5000	/* Threshold step: 5 C */
> +
> +#define THRESH_MIN			0
> +#define THRESH_MAX			3
> +
> +/* Trip points from most critical to least critical */
> +#define TRIP_STAGE3			0
> +#define TRIP_STAGE2			1
> +#define TRIP_STAGE1			2
> +#define TRIP_NUM			3
> +
> +/* Delay between TEMP_STAT IRQ going high and status value changing in m=
s */
> +#define READ_DELAY_MS			40
> +
> +/* Temperature in Milli Celsius reported during stage 0 if no ADC is pre=
sent */
> +#define DEFAULT_TEMP			37000
> +
> +struct qpnp_tm_chip {
> +	struct delayed_work		work;
> +	struct regmap			*map;
> +	struct device			*dev;
> +	struct thermal_zone_device	*tz_dev;
> +	enum thermal_device_mode	mode;
> +	long				temp;
> +	unsigned int			thresh;
> +	unsigned int			stage;
> +	unsigned int			prev_stage;
> +	unsigned int			base;
> +	struct iio_channel		*adc;
> +};
> +
> +static int qpnp_tm_read(struct qpnp_tm_chip *chip, u16 addr, u8 *data)
> +{
> +	unsigned int val;
> +	int ret;
> +
> +	ret =3D regmap_read(chip->map, chip->base + addr, &val);
> +	if (ret < 0)
> +		return ret;
> +
> +	*data =3D val;
> +	return 0;
> +}
> +
> +static int qpnp_tm_write(struct qpnp_tm_chip *chip, u16 addr, u8 data)
> +{
> +	return regmap_write(chip->map, chip->base + addr, data);
> +}
> +
> +static int qpnp_tm_shutdown_override(struct qpnp_tm_chip *chip, bool ena=
ble)
> +{
> +	u8 reg;
> +
> +	reg =3D chip->thresh & SHUTDOWN_CTRL1_THRESHOLD_MASK;
> +
> +	if (enable) {
> +		reg |=3D SHUTDOWN_CTRL1_OVERRIDE_STAGE2;
> +		reg |=3D SHUTDOWN_CTRL1_OVERRIDE_STAGE3;
> +	}
> +
> +	return qpnp_tm_write(chip, QPNP_TM_REG_SHUTDOWN_CTRL1, reg);
> +}
> +
> +/*
> + * This function updates the internal temp value based on the
> + * current thermal stage and threshold as well as the previous stage
> + */
> +static int qpnp_tm_update_temp_no_adc(struct qpnp_tm_chip *chip)
> +{
> +	unsigned int stage;
> +	int ret;
> +	u8 reg =3D 0;
> +
> +	ret =3D qpnp_tm_read(chip, QPNP_TM_REG_STATUS, &reg);
> +	if (ret < 0)
> +		return ret;
> +
> +	stage =3D reg & STATUS_STAGE_MASK;
> +
> +	if (stage > chip->stage) {
> +		/* increasing stage, use lower bound */
> +		chip->temp =3D (stage - 1) * TEMP_STAGE_STEP +
> +			     chip->thresh * TEMP_THRESH_STEP +
> +			     TEMP_STAGE_HYSTERESIS + TEMP_THRESH_MIN;
> +	} else if (stage < chip->stage) {
> +		/* decreasing stage, use upper bound */
> +		chip->temp =3D stage * TEMP_STAGE_STEP +
> +			     chip->thresh * TEMP_THRESH_STEP -
> +			     TEMP_STAGE_HYSTERESIS + TEMP_THRESH_MIN;
> +	}
> +
> +	chip->stage =3D stage;
> +
> +	return 0;
> +}
> +
> +static int qpnp_tz_get_temp(struct thermal_zone_device *thermal,
> +			   unsigned long *temp)
> +{
> +	struct qpnp_tm_chip *chip =3D thermal->devdata;
> +	int ret, mili_celsius;
> +
> +	if (!temp)
> +		return -EINVAL;
> +
> +	if (IS_ERR(chip->adc)) {
> +		ret =3D qpnp_tm_update_temp_no_adc(chip);
> +		if (ret < 0)
> +			return ret;
> +	} else {
> +		ret =3D iio_read_channel_processed(chip->adc, &mili_celsius);
> +		if (ret < 0)
> +			return ret;
> +
> +		chip->temp =3D mili_celsius;
> +	}
> +
> +	*temp =3D chip->temp < 0 ? 0 : chip->temp;
> +
> +	return 0;
> +}
> +
> +static int qpnp_tz_get_mode(struct thermal_zone_device *thermal,
> +			    enum thermal_device_mode *mode)
> +{
> +	struct qpnp_tm_chip *chip =3D thermal->devdata;
> +
> +	if (!mode)
> +		return -EINVAL;
> +
> +	*mode =3D chip->mode;
> +
> +	return 0;
> +}
> +
> +static int qpnp_tz_set_mode(struct thermal_zone_device *thermal,
> +			    enum thermal_device_mode mode)
> +{
> +	struct qpnp_tm_chip *chip =3D thermal->devdata;
> +	int ret;
> +
> +	if (mode =3D=3D chip->mode)
> +		return 0;
> +
> +	if (mode =3D=3D THERMAL_DEVICE_ENABLED)
> +		ret =3D qpnp_tm_shutdown_override(chip, true);
> +	else
> +		ret =3D qpnp_tm_shutdown_override(chip, false);


Can you please elaborate a little more why you need to switch these when
mode changes?

> +
> +	chip->mode =3D mode;
> +
> +	return ret;
> +}
> +
> +static int qpnp_tz_get_trip_type(struct thermal_zone_device *thermal, in=
t trip,
> +			       enum thermal_trip_type *type)
> +{
> +	if (trip < 0 || !type)
> +		return -EINVAL;
> +
> +	switch (trip) {
> +	case TRIP_STAGE3:
> +		*type =3D THERMAL_TRIP_CRITICAL;
> +		break;
> +	case TRIP_STAGE2:
> +		*type =3D THERMAL_TRIP_HOT;
> +		break;
> +	case TRIP_STAGE1:
> +		*type =3D THERMAL_TRIP_HOT;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int qpnp_tz_get_trip_temp(struct thermal_zone_device *thermal, in=
t trip,
> +				unsigned long *temp)
> +{
> +	struct qpnp_tm_chip *chip =3D thermal->devdata;
> +	int thresh_temp;
> +
> +	if (trip < 0 || !temp)
> +		return -EINVAL;
> +
> +	thresh_temp =3D chip->thresh * TEMP_THRESH_STEP + TEMP_THRESH_MIN;
> +
> +	switch (trip) {
> +	case TRIP_STAGE3:
> +		thresh_temp +=3D 2 * TEMP_STAGE_STEP;
> +		break;
> +	case TRIP_STAGE2:
> +		thresh_temp +=3D TEMP_STAGE_STEP;
> +		break;
> +	case TRIP_STAGE1:
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	*temp =3D thresh_temp;
> +
> +	return 0;
> +}
> +
> +static int qpnp_tz_get_crit_temp(struct thermal_zone_device *thermal,
> +				 unsigned long *temp)
> +{
> +	struct qpnp_tm_chip *chip =3D thermal->devdata;
> +
> +	if (!temp)
> +		return -EINVAL;
> +
> +	*temp =3D chip->thresh * TEMP_THRESH_STEP + TEMP_THRESH_MIN +
> +		2 * TEMP_STAGE_STEP;
> +
> +	return 0;
> +}
> +
> +static irqreturn_t qpnp_tm_isr(int irq, void *data)
> +{
> +	struct qpnp_tm_chip *chip =3D data;
> +
> +	schedule_delayed_work(&chip->work, msecs_to_jiffies(READ_DELAY_MS) + 1);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static void qpnp_tm_work(struct work_struct *work)
> +{
> +	struct delayed_work *dwork;
> +	struct qpnp_tm_chip *chip;
> +	int ret, mili_celsius;
> +	u8 reg;
> +
> +	dwork =3D container_of(work, struct delayed_work, work);
> +	chip =3D container_of(dwork, struct qpnp_tm_chip, work);
> +
> +	if (IS_ERR(chip->adc)) {
> +		ret =3D qpnp_tm_update_temp_no_adc(chip);
> +		if (ret < 0)
> +			return;
> +	} else {
> +		ret =3D qpnp_tm_read(chip, QPNP_TM_REG_STATUS, &reg);
> +		if (ret < 0)
> +			return;
> +
> +		chip->stage =3D reg & STATUS_STAGE_MASK;
> +
> +		ret =3D iio_read_channel_processed(chip->adc, &mili_celsius);
> +		if (ret < 0)
> +			return;
> +
> +		chip->temp =3D mili_celsius;
> +	}
> +
> +	if (chip->stage !=3D chip->prev_stage) {
> +		chip->prev_stage =3D chip->stage;
> +
> +		dev_warn(chip->dev, "Thermal alarm stage %u, threshold %u, temp %ld mC=
\n",
> +			 chip->stage, chip->thresh, chip->temp);
> +
> +		thermal_zone_device_update(chip->tz_dev);
> +
> +		/* Notify user space */
> +		sysfs_notify(&chip->tz_dev->device.kobj, NULL, "type");
> +	}
> +}
> +
> +/*
> + * This function initializes the internal temp value based on only the
> + * current thermal stage and threshold. Setup threshold control and
> + * disable shutdown override.
> + */
> +static int qpnp_tm_init(struct qpnp_tm_chip *chip)
> +{
> +	int ret;
> +	u8 reg;
> +
> +	chip->thresh =3D THRESH_MIN;
> +	chip->temp =3D DEFAULT_TEMP;
> +
> +	ret =3D qpnp_tm_read(chip, QPNP_TM_REG_STATUS, &reg);
> +	if (ret < 0)
> +		return ret;
> +
> +	chip->stage =3D reg & STATUS_STAGE_MASK;
> +
> +	if (chip->stage)
> +		chip->temp =3D chip->thresh * TEMP_THRESH_STEP +
> +			     (chip->stage - 1) * TEMP_STAGE_STEP +
> +			     TEMP_THRESH_MIN;
> +
> +	/*
> +	 * Set threshold and disable software override of stage 2 and 3
> +	 * shutdowns.
> +	 */
> +	reg =3D chip->thresh & SHUTDOWN_CTRL1_THRESHOLD_MASK;
> +	ret =3D qpnp_tm_write(chip, QPNP_TM_REG_SHUTDOWN_CTRL1, reg);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Enable the thermal alarm PMIC module in always-on mode. */
> +	reg =3D ALARM_CTRL_FORCE_ENABLE;
> +	ret =3D qpnp_tm_write(chip, QPNP_TM_REG_ALARM_CTRL, reg);
> +
> +	return ret;
> +}
> +
> +static struct thermal_zone_device_ops qpnp_tz_ops =3D {
> +	.get_temp	=3D qpnp_tz_get_temp,
> +	.get_mode	=3D qpnp_tz_get_mode,
> +	.set_mode	=3D qpnp_tz_set_mode,
> +	.get_trip_type	=3D qpnp_tz_get_trip_type,
> +	.get_trip_temp	=3D qpnp_tz_get_trip_temp,
> +	.get_crit_temp	=3D qpnp_tz_get_crit_temp,
> +};
> +
> +static int qpnp_tm_probe(struct platform_device *pdev)
> +{
> +	struct qpnp_tm_chip *chip;
> +	struct device_node *node;
> +	u8 type, subtype;
> +	int ret, irq, res[2];
> +
> +	node =3D pdev->dev.of_node;
> +
> +	chip =3D devm_kzalloc(&pdev->dev, sizeof(*chip), GFP_KERNEL);
> +	if (!chip)
> +		return -ENOMEM;
> +
> +	dev_set_drvdata(&pdev->dev, chip);
> +
> +	chip->dev =3D &pdev->dev;
> +	INIT_DELAYED_WORK(&chip->work, qpnp_tm_work);
> +
> +	chip->map =3D dev_get_regmap(chip->dev->parent, NULL);
> +	if (!chip->map)
> +		return -ENXIO;
> +
> +	ret =3D of_property_read_u32_array(node, "reg", res, 2);
> +	if (ret < 0)
> +		return ret;
> +
> +	chip->base =3D res[0];
> +
> +	ret =3D qpnp_tm_read(chip, QPNP_TM_REG_TYPE, &type);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "could not read type\n");
> +		return ret;
> +	}
> +
> +	ret =3D qpnp_tm_read(chip, QPNP_TM_REG_SUBTYPE, &subtype);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "could not read subtype\n");
> +		return ret;
> +	}
> +
> +	if (type !=3D QPNP_TM_TYPE || subtype !=3D QPNP_TM_SUBTYPE) {
> +		dev_err(&pdev->dev, "invalid type 0x%02x or subtype 0x%02x\n",
> +			type, subtype);
> +		return -ENODEV;
> +	}
> +
> +	irq =3D platform_get_irq(pdev, 0);
> +	if (irq < 0)
> +		return irq;
> +
> +	chip->adc =3D iio_channel_get(chip->dev, "thermal");
> +	if (PTR_ERR(chip->adc) =3D=3D -EPROBE_DEFER)
> +		return PTR_ERR(chip->adc);
> +
> +	ret =3D qpnp_tm_init(chip);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "init failed\n");
> +		return ret;
> +	}
> +
> +	/* Start in HW control. Switch to SW control when user changes mode. */
> +	chip->mode =3D THERMAL_DEVICE_DISABLED;
> +
> +	chip->tz_dev =3D thermal_zone_device_register(node->name, TRIP_NUM, 0,
> +						    chip, &qpnp_tz_ops, NULL,

Have you considered using of-thermal instead of doing your own specific the=
rmal
zone registration? Having a glance look in this driver, most of the
operation are covered by of-thermal. Ahy concerns using of-thermal in
your case?

> +						    0, 0);
> +	if (IS_ERR(chip->tz_dev)) {
> +		dev_err(&pdev->dev, "TZ registration failed\n");
> +		return PTR_ERR(chip->tz_dev);
> +	}
> +
> +	ret =3D devm_request_irq(chip->dev, irq, qpnp_tm_isr, 0, node->name,
> +			      chip);

The IRQ handling would probably be kept in your driver.

> +	if (ret < 0)
> +		thermal_zone_device_unregister(chip->tz_dev);
> +
> +	return ret;
> +}
> +
> +static int qpnp_tm_remove(struct platform_device *pdev)
> +{
> +	struct qpnp_tm_chip *chip =3D dev_get_drvdata(&pdev->dev);
> +
> +	cancel_delayed_work_sync(&chip->work);
> +	thermal_zone_device_unregister(chip->tz_dev);
> +	qpnp_tm_shutdown_override(chip, false);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int qpnp_tm_suspend(struct device *dev)
> +{
> +	struct qpnp_tm_chip *chip =3D dev_get_drvdata(dev);
> +
> +	/* Clear override bits in suspend to allow hardware control */
> +	qpnp_tm_shutdown_override(chip, false);
> +
> +	return 0;
> +}
> +
> +static int qpnp_tm_resume(struct device *dev)
> +{
> +	struct qpnp_tm_chip *chip =3D dev_get_drvdata(dev);
> +
> +	/* Override hardware actions so software can control */
> +	if (chip->mode =3D=3D THERMAL_DEVICE_ENABLED)
> +		qpnp_tm_shutdown_override(chip, true);
> +
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops qpnp_tm_pm_ops =3D {
> +	SET_SYSTEM_SLEEP_PM_OPS(qpnp_tm_suspend, qpnp_tm_resume)
> +};
> +
> +#define QPNP_TM_PM_OPS	(&qpnp_tm_pm_ops)
> +#else
> +#define QPNP_TM_PM_OPS	NULL
> +#endif
> +
> +static const struct of_device_id qpnp_tm_match_table[] =3D {
> +	{ .compatible =3D "qcom,spmi-temp-alarm" },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, qpnp_tm_match_table);
> +
> +static struct platform_driver qpnp_tm_driver =3D {
> +	.driver =3D {
> +		.name =3D "spmi-temp-alarm",
> +		.of_match_table =3D qpnp_tm_match_table,
> +		.pm =3D QPNP_TM_PM_OPS,
> +	},
> +	.probe  =3D qpnp_tm_probe,
> +	.remove =3D qpnp_tm_remove,
> +};
> +module_platform_driver(qpnp_tm_driver);
> +
> +MODULE_ALIAS("platform:spmi-temp-alarm");
> +MODULE_DESCRIPTION("QPNP PMIC Temperature Alarm driver");
> +MODULE_LICENSE("GPL v2");
> --=20
> 1.9.1
>=20

--UFHRwCdBEJvubb2X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUTqf5AAoJEMLUO4d9pOJWns0H/RJE1PCe7CvrXKzuv3WJr7cg
MuDtjRJV+g4/NGGT8ik6Ws5B/huzVcw3IZhjkkmQKAq/GF0AixBZwc+So5tTes8e
dUiQv4SvpKvdgNCqr7z0U0RlGEK5Lgtv9YBKnhktIksm9dRTzYk+Yd9DVmeWzyCc
11GbP66konrp1IcdLmXZ2NEbbWEWvIcahVJov6JWUSqoIwqTGQn3X38qCIdkmksY
scQ5R7HQ9RqG4W2aJkjFlIb6E83jhUBKyIuJSkYuLIQ6zQZbR96/Qog/9fGp7T5s
Bbmom8nlmujBdlxayKgJCRV5GoH3wgLHbAdTyFdzHBya9LUY/4wooNb5Gn6+2+M=
=IsEd
-----END PGP SIGNATURE-----

--UFHRwCdBEJvubb2X--
