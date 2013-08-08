Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab3HHQZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 12:25:56 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:61239 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab3HHQZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 12:25:55 -0400
MIME-Version: 1.0
In-Reply-To: <20130808154107.GA28971@redhat.com>
References: <CA+55aFwTX47vLvZckozZub0rUEo-aCBe7weqe=4mfQGfrW7NUA@mail.gmail.com>
	<CAMP44s2bOniz4qx5y9h4ppHRUjiPVGL+igSwO5NUJd4zpObxFw@mail.gmail.com>
	<20130806154314.GA398@redhat.com>
	<CANOLnOMPhOH5uUBqWwV-YNSeA_YHxL_dDa0ftL4jcWRgGwkfiQ@mail.gmail.com>
	<CA+55aFxt1iqJXW=bsETugWVxj9LwZXkq0FT836YMJVsRP9juEQ@mail.gmail.com>
	<20130807192734.GA8395@redhat.com>
	<CA+55aFw7P7LYNFQzy6nrn9DDn5a0UdYYQNx_7sibShvZPLEcmg@mail.gmail.com>
	<20130808154107.GA28971@redhat.com>
Date: Thu, 8 Aug 2013 09:25:54 -0700
X-Google-Sender-Auth: V6wqyeQFvgqkB5WMrdCKuUms35g
Message-ID: <CA+55aFybUdO10FVZPTbWyUE4eKxiEPYD0N=ZwHkOUNJbCvyT=w@mail.gmail.com>
Subject: Re: [PATCH 0/1] (Was: Linux 3.11-rc4)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Grazvydas Ignotas <notasas@gmail.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Denys Vlasenko <dvlasenk@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 8, 2013 at 8:41 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> On x86 execute breakpoints are only a single byte, which has to be
> the first byte of the instruction. IOW the hardware requires len = 1
> in dr7 or it doesn't work (iirc).
>
> But for some reason perf requires bp_len = sizeof(long), not 1. And
> note that it sets info->len = X86_BREAKPOINT_LEN_X. The comment says:
>
>         x86 inst breakpoints need to have a specific undefined len
>
> but despite its "special" name LEN_X is simply LEN_1, and other code
> relies on this fact.
>
> Now, ptrace correctly requires DR_LEN_1. So arch_bp_generic_fields()
> translates this into "gen_len = sizeof(long)" for validation.

Yeah, that just sounds insane. I suspect it's some misguided attempt
to be compatible either with some broken old version of perf. But if
so, I agree that the compatibility code should be elsewhere, and not
in "let's turn the _correct_ length of 1 into some random crap because
we screwed up elsewhere".

>> But the kernel address checking definitely needs to stay around for
>> security reasons.
>
> Sure. And btw it doesn't look right. I sent the patch below twice (iirc),
> perhaps I should resend it again.

Your patch looks correct.

That said,

> -       return (va >= TASK_SIZE) && ((va + len - 1) >= TASK_SIZE);
> +       return (va >= TASK_SIZE) || ((va + len - 1) >= TASK_SIZE);

I'd much rather make this be more clearly about overflow, and write
this as something like

    last = va + len - 1;
    /* Check for overflow too */
    if (last < va || end >= TASK_SIZE)

because quite frankly, the "va >= TASK_SIZE" check is kind of insane.
It makes very little semantic sense. The rewritten test can be seen as
two independent tests that both make sense individually (the first
checks for overflow, the second checks that the range isn't in kernel
space).

In fact, the overflow check could/should even be done in generic code,
methinks. There's nothing architecture-specific about that.

                   Linus
