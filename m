Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751007AbaBTFDU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 00:03:20 -0500
Received: from mga01.intel.com ([192.55.52.88]:18549 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703AbaBTFDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 00:03:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,510,1389772800"; 
   d="scan'208";a="484593502"
Date: Thu, 20 Feb 2014 10:33:10 +0530
From: Jenny Tc <jenny.tc@intel.com>
To: Pavel Machek <pavel@ucw.cz>
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
Message-ID: <20140220050310.GA2498@jenny-desktop>
References: <1391490780-6141-1-git-send-email-jenny.tc@intel.com>
 <1391490780-6141-5-git-send-email-jenny.tc@intel.com>
 <20140204113621.GB2450@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140204113621.GB2450@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 12:36:21PM +0100, Pavel Machek wrote:
> > +#define BQ24261_MIN_CV 3500
> > +#define BQ24261_MAX_CV 4440
> 
> Other defines use uV as an unit :-(.

uV is used if the value is read from psy class. For register configurations
uses mV. Will change the name to reflect mV

> > +	/* If status is fault, wait for READY before enabling the charging */
> > +
> > +	if (!is_ready) {
> > +		ret = wait_event_timeout(chip->wait_ready,
> > +			(chip->chrgr_stat != BQ24261_CHRGR_STAT_READY),
> > +				HZ);
> > +		dev_info(&chip->client->dev,
> > +			"chrgr_stat=%x\n", chip->chrgr_stat);
> > +		if (ret == 0) {
> > +			dev_err(&chip->client->dev,
> > +				"Waiting for Charger Ready Failed.Enabling charging anyway\n");
> > +		}
> > +	}
> 
> So charger has a problem, and we force it on, anyway? Also put space
> after ".".

Yes, sometimes charger does not give ready, so we force.
> 
> > +static inline int bq24261_set_cv(struct bq24261_charger *chip, int cv)
> > +{
> > +	int bat_volt;
> > +	int ret;
> > +	u8 reg_val;
> > +	u8 vindpm_val = 0x0;
> > +
> > +	/*
> > +	* Setting VINDPM value as per the battery voltage
> > +	*  VBatt           Vindpm     Register Setting
> > +	*  < 3.7v           4.2v       0x0 (default)
> > +	*  3.71v - 3.96v    4.36v      0x2
> > +	*  > 3.96v          4.6v       0x5
> > +	*/
> > +	ret = get_battery_voltage(&bat_volt);
> > +	if (ret) {
> > +		dev_err(&chip->client->dev,
> > +			"Error getting battery voltage!!\n");
> > +	} else {
> 
> You forget the error value and continue anyway.

On error, throw the error and program default VINDPM value.

-Jenny
