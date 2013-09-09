Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab3IIDcG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 23:32:06 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:58553 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab3IIDcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 23:32:04 -0400
MIME-Version: 1.0
In-Reply-To: <20130909000300.GH13318@ZenIV.linux.org.uk>
References: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com>
	<1375758759-29629-2-git-send-email-Waiman.Long@hp.com>
	<CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com>
	<1377751465.4028.20.camel@pasglop>
	<20130829070012.GC27322@gmail.com>
	<CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com>
	<CA+55aFx1oq7+jce8vLWRitASVMugCojYe3gmhXwhLx4K9Au3XQ@mail.gmail.com>
	<CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com>
	<CA+55aFxEjDYhY3i6B2okMWZXFiiq7hibTdeOD+OHAhNA7=XV1A@mail.gmail.com>
	<20130909000300.GH13318@ZenIV.linux.org.uk>
Date: Sun, 8 Sep 2013 20:32:03 -0700
X-Google-Sender-Auth: KrsgmEDGx3AEQ8HD39s5Wpw6ysI
Message-ID: <CA+55aFyFt+8DY3Umw_YjytdUC8AVoPOWLFdvDP2EWVHue9Mi9A@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Waiman Long <Waiman.Long@hp.com>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 8, 2013 at 5:03 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> There's one exception - basically, we decide to put duplicates of
> reference(s) we hold into (a bunch of) structures being created.  If
> we decide that we'd failed and need to roll back, the structures
> need to be taken out of whatever lists, etc. they'd been already
> put on and references held in them - dropped.  That removal gets done
> under a spinlock.  Sure, we can string those structures on some kind
> of temp list, drop the spinlock and do dput() on everything in there,
> but it's much more convenient to just free them as we are evicting
> them, doing dput() as we go.  Which is safe, since we are still have
> the references used to create these buggers pinned down.

Hmm. Which codepath does this? Because I got curious and added back
the __might_sleep() unconditionally to dput() just to see (now that I
think that the dput() bugs are gone), and at least under normal load
it doesn't trigger. I even wrote a thing that just constantly creates
and renames the target file concurrently with looking it up, so that
I've stress-tested the RCU sequence number failure path (and verified
with a profile that yes, it does trigger the "oops, need to retry"
case). I didn't test anything odd at all (just my dentry stress tests
and a regular graphical desktop), though.

And I have too much memory to sanely stress any out-of-memory situations.

#firstworldkerneldeveloperproblems

            Linus
