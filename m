Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005Ab3H3Smh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 14:42:37 -0400
Received: from mail-vb0-f44.google.com ([209.85.212.44]:47934 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633Ab3H3Smg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 14:42:36 -0400
MIME-Version: 1.0
In-Reply-To: <20130830121227.3915ffb3@gandalf.local.home>
References: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com>
	<1375758759-29629-2-git-send-email-Waiman.Long@hp.com>
	<CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com>
	<1377751465.4028.20.camel@pasglop>
	<20130829070012.GC27322@gmail.com>
	<CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com>
	<CA+55aFx1oq7+jce8vLWRitASVMugCojYe3gmhXwhLx4K9Au3XQ@mail.gmail.com>
	<CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com>
	<52200DAE.2020303@hp.com>
	<CA+55aFyhTR15GBS4VNoRkcFyubEJU7a+Pzd-6VZeKoU8qB0q5Q@mail.gmail.com>
	<CA+icZUX3zQEWDoaXk0RMKmbQhDRo0Z7jGZ=9tJu1gZWvGodMkg@mail.gmail.com>
	<CA+icZUUDKExRW3iNXj6jTs8A4DwQNaWvPuUfV5_ExXNPzq=+rA@mail.gmail.com>
	<CA+55aFxvEjdEFK0dXn783eVN0PEXVhb5k8OnrbxSWDpXgyTwWw@mail.gmail.com>
	<CA+icZUXcn6-A+AW5bu_pfRdOcScsNyn3-OZe6n93S5NUEzHtcg@mail.gmail.com>
	<20130830121227.3915ffb3@gandalf.local.home>
Date: Fri, 30 Aug 2013 11:42:35 -0700
X-Google-Sender-Auth: AAdH6ybb7aIIjzgiAqujuAIWg5Y
Message-ID: <CA+55aFzjrBpa-YhC5tFKqS-sYjoJ=PcebeVfz1PUqXz1_eEVjA@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Sedat Dilek <sedat.dilek@gmail.com>, Waiman Long <waiman.long@hp.com>,
        Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 9:12 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Now I know this isn't going to be popular, but I'll suggest it anyway.
> What about only implementing the lockref locking when CPUs are greater
> than 7, 7 or less will still use the normal optimized spinlocks.

I considered it. It's not hugely difficult to do, in that we could
make it a static key thing, but I'd actually rather make it depend on
some actual user-settable thing than on some arbitrary number of
cpu's.

See the CMPXCHG_LOOP() macro in lib/lockref.c: it would be easy to
just enclose the whole thing in a

    if (static_key_enabled(&cmpxchg_lockref)) { .. }

and then it could be enabled/disabled at will with very little
performance downside. And I don't think it's necessarily a bad idea.
The code has a very natural "fall back to spinlock" model.

THAT SAID.

Even though uncontended spinlocks are faster than a cmpxchg, under any
real normal load I don't think you can necessarily measure the
difference. Remember: this particular benchmark does absolutely
*nothing* but pathname lookups, and even then it's pretty close to
noise. And the biggest disadvantage of cmpxchg - the fact that you
have to read the cache line before you do the r-m-w cycle, and thus
might have an extra cache coherency cycle - shouldn't be an issue for
the dentry use when you don't try to hit the same dentry over and over
again, because the code has already read the dentry hash etc.

So I'm not sure it's really worth it. It might be interesting to try
that static_key approach simply for benchmarking, though. That way you
could benchmark the exact same boot with pretty much the exact same
dentry population, just switch the static key around and run a few
path-intensive benchmarks.

If anybody is willing to write the patch and do the benchmarking (I
would suggest *not* using my idiotic test-program for this), and then
send it to me with numbers, that would be interesting...

                   Linus
