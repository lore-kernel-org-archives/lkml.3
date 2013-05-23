Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759363Ab3EWO7l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 10:59:41 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:60305 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758360Ab3EWO7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 10:59:38 -0400
MIME-Version: 1.0
In-Reply-To: <6402.1369320636@warthog.procyon.org.uk>
References: <6402.1369320636@warthog.procyon.org.uk>
Date: Thu, 23 May 2013 07:59:38 -0700
X-Google-Sender-Auth: Y-tPt74Xt5Dpzc9fhJCRYK_oDMY
Message-ID: <CA+55aFww-UYfLA4cN6MSkeXzmAnAruShddAPegCpn+5yd1HGmQ@mail.gmail.com>
Subject: Re: Is spin_is_locked() safe to use with BUG_ON()/WARN_ON()?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, milosz@adfin.com,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 7:50 AM, David Howells <dhowells@redhat.com> wrote:
>
> We are using spin_is_locked() in a few places to give a warning or an oops if
> either a spinlock is not held or if it is held.  I'm not sure all of these are
> safe.

No, they're not. On SMP, you can get spurious "it's locked" (because
somebody *else* took the lock on another CPU) and on UP you'll always
get "it's unlocked".

So it's never safe to check the state, at least not without checking
for SMP or UP (and realizing that in the SMP case you can only assert
that it's held).

I guess we could change the UP case to always return "it's locked".
But since you'd better know what you're doing with "spin_is_locked()",
I don't think it's worth it making it easier to use.

> Take uas_try_complete() in drivers/usb/storage/uas.c which does:
>
>         WARN_ON(!spin_is_locked(&devinfo->lock));

Pure garbage. That's a debug thing that should not exist.

> or fscache_start_operations() which does:
>
>         ASSERT(spin_is_locked(&object->lock));

Same thing.

We do *not* want to add some crazy "spin_is_nt_locked". We just want
to get rid of these idiotic debug tests.

Note that even on SMP, spin_is_locked() can end up being bad. If this
whole memory transaction thing takes off, testing the lock is possibly
going to abort the transaction.

So I'd suggest removing it entirely. Drivers have absolutely no place
doing crap like this. We could add some particular
"assert_spin_lock_held()" that only ends up existing if spinlock
debugging is enabled or something, and make it clear that it is purely
a debug feature (and it verifies that *this* process holds the lock,
using the debug fields), not a "test if something is locked" or not.

             Linus
