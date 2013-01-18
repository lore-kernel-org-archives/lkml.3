Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab3ARNtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 08:49:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466Ab3ARNtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 08:49:24 -0500
Date: Fri, 18 Jan 2013 14:49:07 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, namhyung.kim@lge.com
Subject: Re: [PATCH v2 1/2] perf tools: add evsel prev_raw_count field
Message-ID: <20130118134907.GA1579@krava>
References: <1358514388-4344-1-git-send-email-eranian@google.com>
 <1358514388-4344-2-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358514388-4344-2-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 02:06:27PM +0100, Stephane Eranian wrote:
> This field will be used by commands which print
> counter deltas on regular timer intervals,
> such as perf stat -I.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
>  tools/perf/util/evsel.c |   21 +++++++++++++++++++++
>  tools/perf/util/evsel.h |    1 +
>  2 files changed, 22 insertions(+)
> 
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index 1b16dd1..132da7c 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -646,6 +646,17 @@ int __perf_evsel__read_on_cpu(struct perf_evsel *evsel,
>  	if (readn(FD(evsel, cpu, thread), &count, nv * sizeof(u64)) < 0)
>  		return -errno;
>  
> +	if (evsel->prev_raw_counts) {
> +		struct perf_counts_values tmp;
> +
> +		tmp = evsel->prev_raw_counts->cpu[cpu];
> +		evsel->prev_raw_counts->cpu[cpu] = count;
> +
> +		count.val = count.val - tmp.val;
> +		count.ena = count.ena - tmp.ena;
> +		count.run = count.run - tmp.run;
> +	}
> +
>  	if (scale) {
>  		if (count.run == 0)
>  			count.val = 0;
> @@ -684,6 +695,16 @@ int __perf_evsel__read(struct perf_evsel *evsel,
>  		}
>  	}
>  
> +	if (evsel->prev_raw_counts) {
> +		struct perf_counts_values tmp = evsel->prev_raw_counts->aggr;
> +
> +		evsel->prev_raw_counts->aggr = *aggr;
> +
> +		aggr->val = aggr->val - tmp.val;
> +		aggr->ena = aggr->ena - tmp.ena;
> +		aggr->run = aggr->run - tmp.run;
> +	}

this and the hunk above looks like candidates for function

jirka
