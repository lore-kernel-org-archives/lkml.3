Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbaENFKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 01:10:43 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:48666 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbaENFKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 01:10:40 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        eranian@google.com, jolsa@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 3/9] perf, tools: Add support for reading JSON event files
References: <1399935074-25167-1-git-send-email-andi@firstfloor.org>
	<1399935074-25167-4-git-send-email-andi@firstfloor.org>
Date: Wed, 14 May 2014 14:10:34 +0900
In-Reply-To: <1399935074-25167-4-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Mon, 12 May 2014 15:51:08 -0700")
Message-ID: <874n0tlzcl.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2014 15:51:08 -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> Add a parser for Intel style JSON event files. This allows
> to use an Intel event list directly with perf. The Intel
> event lists can be quite large and are too big to store
> in unswappable kernel memory.
>
> The parser code knows how to convert the JSON fields
> to perf fields. The conversion code is straight forward.
> It knows (very little) Intel specific information, and can be easily
> extended to handle fields for other CPUs.
>
> The parser code is partially shared with an independent parsing
> library, which is 2-clause BSD licenced. To avoid any conflicts I marked
> those files as BSD licenced too. As part of perf they become GPLv2.
>
> The events are handled using the existing alias machinery.
>
> We output the BriefDescription in perf list.
>
> Right now the json file can be specified as an argument
> to perf stat/record/list. Followon patches will automate this.

I think it'd be good to show an example json event file content in
the changelog and/or comment.

>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  tools/perf/Documentation/perf-list.txt   |   6 +
>  tools/perf/Documentation/perf-record.txt |   3 +
>  tools/perf/Documentation/perf-stat.txt   |   3 +
>  tools/perf/Makefile.perf                 |   2 +
>  tools/perf/builtin-list.c                |   2 +
>  tools/perf/builtin-record.c              |   3 +
>  tools/perf/builtin-stat.c                |   2 +
>  tools/perf/util/jevents.c                | 248 +++++++++++++++++++++++++++++++
>  tools/perf/util/jevents.h                |   3 +
>  tools/perf/util/pmu.c                    |  14 ++
>  tools/perf/util/pmu.h                    |   2 +
>  11 files changed, 288 insertions(+)
>  create mode 100644 tools/perf/util/jevents.c
>  create mode 100644 tools/perf/util/jevents.h
>
> diff --git a/tools/perf/Documentation/perf-list.txt b/tools/perf/Documentation/perf-list.txt
> index 6fce6a6..d399e04 100644
> --- a/tools/perf/Documentation/perf-list.txt
> +++ b/tools/perf/Documentation/perf-list.txt
> @@ -15,6 +15,12 @@ DESCRIPTION
>  This command displays the symbolic event types which can be selected in the
>  various perf commands with the -e option.
>  
> +OPTIONS
> +-------
> +--json-file=::

Hmm.. I think the option name should not be tied to the implementation.
How about --event-file or --event-alias then?


