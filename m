Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbaJHSF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 14:05:26 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:14662 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752503AbaJHSFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 14:05:19 -0400
Message-Id: <20141008180518.380312567@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 08 Oct 2014 14:03:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5/5] tracing/kprobes: Add selftest scripts testing kprobe-tracer as
 startup test
References: <20141008180341.252728944@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0005-tracing-kprobes-Add-selftest-scripts-testing-kprobe-.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Add two selftest scripts which tests kprobe-tracer as the startup
selftest does.
These test cases are testing that the kprobe_event can accept a
kprobe event with $stack related arguments and a kretprobe event
with $retval argument.

Link: http://lkml.kernel.org/p/20141008040307.13415.45145.stgit@kbuild-f20.novalocal

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 .../selftests/ftrace/test.d/kprobe/kprobe_args.tc        | 16 ++++++++++++++++
 .../selftests/ftrace/test.d/kprobe/kretprobe_args.tc     | 15 +++++++++++++++
 2 files changed, 31 insertions(+)
 create mode 100644 tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc

diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc
new file mode 100644
index 000000000000..a603d3f8db7b
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
index 000000000000..283c29e7f7c4
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
-- 
2.0.1


