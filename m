Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab3BCLRW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 06:17:22 -0500
Received: from softlayer.compulab.co.il ([50.23.254.55]:54984 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268Ab3BCLRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 06:17:20 -0500
Message-ID: <510E473C.2040805@compulab.co.il>
Date: Sun, 03 Feb 2013 13:17:16 +0200
From: Andrey Gelman <andreyg@compulab.co.il>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Anton Vorontsov <anton@enomsg.org>
CC: dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: A patch to test_power module
References: <510591F7.5080005@compulab.co.il> <20130203033917.GE25016@lizard.sbx00618.mountca.wayport.net>
In-Reply-To: <20130203033917.GE25016@lizard.sbx00618.mountca.wayport.net>
Content-Type: multipart/mixed;
 boundary="------------030906020001060002080603"
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Get-Message-Sender-Via: softlayer.compulab.co.il: acl_c_relayhosts_text_entry: andreyg@compulab.co.il|compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030906020001060002080603
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/03/2013 05:39 AM, Anton Vorontsov wrote:
> On Sun, Jan 27, 2013 at 10:45:43PM +0200, Andrey Gelman wrote:
>>      Hello !
>>      This patch fixes 2 issues in test_power module:
>>      1. the mapping of ac_online parameter to its string value "on / off"
>>      was swapped.
>>      2. more important ...
>>      You could not insmod test_power with module parameters, without
>>      causing kernel crash.
>>      The reason is that in test_power, setting module parameter value has
>>      side effect - power_supply_changed event.
>>      As the module parameters are processed prior to calling module_init,
>>      power_supply_changed event is generated on behalf module that is not
>>      yet initialized, causing some NULL pointer dereference.
>>
>>      My solution is to test whether the module has been initialized,
>>      prior to calling power_supply_changed.
>
> Hi!
>
> The patch looks good, but it is missing Signed-off-by tag. Plus, you
> should also Cc: linux-kernel@vger.kernel.org on submissions (I've added it
> now).
>
> Plus, please don't use html in emails. :)
>
> Thanks a lot!
>
> Anton
>
>>  From ccd5b3e916477a3c2a51bbf10a3be8e01f3c85e4 Mon Sep 17 00:00:00 2001
>> From: Andrey Gelman <andreyg@compulab.co.il>
>> Date: Sun, 27 Jan 2013 22:16:33 +0200
>> Subject: [PATCH] test_power: fix a bug in setting module parameter values
>>
>> When the kernel loads a module, module params are processed
>> prior to calling module_init. As a result, setting module param
>> value should not have side effects, at least as long as the
>> module has not been initialized.
>> ---
>>   drivers/power/test_power.c |   31 +++++++++++++++++++++----------
>>   1 file changed, 21 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/power/test_power.c b/drivers/power/test_power.c
>> index b99a452..753a74f 100644
>> --- a/drivers/power/test_power.c
>> +++ b/drivers/power/test_power.c
>> @@ -30,6 +30,8 @@ static int battery_technology		= POWER_SUPPLY_TECHNOLOGY_LION;
>>   static int battery_capacity		= 50;
>>   static int battery_voltage		= 3300;
>>
>> +static bool module_initialized	= false;
>> +
>>   static int test_power_get_ac_property(struct power_supply *psy,
>>   				      enum power_supply_property psp,
>>   				      union power_supply_propval *val)
>> @@ -185,6 +187,7 @@ static int __init test_power_init(void)
>>   		}
>>   	}
>>
>> +	module_initialized = true;
>>   	return 0;
>>   failed:
>>   	while (--i >= 0)
>> @@ -209,6 +212,8 @@ static void __exit test_power_exit(void)
>>
>>   	for (i = 0; i < ARRAY_SIZE(test_power_supplies); i++)
>>   		power_supply_unregister(&test_power_supplies[i]);
>> +
>> +	module_initialized = false;
>>   }
>>   module_exit(test_power_exit);
>>
>> @@ -221,8 +226,8 @@ struct battery_property_map {
>>   };
>>
>>   static struct battery_property_map map_ac_online[] = {
>> -	{ 0,  "on"  },
>> -	{ 1,  "off" },
>> +	{ 0,  "off"  },
>> +	{ 1,  "on" },
>>   	{ -1, NULL  },
>>   };
>>
>> @@ -295,10 +300,16 @@ static const char *map_get_key(struct battery_property_map *map, int value,
>>   	return def_key;
>>   }
>>
>> +static inline void signal_power_supply_changed(struct power_supply *psy)
>> +{
>> +	if (module_initialized)
>> +		power_supply_changed(psy);
>> +}
>> +
>>   static int param_set_ac_online(const char *key, const struct kernel_param *kp)
>>   {
>>   	ac_online = map_get_value(map_ac_online, key, ac_online);
>> -	power_supply_changed(&test_power_supplies[0]);
>> +	signal_power_supply_changed(&test_power_supplies[0]);
>>   	return 0;
>>   }
>>
>> @@ -311,7 +322,7 @@ static int param_get_ac_online(char *buffer, const struct kernel_param *kp)
>>   static int param_set_usb_online(const char *key, const struct kernel_param *kp)
>>   {
>>   	usb_online = map_get_value(map_ac_online, key, usb_online);
>> -	power_supply_changed(&test_power_supplies[2]);
>> +	signal_power_supply_changed(&test_power_supplies[2]);
>>   	return 0;
>>   }
>>
>> @@ -325,7 +336,7 @@ static int param_set_battery_status(const char *key,
>>   					const struct kernel_param *kp)
>>   {
>>   	battery_status = map_get_value(map_status, key, battery_status);
>> -	power_supply_changed(&test_power_supplies[1]);
>> +	signal_power_supply_changed(&test_power_supplies[1]);
>>   	return 0;
>>   }
>>
>> @@ -339,7 +350,7 @@ static int param_set_battery_health(const char *key,
>>   					const struct kernel_param *kp)
>>   {
>>   	battery_health = map_get_value(map_health, key, battery_health);
>> -	power_supply_changed(&test_power_supplies[1]);
>> +	signal_power_supply_changed(&test_power_supplies[1]);
>>   	return 0;
>>   }
>>
>> @@ -353,7 +364,7 @@ static int param_set_battery_present(const char *key,
>>   					const struct kernel_param *kp)
>>   {
>>   	battery_present = map_get_value(map_present, key, battery_present);
>> -	power_supply_changed(&test_power_supplies[0]);
>> +	signal_power_supply_changed(&test_power_supplies[0]);
>>   	return 0;
>>   }
>>
>> @@ -369,7 +380,7 @@ static int param_set_battery_technology(const char *key,
>>   {
>>   	battery_technology = map_get_value(map_technology, key,
>>   						battery_technology);
>> -	power_supply_changed(&test_power_supplies[1]);
>> +	signal_power_supply_changed(&test_power_supplies[1]);
>>   	return 0;
>>   }
>>
>> @@ -390,7 +401,7 @@ static int param_set_battery_capacity(const char *key,
>>   		return -EINVAL;
>>
>>   	battery_capacity = tmp;
>> -	power_supply_changed(&test_power_supplies[1]);
>> +	signal_power_supply_changed(&test_power_supplies[1]);
>>   	return 0;
>>   }
>>
>> @@ -405,7 +416,7 @@ static int param_set_battery_voltage(const char *key,
>>   		return -EINVAL;
>>
>>   	battery_voltage = tmp;
>> -	power_supply_changed(&test_power_supplies[1]);
>> +	signal_power_supply_changed(&test_power_supplies[1]);
>>   	return 0;
>>   }
>>
>> --
>> 1.7.9.5

Fixed ... I think.
Thank you,
Andrey


--------------030906020001060002080603
Content-Type: text/x-patch;
 name="test_power.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="test_power.patch"

>From cc873c2cddd8c7457ad807d71ebada42754638dd Mon Sep 17 00:00:00 2001
From: Andrey Gelman <andreyg@compulab.co.il>
Date: Sun, 27 Jan 2013 22:16:33 +0200
Subject: [PATCH] test_power: fix a bug in setting module parameter values

When the kernel loads a module, module params are processed
prior to calling module_init. As a result, setting module param
value should not have side effects, at least as long as the
module has not been initialized.

Signed-off-by: Andrey Gelman <andreyg@compulab.co.il>
---
 drivers/power/test_power.c |   31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/power/test_power.c b/drivers/power/test_power.c
index b99a452..753a74f 100644
--- a/drivers/power/test_power.c
+++ b/drivers/power/test_power.c
@@ -30,6 +30,8 @@ static int battery_technology		= POWER_SUPPLY_TECHNOLOGY_LION;
 static int battery_capacity		= 50;
 static int battery_voltage		= 3300;
 
+static bool module_initialized	= false;
+
 static int test_power_get_ac_property(struct power_supply *psy,
 				      enum power_supply_property psp,
 				      union power_supply_propval *val)
@@ -185,6 +187,7 @@ static int __init test_power_init(void)
 		}
 	}
 
