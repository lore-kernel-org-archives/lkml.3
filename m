Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567Ab3IICKO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 22:10:14 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:50521 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab3IICKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 22:10:12 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFy6=CvNet+fjcYiFxbb_E1gDPzudaJ+hVotYuG5zuMb5Q@mail.gmail.com>
References: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com>
 <1375758759-29629-2-git-send-email-Waiman.Long@hp.com> <CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com>
 <1377751465.4028.20.camel@pasglop> <20130829070012.GC27322@gmail.com>
 <CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com>
 <CA+55aFx1oq7+jce8vLWRitASVMugCojYe3gmhXwhLx4K9Au3XQ@mail.gmail.com>
 <CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com>
 <CA+55aFxEjDYhY3i6B2okMWZXFiiq7hibTdeOD+OHAhNA7=XV1A@mail.gmail.com>
 <20130909000300.GH13318@ZenIV.linux.org.uk> <CA+55aFy6=CvNet+fjcYiFxbb_E1gDPzudaJ+hVotYuG5zuMb5Q@mail.gmail.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Mon, 9 Sep 2013 07:39:31 +0530
Message-ID: <CALkWK0=UYfchtAHCvp_tQK7J5My9ckTJXMY4VTy0Qss+jhReJA@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@kernel.org>,
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

Linus Torvalds wrote:
> On Sun, Sep 8, 2013 at 5:03 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>
>> Well...  unlazy_walk() is always followed by terminate_walk() very shortly,
>> but there's a minor problem - terminate_walk() uses "are we in RCU
>> mode?" for two things:
>>         a) do we need to do path_put() here?
>>         b) do we need to unlock?
>> If you introduce the third case ("no need to do unlock and no need to
>> do path_put()"), we'd better decide how to check for that case...

Yeah, I think b is a crucial step: it depends on how you unlock. Does
the unlocking result in data corruption and chaos, or does it result
in ordered data being unlocked? If it's the former case, people are
sure to take advantage of you; otherwise, you can use people.

> Actually, I decided to take advantage of those two cases instead, and
> I have a patch that I think does the right thing. Basically, I start
> off unlazy_walk() with just doing that lockref_get_not_dead() on the
> parent dentry, and if that fails I just return an error in RCU mode
> (so terminate_walk() does what it always used to do, and we haven't
> done anything else to any refcounts).

LRU cache requires that a single processor is accessing memory at a
time: if there are multiple processors, L1/ L2 cache concurrent access
is a problem.

> Now, if the lockref_get_not_dead() succeeded, that means that we have
> a reference on the nd->path.dentry, and we can now just do
> "mntget(nd->path.mnt);". Ta-Daa! We now have everything done for the
> non-RCU case for terminate_walk().

How efficient is the mounting? Has data been corrupted while taking
the portable filesystem around?

> So after that point, we clear LOOKUP_RCU, and make the rule be that
> any return (error or success) has to do unlock_rcu_walk(). And then
> all the other refcounts are easy, we can just "dput(dentry);" after
> that.

Drag ropes.

> I haven't tested it yet, I was going to reboot into it just now. But
> I'm attaching the patch here. Maybe I missed some detail, but it all
> seems simpler.

Some amount of garbage collection is healthy every once in a while,
but the project requires more yak shavers than anything else at this
point.

> Note that this patch requires the "lockref_get_not_dead()" cleanup at
> the top of my current -git.

Why is the current gitster not up to date? We should discuss automated
version control.
