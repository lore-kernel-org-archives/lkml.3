Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab3GKGQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 02:16:48 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:52830 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab3GKGQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 02:16:47 -0400
X-AuditID: 9c93017e-b7b62ae000000eeb-ea-51de4dcd7393
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH 1/4] perf tools: Remove event types framework only user
References: <1373388539-9347-1-git-send-email-jolsa@redhat.com>
	<1373388539-9347-2-git-send-email-jolsa@redhat.com>
Date: Thu, 11 Jul 2013 15:16:45 +0900
In-Reply-To: <1373388539-9347-2-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Tue, 9 Jul 2013 18:48:56 +0200")
Message-ID: <87oba9y62a.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Tue,  9 Jul 2013 18:48:56 +0200, Jiri Olsa wrote:
> The only user of the event types data is 'perf timechart'
> command and uses this info to identify proper tracepoints
> based on its name.
>
> Switching this code to use traceevent library API to obtain
> IDs for needed tracepoints. This should also make the samples
> processing faster as we no longer compare strings but numbers.

A better way I think is using tracepoint handlers.  You don't need to
compare anything this way since an evsel can know its handler.

Please see perf_session__set_tracepoints_handlers() and builtin-
{kmem,lock,sched}.c.


[SNIP]
>  
> -/*
> - * trace_flag_type is an enumeration that holds different
> - * states when a trace occurs. These are:
> - *  IRQS_OFF            - interrupts were disabled
> - *  IRQS_NOSUPPORT      - arch does not support irqs_disabled_flags
> - *  NEED_RESCED         - reschedule is requested
> - *  HARDIRQ             - inside an interrupt handler
> - *  SOFTIRQ             - inside a softirq handler
> - */
> -enum trace_flag_type {
> -	TRACE_FLAG_IRQS_OFF		= 0x01,
> -	TRACE_FLAG_IRQS_NOSUPPORT	= 0x02,
> -	TRACE_FLAG_NEED_RESCHED		= 0x04,
> -	TRACE_FLAG_HARDIRQ		= 0x08,
> -	TRACE_FLAG_SOFTIRQ		= 0x10,
> -};

Why did you remove this part?  Isn't it used by elsewhere?  Anyway, it
seems unrelated to this change.


[SNIP]
> +static int get_id(const char *sys, const char *name, u32 *id)
> +{
> +	struct event_format *format;
> +
> +	format = event_format__new(sys, name);

No.  You need to access to tracepoints in the perf session data, not
ones in the current system.  The perf_session__set_tracepoints_handlers()
deals with it correctly.

Thanks,
Namhyung


> +	if (!format)
> +		return -1;
> +
> +	*id = format->id;
> +	pevent_free_format(format);
> +	return 0;
> +}
