Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab3J2Hu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 03:50:27 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:55097 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab3J2Hu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 03:50:26 -0400
X-AuditID: 9c93017d-b7cd3ae000007ab3-57-526f68beb6df
From: Namhyung Kim <namhyung@kernel.org>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] perf timechart: always try to print at least 15 tasks
References: <1382439412-23713-1-git-send-email-stfomichev@yandex-team.ru>
	<1382439412-23713-2-git-send-email-stfomichev@yandex-team.ru>
Date: Tue, 29 Oct 2013 16:50:22 +0900
In-Reply-To: <1382439412-23713-2-git-send-email-stfomichev@yandex-team.ru>
	(Stanislav Fomichev's message of "Tue, 22 Oct 2013 14:56:47 +0400")
Message-ID: <87y55c5xdt.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stanislav,

On Tue, 22 Oct 2013 14:56:47 +0400, Stanislav Fomichev wrote:
> Always try to print at least 15 tasks no matter how long they run.
> Add -n option to specify desired number of tasks to print.

Hmm.. I think that this patch tried to do many things at once.

1. introduce while loop: it's a behavioral change so that it can be a
separate patch.  But it seems not checking the process filter - in that
case the loop is almost useless IMHO.

2. new -n option: it should update Documentation/perf-timechart.txt
also.  And the long option name "number" is too general.

3. two if(proc_num): what is this?  Is it for patch 2?

Thanks,
Namhyung

>
> Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
> ---
>  tools/perf/builtin-timechart.c | 22 +++++++++++++++-------
>  1 file changed, 15 insertions(+), 7 deletions(-)
>
> diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
> index c2e02319347a..d965f26308ed 100644
> --- a/tools/perf/builtin-timechart.c
> +++ b/tools/perf/builtin-timechart.c
> @@ -40,6 +40,8 @@
>  #define SUPPORT_OLD_POWER_EVENTS 1
>  #define PWR_EVENT_EXIT -1
>  
> +static int proc_num = 15;
> +
>  
>  static unsigned int	numcpus;
>  static u64		min_freq;	/* Lowest CPU frequency seen */
> @@ -944,15 +946,17 @@ static void write_svg_file(const char *filename)
>  {
>  	u64 i;
>  	int count;
> +	int thresh = TIME_THRESH;
>  
>  	numcpus++;
>  
>  
> -	count = determine_display_tasks(TIME_THRESH);
> -
> -	/* We'd like to show at least 15 tasks; be less picky if we have fewer */
> -	if (count < 15)
> -		count = determine_display_tasks(TIME_THRESH / 10);
> +	/* We'd like to show at least proc_num tasks;
> +	 * be less picky if we have fewer */
> +	do {
> +		count = determine_display_tasks(thresh);
> +		thresh /= 10;
> +	} while (thresh && count < proc_num);
>  
>  	open_svg(filename, numcpus, count, first_time, last_time);
>  
> @@ -963,9 +967,11 @@ static void write_svg_file(const char *filename)
>  		svg_cpu_box(i, max_freq, turbo_frequency);
>  
>  	draw_cpu_usage();
> -	draw_process_bars();
> +	if (proc_num)
> +		draw_process_bars();
>  	draw_c_p_states();
> -	draw_wakeups();
> +	if (proc_num)
> +		draw_wakeups();
>  
>  	svg_close();
>  }
> @@ -1094,6 +1100,8 @@ int cmd_timechart(int argc, const char **argv,
>  		       parse_process),
>  	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
>  		    "Look for files with symbols relative to this directory"),
> +	OPT_INTEGER('n', "number", &proc_num,
> +		    "min. number of tasks to print"),
>  	OPT_END()
>  	};
>  	const char * const timechart_usage[] = {