+	module_initialized = true;
 	return 0;
 failed:
 	while (--i >= 0)
@@ -209,6 +212,8 @@ static void __exit test_power_exit(void)
 
 	for (i = 0; i < ARRAY_SIZE(test_power_supplies); i++)
 		power_supply_unregister(&test_power_supplies[i]);
+
+	module_initialized = false;
 }
 module_exit(test_power_exit);
 
@@ -221,8 +226,8 @@ struct battery_property_map {
 };
 
 static struct battery_property_map map_ac_online[] = {
-	{ 0,  "on"  },
-	{ 1,  "off" },
+	{ 0,  "off"  },
+	{ 1,  "on" },
 	{ -1, NULL  },
 };
 
@@ -295,10 +300,16 @@ static const char *map_get_key(struct battery_property_map *map, int value,
 	return def_key;
 }
 
+static inline void signal_power_supply_changed(struct power_supply *psy)
+{
+	if (module_initialized)
+		power_supply_changed(psy);
+}
+
 static int param_set_ac_online(const char *key, const struct kernel_param *kp)
 {
 	ac_online = map_get_value(map_ac_online, key, ac_online);
-	power_supply_changed(&test_power_supplies[0]);
+	signal_power_supply_changed(&test_power_supplies[0]);
 	return 0;
 }
 
