Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab3CQXhq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 19:37:46 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:53043 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851Ab3CQXhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 19:37:45 -0400
Message-ID: <514653C7.2020203@gmail.com>
Date: Sun, 17 Mar 2013 17:37:43 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: chenggang <chenggang.qin@gmail.com>
CC: linux-kernel@vger.kernel.org, chenggang <chenggang.qcg@taobao.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 1/8]Perf: Transform thread_map to linked list
References: <1363167740-27735-1-git-send-email-chenggang.qin@gmail.com> <1363167740-27735-8-git-send-email-chenggang.qin@gmail.com>
In-Reply-To: <1363167740-27735-8-git-send-email-chenggang.qin@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi:

On 3/13/13 3:42 AM, chenggang wrote:
> ---
>   tools/perf/builtin-stat.c                 |    2 +-
>   tools/perf/tests/open-syscall-tp-fields.c |    2 +-
>   tools/perf/util/event.c                   |   12 +-
>   tools/perf/util/evlist.c                  |    2 +-
>   tools/perf/util/evsel.c                   |   16 +-
>   tools/perf/util/python.c                  |    2 +-
>   tools/perf/util/thread_map.c              |  281 ++++++++++++++++++++++-------
>   tools/perf/util/thread_map.h              |   17 +-
>   8 files changed, 244 insertions(+), 90 deletions(-)

You need to target smaller changes per patch. Think small, bisectable 
changes that evolve the code to where you want it to be.

For example, start with a patch that introduces the API 
thread_map__set_pid_by_idx:

int thread_map__set_pid_by_idx(struct thread_map *map, int idx, pid_t pid)
{
	if (idx >= map->nr)
		return -EINVAL;

	map[idx] = pid;

	return 0;
}

and use that method for the perf-stat change, 
tests/open-syscall-tp-fields.c and util/evlist.c. That's patch 1 -- 
small and focused.

