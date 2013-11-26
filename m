Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388Ab3KZKow (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 05:44:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:54723 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754623Ab3KZKou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 05:44:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,773,1378882800"; 
   d="scan'208";a="440048761"
Message-ID: <52947D65.4050405@intel.com>
Date: Tue, 26 Nov 2013 12:52:21 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 21/25] perf evsel: Skip ignored symbols while printing
 callchain
References: <1385389075-7989-1-git-send-email-acme@infradead.org> <1385389075-7989-22-git-send-email-acme@infradead.org>
In-Reply-To: <1385389075-7989-22-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/11/13 16:17, Arnaldo Carvalho de Melo wrote:
> From: David Ahern <dsahern@gmail.com>
> 
> Allows a command to have a symbol_filter controlled by the user to skip
> certain functions in a backtrace. One example is to allow the user to
> reduce repeating patterns like:
> 
>     do_select  core_sys_select  sys_select
> 
> to just sys_select when dumping callchains, consuming less real estate
> on the screen while still conveying the essential message - the process
> is in a select call.
> 
> This option is leveraged by the upcoming timehist command.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephane Eranian <eranian@google.com>
> Link: http://lkml.kernel.org/r/1384806771-2945-2-git-send-email-dsahern@gmail.com
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/util/session.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index f36d24a02445..948f7644b4d9 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -1522,6 +1522,9 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
>  			if (!node)
>  				break;
>  
> +			if (node->sym && node->sym->ignore)
> +				goto next;
> +
>  			if (print_ip)
>  				printf("%c%16" PRIx64, s, node->ip);
>  
> @@ -1544,12 +1547,15 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
>  			if (!print_oneline)
>  				printf("\n");
>  
> -			callchain_cursor_advance(&callchain_cursor);
> -
>  			stack_depth--;
> +next:
> +			callchain_cursor_advance(&callchain_cursor);
>  		}
>  
>  	} else {
> +		if (al.sym->ignore)

Seems to segfault here because sym is null

> +			return;
> +
>  		if (print_ip)
>  			printf("%16" PRIx64, sample->ip);
>  
> 

