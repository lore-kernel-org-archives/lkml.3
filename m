Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab3IBQoh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 12:44:37 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:43771 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557Ab3IBQoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 12:44:34 -0400
MIME-Version: 1.0
In-Reply-To: <20130902070538.GA31639@gmail.com>
References: <CA+55aFxwjx30pC=kcfvOzgJvt2KK9DLm2i6JKYYz+mtOOJEnMA@mail.gmail.com>
	<CA+icZUUwy=sbt6BOirH6N4mSrQOykb=Z3GSdCb7vy_eVfG2RYw@mail.gmail.com>
	<CA+55aFwU054C+zC+G+JrF4ngWvVmvD9WPGWaT_2=nF2j7bpHxA@mail.gmail.com>
	<CA+55aFyc17miqwhncAKsanPQ9fHX_czQx+g-a9At_S1-XNpyKA@mail.gmail.com>
	<20130901212355.GU13318@ZenIV.linux.org.uk>
	<CA+55aFzkZi6Q1bwSZUJxyfqUgLS05icjrObdCxC+4S-3Tup9Ew@mail.gmail.com>
	<CA+55aFzsXwFkYsWY45ZNTaVFC+-1Yh9nxx=NLhv+NxGmQAKHTg@mail.gmail.com>
	<20130901233005.GX13318@ZenIV.linux.org.uk>
	<CA+55aFyzas75yYP+AiwOxsAg5sG3KU+KEmO+ny=dn0-jxqUt5Q@mail.gmail.com>
	<CA+55aFyodR650Y8yXXenH1XHo-__5avng1WSK=AiSJx4mYy25g@mail.gmail.com>
	<20130902070538.GA31639@gmail.com>
Date: Mon, 2 Sep 2013 09:44:33 -0700
X-Google-Sender-Auth: jXA0hIKwitHtouRqI07pqX4xm5Q
Message-ID: <CA+55aFyCBoeqceQcxA3JZ-k8a4uLbHf3N4rNmTZ4oh9XA7akEA@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Sedat Dilek <sedat.dilek@gmail.com>,
        Waiman Long <waiman.long@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 2, 2013 at 12:05 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> The Haswell perf code isn't very widely tested yet as it took quite some
> time to get it ready for upstream and thus got merged late, but on its
> face this looks like a pretty good profile.

Yes. And everything else looks fine too. Profiles without locked
instructions all look very reasonable, and have the expected patterns.

\> It still looks anomalous to me, on fresh Intel hardware. One suggestion:
> could you, just for pure testing purposes, turn HT off and do a quick
> profile that way?
>
> The XADD, even if it's all in the fast path, could be a pretty natural
> point to 'yield' an SMT context on a given core, giving it artificially
> high overhead.
>
> Note that to test HT off an intrusive reboot is probably not needed, if
> the HT siblings are right after each other in the CPU enumeration sequence
> then you can turn HT "off" effectively by running the workload only on 4
> cores:
>
>   taskset 0x55 ./my-test
>
> and reducing the # of your workload threads to 4 or so.

Remember: I see the exact same profile for single-thread behavior.
Other things change (iow, lockref_get_or_lock() is either ~3% or ~30%
- the latter case is for when there are bouncing cachelines), but
lg_local_lock() stays pretty constant.

So it's not a HT artifact or anything like that.

I've timed "lock xadd" separately, and it's not a slow instruction. I
also tried (in user space, using thread-local storage) to see if it's
the combination of creating the address through a segment load and
that somehow causing a micro-exception or something (the P4 used to
have things like that), and that doesn't seem to account for it
either.

It is entirely possible that it is just a "cycles:pp" oddity - because
the "lock xadd" is serializing, it can't retire until everything
around it has been sorted out, and maybe it just shows up in profiles
more than is really "fair" to the instruction itself, because it ends
up being that stable point for potentially hundreds of instructions
around it.

                 Linus
