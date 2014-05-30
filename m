Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933089AbaE3Njt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 09:39:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932498AbaE3Njr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 09:39:47 -0400
Date: Fri, 30 May 2014 15:39:06 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jacob Shin <jacob.w.shin@gmail.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, xiakaixu <xiakaixu@huawei.com>
Subject: Re: [PATCH 2/4] perf tools: allow user to specify hardware
 breakpoint bp_len
Message-ID: <20140530133906.GC7427@krava.brq.redhat.com>
References: <1401377213-24551-1-git-send-email-fweisbec@gmail.com>
 <1401377213-24551-3-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401377213-24551-3-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 05:26:51PM +0200, Frederic Weisbecker wrote:
> From: Jacob Shin <jacob.w.shin@gmail.com>
> 
> Currently bp_len is given a default value of 4. Allow user to override it:
> 
>   $ perf stat -e mem:0x1000/8
>                             ^
>                             bp_len
> 
> If no value is given, it will default to 4 as it did before.

Namhyung,
both perf tols patches from this patchset mess up with hists
tests..  I havent found any connection yet.. any idea? ;-)

[root@krava perf]# ./perf test 
...
19: Test software clock events have valid period values    : Ok
20: Test converting perf time to TSC                       : Ok
21: Test object code reading                               : Ok
22: Test sample parsing                                    : Ok
23: Test using a dummy software event to keep tracking     : Ok
24: Test parsing with no sample_id_all bit set             : Ok
25: Test dwarf unwind                                      : Ok
26: Test filtering hist entries                            : FAILED!
27: Test mmap thread lookup                                : Ok
28: Test thread mg sharing                                 : Ok
29: Test output sorting of hist entries                    : FAILED!
30: Test cumulation of child hist entries                  : FAILED!

thanks,
jirka

