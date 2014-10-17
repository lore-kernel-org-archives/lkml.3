Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbaJQITb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 04:19:31 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:34149 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279AbaJQIT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 04:19:27 -0400
Date: Fri, 17 Oct 2014 10:19:21 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] s390 vs. kprobes on ftrace
Message-ID: <20141017081921.GA18203@osiris>
References: <1413387978-984-1-git-send-email-heiko.carstens@de.ibm.com>
 <543F5C84.7090005@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543F5C84.7090005@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14101708-0025-0000-0000-000001ED2785
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 02:49:56PM +0900, Masami Hiramatsu wrote:
> Hi Heiko,
> 
> (2014/10/16 0:46), Heiko Carstens wrote:
> > Hi all,
> > 
> > we would like to implement an architecture specific variant of "kprobes
> > on ftrace" without using the current HAVE_KPROBES_ON_FTRACE infrastructure
> > which is currently only used by x86.

[...]

> I'm not sure about s390 nor have the machine, so it is very helpful if you
> give us a command line level test and show us the result with this patch :)
> Fortunately, we already have ftracetest under tools/tesitng/selftest/ftrace/.
> You can add the testcase for checking co-existence of kprobes and ftrace on
> an entry of a function.

So how about something like below?

>From e7ba7796bfc7179aad1c612571d330cae4c048b7 Mon Sep 17 00:00:00 2001
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Fri, 17 Oct 2014 10:01:03 +0200
Subject: [PATCH] ftracetest: add kprobes on ftrace testcase

Add a kprobes on ftrace testcase. The testcase verifies that
- enabling and disabling function tracing works on a function which
  already contains a dynamic kprobe
- adding and removing a dynamic kprobe works on a function which is
  already enabled for function tracing

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 .../ftrace/test.d/kprobe/kprobe_ftrace.tc          | 56 ++++++++++++++++++++++
 1 file changed, 56 insertions(+)
 create mode 100644 tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc

diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc
new file mode 100644
index 000000000000..4ddd18054fda
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc
@@ -0,0 +1,56 @@
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
+echo > trace
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

