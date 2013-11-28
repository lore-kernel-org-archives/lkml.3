Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920Ab3K1QBI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 11:01:08 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:61498 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705Ab3K1QBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 11:01:04 -0500
Message-ID: <529768BC.2090604@gmail.com>
Date: Thu, 28 Nov 2013 09:01:00 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 6/8] perf sched: Introduce timehist command
References: <1384806771-2945-1-git-send-email-dsahern@gmail.com>	<1384806771-2945-7-git-send-email-dsahern@gmail.com> <87siugq2hr.fsf@sejong.aot.lge.com>
In-Reply-To: <87siugq2hr.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/13, 2:50 AM, Namhyung Kim wrote:
>> +static inline void printf_nsecs(unsigned long long nsecs, int width_sec)
>> >+{
>> >+	unsigned long secs;
>> >+	unsigned long usecs;
>> >+
>> >+	secs = nsecs / NSECS_PER_SEC;
>> >+	nsecs -= secs * NSECS_PER_SEC;
>> >+	usecs = nsecs / NSECS_PER_USEC;
>> >+	printf("%*lu.%06lu ", width_sec, secs, usecs);
>> >+}
> It seems very similar to what timehist_time_str() does.  Better to
> factor out?

yes and no. The above is used to dump time-based stats (time between 
sched-in events, scheduling delay, and run time).

What I really want for timehist_time_str is time-of-day. And in local 
variants of this code I have that. Until I can convince Peter, et al. 
about the real need to pull perf_clock into userspace this is a bit of a 
place holder so that local code and this version do not differ too much.

>
>
> [SNIP]
>> >+static unsigned int comm_width = 20;
>> >+
>> >+static char *timehist_get_commstr(struct thread *thread)
>> >+{
>> >+	static char str[32];
>> >+	const char *comm = thread__comm_str(thread);
>> >+	pid_t tid = thread->tid;
>> >+	pid_t pid = thread->pid_;
>> >+	unsigned int n;
>> >+
>> >+	if (pid == 0)
>> >+		scnprintf(str, sizeof(str), "%s", comm);
>> >+
>> >+	else if (tid != pid)
>> >+		scnprintf(str, sizeof(str), "%s[%d/%d]", comm, tid, pid);
>> >+
>> >+	else
>> >+		scnprintf(str, sizeof(str), "%s[%d]", comm, tid);
>> >+
>> >+	n = strlen(str);
> Why not just using return value of scnprintf()?

right. will do.

>
>
>> >+	if (n > comm_width)
>> >+		comm_width = n;
>> >+
>> >+	return str;
>> >+}
>> >+
>> >+static void timehist_header(struct perf_sched *sched)
>> >+{
>> >+	u32 max_cpus = sched->max_cpu;
>> >+	u32 i, j;
>> >+
>> >+	printf("%15s %-4s", "time", "cpu");
>> >+
>> >+	if (sched->show_cpu_visual && max_cpus) {
>> >+		printf(" ");
>> >+		for (i = 0, j = 0; i < max_cpus; ++i) {
>> >+			printf("%x", j++);
>> >+			if (j > 15)
>> >+				j = 0;
>> >+		}
>> >+		printf(" ");
>> >+	}
>> >+
>> >+	printf(" %-20s %9s %9s %9s",
>> >+		"task name[tid/pid]", "b/n time", "sch delay", "run time");
>> >+
>> >+	if (sched->show_wakeups)
>> >+		printf("  %-20s", "wakeup");
>> >+
>> >+	printf("\n");
>> >+
>> >+	printf("%15s %4s", "---------------", "----");
> You might want to use "%.15s" and graph_dotted_line.

did not know about that. will update.


>> >+static void timehist_print_sample(struct perf_sched *sched,
>> >+				  union perf_event *event,
>> >+				  struct perf_evsel *evsel,
>> >+				  struct perf_sample *sample,
>> >+				  struct thread *thread,
>> >+				  struct machine *machine)
>> >+{
>> >+	struct thread_runtime *tr = thread__priv(thread);
>> >+	char tstr[64];
>> >+	u32 max_cpus = sched->max_cpu;
>> >+
>> >+	printf("%15s ", timehist_time_str(tstr, sizeof(tstr), sample->time));
>> >+
>> >+	printf("[%02d] ", sample->cpu);
>> >+
>> >+	if (sched->show_cpu_visual && max_cpus) {
>> >+		u32 i;
>> >+		char c;
>> >+		for (i = 0; i < max_cpus; ++i) {
>> >+			if (i == sample->cpu)
>> >+				c = (thread->tid == 0) ? 'i' : 's';
> It'd better explaining what the 'i' and 's' mean..

visual aid: i = idle, s = sched-event. will add a comment.

>> >+static void free_idle_threads(void)
>> >+{
>> >+	int i;
>> >+
>> >+	if (idle_threads == NULL)
>> >+		return;
>> >+
>> >+	for (i = 0; i <= idle_max_cpu; ++i)
>> >+		free(idle_threads[i]);
> Doesn't it need to be thread__delete(idle_threads[i]) ?

yes. forgot to update this to the new api.

David

