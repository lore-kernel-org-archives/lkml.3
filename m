Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbaE2CcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 22:32:23 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:49787 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384AbaE2CcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 22:32:22 -0400
Message-ID: <53869C0A.3020400@oracle.com>
Date: Wed, 28 May 2014 22:31:38 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>
Subject: Re: perf: use after free in perf_remove_from_context
References: <5370EBE9.6@oracle.com> <20140514162943.GR30445@twins.programming.kicks-ass.net> <53739A9A.5010703@oracle.com> <20140514163535.GS30445@twins.programming.kicks-ass.net> <538676A7.6090306@oracle.com>
In-Reply-To: <538676A7.6090306@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2014 07:52 PM, Sasha Levin wrote:
> On 05/14/2014 12:35 PM, Peter Zijlstra wrote:
>> On Wed, May 14, 2014 at 12:32:26PM -0400, Sasha Levin wrote:
>>>> -----BEGIN PGP SIGNED MESSAGE-----
>>>> Hash: SHA1
>>>>
>>>> On 05/14/2014 12:29 PM, Peter Zijlstra wrote:
>>>>>> On Mon, May 12, 2014 at 11:42:33AM -0400, Sasha Levin wrote:
>>>>>>>> Hi all,
>>>>>>>>
>>>>>>>> While fuzzing with trinity inside a KVM tools guest running the latest -next kernel I've stumbled on the following spew. Maybe related to the very recent change in freeing on task exit?
>>>>>>>>
>>>>>>>> [ 2509.827261] general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC [ 2509.830379] Dumping ftrace buffer: [ 2509.830379]    (ftrace buffer empty) [ 2509.830379] Modules linked in: [ 2509.830379] CPU: 47 PID: 43306 Comm: trinity-c126 Tainted: G        W     3.15.0-rc5-next-20140512-sasha-00019-ga20bc00-dirty #456
>>>>>>
>>>>>> Any particular trinity setup? And would you happen to have the seed of that run?
>>>>
>>>> Nothing special about trinity options. 400 threads and blacklisting some of the
>>>> destructive syscalls (umount, reboot, etc).
>>>>
>>>> I don't have the seed, but that problem did reproduce again tonight so I can test
>>>> out debug code if you have something in mind.
>> Nah, I drew a pretty big blank, which is why I wanted to see if I could
>> reproduce. If you could share your trinity cmdline I'd be much obliged.
>> While I did manage to clone (the repo moved since last time) and build
>> it, I'm not really that handy with it and want to avoid destroying my
>> machine if possible ;-)
> 
> Anything I could do to help out with this? It reproduces pretty easily on my
> configuration so I'd be happy to test out whatever might help.

I've just had this:


[  591.111854] general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  591.121057] Dumping ftrace buffer:
[  591.121057]    (ftrace buffer empty)
[  591.121057] Modules linked in:
[  591.121057] CPU: 14 PID: 10272 Comm: trinity-c230 Tainted: G        W     3.15.0-rc7-next-20140528-sasha-00019-gd193e91-dirty #545
[  591.121057] task: ffff8802df0d3000 ti: ffff8802df0fe000 task.ti: ffff8802df0fe000
[  591.129130] RIP: perf_event_exit_task (kernel/events/core.c:7492 kernel/events/core.c:7524)
[  591.129130] RSP: 0000:ffff8802df0ffe28  EFLAGS: 00010246
[  591.129130] RAX: 0000000000000000 RBX: ffff8802df0d3000 RCX: 0000000000000001
[  591.129130] RDX: 0000000000000000 RSI: ffffffff97088100 RDI: 0000000000000282
[  591.129130] RBP: ffff8802df0ffe98 R08: 0000000000000000 R09: 0000000000000000
[  591.129130] R10: 0000000000000001 R11: 0000000000000000 R12: 6b6b6b6b6b6b6b6b
[  591.129130] R13: 6b6b6b6b6b6b6b6b R14: ffff8806c9bfd550 R15: 0000000000000001
[  591.129130] FS:  00007f4b26866700(0000) GS:ffff88036ae00000(0000) knlGS:0000000000000000
[  591.129130] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  591.129130] CR2: 0000000001a3a9f8 CR3: 000000001702c000 CR4: 00000000000006a0
[  591.129130] Stack:
[  591.129130]  ffff8802df0ffe48 ffff8802df09cce0 ffff8802fdf99488 ffff8802fdf99290
[  591.129130]  ffff8806c9bfd5a8 ffff8806c9bfd670 ffff8802df0ffe88 6b6b6b6b6b6b6b6b
[  591.129130]  ffff8802df0ffe98 0000000000000001 0000000000000001 ffff8802df0d3000
[  591.129130] Call Trace:
[  591.129130] do_exit (kernel/exit.c:766)
[  591.129130] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
[  591.129130] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2557 kernel/locking/lockdep.c:2599)
[  591.129130] ? trace_hardirqs_on (kernel/locking/lockdep.c:2607)
[  591.129130] do_group_exit (kernel/exit.c:884)
[  591.129130] SyS_exit_group (kernel/exit.c:895)
[  591.129130] tracesys (arch/x86/kernel/entry_64.S:542)
[ 591.129130] Code: a0 02 00 00 49 89 95 a8 02 00 00 4c 8b 45 a0 4c 89 c7 e8 11 c2 2c 03 48 8b 45 a8 48 89 c7 e8 15 7c ff ff 4c 89 ef e8 bd 7b ff ff <49> 8b 45 00 48 89 45 c8 4c 8b 6d c8 e8 cc 19 f6 ff 85 c0 74 0e
All code
========
   0:	a0 02 00 00 49 89 95 	movabs 0x2a8958949000002,%al
   7:	a8 02
   9:	00 00                	add    %al,(%rax)
   b:	4c 8b 45 a0          	mov    -0x60(%rbp),%r8
   f:	4c 89 c7             	mov    %r8,%rdi
  12:	e8 11 c2 2c 03       	callq  0x32cc228
  17:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  1b:	48 89 c7             	mov    %rax,%rdi
  1e:	e8 15 7c ff ff       	callq  0xffffffffffff7c38
  23:	4c 89 ef             	mov    %r13,%rdi
  26:	e8 bd 7b ff ff       	callq  0xffffffffffff7be8
  2b:*	49 8b 45 00          	mov    0x0(%r13),%rax		<-- trapping instruction
  2f:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  33:	4c 8b 6d c8          	mov    -0x38(%rbp),%r13
  37:	e8 cc 19 f6 ff       	callq  0xfffffffffff61a08
  3c:	85 c0                	test   %eax,%eax
  3e:	74 0e                	je     0x4e
	...

Code starting with the faulting instruction
===========================================
   0:	49 8b 45 00          	mov    0x0(%r13),%rax
   4:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
   8:	4c 8b 6d c8          	mov    -0x38(%rbp),%r13
   c:	e8 cc 19 f6 ff       	callq  0xfffffffffff619dd
  11:	85 c0                	test   %eax,%eax
  13:	74 0e                	je     0x23
	...
[  591.129130] RIP perf_event_exit_task (kernel/events/core.c:7492 kernel/events/core.c:7524)
[  591.129130]  RSP <ffff8802df0ffe28>


Seems similar enough.


Thanks,
Sasha
