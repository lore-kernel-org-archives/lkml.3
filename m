Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab3F0QjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 12:39:17 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:52350 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab3F0QjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 12:39:15 -0400
Message-ID: <51CC6AAF.4030404@gmail.com>
Date: Thu, 27 Jun 2013 10:39:11 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@intel.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V2 12/15] perf tools: allow non-matching sample types
References: <1372319707-13892-1-git-send-email-adrian.hunter@intel.com> <1372319707-13892-13-git-send-email-adrian.hunter@intel.com>
In-Reply-To: <1372319707-13892-13-git-send-email-adrian.hunter@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/27/13 1:55 AM, Adrian Hunter wrote:
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
>   tools/perf/builtin-report.c |   2 +-
>   tools/perf/util/event.h     |  14 +++++
>   tools/perf/util/evlist.c    | 135 ++++++++++++++++++++++++++++++++++++++++++--
>   tools/perf/util/evlist.h    |   8 ++-
>   tools/perf/util/evsel.c     |  64 ++++++++++++++++++++-
>   tools/perf/util/evsel.h     |  10 ++++
>   tools/perf/util/session.c   |   8 ++-
>   7 files changed, 230 insertions(+), 11 deletions(-)
>
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index ca98d34..58572ac 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -367,7 +367,7 @@ static int process_read_event(struct perf_tool *tool,
>   static int perf_report__setup_sample_type(struct perf_report *rep)
>   {
>   	struct perf_session *self = rep->session;
> -	u64 sample_type = perf_evlist__sample_type(self->evlist);
> +	u64 sample_type = perf_evlist__combined_sample_type(self->evlist);
>
>   	if (!self->fd_pipe && !(sample_type & PERF_SAMPLE_CALLCHAIN)) {
>   		if (sort__has_parent) {
> diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
> index 1813895..3aef78c 100644
> --- a/tools/perf/util/event.h
> +++ b/tools/perf/util/event.h
> @@ -65,6 +65,20 @@ struct read_event {
>   	PERF_SAMPLE_ID | PERF_SAMPLE_STREAM_ID |	\
>   	 PERF_SAMPLE_CPU | PERF_SAMPLE_PERIOD)
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
>   struct sample_event {
>   	struct perf_event_header        header;
>   	u64 array[];
> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> index a660f56..78331da 100644
> --- a/tools/perf/util/evlist.c
> +++ b/tools/perf/util/evlist.c
> @@ -49,6 +49,45 @@ struct perf_evlist *perf_evlist__new(void)
>   	return evlist;
>   }
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
> +		evsel->sample_size = __perf_evsel__sample_size(evsel->attr.sample_type);
> +		perf_evsel__calc_id_pos(evsel);
> +	}
> +
> +	perf_evlist__set_id_pos(evlist);
> +}
> +

While this works for a combined S/W and tracepoint events session, I do 
not like promoting sample types to the minimum compatible level for all 
events in the session. perf needs to allow each event to have its own 
sample_type and not force a minimal compatibility.

David
