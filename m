Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413Ab3G0A3s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 20:29:48 -0400
Received: from mail-vb0-f47.google.com ([209.85.212.47]:47832 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab3G0A3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 20:29:45 -0400
MIME-Version: 1.0
In-Reply-To: <20130726232852.GA15147@linux.vnet.ibm.com>
References: <20130726232852.GA15147@linux.vnet.ibm.com>
Date: Fri, 26 Jul 2013 17:29:44 -0700
X-Google-Sender-Auth: NtYnp615e0j6hpcEQlMyQ-81fpI
Message-ID: <CA+55aFx_+hLT8Ze2Aihjow660vxyfnqCL9T+xQRw-mbmdA39xA@mail.gmail.com>
Subject: Re: [PATCH RFC fs] v2 Make sync() satisfy many requests with one invocation
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        Jan Kara <jack@suse.cz>, curtw@google.com,
        Jens Axboe <jaxboe@fusionio.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 4:28 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> +
> +       snap = ACCESS_ONCE(sync_seq);
> +       smp_mb();  /* Prevent above from bleeding into critical section. */
> +       mutex_lock(&sync_mutex);
> +       snap_done = ACCESS_ONCE(sync_seq);
> +       if (ULONG_CMP_GE(snap_done, ((snap + 1) & ~0x1) + 2)) {

Ugh. I dislike this RCU'ism. It's bad code. It doesn't just look ugly
and complex, it's also not even clever.

It is possible that the compiler can fix up this horrible stuff and
turn it into the nice clever stuff, but I dunno.

The two things that make me go "Eww":

 - "((snap + 1) & ~0x1) + 2" just isn't the smart way of doing things.
Afaik, "(snap+3)&~1" gives the same answer with a simpler arithmetic.

 - that ULONG_CMP_GE() macro is disgusting. What's wrong with doing it
the sane way, which is how (for example) the time comparison functions
do it (see time_before() and friends): Just do it

     ((long)(a-b) >= 0)

   which doesn't need large constants.

And yeah, a smart compiler will hopefully do one or both of those, but
what annoys me about the source code is that it actually isn't even
any more readable despite being more complicated and needing more
compiler tricks for good code generation.

So that one line is (a) totally undocumented, (b) not obvious and (c)
not very clever.

I'm also not a huge believer in those two WARN_ON_ONCE's you have. The
sequence count is *only* updated in this place, it is *only* updated
inside a lock, and dammit, if those tests ever trigger, we have bigger
problems than that piece of code. Those warnings may make sense in
code when you write it the first time (because you're thinking things
through), but they do *not* make sense at the point where that code is
actually committed to the project. I notice that you have those
warnings in the RCU code itself, and I don't really think they make
sense there either.

Finally, the ACCESS_ONCE() is also only correct in the one place where
you do the access speculatively outside the lock. Inside the lock,
there is no excuse/reason for them, since the value is stable, and you
need the memory barriers anyway, so there's no way the compiler could
migrate things regardless. So the other two ACCESS_ONCE calls are
actually misleading and wrong, and only likely to make the compiler
generate much worse code.

In fact, the ACCESS_ONCE() is pretty much *guaranteed* to cause the
compiler to unnecessarily generate worse code, since there is
absolutely no reason why the compiler couldn't reuse the "snap_done"
value it reads when it then does the "sync_seq++". There's no way the
value could possible have changed from the "snap_done" value earlier,
since we're inside the lock, so why force the compiler to reload it?

In short, I think the code does too much. I'm sure it works, but I
think it might make people believe that the extra work (like those
later ACCESS_ONCE ones) is meaningful, when it isn't. It's just
make-believe, afaik.

But maybe I'm missing something, and there actually *is* reason for
the extra work/complexity?

                 Linus
