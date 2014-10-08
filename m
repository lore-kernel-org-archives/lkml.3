Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494AbaJHEDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 00:03:19 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:36658 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186AbaJHEDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 00:03:18 -0400
Subject: [PATCH ftrace/for-next V2] tracing/kprobes: Add selftest scripts
 testing kprobe-tracer as startup test
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Shuah Khan <shuah.kh@samsung.com>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 08 Oct 2014 04:03:07 +0000
Message-ID: <20141008040307.13415.45145.stgit@kbuild-f20.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add two selftest scripts which tests kprobe-tracer as the startup
selftest does.
These test cases are testing that the kprobe_event can accept a
kprobe event with $stack related arguments and a kretprobe event
with $retval argument.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 .../selftests/ftrace/test.d/kprobe/kprobe_args.tc  |   16 ++++++++++++++++
 .../ftrace/test.d/kprobe/kretprobe_args.tc         |   15 +++++++++++++++
 2 files changed, 31 insertions(+)
 create mode 100644 tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc

diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc
new file mode 100644
index 0000000..a603d3f
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc
@@ -0,0 +1,16 @@
+#!/bin/sh
+# description: Kprobe dynamic event with arguments
+
+[ -f kprobe_events ] || exit_unsupported # this is configurable
+
+echo 0 > events/enable
+echo > kprobe_events
+echo 'p:testprobe do_fork $stack $stack0 +0($stack)' > kprobe_events
+grep testprobe kprobe_events
+test -d events/kprobes/testprobe
+echo 1 > events/kprobes/testprobe/enable
+( echo "forked")
+echo 0 > events/kprobes/testprobe/enable
+echo "-:testprobe" >> kprobe_events
+test -d events/kprobes/testprobe && exit 1 || exit 0
+
diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc
new file mode 100644
index 0000000..283c29e
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc
@@ -0,0 +1,15 @@
+#!/bin/sh
+# description: Kretprobe dynamic event with arguments
+
+[ -f kprobe_events ] || exit_unsupported # this is configurable
+
+echo 0 > events/enable
+echo > kprobe_events
+echo 'r:testprobe2 do_fork $retval' > kprobe_events
+grep testprobe2 kprobe_events
+test -d events/kprobes/testprobe2
+echo 1 > events/kprobes/testprobe2/enable
+( echo "forked")
+echo 0 > events/kprobes/testprobe2/enable
+echo '-:testprobe2' >> kprobe_events
+test -d events/kprobes/testprobe2 && exit 1 || exit 0


