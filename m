Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab3H3JtF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 05:49:05 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:65017 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336Ab3H3JtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 05:49:03 -0400
Date: Fri, 30 Aug 2013 11:48:58 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <waiman.long@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
Message-ID: <20130830094857.GA14502@gmail.com>
References: <CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com>
 <1377751465.4028.20.camel@pasglop>
 <20130829070012.GC27322@gmail.com>
 <CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com>
 <CA+55aFx1oq7+jce8vLWRitASVMugCojYe3gmhXwhLx4K9Au3XQ@mail.gmail.com>
 <CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com>
 <52200DAE.2020303@hp.com>
 <CA+55aFyhTR15GBS4VNoRkcFyubEJU7a+Pzd-6VZeKoU8qB0q5Q@mail.gmail.com>
 <CA+icZUX3zQEWDoaXk0RMKmbQhDRo0Z7jGZ=9tJu1gZWvGodMkg@mail.gmail.com>
 <CA+icZUUDKExRW3iNXj6jTs8A4DwQNaWvPuUfV5_ExXNPzq=+rA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUUDKExRW3iNXj6jTs8A4DwQNaWvPuUfV5_ExXNPzq=+rA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sedat Dilek <sedat.dilek@gmail.com> wrote:

> On Fri, Aug 30, 2013 at 9:55 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> > On Fri, Aug 30, 2013 at 5:54 AM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> >> On Thu, Aug 29, 2013 at 8:12 PM, Waiman Long <waiman.long@hp.com> wrote:
> >>> On 08/29/2013 07:42 PM, Linus Torvalds wrote:
> >>>>
> >>>> Waiman? Mind looking at this and testing? Linus
> >>>
> >>> Sure, I will try out the patch tomorrow morning and see how it works out for
> >>> my test case.
> >>
> >> Ok, thanks, please use this slightly updated patch attached here.
> >>
> >> It improves on the previous version in actually handling the
> >> "unlazy_walk()" case with native lockref handling, which means that
> >> one other not entirely odd case (symlink traversal) avoids the d_lock
> >> contention.
> >>
> >> It also refactored the __d_rcu_to_refcount() to be more readable, and
> >> adds a big comment about what the heck is going on. The old code was
> >> clever, but I suspect not very many people could possibly understand
> >> what it actually did. Plus it used nested spinlocks because it wanted
> >> to avoid checking the sequence count twice. Which is stupid, since
> >> nesting locks is how you get really bad contention, and the sequence
> >> count check is really cheap anyway. Plus the nesting *really* didn't
> >> work with the whole lockref model.
> >>
> >> With this, my stupid thread-lookup thing doesn't show any spinlock
> >> contention even for the "look up symlink" case.
> >>
> >> It also avoids the unnecessary aligned u64 for when we don't actually
> >> use cmpxchg at all.
> >>
> >> It's still one single patch, since I was working on lots of small
> >> cleanups. I think it's pretty close to done now (assuming your testing
> >> shows it performs fine - the powerpc numbers are promising, though),
> >> so I'll split it up into proper chunks rather than random commit
> >> points. But I'm done for today at least.
> >>
> >> NOTE NOTE NOTE! My test coverage really has been pretty pitiful. You
> >> may hit cases I didn't test. I think it should be *stable*, but maybe
> >> there's some other d_lock case that your tuned waiting hid, and that
> >> my "fastpath only for unlocked case" version ends up having problems
> >> with.
> >>
> >
> > Following this thread with half an eye... Was that "unsigned" stuff
> > fixed (someone pointed to it).
> > How do you call that test-patch (subject)?
> > I would like to test it on my SNB ultrabook with your test-case script.
> >
> 
> Here on Ubuntu/precise v12.04.3 AMD64 I get these numbers for total loops:
> 
> lockref:  w/o patch | w/ patch
> ======================
> Run #1: 2.688.094 | 2.643.004
> Run #2: 2.678.884 | 2.652.787
> Run #3: 2.686.450 | 2.650.142
> Run #4: 2.688.435 | 2.648.409
> Run #5: 2.693.770 | 2.651.514
> 
> Average: 2687126,6 VS. 2649171,2 ( ???37955,4 )

For precise stddev numbers you can run it like this:

   perf stat --null --repeat 5 ./test

and it will measure time only and print the stddev in percentage:

 Performance counter stats for './test' (5 runs):

       1.001008928 seconds time elapsed                                          ( +-  0.00% )

Thanks,

	Ingo
