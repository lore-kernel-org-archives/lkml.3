Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab3DYGuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 02:50:50 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57373 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab3DYGut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 02:50:49 -0400
X-AuditID: 9c930179-b7b5bae0000069d1-b0-5178d2459ba7
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
Date: Thu, 25 Apr 2013 15:50:45 +0900
In-Reply-To: <20130424141724.GH971@krava.brq.redhat.com> (Jiri Olsa's message
	of "Wed, 24 Apr 2013 16:17:24 +0200")
Message-ID: <877gjr9k8q.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Apr 2013 16:17:24 +0200, Jiri Olsa wrote:
> On Tue, Apr 23, 2013 at 05:31:10PM +0900, Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> It's convenient to use pager when seeing many lines of result.
>> 
> for some reason I'm able to get any output for 'live' command only
> when using --no-pager option. I dont get any data for:
>
>   # ./perf ftrace live ls
>
>   not even ls output
>
> But sometime I dont even get ftrace output for:
>
>   # ./perf --no-pager ftrace live ls
>
>   just ls output
>
>
> I wonder there's some race with reading trace_pipe file,
> I haven't checked deeply yet..

It seems go_pipe in perf_evlist__prepare_workload() was closed due to
the pager process, so the workload ended up blocking indefinitely.

I guess other subcommands were not affected by this since record doesn't
use a pager, and show and report don't have a workload.

Does the patch below fix it?



diff --git a/tools/perf/builtin-ftrace.c b/tools/perf/builtin-ftrace.c
index 95f9a7fa3e04..3f3a684193e0 100644
--- a/tools/perf/builtin-ftrace.c
+++ b/tools/perf/builtin-ftrace.c
@@ -1486,12 +1486,12 @@ __cmd_ftrace_live(struct perf_ftrace *ftrace, int argc, const char **argv)
        if (!argc && perf_target__none(&ftrace->target))
                usage_with_options(live_usage, live_options);
 
+       setup_pager();
+
        ret = ftrace_setup(ftrace, argc, argv);
        if (ret < 0)
                return ret;
 
-       setup_pager();
-
        ret = do_ftrace_live(ftrace);
 
        ftrace_teardown(ftrace);
