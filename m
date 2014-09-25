Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbaIYXAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 19:00:11 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:36841 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbaIYXAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 19:00:10 -0400
Date: Thu, 25 Sep 2014 18:00:05 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Anish Bhatt <anish@chelsio.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, sebastian@fds-team.de
Subject: Re: [PATCH] x86 : Ensure X86_FLAGS_NT is cleared on syscall entry
Message-ID: <20140925180005.356089de@as>
In-Reply-To: <1411674171-24442-1-git-send-email-anish@chelsio.com>
References: <1411674171-24442-1-git-send-email-anish@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2014 12:42:51 -0700
Anish Bhatt <anish@chelsio.com> wrote:

> The MSR_SYSCALL_MASK, which is responsible for clearing specific EFLAGS on
>  syscall entry, should also clear the nested task (NT) flag to be safe from
>  userspace injection. Without this fix the application segmentation
>  faults on syscall return because of the changed meaning of the IRET
>  instruction.
> 
> Further details can be seen here https://bugs.winehq.org/show_bug.cgi?id=33275
> 
> Signed-off-by: Anish Bhatt <anish@chelsio.com>
> Signed-off-by: Sebastian Lackner <sebastian@fds-team.de>
> ---
>  arch/x86/kernel/cpu/common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index e4ab2b4..3126558 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -1184,7 +1184,7 @@ void syscall_init(void)
>  	/* Flags to clear on syscall */
>  	wrmsrl(MSR_SYSCALL_MASK,
>  	       X86_EFLAGS_TF|X86_EFLAGS_DF|X86_EFLAGS_IF|
> -	       X86_EFLAGS_IOPL|X86_EFLAGS_AC);
> +	       X86_EFLAGS_IOPL|X86_EFLAGS_AC|X86_EFLAGS_NT);
>  }
>  
>  /*

To demonstrate the bug this fixes, just strace this program, adapted
from the linked bug report:

#include <stdio.h>
#include <unistd.h>

int main()
{
	asm volatile("pushfq           \n\t" \
		     "pop %rax         \n\t" \
		     "or $0x4000,%rax  \n\t" \
		     "push %rax        \n\t" \
		     "popfq            \n\t");
	sleep(1);

	return 0;
}

I ran strace under gdb and found it dies here with SIGSEGV:

   0x00007ffff7a505c2 <+50>:	mov    $0xea,%eax
   0x00007ffff7a505c7 <+55>:	syscall 
=> 0x00007ffff7a505c9 <+57>:	cmp    $0xfffffffffffff000,%rax

