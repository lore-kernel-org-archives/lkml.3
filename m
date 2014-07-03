Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964811AbaGCPZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:25:40 -0400
Received: from mail.kernel.org ([198.145.19.201]:38766 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988AbaGCPZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:25:38 -0400
Date: Thu, 3 Jul 2014 17:25:29 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Jenny TC <jenny.tc@intel.com>
Cc: linux-kernel@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Pallala Ramakrishna <ramakrishna.pallala@intel.com>
Subject: Re: [PATCH 4/4] power_supply: bq24261 charger driver
Message-ID: <20140703152528.GB23309@earth.universe>
References: <1404122155-12369-1-git-send-email-jenny.tc@intel.com>
 <1404122155-12369-5-git-send-email-jenny.tc@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="i9LlY+UWpKt15+FH"
Content-Disposition: inline
In-Reply-To: <1404122155-12369-5-git-send-email-jenny.tc@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i9LlY+UWpKt15+FH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jun 30, 2014 at 03:25:55PM +0530, Jenny TC wrote:
> This patch introduces BQ24261 charger driver. The driver makes use of pow=
er
> supply charging driver to setup charging. So the driver does hardware
> abstraction and handles h/w specific corner cases. The charging logic res=
ides
> with power supply charging driver

I just found one thing. See below:

> Signed-off-by: Jenny TC <jenny.tc@intel.com>
> ---
>  drivers/power/Kconfig                 |   10 +
>  drivers/power/Makefile                |    1 +
>  drivers/power/bq24261_charger.c       | 1351 +++++++++++++++++++++++++++=
++++++
>  include/linux/power/bq24261-charger.h |   25 +
>  4 files changed, 1387 insertions(+)
>  create mode 100644 drivers/power/bq24261_charger.c
>  create mode 100644 include/linux/power/bq24261-charger.h
>=20
> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
> index 54a0321..4ff080c 100644
> --- a/drivers/power/Kconfig
> +++ b/drivers/power/Kconfig
> @@ -411,6 +411,16 @@ config BATTERY_GOLDFISH
>  	  Say Y to enable support for the battery and AC power in the
>  	  Goldfish emulator.
> =20
> +config CHARGER_BQ24261
> +	tristate "BQ24261 charger driver"
> +	select POWER_SUPPLY_CHARGER
> +	depends on I2C
> +	help
> +	  Say Y to include support for BQ24261 Charger driver. This driver
> +	  makes use of power supply charging driver. So the driver gives
> +	  the charger hardware abstraction only. Charging logic is abstracted
> +	  in the power supply charging driver.
> +
>  source "drivers/power/reset/Kconfig"
> =20
>  endif # POWER_SUPPLY
> diff --git a/drivers/power/Makefile b/drivers/power/Makefile
> index 77535fd..a6e9897 100644
> --- a/drivers/power/Makefile
> +++ b/drivers/power/Makefile
> @@ -59,4 +59,5 @@ obj-$(CONFIG_CHARGER_BQ24735)	+=3D bq24735-charger.o
>  obj-$(CONFIG_POWER_AVS)		+=3D avs/
>  obj-$(CONFIG_CHARGER_SMB347)	+=3D smb347-charger.o
>  obj-$(CONFIG_CHARGER_TPS65090)	+=3D tps65090-charger.o
> +obj-$(CONFIG_CHARGER_BQ24261)	+=3D bq24261_charger.o
>  obj-$(CONFIG_POWER_RESET)	+=3D reset/
> diff --git a/drivers/power/bq24261_charger.c b/drivers/power/bq24261_char=
ger.c
> new file mode 100644
> index 0000000..c21ea04
> --- /dev/null
> +++ b/drivers/power/bq24261_charger.c
> @@ -0,0 +1,1351 @@
> +/*
> + * bq24261-charger.c - BQ24261 Charger I2C client driver
> + *
> + * Copyright (C) 2011 Intel Corporation
> + *
> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the GNU
> + * General Public License for more details.
> + *
> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~
> + * Author: Jenny TC <jenny.tc@intel.com>
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/device.h>
> +#include <linux/err.h>
> +#include <linux/i2c.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/power_supply.h>
> +#include <linux/power/power_supply_charger.h>
> +#include <linux/power/bq24261-charger.h>
> +#include <linux/sched.h>
> +#include <linux/seq_file.h>
> +#include <linux/slab.h>
> +#include <linux/usb/otg.h>
> +#include <linux/version.h>
> +
> +
> +#define DEV_NAME "bq24261_charger"
> +#define MODEL_NAME_SIZE 8
> +
> +#define EXCEPTION_MONITOR_DELAY (60 * HZ)
> +#define WDT_RESET_DELAY (15 * HZ)
> +
> +/* BQ24261 registers */
> +#define BQ24261_STAT_CTRL0_ADDR		0x00
> +#define BQ24261_CTRL_ADDR		0x01
> +#define BQ24261_BATT_VOL_CTRL_ADDR	0x02
> +#define BQ24261_VENDOR_REV_ADDR		0x03
> +#define BQ24261_TERM_FCC_ADDR		0x04
> +#define BQ24261_VINDPM_STAT_ADDR	0x05
> +#define BQ24261_ST_NTC_MON_ADDR		0x06
> +
> +#define BQ24261_RESET_MASK		(0x01 << 7)
> +#define BQ24261_RESET_ENABLE		(0x01 << 7)
> +
> +#define BQ24261_FAULT_MASK		0x07
> +#define BQ24261_STAT_MASK		(0x03 << 4)
> +#define BQ24261_BOOST_MASK		(0x01 << 6)
> +#define BQ24261_TMR_RST_MASK		(0x01 << 7)
> +#define BQ24261_TMR_RST			(0x01 << 7)
> +
> +#define BQ24261_ENABLE_BOOST		(0x01 << 6)
> +
> +#define BQ24261_VOVP			0x01
> +#define BQ24261_LOW_SUPPLY		0x02
> +#define BQ24261_THERMAL_SHUTDOWN	0x03
> +#define BQ24261_BATT_TEMP_FAULT		0x04
> +#define BQ24261_TIMER_FAULT		0x05
> +#define BQ24261_BATT_OVP		0x06
> +#define BQ24261_NO_BATTERY		0x07
> +#define BQ24261_STAT_READY		0x00
> +
> +#define BQ24261_STAT_CHRG_PRGRSS	(0x01 << 4)
> +#define BQ24261_STAT_CHRG_DONE		(0x02 << 4)
> +#define BQ24261_STAT_FAULT		(0x03 << 4)
> +
> +#define BQ24261_CE_MASK			(0x01 << 1)
> +#define BQ24261_CE_DISABLE		(0x01 << 1)
> +
> +#define BQ24261_HZ_MASK			(0x01)
> +#define BQ24261_HZ_ENABLE		(0x01)
> +
> +#define BQ24261_ICHRG_MASK		(0x1F << 3)
> +#define BQ24261_MIN_CC 500 /* 500mA */
> +#define BQ24261_MAX_CC	3000 /* 3A */
> +
> +#define BQ24261_ITERM_MASK		(0x03)
> +#define BQ24261_MIN_ITERM 50 /* 50 mA */
> +#define BQ24261_MAX_ITERM 300 /* 300mA */
> +
> +#define BQ24261_VBREG_MASK		(0x3F << 2)
> +
> +#define BQ24261_INLMT_MASK		(0x03 << 4)
> +#define BQ24261_INLMT_100		0x00
> +#define BQ24261_INLMT_150		(0x01 << 4)
> +#define BQ24261_INLMT_500		(0x02 << 4)
> +#define BQ24261_INLMT_900		(0x03 << 4)
> +#define BQ24261_INLMT_1500		(0x04 << 4)
> +#define BQ24261_INLMT_2500		(0x06 << 4)
> +
> +#define BQ24261_TE_MASK			(0x01 << 2)
> +#define BQ24261_TE_ENABLE		(0x01 << 2)
> +#define BQ24261_STAT_ENABLE_MASK	(0x01 << 3)
> +#define BQ24261_STAT_ENABLE		(0x01 << 3)
> +
> +#define BQ24261_VENDOR_MASK		(0x07 << 5)
> +#define BQ24261_VENDOR			(0x02 << 5)
> +#define BQ24261_REV_MASK		(0x07)
> +#define BQ24261_REV			(0x02)
> +#define BQ24261_PG2_3_REV		(0x06)
> +#define BQ24260_REV			(0x01)
> +
> +#define BQ24261_TS_MASK			(0x01 << 3)
> +#define BQ24261_TS_ENABLED		(0x01 << 3)
> +#define BQ24261_BOOST_ILIM_MASK		(0x01 << 4)
> +#define BQ24261_BOOST_ILIM_500ma	(0x0)
> +#define BQ24261_BOOST_ILIM_1A		(0x01 << 4)
> +
> +#define BQ24261_SAFETY_TIMER_MASK	(0x03 << 5)
> +#define BQ24261_SAFETY_TIMER_40MIN	0x00
> +#define BQ24261_SAFETY_TIMER_6HR	(0x01 << 5)
> +#define BQ24261_SAFETY_TIMER_9HR	(0x02 << 5)
> +#define BQ24261_SAFETY_TIMER_DISABLED	(0x03 << 5)
> +
> +/* 1% above voltage max design to report over voltage */
> +#define BQ24261_OVP_MULTIPLIER			1010
> +#define BQ24261_OVP_RECOVER_MULTIPLIER		990
> +#define BQ24261_DEF_BAT_VOLT_MAX_DESIGN		4200000
> +
> +/* Settings for Voltage / DPPM Register (05) */
> +#define BQ24261_VBATT_LEVEL1		3700000
> +#define BQ24261_VBATT_LEVEL2		3960000
> +#define BQ24261_VINDPM_MASK		(0x07)
> +#define BQ24261_VINDPM_320MV		(0x01 << 2)
> +#define BQ24261_VINDPM_160MV		(0x01 << 1)
> +#define BQ24261_VINDPM_80MV		(0x01 << 0)
> +#define BQ24261_CD_STATUS_MASK		(0x01 << 3)
> +#define BQ24261_DPM_EN_MASK		(0x01 << 4)
> +#define BQ24261_DPM_EN_FORCE		(0x01 << 4)
> +#define BQ24261_LOW_CHG_MASK		(0x01 << 5)
> +#define BQ24261_LOW_CHG_EN		(0x01 << 5)
> +#define BQ24261_LOW_CHG_DIS		(~BQ24261_LOW_CHG_EN)
> +#define BQ24261_DPM_STAT_MASK		(0x01 << 6)
> +#define BQ24261_MINSYS_STAT_MASK	(0x01 << 7)
> +
> +#define BQ24261_MIN_CC			500
> +
> +static u16 bq24261_sfty_tmr[][2] =3D {
> +	{0, BQ24261_SAFETY_TIMER_DISABLED}
> +	,
> +	{40, BQ24261_SAFETY_TIMER_40MIN}
> +	,
> +	{360, BQ24261_SAFETY_TIMER_6HR}
> +	,
> +	{540, BQ24261_SAFETY_TIMER_9HR}
> +	,
> +};
> +
> +
> +static u16 bq24261_inlmt[][2] =3D {
> +	{100, BQ24261_INLMT_100}
> +	,
> +	{150, BQ24261_INLMT_150}
> +	,
> +	{500, BQ24261_INLMT_500}
> +	,
> +	{900, BQ24261_INLMT_900}
> +	,
> +	{1500, BQ24261_INLMT_1500}
> +	,
> +	{2500, BQ24261_INLMT_2500}
> +	,
> +};
> +
> +#define BQ24261_MIN_CV_mV 3500
> +#define BQ24261_MAX_CV_mV 4440
> +
> +static enum power_supply_property bq24261_usb_props[] =3D {
> +	POWER_SUPPLY_PROP_PRESENT,
> +	POWER_SUPPLY_PROP_ONLINE,
> +	POWER_SUPPLY_PROP_TYPE,
> +	POWER_SUPPLY_PROP_HEALTH,
> +	POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT_MAX,
> +	POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE_MAX,
> +	POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT,
> +	POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE,
> +	POWER_SUPPLY_PROP_INPUT_CURRENT_LIMIT,
> +	POWER_SUPPLY_PROP_CHARGE_TERM_CURRENT,
> +	POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT,
> +	POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT_MAX,
> +	POWER_SUPPLY_PROP_MODEL_NAME,
> +	POWER_SUPPLY_PROP_MANUFACTURER,
> +	POWER_SUPPLY_PROP_TEMP_MAX,
> +	POWER_SUPPLY_PROP_TEMP_MIN,
> +};
> +
> +enum bq24261_chrgr_stat {
> +	BQ24261_CHRGR_STAT_UNKNOWN,
> +	BQ24261_CHRGR_STAT_READY,
> +	BQ24261_CHRGR_STAT_CHARGING,
> +	BQ24261_CHRGR_STAT_BAT_FULL,
> +	BQ24261_CHRGR_STAT_FAULT,
> +};
> +
> +struct bq24261_charger {
> +
> +	struct mutex lock;
> +	struct i2c_client *client;
> +	struct bq24261_plat_data *pdata;
> +	struct power_supply psy_usb;
> +	struct power_supply_charger psyc_usb;
> +	struct delayed_work notify_work;
> +	struct delayed_work low_supply_fault_work;
> +	struct delayed_work exception_mon_work;
> +	struct list_head irq_queue;
> +	wait_queue_head_t wait_ready;
> +
> +	int chrgr_health;
> +	int bat_health;
> +	int cc;
> +	int cv;
> +	int inlmt;
> +	int max_cc;
> +	int max_cv;
> +	int iterm;
> +	int cable_type;
> +	int cntl_state;
> +	int max_temp;
> +	int min_temp;
> +	enum bq24261_chrgr_stat chrgr_stat;
> +	bool online;
> +	bool present;
> +	bool is_charging_enabled;
> +	bool is_charger_enabled;
> +	bool is_vsys_on;
> +	bool is_hw_chrg_term;
> +	char model_name[MODEL_NAME_SIZE];
> +};
> +
> +enum bq2426x_model_num {
> +	BQ24260 =3D 0,
> +	BQ24261,
> +};
> +
> +struct bq2426x_model {
> +	char model_name[MODEL_NAME_SIZE];
> +	enum bq2426x_model_num model;
> +};
> +
> +static struct bq2426x_model bq24261_model_name[] =3D {
> +	{ "bq24260", BQ24260 },
> +	{ "bq24261", BQ24261 },
> +};
> +
> +struct i2c_client *bq24261_client;
> +static inline int get_battery_voltage(int *volt);
> +static int bq24261_handle_irq(struct bq24261_charger *chip, u8 stat_reg);
> +static inline int bq24261_set_iterm(struct bq24261_charger *chip, int it=
erm);
> +static inline int bq24261_enable_hw_charge_term(struct bq24261_charger *=
chip,
> +		bool val);
> +
> +enum power_supply_type get_power_supply_type(
> +		unsigned long cable)
> +{
> +	switch (cable) {
> +
> +	case PSY_CHARGER_CABLE_TYPE_USB_DCP:
> +		return POWER_SUPPLY_TYPE_USB_DCP;
> +	case PSY_CHARGER_CABLE_TYPE_USB_CDP:
> +		return POWER_SUPPLY_TYPE_USB_CDP;
> +	case PSY_CHARGER_CABLE_TYPE_USB_ACA:
> +	case PSY_CHARGER_CABLE_TYPE_ACA_DOCK:
> +		return POWER_SUPPLY_TYPE_USB_ACA;
> +	case PSY_CHARGER_CABLE_TYPE_AC:
> +		return POWER_SUPPLY_TYPE_MAINS;
> +	case PSY_CHARGER_CABLE_TYPE_NONE:
> +	case PSY_CHARGER_CABLE_TYPE_USB_SDP:
> +		return POWER_SUPPLY_TYPE_USB;
> +	default:
> +		return POWER_SUPPLY_TYPE_UNKNOWN;
> +	}
> +
> +	return POWER_SUPPLY_TYPE_USB;
> +}
> +
> +static u8 lookup_regval(u16 tbl[][2], size_t size, u16 in_val)
> +{
> +	int i;
> +
> +	for (i =3D 1; i < size; ++i)
> +		if (in_val < tbl[i][0])
> +			break;
> +
> +	return tbl[i - 1][1];
> +}
> +
> +static u8 bq24261_cc_to_reg(int cc)
> +{
> +	cc =3D clamp_t(int, cc, BQ24261_MIN_CC, BQ24261_MAX_CC);
> +	cc =3D cc - BQ24261_MIN_CC;
> +	return  (cc / 100) << 3;
> +}
> +
> +static u8 bq24261_cv_to_reg(int cv)
> +{
> +	cv =3D clamp_t(int, cv, BQ24261_MIN_CV_mV, BQ24261_MAX_CV_mV);
> +	cv =3D cv - BQ24261_MIN_CV_mV;
> +	return	(cv / 20) << 2;
> +}
> +
> +static u8 bq24261_inlmt_to_reg(int inlmt)
> +{
> +	return lookup_regval(bq24261_inlmt, ARRAY_SIZE(bq24261_inlmt), inlmt);
> +}
> +
> +static u8 bq24261_iterm_to_reg(int iterm)
> +{
> +	iterm =3D clamp_t(int, iterm, BQ24261_MIN_ITERM,  BQ24261_MAX_ITERM);
> +	iterm =3D iterm - BQ24261_MIN_ITERM;
> +
> +	return   iterm/50;
> +}
> +
> +static u8 bq24261_sfty_tmr_to_reg(int tmr)
> +{
> +	return lookup_regval(bq24261_sfty_tmr,
> +			ARRAY_SIZE(bq24261_sfty_tmr), tmr);
> +}
> +
> +static inline int bq24261_read_reg(struct i2c_client *client, u8 reg)
> +{
> +	int ret;
> +
> +	ret =3D i2c_smbus_read_byte_data(client, reg);
> +	if (ret < 0)
> +		dev_err(&client->dev, "Error(%d) in reading reg %d\n", ret,
> +			reg);
> +
> +	return ret;
> +}
> +
> +static inline int bq24261_write_reg(struct i2c_client *client, u8 reg, u=
8 data)
> +{
> +	int ret;
> +
> +	ret =3D i2c_smbus_write_byte_data(client, reg, data);
> +	if (ret < 0)
> +		dev_err(&client->dev, "Error(%d) in writing %d to reg %d\n",
> +			ret, data, reg);
> +
> +	return ret;
> +}
> +
> +static inline int bq24261_read_modify_reg(struct i2c_client *client, u8 =
reg,
> +					  u8 mask, u8 val)
> +{
> +	int ret;
> +
> +	ret =3D bq24261_read_reg(client, reg);
> +	if (ret < 0)
> +		return ret;
> +	ret =3D (ret & ~mask) | (mask & val);
> +	return bq24261_write_reg(client, reg, ret);
> +}
> +
> +static inline int bq24261_tmr_ntc_init(struct bq24261_charger *chip)
> +{
> +	u8 reg_val;
> +	int ret;
> +
> +	reg_val =3D bq24261_sfty_tmr_to_reg(chip->pdata->safety_timer);
> +
> +	if (chip->pdata->is_ts_enabled)
> +		reg_val |=3D BQ24261_TS_ENABLED;
> +
> +	ret =3D bq24261_read_modify_reg(chip->client, BQ24261_ST_NTC_MON_ADDR,
> +			BQ24261_TS_MASK|BQ24261_SAFETY_TIMER_MASK|
> +			BQ24261_BOOST_ILIM_MASK, reg_val);
> +
> +	return ret;
> +}
> +
> +static inline int bq24261_enable_charging(
> +	struct bq24261_charger *chip, bool val)
> +{
> +	int ret;
> +	u8 reg_val;
> +	bool is_ready;
> +
> +	ret =3D bq24261_read_reg(chip->client,
> +					BQ24261_STAT_CTRL0_ADDR);
> +	if (ret < 0) {
> +		dev_err(&chip->client->dev,
> +			"Error(%d) in reading BQ24261_STAT_CTRL0_ADDR\n", ret);
> +	}
> +
> +	is_ready =3D  (ret & BQ24261_STAT_MASK) !=3D BQ24261_STAT_FAULT;
> +
> +	/* If status is fault, wait for READY before enabling the charging */
> +
> +	if (!is_ready && val) {
> +		ret =3D wait_event_timeout(chip->wait_ready,
> +			(chip->chrgr_stat =3D=3D BQ24261_CHRGR_STAT_READY),
> +				HZ);
> +		dev_info(&chip->client->dev,
> +			"chrgr_stat=3D%x\n", chip->chrgr_stat);
> +		if (ret =3D=3D 0) {
> +			dev_err(&chip->client->dev,
> +				"Waiting for Charger Ready Failed. Enabling charging anyway\n");
> +		}
> +	}
> +
> +	if (val) {
> +		reg_val =3D (~BQ24261_CE_DISABLE & BQ24261_CE_MASK);
> +		if (chip->is_hw_chrg_term)
> +			reg_val |=3D BQ24261_TE_ENABLE;
> +	} else {
> +		reg_val =3D BQ24261_CE_DISABLE;
> +	}
> +
> +	reg_val |=3D  BQ24261_STAT_ENABLE;
> +
> +	ret =3D bq24261_read_modify_reg(chip->client, BQ24261_CTRL_ADDR,
> +		       BQ24261_STAT_ENABLE_MASK|BQ24261_RESET_MASK|
> +				BQ24261_CE_MASK|BQ24261_TE_MASK,
> +					reg_val);
> +	if (ret || !val) {
> +		cancel_delayed_work_sync(&chip->notify_work);
> +		return ret;
> +	}
> +
> +	bq24261_set_iterm(chip, chip->iterm);
> +	schedule_delayed_work(&chip->notify_work, 0);
> +	bq24261_enable_hw_charge_term(chip, true);
> +	return bq24261_tmr_ntc_init(chip);
> +}
> +
> +static inline int bq24261_reset_timer(struct bq24261_charger *chip)
> +{
> +	return bq24261_read_modify_reg(chip->client, BQ24261_STAT_CTRL0_ADDR,
> +			BQ24261_TMR_RST_MASK, BQ24261_TMR_RST);
> +}
> +
> +static inline int bq24261_enable_charger(
> +	struct bq24261_charger *chip, int val)
> +{
> +
> +	u8 reg_val;
> +	int ret;
> +
> +	reg_val =3D val ? (~BQ24261_HZ_ENABLE & BQ24261_HZ_MASK)  :
> +			BQ24261_HZ_ENABLE;
> +
> +	ret =3D bq24261_read_modify_reg(chip->client, BQ24261_CTRL_ADDR,
> +		       BQ24261_HZ_MASK|BQ24261_RESET_MASK, reg_val);
> +	if (ret)
> +		return ret;
> +
> +	return bq24261_reset_timer(chip);
> +}
> +
> +static inline int bq24261_set_cc(struct bq24261_charger *chip, int cc)
> +{
> +	u8 reg_val;
> +	int ret;
> +
> +	dev_dbg(&chip->client->dev, "cc=3D%d\n", cc);
> +
> +	if (cc && (cc < BQ24261_MIN_CC)) {
> +		dev_dbg(&chip->client->dev, "Set LOW_CHG bit\n");
> +		reg_val =3D BQ24261_LOW_CHG_EN;
> +		ret =3D bq24261_read_modify_reg(chip->client,
> +				BQ24261_VINDPM_STAT_ADDR,
> +				BQ24261_LOW_CHG_MASK, reg_val);
> +	} else {
> +		dev_dbg(&chip->client->dev, "Clear LOW_CHG bit\n");
> +		reg_val =3D BQ24261_LOW_CHG_DIS;
> +		ret =3D bq24261_read_modify_reg(chip->client,
> +				BQ24261_VINDPM_STAT_ADDR,
> +				BQ24261_LOW_CHG_MASK, reg_val);
> +	}
> +
> +	reg_val =3D bq24261_cc_to_reg(cc);
> +
> +	return bq24261_read_modify_reg(chip->client, BQ24261_TERM_FCC_ADDR,
> +			BQ24261_ICHRG_MASK, reg_val);
> +}
> +
> +static inline int bq24261_set_cv(struct bq24261_charger *chip, int cv)
> +{
> +	int bat_volt;
> +	int ret;
> +	u8 reg_val;
> +	u8 vindpm_val =3D 0x0;
> +
> +	/*
> +	* Setting VINDPM value as per the battery voltage
> +	*  VBatt           Vindpm     Register Setting
> +	*  < 3.7v           4.2v       0x0 (default)
> +	*  3.71v - 3.96v    4.36v      0x2
> +	*  > 3.96v          4.6v       0x5
> +	*/
> +	ret =3D get_battery_voltage(&bat_volt);
> +	if (ret) {
> +		dev_err(&chip->client->dev,
> +			"Error getting battery voltage!!\n");
> +	} else {
> +		if (bat_volt > BQ24261_VBATT_LEVEL2)
> +			vindpm_val =3D
> +				(BQ24261_VINDPM_320MV | BQ24261_VINDPM_80MV);
> +		else if (bat_volt > BQ24261_VBATT_LEVEL1)
> +			vindpm_val =3D BQ24261_VINDPM_160MV;
> +	}
> +
> +	ret =3D bq24261_read_modify_reg(chip->client,
> +			BQ24261_VINDPM_STAT_ADDR,
> +			BQ24261_VINDPM_MASK,
> +			vindpm_val);
> +	if (ret) {
> +		dev_err(&chip->client->dev,
> +			"Error setting VINDPM setting!!\n");
> +		return ret;
> +	}
> +
> +
> +	reg_val =3D bq24261_cv_to_reg(cv);
> +
> +	return bq24261_read_modify_reg(chip->client, BQ24261_BATT_VOL_CTRL_ADDR,
> +				       BQ24261_VBREG_MASK, reg_val);
> +}
> +
> +static inline int bq24261_set_inlmt(struct bq24261_charger *chip, int in=
lmt)
> +{
> +	u8 reg_val;
> +
> +	reg_val =3D bq24261_inlmt_to_reg(inlmt);
> +
> +	return bq24261_read_modify_reg(chip->client, BQ24261_CTRL_ADDR,
> +		       BQ24261_RESET_MASK|BQ24261_INLMT_MASK, reg_val);
> +
> +}
> +
> +static inline void resume_charging(struct bq24261_charger *chip)
> +{
> +	int ret =3D 0;
> +
> +	if (chip->is_charger_enabled)
> +		ret =3D bq24261_enable_charger(chip, true);
> +	if (!ret && chip->inlmt)
> +		ret =3D bq24261_set_inlmt(chip, chip->inlmt);
> +	if (!ret && chip->cc)
> +		ret =3D bq24261_set_cc(chip, chip->cc);
> +	if (!ret && chip->cv)
> +		ret =3D bq24261_set_cv(chip, chip->cv);
> +	if (!ret && chip->is_charging_enabled)
> +		ret =3D bq24261_enable_charging(chip, true);
> +
> +	if (ret)
> +		dev_err(&bq24261_client->dev,
> +			"Error(%d) in resume charging\n", ret);
> +}
> +
> +static inline int bq24261_set_iterm(struct bq24261_charger *chip, int it=
erm)
> +{
> +	u8 reg_val;
> +
> +	reg_val =3D bq24261_iterm_to_reg(iterm);
> +
> +	return bq24261_read_modify_reg(chip->client, BQ24261_TERM_FCC_ADDR,
> +				       BQ24261_ITERM_MASK, reg_val);
> +}
> +
> +static inline int bq24261_enable_hw_charge_term(
> +	struct bq24261_charger *chip, bool val)
> +{
> +	u8 data;
> +	int ret;
> +
> +	data =3D val ? BQ24261_TE_ENABLE : (~BQ24261_TE_ENABLE & BQ24261_TE_MAS=
K);
> +
> +	ret =3D bq24261_read_modify_reg(chip->client, BQ24261_CTRL_ADDR,
> +			       BQ24261_RESET_MASK|BQ24261_TE_MASK, data);
> +
> +	if (ret)
> +		return ret;
> +
> +	chip->is_hw_chrg_term =3D val ? true : false;
> +
> +	return ret;
> +}
> +
> +static inline bool bq24261_is_vsys_on(struct bq24261_charger *chip)
> +{
> +	int ret;
> +	struct i2c_client *client =3D chip->client;
> +
> +	ret =3D bq24261_read_reg(client, BQ24261_CTRL_ADDR);
> +	if (ret < 0) {
> +		dev_err(&client->dev,
> +			"Error(%d) in reading BQ24261_CTRL_ADDR\n", ret);
> +		return false;
> +	}
> +
> +	if (((ret & BQ24261_HZ_MASK) =3D=3D BQ24261_HZ_ENABLE) &&
> +			chip->is_charger_enabled) {
> +		dev_err(&client->dev, "Charger in Hi Z Mode\n");
> +		return false;
> +	}
> +
> +	ret =3D bq24261_read_reg(client, BQ24261_VINDPM_STAT_ADDR);
> +	if (ret < 0) {
> +		dev_err(&client->dev,
> +			"Error(%d) in reading BQ24261_VINDPM_STAT_ADDR\n", ret);
> +		return false;
> +	}
> +
> +	if (ret & BQ24261_CD_STATUS_MASK) {
> +		dev_err(&client->dev, "CD line asserted\n");
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +static inline bool is_bq24261_enabled(struct bq24261_charger *chip)
> +{
> +	if (chip->cable_type =3D=3D PSY_CHARGER_CABLE_TYPE_NONE)
> +		return false;
> +	else if (!chip->is_charger_enabled)
> +		return false;
> +	/*
> +	* BQ24261 gives interrupt only on stop/resume charging.
> +	* If charging is already stopped, we need to query the hardware
> +	* to see charger is still active and can supply vsys or not.
> +	*/
> +	if ((chip->chrgr_stat =3D=3D BQ24261_CHRGR_STAT_FAULT) ||
> +		 (!chip->is_charging_enabled))
> +		return bq24261_is_vsys_on(chip);
> +
> +	return chip->is_vsys_on;
> +}
> +
> +static int bq24261_usb_psyc_set_property(struct power_supply_charger *ps=
yc,
> +				    enum power_supply_charger_property pscp,
> +				    const union power_supply_propval *val)
> +{
> +	struct bq24261_charger *chip;
> +	int ret =3D 0;
> +
> +	chip =3D container_of(psyc, struct bq24261_charger, psyc_usb);
> +
> +	mutex_lock(&chip->lock);
> +	dev_dbg(&chip->client->dev, "%s: prop=3D%d, val=3D%d\n",
> +			__func__, pscp, val->intval);
> +
> +	switch (pscp) {
> +
> +	case POWER_SUPPLY_CHARGER_PROP_ENABLE_CHARGING:
> +		ret =3D bq24261_enable_charging(chip, val->intval);
> +
> +		if (ret)
> +			dev_err(&chip->client->dev,
> +				"Error(%d) in %s charging", ret,
> +				(val->intval ? "enable" : "disable"));
> +		else
> +			chip->is_charging_enabled =3D val->intval;
> +
> +		break;
> +	case POWER_SUPPLY_CHARGER_PROP_ENABLE_CHARGER:
> +		/* Don't enable the charger unless over voltage is recovered */
> +
> +		if (chip->bat_health !=3D POWER_SUPPLY_HEALTH_OVERVOLTAGE) {
> +			ret =3D bq24261_enable_charger(chip, val->intval);
> +
> +			if (ret)
> +				dev_err(&chip->client->dev,
> +					"Error(%d) in %s charger", ret,
> +					(val->intval ? "enable" : "disable"));
> +			else
> +				chip->is_charger_enabled =3D val->intval;
> +		} else {
> +			dev_info(&chip->client->dev, "Battery Over Voltage. Charger will be d=
isabled\n");
> +		}
> +		break;
> +	case POWER_SUPPLY_CHARGER_PROP_CABLE_TYPE:
> +		chip->cable_type =3D val->intval;
> +		chip->psy_usb.type =3D get_power_supply_type(chip->cable_type);
> +		if (chip->cable_type !=3D PSY_CHARGER_CABLE_TYPE_NONE) {
> +			chip->chrgr_health =3D POWER_SUPPLY_HEALTH_GOOD;
> +			chip->chrgr_stat =3D BQ24261_CHRGR_STAT_UNKNOWN;
> +
> +			/*
> +			* Adding this processing in order to check
> +			* for any faults during connect
> +			*/
> +
> +			ret =3D bq24261_read_reg(chip->client,
> +						BQ24261_STAT_CTRL0_ADDR);
> +			if (ret < 0)
> +				dev_err(&chip->client->dev, "Error (%d) in reading status register(0=
x00)\n",
> +						ret);
> +			else
> +				bq24261_handle_irq(chip, ret);
> +		} else {
> +			chip->chrgr_stat =3D BQ24261_CHRGR_STAT_UNKNOWN;
> +			chip->chrgr_health =3D POWER_SUPPLY_HEALTH_UNKNOWN;
> +			cancel_delayed_work_sync(&chip->low_supply_fault_work);
> +		}
> +		break;
> +	case POWER_SUPPLY_CHARGER_PROP_RESET_WDT:
> +		bq24261_reset_timer(chip);
> +		break;
> +	default:
> +		ret =3D -ENODATA;
> +	}
> +
> +	mutex_unlock(&chip->lock);
> +	return ret;
> +}
> +
> +static int bq24261_usb_set_property(struct power_supply *psy,
> +				    enum power_supply_property psp,
> +				    const union power_supply_propval *val)
> +{
> +	struct bq24261_charger *chip;
> +	int ret =3D 0;
> +
> +	chip =3D container_of(psy, struct bq24261_charger, psy_usb);
> +
> +	mutex_lock(&chip->lock);
> +
> +	switch (psp) {
> +
> +	case POWER_SUPPLY_PROP_PRESENT:
> +		chip->present =3D val->intval;
> +		break;
> +	case POWER_SUPPLY_PROP_ONLINE:
> +		chip->online =3D val->intval;
> +		break;
> +	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT:
> +		ret =3D bq24261_set_cc(chip, val->intval);
> +		if (!ret)
> +			chip->cc =3D val->intval;
> +		break;
> +	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE:
> +		ret =3D bq24261_set_cv(chip, val->intval);
> +		if (!ret)
> +			chip->cv =3D val->intval;
> +		break;
> +	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT_MAX:
> +		chip->max_cc =3D val->intval;
> +		break;
> +	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE_MAX:
> +		chip->max_cv =3D val->intval;
> +		break;
> +	case POWER_SUPPLY_PROP_CHARGE_TERM_CURRENT:
> +		ret =3D bq24261_set_iterm(chip, val->intval);
> +		if (!ret)
> +			chip->iterm =3D val->intval;
> +		break;
> +	case POWER_SUPPLY_PROP_INPUT_CURRENT_LIMIT:
> +		ret =3D bq24261_set_inlmt(chip, val->intval);
> +		if (!ret)
> +			chip->inlmt =3D val->intval;
> +		break;
> +	case POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT:
> +		chip->cntl_state =3D val->intval;
> +		break;
> +	case POWER_SUPPLY_PROP_TEMP_MAX:
> +		chip->max_temp =3D val->intval;
> +		break;
> +	case POWER_SUPPLY_PROP_TEMP_MIN:
> +		chip->min_temp =3D val->intval;
> +		break;
> +	default:
> +		ret =3D -ENODATA;
> +	}
> +
> +	mutex_unlock(&chip->lock);
> +	return ret;
> +}
> +
> +static int bq24261_usb_psyc_get_property(struct power_supply_charger *ps=
yc,
> +				    enum power_supply_charger_property pscp,
> +				    union power_supply_propval *val)
> +{
> +	struct bq24261_charger *chip;
> +
> +	chip =3D container_of(psyc, struct bq24261_charger, psyc_usb);
> +
> +	mutex_lock(&chip->lock);
> +
> +	switch (pscp) {
> +	case POWER_SUPPLY_CHARGER_PROP_CABLE_TYPE:
> +		val->intval =3D chip->cable_type;
> +		break;
> +	case POWER_SUPPLY_CHARGER_PROP_ENABLE_CHARGING:
> +		val->intval =3D (chip->is_charging_enabled &&
> +			(chip->chrgr_stat =3D=3D BQ24261_CHRGR_STAT_CHARGING));
> +
> +		break;
> +	case POWER_SUPPLY_CHARGER_PROP_ENABLE_CHARGER:
> +		val->intval =3D is_bq24261_enabled(chip);
> +		break;
> +	default:
> +		mutex_unlock(&chip->lock);
> +		return -EINVAL;
> +	}
> +
> +	mutex_unlock(&chip->lock);
> +	return 0;
> +}
> +
> +static int bq24261_usb_get_property(struct power_supply *psy,
> +				    enum power_supply_property psp,
> +				    union power_supply_propval *val)
> +{
> +	struct bq24261_charger *chip;
> +
> +	chip  =3D container_of(psy, struct bq24261_charger, psy_usb);
> +
> +	mutex_lock(&chip->lock);
> +
> +	switch (psp) {
> +	case POWER_SUPPLY_PROP_PRESENT:
> +		val->intval =3D chip->present;
> +		break;
> +	case POWER_SUPPLY_PROP_ONLINE:
> +		val->intval =3D chip->online;
> +		break;
> +	case POWER_SUPPLY_PROP_HEALTH:
> +		val->intval =3D chip->chrgr_health;
> +		break;
> +	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT_MAX:
> +		val->intval =3D chip->max_cc;
> +		break;
> +	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE_MAX:
> +		val->intval =3D chip->max_cv;
> +		break;
> +	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT:
> +		val->intval =3D chip->cc;
> +		break;
> +	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE:
> +		val->intval =3D chip->cv;
> +		break;
> +	case POWER_SUPPLY_PROP_INPUT_CURRENT_LIMIT:
> +		val->intval =3D chip->inlmt;
> +		break;
> +	case POWER_SUPPLY_PROP_CHARGE_TERM_CURRENT:
> +		val->intval =3D chip->iterm;
> +		break;
> +	case POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT:
> +		val->intval =3D chip->cntl_state;
> +		break;
> +	case POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT_MAX:
> +		val->intval =3D chip->pdata->num_throttle_states;
> +		break;
> +	case POWER_SUPPLY_PROP_MODEL_NAME:
> +		val->strval =3D chip->model_name;
> +		break;
> +	case POWER_SUPPLY_PROP_MANUFACTURER:
> +		val->strval =3D "TI";
> +		break;
> +	case POWER_SUPPLY_PROP_TEMP_MAX:
> +		val->intval =3D chip->max_temp;
> +		break;
> +	case POWER_SUPPLY_PROP_TEMP_MIN:
> +		val->intval =3D chip->min_temp;
> +		break;
> +	default:
> +		mutex_unlock(&chip->lock);
> +		return -EINVAL;
> +	}
> +
> +	mutex_unlock(&chip->lock);
> +	return 0;
> +}
> +
> +static inline struct power_supply *get_psy_battery(void)
> +{
> +	static struct power_supply *psy;
> +	struct bq24261_charger *chip;
> +	int i;
> +
> +	if (!bq24261_client)
> +		return NULL;
> +
> +	chip =3D i2c_get_clientdata(bq24261_client);
> +
> +	for (i =3D 0; i < chip->psy_usb.num_supplicants; ++i) {
> +		psy =3D power_supply_get_by_name(chip->psy_usb.supplied_to[i]);
> +		if (psy)
> +			return psy;
> +	}
> +
> +	return NULL;
> +}
> +
> +static inline int get_battery_voltage(int *volt)
> +{
> +	struct power_supply *psy;
> +	union power_supply_propval val;
> +	int ret;
> +
> +	psy =3D get_psy_battery();
> +	if (!psy)
> +		return -EINVAL;
> +
> +	ret =3D psy->get_property(psy, POWER_SUPPLY_PROP_VOLTAGE_NOW, &val);
> +	if (!ret)
> +		*volt =3D val.intval;
> +
> +	return ret;
> +}
> +
> +static inline int get_battery_property
> +	(enum power_supply_property prop, int *prop_val)
> +{
> +	struct power_supply *psy;
> +
> +	psy =3D get_psy_battery();
> +	if (!psy)
> +		return -EINVAL;
> +
> +	*prop_val =3D psy_get_ps_int_property(psy, prop);
> +
> +	return 0;
> +}
> +
> +static inline int get_battery_volt_max_design(int *volt)
> +{
> +	return get_battery_property(POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN, volt);
> +
> +}
> +
> +static void notify_worker(struct work_struct *work)
> +{
> +
> +	struct bq24261_charger *chip =3D container_of(work,
> +						    struct bq24261_charger,
> +						    notify_work.work);
> +
> +	atomic_notifier_call_chain(&power_supply_notifier,
> +				PSY_EVENT_PROP_CHANGED, &chip->psy_usb);
> +	schedule_delayed_work(&chip->notify_work, WDT_RESET_DELAY);
> +}
> +
> +int bq24261_get_bat_health(void)
> +{
> +
> +	struct bq24261_charger *chip;
> +
> +	if (!bq24261_client)
> +		return -ENODEV;
> +
> +	chip =3D i2c_get_clientdata(bq24261_client);
> +
> +	return chip->bat_health;
> +}
> +
> +
> +static void bq24261_low_supply_fault_work(struct work_struct *work)
> +{
> +	struct bq24261_charger *chip =3D container_of(work,
> +						    struct bq24261_charger,
> +						    low_supply_fault_work.work);
> +
> +	if (chip->chrgr_stat =3D=3D BQ24261_CHRGR_STAT_FAULT) {
> +		dev_err(&chip->client->dev, "Low Supply Fault detected!!\n");
> +		chip->chrgr_health =3D POWER_SUPPLY_HEALTH_DEAD;
> +		power_supply_changed(&chip->psy_usb);
> +	}
> +	return;
> +}
> +
> +
> +/* is_bat_over_voltage: check battery is over voltage or not
> +*  @chip: bq24261_charger context
> +*
> +*  This function is used to verify the over voltage condition.
> +*  In some scenarios, HW generates Over Voltage exceptions when
> +*  battery voltage is normal. This function uses the over voltage
> +*  condition (voltage_max_design * 1.01) to verify battery is really
> +*  over charged or not.
> +*/
> +
> +static bool is_bat_over_voltage(struct bq24261_charger *chip)
> +{
> +	int bat_volt, bat_volt_max_des, ret;
> +
> +	ret =3D get_battery_voltage(&bat_volt);
> +	if (ret)
> +		return true;
> +
> +	ret =3D get_battery_volt_max_design(&bat_volt_max_des);
> +
> +	if (ret)
> +		bat_volt_max_des =3D BQ24261_DEF_BAT_VOLT_MAX_DESIGN;
> +
> +	dev_info(&chip->client->dev, "bat_volt=3D%d Voltage Max Design=3D%d OVP=
_VOLT=3D%d\n",
> +			bat_volt, bat_volt_max_des,
> +			(bat_volt_max_des/1000 * BQ24261_OVP_MULTIPLIER));
> +
> +	if ((bat_volt) >=3D (bat_volt_max_des / 1000 *
> +					BQ24261_OVP_MULTIPLIER))
> +			return true;
> +
> +	return false;
> +}
> +
> +#define IS_BATTERY_OVER_VOLTAGE_RECOVERED(chip) \
> +	(!is_bat_over_voltage(chip))
> +
> +static void handle_battery_over_voltage(struct bq24261_charger *chip)
> +{
> +	/*
> +	* Set Health to Over Voltage. Disable charger to discharge
> +	* battery to reduce the battery voltage.
> +	*/
> +	chip->bat_health =3D POWER_SUPPLY_HEALTH_OVERVOLTAGE;
> +	bq24261_enable_charger(chip, false);
> +	chip->is_charger_enabled =3D false;
> +	cancel_delayed_work_sync(&chip->exception_mon_work);
> +	schedule_delayed_work(&chip->exception_mon_work,
> +			EXCEPTION_MONITOR_DELAY);
> +}
> +
> +static void bq24261_exception_mon_work(struct work_struct *work)
> +{
> +	struct bq24261_charger *chip =3D container_of(work,
> +						    struct bq24261_charger,
> +						    exception_mon_work.work);
> +	/* Only over voltage exception need to monitor.*/
> +	if (IS_BATTERY_OVER_VOLTAGE_RECOVERED(chip)) {
> +		dev_info(&chip->client->dev, "Over Voltage Exception Recovered\n");
> +		chip->bat_health =3D POWER_SUPPLY_HEALTH_GOOD;
> +		bq24261_enable_charger(chip, true);
> +		chip->is_charger_enabled =3D true;
> +		resume_charging(chip);
> +	} else {
> +		schedule_delayed_work(&chip->exception_mon_work,
> +			      EXCEPTION_MONITOR_DELAY);
> +	}
> +}
> +
> +static int bq24261_handle_irq(struct bq24261_charger *chip, u8 stat_reg)
> +{
> +	struct i2c_client *client =3D chip->client;
> +	bool notify =3D true;
> +
> +	dev_info(&client->dev, "%s:%d stat=3D0x%x\n",
> +			__func__, __LINE__, stat_reg);
> +
> +	switch (stat_reg & BQ24261_STAT_MASK) {
> +	case BQ24261_STAT_READY:
> +		chip->chrgr_stat =3D BQ24261_CHRGR_STAT_READY;
> +		chip->chrgr_health =3D POWER_SUPPLY_HEALTH_GOOD;
> +		chip->bat_health =3D POWER_SUPPLY_HEALTH_GOOD;
> +		dev_info(&client->dev, "Charger Status: Ready\n");
> +		notify =3D false;
> +		break;
> +	case BQ24261_STAT_CHRG_PRGRSS:
> +		chip->chrgr_stat =3D BQ24261_CHRGR_STAT_CHARGING;
> +		chip->chrgr_health =3D POWER_SUPPLY_HEALTH_GOOD;
> +		chip->bat_health =3D POWER_SUPPLY_HEALTH_GOOD;
> +		dev_info(&client->dev, "Charger Status: Charge Progress\n");
> +		break;
> +	case BQ24261_STAT_CHRG_DONE:
> +		chip->chrgr_health =3D POWER_SUPPLY_HEALTH_GOOD;
> +		chip->bat_health =3D POWER_SUPPLY_HEALTH_GOOD;
> +		dev_info(&client->dev, "Charger Status: Charge Done\n");
> +
> +		/*
> +		*  HW reports charge termination. Stop h/w charge termination
> +		* and resume charging. Let power supply charging driver decide
> +		* on charge termination
> +		*/
> +
> +		bq24261_enable_hw_charge_term(chip, false);
> +		resume_charging(chip);
> +		break;
> +
> +	case BQ24261_STAT_FAULT:
> +		break;
> +	}
> +
> +	if (stat_reg & BQ24261_BOOST_MASK)
> +		dev_info(&client->dev, "Boost Mode\n");
> +
> +	if ((stat_reg & BQ24261_STAT_MASK) =3D=3D BQ24261_STAT_FAULT) {
> +		chip->chrgr_stat =3D BQ24261_CHRGR_STAT_FAULT;
> +
> +		switch (stat_reg & BQ24261_FAULT_MASK) {
> +		case BQ24261_VOVP:
> +			chip->chrgr_health =3D POWER_SUPPLY_HEALTH_OVERVOLTAGE;
> +			dev_err(&client->dev, "Charger OVP Fault\n");
> +			break;
> +
> +		case BQ24261_LOW_SUPPLY:
> +			notify =3D false;
> +
> +			if (chip->cable_type !=3D
> +					PSY_CHARGER_CABLE_TYPE_NONE) {
> +				schedule_delayed_work
> +					(&chip->low_supply_fault_work,
> +					5*HZ);
> +				dev_dbg(&client->dev,
> +					"Schedule Low Supply Fault work!!\n");
> +			}
> +			break;
> +
> +		case BQ24261_THERMAL_SHUTDOWN:
> +			chip->chrgr_health =3D POWER_SUPPLY_HEALTH_OVERHEAT;
> +			dev_err(&client->dev, "Charger Thermal Fault\n");
> +			break;
> +
> +		case BQ24261_BATT_TEMP_FAULT:
> +			chip->bat_health =3D POWER_SUPPLY_HEALTH_OVERHEAT;
> +			dev_err(&client->dev, "Battery Temperature Fault\n");
> +			break;
> +
> +		case BQ24261_TIMER_FAULT:
> +			chip->bat_health =3D POWER_SUPPLY_HEALTH_UNSPEC_FAILURE;
> +			chip->chrgr_health =3D POWER_SUPPLY_HEALTH_UNSPEC_FAILURE;
> +			dev_err(&client->dev, "Charger Timer Fault\n");
> +			break;
> +
> +		case BQ24261_BATT_OVP:
> +			notify =3D false;
> +			if (chip->bat_health !=3D
> +					POWER_SUPPLY_HEALTH_OVERVOLTAGE) {
> +				if (!is_bat_over_voltage(chip)) {
> +					chip->chrgr_stat =3D
> +						BQ24261_CHRGR_STAT_UNKNOWN;
> +					resume_charging(chip);
> +				} else {
> +					dev_err(&client->dev, "Battery Over Voltage Fault\n");
> +					handle_battery_over_voltage(chip);
> +					notify =3D true;
> +				}
> +			}
> +			break;
> +		case BQ24261_NO_BATTERY:
> +			dev_err(&client->dev, "No Battery Connected\n");
> +			break;
> +
> +		}
> +
> +	}
> +
> +	wake_up(&chip->wait_ready);
> +
> +	chip->is_vsys_on =3D bq24261_is_vsys_on(chip);
> +	if (notify)
> +		power_supply_changed(&chip->psy_usb);
> +
> +	return 0;
> +}
> +
> +static irqreturn_t bq24261_thread_handler(int id, void *data)
> +{
> +	struct bq24261_charger *chip =3D (struct bq24261_charger *)data;
> +	int ret;
> +
> +	mutex_lock(&chip->lock);
> +
> +	ret =3D bq24261_read_reg(chip->client, BQ24261_STAT_CTRL0_ADDR);
> +	if (ret < 0)
> +		dev_err(&chip->client->dev,
> +			"Error (%d) in reading BQ24261_STAT_CTRL0_ADDR\n", ret);
> +	else
> +		bq24261_handle_irq(chip, ret);
> +
> +	mutex_unlock(&chip->lock);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static enum bq2426x_model_num bq24261_get_model(int bq24261_rev_reg)
> +{
> +	switch (bq24261_rev_reg & BQ24261_REV_MASK) {
> +	case BQ24260_REV:
> +		return BQ24260;
> +	case BQ24261_REV:
> +	case BQ24261_PG2_3_REV:
> +		return BQ24261;
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +static int bq24261_probe(struct i2c_client *client,
> +			 const struct i2c_device_id *id)
> +{
> +	struct i2c_adapter *adapter;
> +	struct bq24261_charger *chip;
> +	int ret;
> +	enum bq2426x_model_num bq24261_rev;
> +
> +	adapter =3D to_i2c_adapter(client->dev.parent);
> +
> +	if (!client->dev.platform_data) {
> +		dev_err(&client->dev, "platform data is null");
> +		return -EFAULT;
> +	}
> +
> +	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
> +		dev_err(&client->dev,
> +			"I2C adapter %s doesn't support BYTE DATA transfer\n",
> +			adapter->name);
> +		return -EIO;
> +	}
> +
> +	ret =3D bq24261_read_reg(client, BQ24261_VENDOR_REV_ADDR);
> +	if (ret < 0) {
> +		dev_err(&client->dev,
> +			"Error (%d) in reading BQ24261_VENDOR_REV_ADDR\n", ret);
> +		return ret;
> +	}
> +
> +	bq24261_rev =3D bq24261_get_model(ret);
> +	if (((ret & BQ24261_VENDOR_MASK) !=3D BQ24261_VENDOR) ||
> +		(bq24261_rev < 0)) {
> +		dev_err(&client->dev,
> +			"Invalid Vendor/Revision number in BQ24261_VENDOR_REV_ADDR: %d",
> +			ret);
> +		return -ENODEV;
> +	}
> +
> +	chip =3D devm_kzalloc(&client->dev, sizeof(*chip), GFP_KERNEL);
> +	if (!chip) {
> +		dev_err(&client->dev, "mem alloc failed\n");
> +		return -ENOMEM;
> +	}
> +
> +	init_waitqueue_head(&chip->wait_ready);
> +	i2c_set_clientdata(client, chip);
> +	chip->pdata =3D client->dev.platform_data;
> +
> +
> +	chip->client =3D client;
> +	chip->pdata =3D client->dev.platform_data;

why do you set platform_data two times?

> +	chip->psy_usb.name =3D DEV_NAME;
> +	chip->psy_usb.type =3D POWER_SUPPLY_TYPE_USB;
> +	chip->psy_usb.properties =3D bq24261_usb_props;
> +	chip->psy_usb.num_properties =3D ARRAY_SIZE(bq24261_usb_props);
> +	chip->psy_usb.get_property =3D bq24261_usb_get_property;
> +	chip->psy_usb.set_property =3D bq24261_usb_set_property;
> +	chip->psy_usb.supplied_to =3D chip->pdata->supplied_to;
> +	chip->psy_usb.num_supplicants =3D chip->pdata->num_supplicants;
> +	/* Limit charge current */
> +	chip->max_cc =3D 1500;
> +	chip->chrgr_stat =3D BQ24261_CHRGR_STAT_UNKNOWN;
> +	chip->chrgr_health =3D POWER_SUPPLY_HEALTH_UNKNOWN;
> +
> +	chip->psyc_usb.get_property =3D bq24261_usb_psyc_get_property;
> +	chip->psyc_usb.set_property =3D bq24261_usb_psyc_set_property;
> +	chip->psyc_usb.throttle_states =3D chip->pdata->throttle_states;
> +	chip->psyc_usb.num_throttle_states =3D chip->pdata->num_throttle_states;
> +	chip->psyc_usb.supported_cables =3D PSY_CHARGER_CABLE_TYPE_USB;
> +
> +	strncpy(chip->model_name,
> +		bq24261_model_name[bq24261_rev].model_name,
> +		MODEL_NAME_SIZE);
> +
> +	mutex_init(&chip->lock);
> +	ret =3D power_supply_register(&client->dev, &chip->psy_usb);
> +	if (ret) {
> +		dev_err(&client->dev, "Failed: power supply register (%d)\n",
> +			ret);
> +		return ret;
> +	}
> +
> +	ret =3D power_supply_register_charger(&chip->psy_usb, &chip->psyc_usb);
> +	if (ret) {
> +		dev_err(&client->dev, "Failed: power supply register (%d)\n",
> +			ret);
> +		power_supply_unregister(&chip->psy_usb);
> +		return ret;
> +	}
> +
> +	INIT_DELAYED_WORK(&chip->notify_work, notify_worker);
> +	INIT_DELAYED_WORK(&chip->low_supply_fault_work,
> +				bq24261_low_supply_fault_work);
> +	INIT_DELAYED_WORK(&chip->exception_mon_work,
> +				bq24261_exception_mon_work);
> +	bq24261_client =3D client;
> +
> +	if (chip->client->irq) {
> +		ret =3D request_threaded_irq(chip->client->irq,
> +					   NULL,
> +					   bq24261_thread_handler,
> +					   IRQF_SHARED|IRQF_NO_SUSPEND,
> +					   DEV_NAME, chip);
> +		if (ret) {
> +			dev_err(&client->dev, "Failed: request_irq (%d)\n",
> +				ret);
> +			power_supply_unregister(&chip->psy_usb);
> +			power_supply_unregister_charger(&chip->psyc_usb);
> +			bq24261_client =3D NULL;
> +			return ret;
> +		}
> +	}
> +
> +	if (is_bat_over_voltage(chip))
> +		handle_battery_over_voltage(chip);
> +	else
> +		chip->bat_health =3D POWER_SUPPLY_HEALTH_GOOD;
> +
> +
> +	return 0;
> +}
> +
> +static int bq24261_remove(struct i2c_client *client)
> +{
> +	struct bq24261_charger *chip =3D i2c_get_clientdata(client);
> +
> +	if (client->irq)
> +		free_irq(client->irq, chip);
> +
> +	flush_scheduled_work();
> +
> +	power_supply_unregister(&chip->psy_usb);
> +	return 0;
> +}
> +
> +static const struct i2c_device_id bq24261_id[] =3D {
> +	{DEV_NAME, 0},
> +	{},
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, bq24261_id);
> +
> +static struct i2c_driver bq24261_driver =3D {
> +	.driver =3D {
> +		   .name =3D DEV_NAME,
> +	},
> +	.probe =3D bq24261_probe,
> +	.remove =3D bq24261_remove,
> +	.id_table =3D bq24261_id,
> +};
> +
> +module_i2c_driver(bq24261_driver);
> +
> +MODULE_AUTHOR("Jenny TC <jenny.tc@intel.com>");
> +MODULE_DESCRIPTION("BQ24261 Charger Driver");
> +MODULE_LICENSE("GPL");
> diff --git a/include/linux/power/bq24261-charger.h b/include/linux/power/=
bq24261-charger.h
> new file mode 100644
> index 0000000..4ff02af
> --- /dev/null
> +++ b/include/linux/power/bq24261-charger.h
> @@ -0,0 +1,25 @@
> +/*
> + * bq24261_charger.h: platform data structure for bq24261 driver
> + *
> + * (C) Copyright 2012 Intel Corporation
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; version 2
> + * of the License.
> + */
> +
> +#ifndef __BQ24261_CHARGER_H__
> +#define __BQ24261_CHARGER_H__
> +
> +struct bq24261_plat_data {
> +	char **supplied_to;
> +	size_t num_supplicants;
> +	struct psy_throttle_state *throttle_states;
> +	size_t num_throttle_states;
> +	int safety_timer;
> +	bool is_ts_enabled;
> +
> +};
> +
> +#endif
> --=20
> 1.7.9.5
>=20

--i9LlY+UWpKt15+FH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTtXXoAAoJENju1/PIO/qaZ94P/1CzC875bX4mmcpAeT51wFTX
cQTwKd6JyF5vxP/05rUi2Mp0NsU1M+YtZeJLAz3PwGUEg5QN45kom7LmXRravOV9
goQvK12qMqEGKcAaSmbYE1OzRm3Mf2vp6YKI5DXFHXAbSCVM0JB9zw3GuH2pTTye
tXSA0eiWPzB6s802fxn8jl/nq5UHPcy4wqUcCkHALT0oiJvoqD05A26AQskvGlGs
AnWOm4uNJBgrX4S1J/VbUk2ebPqiKQXMg57rFk3uhYhAUFPq7EnbVof+hKooeryn
YkqVhaas0PnDWnRSJR12BkkH2YddadMGhZbJp9MdOrUoOf9b+ACeHSQi2epRx5CP
r8SVaOH0+j53FiOem7NaJIfd/rQ6uR7PcnEfSmYoge0xYQooq+nG7mF8cBepAjWW
0Pqq5ZrR6JIduqWkzoH3cYMXUo2t8OZhwoc7zUy3SeMoLScdHR4BEWVlYzDAQix1
h6VF+9rb2MsB+A4dniKq3oMhG2FqH/edWr7JTrQfVq2jaDZyPClhI14lpUzZYkMp
kZ+sS2kqgYyvkNkyA7Kc30HqxUUQSckqHup3Dt6dgoGn9l2ZBziaO4W25Wp0LcHe
xnvj4H5LVUhBHQpe2VtWeW3TaxvVCw7wLDqjYpydRk25a32031FYSrQSGZy/13mu
FKwyrCgRjlqoM84q6NlA
=NHDU
-----END PGP SIGNATURE-----

--i9LlY+UWpKt15+FH--
