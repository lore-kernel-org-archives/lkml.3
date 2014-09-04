Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbaIDQwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:52:20 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:46116 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351AbaIDQwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:52:09 -0400
MIME-Version: 1.0
In-Reply-To: <20140904134201.GA3312@redhat.com>
References: <20140904134135.GA3309@redhat.com> <20140904134201.GA3312@redhat.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Thu, 4 Sep 2014 18:51:49 +0200
Message-ID: <CAK1hOcMmOi4vNPrLUtZwtStbs52r15n+h8h+aKCNxTJ1dkOwpg@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86: reimplement ___preempt_schedule*() using THUNK helpers
To: Oleg Nesterov <oleg@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@amacapital.net>,
        Denys Vlasenko <dvlasenk@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, X86 ML <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2014 at 3:42 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> -#ifdef CONFIG_TRACE_IRQFLAGS
>         /* put return address in eax (arg1) */
> -       .macro thunk_ra name,func
> +       .macro thunk_ra name, func, put_ret_addr_in_eax=0
>         .globl \name
>  \name:
>         pushl %eax
>         pushl %ecx
>         pushl %edx
> +
> +       .if \put_ret_addr_in_eax
>         /* Place EIP in the arg1 */
>         movl 3*4(%esp), %eax
> +       .endif
> +
>         call \func
>         popl %edx
>         popl %ecx
> @@ -25,6 +28,15 @@
>         _ASM_NOKPROBE(\name)
>         .endm
>
> -       thunk_ra trace_hardirqs_on_thunk,trace_hardirqs_on_caller
> -       thunk_ra trace_hardirqs_off_thunk,trace_hardirqs_off_caller
> +#ifdef CONFIG_TRACE_IRQFLAGS
> +       thunk_ra trace_hardirqs_on_thunk,trace_hardirqs_on_caller,1
> +       thunk_ra trace_hardirqs_off_thunk,trace_hardirqs_off_caller,1
> +#endif
> +
> +#ifdef CONFIG_PREEMPT
> +       THUNK ___preempt_schedule, preempt_schedule
> +#ifdef CONFIG_CONTEXT_TRACKING
> +       THUNK ___preempt_schedule_context, preempt_schedule_context
>  #endif
> +#endif


I think THUNK should be thunk_ra here;
or thunk_ra should be renamed to THUNK (like it is in thunk_64.S)
