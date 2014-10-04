Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761066AbaJDALk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:11:40 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:62632 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759533AbaJDALY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 20:11:24 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwT3KFkGMgWz9Gag+xMHD=5X3RNz-iMswGD88_wnUT-Eg@mail.gmail.com>
References: <20140921184153.GA23727@redhat.com>
	<tip-0ad6e3c5199be12c9745da8f8b9e3c9f8066c235@git.kernel.org>
	<542E2B05.5080607@oracle.com>
	<20141003232631.GA3439@redhat.com>
	<CA+55aFwT3KFkGMgWz9Gag+xMHD=5X3RNz-iMswGD88_wnUT-Eg@mail.gmail.com>
Date: Fri, 3 Oct 2014 17:11:23 -0700
X-Google-Sender-Auth: wBtwuC25EscdShCEv_e0Z-rtAbQ
Message-ID: <CA+55aFxBAFMxAsSvgOcVuWy4FWH77E4NT8M3SYvQzxGBJ_qkHw@mail.gmail.com>
Subject: Re: [tip:x86/asm] x86: Speed up ___preempt_schedule*() by using THUNK helpers
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Anvin <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Chuck Ebbert <cebbert.lkml@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 3, 2014 at 5:01 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> The real fix would appear to be to use
> "preempt_enable_no_resched_notrace()", which your patch did, but
> without the loop.

Actually, the real fix would be to not be stupid, and just make the
code do something like

>        if (likely(!preemptible()))
>                return;
>
>         __preempt_count_add(PREEMPT_ACTIVE);
>         prev_ctx = exception_enter();
>
>         __schedule();
>
>         exception_exit(prev_ctx);
>         __preempt_count_sub(PREEMPT_ACTIVE);

and *not* enable preemption around the scheduling at all. The whole
enable and then re-disable seems entirely broken, and comes from the
code using "preempt_schedule()" which doesn't work while preemption is
disabled. So don't do that then.

No?

               Linus
