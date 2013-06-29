Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab3F2RpW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 13:45:22 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:38199 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab3F2RpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 13:45:17 -0400
MIME-Version: 1.0
In-Reply-To: <1372268603-46748-2-git-send-email-Waiman.Long@hp.com>
References: <1372268603-46748-1-git-send-email-Waiman.Long@hp.com>
	<1372268603-46748-2-git-send-email-Waiman.Long@hp.com>
Date: Sat, 29 Jun 2013 10:45:16 -0700
X-Google-Sender-Auth: A9QdSNr6MgH4BexxSbmT3IvMNKY
Message-ID: <CA+55aFzo5Jy064pbvEZh5cg_RJiSxe1R+tSgByQTs4rc=4SN3Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] spinlock: New spinlock_refcount.h for lockless
 update of refcount
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for not commenting earlier, I was traveling and keeping email to
a minimum..

On Wed, Jun 26, 2013 at 10:43 AM, Waiman Long <Waiman.Long@hp.com> wrote:
> This patch introduces a new spinlock_refcount.h header file to be
> included by kernel code that want to do a lockless update of reference
> count protected by a spinlock.

So I really like the concept, but the implementation is a mess, and
tries to do too much, while actually achieving too little.

I do not believe you should care about debug spinlocks at all, and
just leave them be. Have a simple fallback code that defaults to
regular counts and spinlocks, and have any debug cases just use that.

But more importantly, I think this needs to be architecture-specific,
and using <linux/spinlock_refcount.h> to try to do some generic 64-bit
cmpxchg() version is a bad bad idea.

We have several architectures coming up that have memory transaction
support, and the "spinlock with refcount" is a perfect candidate for a
transactional memory implementation. So when introducing a new atomic
like this that is very performance-critical and used for some very
core code, I really think architectures would want to make their own
optimized versions.

These things should also not be inlined, I think.

So I think the concept is good, but I think the implementation needs
more thought.

                       Linus
