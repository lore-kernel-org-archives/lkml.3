Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab3JCU5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 16:57:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43949 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490Ab3JCU5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 16:57:07 -0400
Date: Thu, 3 Oct 2013 21:57:06 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH] fs: make sure we do not read beyond allocation
Message-ID: <20131003205706.GM13318@ZenIV.linux.org.uk>
References: <20131003163411.GA17101@www.outflux.net>
 <20131003175824.GH13318@ZenIV.linux.org.uk>
 <CAGXu5j+8sxc8vc4bwv14nGNiOhq-ey2nxAK99LgMKO+Qmh1L6A@mail.gmail.com>
 <20131003182311.GI13318@ZenIV.linux.org.uk>
 <CAGXu5j+4NUKfgKiAK+w2MrsqRxHiYc62LBMx4UsfxUBSxNwNJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+4NUKfgKiAK+w2MrsqRxHiYc62LBMx4UsfxUBSxNwNJA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 12:36:08PM -0700, Kees Cook wrote:
> > Kees, try to think for a minute[1].  Really.  We have general-purpose
> > ...
> > [1] yes, yes, I know - the mere mention of security should've prevented such
> > arrogant requests.  It's an imperfect universe.
> 
> I want to attempt to disassemble what you've communicating here:
> 
> a) I'm not thinking.
> b) Requesting that someone think when they mention security is arrogant.

Not really.

It's just that all too often completely pointless changes are touted
as security hardening.  With replies along the lines of "it doesn't
really buy you anything" countered with indignant "but what if
<impossible situation>" and/or references to "defense in depth" (used
as a magical incantation), etc.

You've posted a provably pointless patch.  Happens to all of us.  And in
reply to "it's pointless for the following reasons" (with moderate
level of sarcasm) you responded pretty much with "but what if allocator
changes?  It's more robust that way".  OK, but if you go for that
kind of arguments (and they can be valid), you'd better be correct.
You were not, and for very obvious reasons.  Let me repeat, this
time with sarcasm level down to zero:

Let n be some integer between 32 and 4096 and N be equal to n rounded up
to word size.  If kmalloc(n) returns a pointer such that fetch from
(char *)p[N - 1] triggers an exception, we have a badly broken kernel.
It can happen only if there is a page boundary between p[n-1] and p[N-1],
which means that p is not word-aligned.
Consider the following code:
	struct foo {
		unsigned long n;
		char a[];
	} *p = kmalloc(offsetof(struct foo, a) + 33);
	if (p)
		p->n = 1;
and note that it will result in an exception on any architecture that prohibits
unaligned accesses in the kernel.  Even on architectures where those are
allowed, misaligned structures mean serious correctness problems (atomicity of
stores, etc.)

In other words, kmalloc() (or, indeed, userland malloc()) demonstrating
such behaviour would need immediate fixing.  The only exception I can
think of is something with byte granularity of memory protection; in such
case we can have that without unaligned return values returned by allocator.
Which would require a lot of changes in mm/*, at the very least, and probably
would violate a lot of assumptions elsewhere in the kernel (starting with
sizeof(void *) == sizeof(unsigned long)).

> What the patch does help with, though, is dynamic analysis tools that
> are looking for out-of-bound reads, which this clearly is. It should
> be considered a violation of the API to attempt to access a range
> beyond what was requested for the allocation. Fixing this means lots
> of noise vanishes from such analysis of the allocation API, letting
> other tools besides just KASAN do work to find other more serious
> problems in heap usage.
> 
> Does fixing this to help dynamic analysis tools somehow make the
> kernel worse? I think that fixing this makes it easier to find further
> bugs that might be much more serious.

Possibly true.  But then I'd suggest wrapping that into a different ifdef;
grep for ifdef __CHECKER__, with comment along the lines of "to simplify
analysis of potential out-of-bounds accesses".
