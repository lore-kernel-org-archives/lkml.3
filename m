Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457Ab3GEQ7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 12:59:44 -0400
Received: from mail-yh0-f49.google.com ([209.85.213.49]:58105 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361Ab3GEQ7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 12:59:42 -0400
Date: Fri, 5 Jul 2013 13:59:33 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V4 09/21] perf tools: add debug prints
Message-ID: <20130705165933.GF2559@ghostprotocols.net>
References: <1372944040-32690-1-git-send-email-adrian.hunter@intel.com>
 <1372944040-32690-10-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372944040-32690-10-git-send-email-adrian.hunter@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jul 04, 2013 at 04:20:28PM +0300, Adrian Hunter escreveu:
> It is useful to see the arguments to perf_event_open
> and whether the perf events ring buffer was mmapped
> per-cpu or per-thread.  That information will now be
> displayed when verbose is 2 i.e option -vv
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Acked-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  tools/perf/util/evlist.c |  3 +++
>  tools/perf/util/evsel.c  | 52 ++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 55 insertions(+)
> 
> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> index 160036e..dfc267b 100644
> --- a/tools/perf/util/evlist.c
> +++ b/tools/perf/util/evlist.c
> @@ -14,6 +14,7 @@
>  #include "target.h"
>  #include "evlist.h"
>  #include "evsel.h"
> +#include "debug.h"
>  #include <unistd.h>
>  
>  #include "parse-events.h"
> @@ -454,6 +455,7 @@ static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist, int prot, int m
>  	int nr_cpus = cpu_map__nr(evlist->cpus);
>  	int nr_threads = thread_map__nr(evlist->threads);
>  
> +	pr_debug2("perf event ring buffer mmapped per cpu\n");
>  	for (cpu = 0; cpu < nr_cpus; cpu++) {
>  		int output = -1;
>  
> @@ -492,6 +494,7 @@ static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist, int prot, in
>  	int thread;
>  	int nr_threads = thread_map__nr(evlist->threads);
>  
> +	pr_debug2("perf event ring buffer mmapped per thread\n");
>  	for (thread = 0; thread < nr_threads; thread++) {
>  		int output = -1;
>  
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index dea0684..8978213 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -21,6 +21,7 @@
>  #include "thread_map.h"
>  #include "target.h"
>  #include "perf_regs.h"
> +#include "debug.h"
>  
>  static struct {
>  	bool sample_id_all;
> @@ -817,6 +818,54 @@ static int get_group_fd(struct perf_evsel *evsel, int cpu, int thread)
>  	return fd;
>  }
>  
> +static void show_attr(struct perf_event_attr *attr)
> +{

These things have been done usually as:

	size_t perf_event_attr__fprintf(struct perf_event_attr *attr, FILE *fp)

Take a look at dso__fprintf() for instance, and grep for __fprintf on
tools/perf for other examples.

And then you can do just one test of (verbose >= 2) to call this
function.

> +	pr_debug2("------------------------------------------------------------\n");
> +	pr_debug2("perf_event_attr:\n");
> +	pr_debug2("  type                %u\n", attr->type);
> +	pr_debug2("  size                %u\n", attr->size);
> +	pr_debug2("  config              %#"PRIx64"\n", (uint64_t)attr->config);
> +	pr_debug2("  sample_period       %"PRIu64"\n", (uint64_t)attr->sample_period);
> +	pr_debug2("  sample_freq         %"PRIu64"\n", (uint64_t)attr->sample_freq);
> +	pr_debug2("  sample_type         %#"PRIx64"\n", (uint64_t)attr->sample_type);
> +	pr_debug2("  read_format         %#"PRIx64"\n", (uint64_t)attr->read_format);
> +
> +	pr_debug2("  disabled            %u    ", attr->disabled);
> +	pr_debug2("inherit             %u\n", attr->inherit);
> +	pr_debug2("  pinned              %u    ", attr->pinned);
> +	pr_debug2("exclusive           %u\n", attr->exclusive);
> +	pr_debug2("  exclude_user        %u    ", attr->exclude_user);
> +	pr_debug2("exclude_kernel      %u\n", attr->exclude_kernel);
> +	pr_debug2("  exclude_hv          %u    ", attr->exclude_hv);
> +	pr_debug2("exclude_idle        %u\n", attr->exclude_idle);
> +	pr_debug2("  mmap                %u    ", attr->mmap);
> +	pr_debug2("comm                %u\n", attr->comm);
> +	pr_debug2("  freq                %u    ", attr->freq);
> +	pr_debug2("inherit_stat        %u\n", attr->inherit_stat);
> +	pr_debug2("  enable_on_exec      %u    ", attr->enable_on_exec);
> +	pr_debug2("task                %u\n", attr->task);
> +	pr_debug2("  watermark           %u    ", attr->watermark);
> +	pr_debug2("precise_ip          %u\n", attr->precise_ip);
> +	pr_debug2("  mmap_data           %u    ", attr->mmap_data);
> +	pr_debug2("sample_id_all       %u\n", attr->sample_id_all);
> +	pr_debug2("  exclude_host        %u    ", attr->exclude_host);
> +	pr_debug2("exclude_guest       %u\n", attr->exclude_guest);
> +	pr_debug2("  excl.callchain.kern %u    ", attr->exclude_callchain_kernel);
> +	pr_debug2("excl.callchain.user %u\n", attr->exclude_callchain_user);
> +
> +	pr_debug2("  wakeup_events       %u\n", attr->wakeup_events);
> +	pr_debug2("  wakeup_watermark    %u\n", attr->wakeup_watermark);
> +	pr_debug2("  bp_type             %#x\n", attr->bp_type);
> +	pr_debug2("  bp_addr             %#"PRIx64"\n", (uint64_t)attr->bp_addr);
> +	pr_debug2("  config1             %#"PRIx64"\n", (uint64_t)attr->config1);
> +	pr_debug2("  bp_len              %"PRIu64"\n", (uint64_t)attr->bp_len);
> +	pr_debug2("  config2             %#"PRIx64"\n", (uint64_t)attr->config2);
> +	pr_debug2("  branch_sample_type  %#"PRIx64"\n", (uint64_t)attr->branch_sample_type);
> +	pr_debug2("  sample_regs_user    %#"PRIx64"\n", (uint64_t)attr->sample_regs_user);
> +	pr_debug2("  sample_stack_user   %u\n", attr->sample_stack_user);
> +	pr_debug2("------------------------------------------------------------\n");
> +}
> +
>  static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
>  			      struct thread_map *threads)
>  {
> @@ -840,6 +889,7 @@ retry_sample_id:
>  	if (perf_missing_features.sample_id_all)
>  		evsel->attr.sample_id_all = 0;
>  
> +	show_attr(&evsel->attr);
>  	for (cpu = 0; cpu < cpus->nr; cpu++) {
>  
>  		for (thread = 0; thread < threads->nr; thread++) {
> @@ -850,6 +900,8 @@ retry_sample_id:
>  
>  			group_fd = get_group_fd(evsel, cpu, thread);
>  
> +			pr_debug2("perf_event_open: pid %d  cpu %d  group_fd %d  flags %#lx\n",
> +				  pid, cpus->map[cpu], group_fd, flags);
>  			FD(evsel, cpu, thread) = sys_perf_event_open(&evsel->attr,
>  								     pid,
>  								     cpus->map[cpu],
> -- 
> 1.7.11.7
