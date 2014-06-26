Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbaFZWBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 18:01:32 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:39799 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751233AbaFZWBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 18:01:31 -0400
Message-Id: <20140626214901.596791200@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 26 Jun 2014 17:49:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Jan Kara <jack@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>, Petr Mladek <pmladek@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: [RFC][PATCH 0/5 v2] x86/nmi: Print all cpu stacks from NMI safely
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is version 2:

This is my proposal to print the NMI stack traces from an RCU stall safely.
Here's the gist of it.

Patch 1: add trace_seq_buffer_ptr() helper function to clean up
   open coded trace_seq code. This is already in my 3.17 queue.

Patch 2: Add a new layer to trace_seq called seq_buf, that the trace
   seq uses. The seq_buf is more generic, and does not supply its own
   buffer. The buffer must be supplied when initializing the seq_buf.
   Note, this patch too may be going into 3.17. There's some places in
   the tracing code that I wanted to use a different size buffer
   but still needed trace_seq to have a pre-allocated buffer. Having
   this new layer will help me out. I have not added this to 3.17 until
   I decide to make use of it.

Patch 3: move the seq_buf out of the tracing code. It's useful for other
 purposes too. Like writing from an NMI context.

Patch 4: Add a per_cpu "printk_func" that printk calls. By default it calls
 vprintk_def() which does what it has always done. This allows us to
 override what printk() calls normally on a per cpu basis.

Patch 5: Have the NMI handler that dumps the stack trace just change the
 printk_func to call a NMI safe printk function that writes to a per cpu
 seq_buf. When all NMI handlers chimed in, the original caller prints
 out the seq_buf buffers for each CPU from a printk safe context.

This is much less intrusive than the other versions out there.

Changes since V1:

- Note, I based this off of my 3.17 queue that already updated trace_seq
  with a lot of comments from Andrew Morton. His comments have already
  been incorporated into the trace_seq.c file. This patch set is on top
  of those.

- Added a change that is in my 3.17 queue that cleans up open coded
  calculations of the trace_seq buffer to get the current location of
  the buffer.

- Biggest change is the added seq_buf. I'm keeping trace_seq doing the
  stop everything once it fills up. But seq_buf will act more like other
  utilities, as it will return what I would have written, and fills
  up the buffer as much as it can. It sets an overflow flag to test to
  see if there wasn't enough buffer space.

- I updated the last patch to use the seq_buf instead of the trace_seq
  by using its own struct nmi_seq_buf that allocates the buffer used.
  I also made some updates from previous reviews like not stripping the
  log level from the NMI printks and just using it in the final output
  as well as adding more comments and fixing the "return true" on a void
  function.

Thoughts?


Steven Rostedt (Red Hat) (5):
      tracing: Add trace_seq_buffer_ptr() helper function
      tracing: Create seq_buf layer in trace_seq
      seq_buf: Move the seq_buf code to lib/
      printk: Add per_cpu printk func to allow printk to be diverted
      x86/nmi: Perform a safe NMI stack trace on all CPUs

----
 arch/x86/kernel/apic/hw_nmi.c        |  84 ++++++++-
 arch/x86/kvm/mmutrace.h              |   2 +-
 drivers/scsi/scsi_trace.c            |  16 +-
 include/linux/percpu.h               |   3 +
 include/linux/printk.h               |   2 +
 include/linux/seq_buf.h              |  58 ++++++
 include/linux/trace_seq.h            |  23 ++-
 kernel/printk/printk.c               |  38 +++-
 kernel/trace/Makefile                |   1 +
 kernel/trace/trace.c                 |  39 ++--
 kernel/trace/trace_events.c          |   6 +-
 kernel/trace/trace_functions_graph.c |   6 +-
 kernel/trace/trace_output.c          |  14 +-
 kernel/trace/trace_seq.c             | 184 +++++++++---------
 lib/Makefile                         |   2 +-
 lib/seq_buf.c                        | 348 +++++++++++++++++++++++++++++++++++
 lib/trace_seq.c                      | 303 ++++++++++++++++++++++++++++++
 17 files changed, 976 insertions(+), 153 deletions(-)
