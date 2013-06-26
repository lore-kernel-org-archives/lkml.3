Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805Ab3FZUsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 16:48:51 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:62714 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab3FZUsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 16:48:50 -0400
Message-ID: <51CB53A9.80004@gmail.com>
Date: Wed, 26 Jun 2013 14:48:41 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 12/15] perf tools: allow non-matching sample types
References: <1372079772-20803-1-git-send-email-adrian.hunter@intel.com> <1372079772-20803-13-git-send-email-adrian.hunter@intel.com>
In-Reply-To: <1372079772-20803-13-git-send-email-adrian.hunter@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo:

I noticed this patch in your perf/core branch. I do not think this one 
is ready to be committed. It does not fully solve the problem of 
allowing non-matching sample types.

I have a set of patches here on github that work fine for one use case 
-- mixed s/w and tracepoint events: 
https://github.com/dsahern/linux/tree/multiple-sample_type

I'll push the patches out, but wanted to run some more test cases first.

David

On 6/24/13 7:16 AM, Adrian Hunter wrote:
> Sample types need not be identical to determine
> the sample id from the event.  Only the position
> of the sample id needs to be the same.
>
> Compatible sample types are ones in which the bits
> defined by PERF_COMPAT_MASK are the same.
> 'perf_evlist__config()' forces sample types to be
> compatible on that basis.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>   tools/perf/util/event.h  |  6 ++++
>   tools/perf/util/evlist.c | 93 ++++++++++++++++++++++++++++++++++++++++++++++--
>   tools/perf/util/evlist.h |  3 ++
>   tools/perf/util/evsel.c  | 41 +++++++++++++++++++++
>   tools/perf/util/evsel.h  |  4 +++
>   5 files changed, 145 insertions(+), 2 deletions(-)
>
> diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
> index 1813895..858572f 100644
> --- a/tools/perf/util/event.h
> +++ b/tools/perf/util/event.h
> @@ -65,6 +65,12 @@ struct read_event {
>   	PERF_SAMPLE_ID | PERF_SAMPLE_STREAM_ID |	\
>   	 PERF_SAMPLE_CPU | PERF_SAMPLE_PERIOD)
>
> +#define PERF_COMPAT_MASK				\
> +	(PERF_SAMPLE_IP   | PERF_SAMPLE_TID       |	\
> +	 PERF_SAMPLE_TIME | PERF_SAMPLE_ADDR      |	\
> +	 PERF_SAMPLE_ID   | PERF_SAMPLE_STREAM_ID |	\
> +	 PERF_SAMPLE_CPU)
> +
>   struct sample_event {
>   	struct perf_event_header        header;
>   	u64 array[];
> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> index a660f56..85c4d91 100644
> --- a/tools/perf/util/evlist.c
> +++ b/tools/perf/util/evlist.c
> @@ -49,10 +49,20 @@ struct perf_evlist *perf_evlist__new(void)
>   	return evlist;
>   }
>
> +static void perf_evlist__set_id_pos(struct perf_evlist *evlist)
> +{
> +	struct perf_evsel *first = perf_evlist__first(evlist);
> +
> +	evlist->id_pos = first->id_pos;
> +	evlist->is_pos = first->is_pos;
> +}
> +
>   void perf_evlist__config(struct perf_evlist *evlist,
>   			struct perf_record_opts *opts)
>   {
>   	struct perf_evsel *evsel;
> +	u64 compat = 0;
> +
>   	/*
>   	 * Set the evsel leader links before we configure attributes,
>   	 * since some might depend on this info.
> @@ -68,7 +78,15 @@ void perf_evlist__config(struct perf_evlist *evlist,
>
>   		if (evlist->nr_entries > 1)
>   			perf_evsel__set_sample_id(evsel);
> +		compat |= evsel->attr.sample_type & PERF_COMPAT_MASK;
>   	}
> +
> +	list_for_each_entry(evsel, &evlist->entries, node) {
> +		evsel->attr.sample_type |= compat;
> +		perf_evsel__calc_id_pos(evsel);
> +	}
> +
> +	perf_evlist__set_id_pos(evlist);
>   }
>
>   static void perf_evlist__purge(struct perf_evlist *evlist)
> @@ -102,6 +120,7 @@ void perf_evlist__add(struct perf_evlist *evlist, struct perf_evsel *entry)
>   {
>   	list_add_tail(&entry->node, &evlist->entries);
>   	++evlist->nr_entries;
> +	perf_evlist__set_id_pos(evlist);
>   }
>
>   void perf_evlist__splice_list_tail(struct perf_evlist *evlist,
> @@ -110,6 +129,7 @@ void perf_evlist__splice_list_tail(struct perf_evlist *evlist,
>   {
>   	list_splice_tail(list, &evlist->entries);
>   	evlist->nr_entries += nr_entries;
> +	perf_evlist__set_id_pos(evlist);
>   }
>
>   void __perf_evlist__set_leader(struct list_head *list)
> @@ -339,6 +359,55 @@ struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id)
>   	return NULL;
>   }
>
> +static int perf_evlist__event2id(struct perf_evlist *evlist,
> +				 union perf_event *event, u64 *id)
> +{
> +	const u64 *array = event->sample.array;
> +	ssize_t n;
> +
> +	n = (event->header.size - sizeof(event->header)) >> 3;
> +
> +	if (event->header.type == PERF_RECORD_SAMPLE) {
> +		if (evlist->id_pos >= n)
> +			return -1;
> +		*id = array[evlist->id_pos];
> +	} else {
> +		if (evlist->is_pos >= n)
> +			return -1;
> +		n -= evlist->is_pos;
> +		*id = array[n];
> +	}
> +	return 0;
> +}
> +
> +static struct perf_evsel *perf_evlist__event2evsel(struct perf_evlist *evlist,
> +						   union perf_event *event)
> +{
> +	struct hlist_head *head;
> +	struct perf_sample_id *sid;
> +	int hash;
> +	u64 id;
> +
> +	if (evlist->nr_entries == 1 || evlist->matching_sample_types)
> +		return perf_evlist__first(evlist);
> +
> +	if (perf_evlist__event2id(evlist, event, &id))
> +		return NULL;
> +
> +	/* Synthesized events have an id of zero */
> +	if (!id)
> +		return perf_evlist__first(evlist);
> +
> +	hash = hash_64(id, PERF_EVLIST__HLIST_BITS);
> +	head = &evlist->heads[hash];
> +
> +	hlist_for_each_entry(sid, head, node) {
> +		if (sid->id == id)
> +			return sid->evsel;
> +	}
> +	return NULL;
> +}
> +
>   union perf_event *perf_evlist__mmap_read(struct perf_evlist *evlist, int idx)
>   {
>   	struct perf_mmap *md = &evlist->mmap[idx];
> @@ -650,9 +719,26 @@ int perf_evlist__set_filter(struct perf_evlist *evlist, const char *filter)
>   bool perf_evlist__valid_sample_type(struct perf_evlist *evlist)
>   {
>   	struct perf_evsel *first = perf_evlist__first(evlist), *pos = first;
> +	bool ok = true;
>
>   	list_for_each_entry_continue(pos, &evlist->entries, node) {
> -		if (first->attr.sample_type != pos->attr.sample_type)
> +		if (first->attr.sample_type != pos->attr.sample_type) {
> +			ok = false;
> +			break;
> +		}
> +	}
> +
> +	if (ok) {
> +		evlist->matching_sample_types = true;
> +		return true;
> +	}
> +
> +	if (evlist->id_pos < 0 || evlist->is_pos < 0)
> +		return false;
> +
> +	list_for_each_entry(pos, &evlist->entries, node) {
> +		if (pos->id_pos != evlist->id_pos ||
> +		    pos->is_pos != evlist->is_pos)
>   			return false;
>   	}
>
> @@ -848,7 +934,10 @@ int perf_evlist__start_workload(struct perf_evlist *evlist)
>   int perf_evlist__parse_sample(struct perf_evlist *evlist, union perf_event *event,
>   			      struct perf_sample *sample)
>   {
> -	struct perf_evsel *evsel = perf_evlist__first(evlist);
> +	struct perf_evsel *evsel = perf_evlist__event2evsel(evlist, event);
> +
> +	if (!evsel)
> +		return -EFAULT;
>   	return perf_evsel__parse_sample(evsel, event, sample);
>   }
>
> diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
> index 0583d36..bfcbf67 100644
> --- a/tools/perf/util/evlist.h
> +++ b/tools/perf/util/evlist.h
> @@ -32,11 +32,14 @@ struct perf_evlist {
>   	int		 nr_fds;
>   	int		 nr_mmaps;
>   	int		 mmap_len;
> +	int		 id_pos;
> +	int		 is_pos;
>   	struct {
>   		int	cork_fd;
>   		pid_t	pid;
>   	} workload;
>   	bool		 overwrite;
> +	bool		 matching_sample_types;
>   	struct perf_mmap *mmap;
>   	struct pollfd	 *pollfd;
>   	struct thread_map *threads;
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index d01d2cd..ee0f894 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -46,6 +46,46 @@ static int __perf_evsel__sample_size(u64 sample_type)
>   	return size;
>   }
>
> +static int __perf_evsel__calc_id_pos(u64 sample_type)
> +{
> +	u64 mask;
> +	int i, idx;
> +
> +	if (!(sample_type & PERF_SAMPLE_ID))
> +		return -1;
> +
> +	mask = sample_type & (PERF_SAMPLE_ID - 1);
> +
> +	for (i = 0, idx = 0; i < 64; i++) {
> +		if (mask & (1ULL << i))
> +			idx++;
> +	}
> +
> +	return idx;
> +}
> +
> +static int __perf_evsel__calc_is_pos(u64 sample_type)
> +{
> +	int idx = 1;
> +
> +	if (!(sample_type & PERF_SAMPLE_ID))
> +		return -1;
> +
> +	if (sample_type & PERF_SAMPLE_CPU)
> +		idx += 1;
> +
> +	if (sample_type & PERF_SAMPLE_STREAM_ID)
> +		idx += 1;
> +
> +	return idx;
> +}
> +
> +void perf_evsel__calc_id_pos(struct perf_evsel *evsel)
> +{
> +	evsel->id_pos = __perf_evsel__calc_id_pos(evsel->attr.sample_type);
> +	evsel->is_pos = __perf_evsel__calc_is_pos(evsel->attr.sample_type);
> +}
> +
>   void hists__init(struct hists *hists)
>   {
>   	memset(hists, 0, sizeof(*hists));
> @@ -89,6 +129,7 @@ void perf_evsel__init(struct perf_evsel *evsel,
>   	INIT_LIST_HEAD(&evsel->node);
>   	hists__init(&evsel->hists);
>   	evsel->sample_size = __perf_evsel__sample_size(attr->sample_type);
> +	perf_evsel__calc_id_pos(evsel);
>   }
>
>   struct perf_evsel *perf_evsel__new(struct perf_event_attr *attr, int idx)
> diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
> index 3f156cc..88b4319 100644
> --- a/tools/perf/util/evsel.h
> +++ b/tools/perf/util/evsel.h
> @@ -71,6 +71,8 @@ struct perf_evsel {
>   	} handler;
>   	struct cpu_map		*cpus;
>   	unsigned int		sample_size;
> +	int			id_pos;
> +	int			is_pos;
>   	bool 			supported;
>   	bool 			needs_swap;
>   	/* parse modifier helper */
> @@ -100,6 +102,8 @@ void perf_evsel__delete(struct perf_evsel *evsel);
>   void perf_evsel__config(struct perf_evsel *evsel,
>   			struct perf_record_opts *opts);
>
> +void perf_evsel__calc_id_pos(struct perf_evsel *evsel);
> +
>   bool perf_evsel__is_cache_op_valid(u8 type, u8 op);
>
>   #define PERF_EVSEL__MAX_ALIASES 8
>

