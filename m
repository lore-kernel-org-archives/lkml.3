Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092Ab3LSUqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 15:46:42 -0500
Received: from mail-ve0-f179.google.com ([209.85.128.179]:64118 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756743Ab3LSUqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 15:46:38 -0500
MIME-Version: 1.0
In-Reply-To: <20131219204051.GA2253@gmail.com>
References: <CA+55aFzGxcML7j8CEvQPYzh0W81uVoAAVmGctMOUZ7CZ1yYd2A@mail.gmail.com>
	<tip-7e98b71920464b8d15fa95c74366416cd3c88861@git.kernel.org>
	<20131219204051.GA2253@gmail.com>
Date: Fri, 20 Dec 2013 05:46:37 +0900
X-Google-Sender-Auth: Xh2BRuOUkbKeTOG7DA-y6-KI68o
Message-ID: <CA+55aFyr5VcONQKp_yDRDy+BFpMy9=P--+U8d1uYeDVNWcAM8Q@mail.gmail.com>
Subject: Re: [tip:x86/idle] x86, idle: Use static_cpu_has() for CLFLUSH
 workaround, add barriers
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Anvin <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Anvin <hpa@linux.intel.com>, Len Brown <len.brown@intel.com>,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 5:40 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> The first mb() looks superfluous, because see
> current_set_polling_and_test():
>
> static inline bool __must_check current_set_polling_and_test(void)
> {
>         __current_set_polling();
>
>         /*
>          * Polling state must be visible before we test NEED_RESCHED,
>          * paired by resched_task()
>          */
>         smp_mb();
>
>         return unlikely(tif_need_resched());
> }
>
> So it already has a (MFENCE) barrier after ->flags is modified.

So what?

The mb() isn't necessarily against the *write*, it is also against the *read*.

If the cflush is needed before the monitor, it's likely because the
monitor instruction has some bug with already-existing cachelines in
shared state or whatever.

Which means that we want to make sure that the cflush is ordered wrt
*reads* from that cacheline too.

cflush has nothing specifically to do with writes.

             Linus
