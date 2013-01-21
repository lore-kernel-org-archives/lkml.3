Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab3AUGCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 01:02:34 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:39490 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab3AUGCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 01:02:33 -0500
Date: Mon, 21 Jan 2013 06:02:29 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Issues with "x86, um: switch to generic fork/vfork/clone" commit
Message-ID: <20130121060229.GT4939@ZenIV.linux.org.uk>
References: <50F3D2F2.3080200@6wind.com>
 <20130119063808.GN4939@ZenIV.linux.org.uk>
 <20130120031253.GO4939@ZenIV.linux.org.uk>
 <CA+55aFyRMC43_H1hL5goAQxX4EdTuXOu5A9CoBk9fpGoJT_nig@mail.gmail.com>
 <20130121012217.GQ4939@ZenIV.linux.org.uk>
 <CA+55aFwG2j_+2pjUJuZqT1yk0xDEyeFMgCxHmxAzfGXHO5qCXQ@mail.gmail.com>
 <20130121023010.GR4939@ZenIV.linux.org.uk>
 <CA+55aFwPM3qWE7F7nwUVKphVTJb7WE7zPF5artdVw7Xq5Z1UgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwPM3qWE7F7nwUVKphVTJb7WE7zPF5artdVw7Xq5Z1UgQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 06:39:09PM -0800, Linus Torvalds wrote:

> And right now, that HAVE_SYSCALL_WRAPPERS does make it much harder to
> think about the header file changes.

Agreed.

> > FWIW, there's another bit of ugliness around that area - all these
> > #define __SC_BLAH3, etc., all of the same form.  This stuff begs for
> > something like
> > #define __MAP1(m,t,a) m(t,a)
> > #define __MAP2(m,t,a,...) m(t,a) __MAP1(m,__VA_ARGS__)
> > #define __MAP3(m,t,a,...) m(t,a) __MAP2(m,__VA_ARGS__)
> > #define __MAP4(m,t,a,...) m(t,a) __MAP3(m,__VA_ARGS__)
> > #define __MAP5(m,t,a,...) m(t,a) __MAP4(m,__VA_ARGS__)
> > #define __MAP6(m,t,a,...) m(t,a) __MAP5(m,__VA_ARGS__)
> > #define __MAP(n,...) __MAP##n(__VA_ARGS__)
> > with __MAP(x,__SC_DECL,__VA_ARGS__) instead of __SC_DECL##x(__VA_ARGS__)
> > etc. in users...

... with missing commas added, of course.

> Well, I can see both sides. The above is the nice and dense
> declaration model with less duplication, but christ, it's hard for
> people to wrap their minds around unless they've seen it a million
> times. It really does take some getting used to, and the long-form can
> be easier to understand.

Umm...  Even with
/*
 * __MAP - apply a given macro to all syscall arguments.
 * __MAP(n, m, t1, a1, ..., tn, an) will expand to
 *      m(t1,a1), m(t2,a2), ..., m(tn, an)
 * Note that the first argument of __MAP must be equal to the number of
 * type, name pairs in the list.  The list itself (all arguments of __MAP
 * starting with the 3rd one) is in the form we pass to SYSCALL_DEFINE<n>.
 */
slapped on top of it?

> That said, we have so many of those things now when it comes to the
> syscall stuff that the dense form seems to be called for just to be
> consistent.
> 
> So go wild if you have the energy for it. I'm not going to pull that
> for 3.8, though.

No, that's obviously next cycle fodder, along with the sick tricks for
generating compat wrappers on s390 if Martin can live with those.

BTW, grep for asmlinkage; it's amazing how much cargo-culting is going
on with it ;-/  Some of the instances are syscalls yet to be converted
to SYSCALL_DEFINE<n>; even more of COMPAT_SYSCALL_DEFINE<n>-to-be.  We
also have a bunch of declarations in syscalls.h and compat.h - those
are fine.  _Some_ of the rest might be legitimate - ia64 and i386 have
non-trivial asmlinkage expansion and some (but not all) of arch/{x86,ia64}
instances do make sense.  Not all of those - e.g. things like
FPU_divide_by_zero() have no business being regparm(0); they are only called
from C code and forcing their arguments on stack is a pure pessimization for
no reason whatsoever.  Everything else in arch/* is magic green marker,
AFAICS...

There are some borderline cases - e.g. I'm not sure if having sys_recv
done *not* via SYSCALL_DEFINE() is deliberate; it might cut down on
some overhead (the sucker's calling sys_recvfrom(), which does normalizations,
which make normalizing in sys_recv() pointless).  OTOH, sys_send *is*
done as SYSCALL_DEFINE, even though it ends up calling sys_sendto()...