> +Specify JSON event list file to use for parsing events.
> +
> +
>  [[EVENT_MODIFIERS]]
>  EVENT MODIFIERS
>  ---------------
> diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
> index c71b0f3..8a1e0d9 100644
> --- a/tools/perf/Documentation/perf-record.txt
> +++ b/tools/perf/Documentation/perf-record.txt
> @@ -213,6 +213,9 @@ if combined with -a or -C options.
>  After starting the program, wait msecs before measuring. This is useful to
>  filter out the startup phase of the program, which is often very different.
>  
> +--json-file=::
> +Specify JSON event list file to use for parsing events.
> +
>  SEE ALSO
>  --------
>  linkperf:perf-stat[1], linkperf:perf-list[1]
> diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
> index 29ee857..a946283 100644
> --- a/tools/perf/Documentation/perf-stat.txt
> +++ b/tools/perf/Documentation/perf-stat.txt
> @@ -142,6 +142,9 @@ filter out the startup phase of the program, which is often very different.
>  
>  Print statistics of transactional execution if supported.
>  
> +--json-file=::
> +Specify JSON event list file to use for parsing events.
> +
>  EXAMPLES
>  --------
>  
> diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
> index 43d4109..8800838 100644
> --- a/tools/perf/Makefile.perf
> +++ b/tools/perf/Makefile.perf
> @@ -302,6 +302,7 @@ LIB_H += ui/ui.h
>  LIB_H += util/data.h
>  LIB_H += util/jsmn.h
>  LIB_H += util/json.h
> +LIB_H += util/jevents.h
>  
>  LIB_OBJS += $(OUTPUT)util/abspath.o
>  LIB_OBJS += $(OUTPUT)util/alias.o
> @@ -377,6 +378,7 @@ LIB_OBJS += $(OUTPUT)util/srcline.o
>  LIB_OBJS += $(OUTPUT)util/data.o
>  LIB_OBJS += $(OUTPUT)util/jsmn.o
>  LIB_OBJS += $(OUTPUT)util/json.o
> +LIB_OBJS += $(OUTPUT)util/jevents.o
>  
>  LIB_OBJS += $(OUTPUT)ui/setup.o
>  LIB_OBJS += $(OUTPUT)ui/helpline.o
> diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
> index 011195e..ca3dd18 100644
> --- a/tools/perf/builtin-list.c
> +++ b/tools/perf/builtin-list.c
> @@ -20,6 +20,8 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
>  {
>  	int i;
>  	const struct option list_options[] = {
> +		OPT_STRING(0, "json-file", &json_file, "json file",
> +			   "Read event json file"),
>  		OPT_END()
>  	};
>  	const char * const list_usage[] = {
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index e4c85b8..e4a5be0 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -25,6 +25,7 @@
>  #include "util/cpumap.h"
>  #include "util/thread_map.h"
>  #include "util/data.h"
> +#include "util/pmu.h"
>  
>  #include <unistd.h>
>  #include <sched.h>
> @@ -871,6 +872,8 @@ const struct option record_options[] = {
>  		    "sample transaction flags (special events only)"),
>  	OPT_BOOLEAN(0, "per-thread", &record.opts.target.per_thread,
>  		    "use per-thread mmaps"),
> +	OPT_STRING(0, "json-file", &json_file, "json file",
> +		   "Read event json file"),
>  	OPT_END()
>  };
>  
> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index 65a151e..461ff0a 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -1668,6 +1668,8 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
>  		     "aggregate counts per physical processor core", AGGR_CORE),
>  	OPT_UINTEGER('D', "delay", &initial_delay,
>  		     "ms to wait before starting measurement after program start"),
> +	OPT_STRING(0, "json-file", &json_file, "json file",
> +		   "Read event json file"),
>  	OPT_END()
>  	};
>  	const char * const stat_usage[] = {
> diff --git a/tools/perf/util/jevents.c b/tools/perf/util/jevents.c
> new file mode 100644
> index 0000000..0173b68
> --- /dev/null
> +++ b/tools/perf/util/jevents.c
> @@ -0,0 +1,248 @@
> +/* Parse event JSON files */
> +
> +/*
> + * Copyright (c) 2014, Intel Corporation
> + * All rights reserved.
> + *
> + * Redistribution and use in source and binary forms, with or without
> + * modification, are permitted provided that the following conditions are met:
> + *
> + * 1. Redistributions of source code must retain the above copyright notice,
> + * this list of conditions and the following disclaimer.
> + *
> + * 2. Redistributions in binary form must reproduce the above copyright
> + * notice, this list of conditions and the following disclaimer in the
> + * documentation and/or other materials provided with the distribution.
> + *
> + * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
> + * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
> + * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
> + * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
> + * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
> + * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
> + * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
> + * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
> + * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
> + * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
> + * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
> + * OF THE POSSIBILITY OF SUCH DAMAGE.
> +*/
> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <errno.h>
> +#include <string.h>
> +#include <ctype.h>
> +#include "jsmn.h"
> +#include "json.h"
> +#include "jevents.h"
> +
> +static void addfield(char *map, char **dst, const char *sep,
> +		     const char *a, jsmntok_t *bt)
> +{
> +	unsigned len = strlen(a) + 1 + strlen(sep);
> +	int olen = *dst ? strlen(*dst) : 0;
> +	int blen = bt ? json_len(bt) : 0;
> +
> +	*dst = realloc(*dst, len + olen + blen);
> +	if (!*dst)
> +		exit(ENOMEM);

Hmm.. wouldn't it be better to return an error code?  In general, the
perf tools try to terminate it gracefully in case of error.


> +	if (!olen)
> +		*(*dst) = 0;
> +	else
> +		strcat(*dst, sep);
> +	strcat(*dst, a);
> +	if (bt)
> +		strncat(*dst, map + bt->start, blen);
> +}
> +
> +static void fixname(char *s)
> +{
> +	for (; *s; s++) {
> +		*s = tolower(*s);
> +		/*
> +		 * Remove '.' for now, until the parser
> +		 * can deal with it.
> +		 */
> +		if (*s == '.')
> +			*s = '_';
> +	}
> +}
> +
> +static void fixdesc(char *s)
> +{
> +	char *e = s + strlen(s);
> +
> +	/* Remove trailing dots that look ugly in perf list */
> +	--e;
> +	while (e >= s && isspace(*e))
> +		--e;
> +	if (*e == '.')
> +		*e = 0;
> +}
> +
> +#define EXPECT(e, t, m) do { if (!(e)) {			\
> +	jsmntok_t *loc = (t);					\
> +	if (!(t)->start && (t) > tokens)			\
> +		loc = (t) - 1;					\
> +	fprintf(stderr, "%s:%d: " m ", got %s\n", fn,		\
> +		json_line(map, loc),				\
> +		json_name(t));					\
> +	goto out_free;						\
> +} } while (0)

