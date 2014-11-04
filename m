Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbaKDQCl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:02:41 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:49577 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754591AbaKDQCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:02:24 -0500
Message-Id: <20141104155237.228431433@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 04 Nov 2014 10:52:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC][PATCH 00/12 v3] seq-buf/x86/printk: Print all stacks from NMI safely
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is version 3:

This is my proposal to print the NMI stack traces from an RCU stall safely,
as well as from a sysrq-l.

Here's the gist of it.

 o Add a new layer to trace_seq called seq_buf, that the trace
   seq uses. The seq_buf is more generic, and does not supply its own
   buffer. The buffer must be supplied when initializing the seq_buf.
   Note, these patches may be going into 3.19. There's some places in
   the tracing code that I wanted to use a different size buffer
   but still needed trace_seq to have a pre-allocated buffer. Having
   this new layer will help me out.

   I also based this on seq_file, and ideally, I want to merge the code
   between seq_file.c and trace_seq.c, as they are very similar. I already
   have a working set of patches that do this, but will get seq_buf
   merged first.

 o Update the seq_buf code to be more like seq_file.

 o Move the seq_buf out of the tracing code. It's useful for other
   purposes too. Like writing from an NMI context, and for seq_file.

 o Add a per_cpu "printk_func" that printk calls. By default it calls
   vprintk_def() which does what it has always done. This allows us to
   override what printk() calls normally on a per cpu basis.

 o Have the NMI handler that dumps the stack trace just change the
   printk_func to call a NMI safe printk function that writes to a per cpu
   seq_buf. When all NMI handlers chimed in, the original caller prints
   out the seq_buf buffers for each CPU from a printk safe context.

Changes since V2:

- Mostly it was modifying seq_buf to be based on seq_file as there were
  some questions to the way seq_buf should work. Note, there's also a
  set of patches that are getting ready to remove the return value of
  the seq_printf() and friends to be void, so the seq_buf_printf() and
  friends return values can be ignored, because they will be void as well.
  but for now, they just match what seq_file does.

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

-- Steve

Steven Rostedt (Red Hat) (12):
      x86/kvm/tracing: Use helper function trace_seq_buffer_ptr()
      RAS/tracing: Use trace_seq_buffer_ptr() helper instead of open coded
      tracing: Create seq_buf layer in trace_seq
      tracing: Convert seq_buf_path() to be like seq_path()
      tracing: Convert seq_buf fields to be like seq_file fields
      tracing: Add a seq_buf_clear() helper and clear len and readpos in init
      tracing: Have seq_buf use full buffer
      tracing: Add seq_buf_get_buf() and seq_buf_commit() helper functions
      seq_buf: Move the seq_buf code to lib/
      seq-buf: Make seq_buf_bprintf() conditional on CONFIG_BINARY_PRINTF
      printk: Add per_cpu printk func to allow printk to be diverted
      x86/nmi: Perform a safe NMI stack trace on all CPUs

----
 arch/x86/kernel/apic/hw_nmi.c        |  90 ++++++++-
 arch/x86/kvm/mmutrace.h              |   4 +-
 drivers/firmware/efi/cper.c          |   2 +-
 include/linux/percpu.h               |   3 +
 include/linux/printk.h               |   2 +
 include/linux/seq_buf.h              | 120 ++++++++++++
 include/linux/trace_seq.h            |  10 +-
 kernel/printk/printk.c               |  38 +++-
 kernel/trace/trace.c                 |  39 ++--
 kernel/trace/trace_events.c          |   6 +-
 kernel/trace/trace_functions_graph.c |   6 +-
 kernel/trace/trace_seq.c             | 184 +++++++++----------
 lib/Makefile                         |   2 +-
 lib/seq_buf.c                        | 344 +++++++++++++++++++++++++++++++++++
 14 files changed, 707 insertions(+), 143 deletions(-)
