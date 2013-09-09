Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335Ab3IIAf0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 20:35:26 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49119 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab3IIAfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 20:35:24 -0400
Date: Mon, 9 Sep 2013 01:35:17 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
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
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
Message-ID: <20130909003517.GJ13318@ZenIV.linux.org.uk>
References: <1375758759-29629-2-git-send-email-Waiman.Long@hp.com>
 <CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com>
 <1377751465.4028.20.camel@pasglop>
 <20130829070012.GC27322@gmail.com>
 <CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com>
 <CA+55aFx1oq7+jce8vLWRitASVMugCojYe3gmhXwhLx4K9Au3XQ@mail.gmail.com>
 <CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com>
 <CA+55aFxEjDYhY3i6B2okMWZXFiiq7hibTdeOD+OHAhNA7=XV1A@mail.gmail.com>
 <20130909000300.GH13318@ZenIV.linux.org.uk>
 <CA+55aFy6=CvNet+fjcYiFxbb_E1gDPzudaJ+hVotYuG5zuMb5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy6=CvNet+fjcYiFxbb_E1gDPzudaJ+hVotYuG5zuMb5Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 08, 2013 at 05:25:40PM -0700, Linus Torvalds wrote:
> On Sun, Sep 8, 2013 at 5:03 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Well...  unlazy_walk() is always followed by terminate_walk() very shortly,
> > but there's a minor problem - terminate_walk() uses "are we in RCU
> > mode?" for two things:
> >         a) do we need to do path_put() here?
> >         b) do we need to unlock?
> > If you introduce the third case ("no need to do unlock and no need to
> > do path_put()"), we'd better decide how to check for that case...
> 
> Actually, I decided to take advantage of those two cases instead, and
> I have a patch that I think does the right thing. Basically, I start
> off unlazy_walk() with just doing that lockref_get_not_dead() on the
> parent dentry, and if that fails I just return an error in RCU mode
> (so terminate_walk() does what it always used to do, and we haven't
> done anything else to any refcounts).
> 
> Now, if the lockref_get_not_dead() succeeded, that means that we have
> a reference on the nd->path.dentry, and we can now just do
> "mntget(nd->path.mnt);". Ta-Daa! We now have everything done for the
> non-RCU case for terminate_walk().
> 
> So after that point, we clear LOOKUP_RCU, and make the rule be that
> any return (error or success) has to do unlock_rcu_walk(). And then
> all the other refcounts are easy, we can just "dput(dentry);" after
> that.
> 
> I haven't tested it yet, I was going to reboot into it just now. But
> I'm attaching the patch here. Maybe I missed some detail, but it all
> seems simpler.
> 
> Note that this patch requires the "lockref_get_not_dead()" cleanup at
> the top of my current -git.

That should also work, replacing the current tip of #for-next.  Do you
prefer to merge those two diffs of yours into a single commit?
