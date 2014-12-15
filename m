Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbaLOPh7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:37:59 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:11840 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750911AbaLOPh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 10:37:56 -0500
Message-Id: <20141215153638.563024114@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 15 Dec 2014 10:36:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 0/2] [GIT PULL] tracing: Enable tracepoints early and allow printk to use them
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

As the merge window is still open, and this code was not as complex
as I thought it might be. I'm pushing this in now.

This will allow Thomas to debug his irq work for 3.20.

This adds two new features:

1) Allow traceopoints to be enabled right after mm_init(). By passing
in the trace_event= kernel command line parameter, tracepoints can be
enabled at boot up. For debugging things like the initialization of
interrupts, it is needed to have tracepoints enabled very early. People
have asked about this before and this has been on my todo list. As it
can be helpful for Thomas to debug his upcoming 3.20 IRQ work, I'm
pushing this now. This way he can add tracepoints into the IRQ set up
and have users enable them when things go wrong.

2) Have the tracepoints printed via printk() (the console) when they
are triggered. If the irq code locks up or reboots the box, having the
tracepoint output go into the kernel ring buffer is useless for
debugging. But being able to add the tp_printk kernel command line
option along with the trace_event= option will have these tracepoints
printed as they occur, and that can be really useful for debugging
early lock up or reboot problems.

This code is not that intrusive and it passed all my tests. Thomas tried
them out too and it works for his needs.

 Link: http://lkml.kernel.org/r/20141214201609.126831471@goodmis.org

Please pull the latest trace-3.19-2 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-3.19-2

Tag SHA1: 378ef8105fed2dd3299e3232ff3d365a7d9feac9
Head SHA1: 0daa2302968c13b657118d6ac92471f8fd2f3f28


Steven Rostedt (Red Hat) (2):
      tracing: Move enabling tracepoints to just after rcu_init()
      tracing: Add tp_printk cmdline to have tracepoints go to printk()

----
 Documentation/kernel-parameters.txt | 18 ++++++++++++++++
 include/linux/ftrace.h              |  7 +++++++
 init/main.c                         |  4 ++++
 kernel/sysctl.c                     |  7 +++++++
 kernel/trace/trace.c                | 25 +++++++++++++++++++++-
 kernel/trace/trace.h                | 14 +++++++++++++
 kernel/trace/trace_events.c         | 42 +++++++++++++++++++++++++++++++++++--
 kernel/trace/trace_syscalls.c       |  7 ++-----
 8 files changed, 116 insertions(+), 8 deletions(-)
