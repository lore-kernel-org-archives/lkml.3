Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759098Ab3AQG1V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 01:27:21 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:64949 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab3AQG1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 01:27:20 -0500
MIME-Version: 1.0
In-Reply-To: <1358379808-16449-1-git-send-email-alcooperx@gmail.com>
References: <1358379808-16449-1-git-send-email-alcooperx@gmail.com>
Date: Thu, 17 Jan 2013 07:27:19 +0100
X-Google-Sender-Auth: LkTbMTicR-wlVa3713-ojwaW_RA
Message-ID: <CAMuHMdUSRM6dauiRtSs20YVfHmNrROrc4RpZL+dKA_e2t82J6A@mail.gmail.com>
Subject: Re: [PATCH V2] mips: function tracer: Fix broken function tracing
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Al Cooper <alcooperx@gmail.com>
Cc: rostedt@goodmis.org, ddaney.cavm@gmail.com, ralf@linux-mips.org,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 12:43 AM, Al Cooper <alcooperx@gmail.com> wrote:
> Part of the sequence is "addiu sp,sp,-8" in the delay slot after every
> call to the trace routine "_mcount" (some legacy thing where 2 arguments
> used to be pushed on the stack). The _mcount routine is expected to
> adjust the sp by +8 before returning.

So when not disabled, the original jalr and addiu will be there, so _mcount has
to adjust sp.

> The problem is that when tracing is disabled for a function, the
> "jalr _mcount" instruction is replaced with a nop, but the
> "addiu sp,sp,-8" is still executed and the stack pointer is left
> trashed. When frame pointers are enabled the problem is masked
> because any access to the stack is done through the frame
> pointer and the stack pointer is restored from the frame pointer when
> the function returns.
>
> This patch writes two nops starting at the address of the "jalr _mcount"
> instruction whenever tracing is disabled. This means that the
> "addiu sp,sp.-8" will be converted to a nop along with the "jalr".

When disabled, there will be two nops.

> This is SMP safe because the first time this happens is during
> ftrace_init() which is before any other processor has been started.
> Subsequent calls to enable/disable tracing when other CPUs ARE running
> will still be safe because the enable will only change the first nop
> to a "jalr" and the disable, while writing 2 nops, will only be changing

When re-enabled, there will be a jalr and a nop, which differs from the initial
case, so _mcount doesn't have to adjust sp?

> @@ -69,7 +68,7 @@ NESTED(ftrace_caller, PT_SIZE, ra)
>         .globl _mcount
>  _mcount:
>         b       ftrace_stub
> -        nop
> +       addiu sp,sp,8
>         lw      t1, function_trace_stop
>         bnez    t1, ftrace_stub
>         nop

But _mcount will always adjust the stack pointer?
What am I missing?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
