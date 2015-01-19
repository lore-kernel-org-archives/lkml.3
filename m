Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbbASLYG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 06:24:06 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:1100 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbbASLWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 06:22:50 -0500
Message-ID: <54BCE8C3.4080903@huawei.com>
Date: Mon, 19 Jan 2015 19:21:39 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: <tixy@linaro.org>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <lizefan@huawei.com>
Subject: Re: [PATCH] kprobes: bugfix: checks kprobes_all_disarmed in unoptimized_kprobe().
References: <54B3B32E.7070709@hitachi.com> <1421064563-77831-1-git-send-email-wangnan0@huawei.com> <54B3C3A0.6010708@hitachi.com> <54BC742E.80006@huawei.com> <54BCC8C0.40706@hitachi.com>
In-Reply-To: <54BCC8C0.40706@hitachi.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.129]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/19 17:05, Masami Hiramatsu wrote:
> Hi Wang,
> 
> I've found a problem on this patch, since kprobes calls unoptioize_kprobe
> with kprobes_all_disarmed=true when trying to disable all kprobes, this
> cause a serious problem.
> 
> Moreover, I couldn't reproduce your reported bug on my 3.19-rc4 kernel.
> Could you test it again?
> 

I tested it again based on 3.19-rc5 and found that the problem still exists.
My testing is based on QEMU.

First I tested my kprobeopt for ARM, then on x86_64. The test results are pasted
at the bottom of this mail. Commands after 'gdb attaches to QEMU' is my actions
on a gdb console attached to QEMU; commands after 'inside virtual machine' is
what I do in Linux run under QEMU.



** ARM result **

------ gdb attaches to QEMU -------
(gdb) x/3i sys_open
   0xc013619c <SyS_open>:	mov	r12, sp          <--- *original insn*
   0xc01361a0 <SyS_open+4>:	push	{r11, r12, lr, pc}
   0xc01361a4 <SyS_open+8>:	sub	r11, r12, #4

------ inside virtual machine -------
# echo 'p:myprobe sys_open' > /sys/kernel/debug/tracing/kprobe_events
# echo 1 > /sys/kernel/debug/tracing/events/kprobes/myprobe/enable

------ gdb attaches to QEMU -------
cpu_v7_do_idle () at /home/w00229757/kernel-hydrogen/arch/arm/mm/proc-v7.S:74
74		ret	lr
(gdb) x/3i sys_open
   0xc013619c <SyS_open>:	b	0xbf000000        <--- *optimized*
   0xc01361a0 <SyS_open+4>:	push	{r11, r12, lr, pc}
   0xc01361a4 <SyS_open+8>:	sub	r11, r12, #4
(gdb) c

------ inside virtual machine -------
# echo 0 > /sys/kernel/debug/kprobes/enabled

------ gdb attaches to QEMU -------
cpu_v7_do_idle () at /home/w00229757/kernel-hydrogen/arch/arm/mm/proc-v7.S:74
74		ret	lr
(gdb) x/3i sys_open
   0xc013619c <SyS_open>:			; <UNDEFINED> instruction: 0xe7f001f8    <--- *BREAKPOINT*
   0xc01361a0 <SyS_open+4>:	push	{r11, r12, lr, pc}
   0xc01361a4 <SyS_open+8>:	sub	r11, r12, #4
(gdb) c



** x86_64 result **

------ gdb attaches to QEMU -------
(gdb) x/10i sys_open
   0xffffffff81184fe0 <SyS_open>:	data32 data32 data32 xchg %ax,%ax
   0xffffffff81184fe5 <SyS_open+5>:	push   %rbp
   0xffffffff81184fe6 <SyS_open+6>:	movzwl %dx,%ecx
   0xffffffff81184fe9 <SyS_open+9>:	mov    %esi,%edx
   0xffffffff81184feb <SyS_open+11>:	mov    %rsp,%rbp
   0xffffffff81184fee <SyS_open+14>:	mov    %rdi,%rsi
   0xffffffff81184ff1 <SyS_open+17>:	or     $0x80,%dh
   0xffffffff81184ff4 <SyS_open+20>:	mov    $0xffffff9c,%edi
   0xffffffff81184ff9 <SyS_open+25>:	callq  0xffffffff81184da0 <do_sys_open>
   0xffffffff81184ffe <SyS_open+30>:	pop    %rbp
(gdb) c
Continuing


------ inside virtual machine -------
# echo 'p:myprobe sys_open+20' > /sys/kernel/debug/tracing/kprobe_events
# echo 1 > /sys/kernel/debug/tracing/events/kprobes/myprobe/enable

------ gdb attaches to QEMU -------
(gdb) x/10i sys_open
   0xffffffff81184fe0 <SyS_open>:	data32 data32 data32 xchg %ax,%ax
   0xffffffff81184fe5 <SyS_open+5>:	push   %rbp
   0xffffffff81184fe6 <SyS_open+6>:	movzwl %dx,%ecx
   0xffffffff81184fe9 <SyS_open+9>:	mov    %esi,%edx
   0xffffffff81184feb <SyS_open+11>:	mov    %rsp,%rbp
   0xffffffff81184fee <SyS_open+14>:	mov    %rdi,%rsi
   0xffffffff81184ff1 <SyS_open+17>:	or     $0x80,%dh
   0xffffffff81184ff4 <SyS_open+20>:	jmpq   0xffffffffa0002000         <--- *optimized*
   0xffffffff81184ff9 <SyS_open+25>:	callq  0xffffffff81184da0 <do_sys_open>
   0xffffffff81184ffe <SyS_open+30>:	pop    %rbp
(gdb) c
Continuing.

------ inside virtual machine -------
# echo 0 > /sys/kernel/debug/kprobes/enabled

------ gdb attaches to QEMU -------
(gdb) x/10i sys_open
   0xffffffff81184fe0 <SyS_open>:	data32 data32 data32 xchg %ax,%ax
   0xffffffff81184fe5 <SyS_open+5>:	push   %rbp
   0xffffffff81184fe6 <SyS_open+6>:	movzwl %dx,%ecx
   0xffffffff81184fe9 <SyS_open+9>:	mov    %esi,%edx
   0xffffffff81184feb <SyS_open+11>:	mov    %rsp,%rbp
   0xffffffff81184fee <SyS_open+14>:	mov    %rdi,%rsi
   0xffffffff81184ff1 <SyS_open+17>:	or     $0x80,%dh
   0xffffffff81184ff4 <SyS_open+20>:	int3          <-- **BREAKPOINT**
   0xffffffff81184ff5 <SyS_open+21>:	pushfq
   0xffffffff81184ff6 <SyS_open+22>:	(bad)
(gdb)


