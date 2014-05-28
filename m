Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbaE1Xqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 19:46:42 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:48406 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaE1Xql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 19:46:41 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
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
References: <1400839463-21933-1-git-send-email-namhyung@kernel.org>
	<1400839463-21933-2-git-send-email-namhyung@kernel.org>
	<20140526184425.GC9699@krava.brq.redhat.com>
Date: Thu, 29 May 2014 08:46:38 +0900
In-Reply-To: <20140526184425.GC9699@krava.brq.redhat.com> (Jiri Olsa's message
	of "Mon, 26 May 2014 20:44:25 +0200")
Message-ID: <874n09ii01.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Mon, 26 May 2014 20:44:25 +0200, Jiri Olsa wrote:
> On Fri, May 23, 2014 at 07:03:58PM +0900, Namhyung Kim wrote:
>> There're some duplicate code when adding hist entries.  They are
>> different in that some have branch info or mem info but generally do
>> same thing.  So introduce new struct hist_entry_iter and add callbacks
>> to customize each case in general way.
>> 
>> The new perf_evsel__add_entry() function will look like:
>> 
>>   iter->prepare_entry();
>>   iter->add_single_entry();
>> 
>>   while (iter->next_entry())
>>     iter->add_next_entry();
>> 
>>   iter->finish_entry();
>> 
>> This will help further work like the cumulative callchain patchset.
>> 
>> Tested-by: Arun Sharma <asharma@fb.com>
>> Tested-by: Rodrigo Campos <rodrigo@sdfg.com.ar>
>> Acked-by: Jiri Olsa <jolsa@redhat.com>
>> Cc: David Ahern <dsahern@gmail.com>
>> Cc: Stephane Eranian <eranian@google.com>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>> ---
>>  tools/perf/builtin-report.c     | 194 +++----------------------
>>  tools/perf/tests/hists_filter.c |  18 +--
>>  tools/perf/tests/hists_output.c |  11 +-
>>  tools/perf/util/hist.c          | 303 ++++++++++++++++++++++++++++++++++++++++
>>  tools/perf/util/hist.h          |  33 +++++
>>  5 files changed, 371 insertions(+), 188 deletions(-)
>> 
>> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
>> index bc0eec1ce4be..d224f5961faa 100644
>> --- a/tools/perf/builtin-report.c
>> +++ b/tools/perf/builtin-report.c
>> @@ -76,165 +76,6 @@ static int report__config(const char *var, const char *value, void *cb)
>>  	return perf_default_config(var, value, cb);
>>  }
>>  
>> -static void report__inc_stats(struct report *rep, struct hist_entry *he)
>> -{
>> -	/*
>> -	 * The @he is either of a newly created one or an existing one
>> -	 * merging current sample.  We only want to count a new one so
>> -	 * checking ->nr_events being 1.
>> -	 */
>> -	if (he->stat.nr_events == 1)
>> -		rep->nr_entries++;
>> -
>
> hm.. above is report specific counter update
>
> while below code is repeated for each iterator in finish_entry,
> maybe we should separated this and put below into a function
> called from generic part

Right.  I'll separate the generic part into a function.

The problem of calling report__inc_stats() in process_sample_event() is
that the hist_entry is no longer available.  And each mode has slightly
different behavior when accounting entries so it's inaccurate at this
stage.  Once we have the callback mechanism later in this series, it'll
be solved.

Thanks,
Namhyung

>
>> -	/*
>> -	 * Only counts number of samples at this stage as it's more
>> -	 * natural to do it here and non-sample events are also
>> -	 * counted in perf_session_deliver_event().  The dump_trace
>> -	 * requires this info is ready before going to the output tree.
>> -	 */
>> -	hists__inc_nr_events(he->hists, PERF_RECORD_SAMPLE);
>> -	if (!he->filtered)
>> -		he->hists->stats.nr_non_filtered_samples++;
>> -}
>
> jirka
