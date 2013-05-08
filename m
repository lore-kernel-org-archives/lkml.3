Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab3EHFtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 01:49:13 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:53480 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab3EHFtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 01:49:13 -0400
X-AuditID: 9c93016f-b7ba0ae000004cc2-c3-5189e7567784
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
Subject: Re: [PATCH 12/14] perf ftrace: Use pager for displaying result
References: <1366705872-12132-1-git-send-email-namhyung@kernel.org>
	<1366705872-12132-13-git-send-email-namhyung@kernel.org>
	<20130424141724.GH971@krava.brq.redhat.com>
	<877gjr9k8q.fsf@sejong.aot.lge.com>
	<20130426084023.GB1054@krava.brq.redhat.com>
	<87ip2w98nl.fsf@sejong.aot.lge.com>
	<20130506113819.GB1093@krava.brq.redhat.com>
Date: Wed, 08 May 2013 14:49:10 +0900
In-Reply-To: <20130506113819.GB1093@krava.brq.redhat.com> (Jiri Olsa's message
	of "Mon, 6 May 2013 13:38:19 +0200")
Message-ID: <871u9i81ih.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 May 2013 13:38:19 +0200, Jiri Olsa wrote:
> On Mon, May 06, 2013 at 10:52:46AM +0900, Namhyung Kim wrote:
>> On Fri, 26 Apr 2013 10:40:23 +0200, Jiri Olsa wrote:
>> > On Thu, Apr 25, 2013 at 03:50:45PM +0900, Namhyung Kim wrote:
>> >> On Wed, 24 Apr 2013 16:17:24 +0200, Jiri Olsa wrote:
>> >> > On Tue, Apr 23, 2013 at 05:31:10PM +0900, Namhyung Kim wrote:
>> >> >> From: Namhyung Kim <namhyung.kim@lge.com>
>> >> >> 
>> >> >> It's convenient to use pager when seeing many lines of result.
>> >> >> 
>> >> > for some reason I'm able to get any output for 'live' command only
>> >> > when using --no-pager option. I dont get any data for:
>> >> >
>> >> >   # ./perf ftrace live ls
>> >> >
>> >> >   not even ls output
>> >
>> > ok, now with your patch I get allways ls output correctly in pager
>> 
>> "ls output" only?  What about the ftrace outputs?
>> 
>> >
>> >> >
>> >> > But sometime I dont even get ftrace output for:
>> >> >
>> >> >   # ./perf --no-pager ftrace live ls
>> >> >
>> >> >   just ls output
>> >
>> > this one still persists
>> 
>> Hmm.. still hard to reproduce.. :(
>> 
>> As it's --no-pager mode, so that it can be reproduced for you without
>> this patch, right?
>
> right, I still see the second issue (not getting ftrace output)
> regardless of the patch being applied or not

Did you get the same result always?  What's the value of tracing_cpumask?

Could you please apply this debug patch below and run it again?

Thank you very much for your help!
Namhyung


diff --git a/tools/perf/builtin-ftrace.c b/tools/perf/builtin-ftrace.c
index f1ecfa207822..6b7aeae2dfa5 100644
--- a/tools/perf/builtin-ftrace.c
+++ b/tools/perf/builtin-ftrace.c
@@ -40,9 +40,11 @@ struct perf_ftrace {
 };
 
 static bool done;
+static int _signal;
 
 static void sig_handler(int sig __maybe_unused)
 {
+	_signal = sig;
 	done = true;
 }
 
@@ -218,6 +220,20 @@ static int do_ftrace_live(struct perf_ftrace *ftrace)
 
 	perf_evlist__start_workload(ftrace->evlist);
 
+	BUG_ON(ftrace->evlist->threads->map[0] != ftrace->evlist->workload.pid);
+
+	trace_file = get_tracing_file("tracing_on");
+	if (trace_file) {
+		int fd = open(trace_file, O_RDONLY);
+
+		BUG_ON(fd < 0);
+		BUG_ON(read(fd, buf, sizeof(buf)) < 0);
+		BUG_ON(buf[0] != '1');
+
+		close(fd);
+		put_tracing_file(trace_file);
+	}
+
 	while (!done) {
 		if (poll(&pollfd, 1, -1) < 0)
 			break;
@@ -231,6 +247,7 @@ static int do_ftrace_live(struct perf_ftrace *ftrace)
 		}
 	}
 
+	psignal(_signal, "perf");
 	write_tracing_file("tracing_on", "0");
 
 	/* read remaining buffer contents */


