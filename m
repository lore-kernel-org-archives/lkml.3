Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbaJAWIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 18:08:48 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:46497 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbaJAWIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 18:08:47 -0400
Message-ID: <542C7B5E.2020000@oracle.com>
Date: Wed, 01 Oct 2014 18:08:30 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>
CC: Dave Jones <davej@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Michel Lespinasse <walken@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: pipe/page fault oddness.
References: <20140930033327.GA14558@redhat.com>	<CA+55aFwmo7ot=h7tpUYhSC49CHKBK2KfGaDJ_fwB0=VNqvTPBQ@mail.gmail.com>	<20140930043309.GA16196@redhat.com>	<CA+55aFwxdOBKHwwp7Zq1k19mHCyHYmYqigCVt59AtB-P7Zva1w@mail.gmail.com>	<CA+55aFynr-Abo_JY1=GGOf9e2tjJvexbX2kVTgD0bkq7BXacJw@mail.gmail.com>	<20140930160510.GA15903@redhat.com>	<CA+55aFzTEXxxh_4_BwVydw1UgCu-NRF95OrzVhj=cievXFTJTg@mail.gmail.com>	<20140930162201.GC15903@redhat.com>	<20140930164047.GA18354@redhat.com>	<CA+55aFzKgJ41Mp=Ub8Kq_uFDHYzkHo3zhO3MHOJo_O2iExdYmQ@mail.gmail.com>	<20140930182059.GA24431@redhat.com>	<CA+55aFzfvXHd2LUhQ5OiV1H1Oq2y3PL8hX_Hrv-C907PyDNugA@mail.gmail.com>	<alpine.LSU.2.11.1410010031070.1902@eggly.anvils>	<CA+55aFyJ09+iv2HX1nfAaDi0-7=L3KxKi11CACbM8K_Coo6kzg@mail.gmail.com>	<CA+55aFzHgemAV7igyG=0pmctTaV7cZfO4fdqukhrCc8VXTrZuw@mail.gmail.com> <CA+55aFzisEwtcBA93Xo74RM-6X9V=_go=YhN7eFJOHLeHs3HEQ@mail.gmail.com>
In-Reply-To: <CA+55aFzisEwtcBA93Xo74RM-6X9V=_go=YhN7eFJOHLeHs3HEQ@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2014 04:20 PM, Linus Torvalds wrote:
> So I'm really sending this patch out in the hope that it will get
> comments, fixup and possibly even testing by people who actually know
> the NUMA balancing code. Rik?  Anybody?

Hi Linus,

I've tried this patch on the same configuration that was triggering
the VM_BUG_ON that Hugh mentioned previously. Surprisingly enough it
ran fine for ~20 minutes before exploding with:

