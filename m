Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274Ab3CBBcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 20:32:50 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:57261 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab3CBBct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 20:32:49 -0500
MIME-Version: 1.0
In-Reply-To: <1362183392.3420.23.camel@buesod1.americas.hpqcorp.net>
References: <1362183392.3420.23.camel@buesod1.americas.hpqcorp.net>
Date: Fri, 1 Mar 2013 17:32:48 -0800
X-Google-Sender-Auth: auUofABG1x6UDrMu8W8K2L8EXNg
Message-ID: <CA+55aFwNoK+Bt07s-fnxRSPHy3Cqq6yZtGP+B2ingxEnkArhVQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] ipc: do not hold ipc lock more than necessary
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, "Low, Jason" <jason.low2@hp.com>,
        linux-tip-commits@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, aquini@redhat.com,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 1, 2013 at 4:16 PM, Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:
>
> With Rik's semop-multi.c microbenchmark we can see the following
> results:

Ok, that certainly looks very good.

> +  59.40%            a.out  [kernel.kallsyms]  [k] _raw_spin_lock
> +  17.47%            a.out  [kernel.kallsyms]  [k] _raw_spin_lock

I had somewhat high expectations, but that's just better than I really
hoped for. Not only is the percentage down, it's down for the case of
a much smaller number of overall cycle cost, so it's a really big
reduction in contention spinning.

Of course, contention will come back and overwhelm you at *some*
point, but it seems the patches certainly moved the really bad
contention point out some way..

> +   6.14%            a.out  [kernel.kallsyms]  [k] sys_semtimedop
> +  11.08%            a.out  [kernel.kallsyms]  [k] sys_semtimedop
> While the _raw_spin_lock time is drastically reduced, others do increase.
> This results in an overall speedup of ~1.7x regarding ops/sec.

Actually, the others don't really increase. Sure, the *percentages* go
up, but that's just because it has to add up to 100% in the end. So
it's not that you're moving costs from one place to another - the 1.7x
speedup is the real reduction in costs, and then that 6.14% -> 11.08%
"growth" is really nothing but that (and yes, 1.7 x 6.14 really does
get pretty close).

So nothing really got slower, despite the percentages going up.

Looks good to me. Of course, the *real* issue is if this is a win on
real code too. And I bet it is, it just won't be quite as noticeable.
But if anything, real code is likely to have less contention to begin
with, because it has more things going on outside of the spinlocks. So
it should see an improvement, but not nearly the kind of improvement
you quote here.

Although your 800-user swingbench numbers were pretty horrible, so
maybe that case can improve by comparable amounts in the bad cases.

                Linus
