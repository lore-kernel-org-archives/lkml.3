Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbaJGHNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 03:13:23 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:34678 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbaJGHNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 03:13:19 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f156d0000063c7-c2-5433928cb0f4
Content-transfer-encoding: 8BIT
Message-id: <1412665994.11780.3.camel@AMDC1943>
Subject: Re: [PATCH] power: charger-manager: Avoid recursive thermal get_temp
 call
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: jonghwa3.lee@samsung.com
Cc: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 07 Oct 2014 09:13:14 +0200
In-reply-to: <54334E00.9030403@samsung.com>
References: <1412611212-24803-1-git-send-email-k.kozlowski@samsung.com>
 <54334E00.9030403@samsung.com>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsVy+t/xa7o9k4xDDM5tkLQ4uFXT4vqX56wW
	k568Z7aYuHIys0Xn2SfMFpd3zWGz+Nx7hNHiduMKNovTu0scOD0m9H9i9Ng56y67x+YVWh6b
	VnWyefRtWcXo8XmTXABbFJdNSmpOZllqkb5dAlfG3hvWBetUKhbvX8LYwDhftouRk0NCwETi
	0p/TjBC2mMSFe+vZuhi5OIQEljJKNO44yQaS4BUQlPgx+R5LFyMHB7OAvMSRS9kgYWYBdYlJ
	8xYxQ9R/ZpR49f0ZK0S9vsSlLcvZQWxhgRCJ3TMvMYPYbALGEpuXLwGbKSIgI7Hy6k8mkGZm
	gU1MEutezmEBSbAIqErc/NDPCrKMU0Bb4u7vDJCwkECGxP+JE5hBwhICyhKN/W4TGAVmIblu
	FsJ1s5Bct4CReRWjaGppckFxUnquoV5xYm5xaV66XnJ+7iZGSNh/2cG4+JjVIUYBDkYlHt4N
	hsYhQqyJZcWVuYcYJTiYlUR4t1QAhXhTEiurUovy44tKc1KLDzEycXBKNTAuNC2zOqjCNV/r
	fqDl68SOuHtJZWaP+9lf9wcoVD+8PO+n8XW5Su2cxNYj3nd3mB65XCUlfsnCLp911o8uxjvr
	Llh3Gv2+xnfxQliV1cEenj47pz/uLa3tyz2+ipqX3fmz3Pas1nrZe9svL998vfZOh/w2q7d/
	y1IaPp3KyQ0OOXTY41+6dqMSS3FGoqEWc1FxIgBcYdjAWQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On wto, 2014-10-07 at 11:20 +0900, jonghwa3.lee@samsung.com wrote:
> Hi,
> On 2014년 10월 07일 01:00, Krzysztof Kozlowski wrote:
> 
> > The charger manager supports POWER_SUPPLY_PROP_TEMP property and acts
> > as a thermal zone if any of these conditions match:
> > 1. Fuel gauge used by charger manager supports POWER_SUPPLY_PROP_TEMP.
> > 2. 'cm-thermal-zone' property is present in DTS (then it will supersede
> >    the fuel gauge temperature property).
> > 
> > However in case 1 (fuel gauge reports temperature and 'cm-thermal-zone'
> > is not set) the charger manager forwards its get_temp calls to fuel
> > gauge thermal zone.
> > 
> > This leads to reporting by lockdep a false positive deadlock for thermal
> > zone's mutex because of nested calls to thermal_zone_get_temp(). This is
> > false positive because these are different mutexes: one for charger
> > manager thermal zone and second for fuel gauge thermal zone.
> > 
> 
> 
> Yes, this happens because power_supply_subsystem automatically creates
> thermal_zone when POWER_SUPPLY_PROP_TEMP is available at the time of
> power_supply registering. And as you point out, it makes duplicate thermal_zone
> when some power_supply references other power_supply's. I hope it would become
> to be a selectable option or change the manner of charger-manager itself (if the
> charger-manager is only one who references other power_supply's temperature
> sensing ability).
> 
> Anyway, the code looks fine to me.
> 
> Acked-by : Jonghwa Lee <jonghwa3.lee@samsung.com>

Thank you for looking at patch. However later I started to wonder
whether my fix is sufficient. For the case when fuel gauge is used as
source of temperature it is. But for the case when external sensor is
used it is not - still there will be recursive call and false positive
from lockdep.

Also minor fix is needed in my patch - s/IS_ENABLED/config_enabled/.

I can send a v2 fixing this but first question - what about second
recursive issue (when external sensor is used instead of fuel gauge)?

Best regards,
Krzysztof


> 
> Thanks,
> Jonghwa.
> 
> > Get rid of false lockdep alert and recursive call by accessing fuel gauge
> > temperature through power supply property instead of thermal zone API.
> > 
> 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  drivers/power/charger-manager.c       | 21 +++++++++++----------
> >  include/linux/power/charger-manager.h |  2 --
> >  2 files changed, 11 insertions(+), 12 deletions(-)
> > 
> > diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
> > index c1ed3c99c059..871fb91429c8 100644
> > --- a/drivers/power/charger-manager.c
> > +++ b/drivers/power/charger-manager.c
> > @@ -559,16 +559,18 @@ static int cm_get_battery_temperature(struct charger_manager *cm,
> >  	if (!cm->desc->measure_battery_temp)
> >  		return -ENODEV;
> >  
> > -#ifdef CONFIG_THERMAL
> > -	ret = thermal_zone_get_temp(cm->tzd_batt, (unsigned long *)temp);
> > -	if (!ret)
> > -		/* Calibrate temperature unit */
> > -		*temp /= 100;
> > -#else
> > -	ret = cm->fuel_gauge->get_property(cm->fuel_gauge,
> > +	if (IS_ENABLED(CONFIG_THERMAL) && cm->tzd_batt) {
> > +		ret = thermal_zone_get_temp(cm->tzd_batt, (unsigned long *)temp);
> > +		if (!ret)
> > +			/* Calibrate temperature unit */
> > +			*temp /= 100;
> > +	} else {
> > +		/* No external thermometer or no CONFIG_THERMAL */
> > +		ret = cm->fuel_gauge->get_property(cm->fuel_gauge,
> >  				POWER_SUPPLY_PROP_TEMP,
> >  				(union power_supply_propval *)temp);
> > -#endif
> > +	}
> > +
> >  	return ret;
> >  }
> >  
> > @@ -1501,9 +1503,8 @@ static int cm_init_thermal_data(struct charger_manager *cm)
> >  		cm->charger_psy.num_properties++;
> >  		cm->desc->measure_battery_temp = true;
> >  	}
> > -#ifdef CONFIG_THERMAL
> > -	cm->tzd_batt = cm->fuel_gauge->tzd;
> >  
> > +#ifdef CONFIG_THERMAL
> >  	if (ret && desc->thermal_zone) {
> >  		cm->tzd_batt =
> >  			thermal_zone_get_zone_by_name(desc->thermal_zone);
> > diff --git a/include/linux/power/charger-manager.h b/include/linux/power/charger-manager.h
> > index 07e7945a1ff2..743ed6d472c6 100644
> > --- a/include/linux/power/charger-manager.h
> > +++ b/include/linux/power/charger-manager.h
> > @@ -256,9 +256,7 @@ struct charger_manager {
> >  	struct power_supply *fuel_gauge;
> >  	struct power_supply **charger_stat;
> >  
> > -#ifdef CONFIG_THERMAL
> >  	struct thermal_zone_device *tzd_batt;
> > -#endif
> >  	bool charger_enabled;
> >  
> >  	unsigned long fullbatt_vchk_jiffies_at;
> 

