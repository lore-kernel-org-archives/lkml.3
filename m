Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932984AbaE2NR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:17:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932081AbaE2NRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:17:25 -0400
Date: Thu, 29 May 2014 15:16:51 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Don Zickus <dzickus@redhat.com>
Subject: Re: [PATCH 18/27] perf tools: Add callback function to
 hist_entry_iter
Message-ID: <20140529131651.GA27903@krava.brq.redhat.com>
References: <1401335910-16832-1-git-send-email-namhyung@kernel.org>
 <1401335910-16832-19-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401335910-16832-19-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 12:58:21PM +0900, Namhyung Kim wrote:
> The new ->add_entry_cb() will be called after an entry was added to
> the histogram.  It's used for code sharing between perf report and
> perf top.  Note that ops->add_*_entry() should set iter->he properly
> in order to call the ->add_entry_cb.
> 
> Also pass @arg to the callback function.  It'll be used by perf top
> later.
> 
> Tested-by: Arun Sharma <asharma@fb.com>
> Tested-by: Rodrigo Campos <rodrigo@sdfg.com.ar>
> Acked-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/builtin-report.c     | 33 +++++++++++++++++++++++++--------
>  tools/perf/tests/hists_filter.c |  2 +-
>  tools/perf/tests/hists_output.c |  2 +-
>  tools/perf/util/hist.c          | 19 +++++++++++++++++--
>  tools/perf/util/hist.h          |  5 ++++-
>  5 files changed, 48 insertions(+), 13 deletions(-)
> 
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index 6cac509212ee..ed9f74dc2d27 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -80,14 +80,31 @@ static int report__config(const char *var, const char *value, void *cb)
>  	return perf_default_config(var, value, cb);
>  }
>  
> -static void report__inc_stats(struct report *rep,
> -			      struct hist_entry *he __maybe_unused)
> +static void report__inc_stats(struct report *rep, struct hist_entry *he)
>  {
>  	/*
> -	 * We cannot access @he at this time.  Just assume it's a new entry.
> -	 * It'll be fixed once we have a callback mechanism in hist_iter.
> +	 * The @he is either of a newly created one or an existing one
> +	 * merging current sample.  We only want to count a new one so
> +	 * checking ->nr_events being 1.
>  	 */
> -	rep->nr_entries++;
> +	if (he->stat.nr_events == 1)
> +		rep->nr_entries++;
> +}
> +
> +static int hist_iter__report_callback(struct hist_entry_iter *iter,
> +				      struct addr_location *al, void *arg)
> +{
> +	int err = 0;
> +	struct hist_entry *he = iter->he;
> +	struct perf_evsel *evsel = iter->evsel;
> +	struct report *rep = arg;
> +
> +	if (ui__has_annotation())
> +		err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);

if we put the annotation stats in here, shouldn't we remove all other
instancies of above call from:

  iter_finish_normal_entry
  iter_add_single_cumulative_entry
  iter_finish_mem_entry


SNIP

>  
> @@ -883,10 +886,22 @@ int hist_entry_iter__add(struct hist_entry_iter *iter, struct addr_location *al,
>  	if (err)
>  		goto out;
>  
> +	if (iter->he && iter->add_entry_cb) {
> +		err = iter->add_entry_cb(iter, al, arg);
> +		if (err)
> +			goto out;
> +	}
> +
>  	while (iter->ops->next_entry(iter, al)) {
>  		err = iter->ops->add_next_entry(iter, al);
>  		if (err)
>  			break;
> +
> +		if (iter->he && iter->add_entry_cb) {
> +			err = iter->add_entry_cb(iter, al, arg);
> +			if (err)
> +				goto out;
> +		}

hm, the callback code is identical.. do we want a function for this?

jirka
