Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934082Ab3JQDBK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 23:01:10 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:37350 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932792Ab3JQDBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 23:01:08 -0400
Message-ID: <525F52F0.2030006@gmail.com>
Date: Wed, 16 Oct 2013 21:01:04 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Waiman Long <Waiman.Long@hp.com>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH 2/2] perf-report: add --max-stack option to limit callchain
 stack scan
References: <1381953595-36427-1-git-send-email-Waiman.Long@hp.com>
In-Reply-To: <1381953595-36427-1-git-send-email-Waiman.Long@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/13 1:59 PM, Waiman Long wrote:
> This patch adds a new --max-stack option to perf-report to limit the
> depth of callchain stack data to look at to reduce the time it takes
> for perf-report to finish its processing. It trades the presence of
> trailing stack information with faster speed.

I like the patch. I have a similar option in my perf-sched-timehist 
command, and I have a patch somewhere for perf-script.

It would be even better to pass this arg kernel side and limit the stack 
depth at data collection time.

---8<---

> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index 72eae74..d90d04a 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -37,6 +37,12 @@
>
>   #include <linux/bitmap.h>
>
> +/*
> + * 2-level stringification macro to enable stringification of macro value
> + * */
> +#define	__to_string(x)	#x
> +#define	STRINGIFY(x)	__to_string(x)

These 2 lines should be somewhere else -- like util/util.h

---8<---

> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index 2122141..2725aca 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -771,7 +771,8 @@ static void perf_event__process_sample(struct perf_tool *tool,
>   		    sample->callchain) {
>   			err = machine__resolve_callchain(machine, evsel,
>   							 al.thread, sample,
> -							 &parent, &al);
> +							 &parent, &al,
> +							 PERF_MAX_STACK_DEPTH);
>   			if (err)
>   				return;
>   		}

Why not add the option to perf-top as well? copy-paste.

David
