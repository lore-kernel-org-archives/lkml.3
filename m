Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbaHKNMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 09:12:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315AbaHKNMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 09:12:35 -0400
Date: Mon, 11 Aug 2014 15:12:05 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 34/41] perf evlist: Add 'system_wide' option
Message-ID: <20140811131205.GC31858@krava.brq.redhat.com>
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
 <1405332185-4050-35-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405332185-4050-35-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 01:02:58PM +0300, Adrian Hunter wrote:
> Add an option to cause a selected event
> to be opened always without a pid when
> configured by perf_evsel__config().
> 
> This is needed when using the sched_switch
> tracepoint to follow object code execution.
> sched_switch occurs before the task
> switch and so it cannot record it in a
> context limited to that task.  Note
> that also means that sched_switch is
> useless when capturing data per-thread,
> as is the 'context-switches' software
> event for the same reason.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/util/evlist.c | 45 +++++++++++++++++++++++++++++++++++++--------
>  tools/perf/util/evsel.c  | 31 ++++++++++++++++++++++++++-----
>  tools/perf/util/evsel.h  |  1 +
>  3 files changed, 64 insertions(+), 13 deletions(-)
> 
> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> index 282e83e..c295b7b 100644
> --- a/tools/perf/util/evlist.c
> +++ b/tools/perf/util/evlist.c
> @@ -265,17 +265,27 @@ int perf_evlist__add_newtp(struct perf_evlist *evlist,
>  	return 0;
>  }
>  
> +static int perf_evlist__nr_threads(struct perf_evlist *evlist,
> +				   struct perf_evsel *evsel)
> +{
> +	if (evsel->system_wide)
> +		return 1;
> +	else
> +		return thread_map__nr(evlist->threads);
> +}

how is 'evsel->system_wide' set?

jirka
