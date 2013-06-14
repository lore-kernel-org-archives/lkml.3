Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759604Ab3FNCPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:15:17 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:57110 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917Ab3FNCPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:15:15 -0400
X-AuditID: 9c93017e-b7bd9ae000006882-3f-51ba7cb1ed1b
From: Namhyung Kim <namhyung@kernel.org>
To: Robert Richter <rric@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>,
        Robert Richter <robert.richter@linaro.org>
Subject: Re: [PATCH v2 03/14] perf: Add persistent event facilities
References: <1370968960-22527-1-git-send-email-rric@kernel.org>
	<1370968960-22527-4-git-send-email-rric@kernel.org>
Date: Fri, 14 Jun 2013 11:15:13 +0900
In-Reply-To: <1370968960-22527-4-git-send-email-rric@kernel.org> (Robert
	Richter's message of "Tue, 11 Jun 2013 18:42:29 +0200")
Message-ID: <87ehc530b2.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert and Boris,

On Tue, 11 Jun 2013 18:42:29 +0200, Robert Richter wrote:
> From: Borislav Petkov <bp@alien8.de>
>
> Add a barebones implementation for registering persistent events with
> perf. For that, we don't destroy the buffers when they're unmapped;
> also, we map them read-only so that multiple agents can access them.
>
> Also, we allocate the event buffers at event init time and not at mmap
> time so that we can log samples into them regardless of whether there
> are readers in userspace or not.
>
> Changes made by Robert Richter <robert.richter@linaro.org>:
>
> * Fixing wrongly determined attribute size.
>
> * The default buffer size used to setup event buffers with perf tools
>   is 512k. Using the same buffer size for persistent events. This also
>   avoids failed mmap calls due to different buffer sizes.
>
> * Improve error reporting.
>
> * Returning -ENODEV if no file descriptor is found. An error code of
>   -1 (-EPERM) is misleading in this case.
>
> * Adding cpu check to perf_get_persistent_event_fd()
>
> [ make percpu variable static ]
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> [ Fix attr size ]
> [ Setting default buffer size to 512k as in perf tools ]
> [ Print error code on failure when adding events ]
> [ Return resonable error code ]
> [ Adding cpu check to perf_get_persistent_event_fd() ]
> Reported-by: Jiri Olsa <jolsa@redhat.com>
> Signed-off-by: Robert Richter <robert.richter@linaro.org>
> Signed-off-by: Robert Richter <rric@kernel.org>
[SNIP]
> +int perf_add_persistent_event_by_id(int id)
> +{
> +	struct perf_event_attr *attr;
> +
> +	attr = kzalloc(sizeof(*attr), GFP_KERNEL);
> +	if (!attr)
> +		return -ENOMEM;
> +
> +	attr->sample_period	= 1;
> +	attr->wakeup_events	= 1;
> +	attr->sample_type	= PERF_SAMPLE_RAW;
> +	attr->persistent	= 1;
> +	attr->config		= id;
> +	attr->type		= PERF_TYPE_TRACEPOINT;
> +	attr->size		= sizeof(*attr);
> +
> +	return perf_add_persistent_event(attr, CPU_BUFFER_NR_PAGES);
> +}
> +
> +int perf_get_persistent_event_fd(unsigned cpu, struct perf_event_attr *attr)
> +{
> +	struct pers_event_desc *desc;
> +
> +	if (cpu >= (unsigned)nr_cpu_ids)
> +		return -EINVAL;
> +
> +	list_for_each_entry(desc, &per_cpu(pers_events, cpu), plist)
> +		if (desc->attr->config == attr->config)
> +			return __alloc_persistent_event_fd(desc);
> +

So it only supports tracepoint events.  Don't we need to add other types
of event?

Thanks,
Namhyung


> +	return -ENODEV;
> +}
> +
> +
> +void __init persistent_events_init(void)
> +{
> +	int i;
> +
> +	for_each_possible_cpu(i)
> +		INIT_LIST_HEAD(&per_cpu(pers_events, i));
> +}
