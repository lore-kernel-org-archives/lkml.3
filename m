Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbbACCZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 21:25:12 -0500
Received: from mail.kernel.org ([198.145.29.136]:42572 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805AbbACCZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 21:25:10 -0500
Date: Fri, 2 Jan 2015 23:25:04 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 6/7] perf tools: Append callchains only when requested
Message-ID: <20150103022504.GB24430@kernel.org>
References: <1419223455-4362-1-git-send-email-namhyung@kernel.org>
 <1419223455-4362-7-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419223455-4362-7-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 22, 2014 at 01:44:14PM +0900, Namhyung Kim escreveu:
> The perf report --children can be called with callchain disabled so no
> need to append callchains.  Actually the root of callchain tree is not
> initialized properly in this case.

Hi Namhyung,

	I should have caught this using 'perf test', but it slipped
thru, please try running 'perf test cumulation', I noticed that it fails
and that if I revert this changeset it works again, can you please
check?

- Arnaldo
 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/hist.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
> index bd4a2cd73236..30ff2cb92884 100644
> --- a/tools/perf/util/hist.c
> +++ b/tools/perf/util/hist.c
> @@ -300,7 +300,7 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template,
>  	size_t callchain_size = 0;
>  	struct hist_entry *he;
>  
> -	if (symbol_conf.use_callchain || symbol_conf.cumulate_callchain)
> +	if (symbol_conf.use_callchain)
>  		callchain_size = sizeof(struct callchain_root);
>  
>  	he = zalloc(sizeof(*he) + callchain_size);
> @@ -735,7 +735,7 @@ iter_add_single_cumulative_entry(struct hist_entry_iter *iter,
>  	iter->he = he;
>  	he_cache[iter->curr++] = he;
>  
> -	callchain_append(he->callchain, &callchain_cursor, sample->period);
> +	hist_entry__append_callchain(he, sample);
>  
>  	/*
>  	 * We need to re-initialize the cursor since callchain_append()
> @@ -808,7 +808,8 @@ iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
>  	iter->he = he;
>  	he_cache[iter->curr++] = he;
>  
> -	callchain_append(he->callchain, &cursor, sample->period);
> +	if (symbol_conf.use_callchain)
> +		callchain_append(he->callchain, &cursor, sample->period);
>  	return 0;
>  }
>  
> -- 
> 2.1.3
