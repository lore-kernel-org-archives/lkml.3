Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbaL2Hbs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 02:31:48 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:49692 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbaL2Hbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 02:31:43 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
Date: Mon, 29 Dec 2014 16:32:49 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Taesoo Kim <tsgatesv@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-kernel@vger.kernel.org, taesoo@gatech.edu
Subject: Re: [PATCH 1/1] perf list: Fix --raw-dump option
Message-ID: <20141229073249.GB6081@sejong>
References: <1419654573-2340-1-git-send-email-tsgatesv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1419654573-2340-1-git-send-email-tsgatesv@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Taesoo,

On Fri, Dec 26, 2014 at 11:29:33PM -0500, Taesoo Kim wrote:
> Currently, 'perf list --raw-dump' requires extra arguments
> (e.g., hw) to invoke, which breaks bash/zsh completion
> (perf-completion.sh).
> 
>   $ perf list --raw-dump
>     Error: unknown option `raw-dump'
> 
>      usage: perf list [hw|sw|cache|tracepoint|pmu|event_glob]
> 
> After,
> 
>   $ perf list --raw-dump
>   cpu-cycles instructions cache-references cache-misses ...
> 
> Signed-off-by: Taesoo Kim <tsgatesv@gmail.com>

Thanks for fixing this.  Actually the --raw-dump option is intended to
support shell completion and not to be used directly.  I didn't update
the completion script for a while so didn't notice it.  It seems like
recent updates of the option parsing code broke this.


> ---
>  tools/perf/builtin-list.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
> index 011195e..ec76bee 100644
> --- a/tools/perf/builtin-list.c
> +++ b/tools/perf/builtin-list.c
> @@ -16,14 +16,17 @@
>  #include "util/pmu.h"
>  #include "util/parse-options.h"
>  
> +static bool raw_dump = false;
> +
>  int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
>  {
>  	int i;
>  	const struct option list_options[] = {
> +		OPT_BOOLEAN(0, "raw-dump", &raw_dump, "Dump raw events"),
>  		OPT_END()
>  	};
>  	const char * const list_usage[] = {
> -		"perf list [hw|sw|cache|tracepoint|pmu|event_glob]",
> +		"perf list [hw|sw|cache|tracepoint|pmu|event_glob|--raw-dump]",
>  		NULL
>  	};

So I'd like to keep the usage string as is and mark the option as
hidden - i.e. using set_option_flag(list_options, 0, "raw-dump",
PARSE_OPT_HIDDEN) before calling to parse_options().

With that,

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


>  
> @@ -32,6 +35,11 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
>  
>  	setup_pager();
>  
> +	if (raw_dump) {
> +		print_events(NULL, true);
> +		return 0;
> +	}
> +
>  	if (argc == 0) {
>  		print_events(NULL, false);
>  		return 0;
> @@ -53,8 +61,6 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
>  			print_hwcache_events(NULL, false);
>  		else if (strcmp(argv[i], "pmu") == 0)
>  			print_pmu_events(NULL, false);
> -		else if (strcmp(argv[i], "--raw-dump") == 0)
> -			print_events(NULL, true);
>  		else {
>  			char *sep = strchr(argv[i], ':'), *s;
>  			int sep_idx;
> -- 
> 2.1.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
