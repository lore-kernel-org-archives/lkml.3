Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab3IJNWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 09:22:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46867 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab3IJNV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 09:21:27 -0400
Message-Id: <20130910130811.507933095@infradead.org>
User-Agent: quilt/0.60-1
Date: Tue, 10 Sep 2013 15:08:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 0/7] preempt_count rework -v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches optimize preempt_enable by firstly folding the preempt and
need_resched tests into one -- this should work for all architectures. And
secondly by providing per-arch preempt_count implementations; with x86 using
per-cpu preempt_count for fastest access.


These patches have been boot tested on CONFIG_PREEMPT=y x86_64 and survive
building a x86_64-defconfig kernel.

kernel/sched/core.c:kick_process() now looks like:

  ffffffff8106f3f0 <kick_process>:
  ffffffff8106f3f0:       55                      push   %rbp
  ffffffff8106f3f1:       65 ff 04 25 e0 b7 00    incl   %gs:0xb7e0
  ffffffff8106f3f8:       00 
  ffffffff8106f3f9:       48 89 e5                mov    %rsp,%rbp
  ffffffff8106f3fc:       48 8b 47 08             mov    0x8(%rdi),%rax
  ffffffff8106f400:       8b 50 18                mov    0x18(%rax),%edx
  ffffffff8106f403:       65 8b 04 25 1c b0 00    mov    %gs:0xb01c,%eax
  ffffffff8106f40a:       00 
  ffffffff8106f40b:       39 c2                   cmp    %eax,%edx
  ffffffff8106f40d:       74 1b                   je     ffffffff8106f42a <kick_process+0x3a>
  ffffffff8106f40f:       89 d1                   mov    %edx,%ecx
  ffffffff8106f411:       48 c7 c0 00 2c 01 00    mov    $0x12c00,%rax
  ffffffff8106f418:       48 8b 0c cd a0 bc cb    mov    -0x7e344360(,%rcx,8),%rcx
  ffffffff8106f41f:       81 
  ffffffff8106f420:       48 3b bc 08 00 08 00    cmp    0x800(%rax,%rcx,1),%rdi
  ffffffff8106f427:       00 
  ffffffff8106f428:       74 1e                   je     ffffffff8106f448 <kick_process+0x58>
* ffffffff8106f42a:       65 ff 0c 25 e0 b7 00    decl   %gs:0xb7e0
  ffffffff8106f431:       00 
* ffffffff8106f432:       0f 94 c0                sete   %al
* ffffffff8106f435:       84 c0                   test   %al,%al
* ffffffff8106f437:       75 02                   jne    ffffffff8106f43b <kick_process+0x4b>
  ffffffff8106f439:       5d                      pop    %rbp
  ffffffff8106f43a:       c3                      retq   
* ffffffff8106f43b:       e8 b0 b6 f9 ff          callq  ffffffff8100aaf0 <___preempt_schedule>
  ffffffff8106f440:       5d                      pop    %rbp
  ffffffff8106f441:       c3                      retq   
  ffffffff8106f442:       66 0f 1f 44 00 00       nopw   0x0(%rax,%rax,1)
  ffffffff8106f448:       89 d7                   mov    %edx,%edi
  ffffffff8106f44a:       66 0f 1f 44 00 00       nopw   0x0(%rax,%rax,1)
  ffffffff8106f450:       ff 15 ea e0 ba 00       callq  *0xbae0ea(%rip)        # ffffffff81c1d540 <smp_ops+0x20>
  ffffffff8106f456:       eb d2                   jmp    ffffffff8106f42a <kick_process+0x3a>
  ffffffff8106f458:       0f 1f 84 00 00 00 00    nopl   0x0(%rax,%rax,1)
  ffffffff8106f45f:       00 

Where the '*' marked lines are preempt_enable(), sadly GCC isn't able to get
rid of the sete+test :/ Its a rather frequent pattern in the kernel, so
'fixing' the x86 GCC backend to recognise this might be useful.


---
 arch/alpha/include/asm/Kbuild      |   1 +
 arch/arc/include/asm/Kbuild        |   1 +
 arch/arm/include/asm/Kbuild        |   1 +
 arch/arm64/include/asm/Kbuild      |   1 +
 arch/avr32/include/asm/Kbuild      |   1 +
 arch/blackfin/include/asm/Kbuild   |   1 +
 arch/c6x/include/asm/Kbuild        |   1 +
 arch/cris/include/asm/Kbuild       |   1 +
 arch/frv/include/asm/Kbuild        |   1 +
 arch/h8300/include/asm/Kbuild      |   1 +
 arch/hexagon/include/asm/Kbuild    |   1 +
 arch/ia64/include/asm/Kbuild       |   1 +
 arch/m32r/include/asm/Kbuild       |   1 +
 arch/m68k/include/asm/Kbuild       |   1 +
 arch/metag/include/asm/Kbuild      |   1 +
 arch/microblaze/include/asm/Kbuild |   1 +
 arch/mips/include/asm/Kbuild       |   1 +
 arch/mips/mm/init.c                |   5 +-
 arch/mn10300/include/asm/Kbuild    |   1 +
 arch/openrisc/include/asm/Kbuild   |   1 +
 arch/parisc/include/asm/Kbuild     |   1 +
 arch/powerpc/include/asm/Kbuild    |   1 +
 arch/s390/include/asm/Kbuild       |   1 +
 arch/score/include/asm/Kbuild      |   1 +
 arch/sh/include/asm/Kbuild         |   1 +
 arch/sparc/include/asm/Kbuild      |   1 +
 arch/tile/include/asm/Kbuild       |   1 +
 arch/um/include/asm/Kbuild         |   1 +
 arch/unicore32/include/asm/Kbuild  |   1 +
 arch/x86/include/asm/calling.h     |  50 +++++++++++++++++
 arch/x86/include/asm/thread_info.h |   5 +-
 arch/x86/kernel/Makefile           |   2 +
 arch/x86/kernel/asm-offsets.c      |   1 -
 arch/x86/kernel/cpu/common.c       |   5 ++
 arch/x86/kernel/entry_32.S         |   7 +--
 arch/x86/kernel/entry_64.S         |   4 +-
 arch/x86/kernel/process_32.c       |  10 ++++
 arch/x86/kernel/process_64.c       |  10 ++++
 arch/x86/kernel/traps.c            |   4 +-
 arch/xtensa/include/asm/Kbuild     |   1 +
 include/linux/hardirq.h            |   8 +--
 include/linux/preempt.h            | 112 +++++++++++++++++--------------------
 include/linux/sched.h              |   5 --
 include/linux/thread_info.h        |   1 +
 include/linux/uaccess.h            |   8 +--
 include/trace/events/sched.h       |   2 +-
 init/main.c                        |   2 +-
 kernel/context_tracking.c          |   4 +-
 kernel/cpu/idle.c                  |   7 +++
 kernel/sched/core.c                |  54 +++++++++---------
 kernel/softirq.c                   |  16 +++---
 kernel/timer.c                     |   8 +--
 lib/smp_processor_id.c             |   3 +-
 53 files changed, 226 insertions(+), 136 deletions(-)

