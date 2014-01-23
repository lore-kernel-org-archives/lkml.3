Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbaAWOof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 09:44:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658AbaAWOod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 09:44:33 -0500
Date: Thu, 23 Jan 2014 15:44:00 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Andi Kleen <andi@firstfloor.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 01/21] perf tools: Introduce struct hist_entry_iter
Message-ID: <20140123144400.GD1180@krava.brq.redhat.com>
References: <1390436045-16830-1-git-send-email-namhyung@kernel.org>
 <1390436045-16830-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390436045-16830-2-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 09:13:45AM +0900, Namhyung Kim wrote:
> There're some duplicate code when adding hist entries.  They are
> different in that some have branch info or mem info but generally do
> same thing.  So introduce new struct hist_entry_iter and add callbacks
> to customize each case in general way.
> 
> The new perf_evsel__add_entry() function will look like:
> 
>   iter->prepare_entry();
>   iter->add_single_entry();
> 
>   while (iter->next_entry())
>     iter->add_next_entry();
> 
>   iter->finish_entry();
> 
> This will help further work like the cumulative callchain patchset.
> 
> Tested-by: Arun Sharma <asharma@fb.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/builtin-report.c | 172 +++----------------------
>  tools/perf/util/hist.c      | 304 ++++++++++++++++++++++++++++++++++++++++++++
>  tools/perf/util/hist.h      |  34 +++++
>  3 files changed, 356 insertions(+), 154 deletions(-)
> 
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index 7ddea46594ae..b6618ecb474a 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -85,144 +85,6 @@ static int report__config(const char *var, const char *value, void *cb)
>  	return perf_default_config(var, value, cb);
>  }
>  
> -static int report__add_mem_hist_entry(struct perf_tool *tool, struct addr_location *al,
> -				      struct perf_sample *sample, struct perf_evsel *evsel,
> -				      union perf_event *event)
> -{
> -	struct report *rep = container_of(tool, struct report, tool);
> -	struct symbol *parent = NULL;
> -	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
> -	struct hist_entry *he;
> -	struct mem_info *mi, *mx;
> -	uint64_t cost;
> -	int err = sample__resolve_callchain(sample, &parent, evsel, al, rep->max_stack);
> -
> -	if (err)
> -		return err;
> -
> -	mi = machine__resolve_mem(al->machine, al->thread, sample, cpumode);
> -	if (!mi)
> -		return -ENOMEM;
> -
> -	if (rep->hide_unresolved && !al->sym)
> -		return 0;

this check seems to be missing in iter_add_single_mem_entry

jirka
