Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab3F2V6P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 17:58:15 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:47034 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab3F2V6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 17:58:13 -0400
MIME-Version: 1.0
In-Reply-To: <51CF422E.7030803@hp.com>
References: <1372268603-46748-1-git-send-email-Waiman.Long@hp.com>
	<1372268603-46748-2-git-send-email-Waiman.Long@hp.com>
	<CA+55aFzo5Jy064pbvEZh5cg_RJiSxe1R+tSgByQTs4rc=4SN3Q@mail.gmail.com>
	<51CF422E.7030803@hp.com>
Date: Sat, 29 Jun 2013 14:58:11 -0700
X-Google-Sender-Auth: 7qJnwQXfX9kibxbGHPSCpi1z-H8
Message-ID: <CA+55aFyVOSa7gOVuBVQqK+wQkgc_2+KZ3Ejx9gPYF=o_Lc3sqg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] spinlock: New spinlock_refcount.h for lockless
 update of refcount
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 29, 2013 at 1:23 PM, Waiman Long <waiman.long@hp.com> wrote:
>>
>> But more importantly, I think this needs to be architecture-specific,
>> and using<linux/spinlock_refcount.h>  to try to do some generic 64-bit
>> cmpxchg() version is a bad bad idea.
>
> Yes, I can put the current implementation into
> asm-generic/spinlock_refcount.h. Now I need to put an
> asm/spinlock_refcount.h into every arch's include/asm directory. Right?

No, I'd suggest something slightly different: we did something fairly
similar to this with the per-arch optimized version of the
word-at-a-time filename hashing/lookup.

So the sanest approach is something like this:

STEP 1:

 - create a new set of config option (say
"CONFIG_[ARCH_]SPINLOCK_REFCOUNT") that defaults to 'y' and isn't
actually asked about anywhere. Just a simple

    config ARCH_SPINLOCK_REFCOUNT
        bool

    config SPINLOCK_REFCOUNT
        depends on ARCH_SPINLOCK_REFCOUNT
        depends on !GENERIC_LOCKBREAK
        depends on !DEBUG_SPINLOCK
        depends on !DEBUG_LOCK_ALLOC
        bool

   in init/Kconfig will do that.

 - create a <linux/spinlock-refcount.h> that looks something like this

    #ifdef CONFIG_SPINLOCK_REFCOUNT
    #include <asm/spinlock-refcount.h>
    #else
     .. fallback implementation with normal spinlocks that works for
all cases, including lockdep etc ..
    #endif

and now you should have something that should already work, it just
doesn't actually do the optimized cases for any architecture. Equally
importantly, it already self-disables itself if any of the complicated
debug options are set that means that a spinlock is anything but the
raw architecture spinlock.

STEP 2:

 - Now, step #2 is *not* to do per-architecture version, but to do the
generic cmpxchg version, and make that in
<asm-generic/spinlock-refcount.h>

At this point, any architecture can decide to hook into the generic
version with something like this in their own architecture Kconfig
file:

    select CONFIG_ARCH_SPINLOCK_REFCOUNT

and adding the line

    generic-y += spinlock-refcount.h

to their architecture Kbuild file. So after step two, you basically
have an easy way for architectures to step in one by one with the
cmpxchg version, after they have verified that their spinlocks work
for it. And notice how little the architecture actually needed to do?

STEP 3:

 - This is the "architecture decides to not use the
<asm-generic/spinlock-refcount.h> file, and instead creates its own
optimized version of it.

All these steps are nice and easy and can be tested on their own.  And
make sense on their own. Even that first step is important, since
that's when you create the logic, and that's the code that will be
used when spinlock debugging is enabled etc. The third step may not
ever happen for all architectures. Even the second step might be
something that some architecture decides is not worth it (ie slow and
complex atomics, but fast spinlocks).

And all three steps should be fairly small and logical, I think.

                  Linus
