Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbaL3Wtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 17:49:35 -0500
Received: from mail.kernel.org ([198.145.29.136]:52488 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531AbaL3Wte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 17:49:34 -0500
Date: Tue, 30 Dec 2014 19:49:29 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Taesoo Kim <tsgatesv@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        taesoo@gatech.edu, namhyung@kernel.org
Subject: Re: [PATCH 1/1] perf list: Fix --raw-dump option
Message-ID: <20141230224929.GA14973@kernel.org>
References: <1419872570-24843-1-git-send-email-tsgatesv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419872570-24843-1-git-send-email-tsgatesv@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 29, 2014 at 12:02:50PM -0500, Taesoo Kim escreveu:
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
> ---
>  tools/perf/builtin-list.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
> index 011195e..3783c28 100644
> --- a/tools/perf/builtin-list.c
> +++ b/tools/perf/builtin-list.c
> @@ -16,10 +16,13 @@
>  #include "util/pmu.h"
>  #include "util/parse-options.h"
>  
> +static bool raw_dump = false;
> +

Why does this need to be a global static variable? Can't it be moved
to...

>  int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
>  {
>  	int i;

... here?

  +	bool raw_dump = false;
> -	const struct option list_options[] = {
> +	struct option list_options[] = {
> +		OPT_BOOLEAN(0, "raw-dump", &raw_dump, "Dump raw events"),
>  		OPT_END()
>  	};
>  	const char * const list_usage[] = {
> @@ -27,11 +30,18 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
>  		NULL
>  	};
>  
> +	set_option_flag(list_options, 0, "raw-dump", PARSE_OPT_HIDDEN);
> +
>  	argc = parse_options(argc, argv, list_options, list_usage,
>  			     PARSE_OPT_STOP_AT_NON_OPTION);
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
> @@ -53,8 +63,6 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
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
