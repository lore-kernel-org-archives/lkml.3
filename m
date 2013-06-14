Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759547Ab3FNCgE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:36:04 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:51576 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab3FNCgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:36:02 -0400
X-AuditID: 9c930197-b7b8cae000003b08-01-51ba8190f656
From: Namhyung Kim <namhyung@kernel.org>
To: Robert Richter <rric@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@linaro.org>
Subject: Re: [PATCH v2 13/14] perf, persistent: Exposing persistent events using sysfs
References: <1370968960-22527-1-git-send-email-rric@kernel.org>
	<1370968960-22527-14-git-send-email-rric@kernel.org>
Date: Fri, 14 Jun 2013 11:36:00 +0900
In-Reply-To: <1370968960-22527-14-git-send-email-rric@kernel.org> (Robert
	Richter's message of "Tue, 11 Jun 2013 18:42:39 +0200")
Message-ID: <87a9mt2zcf.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jun 2013 18:42:39 +0200, Robert Richter wrote:
> From: Robert Richter <robert.richter@linaro.org>
>
> Expose persistent events in the system to userland using sysfs. Perf
> tools are able to read existing pmu events from sysfs. Now we use a
> persistent pmu as an event container containing all registered
> persistent events of the system. This patch adds dynamically
> registration of persistent events to sysfs. E.g. something like this:
>
>  /sys/bus/event_source/devices/persistent/events/mce_record:persistent,config=106
>  /sys/bus/event_source/devices/persistent/format/persistent:attr5:23
>
> Perf tools need to support the attr<num> syntax that is added in a
> separate patch set. With it we are able to run perf tool commands to
> read persistent events, e.g.:
>
>  # perf record -e persistent/mce_record/ sleep 10
>  # perf top -e persistent/mce_record/
>
> [ Document attr<index> syntax in sysfs ABI ]
> Reported-by: Jiri Olsa <jolsa@redhat.com>
> Signed-off-by: Robert Richter <robert.richter@linaro.org>
> Signed-off-by: Robert Richter <rric@kernel.org>
> ---
[SNIP]
> +static int pers_event_sysfs_register(struct pers_event *event)
> +{
> +	struct device_attribute *attr = &event->sysfs.attr;
> +	int idx;
> +
> +	*attr = (struct device_attribute)__ATTR(, 0444, pers_event_sysfs_show,
> +						NULL);
> +	attr->attr.name = event->name;

When I added another persistent event with this API, I got an WARNING
from lockdep like this:

[    0.432506] BUG: key ffff88040946f140 not in .data!
[    0.432581] ------------[ cut here ]------------
[    0.432656] WARNING: at /home/namhyung/project/linux/kernel/lockdep.c:2987 lockdep_init_map+0x53d/0x570()
[    0.432763] DEBUG_LOCKS_WARN_ON(1)


I guess we need the following line here:

	sysfs_attr_init(&attr->attr);


Thanks,
Namhyung


> +
> +	/* add sysfs attr to events: */
> +	for (idx = 0; idx < MAX_EVENTS; idx++) {
> +		if (!cmpxchg(persistent_events_attr + idx, NULL, &attr->attr))
> +			break;
> +	}
> +
> +	if (idx >= MAX_EVENTS)
> +		return -ENOSPC;
> +	if (!idx)
> +		EVENTS_GROUP = &persistent_events_group;
> +	if (!persistent_pmu.dev)
> +		return 0;	/* sysfs not yet initialized */
> +	if (idx)
> +		return sysfs_update_group(&persistent_pmu.dev->kobj,
> +					EVENTS_GROUP);
> +	return sysfs_create_group(&persistent_pmu.dev->kobj, EVENTS_GROUP);
> +}
>  
>  static int persistent_pmu_init(struct perf_event *event)
>  {
