Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbaGPUII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 16:08:08 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:41085 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbaGPUIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 16:08:05 -0400
MIME-Version: 1.0
In-Reply-To: <3bee564fe07150f11d2e5078d457b6aacde43bec.1405452484.git.luto@amacapital.net>
References: <cover.1405452484.git.luto@amacapital.net>
	<3bee564fe07150f11d2e5078d457b6aacde43bec.1405452484.git.luto@amacapital.net>
Date: Wed, 16 Jul 2014 13:08:03 -0700
Message-ID: <CAMEtUuywjY8habDJJWyDZLBWtXZXDqpmn2hZ9Dts1hrQ7OWXnA@mail.gmail.com>
Subject: Re: [PATCH 6/7] x86_64,entry: Treat regs->ax the same in fastpath and
 slowpath syscalls
From: Alexei Starovoitov <ast@plumgrid.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Oleg Nesterov <oleg@redhat.com>, X86 ML <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 12:32 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> For slowpath syscalls, we initialize regs->ax to -ENOSYS and stick
> the syscall number into regs->orig_ax prior to any possible tracing
> and syscall execution.  This is user-visible ABI used by ptrace
> syscall emulation and seccomp.
>
> For fastpath syscalls, there's no good reason not to do the same
> thing.  It's even slightly simpler than what we're currently doing.
> It probably has no measureable performance impact.  It should have
> no user-visible effect.
>
> The purpose of this patch is to prepare for seccomp-based syscall
> emulation in the fast path.  This change is just subtle enough that
> I'm keeping it separate.
>
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
>  arch/x86/include/asm/calling.h |  6 +++++-
>  arch/x86/kernel/entry_64.S     | 11 +++--------
>  2 files changed, 8 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/include/asm/calling.h b/arch/x86/include/asm/calling.h
> index cb4c73b..76659b6 100644
> --- a/arch/x86/include/asm/calling.h
> +++ b/arch/x86/include/asm/calling.h
> @@ -85,7 +85,7 @@ For 32-bit we have the following conventions - kernel is built with
>  #define ARGOFFSET      R11
>  #define SWFRAME                ORIG_RAX
>
> -       .macro SAVE_ARGS addskip=0, save_rcx=1, save_r891011=1
> +       .macro SAVE_ARGS addskip=0, save_rcx=1, save_r891011=1, rax_enosys=0
>         subq  $9*8+\addskip, %rsp
>         CFI_ADJUST_CFA_OFFSET   9*8+\addskip
>         movq_cfi rdi, 8*8
> @@ -96,7 +96,11 @@ For 32-bit we have the following conventions - kernel is built with
>         movq_cfi rcx, 5*8
>         .endif
>
> +       .if \rax_enosys
> +       movq $-ENOSYS, 4*8(%rsp)
> +       .else
>         movq_cfi rax, 4*8
> +       .endif
>
>         .if \save_r891011
>         movq_cfi r8,  3*8
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index b25ca96..432c190 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -405,8 +405,8 @@ GLOBAL(system_call_after_swapgs)
>          * and short:
>          */
>         ENABLE_INTERRUPTS(CLBR_NONE)
> -       SAVE_ARGS 8,0
> -       movq  %rax,ORIG_RAX-ARGOFFSET(%rsp)
> +       SAVE_ARGS 8, 0, rax_enosys=1
> +       movq_cfi rax,(ORIG_RAX-ARGOFFSET)

I think changing store rax to macro is unnecessary,
since it breaks common style of asm with the next line:
>         movq  %rcx,RIP-ARGOFFSET(%rsp)
Also it made the diff harder to grasp.

The change from the next patch 7/7:

> -       ja   int_ret_from_sys_call      /* RAX(%rsp) set to -ENOSYS above */
> +       ja   int_ret_from_sys_call      /* RAX(%rsp) is already set */

probably belongs in this 6/7 patch as well.

The rest look good to me. I think it's a big improvement in readability
comparing to v1.
