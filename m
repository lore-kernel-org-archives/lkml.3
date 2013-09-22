Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab3IVWWy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 18:22:54 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:38159 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab3IVWWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 18:22:53 -0400
MIME-Version: 1.0
In-Reply-To: <1379887000.24090.19.camel@pasglop>
References: <1379620267-25191-1-git-send-email-fweisbec@gmail.com>
	<CA+55aFyXf370Ds6FH5wPPycZLSPD5qiP7rjWqxwDetfHfKjg1w@mail.gmail.com>
	<alpine.DEB.2.02.1309201244080.4089@ionos.tec.linutronix.de>
	<20130920162603.GA30381@localhost.localdomain>
	<CA+55aFyBcjP2U6ipzZay=FdhzA4oFNwE4tU0OcJJhwFvgoeALw@mail.gmail.com>
	<CAFTL4hzucS5nJbCrArPv9zfY=QpyUESMK2Th0tKFHVCjDP7-eA@mail.gmail.com>
	<1379799901.24090.6.camel@pasglop>
	<523E4F8A.7020708@zytor.com>
	<1379824754.24090.11.camel@pasglop>
	<1379824861.24090.12.camel@pasglop>
	<20130922162410.GA10649@laptop.programming.kicks-ass.net>
	<1379887000.24090.19.camel@pasglop>
Date: Sun, 22 Sep 2013 15:22:52 -0700
X-Google-Sender-Auth: gMQLXrMyDFZvFjpgi2h7xrefrD0
Message-ID: <CA+55aFwaf_Wst=AS75ydBJVQ6aJxPfAzXdt-UXj3qC9WeUt7kw@mail.gmail.com>
Subject: Re: [RFC GIT PULL] softirq: Consolidation and stack overrun fix
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@au1.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 22, 2013 at 2:56 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Sun, 2013-09-22 at 18:24 +0200, Peter Zijlstra wrote:
>>
>> We use a segment offset. Something like:
>>
>>   inc %gs:var;
>>
>
> And gcc makes no stupid assumptions that this gs doesn't change ? That's
> the main problem we have with using r13 for PACA.

Since gcc doesn't really know about segment registers at all (modulo
%fs as TLS on x86), we do everything like that using inline asm.

It's not *too* painful if you have a number of macro helpers to build
up all the different versions.

And r13 isn't volatile if you are preempt-safe, so I'm wondering if
you could just make the preempt disable code mark %r13 as modified
("+r"). Then gcc won't ever cache r13 across one of those. And if you
don't have preemption disabled, then you cannot do multiple ops using
%r13 anyway, since on a load-store architecture it might change even
between the load and store, so a per-cpu "add" operation *has* to
cache the %r13 value in *another* register anyway, because using
memory ops with just an offset off %r13 would be buggy.

So I don't think this is a gcc issue. gcc can't fix those kinds of problems.

Personally, I'd suggest something like:

 - the paca stuff is just insane. Try to get rid of it.

 - use %r13 for the per-thread thread-info pointer instead. A
per-thread pointer is *not* volatile like the per-cpu base is.

 - Now you can make the per-cpu offset be loaded off the per-thread
pointer (update it at context switch). gcc knows to not cache it
across function calls, since it's a memory access. Use ACCESS_ONCE()
or something to make sure it's only loaded once for the cpu offset
ops.

Alternatively, make %r13 point to the percpu side, but make sure that
you always use an asm accessor to fetch the value. In particular, I
think you need to make __my_cpu_offset be an inline asm that fetches
%r13 into some other register. Otherwise you can never get it right.

             Linus
