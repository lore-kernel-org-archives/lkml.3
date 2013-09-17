Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab3IQJRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 05:17:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42983 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab3IQJP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 05:15:27 -0400
Message-Id: <20130917082838.218329307@infradead.org>
Date: Tue, 17 Sep 2013 11:10:46 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 00/11] preempt_count rework -v3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches optimize preempt_enable by firstly folding the preempt and
need_resched tests into one -- this should work for all architectures. And
secondly by providing per-arch preempt_count implementations; with x86 using
per-cpu preempt_count for fastest access.

These patches have been boot tested on CONFIG_PREEMPT=y x86_64 and survive
building a x86_64-defconfig kernel.

   text    data     bss     filename
11387014  1454776 1187840 defconfig-build/vmlinux.before
11352294  1454776 1187840 defconfig-build/vmlinux.after

void kick_process(struct task_struct *p)
{
	int cpu;

	preempt_disable();
	cpu = task_cpu(p);
	if ((cpu != smp_processor_id()) && task_curr(p))
		smp_send_reschedule(cpu);
	preempt_enable();
}

before:

  ffffffff81073f00 <kick_process>:
  ffffffff81073f00:       55                      push   %rbp
I ffffffff81073f01:       65 48 8b 04 25 f0 b7    mov    %gs:0xb7f0,%rax
  ffffffff81073f08:       00 00 
I ffffffff81073f0a:       83 80 44 e0 ff ff 01    addl   $0x1,-0x1fbc(%rax)
  ffffffff81073f11:       48 89 e5                mov    %rsp,%rbp
  ffffffff81073f14:       48 8b 47 08             mov    0x8(%rdi),%rax
  ffffffff81073f18:       8b 50 18                mov    0x18(%rax),%edx
  ffffffff81073f1b:       65 8b 04 25 1c b0 00    mov    %gs:0xb01c,%eax
  ffffffff81073f22:       00 
  ffffffff81073f23:       39 c2                   cmp    %eax,%edx
  ffffffff81073f25:       74 1b                   je     ffffffff81073f42 <kick_process+0x42>
  ffffffff81073f27:       89 d1                   mov    %edx,%ecx
  ffffffff81073f29:       48 c7 c0 40 2c 01 00    mov    $0x12c40,%rax
  ffffffff81073f30:       48 8b 0c cd 00 25 cc    mov    -0x7e33db00(,%rcx,8),%rcx
  ffffffff81073f37:       81 
  ffffffff81073f38:       48 3b bc 08 00 08 00    cmp    0x800(%rax,%rcx,1),%rdi
  ffffffff81073f3f:       00 
  ffffffff81073f40:       74 2e                   je     ffffffff81073f70 <kick_process+0x70>
D ffffffff81073f42:       65 48 8b 04 25 f0 b7    mov    %gs:0xb7f0,%rax
  ffffffff81073f49:       00 00 
D ffffffff81073f4b:       83 a8 44 e0 ff ff 01    subl   $0x1,-0x1fbc(%rax)
D ffffffff81073f52:       48 8b 80 38 e0 ff ff    mov    -0x1fc8(%rax),%rax
D ffffffff81073f59:       a8 08                   test   $0x8,%al
D ffffffff81073f5b:       75 02                   jne    ffffffff81073f5f <kick_process+0x5f>
  ffffffff81073f5d:       5d                      pop    %rbp
  ffffffff81073f5e:       c3                      retq   
D ffffffff81073f5f:       e8 9c 6f 75 00          callq  ffffffff817caf00 <preempt_schedule>
  ffffffff81073f64:       5d                      pop    %rbp
  ffffffff81073f65:       c3                      retq   
  ffffffff81073f66:       66 2e 0f 1f 84 00 00    nopw   %cs:0x0(%rax,%rax,1)
  ffffffff81073f6d:       00 00 00 
  ffffffff81073f70:       89 d7                   mov    %edx,%edi
  ffffffff81073f72:       ff 15 a8 99 ba 00       callq  *0xba99a8(%rip)        # ffffffff81c1d920 <smp_ops+0x20>
  ffffffff81073f78:       eb c8                   jmp    ffffffff81073f42 <kick_process+0x42>
  ffffffff81073f7a:       66 0f 1f 44 00 00       nopw   0x0(%rax,%rax,1)
   
   
after:
   
  ffffffff8106f5e0 <kick_process>:
  ffffffff8106f5e0:       55                      push   %rbp
I ffffffff8106f5e1:       65 ff 04 25 e0 b7 00    incl   %gs:0xb7e0
  ffffffff8106f5e8:       00 
  ffffffff8106f5e9:       48 89 e5                mov    %rsp,%rbp
  ffffffff8106f5ec:       48 8b 47 08             mov    0x8(%rdi),%rax
  ffffffff8106f5f0:       8b 50 18                mov    0x18(%rax),%edx
  ffffffff8106f5f3:       65 8b 04 25 1c b0 00    mov    %gs:0xb01c,%eax
  ffffffff8106f5fa:       00 
  ffffffff8106f5fb:       39 c2                   cmp    %eax,%edx
  ffffffff8106f5fd:       74 1b                   je     ffffffff8106f61a <kick_process+0x3a>
  ffffffff8106f5ff:       89 d1                   mov    %edx,%ecx
  ffffffff8106f601:       48 c7 c0 40 2c 01 00    mov    $0x12c40,%rax
  ffffffff8106f608:       48 8b 0c cd 00 25 cc    mov    -0x7e33db00(,%rcx,8),%rcx
  ffffffff8106f60f:       81 
  ffffffff8106f610:       48 3b bc 08 00 08 00    cmp    0x800(%rax,%rcx,1),%rdi
  ffffffff8106f617:       00 
  ffffffff8106f618:       74 26                   je     ffffffff8106f640 <kick_process+0x60>
D ffffffff8106f61a:       65 ff 0c 25 e0 b7 00    decl   %gs:0xb7e0
  ffffffff8106f621:       00 
D ffffffff8106f622:       74 0c                   je     ffffffff8106f630 <kick_process+0x50>
  ffffffff8106f624:       5d                      pop    %rbp
  ffffffff8106f625:       c3                      retq   
  ffffffff8106f626:       66 2e 0f 1f 84 00 00    nopw   %cs:0x0(%rax,%rax,1)
  ffffffff8106f62d:       00 00 00 
D ffffffff8106f630:       e8 fb b4 f9 ff          callq  ffffffff8100ab30 <___preempt_schedule>
  ffffffff8106f635:       5d                      pop    %rbp
  ffffffff8106f636:       c3                      retq   
  ffffffff8106f637:       66 0f 1f 84 00 00 00    nopw   0x0(%rax,%rax,1)
  ffffffff8106f63e:       00 00 
  ffffffff8106f640:       89 d7                   mov    %edx,%edi
  ffffffff8106f642:       ff 15 d8 e2 ba 00       callq  *0xbae2d8(%rip)        # ffffffff81c1d920 <smp_ops+0x20>
  ffffffff8106f648:       eb d0                   jmp    ffffffff8106f61a <kick_process+0x3a>
  ffffffff8106f64a:       66 0f 1f 44 00 00       nopw   0x0(%rax,%rax,1)

