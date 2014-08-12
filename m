Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbaHLFxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 01:53:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:49908 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394AbaHLFxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 01:53:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,847,1400050800"; 
   d="scan'208";a="575379047"
Message-ID: <53E9AB9B.2080004@intel.com>
Date: Tue, 12 Aug 2014 08:52:27 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 34/41] perf evlist: Add 'system_wide' option
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com> <1405332185-4050-35-git-send-email-adrian.hunter@intel.com> <20140811131205.GC31858@krava.brq.redhat.com>
In-Reply-To: <20140811131205.GC31858@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2014 04:12 PM, Jiri Olsa wrote:
> On Mon, Jul 14, 2014 at 01:02:58PM +0300, Adrian Hunter wrote:
>> Add an option to cause a selected event
>> to be opened always without a pid when
>> configured by perf_evsel__config().
>>
>> This is needed when using the sched_switch
>> tracepoint to follow object code execution.
>> sched_switch occurs before the task
>> switch and so it cannot record it in a
>> context limited to that task.  Note
>> that also means that sched_switch is
>> useless when capturing data per-thread,
>> as is the 'context-switches' software
>> event for the same reason.
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>  tools/perf/util/evlist.c | 45 +++++++++++++++++++++++++++++++++++++--------
>>  tools/perf/util/evsel.c  | 31 ++++++++++++++++++++++++++-----
>>  tools/perf/util/evsel.h  |  1 +
>>  3 files changed, 64 insertions(+), 13 deletions(-)
>>
>> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
>> index 282e83e..c295b7b 100644
>> --- a/tools/perf/util/evlist.c
>> +++ b/tools/perf/util/evlist.c
>> @@ -265,17 +265,27 @@ int perf_evlist__add_newtp(struct perf_evlist *evlist,
>>  	return 0;
>>  }
>>  
>> +static int perf_evlist__nr_threads(struct perf_evlist *evlist,
>> +				   struct perf_evsel *evsel)
>> +{
>> +	if (evsel->system_wide)
>> +		return 1;
>> +	else
>> +		return thread_map__nr(evlist->threads);
>> +}
> 
> how is 'evsel->system_wide' set?

Intel PT sets it for the sched_switch event.