[ 2781.566206] kernel BUG at mm/huge_memory.c:1293!
[ 2781.566953] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[ 2781.568054] Dumping ftrace buffer:
[ 2781.568826]    (ftrace buffer empty)
[ 2781.569392] Modules linked in:
[ 2781.569909] CPU: 61 PID: 13111 Comm: trinity-c61 Not tainted 3.17.0-rc7-sasha-00040-g65e1cb2 #1259
[ 2781.571077] task: ffff88050ba80000 ti: ffff880418ecc000 task.ti: ffff880418ecc000
[ 2781.571077] RIP: do_huge_pmd_numa_page (mm/huge_memory.c:1293 (discriminator 1))
[ 2781.571077] RSP: 0000:ffff880418ecfc60  EFLAGS: 00010246
[ 2781.571077] RAX: ffffea0074c60000 RBX: ffffea0074c60000 RCX: 0000001d318009e0
[ 2781.571077] RDX: ffffea0000000000 RSI: ffffffffb5706ef3 RDI: 0000001d318009e0
[ 2781.571077] RBP: ffff880418ecfcc8 R08: 0000000000000038 R09: 0000000000000001
[ 2781.571077] R10: 0000000000000038 R11: 0000000000000001 R12: ffff8804f9b52000
[ 2781.571077] R13: 0000001d318009e0 R14: ffff880508a1f840 R15: 0000000000000028
[ 2781.571077] FS:  00007f5502fc9700(0000) GS:ffff881d77e00000(0000) knlGS:0000000000000000
[ 2781.571077] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2781.571077] CR2: 0000000000000000 CR3: 00000004bfac4000 CR4: 00000000000006a0
[ 2781.571077] Stack:
[ 2781.571077]  ffff880418ecfc98 0000000000000282 ffff88050ba80000 000000000000000b
[ 2781.571077]  ffff88060d2ab000 ffff88060000001d 0000000000000000 ffff881d30b3ec00
[ 2781.571077]  0000000000000000 ffff881d30b3ec00 ffff88060d2ab000 0000000000000100
[ 2781.571077] Call Trace:
[ 2781.571077] handle_mm_fault (mm/memory.c:3304 mm/memory.c:3368)
[ 2781.571077] __do_page_fault (arch/x86/mm/fault.c:1231)
[ 2781.571077] ? kvm_clock_read (./arch/x86/include/asm/preempt.h:90 arch/x86/kernel/kvmclock.c:86)
[ 2781.571077] ? sched_clock (./arch/x86/include/asm/paravirt.h:192 arch/x86/kernel/tsc.c:304)
[ 2781.571077] ? sched_clock_local (kernel/sched/clock.c:214)
[ 2781.571077] ? context_tracking_user_exit (kernel/context_tracking.c:184)
[ 2781.571077] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
[ 2781.571077] ? trace_hardirqs_off_caller (kernel/locking/lockdep.c:2641 (discriminator 8))
[ 2781.571077] trace_do_page_fault (arch/x86/mm/fault.c:1314 include/linux/jump_label.h:115 include/linux/context_tracking_state.h:27 include/linux/context_tracking.h:45 arch/x86/mm/fault.c:1315)
[ 2781.571077] do_async_page_fault (arch/x86/kernel/kvm.c:279)
[ 2781.571077] async_page_fault (arch/x86/kernel/entry_64.S:1314)
[ 2781.571077] ? copy_user_generic_unrolled (arch/x86/lib/copy_user_64.S:166)
[ 2781.571077] ? sys32_mmap (arch/x86/ia32/sys_ia32.c:159)
[ 2781.571077] ia32_do_call (arch/x86/ia32/ia32entry.S:430)
[ 2781.571077] Code: b4 eb e0 0f 1f 84 00 00 00 00 00 4c 89 f7 e8 88 2f 0c 03 48 8b 45 d0 4c 89 e6 48 8b b8 88 00 00 00 e8 85 c7 ff ff e9 90 fe ff ff <0f> 0b 66 0f 1f 44 00 00 48 89 df e8 90 e9 f9 ff 84 c0 0f 85 be
All code
========
   0:	b4 eb                	mov    $0xeb,%ah
   2:	e0 0f                	loopne 0x13
   4:	1f                   	(bad)
   5:	84 00                	test   %al,(%rax)
   7:	00 00                	add    %al,(%rax)
   9:	00 00                	add    %al,(%rax)
   b:	4c 89 f7             	mov    %r14,%rdi
   e:	e8 88 2f 0c 03       	callq  0x30c2f9b
  13:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  17:	4c 89 e6             	mov    %r12,%rsi
  1a:	48 8b b8 88 00 00 00 	mov    0x88(%rax),%rdi
  21:	e8 85 c7 ff ff       	callq  0xffffffffffffc7ab
  26:	e9 90 fe ff ff       	jmpq   0xfffffffffffffebb
  2b:*	0f 0b                	ud2    		<-- trapping instruction
  2d:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  33:	48 89 df             	mov    %rbx,%rdi
  36:	e8 90 e9 f9 ff       	callq  0xfffffffffff9e9cb
  3b:	84 c0                	test   %al,%al
  3d:	0f                   	.byte 0xf
  3e:	85                   	.byte 0x85
  3f:	be                   	.byte 0xbe
	...

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2
   2:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
   8:	48 89 df             	mov    %rbx,%rdi
   b:	e8 90 e9 f9 ff       	callq  0xfffffffffff9e9a0
  10:	84 c0                	test   %al,%al
  12:	0f                   	.byte 0xf
  13:	85                   	.byte 0x85
  14:	be                   	.byte 0xbe
	...
[ 2781.571077] RIP do_huge_pmd_numa_page (mm/huge_memory.c:1293 (discriminator 1))
[ 2781.571077]  RSP <ffff880418ecfc60>


Thanks,
Sasha
