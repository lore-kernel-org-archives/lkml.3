Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaANUsW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 15:48:22 -0500
Received: from mail.windriver.com ([147.11.1.11]:54020 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbaANUsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 15:48:19 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 0/3] kernel/mm -- audit/fix core code using module_init
Date: Tue, 14 Jan 2014 15:44:45 -0500
Message-ID: <1389732288-4389-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series had an interesting genesis in chain on effects, typical 
of how things can creep and spill over.

I wanted to clobber pointless instances of #include <linux/init.h>
mostly left behind from __cpuinit and __devinit removal.  But to
fully complete that, I had to plan to move module_init into module.h;
which meant to get rid of the non-modular callers of module_init().

But I couldn't replace them with the 1:1 mapping to __initcall(),
because we aren't supposed to use that anymore.  And finally, I
couldn't just use the 1:1 mapping of __initcall to device_initcall(),
because it looks like crap to be using device_initcall in what is
clearly not device/driver code.  And hence we end up being faced with
checking and/or changing initcall ordering.

Here we fix up kernel/ and mm/ -- the one point of interest was
uncovering an oops when trying to make ksm_init a subsys_initcall,
which in turn led to the 1st patch in the series, which reprioritized
creation of the mm_kobj.

There are other __initcall in mm/ that we probably want to look at
and reprioritize in the future.  But for now I just fixed the one that
was obviously problematic and blocking the other required priority
changes in ksm.c and huge_memory.c

Boot tested on today's master, with x86-32 and powerpc (sbc8548).

For completeness, here is what happens when one tries to make ksm_init
as subsys_initcall, if the mm_kobj is created too late in device_initcall.

Paul.

------------[ cut here ]------------
kernel BUG at fs/sysfs/group.c:94!
invalid opcode: 0000 [#1] SMP
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.13.0-rc8+ #12
Hardware name: Dell Computer Corporation OptiPlex GX270               /0Y1057, BIOS A07 06/26/2006
task: f5860000 ti: f5846000 task.ti: f5846000
EIP: 0060:[<c11884d4>] EFLAGS: 00010246 CPU: 0
EIP is at internal_create_group+0x244/0x270
EAX: 00000000 EBX: c199e5c9 ECX: c1929f60 EDX: 00000000
ESI: f59947c0 EDI: 00000000 EBP: f5847ed8 ESP: f5847ea4
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: ffe14000 CR3: 01a2b000 CR4: 000007d0
Stack:
 f59947c0 f5847ed4 c106fdfb 00000000 34561000 00000000 00000000 00000000
 c1929f60 f59947c0 c199e5c9 f59947c0 00000000 f5847ee0 c118852c f5847f00
 c199e68c c111cde0 00000000 ffffffff c1856da4 c199e5c9 00000004 f5847f70
Call Trace:
 [<c106fdfb>] ? try_to_wake_up+0x18b/0x230
 [<c199e5c9>] ? procswaps_init+0x27/0x27
 [<c118852c>] sysfs_create_group+0xc/0x10
 [<c199e68c>] ksm_init+0xc3/0x15b
 [<c111cde0>] ? run_store+0x2b0/0x2b0
 [<c199e5c9>] ? procswaps_init+0x27/0x27
 [<c10004b2>] do_one_initcall+0xe2/0x140
 [<c1061463>] ? parameq+0x13/0x70
 [<c197e4cc>] ? do_early_param+0x7a/0x7a
 [<c1061699>] ? parse_args+0x1d9/0x340
 [<c107c6a0>] ? __wake_up+0x40/0x50
 [<c197eb73>] kernel_init_freeable+0x129/0x1cd
 [<c197e4cc>] ? do_early_param+0x7a/0x7a
 [<c16bd19b>] kernel_init+0xb/0x100
 [<c16d44b7>] ret_from_kernel_thread+0x1b/0x28
 [<c16bd190>] ? rest_init+0x60/0x60

---

Paul Gortmaker (3):
  mm: make creation of the mm_kobj happen earlier than device_initcall
  kernel: audit/fix non-modular users of module_init in core code
  mm: audit/fix non-modular users of module_init in core code

 kernel/hung_task.c      | 3 +--
 kernel/kexec.c          | 4 ++--
 kernel/profile.c        | 2 +-
 kernel/sched/stats.c    | 2 +-
 kernel/user.c           | 3 +--
 kernel/user_namespace.c | 2 +-
 mm/huge_memory.c        | 2 +-
 mm/ksm.c                | 2 +-
 mm/mm_init.c            | 3 +--
 mm/mmap.c               | 6 +++---
 mm/mmu_notifier.c       | 3 +--
 11 files changed, 14 insertions(+), 18 deletions(-)

-- 
1.8.5.2

