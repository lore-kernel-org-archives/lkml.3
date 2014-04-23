Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861AbaDWNgH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:36:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756057AbaDWNgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:36:02 -0400
Date: Wed, 23 Apr 2014 15:35:36 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/7] perf tools: Account entry stats when it's added to
 the output tree
Message-ID: <20140423133536.GC11124@krava.brq.redhat.com>
References: <1398236408-8856-1-git-send-email-namhyung@kernel.org>
 <1398236408-8856-3-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398236408-8856-3-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 04:00:03PM +0900, Namhyung Kim wrote:
> Currently, accounting each sample is done in multiple places - once
> when adding them to the input tree, other when adding them to the
> output tree.  It's not only confusing but also can cause a subtle
> problem since concurrent processing like in perf top might see the
> updated stats before adding entries into the output tree - like seeing
> more (blank) lines at the end and/or slight inaccurate percentage.
> 
> To fix this, only account the entries when it's moved into the output
> tree so that they cannot be seen prematurely.  There're some
> exceptional cases here and there - they should be addressed separately
> with comments.

sry to be PITA, but need to ask you to split the patch,
otherwise I'd get beaten for that ;-)

I can see several separated changes here:
 * remove stats for input tree (as stated in changelog)
 * hists__inc_nr_entries -> hists__inc_stats rename
 * add hists__reset_stats function
 * move hists__calc_col_len out of hists__inc_nr_entries


> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---

SNIP

>  
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index aed52036468d..4bdcc040b216 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -85,6 +85,10 @@ static void report__inc_stats(struct report *rep, struct hist_entry *he)
>  	 */
>  	if (he->stat.nr_events == 1)
>  		rep->nr_entries++;
> +
> +	hists__inc_nr_events(he->hists, PERF_RECORD_SAMPLE);
> +	if (!he->filtered)
> +		he->hists->stats.nr_non_filtered_samples++;

could you put here some comments as for the diff command
I mean why is this exception in stats counting for input tree

thanks,
jirka
