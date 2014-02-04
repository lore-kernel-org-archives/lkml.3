Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbaBDLg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 06:36:28 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46839 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaBDLgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 06:36:25 -0500
Date: Tue, 4 Feb 2014 12:36:21 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jenny TC <jenny.tc@intel.com>
Cc: linux-kernel@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Kim Milo <Milo.Kim@ti.com>, Lee Jones <lee.jones@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Rhyland Klein <rklein@nvidia.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sebastian Reichel <sre@ring0.de>, aaro.koskinen@iki.fi,
        Pallala Ramakrishna <ramakrishna.pallala@intel.com>,
        freemangordon@abv.bg, linux-omap@vger.kernel.org
Subject: Re: [PATCH 4/4] power_supply: bq24261 charger driver
Message-ID: <20140204113621.GB2450@amd.pavel.ucw.cz>
References: <1391490780-6141-1-git-send-email-jenny.tc@intel.com>
 <1391490780-6141-5-git-send-email-jenny.tc@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391490780-6141-5-git-send-email-jenny.tc@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


> +#define DEV_MANUFACTURER "TI"
> +#define DEV_MANUFACTURER_NAME_SIZE 4

This is unneccessarily complicated for no reason. You copy "TI" to
struct, just so that ou can return pointer to the field on
get_property.

What about simply returning "TI" from get_property, without defines
and copying?

> +#define BQ24261_MIN_CV 3500
> +#define BQ24261_MAX_CV 4440

Other defines use uV as an unit :-(.

> +static void lookup_regval(u16 tbl[][2], size_t size, u16 in_val, u8 *out_val)
> +{
> +	int i;
> +
> +	for (i = 1; i < size; ++i)
> +		if (in_val < tbl[i][0])
> +			break;
> +
> +	*out_val = (u8) tbl[i - 1][1];
> +}

Umm. Could we simply return the value?

> +static void bq24261_cc_to_reg(int cc, u8 *reg_val)
> +{
> +
> +	cc = cc < BQ24261_MAX_CC ? cc : BQ24261_MAX_CC;
> +	cc = cc - BQ24261_MIN_CC;

clamp_t?

> +	*reg_val = cc > 0 ? ((cc/100) << 3) & 0xFF : 0;
> +}

Just return the value?

> +static void bq24261_cv_to_reg(int cv, u8 *reg_val)
> +{
> +	int val;
> +
> +	val = clamp_t(int, cv, BQ24261_MIN_CV, BQ24261_MAX_CV);
> +	*reg_val =
> +		(((val - BQ24261_MIN_CV) / BQ24261_CV_DIV)
> +			<< BQ24261_CV_BIT_POS);
> +}

Not sure if the defines really make it more readable. It should be
consistent with the above/below functions...

> +static inline void bq24261_iterm_to_reg(int iterm, u8 *regval)
> +{
> +	iterm = iterm < BQ24261_MAX_ITERM ? iterm : BQ24261_MAX_ITERM;
> +	iterm = iterm - BQ24261_MIN_ITERM;

clamp_t?

> +	*regval = iterm > 0 ? (iterm/50) & 0xFF : 0;
> +}

Just return the value.

> +static inline void bq24261_sfty_tmr_to_reg(int tmr, u8 *regval)
> +{
> +	return lookup_regval(bq24261_sfty_tmr, ARRAY_SIZE(bq24261_sfty_tmr),
> +			     tmr, regval);
> +}

Just return the value... returning void values with explicit return is
"interesting".

> +	/* If status is fault, wait for READY before enabling the charging */
> +
> +	if (!is_ready) {
> +		ret = wait_event_timeout(chip->wait_ready,
> +			(chip->chrgr_stat != BQ24261_CHRGR_STAT_READY),
> +				HZ);
> +		dev_info(&chip->client->dev,
> +			"chrgr_stat=%x\n", chip->chrgr_stat);
> +		if (ret == 0) {
> +			dev_err(&chip->client->dev,
> +				"Waiting for Charger Ready Failed.Enabling charging anyway\n");
> +		}
> +	}

So charger has a problem, and we force it on, anyway? Also put space
after ".".

> +static inline int bq24261_set_cv(struct bq24261_charger *chip, int cv)
> +{
> +	int bat_volt;
> +	int ret;
> +	u8 reg_val;
> +	u8 vindpm_val = 0x0;
> +
> +	/*
> +	* Setting VINDPM value as per the battery voltage
> +	*  VBatt           Vindpm     Register Setting
> +	*  < 3.7v           4.2v       0x0 (default)
> +	*  3.71v - 3.96v    4.36v      0x2
> +	*  > 3.96v          4.6v       0x5
> +	*/
> +	ret = get_battery_voltage(&bat_volt);
> +	if (ret) {
> +		dev_err(&chip->client->dev,
> +			"Error getting battery voltage!!\n");
> +	} else {

You forget the error value and continue anyway.

> +static inline void resume_charging(struct bq24261_charger *chip)
> +{
> +
> +	if (chip->is_charger_enabled)
> +		bq24261_enable_charger(chip, true);
> +	if (chip->inlmt)
> +		bq24261_set_inlmt(chip, chip->inlmt);
> +	if (chip->cc)
> +		bq24261_set_cc(chip, chip->cc);
> +	if (chip->cv)
> +		bq24261_set_cv(chip, chip->cv);
> +	if (chip->is_charging_enabled)
> +		bq24261_enable_charging(chip, true);

What about some error checking?

Is it wise to enable charging when setting voltage failed?

> +static inline bool is_bq24261_enabled(struct bq24261_charger *chip)
> +{
> +	if (chip->cable_type == PSY_CHARGER_CABLE_TYPE_NONE)
> +		return false;
> +	else if (!chip->is_charger_enabled)
> +		return false;

Kill the else.

> +static inline int get_battery_voltage(int *volt)
> +{
> +	struct power_supply *psy;
> +	union power_supply_propval val;
> +	int ret;
> +
> +	psy = get_psy_battery();
> +	if (!psy)
> +		return -EINVAL;

Hmm. Does this assume just one battery in the system?

Is it good idea? Older machines contain main and memory backup
batteries. Newer machines contain keyboard and display battery....


									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
