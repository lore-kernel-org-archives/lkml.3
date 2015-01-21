Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbbAUUwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 15:52:43 -0500
Received: from mga01.intel.com ([192.55.52.88]:32062 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbbAUUwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 15:52:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,444,1418112000"; 
   d="scan'208";a="673671285"
Date: Wed, 21 Jan 2015 12:52:53 -0800
From: Todd E Brandt <todd.e.brandt@linux.intel.com>
To: Sebastian Reichel <sre@kernel.org>
Cc: linux-pm@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, jacob.jun.pan@linux.intel.com,
        sameo@linux.intel.com, lee.jones@linaro.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, david.woodhouse@intel.com,
        todd.e.brandt@intel.com
Subject: Re: [PATCH 3/3] power/axp288_fuel_gauge: axp288 fuel gauge driver
Message-ID: <20150121205253.GB15525@linux.intel.com>
Reply-To: todd.e.brandt@linux.intel.com
References: <20150107212655.GD3440@linux.intel.com>
 <20150118104923.GA11147@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150118104923.GA11147@earth.universe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2015 at 11:49:27AM +0100, Sebastian Reichel wrote:
> Hi,
> 
> On Wed, Jan 07, 2015 at 01:26:55PM -0800, Todd E Brandt wrote:
> > X-Power AXP288 PMIC Fuel Gauge Driver
> > 
> >  new power_supply driver at driver/power
> >  interfaces with the axp20x mfd driver as a cell
> >  provides battery info and monitors for changes
> >  generates alerts on temperature and capacity issues
> > 
> > [...]
> >
> > +static int fuel_gauge_battery_health(struct axp288_fg_info *info)
> > +{
> > +	int temp, vocv;
> > +	int ret, health = POWER_SUPPLY_HEALTH_UNKNOWN;
> > +
> > +	ret = fuel_gauge_get_btemp(info, &temp);
> > +	if (ret < 0)
> > +		goto health_read_fail;
> > +
> > +	ret = fuel_gauge_get_vocv(info, &vocv);
> > +	if (ret < 0)
> > +		goto health_read_fail;
> > +
> > +	if (vocv > info->pdata->max_volt)
> > +		health = POWER_SUPPLY_HEALTH_OVERVOLTAGE;
> > +	else if (temp > info->pdata->max_temp ||
> > +			temp < info->pdata->min_temp)
> > +		health = POWER_SUPPLY_HEALTH_OVERHEAT;
> 
> if (temp < info->pdata->min_temp)
>     health = POWER_SUPPLY_HEALTH_COLD;

Will add in v2, thanks.

> 
> > +	else if (vocv < info->pdata->min_volt)
> > +		health = POWER_SUPPLY_HEALTH_DEAD;
> > +	else
> > +		health = POWER_SUPPLY_HEALTH_GOOD;
> > +
> > +health_read_fail:
> > +	return health;
> > +}
> >
> > [...]
> >
> > +static int axp288_fuel_gauge_remove(struct platform_device *pdev)
> > +{
> > +	return 0;
> > +}
> 
> You can drop this function if nothing needs to be cleaned, but
> that's not the case, so where is the cleanup code?

You're right, I believe it needs:

cancel_delayed_work_sync(&info->status_monitor);
power_supply_unregister(&info->bat);

will add in v2, thanks

> 
> > [...]
> 
> -- Sebastian


