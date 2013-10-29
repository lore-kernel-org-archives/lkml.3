Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab3J2ID6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 04:03:58 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:56431 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab3J2IDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 04:03:52 -0400
X-AuditID: 9c93017e-b7ca6ae000000e8a-33-526f6be78906
From: Namhyung Kim <namhyung@kernel.org>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] perf timechart: use proc_num to implement --power-only
References: <1382439412-23713-1-git-send-email-stfomichev@yandex-team.ru>
	<1382439412-23713-3-git-send-email-stfomichev@yandex-team.ru>
Date: Tue, 29 Oct 2013 17:03:51 +0900
In-Reply-To: <1382439412-23713-3-git-send-email-stfomichev@yandex-team.ru>
	(Stanislav Fomichev's message of "Tue, 22 Oct 2013 14:56:48 +0400")
Message-ID: <87txg05wrc.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Oct 2013 14:56:48 +0400, Stanislav Fomichev wrote:
> Don't use special flag to indicate power-only mode, use proc_num == 0.
> -P now equals to -n 0

I don't see how it does same thing.  You mean it by skipping
draw_process_bars() and draw_wakeups() on patch 1?  It'd be better
changelog explains the details.

>
> Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
> ---
>  tools/perf/builtin-timechart.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
>
> diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
> index d965f26308ed..e6c041301aa4 100644
> --- a/tools/perf/builtin-timechart.c
> +++ b/tools/perf/builtin-timechart.c
> @@ -50,8 +50,6 @@ static u64		turbo_frequency;
>  
>  static u64		first_time, last_time;
>  
> -static bool		power_only;
> -
>  
>  struct per_pid;
>  struct per_pidcomm;
> @@ -912,7 +910,7 @@ static int determine_display_tasks(u64 threshold)
>  		/* no exit marker, task kept running to the end */
>  		if (p->end_time == 0)
>  			p->end_time = last_time;
> -		if (p->total_time >= threshold && !power_only)
> +		if (p->total_time >= threshold)
>  			p->display = 1;
>  
>  		c = p->all;
> @@ -923,7 +921,7 @@ static int determine_display_tasks(u64 threshold)
>  			if (c->start_time == 1)
>  				c->start_time = first_time;
>  
> -			if (c->total_time >= threshold && !power_only) {
> +			if (c->total_time >= threshold) {
>  				c->display = 1;
>  				count++;
>  			}
> @@ -1086,6 +1084,15 @@ parse_process(const struct option *opt __maybe_unused, const char *arg,
>  	return 0;
>  }
>  
> +static int
> +parse_power(const struct option *opt __maybe_unused,
> +	    const char *arg __maybe_unused,
> +	    int unset __maybe_unused)
> +{
> +	proc_num = 0;
> +	return 0;
> +}
> +
>  int cmd_timechart(int argc, const char **argv,
>  		  const char *prefix __maybe_unused)
>  {
> @@ -1094,7 +1101,8 @@ int cmd_timechart(int argc, const char **argv,
>  	OPT_STRING('i', "input", &input_name, "file", "input file name"),
>  	OPT_STRING('o', "output", &output_name, "file", "output file name"),
>  	OPT_INTEGER('w', "width", &svg_page_width, "page width"),
> -	OPT_BOOLEAN('P', "power-only", &power_only, "output power data only"),
> +	OPT_CALLBACK_NOOPT('P', "power-only", NULL, NULL,
> +		     "output power data only", parse_power),

And I'd like to keep it as BOOLEAN option - it's simpler and more
straight-forward IMHO.

How about adding

	if (power_only)
		proc_num = 0;

after parsing the command line options?

Thanks,
Namhyung


>  	OPT_CALLBACK('p', "process", NULL, "process",
>  		      "process selector. Pass a pid or process name.",
>  		       parse_process),
