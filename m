Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274AbaGOScT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 14:32:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:20330 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755810AbaGOScQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 14:32:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,667,1400050800"; 
   d="scan'208";a="573584213"
Message-ID: <53C573A1.7090304@intel.com>
Date: Tue, 15 Jul 2014 21:32:01 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 38/41] perf session: Add perf_session__deliver_synth_event()
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com> <1405332185-4050-39-git-send-email-adrian.hunter@intel.com> <20140715151756.GA6312@kernel.org>
In-Reply-To: <20140715151756.GA6312@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/07/2014 6:17 p.m., Arnaldo Carvalho de Melo wrote:
> Em Mon, Jul 14, 2014 at 01:03:02PM +0300, Adrian Hunter escreveu:
>> Add a function to deliver synthesized events from
>> within a session.
>
> Why not put this in perf_session_deliver_event (and fix its naming,
> renaming it to perf_session__deliver_event)?
>
> The way you did makes me wonder why you want to fallback to
> perf_session_deliver_event, i.e. would a normal event come thru a
> function which name implies it should be used only for synth events?
>
> Also that events_stats__inc() looks suspicious there :-\

What happens is Intel PT (or Intel BTS) data is decoded which
results in (mostly) branch data.  So "branches" events are
synthesized and injected into the event stream using
perf_session__deliver_synth_event().

The structure of perf_session__deliver_synth_event() reflects
the fact that "user" events (not from the kernel) are processed
differently to "real" events (from the kernel or synthesized).

The synthesized branches events are then consumed by the tools
just as though they came directly from the perf.data file
- so updating stats is normal.


>
> - Arnaldo
>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>   tools/perf/util/session.c | 14 ++++++++++++++
>>   tools/perf/util/session.h |  5 +++++
>>   2 files changed, 19 insertions(+)
>>
>> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
>> index 708e1c1..433884c 100644
>> --- a/tools/perf/util/session.c
>> +++ b/tools/perf/util/session.c
>> @@ -1066,6 +1066,20 @@ static s64 perf_session__process_user_event(struct perf_session *session,
>>   	}
>>   }
>>
>> +int perf_session__deliver_synth_event(struct perf_session *session,
>> +				      union perf_event *event,
>> +				      struct perf_sample *sample,
>> +				      struct perf_tool *tool)
>> +{
>> +	events_stats__inc(&session->stats, event->header.type);
>> +
>> +	if (event->header.type >= PERF_RECORD_USER_TYPE_START)
>> +		return perf_session__process_user_event(session, event, tool,
>> +							0);
>> +
>> +	return perf_session_deliver_event(session, event, sample, tool, 0);
>> +}
>> +
>>   static void event_swap(union perf_event *event, bool sample_id_all)
>>   {
>>   	perf_event__swap_op swap;
>> diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
>> index 39327ca..86f1bb4 100644
>> --- a/tools/perf/util/session.h
>> +++ b/tools/perf/util/session.h
>> @@ -130,6 +130,11 @@ extern volatile int session_done;
>>
>>   #define session_done()	(*(volatile int *)(&session_done))
>>
>> +int perf_session__deliver_synth_event(struct perf_session *session,
>> +				      union perf_event *event,
>> +				      struct perf_sample *sample,
>> +				      struct perf_tool *tool);
>> +
>>   int perf_event__process_id_index(struct perf_tool *tool,
>>   				 union perf_event *event,
>>   				 struct perf_session *session);
>> --
>> 1.8.3.2
