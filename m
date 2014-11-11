Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbaKKVo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 16:44:26 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:55229 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752179AbaKKVmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 16:42:09 -0500
Message-Id: <20141111214207.126077555@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 11 Nov 2014 16:41:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 5/6] ftracetest: Clear trace buffer after running kprobe testcases
References: <20141111214127.196849367@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0005-ftracetest-Clear-trace-buffer-after-running-kprobe-t.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

The kprobe testcases create, use and delete dynamic events during the
test but didn't clear the trace buffer so it'll leave the result after
it finishes.

  # ./ftracetest
  ...

  # cat trace
  # tracer: nop
  #
  # entries-in-buffer/entries-written: 2/2   #P:12
  #
  #                              _-----=> irqs-off
  #                             / _----=> need-resched
  #                            | / _---=> hardirq/softirq
  #                            || / _--=> preempt-depth
  #                            ||| /     delay
  #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
  #              | |       |   ||||       |         |
        ftracetest-26474 [009] d..1 79417.143782: Unknown type 1099
        ftracetest-26498 [009] d..1 79417.208034: Unknown type 1101

Link: http://lkml.kernel.org/r/1415239470-28705-2-git-send-email-namhyung@kernel.org

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc | 1 +
 tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc     | 1 +
 tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc    | 1 +
 tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc | 1 +
 4 files changed, 4 insertions(+)

diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc b/tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc
index 1b8b665ab2b3..a5a426211129 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc
@@ -9,3 +9,4 @@ echo p:myevent do_fork > kprobe_events
 grep myevent kprobe_events
 test -d events/kprobes/myevent
 echo > kprobe_events
+clear_trace
diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc b/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc
index b55c84003587..d8c7bb6581fe 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc
@@ -11,3 +11,4 @@ echo 1 > events/kprobes/myevent/enable
 echo > kprobe_events && exit 1 # this must fail
 echo 0 > events/kprobes/myevent/enable
 echo > kprobe_events # this must succeed
+clear_trace
diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc
index a603d3f8db7b..c45ee2761354 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc
@@ -12,5 +12,6 @@ echo 1 > events/kprobes/testprobe/enable
 ( echo "forked")
 echo 0 > events/kprobes/testprobe/enable
 echo "-:testprobe" >> kprobe_events
+clear_trace
 test -d events/kprobes/testprobe && exit 1 || exit 0
 
diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc
index 283c29e7f7c4..31717985acc7 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc
@@ -12,4 +12,5 @@ echo 1 > events/kprobes/testprobe2/enable
 ( echo "forked")
 echo 0 > events/kprobes/testprobe2/enable
 echo '-:testprobe2' >> kprobe_events
+clear_trace
 test -d events/kprobes/testprobe2 && exit 1 || exit 0
-- 
2.1.1


