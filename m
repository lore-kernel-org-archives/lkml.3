Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172Ab3G2PBn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 11:01:43 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:49826 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab3G2PBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 11:01:42 -0400
Message-ID: <51F683D2.3020901@gmail.com>
Date: Mon, 29 Jul 2013 09:01:38 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@intel.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf: sample after exit loses thread correlation
References: <1374876254-44372-1-git-send-email-dsahern@gmail.com> <51F64411.9060506@intel.com>
In-Reply-To: <51F64411.9060506@intel.com>
Content-Type: multipart/mixed;
 boundary="------------050904090901000007020803"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050904090901000007020803
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 7/29/13 4:29 AM, Adrian Hunter wrote:
>> When perf processes the EXIT event the thread is moved to the
>> dead_threads
>> list. When the SAMPLE event is processed no thread exists for the pid
>> so a new
>> one is created by machine__findnew_thread.
>
> In the case of per-cpu recording, it is normal for sample events to
> occur after the EXIT event simply because the EXIT event is recorded
> while the task is still running (in kernel).  It is therefore a mistake
> to move the thread to dead_threads just because of the EXIT event.
>
> Instead the thread should be marked as exiting and not moved to
> dead_threads until another thread starts on the same CPU. i.e. a comm,
> mmap, fork event with the same tid and same CPU, or any event with a
> different tid and same CPU.
>

Interesting idea -- delaying the move to the dead-threads list. 
Following solves the problem as well.


--------------050904090901000007020803
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="a.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="a.patch"

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index f9f9d63..0d29b1b 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -994,11 +994,27 @@ out_problem:
 	return 0;
 }
 
+static void machine__remove_thread(struct machine *machine, struct thread *th)
+{
+	machine->last_match = NULL;
+	rb_erase(&th->rb_node, &machine->threads);
+	/*
+	 * We may have references to this thread, for instance in some hist_entry
+	 * instances, so just move them to a separate list.
+	 */
+	list_add_tail(&th->node, &machine->dead_threads);
+}
+
 int machine__process_fork_event(struct machine *machine, union perf_event *event)
 {
-	struct thread *thread = machine__findnew_thread(machine, event->fork.tid);
+	struct thread *thread = machine__find_thread(machine, event->fork.tid);
 	struct thread *parent = machine__findnew_thread(machine, event->fork.ptid);
 
+	/* if a thread currently exists for the thread id remove it */
+	if (thread != NULL)
+		machine__remove_thread(machine, thread);
+
+	thread = machine__findnew_thread(machine, event->fork.tid);
 	if (dump_trace)
 		perf_event__fprintf_task(event, stdout);
 
@@ -1011,27 +1027,12 @@ int machine__process_fork_event(struct machine *machine, union perf_event *event
 	return 0;
 }
 
-static void machine__remove_thread(struct machine *machine, struct thread *th)
-{
-	machine->last_match = NULL;
-	rb_erase(&th->rb_node, &machine->threads);
-	/*
-	 * We may have references to this thread, for instance in some hist_entry
-	 * instances, so just move them to a separate list.
-	 */
-	list_add_tail(&th->node, &machine->dead_threads);
-}
-
-int machine__process_exit_event(struct machine *machine, union perf_event *event)
+int machine__process_exit_event(struct machine *machine __maybe_unused,
+				union perf_event *event)
 {
-	struct thread *thread = machine__find_thread(machine, event->fork.tid);
-
 	if (dump_trace)
 		perf_event__fprintf_task(event, stdout);
 
-	if (thread != NULL)
-		machine__remove_thread(machine, thread);
-
 	return 0;
 }
 

--------------050904090901000007020803--
