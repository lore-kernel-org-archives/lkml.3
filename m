Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966257AbaFSVj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:39:58 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:59802 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965317AbaFSVjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:39:54 -0400
Message-Id: <20140619213329.478113470@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 19 Jun 2014 17:33:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Jan Kara <jack@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>, Petr Mladek <pmladek@suse.cz>
Subject: [RFC][PATCH 0/3] x86/nmi: Print all cpu stacks from NMI safely
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is my proposal to print the NMI stack traces from an RCU stall safely.
Here's the gist of it.

Patch 1: move the trace_seq out of the tracing code. It's useful for other
 purposes too. Like writing from an NMI context.

Patch 2: Add a per_cpu "printk_func" that printk calls. By default it calls
 vprintk_def() which does what it has always done. This allows us to
 override what printk() calls normally on a per cpu basis.

Patch 3: Have the NMI handler that dumps the stack trace just change the
 printk_func to call a NMI safe printk function that writes to a per cpu
 trace_seq. When all NMI handlers chimed in, the original caller prints
 out the trace_seqs for each CPU from a printk safe context.

This is much less intrusive than the other versions out there.

Note, The biggest change was the moving of trace_seq code out of trace_output.c
and into the new trace_seq.c library.

Thoughts?


Steven Rostedt (Red Hat) (3):
      trace_seq: Move the trace_seq code to lib/
      printk: Add per_cpu printk func to allow printk to be diverted
      x86/nmi: Perform a safe NMI stack trace on all CPUs

----
 arch/x86/kernel/apic/hw_nmi.c |  66 ++++++++-
 include/linux/percpu.h        |   3 +
 include/linux/printk.h        |   2 +
 include/linux/trace_seq.h     |  68 ++--------
 kernel/printk/printk.c        |  38 ++++--
 kernel/trace/trace.c          |  24 ----
 kernel/trace/trace_output.c   | 268 -------------------------------------
 kernel/trace/trace_output.h   |  16 ---
 lib/Makefile                  |   2 +-
 lib/trace_seq.c               | 303 ++++++++++++++++++++++++++++++++++++++++++
 10 files changed, 412 insertions(+), 378 deletions(-)
