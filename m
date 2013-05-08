Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126Ab3EHVBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 17:01:49 -0400
Received: from relay1.sgi.com ([192.48.179.29]:36370 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932098Ab3EHVBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 17:01:47 -0400
Message-Id: <20130508210144.090393535@asylum.americas.sgi.com>
User-Agent: quilt/0.47-15.17.1
Date: Wed, 08 May 2013 16:01:03 -0500
From: athorlton@sgi.com
To: linux-kernel@vger.kernel.org
Cc: Alex Thorlton <athorlton@sgi.com>, Vineet Gupta <vgupta@synopsys.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Richard Kuo <rkuo@codeaurora.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Robin Holt <holt@sgi.com>
Subject: [patch 1/2] dump_stack: serialize the output from dump_stack()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix up issues with interspersed output from multiple
simultaneous calls to warn or dump_stack on multi-cpu systems.
References: <20130508210102.898396979@asylum.americas.sgi.com>
Content-Disposition: inline; filename=dump-stack-serialize.patch

This patch adds functionality to serialize the output from dump_stack() to 
avoid mangling of the output when dump_stack is called simultaneously from
multiple cpus.

Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Reported-by: Russ Anderson <rja@sgi.com>
Reviewed-by: Robin Holt <holt@sgi.com>
Signed-off-by: Alex Thorlton <athorlton@sgi.com>
---
The original discussion regarding this patch can be found in this thread:
[PATCH] x86: Avoid intermixing cpu dump_stack output on multi-processor systems

 lib/dump_stack.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- linux.orig/lib/dump_stack.c
+++ linux/lib/dump_stack.c
@@ -7,6 +7,8 @@
 #include <linux/export.h>
 #include <linux/sched.h>
 
+static atomic_t dump_lock = ATOMIC_INIT(-1);
+
 /**
  * dump_stack - dump the current task information and its stack trace
  *
@@ -14,7 +16,30 @@
  */
 void dump_stack(void)
 {
+	int was_locked;
+	int old;
+	int cpu;
+
+	preempt_disable();
+
+retry:
+	cpu = smp_processor_id();
+	old = atomic_cmpxchg(&dump_lock, -1, cpu);
+	if (old == -1) {
+		was_locked = 0;
+	} else if (old == cpu) {
+		was_locked = 1;
+	} else {
+		cpu_relax();
+		goto retry;
+	}
+
 	dump_stack_print_info(KERN_DEFAULT);
 	show_stack(NULL, NULL);
+
+	if (!was_locked)
+		atomic_set(&dump_lock, -1);
+
+	preempt_enable();
 }
 EXPORT_SYMBOL(dump_stack);

