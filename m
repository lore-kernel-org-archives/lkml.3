Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116AbaD2Vbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 17:31:47 -0400
Received: from smtprelay02.ispgateway.de ([80.67.31.25]:52147 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757271AbaD2Vbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 17:31:46 -0400
References: <1398561815-22033-1-git-send-email-peter@piie.net> <1398763077-5542-1-git-send-email-peter@piie.net> <1398763077-5542-4-git-send-email-peter@piie.net> <20140429155323.GB31488@e102654-lin.cambridge.arm.com> <cone.1398789448.90431.1768.1000@galar>
Message-ID: <cone.1398807102.60735.1768.1000@galar>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Peter Feuerer <peter@piie.net>
Cc: Javi Merino <javi.merino@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Andreas Mohr <andi@lisas.de>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v2 3/4] thermal: Added Bang-bang thermal governor
Date: Tue, 29 Apr 2014 23:31:42 +0200
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Df-Sender: NDA0MDk0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Javi,

Peter Feuerer writes:

> Javi Merino writes:
[...]

>>> diff --git a/drivers/thermal/gov_bang_bang.c b/drivers/thermal/gov_bang_bang.c
>>> new file mode 100644
>>> index 0000000..328dde0
>>> --- /dev/null
>>> +++ b/drivers/thermal/gov_bang_bang.c
>>> @@ -0,0 +1,124 @@
>>> +/*
>>> + *  gov_bang_bang.c - A simple thermal throttling governor using hysteresis
>>> + *
>>> + *  Copyright (C) 2014 Peter Feuerer <peter@piie.net>
>>> + *
>>> + *  Based on step_wise.c with following Copyrights:
>>> + *  Copyright (C) 2012 Intel Corp
>>> + *  Copyright (C) 2012 Durgadoss R <durgadoss.r@intel.com>
>>> + *
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify
>>> + * it under the terms of the GNU General Public License as published by
>>> + * the Free Software Foundation, version 2.
>>> + *
>>> + * This program is distributed in the hope that it will be useful,
>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
>>> + * the GNU General Public License for more details.
>>> + *
>>> + */
>>> +
>>> +#include <linux/thermal.h>
>>> +
>>> +#include "thermal_core.h"
>>> +
>>> +static void thermal_zone_trip_update(struct thermal_zone_device *tz, int trip)
>>> +{
>>> +	long trip_temp;
>>> +	unsigned long trip_hyst;
>>> +	struct thermal_instance *instance;
>>> +
>>> +	tz->ops->get_trip_temp(tz, trip, &trip_temp);
>>> +	tz->ops->get_trip_hyst(tz, trip, &trip_hyst);
>>> +
>>> +	dev_dbg(&tz->device, "Trip%d[temp=%ld]:temp=%d:hyst=%ld\n",
>>> +				trip, trip_temp, tz->temperature,
>>> +				trip_hyst);
>>> +
>>> +	mutex_lock(&tz->lock);
>>> +
>>> +	list_for_each_entry(instance, &tz->thermal_instances, tz_node) {
>>> +		if (instance->trip != trip)
>>> +			continue;
>>> +
>>> +		/* in case fan is neither on nor off set the fan to active */
>>> +		if (instance->target != 0 && instance->target != 1)
>>> +			instance->target = 1;
>> 
>> I think you should add a pr_warn() here to warn the user that the
>> governor is being used with a cooling device that seems to support
>> more than one cooling state.
> 
> Strange thing is, that the first time it is actually called with acerhdf 
> attached, it comes in with instance→target = -1 … I did not yet find out, 
> why.
> 
> I'll further investigate on this and add some warning to it.

I found out, that the default init state of a cooling device is:

drivers/thermal/thermal_core.c:
 960         dev->target = THERMAL_NO_TARGET;

While drivers/thermal/thermal_core.h:
 30 /* Initial state of a cooling device during binding */
 31 #define THERMAL_NO_TARGET -1UL


So I changed my patch to this:

+               /* in case fan is in initial state, switch the fan off */
+               if (instance->target == THERMAL_NO_TARGET)
+                       instance->target = 0;
+
+               /* in case fan is neither on nor off set the fan to active */
+               if (instance->target != 0 && instance->target != 1) {
+                       pr_warn("Thermal instance %s controlled by bang-bang has unexpected state: %ld\n",
+                                       instance->name, instance->target);
+                       instance->target = 1;
+               }


-- 
kind regards,
--peter;
