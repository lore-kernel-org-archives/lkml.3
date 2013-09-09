Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329Ab3IIAag (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 20:30:36 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49108 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab3IIAae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 20:30:34 -0400
Date: Mon, 9 Sep 2013 01:30:26 +0100
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
Message-ID: <20130909003026.GI13318@ZenIV.linux.org.uk>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909000300.GH13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 01:03:00AM +0100, Al Viro wrote:

> Well...  unlazy_walk() is always followed by terminate_walk() very shortly,
> but there's a minor problem - terminate_walk() uses "are we in RCU
> mode?" for two things:
> 	a) do we need to do path_put() here?
> 	b) do we need to unlock?
> If you introduce the third case ("no need to do unlock and no need to
> do path_put()"), we'd better decide how to check for that case...
> 
> I suspect that minimal variant would be along the lines of
> 	* have unlazy_walk() slap NULL into ->path.mnt on error, clear
> LOOKUP_RCU and unlock
> 	* have terminate_walk() check ->path.mnt before doing path_put()
> in !RCU case
> 	* in do_last() replace bool got_write with struct vfsmount *got_write,
> storing the reference to vfsmount we'd fed to mnt_want_write().
> And use its value when we call mnt_put_write() in there...
> 
> I'll put together a commit like that on top of what I was going to push
> into public queues tonight; give me about half an hour, OK?

See the last commit in vfs.git#for-next (38373e1).
