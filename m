Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061Ab3IBHFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 03:05:45 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:52973 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609Ab3IBHFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 03:05:43 -0400
Date: Mon, 2 Sep 2013 09:05:38 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
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
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
Message-ID: <20130902070538.GA31639@gmail.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyodR650Y8yXXenH1XHo-__5avng1WSK=AiSJx4mYy25g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sun, Sep 1, 2013 at 5:12 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > It *is* one of the few locked accesses remaining, and it's clearly
> > getting called a lot (three calls per system call: two mntput's  - one
> > for the root path, one for the result path, and one from path_init ->
> > rcu_walk_init), but with up to 8% CPU time for basically that one
> > "lock xadd" instruction is damn odd. I can't see how that could happen
> > without seriously nasty cacheline bouncing, but I can't see how *that*
> > can happen when all the accesses seem to be from the current CPU.
> 
> So, I wanted to double-check that "it can only be that expensive if
> there's cacheline bouncing" statement. Thinking "maybe it's just
> really expensive. Even when running just a single thread".
> 
> So I set MAX_THREADS to 1 in my stupid benchmark, just to see what happens..
> 
> And almost everything changes as expected: now we don't have any
> cacheline bouncing any more, so lockref_put_or_lock() and
> lockref_get_or_lock() no longer dominate - instead of being 20%+ each,
> they are now just 3%.
> 
> What _didn't_ change? Right. lg_local_lock() is still 6.40%. Even when
> single-threaded. It's now the #1 function in my profile:
> 
>    6.40%   lg_local_lock
>    5.42%   copy_user_enhanced_fast_string
>    5.14%   sysret_check
>    4.79%   link_path_walk
>    4.41%   0x00007ff861834ee3
>    4.33%   avc_has_perm_flags
>    4.19%   __lookup_mnt
>    3.83%   lookup_fast
> 
> (that "copy_user_enhanced_fast_string" is when we copy the "struct
> stat" from kernel space to user space)
> 
> The instruction-level profile just looking like
> 
>        ???    ffffffff81078e70 <lg_local_lock>:
>   2.06 ???      push   %rbp
>   1.06 ???      mov    %rsp,%rbp
>   0.11 ???      mov    (%rdi),%rdx
>   2.13 ???      add    %gs:0xcd48,%rdx
>   0.92 ???      mov    $0x100,%eax
>  85.87 ???      lock   xadd   %ax,(%rdx)
>   0.04 ???      movzbl %ah,%ecx
>        ???      cmp    %al,%cl
>   3.60 ???    ??? je     31
>        ???      nop
>        ???28:   pause
>        ???      movzbl (%rdx),%eax
>        ???      cmp    %cl,%al
>        ???    ??? jne    28
>        ???31:   pop    %rbp
>   4.22 ???    ??? retq

The Haswell perf code isn't very widely tested yet as it took quite some 
time to get it ready for upstream and thus got merged late, but on its 
face this looks like a pretty good profile.

With one detail:

> so that instruction sequence is just expensive, and it is expensive 
> without any cacheline bouncing. The expense seems to be 100% simply due 
> to the fact that it's an atomic serializing instruction, and it just 
> gets called way too much.
> 
> So lockref_[get|put]_or_lock() are each called once per pathname lookup 
> (because the RCU accesses to the dentries get turned into a refcount, 
> and then that refcount gets dropped). But lg_local_lock() gets called 
> twice: once for path_init(), and once for mntput() - I think I was wrong 
> about mntput getting called twice.
> 
> So it doesn't seem to be cacheline bouncing at all. It's just 
> "serializing instructions are really expensive" together with calling 
> that function too much. And we've optimized pathname lookup so much that 
> even a single locked instruction shows up like a sort thumb.
> 
> I guess we should be proud.

It still looks anomalous to me, on fresh Intel hardware. One suggestion: 
could you, just for pure testing purposes, turn HT off and do a quick 
profile that way?

The XADD, even if it's all in the fast path, could be a pretty natural 
point to 'yield' an SMT context on a given core, giving it artificially 
high overhead.

Note that to test HT off an intrusive reboot is probably not needed, if 
the HT siblings are right after each other in the CPU enumeration sequence 
then you can turn HT "off" effectively by running the workload only on 4 
cores:

  taskset 0x55 ./my-test

and reducing the # of your workload threads to 4 or so.

Thanks,

	Ingo
