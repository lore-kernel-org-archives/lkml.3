Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759244Ab3BYSlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 13:41:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753565Ab3BYSlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 13:41:42 -0500
Date: Mon, 25 Feb 2013 19:39:32 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 1/5] perf tools: Fix -C option for record command
Message-ID: <20130225183932.GA7352@redhat.com>
References: <1361785972-7431-1-git-send-email-jolsa@redhat.com> <1361785972-7431-2-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361785972-7431-2-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To clarify, I am not trying to review this patch, I'd like to ask
the question...

On 02/25, Jiri Olsa wrote:
>
> Currently the -C option does not work for record command,
> because of the targets mismatch when synthesizing threads.
>
> Fixing this by using proper target interface for the
> synthesize decision.

OK, but my fix had the different goal. I thought that

	$ perf ... record -C0 sleep 1

should attach the counter to the child process (workload) and set
event->cpu = 0 (instead of -1). With this patch we create the cpu
counter and event->task == NULL (thanks for your private explanations
btw ;).

But note that (iirc, I didn't even try to read this code again)

	$ perf ... record -a sleep 1

attaches the counter to the task, and I think that -a/C should be
consistent.


However,

> @@ -573,13 +573,15 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
>  					 perf_event__synthesize_guest_os, tool);
>  	}
>
> -	if (!opts->target.system_wide)
> +	if (perf_target__has_task(&opts->target))
>  		err = perf_event__synthesize_thread_map(tool, evsel_list->threads,
>  						  process_synthesized_event,
>  						  machine);
> -	else
> +	else if (perf_target__has_cpu(&opts->target))
>  		err = perf_event__synthesize_threads(tool, process_synthesized_event,

I do agree, this should be changed too, because "-a sleep 1"
sets ->target.system_wide.

Oleg.

