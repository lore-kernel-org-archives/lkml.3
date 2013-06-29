Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab3F2WLO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 18:11:14 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:34827 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab3F2WLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 18:11:12 -0400
MIME-Version: 1.0
In-Reply-To: <51CF52D1.1080406@hp.com>
References: <1372268603-46748-1-git-send-email-Waiman.Long@hp.com>
	<1372268603-46748-2-git-send-email-Waiman.Long@hp.com>
	<CA+55aFzo5Jy064pbvEZh5cg_RJiSxe1R+tSgByQTs4rc=4SN3Q@mail.gmail.com>
	<51CF422E.7030803@hp.com>
	<51CF52D1.1080406@hp.com>
Date: Sat, 29 Jun 2013 15:11:11 -0700
X-Google-Sender-Auth: alG1jgSpm5g1NXn7xdOpuWRYzv8
Message-ID: <CA+55aFxrT4i7QBX71QfEsopW1Vj4K0gG7zFR2VMhWmD1Zj8Bng@mail.gmail.com>
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

On Sat, Jun 29, 2013 at 2:34 PM, Waiman Long <waiman.long@hp.com> wrote:
>
> I think I got it now. For architecture with transactional memory support to
> use an alternative implementation, we will need to use some kind of dynamic
> patching at kernel boot up time as not all CPUs in that architecture will
> have that support. In that case the helper functions have to be real
> functions and cannot be inlined. That means I need to put the implementation
> into a spinlock_refcount.c file with the header file contains structure
> definitions and function prototypes only. Is that what you are looking for?

Yes. Except even more complex: I want the generic fallbacks in a
lib/*.c files too.

So we basically have multiple "levels" of specialization:

 (a) the purely lock-based model that doesn't do any optimization at
all, because we have lockdep enabled etc, so we *want* things to fall
back to real spinlocks.

 (b) the generic cmpxchg approach for the case when that works

 (c) the capability for an architecture to make up its own very
specialized version

and while I think in all cases the actual functions are big enough
that you don't ever want to inline them, at least in the case of (c)
it is entirely possible that the architecture actually wants a
particular layout for the spinlock and refcount, so we do want the
architecture to be able to specify the exact data structure in its own
<asm/spinlock-refcount.h> file. In fact, that may well be true of case
(b) too, as Andi already pointed out that on x86-32, an "u64" is not
necessarily sufficiently aligned for efficient cmpxchg (it may *work*,
but cacheline-crossing atomics are very very slow).

Other architectures may have other issues - even with a "generic"
cmpxchg-based library version, they may well want to specify exactly
how to take the lock. So while (a) would be 100% generic, (b) might
need small architecture-specific tweaks, and (c) would be a full
custom implementation.

See how we do <asm/word-at-a-time.h> and CONFIG_DCACHE_WORD_ACCESS.
Notice how there is a "generic" <asm-generic/word-at-a-time.h> file
(actually, big-endian only) for reference implementations (used by
sparc, m68k and parisc, for example), and then you have "full custom"
implementations for x86, powerpc, alpha and ARM.

See also lib/strnlen_user.c and CONFIG_GENERIC_STRNLEN_USER as an
example of how architectures may choose to opt in to using generic
library versions - if those work sufficiently well for that
architecture. Again, some architecture may decide to write their own
fully custome strlen_user() function.

Very similar concept.

                 Linus
