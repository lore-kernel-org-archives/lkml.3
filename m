Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068Ab3HMCyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 22:54:21 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:47361 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756447Ab3HMCyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 22:54:20 -0400
X-AuditID: 9c930179-b7c0bae0000040ac-13-52099fdafe77
From: Namhyung Kim <namhyung@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V10 01/13] perf tools: add debug prints
References: <1376045519-13832-1-git-send-email-adrian.hunter@intel.com>
	<1376045519-13832-2-git-send-email-adrian.hunter@intel.com>
Date: Tue, 13 Aug 2013 11:54:18 +0900
In-Reply-To: <1376045519-13832-2-git-send-email-adrian.hunter@intel.com>
	(Adrian Hunter's message of "Fri, 9 Aug 2013 13:51:47 +0300")
Message-ID: <87eh9ywbad.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  9 Aug 2013 13:51:47 +0300, Adrian Hunter wrote:
> It is useful to see the arguments to perf_event_open
> and whether the perf events ring buffer was mmapped
> per-cpu or per-thread.  That information will now be
> displayed when verbose is 2 i.e option -vv

I have two nitpicks below, but other than that it looks good, so

Acked-by: Namhyung Kim <namhyung@kernel.org>


[SNIP]

> +#define __PRINT_ATTR(fmt, cast, field)  \
> +	fprintf(fp, "  %-19s "fmt"\n", #field, cast attr->field)
> +
> +#define PRINT_ATTR_U32(field)  __PRINT_ATTR("%u" , , field)
> +#define PRINT_ATTR_X32(field)  __PRINT_ATTR("%#x", , field)
> +#define PRINT_ATTR_U64(field)  __PRINT_ATTR("%" PRIu64, (uint64_t), field)
> +#define PRINT_ATTR_X64(field)  __PRINT_ATTR("%#"PRIx64, (uint64_t), field)
> +
> +#define PRINT_ATTR2N(name1, field1, name2, field2)	\
> +	fprintf(fp, "  %-19s %u    %-19s %u\n",		\
> +	name1, attr->field1, name2, attr->field2)
> +
> +#define PRINT_ATTR2(field1, field2) \
> +	PRINT_ATTR2N(#field1, field1, #field2, field2)
> +
> +static size_t perf_event_attr__fprintf(struct perf_event_attr *attr, FILE *fp)
> +{
> +	size_t ret = 0;
> +
> +	ret += fprintf(fp, "------------------------------");
> +	ret += fprintf(fp, "------------------------------\n");

We have 'graph_dotted_line' for this.


> +	ret += fprintf(fp, "perf_event_attr:\n");
> +
> +	ret += PRINT_ATTR_U32(type);
> +	ret += PRINT_ATTR_U32(size);
> +	ret += PRINT_ATTR_X64(config);
> +	ret += PRINT_ATTR_U64(sample_period);
> +	ret += PRINT_ATTR_U64(sample_freq);
> +	ret += PRINT_ATTR_X64(sample_type);
> +	ret += PRINT_ATTR_X64(read_format);
> +
> +	ret += PRINT_ATTR2(disabled, inherit);
> +	ret += PRINT_ATTR2(pinned, exclusive);
> +	ret += PRINT_ATTR2(exclude_user, exclude_kernel);
> +	ret += PRINT_ATTR2(exclude_hv, exclude_idle);
> +	ret += PRINT_ATTR2(mmap, comm);
> +	ret += PRINT_ATTR2(freq, inherit_stat);
> +	ret += PRINT_ATTR2(enable_on_exec, task);
> +	ret += PRINT_ATTR2(watermark, precise_ip);
> +	ret += PRINT_ATTR2(mmap_data, sample_id_all);
> +	ret += PRINT_ATTR2(exclude_host, exclude_guest);
> +	ret += PRINT_ATTR2N("excl.callchain_kern", exclude_callchain_kernel,
> +			    "excl.callchain_user", exclude_callchain_user);
> +
> +	ret += PRINT_ATTR_U32(wakeup_events);
> +	ret += PRINT_ATTR_U32(wakeup_watermark);
> +	ret += PRINT_ATTR_X32(bp_type);
> +	ret += PRINT_ATTR_X64(bp_addr);
> +	ret += PRINT_ATTR_X64(config1);
> +	ret += PRINT_ATTR_U64(bp_len);
> +	ret += PRINT_ATTR_X64(config2);
> +	ret += PRINT_ATTR_X64(branch_sample_type);
> +	ret += PRINT_ATTR_X64(sample_regs_user);
> +	ret += PRINT_ATTR_U32(sample_stack_user);
> +
> +	ret += fprintf(fp, "------------------------------");
> +	ret += fprintf(fp, "------------------------------\n");
> +
> +	return ret;
> +}

[SNIP]

> diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
> index 925e0c3..381f4fd 100644
> --- a/tools/perf/util/python.c
> +++ b/tools/perf/util/python.c
> @@ -8,6 +8,26 @@
>  #include "cpumap.h"
>  #include "thread_map.h"
>  
> +/*
> + * Support debug printing even though util/debug.c is not linked.  That means
> + * implementing 'verbose' and 'eprintf'.
> + */
> +int verbose;
> +
> +int eprintf(int level, const char *fmt, ...)
> +{
> +	va_list args;
> +	int ret = 0;
> +
> +	if (verbose >= level) {
> +		va_start(args, fmt);
> +		ret = vfprintf(stderr, fmt, args);
> +		va_end(args);
> +	}
> +
> +	return ret;
> +}

Not sure this duplication is the right way.  Maybe linking util/debug.c
into the python extension and move trace_event() somewhere is a better
approach.  But it'd make the util/debug.c more fragile?

Anyway this change could be splitted as a preparation patch.

Thanks,
Namhyung
