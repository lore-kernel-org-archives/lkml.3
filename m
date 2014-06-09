Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933359AbaFIKXH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 06:23:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932611AbaFIKXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 06:23:04 -0400
Date: Mon, 9 Jun 2014 12:22:31 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] perf record: Fix to honor user freq/interval properly
Message-ID: <20140609102231.GA7385@krava.redhat.com>
References: <1402292617-26278-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402292617-26278-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 02:43:37PM +0900, Namhyung Kim wrote:
> When configuring event perf checked a wrong condition that user
> specified both of freq (-F) and period (-c) or the event has no
> default value.  This worked because most of events don't have default
> value and only tracepoint events have default of 1 (and it's not
> desirable to change it for those events).
> 
> However, Andi's downloadable event patch changes the situation so it
> cannot change the value for those events.  Fix it by allowing override
> the default value if user gives one of the options.
> 
>   $ perf record -a -e uops_retired.all -F 4000 sleep 1
>   [ perf record: Woken up 1 times to write data ]
>   [ perf record: Captured and wrote 0.325 MB perf.data (~14185 samples) ]
> 
>   $ perf evlist -F
>   cpu/uops_retired.all/: sample_freq=4000
> 
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/evsel.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index 5c28d82b76c4..5ff811c67adc 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -589,10 +589,10 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
>  	}
>  
>  	/*
> -	 * We default some events to a 1 default interval. But keep
> +	 * We default some events to have a default interval. But keep
>  	 * it a weak assumption overridable by the user.
>  	 */
> -	if (!attr->sample_period || (opts->user_freq != UINT_MAX &&
> +	if (!attr->sample_period || (opts->user_freq != UINT_MAX ||
>  				     opts->user_interval != ULLONG_MAX)) {

seems ok to me, maybe we could fixup brackets in that condition so
it does not seems like there's some hidden message ;-)

Acked-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka
