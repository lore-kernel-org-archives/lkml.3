Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759717AbaJ3NLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 09:11:42 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:30297 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759020AbaJ3NLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:11:40 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-65-5452390978ba
Message-id: <54523907.4030609@samsung.com>
Date: Thu, 30 Oct 2014 14:11:35 +0100
From: =?UTF-8?B?S3J6eXN6dG9mIEtvesWCb3dza2k=?= <k.kozlowski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Jonghwa Lee <jonghwa3.lee@samsung.com>, linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, anton@enomsg.org, pavel@ucw.cz,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com
Subject: Re: [PATCH 01/10] power: charger-manager: Use thermal subsystem
 interface only to get temperature.
References: <1414672996-28355-1-git-send-email-jonghwa3.lee@samsung.com>
 <1414672996-28355-2-git-send-email-jonghwa3.lee@samsung.com>
In-reply-to: <1414672996-28355-2-git-send-email-jonghwa3.lee@samsung.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsVy+t/xy7qclkEhBuu+i1oc3Kppcf3Lc1aL
	SU/eM1tMXDmZ2aLz7BNmi9cvDC0u75rDZvG59wijxe3GFWwWd08dZbM4vbvEgdtjQv8nRo+d
	s+6ye2xeoeWxaVUnm0ffllWMHitWf2f3+LxJLoA9issmJTUnsyy1SN8ugSvj4pTHTAV3pSvm
	vt3M0sDYINbFyMkhIWAisW/FCXYIW0ziwr31bCC2kMBSRokJ21y6GLmA7M+MEjdWzmTpYuTg
	4BXQkmic6AxSwyKgKvGgq5ERxGYT8JCY9r2HGcQWFYiQuLJmDlicV0BQ4sfkeywgtghQzf3W
	TjCbWWANo8S1N2C2sECuxKRnf1kh9rYzSry/DnYPp4CnxOpVk9hB1jILqEtMmZIL0SovsXnN
	W+YJjAKzkGyYhVA1C0nVAkbmVYyiqaXJBcVJ6blGesWJucWleel6yfm5mxghMfF1B+PSY1aH
	GAU4GJV4eCOOBYQIsSaWFVfmHmKU4GBWEuE9qhMUIsSbklhZlVqUH19UmpNafIiRiYNTqoFR
	R+q5fZjCuhWeGRXPyncucmIMPVZ2ZXuE0q1GlYdcf0NbH0XOn5o9yVc1/xCPapVI4uNoAeZl
	3I/MnnMYLPtz2YN338Vfvmz/pkVrtbFb/N0XMJ+hLbDvXZRN7ULtH2cOP+bWkbp26qBFl1ru
	92Kprl3uk9bYOnaJ8lxZt9veJzMkwNy+5Y8SS3FGoqEWc1FxIgCCFup0ZwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.10.2014 13:43, Jonghwa Lee wrote:
> It drops the way of using power_supply interface to reference battery's
> temperature. Then it tries to use thermal subsystem's only. This makes driver
> more simple and also can remove ifdeferies.
> 
> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> ---
>  drivers/power/Kconfig                 |    1 +
>  drivers/power/charger-manager.c       |  113 ++++++++-------------------------
>  include/linux/power/charger-manager.h |    3 +-
>  3 files changed, 28 insertions(+), 89 deletions(-)
> 
> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
> index 8ff2511..115d153 100644
> --- a/drivers/power/Kconfig
> +++ b/drivers/power/Kconfig
> @@ -317,6 +317,7 @@ config CHARGER_MANAGER
>  	bool "Battery charger manager for multiple chargers"
>  	depends on REGULATOR
>  	select EXTCON
> +	select THERMAL

I think both of "select" here could be dangerous. Select should rather
be used for non-visible errors. Just use "depends on".

>  	help
>            Say Y to enable charger-manager support, which allows multiple
>            chargers attached to a battery and multiple batteries attached to a
> diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
> index 22246b9..b4b101c 100644
> --- a/drivers/power/charger-manager.c
> +++ b/drivers/power/charger-manager.c
> @@ -28,13 +28,6 @@
>  #include <linux/of.h>
>  #include <linux/thermal.h>
>  
> -/*
> - * Default termperature threshold for charging.
> - * Every temperature units are in tenth of centigrade.
> - */
> -#define CM_DEFAULT_RECHARGE_TEMP_DIFF	50
> -#define CM_DEFAULT_CHARGE_TEMP_MAX	500
> -
>  static const char * const default_event_names[] = {
>  	[CM_EVENT_UNKNOWN] = "Unknown",
>  	[CM_EVENT_BATT_FULL] = "Battery Full",
> @@ -572,40 +565,18 @@ static int check_charging_duration(struct charger_manager *cm)
>  	return ret;
>  }
>  
> -static int cm_get_battery_temperature_by_psy(struct charger_manager *cm,
> -					int *temp)
> -{
> -	struct power_supply *fuel_gauge;
> -
> -	fuel_gauge = power_supply_get_by_name(cm->desc->psy_fuel_gauge);
> -	if (!fuel_gauge)
> -		return -ENODEV;
> -
> -	return fuel_gauge->get_property(fuel_gauge,
> -				POWER_SUPPLY_PROP_TEMP,
> -				(union power_supply_propval *)temp);
> -}
> -
>  static int cm_get_battery_temperature(struct charger_manager *cm,
>  					int *temp)
>  {
>  	int ret;
>  
> -	if (!cm->desc->measure_battery_temp)
> +	if (!cm->tzd_batt)
>  		return -ENODEV;
>  
> -#ifdef CONFIG_THERMAL
> -	if (cm->tzd_batt) {
> -		ret = thermal_zone_get_temp(cm->tzd_batt, (unsigned long *)temp);
> -		if (!ret)
> -			/* Calibrate temperature unit */
> -			*temp /= 100;
> -	} else
> -#endif
> -	{
> -		/* if-else continued from CONFIG_THERMAL */
> -		ret = cm_get_battery_temperature_by_psy(cm, temp);
> -	}
> +	ret = thermal_zone_get_temp(cm->tzd_batt, (unsigned long *)temp);
> +	if (!ret)
> +		/* Calibrate temperature unit */
> +		*temp /= 100;
>  
>  	return ret;
>  }
> @@ -623,7 +594,7 @@ static int cm_check_thermal_status(struct charger_manager *cm)
>  		 * occur hazadous result. We have to handle it
>  		 * depending on battery type.
>  		 */
> -		dev_err(cm->dev, "Failed to get battery temperature\n");
> +		dev_dbg(cm->dev, "Failed to get battery temperature\n");

A valuable change but not strictly related to the commit. Additionally
that is a user-visible change. Could you split it to separate patch?

Best regards,
Krzysztof

