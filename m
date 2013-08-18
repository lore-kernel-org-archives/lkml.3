Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab3HRTEZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 15:04:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:8090 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684Ab3HRTEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 15:04:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,908,1367996400"; 
   d="scan'208";a="389139318"
Message-ID: <52111AAE.6060702@intel.com>
Date: Sun, 18 Aug 2013 22:04:14 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V11 03/15] perf tools: allow non-matching sample types
References: <1376484517-5339-1-git-send-email-adrian.hunter@intel.com> <1376484517-5339-4-git-send-email-adrian.hunter@intel.com> <20130816184100.GA1970@ghostprotocols.net>
In-Reply-To: <20130816184100.GA1970@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/08/2013 9:41 p.m., Arnaldo Carvalho de Melo wrote:
> Em Wed, Aug 14, 2013 at 03:48:25PM +0300, Adrian Hunter escreveu:
>> Sample types need not be identical to determine
>> the sample id from the event.  Only the position
>> of the sample id needs to be the same.
>>
>> Compatible sample types are ones in which the bits
>> defined by PERF_COMPAT_MASK are the same.
>> 'perf_evlist__config()' forces sample types to be
>> compatible on that basis.
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>   tools/perf/builtin-report.c |   2 +-
>>   tools/perf/util/event.h     |  14 +++++
>>   tools/perf/util/evlist.c    | 136 ++++++++++++++++++++++++++++++++++++++++++--
>>   tools/perf/util/evlist.h    |   8 ++-
>>   tools/perf/util/evsel.c     |  64 ++++++++++++++++++++-
>>   tools/perf/util/evsel.h     |  10 ++++
>>   tools/perf/util/session.c   |   4 +-
>>   7 files changed, 228 insertions(+), 10 deletions(-)
>>
>> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
>> index 958a56a..9725aa3 100644
>> --- a/tools/perf/builtin-report.c
>> +++ b/tools/perf/builtin-report.c
>> @@ -365,7 +365,7 @@ static int process_read_event(struct perf_tool *tool,
>>   static int perf_report__setup_sample_type(struct perf_report *rep)
>>   {
>>   	struct perf_session *self = rep->session;
>> -	u64 sample_type = perf_evlist__sample_type(self->evlist);
>> +	u64 sample_type = perf_evlist__combined_sample_type(self->evlist);
>>
>>   	if (!self->fd_pipe && !(sample_type & PERF_SAMPLE_CALLCHAIN)) {
>>   		if (sort__has_parent) {
>> diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
>> index 15db071..f6c45fd 100644
>> --- a/tools/perf/util/event.h
>> +++ b/tools/perf/util/event.h
>> @@ -65,6 +65,20 @@ struct read_event {
>>   	PERF_SAMPLE_ID | PERF_SAMPLE_STREAM_ID |	\
>>   	 PERF_SAMPLE_CPU | PERF_SAMPLE_PERIOD)
>>
>> +/*
>> + * Events have compatible sample types if the following bits all have the same
>> + * value.  This is because the order of sample members is fixed.  For sample
>> + * events the order is: PERF_SAMPLE_IP, PERF_SAMPLE_TID, PERF_SAMPLE_TIME,
>> + * PERF_SAMPLE_ADDR, PERF_SAMPLE_ID.  For non-sample events the sample members
>> + * are accessed in reverse order.  The order is: PERF_SAMPLE_ID,
>> + * PERF_SAMPLE_STREAM_ID, PERF_SAMPLE_CPU.
>> + */
>> +#define PERF_COMPAT_MASK				\
>> +	(PERF_SAMPLE_IP   | PERF_SAMPLE_TID       |	\
>> +	 PERF_SAMPLE_TIME | PERF_SAMPLE_ADDR      |	\
>> +	 PERF_SAMPLE_ID   | PERF_SAMPLE_STREAM_ID |	\
>> +	 PERF_SAMPLE_CPU)
>> +
>>   struct sample_event {
>>   	struct perf_event_header        header;
>>   	u64 array[];
>> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
>> index 1f5105a..2e5c0b7 100644
>> --- a/tools/perf/util/evlist.c
>> +++ b/tools/perf/util/evlist.c
>> @@ -49,6 +49,46 @@ struct perf_evlist *perf_evlist__new(void)
>>   	return evlist;
>>   }
>>
>> +/**
>> + * perf_evlist__set_id_pos - set the positions of event ids.
>> + * @evlist: selected event list
>> + *
>> + * Events with compatible sample types all have the same id_pos
>> + * and is_pos.  For convenience, put a copy on evlist.
>> + */
>> +static void perf_evlist__set_id_pos(struct perf_evlist *evlist)
>> +{
>> +	struct perf_evsel *first = perf_evlist__first(evlist);
>> +
>> +	evlist->id_pos = first->id_pos;
>> +	evlist->is_pos = first->is_pos;
>> +}
>> +
>> +/**
>> + * perf_evlist__make_sample_types_compatible - make sample types compatible.
>> + * @evlist: selected event list
>> + *
>> + * Events with compatible sample types all have the same id_pos and is_pos.
>> + * This can be achieved by matching the bits of PERF_COMPAT_MASK.
>> + */
>> +void perf_evlist__make_sample_types_compatible(struct perf_evlist *evlist)
>> +{
>> +	struct perf_evsel *evsel;
>> +	u64 compat = 0;
>> +
>> +	list_for_each_entry(evsel, &evlist->entries, node)
>> +		compat |= evsel->attr.sample_type & PERF_COMPAT_MASK;
>> +
>> +	list_for_each_entry(evsel, &evlist->entries, node) {
>> +		evsel->attr.sample_type |= compat;
>> +		evsel->sample_size =
>> +			__perf_evsel__sample_size(evsel->attr.sample_type);
>> +		perf_evsel__calc_id_pos(evsel);
>> +	}
>> +
>> +	perf_evlist__set_id_pos(evlist);
>> +}
>> +
>>   void perf_evlist__config(struct perf_evlist *evlist,
>>   			struct perf_record_opts *opts)
>>   {
>> @@ -69,6 +109,8 @@ void perf_evlist__config(struct perf_evlist *evlist,
>>   		if (evlist->nr_entries > 1)
>>   			perf_evsel__set_sample_id(evsel);
>>   	}
>> +
>> +	perf_evlist__make_sample_types_compatible(evlist);
>>   }
>>
>>   static void perf_evlist__purge(struct perf_evlist *evlist)
>> @@ -102,6 +144,7 @@ void perf_evlist__add(struct perf_evlist *evlist, struct perf_evsel *entry)
>>   {
>>   	list_add_tail(&entry->node, &evlist->entries);
>>   	++evlist->nr_entries;
>> +	perf_evlist__set_id_pos(evlist);
>
> So we repeatedly call this, that will set it to the same element (we add
> to the tail)), its not a problem, but wouldn't it be clearer as:
>
> 	if (!evlist->nr_entries++)
> 		perf_evlist__set_id_pos(evlist);

OK

>
>>   }
>>
>>   void perf_evlist__splice_list_tail(struct perf_evlist *evlist,
>> @@ -110,6 +153,7 @@ void perf_evlist__splice_list_tail(struct perf_evlist *evlist,
>>   {
>>   	list_splice_tail(list, &evlist->entries);
>>   	evlist->nr_entries += nr_entries;
>> +	perf_evlist__set_id_pos(evlist);
>
> Ditto.

OK

>
>>   }
>>
>>   void __perf_evlist__set_leader(struct list_head *list)
>> @@ -371,6 +415,55 @@ struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id)
>>   	return NULL;
>>   }
>>
>> +static int perf_evlist__event2id(struct perf_evlist *evlist,
>> +				 union perf_event *event, u64 *id)
>> +{
>> +	const u64 *array = event->sample.array;
>> +	ssize_t n;
>> +
>> +	n = (event->header.size - sizeof(event->header)) >> 3;
>> +
>> +	if (event->header.type == PERF_RECORD_SAMPLE) {
>> +		if (evlist->id_pos >= n)
>> +			return -1;
>> +		*id = array[evlist->id_pos];
>> +	} else {
>> +		if (evlist->is_pos >= n)
>> +			return -1;
>> +		n -= evlist->is_pos;
>> +		*id = array[n];
>> +	}
>> +	return 0;
>> +}
>> +
>> +static struct perf_evsel *perf_evlist__event2evsel(struct perf_evlist *evlist,
>> +						   union perf_event *event)
>> +{
>> +	struct hlist_head *head;
>> +	struct perf_sample_id *sid;
>> +	int hash;
>> +	u64 id;
>> +
>> +	if (evlist->nr_entries == 1 || evlist->matching_sample_types)
>> +		return perf_evlist__first(evlist);
>
> So this doesn't really maps to the evsel with PERF_SAMPLE_ID, but to a
> evsel that has a sample_type that is the same as whatever evsel maps to
> what is in PERF_SAMPLE_ID, right?
>
> I think we should use a better name for this function, lets see its
> usage...

I will get rid of evlist->matching_sample_types

>
>> +	if (perf_evlist__event2id(evlist, event, &id))
>> +		return NULL;
>> +
>> +	/* Synthesized events have an id of zero */
>> +	if (!id)
>> +		return perf_evlist__first(evlist);
>> +
>> +	hash = hash_64(id, PERF_EVLIST__HLIST_BITS);
>> +	head = &evlist->heads[hash];
>> +
>> +	hlist_for_each_entry(sid, head, node) {
>> +		if (sid->id == id)
>> +			return sid->evsel;
>> +	}
>> +	return NULL;
>> +}
>> +
>>   union perf_event *perf_evlist__mmap_read(struct perf_evlist *evlist, int idx)
>>   {
>>   	struct perf_mmap *md = &evlist->mmap[idx];
>> @@ -682,19 +775,49 @@ int perf_evlist__set_filter(struct perf_evlist *evlist, const char *filter)
>>   bool perf_evlist__valid_sample_type(struct perf_evlist *evlist)
>>   {
>>   	struct perf_evsel *first = perf_evlist__first(evlist), *pos = first;
>> +	bool ok = true;
>>
>>   	list_for_each_entry_continue(pos, &evlist->entries, node) {
>> -		if (first->attr.sample_type != pos->attr.sample_type)
>> +		if (first->attr.sample_type != pos->attr.sample_type) {
>> +			ok = false;
>> +			break;
>> +		}
>> +	}
>> +
>> +	if (ok) {
>> +		evlist->matching_sample_types = true;
>> +		return true;
>> +	}
>> +
>
> What about:
>
>   	evlist->matching_sample_types = true;
>
>   	list_for_each_entry_continue(pos, &evlist->entries, node) {
>   		if (first->attr.sample_type != pos->attr.sample_type) {
>   			evlist->matching_sample_types = false;
>   			break;
>   		}
>   	}
>
>   	if (evlist->matching_sample_types)
>   		return true;
>

I will get rid of evlist->matching_sample_types

>> +	if (evlist->id_pos < 0 || evlist->is_pos < 0)
>> +		return false;
>
> Where do we set this?

id_pos and is_pos are calculated by __perf_evsel__calc_id_pos() and 
__perf_evsel__calc_is_pos().  -1 means there was no PERF_SAMPLE_ID.

>
> If this is the case why don't we test it as the first step in this
> perf_evlist__valid_sample_type() function?
>
> Humm, probably if matching_sample_types is true the values of these
> variables are not used at all?

Yes, but if I drop matching_sample_types it will be the first thing checked.

>
>> +	list_for_each_entry(pos, &evlist->entries, node) {
>> +		if (pos->id_pos != evlist->id_pos ||
>> +		    pos->is_pos != evlist->is_pos)
>>   			return false;
>>   	}
>>
>>   	return true;
>>   }
>>
>> -u64 perf_evlist__sample_type(struct perf_evlist *evlist)
>> +u64 __perf_evlist__combined_sample_type(struct perf_evlist *evlist)
>>   {
>> -	struct perf_evsel *first = perf_evlist__first(evlist);
>> -	return first->attr.sample_type;
>> +	struct perf_evsel *evsel;
>> +
>> +	if (evlist->combined_sample_type)
>> +		return evlist->combined_sample_type;
>> +
>> +	list_for_each_entry(evsel, &evlist->entries, node)
>> +		evlist->combined_sample_type |= evsel->attr.sample_type;
>> +
>> +	return evlist->combined_sample_type;
>> +}
>> +
>> +u64 perf_evlist__combined_sample_type(struct perf_evlist *evlist)
>> +{
>> +	evlist->combined_sample_type = 0;
>> +	return __perf_evlist__combined_sample_type(evlist);
>>   }
>>
>>   bool perf_evlist__valid_read_format(struct perf_evlist *evlist)
>> @@ -907,7 +1030,10 @@ int perf_evlist__start_workload(struct perf_evlist *evlist)
>>   int perf_evlist__parse_sample(struct perf_evlist *evlist, union perf_event *event,
>>   			      struct perf_sample *sample)
>>   {
>> -	struct perf_evsel *evsel = perf_evlist__first(evlist);
>> +	struct perf_evsel *evsel = perf_evlist__event2evsel(evlist, event);
>> +
>> +	if (!evsel)
>> +		return -EFAULT;
>
> Ok, here, for an evlist with three events with the same sample_type
> we'll always get the first event, so:
>
> Can't we have the same sample_type but different sample_regs_user, thus
> different sample_size and then this:
>
>          if (type & PERF_SAMPLE_REGS_USER) {
>                  /* First u64 tells us if we have any regs in sample. */
>                  u64 avail = *array++;
>
>                  if (avail) {
>                          data->user_regs.regs = (u64 *)array;
>                          array += hweight_long(regs_user);
>                  }
>          }
>
> could break if the first event asked for more registers to be dumped per
> sample?
>
> I.e. that optimization to return the first entry needs to look at all
> the evsels sample_regs_user?
>

That is how it works now - the first evsel is used for parsing.  But 
yes, it is better to remove evlist->matching_sample_types.

