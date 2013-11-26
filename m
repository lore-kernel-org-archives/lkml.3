Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977Ab3KZUDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 15:03:13 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:32998 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304Ab3KZUDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 15:03:12 -0500
MIME-Version: 1.0
In-Reply-To: <5294F10C.8060901@amacapital.net>
References: <1385426236-14960-1-git-send-email-andi@firstfloor.org>
	<5294F10C.8060901@amacapital.net>
Date: Tue, 26 Nov 2013 12:03:11 -0800
X-Google-Sender-Auth: oaECRIdm7NL4L1_hdcgZS-I92kQ
Message-ID: <CA+55aFzBXzQS90XYZKHRr0N66uBrDmS=o_U9u=e4qq2CzTg8ww@mail.gmail.com>
Subject: Re: [PATCH] Add a text_poke syscall v2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 11:05 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> IIRC someone proposed that, rather than specifying a "handler", that any
> user thread that traps just wait until the poke completes.  This would
> complicate the kernel implementation a bit, but it would make the user
> code a good deal simpler.  Is there any reason that this is a bad idea?

Please do it this way instead, because user space will get the
callback version wrong and then - because it never actually triggers
in practice in normal situations - it will cause very *very* subtle
bugs that we can't fix.

Making the kernel serialize the accesses is the right thing to do.
Just a new per-mm mutex should trivially do it, then you don't even
have to check the "current->mm == bp_target_mm" thing at all, you just
make the bp handler do a simple

    if (mutex_lock_interruptible(&mm->text_poke_mutex) >= 0)
        mutex_unlock(&mm->text_poke_mutex);

and return. All done.

Plus the callback thing is pointless if we can do the instruction
switch atomically (which would be true for UP, for single-thread, and
potentially for certain sizes/alignments coupled with known rules for
particular micro-architectures). So it's not a particularly good
interface anyway.

Btw, I also think that there's a separate problem wrt shared pages.
Should we perhaps only allow this in private mappings? Because right
now it has that "current->mm == bp_target_mm" thing, and generally it
only works on one particular mm, but by using "get_user_pages_fast(,
1,..)" it really only requires write permissions on the page. So it
could be shared mapping, and I could easily see people doing that on
purpose ("open executable file, then use text_poke() to change it for
this architecture") and THAT DOES NOT WORK with the current patch if
somebody else is also running that app..

               Linus
