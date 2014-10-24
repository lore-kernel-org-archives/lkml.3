Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285AbaJXKnZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 06:43:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:35455 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756148AbaJXKnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 06:43:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,779,1406617200"; 
   d="scan'208";a="624561897"
Message-ID: <544A2CF1.7070802@intel.com>
Date: Fri, 24 Oct 2014 13:41:53 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 03/16] perf session: Add perf_session__deliver_synth_event()
References: <1414061124-26830-1-git-send-email-adrian.hunter@intel.com>	<1414061124-26830-4-git-send-email-adrian.hunter@intel.com> <87tx2uca9w.fsf@sejong.aot.lge.com>
In-Reply-To: <87tx2uca9w.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/10/14 08:22, Namhyung Kim wrote:
> On Thu, 23 Oct 2014 13:45:11 +0300, Adrian Hunter wrote:
>> Add a function to deliver synthesized events from
>> within a session.
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>  tools/perf/util/session.c | 14 ++++++++++++++
>>  tools/perf/util/session.h |  5 +++++
>>  2 files changed, 19 insertions(+)
>>
>> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
>> index d70e37d..09635d1 100644
>> --- a/tools/perf/util/session.c
>> +++ b/tools/perf/util/session.c
>> @@ -907,6 +907,20 @@ static s64 perf_session__process_user_event(struct perf_session *session,
>>  	}
>>  }
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
>> +	return perf_session__deliver_event(session, event, sample, tool, 0);
>> +}
> 
> It seems that it's basically same as what perf_session__process_event()
> does.  So it might deserve a comment or better changelog why it's needed.

Intel PT decoding works by synthesizing events (primarily branch events)
that can then be consumed by existing tools.  This function will be used to
deliver those events.

> 
> Thanks,
> Namhyung
> 
> 
>> +
>>  static void event_swap(union perf_event *event, bool sample_id_all)
>>  {
>>  	perf_event__swap_op swap;
>> diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
>> index d8521ac..dc26ebf 100644
>> --- a/tools/perf/util/session.h
>> +++ b/tools/perf/util/session.h
>> @@ -127,6 +127,11 @@ extern volatile int session_done;
>>  
>>  #define session_done()	ACCESS_ONCE(session_done)
>>  
>> +int perf_session__deliver_synth_event(struct perf_session *session,
>> +				      union perf_event *event,
>> +				      struct perf_sample *sample,
>> +				      struct perf_tool *tool);
>> +
>>  int perf_event__process_id_index(struct perf_tool *tool,
>>  				 union perf_event *event,
>>  				 struct perf_session *session);
> 
> 

