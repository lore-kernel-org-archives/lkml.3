Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbaE1Uri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 16:47:38 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:53221 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbaE1Urh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 16:47:37 -0400
Message-ID: <53864B66.8030100@amacapital.net>
Date: Wed, 28 May 2014 13:47:34 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Philipp Kern <pkern@google.com>, hpa@linux.intel.com
CC: linux-kernel@vger.kernel.org, "H. J. Lu" <hjl.tools@gmail.com>,
        Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH] x32: Mask away the x32 syscall bit in the ptrace codepath
References: <1401279583-1027-1-git-send-email-pkern@google.com>
In-Reply-To: <1401279583-1027-1-git-send-email-pkern@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2014 05:19 AM, Philipp Kern wrote:
> audit_filter_syscall uses the syscall number to reference into a
> bitmask (e->rule.mask[word]). Not removing the x32 bit before passing
> the number to this architecture independent codepath will fail to
> lookup the proper audit bit. Furthermore it will cause an invalid memory
> access in the kernel if the out of bound location is not mapped:
> 
>   BUG: unable to handle kernel paging request at ffff8800e5446630
>   IP: [<ffffffff810fcdd0>] audit_filter_syscall+0x90/0xf0
> 
> Together with the entrypoint in entry_64.S this change causes x32
> programs to pass in both AUDIT_ARCH_X86_64 and AUDIT_ARCH_I386 depending
> on the syscall path.
> 
> Cc: linux-kernel@vger.kernel.org
> Cc: H. J. Lu <hjl.tools@gmail.com>
> Cc: Eric Paris <eparis@redhat.com>
> Signed-off-by: Philipp Kern <pkern@google.com>
> ---
>  arch/x86/kernel/ptrace.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
> index 678c0ad..166a3c7 100644
> --- a/arch/x86/kernel/ptrace.c
> +++ b/arch/x86/kernel/ptrace.c
> @@ -1489,7 +1489,7 @@ long syscall_trace_enter(struct pt_regs *regs)
>  
>  	if (IS_IA32)
>  		audit_syscall_entry(AUDIT_ARCH_I386,
> -				    regs->orig_ax,
> +				    regs->orig_ax & __SYSCALL_MASK,

This is weird.  Three questions:

1. How can this happen?  I thought that x32 syscalls always came in
through the syscall path, which doesn't set is_compat_task.  (Can
someone rename is_compat_task to in_compat_syscall?  Pretty please?)

2. Now audit can't tell whether a syscall is x32 or i386.  And audit is
inconsistent with seccomp.  This seems wrong.

3. The OOPS you're fixing doesn't seem like it's fixed.  What if some
other random high bits are set?

--Andy
