Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291AbaBFP54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 10:57:56 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:55560 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbaBFP5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 10:57:54 -0500
MIME-Version: 1.0
In-Reply-To: <1388728091-18564-15-git-send-email-zheng.z.yan@intel.com>
References: <1388728091-18564-1-git-send-email-zheng.z.yan@intel.com>
	<1388728091-18564-15-git-send-email-zheng.z.yan@intel.com>
Date: Thu, 6 Feb 2014 16:57:54 +0100
Message-ID: <CABPqkBQsR7ZZ86vHVD3xKcydzSoaGw1tQkT4gQbu4LGz126OgA@mail.gmail.com>
Subject: Re: [PATCH 14/14] perf, x86: Discard zero length call entries in LBR
 call stack
From: Stephane Eranian <eranian@google.com>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 3, 2014 at 6:48 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
> "Zero length call" uses the attribute of the call instruction to push
> the immediate instruction pointer on to the stack and then pops off
> that address into a register. This is accomplished without any matching
> return instruction. It confuses the hardware and make the recorded call
> stack incorrect. Try fixing the call stack by discarding zero length
> call entries.
>
So on this one you're saying LBR_CALLSTACK will not pop the return in
this case. And therefore the call remains the in LBR register buffer. The
kernel can look for those and remove them because you can detect them
by the call encoding.

Reviewed-by: Stephane Eranian <eranian@google.com>
> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel_lbr.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> index 08e3ba1..57bdd34 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> @@ -94,7 +94,8 @@ enum {
>         X86_BR_ABORT            = 1 << 12,/* transaction abort */
>         X86_BR_IN_TX            = 1 << 13,/* in transaction */
>         X86_BR_NO_TX            = 1 << 14,/* not in transaction */
> -       X86_BR_CALL_STACK       = 1 << 15,/* call stack */
> +       X86_BR_ZERO_CALL        = 1 << 15,/* zero length call */
> +       X86_BR_CALL_STACK       = 1 << 16,/* call stack */
>  };
>
>  #define X86_BR_PLM (X86_BR_USER | X86_BR_KERNEL)
> @@ -111,13 +112,15 @@ enum {
>          X86_BR_JMP      |\
>          X86_BR_IRQ      |\
>          X86_BR_ABORT    |\
> -        X86_BR_IND_CALL)
> +        X86_BR_IND_CALL |\
> +        X86_BR_ZERO_CALL)
>
>  #define X86_BR_ALL (X86_BR_PLM | X86_BR_ANY)
>
>  #define X86_BR_ANY_CALL                 \
>         (X86_BR_CALL            |\
>          X86_BR_IND_CALL        |\
> +        X86_BR_ZERO_CALL       |\
>          X86_BR_SYSCALL         |\
>          X86_BR_IRQ             |\
>          X86_BR_INT)
> @@ -652,6 +655,12 @@ static int branch_type(unsigned long from, unsigned long to, int abort)
>                 ret = X86_BR_INT;
>                 break;
>         case 0xe8: /* call near rel */
> +               insn_get_immediate(&insn);
> +               if (insn.immediate1.value == 0) {
> +                       /* zero length call */
> +                       ret = X86_BR_ZERO_CALL;
> +                       break;
> +               }
>         case 0x9a: /* call far absolute */
>                 ret = X86_BR_CALL;
>                 break;
> --
> 1.8.4.2
>
