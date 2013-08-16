Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab3HPSlM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 14:41:12 -0400
Received: from mail-gh0-f181.google.com ([209.85.160.181]:63580 "EHLO
	mail-gh0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab3HPSlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 14:41:09 -0400
Date: Fri, 16 Aug 2013 15:41:00 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V11 03/15] perf tools: allow non-matching sample types
Message-ID: <20130816184100.GA1970@ghostprotocols.net>
References: <1376484517-5339-1-git-send-email-adrian.hunter@intel.com>
 <1376484517-5339-4-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376484517-5339-4-git-send-email-adrian.hunter@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 14, 2013 at 03:48:25PM +0300, Adrian Hunter escreveu:
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
>  tools/perf/builtin-report.c |   2 +-
>  tools/perf/util/event.h     |  14 +++++
>  tools/perf/util/evlist.c    | 136 ++++++++++++++++++++++++++++++++++++++++++--
>  tools/perf/util/evlist.h    |   8 ++-
>  tools/perf/util/evsel.c     |  64 ++++++++++++++++++++-
>  tools/perf/util/evsel.h     |  10 ++++
>  tools/perf/util/session.c   |   4 +-
>  7 files changed, 228 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index 958a56a..9725aa3 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -365,7 +365,7 @@ static int process_read_event(struct perf_tool *tool,
>  static int perf_report__setup_sample_type(struct perf_report *rep)
>  {
>  	struct perf_session *self = rep->session;
> -	u64 sample_type = perf_evlist__sample_type(self->evlist);
> +	u64 sample_type = perf_evlist__combined_sample_type(self->evlist);
>  
>  	if (!self->fd_pipe && !(sample_type & PERF_SAMPLE_CALLCHAIN)) {
>  		if (sort__has_parent) {
> diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
> index 15db071..f6c45fd 100644
> --- a/tools/perf/util/event.h
> +++ b/tools/perf/util/event.h
> @@ -65,6 +65,20 @@ struct read_event {
>  	PERF_SAMPLE_ID | PERF_SAMPLE_STREAM_ID |	\
>  	 PERF_SAMPLE_CPU | PERF_SAMPLE_PERIOD)
>  
> +/*
> + * Events have compatible sample types if the following bits all have the same
> + * value.  This is because the order of sample members is fixed.  For sample
> + * events the order is: PERF_SAMPLE_IP, PERF_SAMPLE_TID, PERF_SAMPLE_TIME,
> + * PERF_SAMPLE_ADDR, PERF_SAMPLE_ID.  For non-sample events the sample members
> + * are accessed in reverse order.  The order is: PERF_SAMPLE_ID,
> + * PERF_SAMPLE_STREAM_ID, PERF_SAMPLE_CPU.
> + */
> +#define PERF_COMPAT_MASK				\
> +	(PERF_SAMPLE_IP   | PERF_SAMPLE_TID       |	\
> +	 PERF_SAMPLE_TIME | PERF_SAMPLE_ADDR      |	\
> +	 PERF_SAMPLE_ID   | PERF_SAMPLE_STREAM_ID |	\
> +	 PERF_SAMPLE_CPU)
> +
>  struct sample_event {
>  	struct perf_event_header        header;
>  	u64 array[];
> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> index 1f5105a..2e5c0b7 100644
> --- a/tools/perf/util/evlist.c
> +++ b/tools/perf/util/evlist.c
> @@ -49,6 +49,46 @@ struct perf_evlist *perf_evlist__new(void)
>  	return evlist;
>  }
>  
> +/**
> + * perf_evlist__set_id_pos - set the positions of event ids.
> + * @evlist: selected event list
> + *
> + * Events with compatible sample types all have the same id_pos
> + * and is_pos.  For convenience, put a copy on evlist.
> + */
> +static void perf_evlist__set_id_pos(struct perf_evlist *evlist)
> +{
> +	struct perf_evsel *first = perf_evlist__first(evlist);
> +
> +	evlist->id_pos = first->id_pos;
> +	evlist->is_pos = first->is_pos;
> +}
> +
> +/**
> + * perf_evlist__make_sample_types_compatible - make sample types compatible.
> + * @evlist: selected event list
> + *
> + * Events with compatible sample types all have the same id_pos and is_pos.
> + * This can be achieved by matching the bits of PERF_COMPAT_MASK.
> + */
> +void perf_evlist__make_sample_types_compatible(struct perf_evlist *evlist)
> +{
> +	struct perf_evsel *evsel;
> +	u64 compat = 0;
> +
> +	list_for_each_entry(evsel, &evlist->entries, node)
> +		compat |= evsel->attr.sample_type & PERF_COMPAT_MASK;
> +
> +	list_for_each_entry(evsel, &evlist->entries, node) {
> +		evsel->attr.sample_type |= compat;
> +		evsel->sample_size =
> +			__perf_evsel__sample_size(evsel->attr.sample_type);
> +		perf_evsel__calc_id_pos(evsel);
> +	}
> +
> +	perf_evlist__set_id_pos(evlist);
> +}
> +
>  void perf_evlist__config(struct perf_evlist *evlist,
>  			struct perf_record_opts *opts)
>  {
> @@ -69,6 +109,8 @@ void perf_evlist__config(struct perf_evlist *evlist,
>  		if (evlist->nr_entries > 1)
>  			perf_evsel__set_sample_id(evsel);
>  	}
> +
> +	perf_evlist__make_sample_types_compatible(evlist);
>  }
>  
>  static void perf_evlist__purge(struct perf_evlist *evlist)
> @@ -102,6 +144,7 @@ void perf_evlist__add(struct perf_evlist *evlist, struct perf_evsel *entry)
>  {
>  	list_add_tail(&entry->node, &evlist->entries);
>  	++evlist->nr_entries;
> +	perf_evlist__set_id_pos(evlist);

So we repeatedly call this, that will set it to the same element (we add
to the tail)), its not a problem, but wouldn't it be clearer as:

	if (!evlist->nr_entries++)
		perf_evlist__set_id_pos(evlist);

>  }
>  
>  void perf_evlist__splice_list_tail(struct perf_evlist *evlist,
> @@ -110,6 +153,7 @@ void perf_evlist__splice_list_tail(struct perf_evlist *evlist,
>  {
>  	list_splice_tail(list, &evlist->entries);
>  	evlist->nr_entries += nr_entries;
> +	perf_evlist__set_id_pos(evlist);

Ditto.

>  }
>  
>  void __perf_evlist__set_leader(struct list_head *list)
> @@ -371,6 +415,55 @@ struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id)
>  	return NULL;
>  }
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

So this doesn't really maps to the evsel with PERF_SAMPLE_ID, but to a
evsel that has a sample_type that is the same as whatever evsel maps to
what is in PERF_SAMPLE_ID, right?

I think we should use a better name for this function, lets see its
usage...

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
>  union perf_event *perf_evlist__mmap_read(struct perf_evlist *evlist, int idx)
>  {
>  	struct perf_mmap *md = &evlist->mmap[idx];
> @@ -682,19 +775,49 @@ int perf_evlist__set_filter(struct perf_evlist *evlist, const char *filter)
>  bool perf_evlist__valid_sample_type(struct perf_evlist *evlist)
>  {
>  	struct perf_evsel *first = perf_evlist__first(evlist), *pos = first;
> +	bool ok = true;
>  
>  	list_for_each_entry_continue(pos, &evlist->entries, node) {
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

What about:

 	evlist->matching_sample_types = true;
 
 	list_for_each_entry_continue(pos, &evlist->entries, node) {
 		if (first->attr.sample_type != pos->attr.sample_type) {
 			evlist->matching_sample_types = false;
 			break;
 		}
 	}
 
 	if (evlist->matching_sample_types)
 		return true;

> +	if (evlist->id_pos < 0 || evlist->is_pos < 0)
> +		return false;

Where do we set this?

If this is the case why don't we test it as the first step in this
perf_evlist__valid_sample_type() function?

Humm, probably if matching_sample_types is true the values of these
variables are not used at all?

> +	list_for_each_entry(pos, &evlist->entries, node) {
> +		if (pos->id_pos != evlist->id_pos ||
> +		    pos->is_pos != evlist->is_pos)
>  			return false;
>  	}
>  
>  	return true;
>  }
>  
> -u64 perf_evlist__sample_type(struct perf_evlist *evlist)
> +u64 __perf_evlist__combined_sample_type(struct perf_evlist *evlist)
>  {
> -	struct perf_evsel *first = perf_evlist__first(evlist);
> -	return first->attr.sample_type;
> +	struct perf_evsel *evsel;
> +
> +	if (evlist->combined_sample_type)
> +		return evlist->combined_sample_type;
> +
> +	list_for_each_entry(evsel, &evlist->entries, node)
> +		evlist->combined_sample_type |= evsel->attr.sample_type;
> +
> +	return evlist->combined_sample_type;
> +}
> +
> +u64 perf_evlist__combined_sample_type(struct perf_evlist *evlist)
> +{
> +	evlist->combined_sample_type = 0;
> +	return __perf_evlist__combined_sample_type(evlist);
>  }
>  
>  bool perf_evlist__valid_read_format(struct perf_evlist *evlist)
> @@ -907,7 +1030,10 @@ int perf_evlist__start_workload(struct perf_evlist *evlist)
>  int perf_evlist__parse_sample(struct perf_evlist *evlist, union perf_event *event,
>  			      struct perf_sample *sample)
>  {
> -	struct perf_evsel *evsel = perf_evlist__first(evlist);
> +	struct perf_evsel *evsel = perf_evlist__event2evsel(evlist, event);
> +
> +	if (!evsel)
> +		return -EFAULT;

Ok, here, for an evlist with three events with the same sample_type
we'll always get the first event, so:

Can't we have the same sample_type but different sample_regs_user, thus
different sample_size and then this:

        if (type & PERF_SAMPLE_REGS_USER) {
                /* First u64 tells us if we have any regs in sample. */
                u64 avail = *array++;

                if (avail) {
                        data->user_regs.regs = (u64 *)array;
                        array += hweight_long(regs_user);
                }
        }

could break if the first event asked for more registers to be dumped per
sample?

I.e. that optimization to return the first entry needs to look at all
the evsels sample_regs_user?

>  	return perf_evsel__parse_sample(evsel, event, sample);
>  }
>  
> diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
> index 327abab..1019758 100644
> --- a/tools/perf/util/evlist.h
> +++ b/tools/perf/util/evlist.h
> @@ -32,11 +32,15 @@ struct perf_evlist {
>  	int		 nr_fds;
>  	int		 nr_mmaps;
>  	int		 mmap_len;
> +	int		 id_pos;
> +	int		 is_pos;
> +	u64		 combined_sample_type;
>  	struct {
>  		int	cork_fd;
>  		pid_t	pid;
>  	} workload;
>  	bool		 overwrite;
> +	bool		 matching_sample_types;
>  	struct perf_mmap *mmap;
>  	struct pollfd	 *pollfd;
>  	struct thread_map *threads;
> @@ -85,6 +89,7 @@ union perf_event *perf_evlist__mmap_read(struct perf_evlist *self, int idx);
>  int perf_evlist__open(struct perf_evlist *evlist);
>  void perf_evlist__close(struct perf_evlist *evlist);
>  
> +void perf_evlist__make_sample_types_compatible(struct perf_evlist *evlist);
>  void perf_evlist__config(struct perf_evlist *evlist,
>  			 struct perf_record_opts *opts);
>  
> @@ -121,7 +126,8 @@ void __perf_evlist__set_leader(struct list_head *list);
>  void perf_evlist__set_leader(struct perf_evlist *evlist);
>  
>  u64 perf_evlist__read_format(struct perf_evlist *evlist);
> -u64 perf_evlist__sample_type(struct perf_evlist *evlist);
> +u64 __perf_evlist__combined_sample_type(struct perf_evlist *evlist);
> +u64 perf_evlist__combined_sample_type(struct perf_evlist *evlist);
>  bool perf_evlist__sample_id_all(struct perf_evlist *evlist);
>  u16 perf_evlist__id_hdr_size(struct perf_evlist *evlist);
>  
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index ad5f701..565ab55 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -30,7 +30,7 @@ static struct {
>  
>  #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
>  
> -static int __perf_evsel__sample_size(u64 sample_type)
> +int __perf_evsel__sample_size(u64 sample_type)
>  {
>  	u64 mask = sample_type & PERF_SAMPLE_MASK;
>  	int size = 0;
> @@ -46,6 +46,65 @@ static int __perf_evsel__sample_size(u64 sample_type)
>  	return size;
>  }
>  
> +/**
> + * __perf_evsel__calc_id_pos - calculate id_pos.
> + * @sample_type: sample type
> + *
> + * This function returns the position of the event id (PERF_SAMPLE_ID) in a
> + * sample event i.e. in the array of struct sample_event.
> + */
> +static int __perf_evsel__calc_id_pos(u64 sample_type)
> +{
> +	int idx = 0;
> +
> +	if (!(sample_type & PERF_SAMPLE_ID))
> +		return -1;
> +
> +	if (sample_type & PERF_SAMPLE_IP)
> +		idx += 1;
> +
> +	if (sample_type & PERF_SAMPLE_TID)
> +		idx += 1;
> +
> +	if (sample_type & PERF_SAMPLE_TIME)
> +		idx += 1;
> +
> +	if (sample_type & PERF_SAMPLE_ADDR)
> +		idx += 1;
> +
> +	return idx;
> +}
> +
> +/**
> + * __perf_evsel__calc_is_pos - calculate is_pos.
> + * @sample_type: sample type
> + *
> + * This function returns the position (counting backwards) of the event id
> + * (PERF_SAMPLE_ID) in a non-sample event i.e. if sample_id_all is used there is
> + * an id sample appended to non-sample events.
> + */
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
>  void hists__init(struct hists *hists)
>  {
>  	memset(hists, 0, sizeof(*hists));
> @@ -62,6 +121,7 @@ void __perf_evsel__set_sample_bit(struct perf_evsel *evsel,
>  	if (!(evsel->attr.sample_type & bit)) {
>  		evsel->attr.sample_type |= bit;
>  		evsel->sample_size += sizeof(u64);
> +		perf_evsel__calc_id_pos(evsel);
>  	}
>  }
>  
> @@ -71,6 +131,7 @@ void __perf_evsel__reset_sample_bit(struct perf_evsel *evsel,
>  	if (evsel->attr.sample_type & bit) {
>  		evsel->attr.sample_type &= ~bit;
>  		evsel->sample_size -= sizeof(u64);
> +		perf_evsel__calc_id_pos(evsel);
>  	}
>  }
>  
> @@ -89,6 +150,7 @@ void perf_evsel__init(struct perf_evsel *evsel,
>  	INIT_LIST_HEAD(&evsel->node);
>  	hists__init(&evsel->hists);
>  	evsel->sample_size = __perf_evsel__sample_size(attr->sample_type);
> +	perf_evsel__calc_id_pos(evsel);
>  }
>  
>  struct perf_evsel *perf_evsel__new(struct perf_event_attr *attr, int idx)
> diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
> index 532a5f9..3056f4f 100644
> --- a/tools/perf/util/evsel.h
> +++ b/tools/perf/util/evsel.h
> @@ -48,6 +48,11 @@ struct perf_sample_id {
>   * @name - Can be set to retain the original event name passed by the user,
>   *         so that when showing results in tools such as 'perf stat', we
>   *         show the name used, not some alias.
> + * @id_pos: the position of the event id (PERF_SAMPLE_ID) in a sample event
> + *          i.e. in the array of struct sample_event
> + * @is_pos: the position (counting backwards) of the event id (PERF_SAMPLE_ID)
> + *          in a non-sample event i.e. if sample_id_all is used there is an id
> + *          sample appended to non-sample events
>   */
>  struct perf_evsel {
>  	struct list_head	node;
> @@ -74,6 +79,8 @@ struct perf_evsel {
>  	} handler;
>  	struct cpu_map		*cpus;
>  	unsigned int		sample_size;
> +	int			id_pos;
> +	int			is_pos;
>  	bool 			supported;
>  	bool 			needs_swap;
>  	/* parse modifier helper */
> @@ -104,6 +111,9 @@ void perf_evsel__delete(struct perf_evsel *evsel);
>  void perf_evsel__config(struct perf_evsel *evsel,
>  			struct perf_record_opts *opts);
>  
> +int __perf_evsel__sample_size(u64 sample_type);
> +void perf_evsel__calc_id_pos(struct perf_evsel *evsel);
> +
>  bool perf_evsel__is_cache_op_valid(u8 type, u8 op);
>  
>  #define PERF_EVSEL__MAX_ALIASES 8
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index de16a77..0e7ae17 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -739,7 +739,7 @@ static void perf_session__print_tstamp(struct perf_session *session,
>  				       union perf_event *event,
>  				       struct perf_sample *sample)
>  {
> -	u64 sample_type = perf_evlist__sample_type(session->evlist);
> +	u64 sample_type = __perf_evlist__combined_sample_type(session->evlist);
>  
>  	if (event->header.type != PERF_RECORD_SAMPLE &&
>  	    !perf_evlist__sample_id_all(session->evlist)) {
> @@ -1001,7 +1001,7 @@ static int perf_session__preprocess_sample(struct perf_session *session,
>  					   union perf_event *event, struct perf_sample *sample)
>  {
>  	if (event->header.type != PERF_RECORD_SAMPLE ||
> -	    !(perf_evlist__sample_type(session->evlist) & PERF_SAMPLE_CALLCHAIN))
> +	    !sample->callchain)
>  		return 0;
>  
>  	if (!ip_callchain__valid(sample->callchain, event)) {
> -- 
> 1.7.11.7
