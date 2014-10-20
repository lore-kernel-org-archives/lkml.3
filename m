Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbaJTKwN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 06:52:13 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:43932 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404AbaJTKwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 06:52:09 -0400
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 1/2] ftracetest: add kprobes on ftrace testcase
Date: Mon, 20 Oct 2014 12:52:02 +0200
Message-Id: <1413802323-5297-2-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1413802323-5297-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1413802323-5297-1-git-send-email-heiko.carstens@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102010-0025-0000-0000-000001F68EBF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a kprobes on ftrace testcase. The testcase verifies that
- enabling and disabling function tracing works on a function which
  already contains a dynamic kprobe
- adding and removing a dynamic kprobe works on a function which is
  already enabled for function tracing

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 .../ftrace/test.d/kprobe/kprobe_ftrace.tc          | 55 ++++++++++++++++++++++
 1 file changed, 55 insertions(+)
 create mode 100644 tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc

diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc
new file mode 100644
index 000000000000..ab41d2b29841
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc
@@ -0,0 +1,55 @@
+#!/bin/sh
+# description: Kprobe dynamic event with function tracer
+
+[ -f kprobe_events ] || exit_unsupported # this is configurable
+grep function available_tracers || exit_unsupported # this is configurable
+
+# prepare
+echo nop > current_tracer
+echo do_fork > set_ftrace_filter
+echo 0 > events/enable
+echo > kprobe_events
+echo 'p:testprobe do_fork' > kprobe_events
+
+# kprobe on / ftrace off
+echo 1 > events/kprobes/testprobe/enable
+echo > trace
+( echo "forked")
+grep testprobe trace
+! grep 'do_fork <-' trace
+
+# kprobe on / ftrace on
+echo function > current_tracer
+echo > trace
+( echo "forked")
+grep testprobe trace
+grep 'do_fork <-' trace
+
+# kprobe off / ftrace on
+echo 0 > events/kprobes/testprobe/enable
+echo > trace
+( echo "forked")
+! grep testprobe trace
+grep 'do_fork <-' trace
+
+# kprobe on / ftrace on
+echo 1 > events/kprobes/testprobe/enable
+echo function > current_tracer
+echo > trace
+( echo "forked")
+grep testprobe trace
+grep 'do_fork <-' trace
+
+# kprobe on / ftrace off
+echo nop > current_tracer
+echo > trace
+( echo "forked")
+grep testprobe trace
+! grep 'do_fork <-' trace
+
+# cleanup
+echo nop > current_tracer
+echo > set_ftrace_filter
+echo 0 > events/kprobes/testprobe/enable
+echo > kprobe_events
+echo > trace
-- 
1.8.5.5

