Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761776AbaGRQYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 12:24:35 -0400
Received: from smtprelay04.ispgateway.de ([80.67.31.38]:51880 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741AbaGRQYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 12:24:34 -0400
References: <1398561815-22033-1-git-send-email-peter@piie.net> <1399139966-10625-1-git-send-email-peter@piie.net> <1399139966-10625-4-git-send-email-peter@piie.net> <20140717095855.GC23869@pd.tnic>
Message-ID: <cone.1405700669.905673.1043.1000@galar>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Zhang Rui <rui.zhang@intel.com>, Andreas Mohr <andi@lisas.de>,
        Borislav Petkov <bp@suse.de>, Javi Merino <javi.merino@arm.com>
Subject: Re: [PATCH v3 3/6] thermal: Added Bang-bang thermal governor
Date: Fri, 18 Jul 2014 18:24:29 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: NDA0MDk0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov writes:

> On Sat, May 03, 2014 at 07:59:23PM +0200, Peter Feuerer wrote:
>> The bang-bang thermal governor uses a hysteresis to switch abruptly on
>> or off a cooling device.  It is intended to control fans, which can
>> not be throttled but just switched on or off.
>> Bang-bang cannot be set as default governor as it is intended for
>> special devices only.  For those special devices the driver needs to
>> explicitely request it.
>> 
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Zhang Rui <rui.zhang@intel.com>
>> Cc: Andreas Mohr <andi@lisas.de>
>> Cc: Borislav Petkov <bp@suse.de>
>> Cc: Javi Merino <javi.merino@arm.com>
>> Signed-off-by: Peter Feuerer <peter@piie.net>
> 
> ...
> 
>> +static void thermal_zone_trip_update(struct thermal_zone_device *tz, int trip)
>> +{
>> +	long trip_temp;
>> +	unsigned long trip_hyst;
>> +	struct thermal_instance *instance;
>> +
>> +	tz->ops->get_trip_temp(tz, trip, &trip_temp);
>> +	tz->ops->get_trip_hyst(tz, trip, &trip_hyst);
>> +
>> +	dev_dbg(&tz->device, "Trip%d[temp=%ld]:temp=%d:hyst=%ld\n",
>> +				trip, trip_temp, tz->temperature,
>> +				trip_hyst);
>> +
>> +	mutex_lock(&tz->lock);
>> +
>> +	list_for_each_entry(instance, &tz->thermal_instances, tz_node) {
>> +		if (instance->trip != trip)
>> +			continue;
>> +
>> +		/* in case fan is in initial state, switch the fan off */
>> +		if (instance->target == THERMAL_NO_TARGET)
>> +			instance->target = 0;
>> +
>> +		/* in case fan is neither on nor off set the fan to active */
>> +		if (instance->target != 0 && instance->target != 1) {
> 
> ->target is unsigned long so
> 
> 		if (instance->target > 1)

Right, but I wanted to clearly point out the two possible states.


> (and btw, a whole unsigned long for a cooling state... 2^64-1 cooling
> states, nice).

Hehe, true, maybe u8 makes more sense, so the compiler can take the action to align it accordingly to prevent bit shifting.

> 
>> +			pr_warn("Thermal instance %s controlled by bang-bang has unexpected state: %ld\n",
>> +					instance->name, instance->target);
>> +			instance->target = 1;
>> +		}
> 
> Can that even happen?

It should not, but if so, we have a warning and I have the feeling we should 
keep it there.

-- 
--peter;
