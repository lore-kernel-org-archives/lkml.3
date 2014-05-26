Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbaEZS2X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 14:28:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967AbaEZS2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 14:28:21 -0400
Date: Mon, 26 May 2014 20:27:43 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 01/26] perf tools: Introduce struct hist_entry_iter
Message-ID: <20140526182743.GB9699@krava.brq.redhat.com>
References: <1400839463-21933-1-git-send-email-namhyung@kernel.org>
 <1400839463-21933-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400839463-21933-2-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 07:03:58PM +0900, Namhyung Kim wrote:

SNIP

>  static int process_sample_event(struct perf_tool *tool,
>  				union perf_event *event,
>  				struct perf_sample *sample,
> @@ -243,6 +84,9 @@ static int process_sample_event(struct perf_tool *tool,
>  {
>  	struct report *rep = container_of(tool, struct report, tool);
>  	struct addr_location al;
> +	struct hist_entry_iter iter = {
> +		.hide_unresolved = rep->hide_unresolved,
> +	};
>  	int ret;
>  
>  	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0) {
> @@ -257,22 +101,22 @@ static int process_sample_event(struct perf_tool *tool,
>  	if (rep->cpu_list && !test_bit(sample->cpu, rep->cpu_bitmap))
>  		return 0;
>  
> -	if (sort__mode == SORT_MODE__BRANCH) {
> -		ret = report__add_branch_hist_entry(rep, &al, sample, evsel);
> -		if (ret < 0)
> -			pr_debug("problem adding lbr entry, skipping event\n");
> -	} else if (rep->mem_mode == 1) {
> -		ret = report__add_mem_hist_entry(rep, &al, sample, evsel);
> -		if (ret < 0)
> -			pr_debug("problem adding mem entry, skipping event\n");
> -	} else {
> -		if (al.map != NULL)
> -			al.map->dso->hit = 1;
> -
> -		ret = report__add_hist_entry(rep, evsel, &al, sample);
> -		if (ret < 0)
> -			pr_debug("problem incrementing symbol period, skipping event\n");
> -	}
> +	if (sort__mode == SORT_MODE__BRANCH)
> +		iter.ops = &hist_iter_branch;
> +	else if (rep->mem_mode)
> +		iter.ops = &hist_iter_mem;
> +	else
> +		iter.ops = &hist_iter_normal;
> +
> +	if (al.map != NULL)
> +		al.map->dso->hit = 1;
> +
> +	rep->nr_entries++;

hum, should we call report__inc_stats instead? aaand...

> +
> +	ret = hist_entry_iter__add(&iter, &al, evsel, sample, rep->max_stack);
> +	if (ret < 0)
> +		pr_debug("problem adding hist entry, skipping event\n");
> +

... in here? 

>  	return ret;
>  }


jirka
