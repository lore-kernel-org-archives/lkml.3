Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbaD1Jvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 05:51:39 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:59077 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbaD1Jvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 05:51:36 -0400
Message-ID: <535E249F.2080606@linaro.org>
Date: Mon, 28 Apr 2014 18:51:27 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Don Dutile <ddutile@redhat.com>
CC: viro@zeniv.linux.org.uk, eparis@redhat.com, rgb@redhat.com,
        catalin.marinas@arm.com, will.deacon@arm.com,
        linaro-kernel@lists.linaro.org, arndb@arndb.de,
        linux-kernel@vger.kernel.org, dsaxena@linaro.org,
        linux-audit@redhat.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH_v8 0/2] arm64: Add audit support
References: <1394705767-12423-1-git-send-email-takahiro.akashi@linaro.org> <1394862548-29060-1-git-send-email-takahiro.akashi@linaro.org> <53486087.9060304@redhat.com>
In-Reply-To: <53486087.9060304@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Don,

Sorry for not responding to you soon:

On 04/12/2014 06:37 AM, Don Dutile wrote:
> On 03/15/2014 01:49 AM, AKASHI Takahiro wrote:
>> (Please apply this patch after my ftrace patch to resolve some conflict
>> on arm64/kernel/ptrace.c, functionally it doesn't depend on ftrace though)
>>
>> This patchset adds system call audit support on arm64.
>> Both 32-bit (AUDIT_ARCH_ARM) and 64-bit tasks (AUDIT_ARCH_AARCH64)
>> are supported. Since arm64 has the exact same set of system calls
>> on LE and BE, we don't care about endianness (or more specifically
>> __AUDIT_ARCH_64BIT bit in AUDIT_ARCH_*).
>>
>> There are some prerequisites for this patch to work correctly:
>> * "audit: Add CONFIG_HAVE_ARCH_AUDITSYSCALL" patch
>> * "audit: generic compat system call audit support" patch
>> * "arm64: __NR_* definitions for compat syscalls" patch from Catalin
>> * "arm64: make a single hook to syscall_trace() for all syscall features" patch
>> * "arm64: split syscall_trace() into separate functions for enter/exit" patch
>> * "arm64: Add regs_return_value() in syscall.h" patch
>> * "arm64: is_compat_task is defined both in asm/compat.h and
>>     linux/compat.h" patch
>> * userspace audit tool (v2.3.2 + my patch for arm64)
>>
> and the 2/2 patch won't apply to arch/arm64/kernel/ptrace.c
> without the patch from  [PATCH v7 7/7] arm64: ftrace: Add system call tracepoint;
> My question: do you need all 7 patches from arm64: Add ftrace support
> as well for this audit patch to work, or just this 7/7 patch ?

Functionally, my audit patch should work without ftrace patchset, but as described
in ftrace's [0/7] and audit's [0/2], audit's [2/2] assumes that ftrace patchset, especially
[7/7], has been applied in order to avoid any conflict when making changes on the same
line of ptrace.c.

Thanks,
-Takahiro AKASHI

>
>> Please review them as well for better understandings.
>>
>> This code was tested on both 32-bit and 64-bit LE userland
>> in the following two ways:
>> 1) basic operations with auditctl/autrace
>>    # auditctl -a exit,always -S openat -F path=/etc/inittab
>>    # auditctl -a exit,always -F dir=/tmp -F perm=rw
>>    # auditctl -a task,always
>>    # autrace /bin/ls
>>      by comparing output from autrace with one from strace
>>
>> 2) audit-test-code (+ my workarounds for arm/arm64)
>>    by running "audit-tool", "filter" and "syscalls" test categories.
>>
>> Changes v7 -> v8:
>> * aligned with the change in "audit: generic compat system call audit
>>    support" v5 [1/2]
>> * aligned with the change in "arm64: split syscall_trace() into separate
>>    functions for enter/exit" v5 [2/2]
>>
>> Changes v6 -> v7:
>> * changed an include file in syscall.h from <linux/audit.h> to
>>    <uapi/linux/audit.h> [1/2]
>> * aligned with the patch, "arm64: split syscall_trace() into separate
>>    functions for enter/exit" [2/2]
>>
>> Changes v5 -> v6:
>> * removed and put "arm64: Add regs_return_value() in syscall.h" patch into
>>    a separate set
>> * aligned with the change in "arm64: make a single hook to syscall_trace()
>>    for all syscall features" v3 [1/2]
>>
>> Changes v4 -> v5:
>> * rebased to 3.14-rcX
>> * added a guard against TIF_SYSCALL_AUDIT [3/3]
>> * aligned with the change in "arm64: make a single hook to syscall_trace()
>>    for all syscall features" v2 [3/3]
>>
>> Changes v3 -> v4:
>> * Modified to sync with the patch, "make a single hook to syscall_trace()
>>    for all syscall features"
>> * aligned with "audit: Add CONFIG_HAVE_ARCH_AUDITSYSCALL" patch
>>
>> Changes v2 -> v3:
>> * Remove asm/audit.h.
>>    See "generic compat syscall audit support" patch v4
>> * Remove endianness dependency, ie. AUDIT_ARCH_ARMEB/AARCH64EB.
>> * Remove kernel/syscalls/Makefile which was used to create unistd32.h.
>>    See Catalin's "Add __NR_* definitions for compat syscalls" patch
>>
>> Changes v1 -> v2:
>> * Modified to utilize "generic compat system call audit" [3/6, 4/6, 5/6]
>>    Please note that a required header, unistd_32.h, is automatically
>>    generated from unistd32.h.
>> * Refer to regs->orig_x0 instead of regs->x0 as the first argument of
>>    system call in audit_syscall_entry() [6/6]
>> * Include "Add regs_return_value() in syscall.h" patch [2/6],
>>    which was not intentionally included in v1 because it could be added
>>    by "kprobes support".
>>
>> AKASHI Takahiro (2):
>>    arm64: Add audit support
>>    arm64: audit: Add audit hook in syscall_trace_enter/exit()
>>
>>   arch/arm64/Kconfig               |  2 ++
>>   arch/arm64/include/asm/syscall.h | 15 +++++++++++++++
>>   arch/arm64/kernel/ptrace.c       |  7 +++++++
>>   include/uapi/linux/audit.h       |  1 +
>>   4 files changed, 25 insertions(+)
>>
>
