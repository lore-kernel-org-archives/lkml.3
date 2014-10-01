Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbaJASD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 14:03:26 -0400
Received: from mail.kernel.org ([198.145.19.201]:42530 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbaJASDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 14:03:25 -0400
Date: Wed, 1 Oct 2014 15:03:16 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: jolsa@redhat.com, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Adding a filter to events (instead of replacing one) was Re: [PATCH
 1/2] perf, tools: Add PERF_PID
Message-ID: <20141001180316.GI2799@kernel.org>
References: <1411591869-325-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="NDin8bjvE/0mNLFQ"
Content-Disposition: inline
In-Reply-To: <1411591869-325-1-git-send-email-andi@firstfloor.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NDin8bjvE/0mNLFQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Em Wed, Sep 24, 2014 at 01:51:08PM -0700, Andi Kleen escreveu:

> It's currently difficult to filter out perf itself using a filter.
> This can give cascading effects during IO tracing when the IO perf
> does itself causes more trace output.
 
> The best way to filter is to use the pid. But it's difficult to get the pid
> of perf without using hacks.
 
> Add a PERF_PID meta variable to the perf filter that contains the current pid.
 
> With this patch the following works
 
> % perf record -e syscalls:sys_enter_write -a --filter 'common_pid != PERF_PID' ...

So I tried this one now and saw the other patch, that applies the
--filter to all events, while trying I got:

[root@zoo ~]# perf record --filter "common_pid != PERF_PID" -a
-F option should follow a -e tracepoint option

 usage: perf record [<options>] [<command>]
    or: perf record [<options>] -- <command> [<options>]

        --filter <filter>
                          event filter
[root@zoo ~]#

A bug there, as '-F' is for frequency, will fix, but the message tells
that --filter affects just the last event, i.e. whoever implemented this
wanted to apply filters to specific events, and those need to be
tracepoints (as we can't apply filters to other PERF_TYPE_ events (we
should!).

So, more surgery would be needed to keep the existing behaviour, i.e. to
allow per event filters, which is what the current does (or should,
judging by the error message above), and to provide a new one that would
apply the given filter to all suitable events, i.e. all tracepoint
events (nowadays, others in the future).

I give a shot at implementing it in 'perf trace', by introducing a
perf_evlist__filter_pid() that would then be used by default, but
stopped working as to really make it good by default I would have to
filter out activity on the gnome-terminal where 'perf trace' was
running, to avoid another feedback loop.

But now I think that perf_evlist__filter_pid() thing is what we want
here and then we should add a --filter-self option to 'perf record',
that would just do:

	perf_evlist__filter_pid(evlist, getpid());

Agreed?

The patch is attached, but it is still incomplete, as I haven't checked
if we set a filter we end up reseting whatever filter is in place, or if
we have to use some syntax (prefixing the filter with '+'?) to add a
filter instead of replacing what is there.

- Arnaldo
 
> This won't work for more complex perf pipe lines with multiple processes,
> but at least solves the problem nicely for a single perf.
> 
> v2: Remove debug code. Don't use zero padding (Namhyung)
> v3: Correct patch.
> v4: Handle arbitary pid length.
> v5: Fix a warning
> Acked-by: Namhyung Kim <namhyung@kernel.org>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  tools/perf/Documentation/perf-record.txt |  2 +-
>  tools/perf/util/parse-events.c           | 21 ++++++++++++++++++++-
>  2 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
> index d460049..b6c5e51 100644
> --- a/tools/perf/Documentation/perf-record.txt
> +++ b/tools/perf/Documentation/perf-record.txt
> @@ -41,7 +41,7 @@ OPTIONS
>            'mem:0x1000:rw'.
>  
>  --filter=<filter>::
> -        Event filter.
> +        Event filter. PERF_PID represents the perf pid.
>  
>  -a::
>  --all-cpus::
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index 1e15df1..9c4bab8 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -967,6 +967,9 @@ int parse_filter(const struct option *opt, const char *str,
>  {
>  	struct perf_evlist *evlist = *(struct perf_evlist **)opt->value;
>  	struct perf_evsel *last = NULL;
> +	char *pid, buf[30], *o;
> +	int len, plen;
> +	const char *p;
>  
>  	if (evlist->nr_entries > 0)
>  		last = perf_evlist__last(evlist);
> @@ -977,12 +980,28 @@ int parse_filter(const struct option *opt, const char *str,
>  		return -1;
>  	}
>  
> -	last->filter = strdup(str);
> +	plen = sprintf(buf, "%d", getpid());
> +	len = strlen(str) + 1;
> +	for (pid = strstr(str, "PERF_PID"); pid;
> +	     pid = strstr(pid + 1, "PERF_PID")) {
> +		len += plen - 8;
> +	}
> +
> +	last->filter = malloc(len);
>  	if (last->filter == NULL) {
>  		fprintf(stderr, "not enough memory to hold filter string\n");
>  		return -1;
>  	}
>  
> +	o = last->filter;
> +	for (p = str; *p; ) {
> +		if (*p == 'P' && !strncmp(p, "PERF_PID", 8)) {
> +			strcpy(o, buf);
> +			o += plen;
> +			p += sizeof("PERF_PID") - 1;
> +		} else
> +			*o++ = *p++;
> +	}
>  	return 0;
>  }
>  
> -- 
> 1.9.3

--NDin8bjvE/0mNLFQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="trace_set_filter.patch"

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 09bcf2393910..d64e8c619ff6 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -2105,6 +2105,10 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 	if (err < 0)
 		goto out_error_open;
 
+	err = perf_evlist__set_filter_pid(evlist, getpid());
+	if (err < 0)
+		goto out_error_filter;
+
 	err = perf_evlist__mmap(evlist, trace->opts.mmap_pages, false);
 	if (err < 0) {
 		fprintf(trace->output, "Couldn't mmap the events: %s\n",
@@ -2216,6 +2220,11 @@ out_error_open:
 out_error:
 	fprintf(trace->output, "%s\n", errbuf);
 	goto out_delete_evlist;
+
+out_error_filter:
+	fprintf(trace->output, "Couldn't set 'perf trace' pid filter: %s\n",
+                        strerror_r(errno, errbuf, sizeof(errbuf)));
+	goto out_delete_evlist;
 }
 }
 
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 3cebc9a8d52e..06e54304f63f 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1041,6 +1041,27 @@ int perf_evlist__set_filter(struct perf_evlist *evlist, const char *filter)
 	return err;
 }
 
+int perf_evlist__set_filter_pid(struct perf_evlist *evlist, pid_t pid)
+{
+	struct perf_evsel *evsel;
+	int err = 0;
+	const int ncpus = cpu_map__nr(evlist->cpus),
+		  nthreads = thread_map__nr(evlist->threads);
+	char filter[64];
+
+	scnprintf(filter, sizeof(filter), "common_pid != %d", pid);
+
+	evlist__for_each(evlist, evsel) {
+		if (evsel->attr.type != PERF_TYPE_TRACEPOINT)
+			continue;
+		err = perf_evsel__set_filter(evsel, ncpus, nthreads, filter);
+		if (err)
+			break;
+	}
+
+	return err;
+}
+
 bool perf_evlist__valid_sample_type(struct perf_evlist *evlist)
 {
 	struct perf_evsel *pos;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index bd312b01e876..9c4b9410d511 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -77,6 +77,7 @@ int perf_evlist__add_newtp(struct perf_evlist *evlist,
 			   const char *sys, const char *name, void *handler);
 
 int perf_evlist__set_filter(struct perf_evlist *evlist, const char *filter);
+int perf_evlist__set_filter_pid(struct perf_evlist *evlist, pid_t pid);
 
 struct perf_evsel *
 perf_evlist__find_tracepoint_by_id(struct perf_evlist *evlist, int id);

--NDin8bjvE/0mNLFQ--
