Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326AbaGQJ7E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 05:59:04 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48689 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755423AbaGQJ7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 05:59:01 -0400
Date: Thu, 17 Jul 2014 11:58:55 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Feuerer <peter@piie.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Zhang Rui <rui.zhang@intel.com>, Andreas Mohr <andi@lisas.de>,
        Borislav Petkov <bp@suse.de>, Javi Merino <javi.merino@arm.com>
Subject: Re: [PATCH v3 3/6] thermal: Added Bang-bang thermal governor
Message-ID: <20140717095855.GC23869@pd.tnic>
References: <1398561815-22033-1-git-send-email-peter@piie.net>
 <1399139966-10625-1-git-send-email-peter@piie.net>
 <1399139966-10625-4-git-send-email-peter@piie.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1399139966-10625-4-git-send-email-peter@piie.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2014 at 07:59:23PM +0200, Peter Feuerer wrote:
> The bang-bang thermal governor uses a hysteresis to switch abruptly on
> or off a cooling device.  It is intended to control fans, which can
> not be throttled but just switched on or off.
> Bang-bang cannot be set as default governor as it is intended for
> special devices only.  For those special devices the driver needs to
> explicitely request it.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Andreas Mohr <andi@lisas.de>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Javi Merino <javi.merino@arm.com>
> Signed-off-by: Peter Feuerer <peter@piie.net>

...

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
> +		/* in case fan is in initial state, switch the fan off */
> +		if (instance->target == THERMAL_NO_TARGET)
> +			instance->target = 0;
> +
> +		/* in case fan is neither on nor off set the fan to active */
> +		if (instance->target != 0 && instance->target != 1) {

->target is unsigned long so

		if (instance->target > 1)

(and btw, a whole unsigned long for a cooling state... 2^64-1 cooling
states, nice).

> +			pr_warn("Thermal instance %s controlled by bang-bang has unexpected state: %ld\n",
> +					instance->name, instance->target);
> +			instance->target = 1;
> +		}

Can that even happen?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