>
> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index 9984876..293b09c 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -401,7 +401,7 @@ static int __run_perf_stat(int argc __maybe_unused, const char **argv)
>   		}
>
>   		if (perf_target__none(&target))
> -			evsel_list->threads->map[0] = child_pid;
> +			thread_map__set_pid(evsel_list->threads, 0, child_pid);
>
>   		/*
>   		 * Wait for the child to be ready to exec.
> diff --git a/tools/perf/tests/open-syscall-tp-fields.c b/tools/perf/tests/open-syscall-tp-fields.c
> index 1c52fdc..39eb770 100644
> --- a/tools/perf/tests/open-syscall-tp-fields.c
> +++ b/tools/perf/tests/open-syscall-tp-fields.c
> @@ -43,7 +43,7 @@ int test__syscall_open_tp_fields(void)
>
>   	perf_evsel__config(evsel, &opts);
>
> -	evlist->threads->map[0] = getpid();
> +	thread_map__append(evlist->threads, getpid());
>
>   	err = perf_evlist__open(evlist);
>   	if (err < 0) {


The second small patch introduces the method thread_map__get_pid_by_idx 
which is the counterpart to thread_map__set_pid_by_idx -- this time 
returning the pid for a given index. This new method fixes this use in 
util/event.c and the one in python.c below.

> diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
> index 5cd13d7..d093460 100644
> --- a/tools/perf/util/event.c
> +++ b/tools/perf/util/event.c
> @@ -326,9 +326,11 @@ int perf_event__synthesize_thread_map(struct perf_tool *tool,
>
>   	err = 0;
>   	for (thread = 0; thread < threads->nr; ++thread) {
> +		pid_t pid = thread_map__get_pid(threads, thread);
> +
>   		if (__event__synthesize_thread(comm_event, mmap_event,
> -					       threads->map[thread], 0,
> -					       process, tool, machine)) {
> +					       pid, 0, process, tool,
> +					       machine)) {
>   			err = -1;
>   			break;
>   		}
> @@ -337,12 +339,14 @@ int perf_event__synthesize_thread_map(struct perf_tool *tool,
>   		 * comm.pid is set to thread group id by
>   		 * perf_event__synthesize_comm
>   		 */
> -		if ((int) comm_event->comm.pid != threads->map[thread]) {
> +		if ((int) comm_event->comm.pid != pid) {
>   			bool need_leader = true;
>
>   			/* is thread group leader in thread_map? */
>   			for (j = 0; j < threads->nr; ++j) {
> -				if ((int) comm_event->comm.pid == threads->map[j]) {
> +				pid_t pidj = thread_map__get_pid(threads, j);
> +
> +				if ((int) comm_event->comm.pid == pidj) {
>   					need_leader = false;
>   					break;
>   				}
> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> index bc4ad79..d5063d6 100644
> --- a/tools/perf/util/evlist.c
> +++ b/tools/perf/util/evlist.c
> @@ -793,7 +793,7 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist,
>   	}
>
>   	if (perf_target__none(&opts->target))
> -		evlist->threads->map[0] = evlist->workload.pid;
> +		thread_map__append(evlist->threads, evlist->workload.pid);

Here you can use thread_map__set_pid_by_idx. When you convert the 
xyarray implementation you can come back to this call and change it to 
thread_map__append or have set_pid_by_idx do the append internally if 
the idx == threads->nr

>
>   	close(child_ready_pipe[1]);
>   	close(go_pipe[0]);
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index 9c82f98f..57c569d 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -835,7 +835,7 @@ retry_sample_id:
>   			int group_fd;
>
>   			if (!evsel->cgrp)
> -				pid = threads->map[thread];
> +				pid = thread_map__get_pid(threads, thread);
>
>   			group_fd = get_group_fd(evsel, cpu, thread);
>

This part here can be a separate stand-alone patch. In thread_map.c 
introduce the method:

struct thread_map *thread_map__empty_thread_map(void)
{
	static struct {
		struct thread_map map;
		int threads[1];
	} empty_thread_map = {
		.map.nr  = 1,
		.threads = { -1, },
	};

	return &empty_thread_map.map;
}

In a follow up patch you can change the implementation of this method 
but for now you want a small bisectable change.

> @@ -894,14 +894,6 @@ static struct {
>   	.cpus	= { -1, },
>   };
>
> -static struct {
> -	struct thread_map map;
> -	int threads[1];
> -} empty_thread_map = {
> -	.map.nr	 = 1,
> -	.threads = { -1, },
> -};
> -

keep the above code removal and fix the 2 below fixes.

>   int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
>   		     struct thread_map *threads)
>   {
> @@ -911,7 +903,7 @@ int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
>   	}
>
>   	if (threads == NULL)
> -		threads = &empty_thread_map.map;
> +		threads = thread_map__empty_thread_map();
>
>   	return __perf_evsel__open(evsel, cpus, threads);
>   }
> @@ -919,7 +911,9 @@ int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
>   int perf_evsel__open_per_cpu(struct perf_evsel *evsel,
>   			     struct cpu_map *cpus)
>   {
> -	return __perf_evsel__open(evsel, cpus, &empty_thread_map.map);
> +	struct thread_map *empty_thread_map = thread_map__empty_thread_map();
> +
> +	return __perf_evsel__open(evsel, cpus, empty_thread_map);
>   }
>
>   int perf_evsel__open_per_thread(struct perf_evsel *evsel,
> diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
> index 925e0c3..e3f3f1b 100644
> --- a/tools/perf/util/python.c
> +++ b/tools/perf/util/python.c
> @@ -458,7 +458,7 @@ static PyObject *pyrf_thread_map__item(PyObject *obj, Py_ssize_t i)
>   	if (i >= pthreads->threads->nr)
>   		return NULL;
>
> -	return Py_BuildValue("i", pthreads->threads->map[i]);
> +	return Py_BuildValue("i", thread_map__get_pid(pthreads->threads, i));
>   }
>
>   static PySequenceMethods pyrf_thread_map__sequence_methods = {


Once existing uses of threads->map are consolidated you can create a 
patch to convert the thread_map code to xyarray and introduce new 
methods needed.

> diff --git a/tools/perf/util/thread_map.c b/tools/perf/util/thread_map.c
> index 9b5f856..301f4ce 100644
> --- a/tools/perf/util/thread_map.c
> +++ b/tools/perf/util/thread_map.c
> @@ -19,9 +19,116 @@ static int filter(const struct dirent *dir)
>   		return 1;
>   }
>

Does that make sense?

David

