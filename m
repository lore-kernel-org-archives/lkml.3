Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab3J2IKM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 04:10:12 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:45629 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab3J2IKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 04:10:08 -0400
X-AuditID: 9c93017d-b7cd3ae000007ab3-db-526f6d5e031e
From: Namhyung Kim <namhyung@kernel.org>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] perf timechart: add support for displaying only tasks related data
References: <1382439412-23713-1-git-send-email-stfomichev@yandex-team.ru>
	<1382439412-23713-4-git-send-email-stfomichev@yandex-team.ru>
Date: Tue, 29 Oct 2013 17:10:06 +0900
In-Reply-To: <1382439412-23713-4-git-send-email-stfomichev@yandex-team.ru>
	(Stanislav Fomichev's message of "Tue, 22 Oct 2013 14:56:49 +0400")
Message-ID: <87ppqo5wgx.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Oct 2013 14:56:49 +0400, Stanislav Fomichev wrote:
> In order to make SVG smaller and faster to browse add possibility to
> switch off power related information with -T switch.
>
> Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
> ---
>  tools/perf/builtin-timechart.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
>
> diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
> index e6c041301aa4..c7b30a8c7f3b 100644
> --- a/tools/perf/builtin-timechart.c
> +++ b/tools/perf/builtin-timechart.c
> @@ -41,6 +41,7 @@
>  #define PWR_EVENT_EXIT -1
>  
>  static int proc_num = 15;
> +static bool no_power;
>  
>  
>  static unsigned int	numcpus;
> @@ -967,7 +968,8 @@ static void write_svg_file(const char *filename)
>  	draw_cpu_usage();
>  	if (proc_num)
>  		draw_process_bars();
> -	draw_c_p_states();
> +	if (!no_power)
> +		draw_c_p_states();

Hmm.. double negation is always confusing to me. :-/  How about making
it a boolean option that sets "task_only" variable?


>  	if (proc_num)
>  		draw_wakeups();
>  
> @@ -1076,6 +1078,15 @@ static int __cmd_record(int argc, const char **argv)
>  }
>  
>  static int
> +parse_tasks(const struct option *opt __maybe_unused,
> +	    const char *arg __maybe_unused,
> +	    int unset __maybe_unused)
> +{
> +	no_power = 1;
> +	return 0;
> +}
> +
> +static int
>  parse_process(const struct option *opt __maybe_unused, const char *arg,
>  	      int __maybe_unused unset)
>  {
> @@ -1103,6 +1114,8 @@ int cmd_timechart(int argc, const char **argv,
>  	OPT_INTEGER('w', "width", &svg_page_width, "page width"),
>  	OPT_CALLBACK_NOOPT('P', "power-only", NULL, NULL,
>  		     "output power data only", parse_power),
> +	OPT_CALLBACK_NOOPT('T', "tasks-only", NULL, NULL,
> +		     "output processes data only", parse_tasks),

Also need to update the doc.  And what if user gives -P and -T options
at the same time?

Thanks,
Namhyung


>  	OPT_CALLBACK('p', "process", NULL, "process",
>  		      "process selector. Pass a pid or process name.",
>  		       parse_process),
