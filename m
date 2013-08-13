Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab3HMCU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 22:20:57 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:43802 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756687Ab3HMCU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 22:20:56 -0400
X-AuditID: 9c930197-b7b44ae00000347f-75-520998041271
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Jeremy Eder <jeder@redhat.com>
Subject: Re: [PATCHSET 00/17] perf tools: Introduce new 'ftrace' command (v4)
References: <1375175954-798-1-git-send-email-namhyung@kernel.org>
	<20130809102306.GA1045@krava.brq.redhat.com>
Date: Tue, 13 Aug 2013 11:20:52 +0900
In-Reply-To: <20130809102306.GA1045@krava.brq.redhat.com> (Jiri Olsa's message
	of "Fri, 9 Aug 2013 12:23:06 +0200")
Message-ID: <87r4dywcu3.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri and Jeremy,

On Fri, 9 Aug 2013 12:23:06 +0200, Jiri Olsa wrote:
> On Tue, Jul 30, 2013 at 06:18:57PM +0900, Namhyung Kim wrote:
>> This patchset implements a front-end tool for kernel's ftrace.  It
>> uses function_graph tracer by default and normal function tracer is
>> also supported.  (Of course you need to enable those tracers in your
>> kernel first.)
>> 
>> v4 changes:
>>  * use pid instead of tid for -p option (David)
>>  * not to poll() for reading ftrace pipes (Jiri)
>>  * rename to create_perf_header() (Jiri)
>>  * canonicalize directory name (Jiri)
>>  * show more info when -D option was given (Jiri)
>>  * update documentation (Jiri)
>>  * and few more bug fixes
>> 
>> I pushed it out to 'perf/ftrace-v4' branch on my tree at:
>> 
>>   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
>
> got following for record:
>
> [root@dhcp-26-214 perf]# ./perf ftrace record kill
> usage: kill [ -s signal | -p ] [ -a ] pid ...
>        kill -l [ signal ]
> recorder failed for some reason on cpu0
> recorder failed for some reason on cpu1

It seems like an empty trace pipe returns EAGAIN after child exited - I
expected an EOF.  I don't know why I didn't meet this on my system (FYI
I'm running F17 and this patch tested on that kernel mostly).  Maybe
recent kernel changed the behavior.

Anyway I added a check and printed error message on other cases.  Could
you please test whether the patch below works?

>
>
> afterwards 'perf ftrace report' gets stuck with 2 processes:
>
> [jolsa@dhcp-26-214 perf]$ sudo pstack 1470
> #0  0x00007f23ab61e997 in munmap () from /lib64/libc.so.6
> #1  0x000000000047b5f7 in __perf_session__process_events ()
> #2  0x000000000043f230 in do_ftrace_report ()
> #3  0x0000000000440555 in cmd_ftrace ()
> #4  0x000000000041aad3 in run_builtin ()
> #5  0x000000000041a379 in main ()

Hmm.. this repeated munmap() calls are fixed also.


> [jolsa@dhcp-26-214 perf]$ sudo pstack 1471
> #0  0x00007f23ab61b623 in __select_nocancel () from /lib64/libc.so.6
> #1  0x000000000046a337 in pager_preexec ()
> #2  0x000000000045f5a3 in start_command ()
> #3  0x000000000046a4ab in setup_pager ()
> #4  0x0000000000440535 in cmd_ftrace ()
> #5  0x000000000041aad3 in run_builtin ()
> #6  0x000000000041a379 in main ()



------------8<-------------
diff --git a/tools/perf/builtin-ftrace.c b/tools/perf/builtin-ftrace.c
index 9e78ec19caeb..10590b794cae 100644
--- a/tools/perf/builtin-ftrace.c
+++ b/tools/perf/builtin-ftrace.c
@@ -555,17 +555,25 @@ sleep:
 	while (true) {
 		int n = read(trace_fd, buf, sizeof(buf));
 
-		if (n < 0)
-			goto out_close;
-		if (n == 0)
+		if (n < 0) {
+			if (errno == EINTR || errno == EAGAIN)
+				break;
+			perror("flush read");
+			goto out_close2;
+		} else if (n == 0)
 			break;
-		if (write(output_fd, buf, n) != n)
-			goto out_close;
+
+		if (write(output_fd, buf, n) != n) {
+			perror("flush write");
+			goto out_close2;
+		}
 
 		byte_written += n;
 	}
 	fra->state = RECORD_STATE__DONE;
 
+out_close2:
+	close(output_fd);
 out_close:
 	close(trace_fd);
 out:
@@ -579,6 +587,8 @@ out:
 		pthread_cond_signal(&recorder_ready_cond);
 		pthread_mutex_unlock(&recorder_mutex);
 	}
+
+	pr_debug2("done with %ld bytes\n", (long)byte_written);
 	return fra;
 }
 
@@ -1139,12 +1149,12 @@ retry:
 		return record;
 	}
 
-	munmap(fra->map, pevent_get_page_size(ftrace->pevent));
-	fra->map = NULL;
-
 	if (fra->done)
 		return NULL;
 
+	munmap(fra->map, pevent_get_page_size(ftrace->pevent));
+	fra->map = NULL;
+
 	fra->offset += pevent_get_page_size(ftrace->pevent);
 	if (fra->offset >= fra->size) {
 		/* EOF */
