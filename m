Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985Ab3GMApv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 20:45:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3929 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757953Ab3GMApt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 20:45:49 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=P-lZ08kfo30A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=lTX6idhOm9sA:10 a=JfxD9Cd_A1ovyUqUvWcA:9 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130713004102.219523935@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 12 Jul 2013 20:41:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC][PATCH 0/4] rcu/tracing: Export the RCU tracepoint string pointers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has been on my todo list for a while. I've been promising Paul
to get a way to have his tracepoints work for user tools, and I finally
got around to it :-)

As his tracepoints just save a pointer to a string in the ring buffer
and have the output use that pointer with a "%s" printf field, which
works great in the kernel and is fast and efficient, it sucks for tools
that read the binary data from the kernel but has no access to the strings
that those pointers point to.

The trace_printk() had a similar problem when Frederic Weisbecker optimized
it to just save the pointer to the format string along with the parameters,
but that was solved by exporting a table of pointers with the strings
in the /sys/kernel/debug/tracing/printk_formats file.

I've done the same thing for tracepoints using a separate section but the
same file. I needed a seperate section as the trace_printk() section is
used to know if a trace_printk() was added to the kernel (they should
never be added to Linus's tree, unless its for a strict debugging option).
If a trace_printk() is used, several temporary buffers are allocated, which
we don't want in normal use.

Now tracepoints get a section that has the pointers to the strings and
this gets added to the printk_format file. Doing this means that none
of the tools (perf or trace-cmd) require any changes as they already
handle reading the printk_formats via the event_parse library.

-- Steve

Steven Rostedt (Red Hat) (4):
      rcu: Add const annotation to char * for RCU tracepoints and functions
      rcu: Simplify RCU_STATE_INITIALIZER() macro
      tracing: Add __tracepoint_string() to export string pointers
      rcu: Have the RCU tracepoints use the tracepoint_string infrastructure

----
 include/asm-generic/vmlinux.lds.h |    7 ++-
 include/linux/ftrace_event.h      |    7 +++
 include/linux/rcupdate.h          |    4 +-
 include/trace/events/rcu.h        |   82 +++++++++++++++---------------
 kernel/rcu.h                      |    2 +-
 kernel/rcupdate.c                 |    2 +-
 kernel/rcutiny_plugin.h           |    2 +-
 kernel/rcutorture.c               |   14 +++---
 kernel/rcutree.c                  |  100 +++++++++++++++++++++----------------
 kernel/rcutree.h                  |    2 +-
 kernel/rcutree_plugin.h           |   44 ++++++++--------
 kernel/trace/trace.h              |    3 ++
 kernel/trace/trace_printk.c       |    7 +++
 13 files changed, 154 insertions(+), 122 deletions(-)
