Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491Ab3B0WaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 17:30:21 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:62353 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433Ab3B0WaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 17:30:15 -0500
Message-ID: <512E88F2.4030501@gmail.com>
Date: Wed, 27 Feb 2013 15:30:10 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130216 Thunderbird/17.0.3
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
Subject: Re: [PATCH v2 2/4] Transform thread_map to linked list
References: <1361871710-6251-1-git-send-email-chenggang.qin@gmail.com> <1361871710-6251-3-git-send-email-chenggang.qin@gmail.com>
In-Reply-To: <1361871710-6251-3-git-send-email-chenggang.qin@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/26/13 2:41 AM, chenggang wrote:

---8<---

> diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
> index 5cd13d7..91d2848 100644
> --- a/tools/perf/util/event.c
> +++ b/tools/perf/util/event.c
> @@ -327,8 +327,8 @@ int perf_event__synthesize_thread_map(struct perf_tool *tool,
>   	err = 0;
>   	for (thread = 0; thread < threads->nr; ++thread) {
>   		if (__event__synthesize_thread(comm_event, mmap_event,
> -					       threads->map[thread], 0,
> -					       process, tool, machine)) {
> +					       thread_map__get_pid(threads,
> +					       thread), 0, process, tool,
> +					       machine)) {

ouch, that needs to be easier on the eyes. Use an intermediate variable 
for the thread_map__get_pid(threads, thread).

>   			err = -1;
>   			break;
>   		}
> @@ -337,12 +337,14 @@ int perf_event__synthesize_thread_map(struct perf_tool *tool,
>   		 * comm.pid is set to thread group id by
>   		 * perf_event__synthesize_comm
>   		 */
> -		if ((int) comm_event->comm.pid != threads->map[thread]) {
> +		if ((int) comm_event->comm.pid
> +		    != thread_map__get_pid(threads, thread)) {

ditto. intermediate variable will make that easier to read.

>   			bool need_leader = true;
>
>   			/* is thread group leader in thread_map? */
>   			for (j = 0; j < threads->nr; ++j) {
> -				if ((int) comm_event->comm.pid == threads->map[j]) {
> +				if ((int) comm_event->comm.pid
> +				    == thread_map__get_pid(threads, thread)) {

and again here. Now should that be j instead of thread? i.e,
      thread_map__get_pid(threads, j)

>   					need_leader = false;
>   					break;
>   				}

---8<---

> diff --git a/tools/perf/util/thread_map.c b/tools/perf/util/thread_map.c
> index 9b5f856..5f96fdf 100644
> --- a/tools/perf/util/thread_map.c
> +++ b/tools/perf/util/thread_map.c
> @@ -19,9 +19,72 @@ static int filter(const struct dirent *dir)
>   		return 1;
>   }
>
> -struct thread_map *thread_map__new_by_pid(pid_t pid)
> +struct thread_map *thread_map__init(void)
>   {
>   	struct thread_map *threads;
> +
> +	threads = malloc(sizeof(*threads));
> +	if (threads == NULL)
> +		return NULL;
> +
> +	threads->nr = 0;
> +	INIT_LIST_HEAD(&threads->head);
> +	return threads;
> +}
> +
> +void thread_map__delete(struct thread_map *threads)
> +{
> +	struct thread_pid *tp, *tmp;
> +
> +	list_for_each_entry_safe(tp, tmp, &threads->head, next) {
> +		list_del(&tp->next);
> +		free(tp);
> +	}
> +
> +	free(threads);
> +}
> +
> +int thread_map__append(struct thread_map *threads, pid_t pid)
> +{
> +	struct thread_pid *tp;
> +
> +	if (threads == NULL)
> +		return -1;
> +
> +	list_for_each_entry(tp, &threads->head, next)
> +		if (tp->pid == pid) /*The thread is exist*/
> +			return 1;

braces around multi-line statements

> +
> +	tp = malloc(sizeof(*tp));
> +	if (tp == NULL)
> +		return -1;
> +
> +	tp->pid = pid;
> +	list_add_tail(&tp->next, &threads->head);
> +	threads->nr++;
> +
> +	return 0; /*success*/
> +}
> +
> +int thread_map__remove(struct thread_map *threads, int idx)
> +{
> +	struct thread_pid *tp;
> +	int count = 0;
> +
> +	list_for_each_entry(tp, &threads->head, next)
> +		if (count++ == idx) {
> +			list_del(&tp->next);
> +			free(tp);
> +			threads->nr--;
> +			return 0;
> +		}

braces

> +
> +	return -1;
> +}
> +
> +struct thread_map *thread_map__new_by_pid(pid_t pid)
> +{
> +	struct thread_map *threads = NULL;
>   	char name[256];
>   	int items;
>   	struct dirent **namelist = NULL;
> @@ -32,40 +95,49 @@ struct thread_map *thread_map__new_by_pid(pid_t pid)
>   	if (items <= 0)
>   		return NULL;
>
> -	threads = malloc(sizeof(*threads) + sizeof(pid_t) * items);
> -	if (threads != NULL) {
> +	threads = thread_map__init();
> +	if (threads != NULL)
>   		for (i = 0; i < items; i++)
> -			threads->map[i] = atoi(namelist[i]->d_name);
> -		threads->nr = items;
> -	}
> +			if (thread_map__append(threads,
> +			    atoi(namelist[i]->d_name)) == -1)
> +				goto out_free_threads;

braces; check the indentation too. I think the above 3 lines go under 
the 'if (threads != NULL)' check

>
>   	for (i=0; i<items; i++)
>   		free(namelist[i]);
>   	free(namelist);
>
>   	return threads;
> +
> +out_free_threads:
> +	thread_map__delete(threads);
> +	return NULL;
>   }
>
>   struct thread_map *thread_map__new_by_tid(pid_t tid)
>   {
> -	struct thread_map *threads = malloc(sizeof(*threads) + sizeof(pid_t));
> +	struct thread_map *threads = NULL;
>
> -	if (threads != NULL) {
> -		threads->map[0] = tid;
> -		threads->nr	= 1;
> -	}
> +	threads = thread_map__init();
> +	if (threads != NULL)
> +		if (thread_map__append(threads, tid) == -1)
> +			goto out_free_threads;

braces

>
>   	return threads;
> +
> +out_free_threads:
> +	thread_map__delete(threads);
> +	return NULL;
>   }
>
>   struct thread_map *thread_map__new_by_uid(uid_t uid)
>   {
>   	DIR *proc;
> -	int max_threads = 32, items, i;
> +	int items, i;
>   	char path[256];
>   	struct dirent dirent, *next, **namelist = NULL;
> -	struct thread_map *threads = malloc(sizeof(*threads) +
> -					    max_threads * sizeof(pid_t));
> +	struct thread_map *threads = NULL;
> +
> +	threads = thread_map__init();
>   	if (threads == NULL)
>   		goto out;
>
> @@ -73,11 +145,8 @@ struct thread_map *thread_map__new_by_uid(uid_t uid)
>   	if (proc == NULL)
>   		goto out_free_threads;
>
> -	threads->nr = 0;
> -
>   	while (!readdir_r(proc, &dirent, &next) && next) {
>   		char *end;
> -		bool grow = false;
>   		struct stat st;
>   		pid_t pid = strtol(dirent.d_name, &end, 10);
>
> @@ -97,30 +166,13 @@ struct thread_map *thread_map__new_by_uid(uid_t uid)
>   		if (items <= 0)
>   			goto out_free_closedir;
>
> -		while (threads->nr + items >= max_threads) {
> -			max_threads *= 2;
> -			grow = true;
> -		}
> -
> -		if (grow) {
> -			struct thread_map *tmp;
> -
> -			tmp = realloc(threads, (sizeof(*threads) +
> -						max_threads * sizeof(pid_t)));
> -			if (tmp == NULL)
> -				goto out_free_namelist;
> -
> -			threads = tmp;
> -		}
> -
>   		for (i = 0; i < items; i++)
> -			threads->map[threads->nr + i] = atoi(namelist[i]->d_name);
> +			if (thread_map__append(threads, atoi(namelist[i]->d_name) < 0))
> +				goto out_free_namelist;
>
>   		for (i = 0; i < items; i++)
>   			free(namelist[i]);
>   		free(namelist);
> -
> -		threads->nr += items;
>   	}
>
>   out_closedir:
> @@ -129,7 +181,7 @@ out:
>   	return threads;
>
>   out_free_threads:
> -	free(threads);
> +	thread_map__delete(threads);
>   	return NULL;
>
>   out_free_namelist:
> @@ -138,7 +190,7 @@ out_free_namelist:
>   	free(namelist);
>
>   out_free_closedir:
> -	free(threads);
> +	thread_map__delete(threads);
>   	threads = NULL;
>   	goto out_closedir;
>   }
> @@ -156,11 +208,11 @@ struct thread_map *thread_map__new(pid_t pid, pid_t tid, uid_t uid)
>
>   static struct thread_map *thread_map__new_by_pid_str(const char *pid_str)
>   {
> -	struct thread_map *threads = NULL, *nt;
> +	struct thread_map *threads = NULL;
>   	char name[256];
> -	int items, total_tasks = 0;
> +	int items;
>   	struct dirent **namelist = NULL;
> -	int i, j = 0;
> +	int i;
>   	pid_t pid, prev_pid = INT_MAX;
>   	char *end_ptr;
>   	struct str_node *pos;
> @@ -169,6 +221,10 @@ static struct thread_map *thread_map__new_by_pid_str(const char *pid_str)
>   	if (!slist)
>   		return NULL;
>
> +	threads = thread_map__init();
> +	if (threads == NULL)
> +		return NULL;
> +
>   	strlist__for_each(pos, slist) {
>   		pid = strtol(pos->s, &end_ptr, 10);
>
> @@ -184,19 +240,12 @@ static struct thread_map *thread_map__new_by_pid_str(const char *pid_str)
>   		if (items <= 0)
>   			goto out_free_threads;
>
> -		total_tasks += items;
> -		nt = realloc(threads, (sizeof(*threads) +
> -				       sizeof(pid_t) * total_tasks));
> -		if (nt == NULL)
> -			goto out_free_namelist;
> -
> -		threads = nt;
> +		for (i = 0; i < items; i++)
> +			if (thread_map__append(threads, atoi(namelist[i]->d_name)) < 0)
> +				goto out_free_namelist;

and more braces....

>
> -		for (i = 0; i < items; i++) {
> -			threads->map[j++] = atoi(namelist[i]->d_name);
> +		for (i = 0; i < items; i++)
>   			free(namelist[i]);
> -		}
> -		threads->nr = total_tasks;
>   		free(namelist);
>   	}
>

---8<---

> diff --git a/tools/perf/util/xyarray.c b/tools/perf/util/xyarray.c
> index fc48bda..5777bc2 100644
> --- a/tools/perf/util/xyarray.c
> +++ b/tools/perf/util/xyarray.c
> @@ -78,13 +78,13 @@ int xyarray__remove(struct xyarray *xy, int y)
>   void xyarray__delete(struct xyarray *xy)
>   {
>   	unsigned int i;
> -	struct xyentry *entry;
> +	struct xyentry *entry, *tmp;
>
>   	if (!xy)
>   		return;
>
>   	for (i = 0; i < xy->row_count; i++)
> -		list_for_each_entry(entry, &xy->rows[i].head, next) {
> +		list_for_each_entry_safe(entry, tmp, &xy->rows[i].head, next) {
>   			list_del(&entry->next);
>   			free(entry);
>   		}
>

These xyarray changes should be in the first patch.

David
