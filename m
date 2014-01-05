Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293AbaAEP2o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 10:28:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20145 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbaAEP2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 10:28:43 -0500
Date: Sun, 5 Jan 2014 16:28:15 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 01/21] perf tools: Introduce struct add_entry_iter
Message-ID: <20140105152815.GA8720@krava.brq.redhat.com>
References: <1387873347-28838-1-git-send-email-namhyung@kernel.org>
 <1387873347-28838-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387873347-28838-2-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 24, 2013 at 05:22:07PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>

SNIP

> @@ -239,6 +426,7 @@ static int process_sample_event(struct perf_tool *tool,
>  {
>  	struct report *rep = container_of(tool, struct report, tool);
>  	struct addr_location al;
> +	struct add_entry_iter *iter;
>  	int ret;
>  
>  	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0) {
> @@ -253,22 +441,22 @@ static int process_sample_event(struct perf_tool *tool,
>  	if (rep->cpu_list && !test_bit(sample->cpu, rep->cpu_bitmap))
>  		return 0;
>  
> -	if (sort__mode == SORT_MODE__BRANCH) {
> -		ret = report__add_branch_hist_entry(tool, &al, sample, evsel);
> -		if (ret < 0)
> -			pr_debug("problem adding lbr entry, skipping event\n");
> -	} else if (rep->mem_mode == 1) {
> -		ret = report__add_mem_hist_entry(tool, &al, sample, evsel, event);
> -		if (ret < 0)
> -			pr_debug("problem adding mem entry, skipping event\n");
> -	} else {
> -		if (al.map != NULL)
> -			al.map->dso->hit = 1;
> -
> -		ret = report__add_hist_entry(tool, evsel, &al, sample);
> -		if (ret < 0)
> -			pr_debug("problem incrementing symbol period, skipping event\n");
> -	}
> +	if (sort__mode == SORT_MODE__BRANCH)
> +		iter = &branch_iter;
> +	else if (rep->mem_mode == 1) {
> +		iter = &mem_iter;
> +		iter->priv = event;
> +	} else
> +		iter = &normal_iter;
> +
> +	if (al.map != NULL)
> +		al.map->dso->hit = 1;
> +
> +	iter->rep = rep;
> +	ret = perf_evsel__add_entry(evsel, &al, sample, machine, iter);

you dont need to pass machine pointer, it's already in 'al'

jirka
