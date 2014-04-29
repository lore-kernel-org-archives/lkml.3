Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142AbaD2Px3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 11:53:29 -0400
Received: from service87.mimecast.com ([91.220.42.44]:47321 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaD2Px1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 11:53:27 -0400
Date: Tue, 29 Apr 2014 16:53:23 +0100
From: Javi Merino <javi.merino@arm.com>
To: Peter Feuerer <peter@piie.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Andreas Mohr <andi@lisas.de>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v2 3/4] thermal: Added Bang-bang thermal governor
Message-ID: <20140429155323.GB31488@e102654-lin.cambridge.arm.com>
References: <1398561815-22033-1-git-send-email-peter@piie.net>
 <1398763077-5542-1-git-send-email-peter@piie.net>
 <1398763077-5542-4-git-send-email-peter@piie.net>
MIME-Version: 1.0
In-Reply-To: <1398763077-5542-4-git-send-email-peter@piie.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 29 Apr 2014 15:53:39.0178 (UTC) FILETIME=[2FFAECA0:01CF63C3]
X-MC-Unique: 114042916532515201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 10:17:56AM +0100, Peter Feuerer wrote:
> The bang-bang thermal governor uses a hysteresis to switch abruptly on
> or off a cooling device.  It is intended to control fans, which can
> not be throttled but just switched on or off.
> Bang-bang cannot be set as default governor as it is intended for
> special devices only.  For those special devices the driver needs to
> explicitely request it.

I don't really understand why step-wise doesn't work for you (AIUI,
this governor should be a subset of it.  I'll let others comment on
that, just a minor comment below.

[...]
> diff --git a/drivers/thermal/gov_bang_bang.c b/drivers/thermal/gov_bang_bang.c
> new file mode 100644
> index 0000000..328dde0
> --- /dev/null
> +++ b/drivers/thermal/gov_bang_bang.c
> @@ -0,0 +1,124 @@
> +/*
> + *  gov_bang_bang.c - A simple thermal throttling governor using hysteresis
> + *
> + *  Copyright (C) 2014 Peter Feuerer <peter@piie.net>
> + *
> + *  Based on step_wise.c with following Copyrights:
> + *  Copyright (C) 2012 Intel Corp
> + *  Copyright (C) 2012 Durgadoss R <durgadoss.r@intel.com>
> + *
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, version 2.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
> + * the GNU General Public License for more details.
> + *
> + */
> +
> +#include <linux/thermal.h>
> +
> +#include "thermal_core.h"
> +
> +static void thermal_zone_trip_update(struct thermal_zone_device *tz, int trip)
> +{
> +	long trip_temp;
> +	unsigned long trip_hyst;
> +	struct thermal_instance *instance;
> +
> +	tz->ops->get_trip_temp(tz, trip, &trip_temp);
> +	tz->ops->get_trip_hyst(tz, trip, &trip_hyst);
> +
> +	dev_dbg(&tz->device, "Trip%d[temp=%ld]:temp=%d:hyst=%ld\n",
> +				trip, trip_temp, tz->temperature,
> +				trip_hyst);
> +
> +	mutex_lock(&tz->lock);
> +
> +	list_for_each_entry(instance, &tz->thermal_instances, tz_node) {
> +		if (instance->trip != trip)
> +			continue;
> +
> +		/* in case fan is neither on nor off set the fan to active */
> +		if (instance->target != 0 && instance->target != 1)
> +			instance->target = 1;

I think you should add a pr_warn() here to warn the user that the
governor is being used with a cooling device that seems to support
more than one cooling state.

Cheers,
Javi

