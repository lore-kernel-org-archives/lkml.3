Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559Ab3FYRHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 13:07:42 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:60990 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab3FYRHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 13:07:41 -0400
Message-ID: <51C9CE58.5070004@gmail.com>
Date: Tue, 25 Jun 2013 11:07:36 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 5/5] perf tools: Fix perf_session__delete removal for
 report command
References: <1372161253-22081-1-git-send-email-jolsa@redhat.com> <1372161253-22081-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1372161253-22081-6-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/25/13 5:54 AM, Jiri Olsa wrote:
> There's no point of having out_delete label with perf_session__delete
> call within __cmd_report function, because it's called at the
> end of the cmd_report function.

Is convenient to have a single return point for a function. Perhaps 
change the label to just out and remove the comment?

David

>
> The speed up due to commenting out the perf_session__delete
> at the end does not seem relevant anymore. Measured speedup
> for ~1GB data file with 222466 FORKS events is around 0.5%.
>
>    $ perf report -i perf.data.delete -P perf_session__delete -s parent
>
>    +  99.51%  [other]
>    +   0.49%  perf_session__delete
>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Stephane Eranian <eranian@google.com>
> ---
>   tools/perf/builtin-report.c | 23 +++++------------------
>   1 file changed, 5 insertions(+), 18 deletions(-)
>
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index 8c2c7ce..36de70d 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -497,7 +497,7 @@ static int __cmd_report(struct perf_report *rep)
>   		ret = perf_session__cpu_bitmap(session, rep->cpu_list,
>   					       rep->cpu_bitmap);
>   		if (ret)
> -			goto out_delete;
> +			return ret;
>   	}
>
>   	if (use_browser <= 0)
> @@ -508,11 +508,11 @@ static int __cmd_report(struct perf_report *rep)
>
>   	ret = perf_report__setup_sample_type(rep);
>   	if (ret)
> -		goto out_delete;
> +		return ret;
>
>   	ret = perf_session__process_events(session, &rep->tool);
>   	if (ret)
> -		goto out_delete;
> +		return ret;
>
>   	kernel_map = session->machines.host.vmlinux_maps[MAP__FUNCTION];
>   	kernel_kmap = map__kmap(kernel_map);
> @@ -547,7 +547,7 @@ static int __cmd_report(struct perf_report *rep)
>
>   	if (dump_trace) {
>   		perf_session__fprintf_nr_events(session, stdout);
> -		goto out_delete;
> +		return 0;
>   	}
>
>   	nr_samples = 0;
> @@ -572,7 +572,7 @@ static int __cmd_report(struct perf_report *rep)
>
>   	if (nr_samples == 0) {
>   		ui__error("The %s file has no samples!\n", session->filename);
> -		goto out_delete;
> +		return 0;
>   	}
>
>   	list_for_each_entry(pos, &session->evlist->entries, node)
> @@ -598,19 +598,6 @@ static int __cmd_report(struct perf_report *rep)
>   	} else
>   		perf_evlist__tty_browse_hists(session->evlist, rep, help);
>
> -out_delete:
> -	/*
> -	 * Speed up the exit process, for large files this can
> -	 * take quite a while.
> -	 *
> -	 * XXX Enable this when using valgrind or if we ever
> -	 * librarize this command.
> -	 *
> -	 * Also experiment with obstacks to see how much speed
> -	 * up we'll get here.
> -	 *
> - 	 * perf_session__delete(session);
> - 	 */
>   	return ret;
>   }
>
>

