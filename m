Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438AbaKFCEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 21:04:41 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:42219 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbaKFCEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 21:04:34 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/3] ftracetest: Clear trace buffer after running kprobe testcases
Date: Thu,  6 Nov 2014 11:04:29 +0900
Message-Id: <1415239470-28705-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1415239470-28705-1-git-send-email-namhyung@kernel.org>
References: <1415239470-28705-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
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
2.1.2

