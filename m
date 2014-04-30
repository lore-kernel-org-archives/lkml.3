Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946023AbaD3Unk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 16:43:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54091 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945975AbaD3Unj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 16:43:39 -0400
Message-ID: <5361605B.4080509@zytor.com>
Date: Wed, 30 Apr 2014 13:43:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Hui Zhu <hui_zhu@mentor.com>, Hui Zhu <teawater@gmail.com>,
        Mark Kettenis <mark.kettenis@xs4all.nl>
CC: pinskia@gmail.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org, eparis@redhat.com,
        ak@linux.intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gdb@sourceware.org" <gdb@sourceware.org>,
        Pedro Alves <palves@redhat.com>
Subject: Re: [PATCH] Fix get ERESTARTSYS with m32 in x86_64 when debug by
 GDB
References: <CANFwon0oLO+qCtpewc=BxKBOm05aBMpV=yG0CxwW1isWHfnZqw@mail.gmail.com> <53554846.3070608@zytor.com> <CANFwon3zA9FMujmnN3nMiv8Zr8bU9o72XXa26dkePNq57U=JcQ@mail.gmail.com> <53608125.2020103@zytor.com> <CA+=Sn1=y-smZOaD_yRxEwgu-PPaZYdQtB_RGPCA5-9wmB6=hvQ@mail.gmail.com> <536085B7.5070002@zytor.com> <201404301335.s3UDZX4J017978@glazunov.sibelius.xs4all.nl> <CANFwon1OnRmXChO_uYa=ftJc8NqmvV7CRdM6hrWeyqXYUt417Q@mail.gmail.com> <53612647.1040604@mentor.com>
In-Reply-To: <53612647.1040604@mentor.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2014 09:35 AM, Hui Zhu wrote:
> 
> I sorry that previous patch has some format issue, post a new one.
> 
> Signed-off-by: Hui Zhu <hui@codesourcery.com>
> ---
> --- a/arch/x86/kernel/ptrace.c
> +++ b/arch/x86/kernel/ptrace.c
> @@ -452,6 +452,23 @@ static int putreg(struct task_struct *ch
>          if (child->thread.gs != value)
>              return do_arch_prctl(child, ARCH_SET_GS, value);
>          return 0;
> +    case offsetof(struct user_regs_struct, orig_ax):
> +        /*
> +         * A 64-bit debugger setting orig_ax of a 32-bit inferior
> +         * means to restore the state of the task restarting a
> +         * 32-bit syscall.
> +         * Make sure we interpret the -ERESTART* codes correctly
> +         * in case the task is not actually still sitting at the
> +         * exit from a 32-bit syscall with TS_COMPAT still set.
> +         */
> +        if (test_ti_thread_flag(task_thread_info(child), TIF_IA32)) {
> +            struct pt_regs *regs = task_pt_regs(child);
> +            regs->orig_ax = value;
> +            if (syscall_get_nr(child, regs) >= 0)
> +                task_thread_info(child)->status |= TS_COMPAT;
> +            return 0;
> +        }
> +        break;
>  #endif
>      }

You still seems to have botched whitespace, and no patch description in
the same email so it can be automated.

	-hpa

