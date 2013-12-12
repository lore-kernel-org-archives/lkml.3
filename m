Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602Ab3LLOJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 09:09:55 -0500
Received: from mga01.intel.com ([192.55.52.88]:48574 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396Ab3LLOJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 09:09:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,878,1378882800"; 
   d="scan'208";a="448954989"
Message-ID: <52A9C3AB.9060202@intel.com>
Date: Thu, 12 Dec 2013 16:09:47 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v0 23/71] perf evlist: Add perf_evlist__to_front()
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com> <1386765443-26966-24-git-send-email-alexander.shishkin@linux.intel.com> <20131211193840.GE1458@ghostprotocols.net>
In-Reply-To: <20131211193840.GE1458@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/13 21:38, Arnaldo Carvalho de Melo wrote:
> Em Wed, Dec 11, 2013 at 02:36:35PM +0200, Alexander Shishkin escreveu:
>> From: Adrian Hunter <adrian.hunter@intel.com>
>  
>> Add a function to move a selected event to the front of the list.
>  
>> This is needed because it is not possible to use the
>> PERF_EVENT_IOC_SET_OUTPUT IOCTL from an Instruction Tracing event to a
>> non-Instruction Tracing event.  Thus the Instruction Tracing event
>> must come first.
> 
> 
> The description doesn't matches what the code is doing, as it is moving
> a _group_, not an event.

OK I will rename it

> 
> Also I wonder if you can't do this more effiently by finding where it
> starts, ends and then doing some more splice like operatins instead of
> moving member by member to a temp list. Setting the (next, prev) fields
> of the various sublists to the right places.
> 
> There is even list_cut_position() already in list.h, used with
> list_move() and list_splice() I think you can do it more efficiently,
> I think.

OK

> 
> - Arnaldo
>  
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>  tools/perf/util/evlist.c | 17 +++++++++++++++++
>>  tools/perf/util/evlist.h |  3 +++
>>  2 files changed, 20 insertions(+)
>>
>> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
>> index f9dbf5f..93683bc 100644
>> --- a/tools/perf/util/evlist.c
>> +++ b/tools/perf/util/evlist.c
>> @@ -1216,3 +1216,20 @@ int perf_evlist__strerror_open(struct perf_evlist *evlist __maybe_unused,
>>  
>>  	return 0;
>>  }
>> +
>> +void perf_evlist__to_front(struct perf_evlist *evlist,
>> +			   struct perf_evsel *move_evsel)
>> +{
>> +	struct perf_evsel *evsel, *n;
>> +	LIST_HEAD(move);
>> +
>> +	if (move_evsel == perf_evlist__first(evlist))
>> +		return;
>> +
>> +	list_for_each_entry_safe(evsel, n, &evlist->entries, node) {
>> +		if (evsel->leader == move_evsel->leader)
>> +			list_move_tail(&evsel->node, &move);
>> +	}
>> +
>> +	list_splice(&move, &evlist->entries);
>> +}
>> diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
>> index 8a04aae..9f64ede 100644
>> --- a/tools/perf/util/evlist.h
>> +++ b/tools/perf/util/evlist.h
>> @@ -194,5 +194,8 @@ static inline void perf_mmap__write_tail(struct perf_mmap *md,
>>  }
>>  
>>  bool perf_evlist__can_select_event(struct perf_evlist *evlist, const char *str);
>> +void perf_evlist__to_front(struct perf_evlist *evlist,
>> +			   struct perf_evsel *move_evsel);
>> +
>>  
>>  #endif /* __PERF_EVLIST_H */
>> -- 
>> 1.8.5.1
> 
> 

