Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbaFDQFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 12:05:52 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:43839 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbaFDQFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 12:05:50 -0400
Message-ID: <538F43D7.2080407@hitachi.com>
Date: Thu, 05 Jun 2014 01:05:43 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Peter Moody <pmoody@google.com>
Cc: ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@google.com>
Subject: Re: (ltc-kernel 9473) Re: splat in kretprobe in get_task_mm(current)
References: <r3noay9dhad.fsf@perdido.sfo.corp.google.com> <r3nfvjld5il.fsf@perdido.sfo.corp.google.com> <538ED2E3.1000707@hitachi.com> <538F2837.3080800@hitachi.com>
In-Reply-To: <538F2837.3080800@hitachi.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/06/04 23:07), Masami Hiramatsu wrote:
> (2014/06/04 17:03), Masami Hiramatsu wrote:
>> Hi Peter,
>>
>> (2014/06/04 6:53), Peter Moody wrote:
>>>
>>> As a follow up, I can reliably reproduce this bug with the following code
>>>
>>> #include <unistd.h>
>>> #include <sys/types.h>
>>>
>>> int main(int argc, char *argv[]) {
>>>   char *envp_[] = {NULL};
>>>   char *argv_[] = {argv[0]};
>>>   execve(argv[0], argv_, envp_);
>>>   return 0;
>>> }
>>>
>>> run in parallel like so:
>>>
>>> $ for x in $(seq 0 32) ; do ./a.out & done
>>>
>>> giving me the following splat:.
>>
>> Thank you for reporting that. I've tried to reproduce it with your code, but
>> not succeeded yet. Could you share us your kernel config too?
> 
> Hmm, it seems that on my environment (Fedora20, gcc version 4.8.2 20131212),
> do_execve() in sys_execve has been optimized out (and do_execve_common() is
> also renamed). I'll try to rebuild it. However, since such optimization sometimes
> depends on kernel config, I'd like to do it with your config.

OK, I think at least I could find a clue.
Actually I forgot enabling spinlock debug, but a deadlock catched by rcu_sched.

[ 1155.568010] INFO: rcu_sched detected stalls on CPUs/tasks: { 4 6 7} (detected by 3, t=5252 jiffies, g=20035, c=20034, q=1965612)
[ 1155.572339] sending NMI to all CPUs:
...
[ 1134.596992] NMI backtrace for cpu 4
[ 1134.596992] CPU: 4 PID: 5614 Comm: execve Not tainted 3.15.0-rc8+ #6
[ 1134.596992] Hardware name: Red Hat Inc. OpenStack Nova, BIOS 0.5.1 01/01/2007
[ 1134.596992] task: ffff88040c806f00 ti: ffff8800d9130000 task.ti: ffff8800d9130000
[ 1134.596992] RIP: 0010:[<ffffffff81526d7d>]  [<ffffffff81526d7d>] _raw_spin_lock_irqsave+0x4d/0x61
[ 1134.596992] RSP: 0018:ffff8800d9133c68  EFLAGS: 00000083
[ 1134.596992] RAX: 000000000009692e RBX: 0000000000000286 RCX: 0000000000000030
[ 1134.596992] RDX: 0000000000005944 RSI: 0000000000000030 RDI: ffffffff81cb2800
[ 1134.596992] RBP: ffff8800d9133c78 R08: 0000000000015fe0 R09: ffffea00036c5200
[ 1134.596992] R10: 0000000000000000 R11: ffffffff810435ed R12: ffff88040ac3ef00
[ 1134.596992] R13: ffff8800db14e4c0 R14: 0000000000000040 R15: ffff88040ac3ef00
[ 1134.596992] FS:  0000000000000000(0000) GS:ffff88041fd00000(0000) knlGS:0000000000000000
[ 1134.596992] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1134.596992] CR2: 0000000000601034 CR3: 0000000401da1000 CR4: 00000000000406e0
[ 1134.596992] Stack:
[ 1134.596992]  ffffffff81cb2800 ffff8800d9133ca8 ffff8800d9133c90 ffffffff810b2923
[ 1134.596992]  0000000000000009 ffff8800d9133cc8 ffffffff810b34ac 0000000000000000
[ 1134.596992]  0000000000000000 ffff88041fd12b00 ffff88040ac3ef00 ffff8800db14e4c0
[ 1134.596992] Call Trace:
[ 1134.596992]  [<ffffffff810b2923>] kretprobe_table_lock+0x1d/0x23
[ 1134.596992]  [<ffffffff810b34ac>] kprobe_flush_task+0x50/0xca
[ 1134.596992]  [<ffffffff8106a889>] finish_task_switch+0x94/0x107
[ 1134.596992]  [<ffffffff81523ba0>] __schedule+0x497/0x743
[ 1134.596992]  [<ffffffff810c3eeb>] ? __buffer_unlock_commit+0x12/0x14
[ 1134.596992]  [<ffffffff810c4a30>] ? trace_buffer_unlock_commit_regs+0x3e/0x46
[ 1134.596992]  [<ffffffff810d85ca>] ? kretprobe_trace_func+0x2a2/0x2b6
[ 1134.596992]  [<ffffffff8113b6ec>] ? SyS_execve+0x2a/0x2e
[ 1134.596992]  [<ffffffff8152420a>] _cond_resched+0x44/0x57
[ 1134.596992]  [<ffffffff8104383c>] mmput+0x12/0xc6
[ 1134.596992]  [<ffffffff8113b6ec>] ? SyS_execve+0x2a/0x2e
[ 1134.596992]  [<ffffffffa000a02d>] exec_handler+0x2d/0x34 [exec_mm_probe]
[ 1134.596992]  [<ffffffff8103197c>] trampoline_handler+0x11b/0x1ac
[ 1134.596992]  [<ffffffff810315b2>] kretprobe_trampoline+0x25/0x4c
[ 1134.596992]  [<ffffffff8113e12e>] ? final_putname+0x34/0x37
[ 1134.596992]  [<ffffffff8103158d>] ? kretprobe_trampoline_holder+0x9/0x9
[ 1134.596992]  [<ffffffff81527cb9>] stub_execve+0x69/0xa0

This seems that mmput() invoking __schedule() function which is not allowed in
k*probes handler, since the handler is called from special path. As you can see
in Documentation/kprobes.txt, "5. Kprobes Features and Limitations" says

---
 Probe handlers are run with preemption disabled.  Depending on the
 architecture and optimization state, handlers may also run with
 interrupts disabled (e.g., kretprobe handlers and optimized kprobe
 handlers run without interrupt disabled on x86/x86-64).  In any case,
 your handler should not yield the CPU (e.g., by attempting to acquire
 a semaphore).
---

So the mmput() yielding the CPU (by calling __schedule()) which is not allowed
officially. I think even though this should not happen, but currently, that is
a limitation.

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