> 
> Signed-off-by: Jacob Shin <jacob.w.shin@gmail.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: xiakaixu <xiakaixu@huawei.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  tools/perf/Documentation/perf-record.txt |  7 +++++--
>  tools/perf/util/parse-events.c           | 21 +++++++++++----------
>  tools/perf/util/parse-events.h           |  2 +-
>  tools/perf/util/parse-events.l           |  1 +
>  tools/perf/util/parse-events.y           | 26 ++++++++++++++++++++++++--
>  5 files changed, 42 insertions(+), 15 deletions(-)
> 
> diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
> index c71b0f3..5cac20d 100644
> --- a/tools/perf/Documentation/perf-record.txt
> +++ b/tools/perf/Documentation/perf-record.txt
> @@ -33,12 +33,15 @@ OPTIONS
>          - a raw PMU event (eventsel+umask) in the form of rNNN where NNN is a
>  	  hexadecimal event descriptor.
>  
> -        - a hardware breakpoint event in the form of '\mem:addr[:access]'
> +        - a hardware breakpoint event in the form of '\mem:addr[/len][:access]'
>            where addr is the address in memory you want to break in.
>            Access is the memory access type (read, write, execute) it can
> -          be passed as follows: '\mem:addr[:[r][w][x]]'.
> +          be passed as follows: '\mem:addr[:[r][w][x]]'. len is the range,
> +          number of bytes from specified addr, which the breakpoint will cover.
>            If you want to profile read-write accesses in 0x1000, just set
>            'mem:0x1000:rw'.
> +          If you want to profile write accesses in [0x1000~1008), just set
> +          'mem:0x1000/8:w'.
>  
>  --filter=<filter>::
>          Event filter.
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index 1e15df1..8dd9287 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -516,7 +516,7 @@ do {					\
>  }
>  
>  int parse_events_add_breakpoint(struct list_head *list, int *idx,
> -				void *ptr, char *type)
> +				void *ptr, char *type, u64 len)
>  {
>  	struct perf_event_attr attr;
>  
> @@ -526,14 +526,15 @@ int parse_events_add_breakpoint(struct list_head *list, int *idx,
>  	if (parse_breakpoint_type(type, &attr))
>  		return -EINVAL;
>  
> -	/*
> -	 * We should find a nice way to override the access length
> -	 * Provide some defaults for now
> -	 */
> -	if (attr.bp_type == HW_BREAKPOINT_X)
> -		attr.bp_len = sizeof(long);
> -	else
> -		attr.bp_len = HW_BREAKPOINT_LEN_4;
> +	/* Provide some defaults if len is not specified */
> +	if (!len) {
> +		if (attr.bp_type == HW_BREAKPOINT_X)
> +			len = sizeof(long);
> +		else
> +			len = HW_BREAKPOINT_LEN_4;
> +	}
> +
> +	attr.bp_len = len;
>  
>  	attr.type = PERF_TYPE_BREAKPOINT;
>  	attr.sample_period = 1;
> @@ -1262,7 +1263,7 @@ void print_events(const char *event_glob, bool name_only)
>  		printf("\n");
>  
>  		printf("  %-50s [%s]\n",
> -		       "mem:<addr>[:access]",
> +		       "mem:<addr>[/len][:access]",
>  			event_type_descriptors[PERF_TYPE_BREAKPOINT]);
>  		printf("\n");
>  	}
> diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
> index df094b4..00a5eb4 100644
> --- a/tools/perf/util/parse-events.h
> +++ b/tools/perf/util/parse-events.h
> @@ -92,7 +92,7 @@ int parse_events_add_numeric(struct list_head *list, int *idx,
>  int parse_events_add_cache(struct list_head *list, int *idx,
>  			   char *type, char *op_result1, char *op_result2);
>  int parse_events_add_breakpoint(struct list_head *list, int *idx,
> -				void *ptr, char *type);
> +				void *ptr, char *type, u64 len);
>  int parse_events_add_pmu(struct list_head *list, int *idx,
>  			 char *pmu , struct list_head *head_config);
>  void parse_events__set_leader(char *name, struct list_head *list);
> diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
> index 3432995..199e18a 100644
> --- a/tools/perf/util/parse-events.l
> +++ b/tools/perf/util/parse-events.l
> @@ -141,6 +141,7 @@ branch_type		{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE
>  <mem>{
>  {modifier_bp}		{ return str(yyscanner, PE_MODIFIER_BP); }
>  :			{ return ':'; }
> +"/"			{ return '/'; }
>  {num_dec}		{ return value(yyscanner, 10); }
>  {num_hex}		{ return value(yyscanner, 16); }
>  	/*
> diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
> index 0bc87ba..456f4de 100644
> --- a/tools/perf/util/parse-events.y
> +++ b/tools/perf/util/parse-events.y
> @@ -276,6 +276,28 @@ PE_NAME_CACHE_TYPE
>  }
>  
>  event_legacy_mem:
> +PE_PREFIX_MEM PE_VALUE '/' PE_VALUE ':' PE_MODIFIER_BP sep_dc
> +{
> +	struct parse_events_evlist *data = _data;
> +	struct list_head *list;
> +
> +	ALLOC_LIST(list);
> +	ABORT_ON(parse_events_add_breakpoint(list, &data->idx,
> +					     (void *) $2, $6, $4));
> +	$$ = list;
> +}
> +|
> +PE_PREFIX_MEM PE_VALUE '/' PE_VALUE sep_dc
> +{
> +	struct parse_events_evlist *data = _data;
> +	struct list_head *list;
> +
> +	ALLOC_LIST(list);
> +	ABORT_ON(parse_events_add_breakpoint(list, &data->idx,
> +					     (void *) $2, NULL, $4));
> +	$$ = list;
> +}
> +|
>  PE_PREFIX_MEM PE_VALUE ':' PE_MODIFIER_BP sep_dc
>  {
>  	struct parse_events_evlist *data = _data;
> @@ -283,7 +305,7 @@ PE_PREFIX_MEM PE_VALUE ':' PE_MODIFIER_BP sep_dc
>  
>  	ALLOC_LIST(list);
>  	ABORT_ON(parse_events_add_breakpoint(list, &data->idx,
> -					     (void *) $2, $4));
> +					     (void *) $2, $4, 0));
>  	$$ = list;
>  }
>  |
> @@ -294,7 +316,7 @@ PE_PREFIX_MEM PE_VALUE sep_dc
>  
>  	ALLOC_LIST(list);
>  	ABORT_ON(parse_events_add_breakpoint(list, &data->idx,
> -					     (void *) $2, NULL));
> +					     (void *) $2, NULL, 0));
>  	$$ = list;
>  }
>  
> -- 
> 1.8.3.1
> 
