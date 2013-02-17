Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab3BQPmD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 10:42:03 -0500
Received: from smtprelay04.ispgateway.de ([80.67.31.32]:53599 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab3BQPmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 10:42:01 -0500
References: <20130214153255.GA5033@rhlx01.hs-esslingen.de> <744357E9AAD1214791ACBA4B0B90926329ED72@SHSMSX101.ccr.corp.intel.com> <20130215154931.GA26213@rhlx01.hs-esslingen.de> <CACWwPiuk0GynEwe3RuKndWnsYwTuPhO0ob6sJ6ve34u1_RtkYw@mail.gmail.com> <20130216214712.GA13494@pd.tnic> <cone.1361068993.271211.4532.1000@galar> <20130217140908.GA20323@pd.tnic>
Message-ID: <cone.1361115717.636831.25189.1000@galar>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Borislav Petkov <bp@alien8.de>
Cc: Alexander Lam <azl@andrew.cmu.edu>,
        =?UTF-8?B?bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw==?= 
	<linux-kernel@vger.kernel.org>,
        Andreas Mohr <andi@lisas.de>
Subject: Re: thermal governor: does it actually work??
Date: Sun, 17 Feb 2013 16:41:57 +0100
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: NDA0MDk0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Borislav Petkov writes:
> On Sun, Feb 17, 2013 at 03:43:13AM +0100, Peter Feuerer wrote:
>> From 7b39bd8837de6dc5658ac3e54ac5d4df9d351528 Mon Sep 17 00:00:00 2001
>> From: Peter Feuerer <peter@piie.net>
>> Date: Sun, 17 Feb 2013 03:29:19 +0100
>> Subject: [PATCH] added two more trip points to acerhdf, this allows thermal
>>  layer to correctly handle the two point regulation of acerhdf. Trip point 0
>>  will be active from 0 degree to "fanoff" and is marked as passive, then trip
>>  point 1 is valid from "fanoff" to "fanon" value and is marked as active,
>>  even if it's only really active in case temperature is going down from trip
>>  point 2. Trip point 2 will be valid above "fanon" value and is also marked
>>  as active.
> 
> Right, so this is clearly something new in the thermal pile of code. I
> still don't understand the big picture all that clearly but whatever...

Don't think so, I think this was already in since 2.6.<something> and I 
assume with this patch applied, acerhdf works from at least this 
2.6.<something> up to new 3.8 and will still work in the future.


>> ---
>>  drivers/platform/x86/acerhdf.c | 15 ++++++++++++---
>>  1 file changed, 12 insertions(+), 3 deletions(-)
>> 
>> diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
>> index f94467c..c36633b 100644
>> --- a/drivers/platform/x86/acerhdf.c
>> +++ b/drivers/platform/x86/acerhdf.c
>> @@ -400,6 +400,10 @@ static int acerhdf_get_trip_type(struct thermal_zone_device *thermal, int trip,
>>  				 enum thermal_trip_type *type)
>>  {
>>  	if (trip == 0)
>> +		*type = THERMAL_TRIP_PASSIVE;
>> +	if (trip == 1)
>> +		*type = THERMAL_TRIP_ACTIVE;
>> +	if (trip == 2)
>>  		*type = THERMAL_TRIP_ACTIVE;
> 
> So, digging deep into thermal_sys.c, those naked numbers which we get
> handed down for 'trip' are some sort of trip points. Now, I'd very much
> like to know what those are and there are no defines what they mean -
> code simply iterates over a number of thermal_zone trips - tz->trips -
> and we (try to) act accordingly.

As far as I understand the code (and Documentation/thermal/cpu-cooling-api.txt),
the thermal api finds the appropriate trip point and then set's the fan to 
the corresponding state, defined by the thermal/fan driver. This is nice 
thing, if you can completely control the speed of the fan, because you have 
then a good fan speed to temperature regulation. But we do only have a two 
point regulation (on and off), that's why we have to handle our thresholds 
within the trip=1 on our own to not get an all the time on-off-toggling of 
the fan.


> Now this is very fragile, IMO.

I think this is how the developer of thermal_sys intended drivers to work. 
But he forgot about two-point regulators (most probably because there's no 
one besides acerhdf)


> /me stares at the code a bit more.
> 
> Ok, from the looks of it, I'm guessing each driver has to do its own
> mapping of what each trip point is, IIUC. And the thermal_zone doodles
> over those and for those which the driver has defined, it asks the
> driver itself what it wants done (i.e. ->get_trip_temp) and, in our case
> it doesn't do anything...

I don't understand what you mean by "in our case it doesn't do anything", 
acerhdf is reporting the trip temperatures correctly, when get_trip_temp is 
called.



> Also, come to think of it, why don't we have THERMAL_TRIP_CRITICAL and
> THERMAL_TRIP_HOT trip types?

You are right, we should at least add the THERMAL_TRIP_CRITICAL, so that we 
handle this, but I think we can ignore THERMAL_TRIP_HOT, as it is not really 
serving anything of value in our case.


> 
>>  	return 0;
>> @@ -409,6 +413,10 @@ static int acerhdf_get_trip_temp(struct thermal_zone_device *thermal, int trip,
>>  				 unsigned long *temp)
>>  {
>>  	if (trip == 0)
>> +		*temp = 0;
>> +	if (trip == 1)
>> +		*temp = fanoff;
>> +	if (trip == 2)
>>  		*temp = fanon;
> 
> Maybe the critical and hot types need to go here? I.e., 3 and 4?

Yes, crit has to go there.


> 
>>  	return 0;
>> @@ -486,7 +494,8 @@ static int acerhdf_set_cur_state(struct thermal_cooling_device *cdev,
>>  		    (cur_temp < fanoff))
>>  			acerhdf_change_fanstate(ACERHDF_FAN_OFF);
>>  	} else {
>> -		if (cur_state == ACERHDF_FAN_OFF)
>> +		if ((cur_state == ACERHDF_FAN_OFF) &&
>> +		    (cur_temp > fanon))
>>  			acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
> 
> ... and we hook in into the thermal_cdev_update() call here and do the
> correction ourselves.

As I wrote above, the thermal_sys layer do not serve 2 point regulation per 
se, but with this check, we are able to achieve it. - We've done this check 
already partly before:
/* turn fan off only if below fanoff temperature */
if ((cur_state == ACERHDF_FAN_AUTO) &&        
     (cur_temp < fanoff))                         
acerhdf_change_fanstate(ACERHDF_FAN_OFF);


> Oh well. I need to befriend myself with the whole concept of thermal
> - still have a bad feeling about it, like a star wars character:
> http://www.youtube.com/watch?v=sBknAcTaMiI :-)

I still think it is the right way to go, but maybe we should ask Durgadoss 
R <durgadoss.r () intel.com>. It seems like he took over the thermal 
handling by this commit:

commit 0c01ebbfd3caf1dc132e0d93c8e7e9f742839d94
Author: Durgadoss R <durgadoss.r()intel.com>
Date:   Tue Sep 18 11:05:04 2012 +0530

    Thermal: Remove throttling logic out of thermal_sys.c


have a nice sunday evening,
--peter;
