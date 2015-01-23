Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbbAWAxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 19:53:52 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:58587 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbbAWAxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 19:53:50 -0500
MIME-Version: 1.0
In-Reply-To: <1421857754.173957.216801721.380D3A16@webmail.messagingengine.com>
References: <1421581520-2816-1-git-send-email-heukelum@fastmail.fm>
 <1421581520-2816-3-git-send-email-heukelum@fastmail.fm> <CAK1hOcMgrpw5+Uz+5U25Xq_1fJNTGc4PUtw+YzGGYBZ-YKaJew@mail.gmail.com>
 <1421857754.173957.216801721.380D3A16@webmail.messagingengine.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Fri, 23 Jan 2015 01:53:29 +0100
Message-ID: <CAK1hOcNgE8UF=c7RR3a6SYK3U-uiDw7AhksYt3NFH2JO_iN1Fw@mail.gmail.com>
Subject: Re: [PATCHv2 2/4] x86_64: embrace KERNEL_STACK_OFFSET
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Andy Lutomirski <luto@amacapital.net>, X86 ML <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, Borislav Petkov <bp@suse.de>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 5:29 PM, Alexander van Heukelum
<heukelum@fastmail.fm> wrote:
> On Wed, Jan 21, 2015, at 14:44, Denys Vlasenko wrote:
>> On Sun, Jan 18, 2015 at 12:45 PM, Alexander van Heukelum
>> <heukelum@fastmail.fm> wrote:
>> > KERNEL_STACK_OFFSET is the offset from the top of the kernel stack
>> > page to the value of the kernel_stack percpu variable. This patch
>> > changes KERNEL_STACK_OFFSET to configure a reserved space of 16
>> > bytes above the user ptregs frame. KERNEL_STACK_OFFSET must be
>> > set to a multiple of 16 bytes due to the automatic stack alignment
>> > of interrupts, traps, and exceptions on x86_64.
>>
>> I propose to set kernel_stack percpu variable to point
>> to the top of kernel stack (obvious, isn't it?)
>> and eliminate KERNEL_STACK_OFFSET altogether.
>
> By "top of kernel stack", do you mean the page boundary or the
> top of struct pt_regs on the kernel stack? (is it really that obvious?)
> I think Borislav did the latter for x86_64 in his patchset.

Page boundary.

kernel_stack is currently initialized as follows:

        this_cpu_write(kernel_stack,
                  (unsigned long)task_stack_page(next_p) +
                  THREAD_SIZE - KERNEL_STACK_OFFSET);

i.e. it points KERNEL_STACK_OFFSET bytes below top-of-stack,
which is two pages above task_struct.

Why do we have KERNEL_STACK_OFFSET?

The original idea was that on SYSCALL instruction entry, which
does not create iret stack, we can eliminate one "sub $5*8,%rsp"
instruction. This idea currently does not work, because we
have such instruction anyway (it allocates pr_regs). Nothing is saved there.

And here, in 32-bit compat code:

ENTRY(ia32_sysenter_target)
        CFI_STARTPROC32 simple
        CFI_SIGNAL_FRAME
        CFI_DEF_CFA     rsp,0
        CFI_REGISTER    rsp,rbp
        SWAPGS_UNSAFE_STACK
        movq    PER_CPU_VAR(kernel_stack), %rsp
        addq    $(KERNEL_STACK_OFFSET),%rsp

we even need to _undo_ the "KERNEL_STACK_OFFSET optimization"
(last insn).

My patch "[PATCH 09/11] x86: get rid of KERNEL_STACK_OFFSET"
simply drops the KERNEL_STACK_OFFSET thing.
