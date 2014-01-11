Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbaAKQYc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 11:24:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126AbaAKQYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 11:24:30 -0500
Date: Sat, 11 Jan 2014 17:24:08 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [PATCH 23/28] perf tools: Factor out hist_entry_iter code
Message-ID: <20140111162408.GE1131@krava.brq.redhat.com>
References: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
 <1389170793-21926-24-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389170793-21926-24-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 05:46:28PM +0900, Namhyung Kim wrote:
> Now the hist_entry_iter code will be shared with perf top code base.
> So move it to util/hist.c and do some necessary cleanups and renames.

factoring code from this very patchset.. looks like it could be easily
squashed with:
  perf tools: Introduce struct hist_entry_iter

jirka

> 
> Cc: Arun Sharma <asharma@fb.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/builtin-report.c | 468 +-------------------------------------------
>  tools/perf/util/hist.c      | 441 +++++++++++++++++++++++++++++++++++++++++
>  tools/perf/util/hist.h      |  30 +++
>  3 files changed, 477 insertions(+), 462 deletions(-)
> 

SNIP

> -	err = iter->prepare_entry(iter, al);
> -	if (err)
> -		goto out;
> -
> -	err = iter->add_single_entry(iter, al);
> -	if (err)
> -		goto out;
> -
> -	while (iter->next_entry(iter, al)) {
> -		err = iter->add_next_entry(iter, al);
> -		if (err)
> -			break;
> -	}
> -
> -out:
> -	err2 = iter->finish_entry(iter, al);
> -	if (!err)
> -		err = err2;
> -
> -	return err;
> -}
> -
>  static int process_sample_event(struct perf_tool *tool,
>  				union perf_event *event,
>  				struct perf_sample *sample,
> @@ -555,23 +103,19 @@ static int process_sample_event(struct perf_tool *tool,
>  		return 0;
>  
>  	if (sort__mode == SORT_MODE__BRANCH)
> -		iter = &branch_iter;
> +		iter = &hist_iter_branch;
>  	else if (rep->mem_mode == 1)
> -		iter = &mem_iter;
> +		iter = &hist_iter_mem;
>  	else if (symbol_conf.cumulate_callchain)
> -		iter = &cumulative_iter;
> +		iter = &hist_iter_cumulative;
>  	else
> -		iter = &normal_iter;
> +		iter = &hist_iter_normal;

looks like we could add 'struct hist_entry_iter_ops' and ops
pointer in 'struct hist_entry_iter' ...just feel better ;-)

jirka