It looks like the EXPECT macro can only be used in json_events()
function.  If so, please move it next to the function.

Also please use pr_err() to print an error message.

> +
> +static struct msrmap {
> +	const char *num;
> +	const char *pname;
> +} msrmap[] = {
> +	{ "0x3F6", "ldlat=" },
> +	{ "0x1A6", "offcore_rsp=" },
> +	{ "0x1A7", "offcore_rsp=" },
> +	{ NULL, NULL }
> +};
> +
> +static struct field {
> +	const char *field;
> +	const char *kernel;
> +} fields[] = {
> +	{ "EventCode",	"event=" },
> +	{ "UMask",	"umask=" },
> +	{ "CounterMask", "cmask=" },
> +	{ "Invert",	"inv=" },
> +	{ "AnyThread",	"any=" },
> +	{ "EdgeDetect",	"edge=" },
> +	{ "SampleAfterValue", "period=" },
> +	{ NULL, NULL }
> +};
> +
> +static void cut_comma(char *map, jsmntok_t *newval)
> +{
> +	int i;
> +
> +	/* Cut off everything after comma */
> +	for (i = newval->start; i < newval->end; i++) {
> +		if (map[i] == ',')
> +			newval->end = i;
> +	}
> +}
> +
> +static int match_field(char *map, jsmntok_t *field, int nz,
> +		       char **event, jsmntok_t *val)
> +{
> +	struct field *f;
> +	jsmntok_t newval = *val;
> +
> +	for (f = fields; f->field; f++)
> +		if (json_streq(map, field, f->field) && nz) {
> +			cut_comma(map, &newval);
> +			addfield(map, event, ",", f->kernel, &newval);
> +			return 1;
> +		}
> +	return 0;
> +}
> +
> +static struct msrmap *lookup_msr(char *map, jsmntok_t *val)
> +{
> +	jsmntok_t newval = *val;
> +	static bool warned;
> +	int i;
> +
> +	cut_comma(map, &newval);
> +	for (i = 0; msrmap[i].num; i++)
> +		if (json_streq(map, &newval, msrmap[i].num))
> +			return &msrmap[i];
> +	if (!warned) {
> +		warned = true;
> +		pr_err("Unknown MSR in event file %.*s\n",
> +			json_len(val), map + val->start);
> +	}
> +	return NULL;
> +}
> +
> +/* Call func with each event in the json file */
> +
> +int json_events(const char *fn,
> +	  int (*func)(void *data, char *name, char *event, char *desc),
> +	  void *data)
> +{
> +	int err = -EIO;
> +	size_t size;
> +	jsmntok_t *tokens, *tok;
> +	int i, j, len;
> +	char *map;
> +
> +	tokens = parse_json(fn, &map, &size, &len);
> +	if (!tokens)
> +		return -EIO;
> +	EXPECT(tokens->type == JSMN_ARRAY, tokens, "expected top level array");
> +	tok = tokens + 1;
> +	for (i = 0; i < tokens->size; i++) {
> +		char *event = NULL, *desc = NULL, *name = NULL;
> +		struct msrmap *msr = NULL;
> +		jsmntok_t *msrval = NULL;
> +		jsmntok_t *precise = NULL;
> +		jsmntok_t *obj = tok++;
> +
> +		EXPECT(obj->type == JSMN_OBJECT, obj, "expected object");
> +		for (j = 0; j < obj->size; j += 2) {
> +			jsmntok_t *field, *val;
> +			int nz;
> +
> +			field = tok + j;
> +			EXPECT(field->type == JSMN_STRING, tok + j,
> +			       "Expected field name");
> +			val = tok + j + 1;
> +			EXPECT(val->type == JSMN_STRING, tok + j + 1,
> +			       "Expected string value");
> +
> +			nz = !json_streq(map, val, "0");
> +			if (match_field(map, field, nz, &event, val)) {
> +				/* ok */
> +			} else if (json_streq(map, field, "EventName")) {
> +				addfield(map, &name, "", "", val);
> +			} else if (json_streq(map, field, "BriefDescription")) {
> +				addfield(map, &desc, "", "", val);
> +				fixdesc(desc);
> +			} else if (json_streq(map, field, "PEBS") && nz &&
> +				   !strstr(desc, "(Precise Event)")) {

I can't understand this.  Why did you check 'desc' to have such string?
It seems that it's only set after the loop.  And what if this PEBS line
comes first (having desc set NULL)?

And more generally, can we extend these if-else's to a generic loop to
check a table like in match_field() so that it can be added easily?


> +				precise = val;
> +			} else if (json_streq(map, field, "MSRIndex") && nz) {
> +				msr = lookup_msr(map, val);
> +			} else if (json_streq(map, field, "MSRValue")) {
> +				msrval = val;
> +			} else if (json_streq(map, field, "Errata") &&
> +				   !json_streq(map, val, "null")) {
> +				addfield(map, &desc, ". ",
> +					" Spec update: ", val);
> +			} else if (json_streq(map, field, "Data_LA") && nz) {
> +				addfield(map, &desc, ". ",
> +					" Supports address when precise",
> +					NULL);
> +			}
> +			/* ignore unknown fields */
> +		}
> +		if (precise) {
> +			if (json_streq(map, precise, "2"))
> +				addfield(map, &desc, " ", "(Must be precise)",
> +						NULL);
> +			else
> +				addfield(map, &desc, " ",
> +						"(Precise event)", NULL);
> +		}
> +		if (msr != NULL)
> +			addfield(map, &event, ",", msr->pname, msrval);
> +		fixname(name);
> +		err = func(data, name, event, desc);
> +		free(event);
> +		free(desc);
> +		free(name);
> +		if (err)
> +			break;
> +		tok += j;
> +	}
> +	EXPECT(tok - tokens == len, tok, "unexpected objects at end");
> +	err = 0;
> +out_free:
> +	free_json(map, size, tokens);
> +	return err;
> +}
> diff --git a/tools/perf/util/jevents.h b/tools/perf/util/jevents.h
> new file mode 100644
> index 0000000..4c2b879
> --- /dev/null
> +++ b/tools/perf/util/jevents.h
> @@ -0,0 +1,3 @@
> +int json_events(const char *fn,
> +		int (*func)(void *data, char *name, char *event, char *desc),
> +		void *data);
> diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
> index baec090..9f154af 100644
> --- a/tools/perf/util/pmu.c
> +++ b/tools/perf/util/pmu.c
> @@ -9,6 +9,9 @@
>  #include "pmu.h"
>  #include "parse-events.h"
>  #include "cpumap.h"
> +#include "jevents.h"
> +
> +const char *json_file;
>  
>  #define UNIT_MAX_LEN	31 /* max length for event unit name */
>  
> @@ -273,6 +276,14 @@ static int pmu_aliases_parse(char *dir, struct list_head *head)
>  	return ret;
>  }
>  
> +static int add_alias(void *data, char *name, char *event, char *desc)
> +{
> +	struct list_head *head = (struct list_head *)data;
> +
> +	__perf_pmu__new_alias(head, name, NULL, desc, event);
> +	return 0;
> +}
> +
>  /*
>   * Reading the pmu event aliases definition, which should be located at:
>   * /sys/bus/event_source/devices/<dev>/events as sysfs group attributes.
> @@ -422,6 +433,9 @@ static struct perf_pmu *pmu_lookup(const char *name)
>  	if (pmu_aliases(name, &aliases))
>  		return NULL;
>  
> +	if (!strcmp(name, "cpu") && json_file)
> +		json_events(json_file, add_alias, &aliases);
> +
>  	if (pmu_type(name, &type))
>  		return NULL;
>  
> diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
> index c14a543..583d21e 100644
> --- a/tools/perf/util/pmu.h
> +++ b/tools/perf/util/pmu.h
> @@ -46,4 +46,6 @@ void print_pmu_events(const char *event_glob, bool name_only);
>  bool pmu_have_event(const char *pname, const char *name);
>  
>  int perf_pmu__test(void);
> +
> +extern const char *json_file;
>  #endif /* __PMU_H */
