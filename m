Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762567Ab3DCRJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 13:09:54 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:33550 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762172Ab3DCRJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 13:09:53 -0400
Date: Wed, 3 Apr 2013 14:09:44 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 10/10] perf sort: Consolidate sort_entry__setup_elide()
Message-ID: <20130403170944.GB7238@ghostprotocols.net>
References: <1364991979-3008-1-git-send-email-namhyung@kernel.org>
 <1364991979-3008-11-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364991979-3008-11-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Apr 03, 2013 at 09:26:19PM +0900, Namhyung Kim escreveu:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> The same code was duplicate to places, factor them out to common
> sort__setup_elide().

Looks ok, applying after fixing up fuzzes due to this being at the end
of the patchseries. Things like this that are clear cleanups are best
positioned in the start of the patch series.

- Arnaldo
 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/builtin-diff.c   |  4 +---
>  tools/perf/builtin-report.c | 20 +-------------------
>  tools/perf/builtin-top.c    |  4 +---
>  tools/perf/util/sort.c      | 45 +++++++++++++++++++++++++++++++++++++++++++--
>  tools/perf/util/sort.h      |  3 +--
>  5 files changed, 47 insertions(+), 29 deletions(-)
> 
> diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
> index 03b56c542bb6..316bf13e59c7 100644
> --- a/tools/perf/builtin-diff.c
> +++ b/tools/perf/builtin-diff.c
> @@ -611,9 +611,7 @@ int cmd_diff(int argc, const char **argv, const char *prefix __maybe_unused)
>  
>  	setup_pager();
>  
> -	sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "dso", NULL);
> -	sort_entry__setup_elide(&sort_comm, symbol_conf.comm_list, "comm", NULL);
> -	sort_entry__setup_elide(&sort_sym, symbol_conf.sym_list, "symbol", NULL);
> +	sort__setup_elide(NULL);
>  
>  	return __cmd_diff();
>  }
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index c95fd92fbd44..bff244fa4b5d 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -937,25 +937,7 @@ repeat:
>  		report.symbol_filter_str = argv[0];
>  	}
>  
> -	sort_entry__setup_elide(&sort_comm, symbol_conf.comm_list, "comm", stdout);
> -
> -	if (sort__mode == SORT_MODE__BRANCH) {
> -		sort_entry__setup_elide(&sort_dso_from, symbol_conf.dso_from_list, "dso_from", stdout);
> -		sort_entry__setup_elide(&sort_dso_to, symbol_conf.dso_to_list, "dso_to", stdout);
> -		sort_entry__setup_elide(&sort_sym_from, symbol_conf.sym_from_list, "sym_from", stdout);
> -		sort_entry__setup_elide(&sort_sym_to, symbol_conf.sym_to_list, "sym_to", stdout);
> -	} else {
> -		if (report.mem_mode) {
> -			sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "symbol_daddr", stdout);
> -			sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "dso_daddr", stdout);
> -			sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "mem", stdout);
> -			sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "local_weight", stdout);
> -			sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "tlb", stdout);
> -			sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "snoop", stdout);
> -		}
> -		sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "dso", stdout);
> -		sort_entry__setup_elide(&sort_sym, symbol_conf.sym_list, "symbol", stdout);
> -	}
> +	sort__setup_elide(stdout);
>  
>  	ret = __cmd_report(&report);
>  	if (ret == K_SWITCH_INPUT_DATA) {
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index 4aa504baaf0b..fe4acf568483 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -1201,9 +1201,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
>  	if (symbol__init() < 0)
>  		return -1;
>  
> -	sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "dso", stdout);
> -	sort_entry__setup_elide(&sort_comm, symbol_conf.comm_list, "comm", stdout);
> -	sort_entry__setup_elide(&sort_sym, symbol_conf.sym_list, "symbol", stdout);
> +	sort__setup_elide(stdout);
>  
>  	get_term_dimensions(&top.winsize);
>  	if (top.print_entries == 0) {
> diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
> index 213831133e08..86ae94d8782e 100644
> --- a/tools/perf/util/sort.c
> +++ b/tools/perf/util/sort.c
> @@ -1,5 +1,6 @@
>  #include "sort.h"
>  #include "hist.h"
> +#include "symbol.h"
>  
>  regex_t		parent_regex;
>  const char	default_parent_pattern[] = "^sys_|^do_page_fault";
> @@ -1085,8 +1086,9 @@ int setup_sorting(void)
>  	return ret;
>  }
>  
> -void sort_entry__setup_elide(struct sort_entry *self, struct strlist *list,
> -			     const char *list_name, FILE *fp)
> +static void sort_entry__setup_elide(struct sort_entry *self,
> +				    struct strlist *list,
> +				    const char *list_name, FILE *fp)
>  {
>  	if (list && strlist__nr_entries(list) == 1) {
>  		if (fp != NULL)
> @@ -1095,3 +1097,42 @@ void sort_entry__setup_elide(struct sort_entry *self, struct strlist *list,
>  		self->elide = true;
>  	}
>  }
> +
> +void sort__setup_elide(FILE *output)
> +{
> +	sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
> +				"dso", output);
> +	sort_entry__setup_elide(&sort_comm, symbol_conf.comm_list,
> +				"comm", output);
> +	sort_entry__setup_elide(&sort_sym, symbol_conf.sym_list,
> +				"symbol", output);
> +
> +	if (sort__mode == SORT_MODE__BRANCH) {
> +		sort_entry__setup_elide(&sort_dso_from,
> +					symbol_conf.dso_from_list,
> +					"dso_from", output);
> +		sort_entry__setup_elide(&sort_dso_to,
> +					symbol_conf.dso_to_list,
> +					"dso_to", output);
> +		sort_entry__setup_elide(&sort_sym_from,
> +					symbol_conf.sym_from_list,
> +					"sym_from", output);
> +		sort_entry__setup_elide(&sort_sym_to,
> +					symbol_conf.sym_to_list,
> +					"sym_to", output);
> +	} else if (sort__mode == SORT_MODE__MEMORY) {
> +		sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
> +					"symbol_daddr", output);
> +		sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
> +					"dso_daddr", output);
> +		sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
> +					"mem", output);
> +		sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
> +					"local_weight", output);
> +		sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
> +					"tlb", output);
> +		sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
> +					"snoop", output);
> +	}
> +
> +}
> diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
> index 1f945a3b2e5b..c80aac4ae3a2 100644
> --- a/tools/perf/util/sort.h
> +++ b/tools/perf/util/sort.h
> @@ -184,7 +184,6 @@ extern struct list_head hist_entry__sort_list;
>  
>  int setup_sorting(void);
>  extern int sort_dimension__add(const char *);
> -void sort_entry__setup_elide(struct sort_entry *self, struct strlist *list,
> -			     const char *list_name, FILE *fp);
> +void sort__setup_elide(FILE *fp);
>  
>  #endif	/* __PERF_SORT_H */
> -- 
> 1.7.11.7
