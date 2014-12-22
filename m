Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091AbaLVOwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 09:52:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754842AbaLVOwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 09:52:19 -0500
Date: Mon, 22 Dec 2014 12:52:10 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        linux-kernel@vger.kernel.org, acme@kernel.org
Subject: Re: [PATCH] tools: lib: traceevent: event-parse.c:  Remove some
 unused functions
Message-ID: <20141222145210.GA2188@redhat.com>
References: <1419079541-32288-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419079541-32288-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Dec 20, 2014 at 01:45:41PM +0100, Rickard Strandqvist escreveu:
> Removes some functions that are not used anywhere:
> pevent_get_any_field_val() pevent_get_common_field_val() pevent_event_fields() pevent_event_common_fields() pevent_list_events() pevent_print_event() pevent_data_event_from_type() pevent_register_trace_clock() pevent_pid_is_registered()
> 
> This was partially found by using a static code analysis program called cppcheck.

Steven, Namhyung, Jiri:

Are you ok with me applying this patch? I'm all for it, dead code better
be removed, but I don't know what are your plans wrt synchronization
with the trace-cmd repo.

- Arnaldo
 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  tools/lib/traceevent/event-parse.c |  240 ------------------------------------
>  tools/lib/traceevent/event-parse.h |   16 ---
>  2 files changed, 256 deletions(-)
> 
> diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> index cf3a44b..4287771 100644
> --- a/tools/lib/traceevent/event-parse.c
> +++ b/tools/lib/traceevent/event-parse.c
> @@ -206,35 +206,6 @@ static const char *find_cmdline(struct pevent *pevent, int pid)
>  	return "<...>";
>  }
>  
> -/**
> - * pevent_pid_is_registered - return if a pid has a cmdline registered
> - * @pevent: handle for the pevent
> - * @pid: The pid to check if it has a cmdline registered with.
> - *
> - * Returns 1 if the pid has a cmdline mapped to it
> - * 0 otherwise.
> - */
> -int pevent_pid_is_registered(struct pevent *pevent, int pid)
> -{
> -	const struct cmdline *comm;
> -	struct cmdline key;
> -
> -	if (!pid)
> -		return 1;
> -
> -	if (!pevent->cmdlines && cmdline_init(pevent))
> -		return 0;
> -
> -	key.pid = pid;
> -
> -	comm = bsearch(&key, pevent->cmdlines, pevent->cmdline_count,
> -		       sizeof(*pevent->cmdlines), cmdline_cmp);
> -
> -	if (comm)
> -		return 1;
> -	return 0;
> -}
> -
>  /*
>   * If the command lines have been converted to an array, then
>   * we must add this pid. This is much slower than when cmdlines
> @@ -317,11 +288,6 @@ int pevent_register_comm(struct pevent *pevent, const char *comm, int pid)
>  	return 0;
>  }
>  
> -void pevent_register_trace_clock(struct pevent *pevent, char *trace_clock)
> -{
> -	pevent->trace_clock = trace_clock;
> -}
> -
>  struct func_map {
>  	unsigned long long		addr;
>  	char				*func;
> @@ -4572,18 +4538,6 @@ int pevent_data_type(struct pevent *pevent, struct pevent_record *rec)
>  }
>  
>  /**
> - * pevent_data_event_from_type - find the event by a given type
> - * @pevent: a handle to the pevent
> - * @type: the type of the event.
> - *
> - * This returns the event form a given @type;
> - */
> -struct event_format *pevent_data_event_from_type(struct pevent *pevent, int type)
> -{
> -	return pevent_find_event(pevent, type);
> -}
> -
> -/**
>   * pevent_data_pid - parse the PID from raw data
>   * @pevent: a handle to the pevent
>   * @rec: the record to parse
> @@ -4653,75 +4607,6 @@ static bool is_timestamp_in_us(char *trace_clock, bool use_trace_clock)
>  	return false;
>  }
>  
> -void pevent_print_event(struct pevent *pevent, struct trace_seq *s,
> -			struct pevent_record *record, bool use_trace_clock)
> -{
> -	static const char *spaces = "                    "; /* 20 spaces */
> -	struct event_format *event;
> -	unsigned long secs;
> -	unsigned long usecs;
> -	unsigned long nsecs;
> -	const char *comm;
> -	void *data = record->data;
> -	int type;
> -	int pid;
> -	int len;
> -	int p;
> -	bool use_usec_format;
> -
> -	use_usec_format = is_timestamp_in_us(pevent->trace_clock,
> -							use_trace_clock);
> -	if (use_usec_format) {
> -		secs = record->ts / NSECS_PER_SEC;
> -		nsecs = record->ts - secs * NSECS_PER_SEC;
> -	}
> -
> -	if (record->size < 0) {
> -		do_warning("ug! negative record size %d", record->size);
> -		return;
> -	}
> -
> -	type = trace_parse_common_type(pevent, data);
> -
> -	event = pevent_find_event(pevent, type);
> -	if (!event) {
> -		do_warning("ug! no event found for type %d", type);
> -		return;
> -	}
> -
> -	pid = parse_common_pid(pevent, data);
> -	comm = find_cmdline(pevent, pid);
> -
> -	if (pevent->latency_format) {
> -		trace_seq_printf(s, "%8.8s-%-5d %3d",
> -		       comm, pid, record->cpu);
> -		pevent_data_lat_fmt(pevent, s, record);
> -	} else
> -		trace_seq_printf(s, "%16s-%-5d [%03d]", comm, pid, record->cpu);
> -
> -	if (use_usec_format) {
> -		if (pevent->flags & PEVENT_NSEC_OUTPUT) {
> -			usecs = nsecs;
> -			p = 9;
> -		} else {
> -			usecs = (nsecs + 500) / NSECS_PER_USEC;
> -			p = 6;
> -		}
> -
> -		trace_seq_printf(s, " %5lu.%0*lu: %s: ",
> -					secs, p, usecs, event->name);
> -	} else
> -		trace_seq_printf(s, " %12llu: %s: ",
> -					record->ts, event->name);
> -
> -	/* Space out the event names evenly. */
> -	len = strlen(event->name);
> -	if (len < 20)
> -		trace_seq_printf(s, "%.*s", 20 - len, spaces);
> -
> -	pevent_event_info(s, event, record);
> -}
> -
>  static int events_id_cmp(const void *a, const void *b)
>  {
>  	struct event_format * const * ea = a;
> @@ -4770,53 +4655,6 @@ static int events_system_cmp(const void *a, const void *b)
>  	return events_id_cmp(a, b);
>  }
>  
> -struct event_format **pevent_list_events(struct pevent *pevent, enum event_sort_type sort_type)
> -{
> -	struct event_format **events;
> -	int (*sort)(const void *a, const void *b);
> -
> -	events = pevent->sort_events;
> -
> -	if (events && pevent->last_type == sort_type)
> -		return events;
> -
> -	if (!events) {
> -		events = malloc(sizeof(*events) * (pevent->nr_events + 1));
> -		if (!events)
> -			return NULL;
> -
> -		memcpy(events, pevent->events, sizeof(*events) * pevent->nr_events);
> -		events[pevent->nr_events] = NULL;
> -
> -		pevent->sort_events = events;
> -
> -		/* the internal events are sorted by id */
> -		if (sort_type == EVENT_SORT_ID) {
> -			pevent->last_type = sort_type;
> -			return events;
> -		}
> -	}
> -
> -	switch (sort_type) {
> -	case EVENT_SORT_ID:
> -		sort = events_id_cmp;
> -		break;
> -	case EVENT_SORT_NAME:
> -		sort = events_name_cmp;
> -		break;
> -	case EVENT_SORT_SYSTEM:
> -		sort = events_system_cmp;
> -		break;
> -	default:
> -		return events;
> -	}
> -
> -	qsort(events, pevent->nr_events, sizeof(*events), sort);
> -	pevent->last_type = sort_type;
> -
> -	return events;
> -}
> -
>  static struct format_field **
>  get_event_fields(const char *type, const char *name,
>  		 int count, struct format_field *list)
> @@ -4848,34 +4686,6 @@ get_event_fields(const char *type, const char *name,
>  	return fields;
>  }
>  
> -/**
> - * pevent_event_common_fields - return a list of common fields for an event
> - * @event: the event to return the common fields of.
> - *
> - * Returns an allocated array of fields. The last item in the array is NULL.
> - * The array must be freed with free().
> - */
> -struct format_field **pevent_event_common_fields(struct event_format *event)
> -{
> -	return get_event_fields("common", event->name,
> -				event->format.nr_common,
> -				event->format.common_fields);
> -}
> -
> -/**
> - * pevent_event_fields - return a list of event specific fields for an event
> - * @event: the event to return the fields of.
> - *
> - * Returns an allocated array of fields. The last item in the array is NULL.
> - * The array must be freed with free().
> - */
> -struct format_field **pevent_event_fields(struct event_format *event)
> -{
> -	return get_event_fields("event", event->name,
> -				event->format.nr_fields,
> -				event->format.fields);
> -}
> -
>  static void print_fields(struct trace_seq *s, struct print_flag_sym *field)
>  {
>  	trace_seq_printf(s, "{ %s, %s }", field->value, field->str);
> @@ -5467,56 +5277,6 @@ int pevent_get_field_val(struct trace_seq *s, struct event_format *event,
>  }
>  
>  /**
> - * pevent_get_common_field_val - find a common field and return its value
> - * @s: The seq to print to on error
> - * @event: the event that the field is for
> - * @name: The name of the field
> - * @record: The record with the field name.
> - * @val: place to store the value of the field.
> - * @err: print default error if failed.
> - *
> - * Returns 0 on success -1 on field not found.
> - */
> -int pevent_get_common_field_val(struct trace_seq *s, struct event_format *event,
> -				const char *name, struct pevent_record *record,
> -				unsigned long long *val, int err)
> -{
> -	struct format_field *field;
> -
> -	if (!event)
> -		return -1;
> -
> -	field = pevent_find_common_field(event, name);
> -
> -	return get_field_val(s, field, name, record, val, err);
> -}
> -
> -/**
> - * pevent_get_any_field_val - find a any field and return its value
> - * @s: The seq to print to on error
> - * @event: the event that the field is for
> - * @name: The name of the field
> - * @record: The record with the field name.
> - * @val: place to store the value of the field.
> - * @err: print default error if failed.
> - *
> - * Returns 0 on success -1 on field not found.
> - */
> -int pevent_get_any_field_val(struct trace_seq *s, struct event_format *event,
> -			     const char *name, struct pevent_record *record,
> -			     unsigned long long *val, int err)
> -{
> -	struct format_field *field;
> -
> -	if (!event)
> -		return -1;
> -
> -	field = pevent_find_any_field(event, name);
> -
> -	return get_field_val(s, field, name, record, val, err);
> -}
> -
> -/**
>   * pevent_print_num_field - print a field and a format
>   * @s: The seq to print to
>   * @fmt: The printf format to print the field with.
> diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
> index 7a3873f..8e50f9d 100644
> --- a/tools/lib/traceevent/event-parse.h
> +++ b/tools/lib/traceevent/event-parse.h
> @@ -597,15 +597,10 @@ enum trace_flag_type {
>  };
>  
>  int pevent_register_comm(struct pevent *pevent, const char *comm, int pid);
> -void pevent_register_trace_clock(struct pevent *pevent, char *trace_clock);
>  int pevent_register_function(struct pevent *pevent, char *name,
>  			     unsigned long long addr, char *mod);
>  int pevent_register_print_string(struct pevent *pevent, const char *fmt,
>  				 unsigned long long addr);
> -int pevent_pid_is_registered(struct pevent *pevent, int pid);
> -
> -void pevent_print_event(struct pevent *pevent, struct trace_seq *s,
> -			struct pevent_record *record, bool use_trace_clock);
>  
>  int pevent_parse_header_page(struct pevent *pevent, char *buf, unsigned long size,
>  			     int long_size);
> @@ -625,12 +620,6 @@ void *pevent_get_field_raw(struct trace_seq *s, struct event_format *event,
>  int pevent_get_field_val(struct trace_seq *s, struct event_format *event,
>  			 const char *name, struct pevent_record *record,
>  			 unsigned long long *val, int err);
> -int pevent_get_common_field_val(struct trace_seq *s, struct event_format *event,
> -				const char *name, struct pevent_record *record,
> -				unsigned long long *val, int err);
> -int pevent_get_any_field_val(struct trace_seq *s, struct event_format *event,
> -			     const char *name, struct pevent_record *record,
> -			     unsigned long long *val, int err);
>  
>  int pevent_print_num_field(struct trace_seq *s, const char *fmt,
>  			   struct event_format *event, const char *name,
> @@ -672,7 +661,6 @@ pevent_find_event_by_name(struct pevent *pevent, const char *sys, const char *na
>  void pevent_data_lat_fmt(struct pevent *pevent,
>  			 struct trace_seq *s, struct pevent_record *record);
>  int pevent_data_type(struct pevent *pevent, struct pevent_record *rec);
> -struct event_format *pevent_data_event_from_type(struct pevent *pevent, int type);
>  int pevent_data_pid(struct pevent *pevent, struct pevent_record *rec);
>  const char *pevent_data_comm_from_pid(struct pevent *pevent, int pid);
>  void pevent_event_info(struct trace_seq *s, struct event_format *event,
> @@ -680,10 +668,6 @@ void pevent_event_info(struct trace_seq *s, struct event_format *event,
>  int pevent_strerror(struct pevent *pevent, enum pevent_errno errnum,
>  		    char *buf, size_t buflen);
>  
> -struct event_format **pevent_list_events(struct pevent *pevent, enum event_sort_type);
> -struct format_field **pevent_event_common_fields(struct event_format *event);
> -struct format_field **pevent_event_fields(struct event_format *event);
> -
>  static inline int pevent_get_cpus(struct pevent *pevent)
>  {
>  	return pevent->cpus;
> -- 
> 1.7.10.4
