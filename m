Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751199AbaJWFAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 01:00:46 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:43745 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaJWFAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 01:00:45 -0400
Message-ID: <54488B72.9090902@hitachi.com>
Date: Thu, 23 Oct 2014 14:00:34 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Hemant Kumar <hemant@linux.vnet.ibm.com>
Subject: Re: [PATCH 5/5] perf probe: Use PARSE_OPT_EXCLUSIVE flag
References: <1413990949-13953-1-git-send-email-namhyung@kernel.org> <1413990949-13953-6-git-send-email-namhyung@kernel.org>
In-Reply-To: <1413990949-13953-6-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Namhyng,


(2014/10/23 0:15), Namhyung Kim wrote:
> The perf probe has some exclusive options.  Use new PARSE_OPT_EXCLUSIVE
> flag to simplify the code and show more compact usage.
> 
>   $ perf probe -l -a foo
>     Error: switch `a' cannot be used with switch `l'
> 
>    usage: perf probe [<options>] 'PROBEDEF' ['PROBEDEF' ...]
>       or: perf probe [<options>] --add 'PROBEDEF' [--add 'PROBEDEF' ...]
>       or: perf probe [<options>] --del '[GROUP:]EVENT' ...
>       or: perf probe --list
>       or: perf probe [<options>] --line 'LINEDESC'
>       or: perf probe [<options>] --vars 'PROBEPOINT'
> 
>       -a, --add <[EVENT=]FUNC[@SRC][+OFF|%return|:RL|;PT]|SRC:AL|SRC;PT [[NAME=]ARG ...]>
>                             probe point definition, where
> 		GROUP:	Group name (optional)
> 		EVENT:	Event name
> 		FUNC:	Function name
> 		OFF:	Offset from function entry (in byte)
> 		%return:	Put the probe at function return
> 		SRC:	Source code path
> 		RL:	Relative line number from function entry.
> 		AL:	Absolute line number in file.
> 		PT:	Lazy expression of line code.
> 		ARG:	Probe argument (local variable name or
> 			kprobe-tracer argument format.)
> 
>       -l, --list            list up current probe events
> 

Thanks! this looks very good to me:)

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Hemant Kumar <hemant@linux.vnet.ibm.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/builtin-probe.c | 54 ++++++++--------------------------------------
>  1 file changed, 9 insertions(+), 45 deletions(-)
> 
> diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
> index 04412b4770a2..23d6e7f03cf1 100644
> --- a/tools/perf/builtin-probe.c
> +++ b/tools/perf/builtin-probe.c
> @@ -312,7 +312,7 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
>  #endif
>  		NULL
>  };
> -	const struct option options[] = {
> +	struct option options[] = {
>  	OPT_INCR('v', "verbose", &verbose,
>  		    "be more verbose (show parsed arguments, etc)"),
>  	OPT_BOOLEAN('l', "list", &params.list_events,
> @@ -382,6 +382,14 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
>  	};
>  	int ret;
>  
> +	set_option_flag(options, 'a', "add", PARSE_OPT_EXCLUSIVE);
> +	set_option_flag(options, 'd', "del", PARSE_OPT_EXCLUSIVE);
> +	set_option_flag(options, 'l', "list", PARSE_OPT_EXCLUSIVE);
> +#ifdef HAVE_DWARF_SUPPORT
> +	set_option_flag(options, 'L', "line", PARSE_OPT_EXCLUSIVE);
> +	set_option_flag(options, 'V', "vars", PARSE_OPT_EXCLUSIVE);
> +#endif
> +
>  	argc = parse_options(argc, argv, options, probe_usage,
>  			     PARSE_OPT_STOP_AT_NON_OPTION);
>  	if (argc > 0) {
> @@ -409,22 +417,6 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
>  	symbol_conf.try_vmlinux_path = (symbol_conf.vmlinux_name == NULL);
>  
>  	if (params.list_events) {
> -		if (params.mod_events) {
> -			pr_err("  Error: Don't use --list with --add/--del.\n");
> -			usage_with_options(probe_usage, options);
> -		}
> -		if (params.show_lines) {
> -			pr_err("  Error: Don't use --list with --line.\n");
> -			usage_with_options(probe_usage, options);
> -		}
> -		if (params.show_vars) {
> -			pr_err(" Error: Don't use --list with --vars.\n");
> -			usage_with_options(probe_usage, options);
> -		}
> -		if (params.show_funcs) {
> -			pr_err("  Error: Don't use --list with --funcs.\n");
> -			usage_with_options(probe_usage, options);
> -		}
>  		if (params.uprobes) {
>  			pr_warning("  Error: Don't use --list with --exec.\n");
>  			usage_with_options(probe_usage, options);
> @@ -435,19 +427,6 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
>  		return ret;
>  	}
>  	if (params.show_funcs) {
> -		if (params.nevents != 0 || params.dellist) {
> -			pr_err("  Error: Don't use --funcs with"
> -			       " --add/--del.\n");
> -			usage_with_options(probe_usage, options);
> -		}
> -		if (params.show_lines) {
> -			pr_err("  Error: Don't use --funcs with --line.\n");
> -			usage_with_options(probe_usage, options);
> -		}
> -		if (params.show_vars) {
> -			pr_err("  Error: Don't use --funcs with --vars.\n");
> -			usage_with_options(probe_usage, options);
> -		}
>  		if (!params.filter)
>  			params.filter = strfilter__new(DEFAULT_FUNC_FILTER,
>  						       NULL);
> @@ -462,16 +441,6 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
>  
>  #ifdef HAVE_DWARF_SUPPORT
>  	if (params.show_lines) {
> -		if (params.mod_events) {
> -			pr_err("  Error: Don't use --line with"
> -			       " --add/--del.\n");
> -			usage_with_options(probe_usage, options);
> -		}
> -		if (params.show_vars) {
> -			pr_err(" Error: Don't use --line with --vars.\n");
> -			usage_with_options(probe_usage, options);
> -		}
> -
>  		ret = show_line_range(&params.line_range, params.target,
>  				      params.uprobes);
>  		if (ret < 0)
> @@ -479,11 +448,6 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
>  		return ret;
>  	}
>  	if (params.show_vars) {
> -		if (params.mod_events) {
> -			pr_err("  Error: Don't use --vars with"
> -			       " --add/--del.\n");
> -			usage_with_options(probe_usage, options);
> -		}
>  		if (!params.filter)
>  			params.filter = strfilter__new(DEFAULT_VAR_FILTER,
>  						       NULL);
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


