Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031AbaKSEz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 23:55:59 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:21180 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754238AbaKSEz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 23:55:57 -0500
Message-Id: <20141119043917.578498291@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 18 Nov 2014 23:39:17 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>
Subject: [RFC][PATCH 0/3] printk/seq-buf/NMI: Revisit of safe NMI printing with seq_buf code
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus and Andrew,

You were the ones that brought up issues with this change, so I want
to get your thoughts on it after we worked quite a bit to clean things up.

Here's where it all started:

 Link: http://lkml.kernel.org/r/20140619213329.478113470@goodmis.org

Linus,

You had issues with moving trace_seq.c to lib/ mainly due to the name
as it stopped having anything to do with tracing.

To fix that, I created a seq_buf.c code and converted trace_seq.c to
use it. seq_buf.c is a bit more generic than trace_seq, which has some
things that are hard coded to tracing. I restructured the code to
follow seq_file.c. In fact, to test this, I have a patch that converts
seq_file.c to use the seq_buf.c code just like trace_seq.c does, and
that will remove the duplicate code that both files are doing now.

But consolidating seq_file.c with trace_seq.c is not the reason for this
patch set, although I plan on doing that if this patch set gets in.
The reason for this patch set is to remove the race of performing a
printk() from NMI context. What it does instead is, each CPU that does
an NMI stack dump (sysrq-l) writes to a per_cpu seq_buf instead of
writing with printk(). Then the caller of the NMI stack dumps performs
the printk() using the data written in the seq_buf buffers.

This also makes doing an NMI stack dump with sysrq-l less intrusive on
the system as all CPUs no longer have to wait for all other CPUs to
finish printing.

It also solves the problem of deadlocking the system if the NMI stack
trace happens on a CPU that is currently doing a printk.

Andrew,

I incorporated all your comments from last time and did even more.
I based the seq-buf code off of the seq_file code as I stated previously
and made it much more generic. Well, it works for seq_file just as well
as it works for trace_seq and the NMI printing code.

What are your thoughts on this? Can I go ahead and include this in
my queue for 3.19?

I have a bunch of changes to trace_seq queued already, but I left out 
the creation of seq_buf until I get an OK for these final patches. I don't
want to make a generic seq_buf if trace_seq is the only one that is
going to use it.


Then there's the other two patches as well.

The second patch creates a per_cpu function hook that allows one to override
what printk does. This lets me set the NMI handler to make printk temporarily
point to the seq_buf functions such that the dump_stack() code writes to
the seq_buf instead of doing the printk().

The third patch is what implements the NMI code to use seq_buf.

Let me know what you think.


Thanks!

-- Steve

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
rfc/seq-buf

Head SHA1: 948a6c8fbca4d96a8c4938ba28bd9c983df14eda


Steven Rostedt (Red Hat) (3):
      seq_buf: Move the seq_buf code to lib/
      printk: Add per_cpu printk func to allow printk to be diverted
      x86/nmi: Perform a safe NMI stack trace on all CPUs

----
 arch/x86/kernel/apic/hw_nmi.c |  91 ++++++++++-
 include/linux/percpu.h        |   3 +
 include/linux/printk.h        |   2 +
 kernel/printk/printk.c        |  38 +++--
 kernel/trace/Makefile         |   1 -
 kernel/trace/seq_buf.c        | 359 ------------------------------------------
 lib/Makefile                  |   2 +-
 lib/seq_buf.c                 | 359 ++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 480 insertions(+), 375 deletions(-)
