Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab3EFBpE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 21:45:04 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48731 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab3EFBpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 21:45:02 -0400
X-AuditID: 9c930197-b7c1fae000001854-0b-51870b1b7cd6
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 09/14] perf ftrace: Add 'record' sub-command
References: <1366705872-12132-1-git-send-email-namhyung@kernel.org>
	<1366705872-12132-10-git-send-email-namhyung@kernel.org>
	<20130424141241.GG971@krava.brq.redhat.com>
	<87bo939lgt.fsf@sejong.aot.lge.com>
Date: Mon, 06 May 2013 10:44:56 +0900
In-Reply-To: <87bo939lgt.fsf@sejong.aot.lge.com> (Namhyung Kim's message of
	"Thu, 25 Apr 2013 15:24:18 +0900")
Message-ID: <87mws8990n.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Sorry for late reply.  I've been busy these days.

On Thu, 25 Apr 2013 15:24:18 +0900, Namhyung Kim wrote:
> On Wed, 24 Apr 2013 16:12:41 +0200, Jiri Olsa wrote:
>> I got following lockup for record command:
>>
>>   # ./perf --no-pager ftrace record ls
>>   ...
>>   hangs
>>
>>   in other terminal:
>>
>>   # pstack 14237
>>   Thread 2 (Thread 0x7f3f1aa1d700 (LWP 14241)):
>>   #0  0x0000003cec20b595 in pthread_cond_wait@@GLIBC_2.3.2 () from /lib64/libpthread.so.0
>>   #1  0x0000000000446ebe in record_ftrace_raw_buffer (arg=0x21f9ce0) at builtin-ftrace.c:451
>>   #2  0x0000003cec207d14 in start_thread () from /lib64/libpthread.so.0
>>   #3  0x0000003cebaf168d in clone () from /lib64/libc.so.6
>>   Thread 1 (Thread 0x7f3f1ba209c0 (LWP 14237)):
>>   #0  0x0000003cec208e60 in pthread_join () from /lib64/libpthread.so.0
>>   #1  0x0000000000449c8c in do_ftrace_record (ftrace=ftrace@entry=0x7fff1377d240) at builtin-ftrace.c:682
>>   #2  0x000000000044a57b in __cmd_ftrace_record (argv=0x7fff1377d818, argc=<optimized out>, ftrace=0x7fff1377d240) at builtin-ftrace.c:1535
>>   #3  cmd_ftrace (argc=2, argv=0x7fff1377d818, prefix=<optimized out>) at builtin-ftrace.c:1655
>>   #4  0x000000000041a763 in run_builtin (p=p@entry=0x7d58a0, argc=argc@entry=3, argv=argv@entry=0x7fff1377d818) at perf.c:320
>>   #5  0x0000000000419faf in handle_internal_command (argv=0x7fff1377d818, argc=3) at perf.c:377
>>   #6  run_argv (argv=0x7fff1377d600, argcp=0x7fff1377d60c) at perf.c:421
>>   #7  main (argc=3, argv=0x7fff1377d818) at perf.c:522
>>
>
> How often can you reproduce it?  I can't. :(
>
> But it looks there's a race between cond_wait() and cond_broatcast().
> I'll take a look at that.

I think the problem is that a recorder can be blocked if it received a
broadcast signal before calling cond_wait().  So I modified the code to
place signaling ready_cond and waiting start_cond in the same cs.

Does the patch below fix your problem?

Thanks,
Namhyung


diff --git a/tools/perf/builtin-ftrace.c b/tools/perf/builtin-ftrace.c
index 4296948197de..f1ecfa207822 100644
--- a/tools/perf/builtin-ftrace.c
+++ b/tools/perf/builtin-ftrace.c
@@ -428,12 +428,6 @@ static void *record_ftrace_raw_buffer(void *arg)
 
        fra->state = RECORD_STATE__READY;
 
-       /* Now I'm ready */
-       pthread_mutex_lock(&recorder_mutex);
-       recorder_count++;
-       pthread_cond_signal(&recorder_ready_cond);
-       pthread_mutex_unlock(&recorder_mutex);
-
        /*
         * block all signals but SIGUSR2.
         * It'll be used to unblock a recorder to finish.
@@ -447,7 +441,10 @@ static void *record_ftrace_raw_buffer(void *arg)
        fcntl(trace_fd, F_SETFL, O_NONBLOCK);
        pollfd.fd = trace_fd;
 
+       /* Now I'm ready */
        pthread_mutex_lock(&recorder_mutex);
+       recorder_count++;
+       pthread_cond_signal(&recorder_ready_cond);
        pthread_cond_wait(&recorder_start_cond, &recorder_mutex);
        pthread_mutex_unlock(&recorder_mutex);
 
