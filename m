Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab3F1Rdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 13:33:38 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:49365 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359Ab3F1Rdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 13:33:36 -0400
Message-ID: <51CDC795.3070507@gmail.com>
Date: Fri, 28 Jun 2013 11:27:49 -0600
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
Subject: Re: [PATCH V3 14/15] perf tools: add pid to struct thread
References: <1372409006-8431-1-git-send-email-adrian.hunter@intel.com> <1372409006-8431-15-git-send-email-adrian.hunter@intel.com>
In-Reply-To: <1372409006-8431-15-git-send-email-adrian.hunter@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/28/13 2:43 AM, Adrian Hunter wrote:
> Record pid on struct thread.  The member is named 'pid_'
> to avoid confusion with the 'tid' member which was previously
> named 'pid'.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>   tools/perf/util/machine.c | 26 +++++++++++++++++++++-----
>   tools/perf/util/machine.h |  2 ++
>   tools/perf/util/thread.c  |  3 ++-
>   tools/perf/util/thread.h  |  3 ++-
>   4 files changed, 27 insertions(+), 7 deletions(-)
>
> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index ef0be97..722281a 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -233,7 +233,8 @@ void machines__set_id_hdr_size(struct machines *machines, u16 id_hdr_size)
>   	return;
>   }
>
> -static struct thread *__machine__findnew_thread(struct machine *machine, pid_t tid,
> +static struct thread *__machine__findnew_thread(struct machine *machine,
> +						pid_t pid, pid_t tid,
>   						bool create)
>   {
>   	struct rb_node **p = &machine->threads.rb_node;
> @@ -245,8 +246,11 @@ static struct thread *__machine__findnew_thread(struct machine *machine, pid_t t
>   	 * so most of the time we dont have to look up
>   	 * the full rbtree:
>   	 */
> -	if (machine->last_match && machine->last_match->tid == tid)
> +	if (machine->last_match && machine->last_match->tid == tid) {
> +		if (pid && !machine->last_match->pid_)
> +			machine->last_match->pid_ = pid;
>   		return machine->last_match;
> +	}
>
>   	while (*p != NULL) {
>   		parent = *p;
> @@ -254,6 +258,8 @@ static struct thread *__machine__findnew_thread(struct machine *machine, pid_t t
>
>   		if (th->tid == tid) {
>   			machine->last_match = th;
> +			if (pid && !th->pid_)
> +				th->pid_ = pid;
>   			return th;
>   		}
>
> @@ -266,7 +272,7 @@ static struct thread *__machine__findnew_thread(struct machine *machine, pid_t t
>   	if (!create)
>   		return NULL;
>
> -	th = thread__new(tid);
> +	th = thread__new(pid, tid);
>   	if (th != NULL) {
>   		rb_link_node(&th->rb_node, parent, p);
>   		rb_insert_color(&th->rb_node, &machine->threads);
> @@ -278,12 +284,12 @@ static struct thread *__machine__findnew_thread(struct machine *machine, pid_t t
>
>   struct thread *machine__findnew_thread(struct machine *machine, pid_t tid)
>   {
> -	return __machine__findnew_thread(machine, tid, true);
> +	return __machine__findnew_thread(machine, 0, tid, true);
>   }
>
>   struct thread *machine__find_thread(struct machine *machine, pid_t tid)
>   {
> -	return __machine__findnew_thread(machine, tid, false);
> +	return __machine__findnew_thread(machine, 0, tid, false);
>   }
>
>   int machine__process_comm_event(struct machine *machine, union perf_event *event)
> @@ -1264,3 +1270,13 @@ int machine__resolve_callchain(struct machine *machine,
>   				   sample);
>
>   }
> +
> +pid_t machine__get_thread_pid(struct machine *machine, pid_t tid)
> +{
> +	struct thread *thread = machine__find_thread(machine, tid);
> +
> +	if (!thread)
> +		return 0;
> +
> +	return thread->pid_;
> +}

The APIs should be machine__find_thread and then given a thread have 
something like thread__get_pid(thread) but to go from machine returning 
a thread's pid seems odd.

Also, there are no users of this function, so no need to create it anyways.

David


> diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
> index e49ba01..221a0a9 100644
> --- a/tools/perf/util/machine.h
> +++ b/tools/perf/util/machine.h
> @@ -156,4 +156,6 @@ void machines__destroy_kernel_maps(struct machines *machines);
>
>   size_t machine__fprintf_vmlinux_path(struct machine *machine, FILE *fp);
>
> +pid_t machine__get_thread_pid(struct machine *machine, pid_t tid);
> +
>   #endif /* __PERF_MACHINE_H */
> diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
> index 6feeb88..e3d4a55 100644
> --- a/tools/perf/util/thread.c
> +++ b/tools/perf/util/thread.c
> @@ -7,12 +7,13 @@
>   #include "util.h"
>   #include "debug.h"
>
> -struct thread *thread__new(pid_t tid)
> +struct thread *thread__new(pid_t pid, pid_t tid)
>   {
>   	struct thread *self = zalloc(sizeof(*self));
>
>   	if (self != NULL) {
>   		map_groups__init(&self->mg);
> +		self->pid_ = pid;
>   		self->tid = tid;
>   		self->ppid = -1;
>   		self->comm = malloc(32);
> diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
> index 37a86a3..bfa68e7 100644
> --- a/tools/perf/util/thread.h
> +++ b/tools/perf/util/thread.h
> @@ -12,6 +12,7 @@ struct thread {
>   		struct list_head node;
>   	};
>   	struct map_groups	mg;
> +	pid_t			pid_; /* Not all tools update this */
>   	pid_t			tid;
>   	pid_t			ppid;
>   	char			shortname[3];
> @@ -24,7 +25,7 @@ struct thread {
>
>   struct machine;
>
> -struct thread *thread__new(pid_t tid);
> +struct thread *thread__new(pid_t pid, pid_t tid);
>   void thread__delete(struct thread *self);
>
>   int thread__set_comm(struct thread *self, const char *comm);
>

