Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab3BKJoE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 04:44:04 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:60224 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab3BKJoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 04:44:01 -0500
Date: Mon, 11 Feb 2013 10:43:57 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Arapov <anton@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frank Eigler <fche@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] uprobes/perf: pre-filtering
Message-ID: <20130211094357.GE23932@gmail.com>
References: <20130208180348.GA11280@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130208180348.GA11280@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> OK, nobody has comments. Ingo, please pull from
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc uprobes/core
> 
> Changes:
> 	- fix the conflict with d24d7dbf which added the (unsafe) check
> 	  into create_trace_uprobe()
> 
> 	- drop "Kill the "uprobe != NULL" check in uprobe_unregister()",
> 	  the same patch from Sasha Levin was already applied as c91368c4
> 
> 	- drop "perf: Ensure we do not free event->parent before event"
> 	  http://marc.info/?l=linux-kernel&m=136000475509419
> 
> 	  Currently it is not necessary and it wasn't reviewed. But perhaps
> 	  I'll resend it later.
> 
> Simple performance test:
> 
> 	# time perl -e 'syscall -1 for 1..100_000'
> 	real    0m0.040s
> 	user    0m0.027s
> 	sys     0m0.010s
> 	
> 	# perf probe -x /lib/libc.so.6 syscall
> 	# perf record -e probe_libc:syscall sleep 100 &
> 
> Before this series:
> 
> 	# time perl -e 'syscall -1 for 1..100_000'
> 	real    0m1.714s
> 	user    0m0.103s
> 	sys     0m1.607s
> 
> After:
> 	real    0m0.037s
> 	user    0m0.013s
> 	sys	0m0.023s
> 
> The untraced process is not penalized.
> 
> Josh Stone (1):
>       uprobes: Add exports for module use
> 
> Oleg Nesterov (37):
>       uprobes: Move __set_bit(UPROBE_SKIP_SSTEP) into alloc_uprobe()
>       uprobes: Kill the pointless inode/uc checks in register/unregister
>       uprobes: Kill uprobe_consumer->filter()
>       uprobes: Introduce filter_chain()
>       uprobes: _unregister() should always do register_for_each_vma(false)
>       uprobes: _register() should always do register_for_each_vma(true)
>       uprobes: Introduce uprobe->register_rwsem
>       uprobes: Change filter_chain() to iterate ->consumers list
>       uprobes: Kill UPROBE_RUN_HANDLER flag
>       uprobes: Kill uprobe->copy_mutex
>       uprobes: Kill uprobe_events, use RB_EMPTY_ROOT() instead
>       uprobes: Introduce uprobe_is_active()
>       uprobes: Kill uprobes_mutex[], separate alloc_uprobe() and __uprobe_register()
>       uprobes: Rationalize the usage of filter_chain()
>       uprobes: Reintroduce uprobe_consumer->filter()
>       uprobes: Teach handler_chain() to filter out the probed task
>       uprobes/x86: Change __skip_sstep() to actually skip the whole insn
>       uprobes: Change handle_swbp() to expose bp_vaddr to handler_chain()
>       uprobes: Move alloc_page() from xol_add_vma() to xol_alloc_area()
>       uprobes: Fold xol_alloc_area() into get_xol_area()
>       uprobes: Turn add_utask() into get_utask()
>       uprobes: Do not play with utask in xol_get_insn_slot()
>       uprobes: Fix utask->xol_vaddr leak in pre_ssout()
>       uprobes: Do not allocate current->utask unnecessary
>       uprobes: Kill the bogus IS_ERR_VALUE(xol_vaddr) check
>       uprobes/tracing: Fix dentry/mount leak in create_trace_uprobe()
>       uprobes/tracing: Fully initialize uprobe_trace_consumer before uprobe_register()
>       uprobes/tracing: Ensure inode != NULL in create_trace_uprobe()
>       uprobes/tracing: Introduce is_trace_uprobe_enabled()
>       uprobes/tracing: Kill uprobe_trace_consumer, embed uprobe_consumer into trace_uprobe
>       uprobes/perf: Always increment trace_uprobe->nhit
>       perf: Introduce hw_perf_event->tp_target and ->tp_list
>       uprobes: Introduce uprobe_apply()
>       uprobes/perf: Teach trace_uprobe/perf code to track the active perf_event's
>       uprobes/perf: Teach trace_uprobe/perf code to pre-filter
>       uprobes/perf: Teach trace_uprobe/perf code to use UPROBE_HANDLER_REMOVE
>       uprobes/perf: Avoid uprobe_apply() whenever possible
> 
>  arch/x86/kernel/uprobes.c   |    4 +-
>  include/linux/perf_event.h  |    9 +-
>  include/linux/uprobes.h     |   23 ++-
>  kernel/events/core.c        |    5 +-
>  kernel/events/uprobes.c     |  465 +++++++++++++++++++++++--------------------
>  kernel/ptrace.c             |    6 +
>  kernel/trace/trace_probe.h  |    1 -
>  kernel/trace/trace_uprobe.c |  217 +++++++++++++++-----
>  8 files changed, 456 insertions(+), 274 deletions(-)

Pulled, thanks a lot Oleg!

	Ingo
