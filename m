Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762895Ab3DCRuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 13:50:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762748Ab3DCRui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 13:50:38 -0400
Date: Wed, 3 Apr 2013 19:45:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: Re: [PATCH v1 0/9] uretprobes: Return uprobes implementation
Message-ID: <20130403174552.GA9984@redhat.com>
References: <1365004839-21982-1-git-send-email-anton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365004839-21982-1-git-send-email-anton@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03, Anton Arapov wrote:
>
> Anton Arapov (9):
>   uretprobes: Introduce uprobe_consumer->ret_handler()
>   uretprobes: Reserve the first slot in xol_vma for trampoline
>   uretprobes/x86: Hijack return address
>   uretprobes/ppc: Hijack return address
>   uretprobes: Return probe entry, prepare_uretprobe()
>   uretprobes: Return probe exit, invoke handlers
>   uretprobes: Limit the depth of return probe nestedness
>   uretprobes: Remove -ENOSYS as return probes implemented
>   uretprobes: Documentation update
>
>  Documentation/trace/uprobetracer.txt | 126 +++++++++++++---------
>  arch/powerpc/include/asm/uprobes.h   |   1 +
>  arch/powerpc/kernel/uprobes.c        |  13 +++
>  arch/x86/include/asm/uprobes.h       |   1 +
>  arch/x86/kernel/uprobes.c            |  29 +++++
>  include/linux/uprobes.h              |   7 ++
>  kernel/events/uprobes.c              | 202 +++++++++++++++++++++++++++++++++--
>  7 files changed, 320 insertions(+), 59 deletions(-)

Looks fine to me. I am going to add this to
git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc uprobes/core

Ananth. "4/9 uretprobes/ppc" looks "obviously correct", but could you
please review and ack/nack ?

To remind, this series depends on other changes in uprobes core
and kernel/trace/trace_uprobe.c, please see the full stat below.

I'll wait for the comments a bit, after that I'll ask Ingo to
pull if nobody objects.

Anton Arapov (9):
      uretprobes: Introduce uprobe_consumer->ret_handler()
      uretprobes: Reserve the first slot in xol_vma for trampoline
      uretprobes/x86: Hijack return address
      uretprobes/ppc: Hijack return address
      uretprobes: Return probe entry, prepare_uretprobe()
      uretprobes: Return probe exit, invoke handlers
      uretprobes: Limit the depth of return probe nestedness
      uretprobes: Remove -ENOSYS as return probes implemented
      uretprobes: Documentation update

Oleg Nesterov (15):
      uprobes: Turn copy_opcode() into copy_from_page()
      uprobes: Change __copy_insn() to use copy_from_page()
      uprobes: Kill the unnecesary filp != NULL check in __copy_insn()
      uprobes: Introduce copy_to_page()
      uprobes: Change write_opcode() to use copy_*page()
      uprobes/tracing: Kill the pointless task_pt_regs() calls
      uprobes/tracing: Kill the pointless seq_print_ip_sym() call
      uprobes/tracing: Kill the pointless local_save_flags/preempt_count calls
      uprobes/tracing: Generalize struct uprobe_trace_entry_head
      uprobes/tracing: Introduce uprobe_{trace,perf}_print() helpers
      uprobes/tracing: Introduce is_ret_probe() and uretprobe_dispatcher()
      uprobes/tracing: Make uprobe_{trace,perf}_print() uretprobe-friendly
      uprobes/tracing: Make register_uprobe_event() paths uretprobe-friendly
      uprobes/tracing: Make seq_printf() code uretprobe-friendly
      uprobes/tracing: Change create_trace_uprobe() to support uretprobes

 Documentation/trace/uprobetracer.txt |  114 +++++++++-------
 arch/powerpc/include/asm/uprobes.h   |    1 +
 arch/powerpc/kernel/uprobes.c        |   13 ++
 arch/x86/include/asm/uprobes.h       |    1 +
 arch/x86/kernel/uprobes.c            |   29 ++++
 include/linux/uprobes.h              |    7 +
 kernel/events/uprobes.c              |  251 ++++++++++++++++++++++++++++------
 kernel/trace/trace.h                 |    5 -
 kernel/trace/trace_uprobe.c          |  205 ++++++++++++++++++++--------
 9 files changed, 480 insertions(+), 146 deletions(-)

