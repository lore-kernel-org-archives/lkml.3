Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaFDWuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 18:50:00 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:54494 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaFDWt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 18:49:58 -0400
Message-ID: <538FA28F.30407@hitachi.com>
Date: Thu, 05 Jun 2014 07:49:51 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Peter Moody <pmoody@google.com>
Cc: ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@google.com>
Subject: Re: Re: splat in kretprobe in get_task_mm(current)
References: <r3noay9dhad.fsf@perdido.sfo.corp.google.com> <r3nfvjld5il.fsf@perdido.sfo.corp.google.com> <538ED2E3.1000707@hitachi.com> <538F2837.3080800@hitachi.com> <r3nd2eobswp.fsf@perdido.sfo.corp.google.com>
In-Reply-To: <r3nd2eobswp.fsf@perdido.sfo.corp.google.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/06/05 0:23), Peter Moody wrote:
> 
> On Wed, Jun 04 2014 at 07:07, Masami Hiramatsu wrote:
> 
>>> Thank you for reporting that. I've tried to reproduce it with your code, but
>>> not succeeded yet. Could you share us your kernel config too?
>>
>> Hmm, it seems that on my environment (Fedora20, gcc version 4.8.2 20131212),
>> do_execve() in sys_execve has been optimized out (and do_execve_common() is
>> also renamed). I'll try to rebuild it. However, since such optimization sometimes
>> depends on kernel config, I'd like to do it with your config.
>>
>> Thank you,
> 
> Sure thing, sorry for not attaching it to begin with.
> 
> One other thing is that, at least on the systems I've been able to repro on, the more processes,
> the more likely I was to not emit a splat before just deadlocking the machine. eg. on a 12 core
> machine, I got the splat with 32 processes and a deadlock with 50. On a 2 core qemu virtual
> machine I got a deadlock with 32 and a splat with something like 12 or 16.
> 
> And FWIW, I'm running ubuntu precise, with gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5)


Thank you for sharing the kconfig. I saw the CONFIG_DEBUG_ATOMIC_SLEEP was not set
in your kconfig. When I set that and run your test, I had (a lot of) below warnings
instead of deadlock.

[  342.072132] BUG: sleeping function called from invalid context at /home/fedora/ksrc/linux-3/kernel/fork.c:615
[  342.080684] in_atomic(): 1, irqs_disabled(): 1, pid: 5017, name: execve
[  342.080684] INFO: lockdep is turned off.
[  342.080684] irq event stamp: 0
[  342.080684] hardirqs last  enabled at (0): [<          (null)>]           (null)
[  342.080684] hardirqs last disabled at (0): [<ffffffff81045468>] copy_process.part.31+0x5ba/0x183d
[  342.080684] softirqs last  enabled at (0): [<ffffffff81045468>] copy_process.part.31+0x5ba/0x183d
[  342.080684] softirqs last disabled at (0): [<          (null)>]           (null)
[  342.080684] CPU: 5 PID: 5017 Comm: execve Not tainted 3.15.0-rc8+ #7
[  342.080684] Hardware name: Red Hat Inc. OpenStack Nova, BIOS 0.5.1 01/01/2007
[  342.080684]  0000000000000000 ffff8803ff81bdf8 ffffffff81554140 ffff88040a9df500
[  342.080684]  ffff8803ff81be08 ffffffff8106d17c ffff8803ff81be20 ffffffff81044bd8
[  342.080684]  ffffffff8114ad8f ffff8803ff81be30 ffffffffa015802d ffff8803ff81be88
[  342.080684] Call Trace:
[  342.080684]  [<ffffffff81554140>] dump_stack+0x4d/0x66
[  342.080684]  [<ffffffff8106d17c>] __might_sleep+0x118/0x11a
[  342.080684]  [<ffffffff81044bd8>] mmput+0x20/0xd9
[  342.080684]  [<ffffffff8114ad8f>] ? SyS_execve+0x2a/0x2e
[  342.080684]  [<ffffffffa015802d>] exec_handler+0x2d/0x34 [exec_mm_probe]
[  342.080684]  [<ffffffff81032a2c>] trampoline_handler+0x11b/0x1ac
[  342.080684]  [<ffffffff8103265a>] kretprobe_trampoline+0x25/0x4c
[  342.080684]  [<ffffffff81032635>] ? kretprobe_trampoline_holder+0x9/0x9
[  342.080684]  [<ffffffff8155ca99>] stub_execve+0x69/0xa0

Here, as you can see, calling mmput() in kretprobe handler is actually the root cause
of this problem.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