@@ -311,7 +322,7 @@ static int param_get_ac_online(char *buffer, const struct kernel_param *kp)
 static int param_set_usb_online(const char *key, const struct kernel_param *kp)
 {
 	usb_online = map_get_value(map_ac_online, key, usb_online);
-	power_supply_changed(&test_power_supplies[2]);
+	signal_power_supply_changed(&test_power_supplies[2]);
 	return 0;
 }
 
@@ -325,7 +336,7 @@ static int param_set_battery_status(const char *key,
 					const struct kernel_param *kp)
 {
 	battery_status = map_get_value(map_status, key, battery_status);
-	power_supply_changed(&test_power_supplies[1]);
+	signal_power_supply_changed(&test_power_supplies[1]);
 	return 0;
 }
 
@@ -339,7 +350,7 @@ static int param_set_battery_health(const char *key,
 					const struct kernel_param *kp)
 {
 	battery_health = map_get_value(map_health, key, battery_health);
-	power_supply_changed(&test_power_supplies[1]);
+	signal_power_supply_changed(&test_power_supplies[1]);
 	return 0;
 }
 
@@ -353,7 +364,7 @@ static int param_set_battery_present(const char *key,
 					const struct kernel_param *kp)
 {
 	battery_present = map_get_value(map_present, key, battery_present);
-	power_supply_changed(&test_power_supplies[0]);
+	signal_power_supply_changed(&test_power_supplies[0]);
 	return 0;
 }
 
@@ -369,7 +380,7 @@ static int param_set_battery_technology(const char *key,
 {
 	battery_technology = map_get_value(map_technology, key,
 						battery_technology);
-	power_supply_changed(&test_power_supplies[1]);
+	signal_power_supply_changed(&test_power_supplies[1]);
 	return 0;
 }
 
@@ -390,7 +401,7 @@ static int param_set_battery_capacity(const char *key,
 		return -EINVAL;
 
 	battery_capacity = tmp;
-	power_supply_changed(&test_power_supplies[1]);
+	signal_power_supply_changed(&test_power_supplies[1]);
 	return 0;
 }
 
@@ -405,7 +416,7 @@ static int param_set_battery_voltage(const char *key,
 		return -EINVAL;
 
 	battery_voltage = tmp;
-	power_supply_changed(&test_power_supplies[1]);
+	signal_power_supply_changed(&test_power_supplies[1]);
 	return 0;
 }
 
-- 
1.7.9.5


--------------030906020001060002080603--
