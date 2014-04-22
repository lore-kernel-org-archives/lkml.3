Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932869AbaDVOzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:55:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932661AbaDVOzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:55:13 -0400
Date: Tue, 22 Apr 2014 16:54:49 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 3/9] perf tools: Account entry stats when it's added to
 the output tree
Message-ID: <20140422145449.GI1104@krava.brq.redhat.com>
References: <1398156591-11001-1-git-send-email-namhyung@kernel.org>
 <1398156591-11001-4-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398156591-11001-4-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 05:49:45PM +0900, Namhyung Kim wrote:

SNIP

>  }
>  
>  static int process_sample_event(struct perf_tool *tool,
> @@ -234,19 +230,17 @@ static int __cmd_annotate(struct perf_annotate *ann)
>  	total_nr_samples = 0;
>  	evlist__for_each(session->evlist, pos) {
>  		struct hists *hists = &pos->hists;
> -		u32 nr_samples = hists->stats.nr_events[PERF_RECORD_SAMPLE];
>  
> -		if (nr_samples > 0) {

so this condition of having some data is handled in the
resort I guess.. hm, it will just iterate 0 times ;-)

> -			total_nr_samples += nr_samples;
> -			hists__collapse_resort(hists, NULL);
> -			hists__output_resort(hists);
> +		hists__collapse_resort(hists, NULL);
> +		hists__output_resort(hists);
>  
> -			if (symbol_conf.event_group &&
> -			    !perf_evsel__is_group_leader(pos))
> -				continue;
> +		if (symbol_conf.event_group &&
> +		    !perf_evsel__is_group_leader(pos))
> +			continue;
>  
> -			hists__find_annotations(hists, pos, ann);
> -		}
> +		hists__find_annotations(hists, pos, ann);
> +
> +		total_nr_samples += hists->stats.nr_events[PERF_RECORD_SAMPLE];
>  	}
>  
>  	if (total_nr_samples == 0) {
>  

SNIP

> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
> index 1c77714f668d..f955ae5a41c5 100644
> --- a/tools/perf/util/hist.c
> +++ b/tools/perf/util/hist.c
> @@ -344,9 +344,11 @@ void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h)

I was wondering for a while about the name of this function
since it no longer increments only nr_entries.. but could not
think about any good replacement ;-)

We could also add hists__reset_nr_entries for the zeroing code.


>  		hists__calc_col_len(hists, h);

also having hists__calc_col_len called here seems strange

thanks,
jirka
