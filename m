Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab3H3Co0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 22:44:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:48849 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962Ab3H3CoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 22:44:25 -0400
Message-ID: <1377830598.4028.48.camel@pasglop>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael Neuling <mikey@neuling.org>, Ingo Molnar <mingo@kernel.org>,
        Waiman Long <Waiman.Long@hp.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Date: Fri, 30 Aug 2013 12:43:18 +1000
In-Reply-To: <CA+55aFzVNe==TM+PeK4zqvGQm7K+KLgO1hBYSOzFqwPSVts03Q@mail.gmail.com>
References: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com>
	 <1375758759-29629-2-git-send-email-Waiman.Long@hp.com>
	 <CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com>
	 <1377751465.4028.20.camel@pasglop> <20130829070012.GC27322@gmail.com>
	 <CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com>
	 <CA+55aFx1oq7+jce8vLWRitASVMugCojYe3gmhXwhLx4K9Au3XQ@mail.gmail.com>
	 <CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com>
	 <1377822408.4028.44.camel@pasglop>
	 <CA+55aFz4rJAAWopcSEJct55jUgCHY_6ZD=GSkKFmWanvd0otuw@mail.gmail.com>
	 <29797.1377828380@ale.ozlabs.ibm.com>
	 <CA+55aFzVNe==TM+PeK4zqvGQm7K+KLgO1hBYSOzFqwPSVts03Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-29 at 19:31 -0700, Linus Torvalds wrote:

> Also, on x86, there are no advantages to cmpxchg over a spinlock -
> they are both exactly one equally serializing instruction. If
> anything, cmpxchg is worse due to having a cache read before the
> write, and a few cycles slower anyway. So I actually expect the x86
> code to slow down a tiny bit for the single-threaded case, although
> that should be hopefully unmeasurable.
> 
> On POWER, you may have much less serialization for the cmpxchg. That
> may sadly be something we'll need to fix - the serialization between
> getting a lockref and checking sequence counts etc may need some extra
> work.

> So it may be that you are seeing unrealistically good numbers, and
> that we will need to add a memory barrier or two. On x86, due to the
> locked instruction semantics, that just isn't an issue.

Dunno, our cmpxhg has both acquire and release barriers. It basically
does release, xchg, then acquire. So it is equivalent to an unlock
followed by a lock.

> > The numbers move around about 10% from run to run.
> 
> Please note that the whole "dentry hash chains may be better" for one
> run vs another, and that's something that will _persist_ between
> subsequent runs, so you may see "only 10% variability", but there may
> be a bigger picture variability that you're not noticing because you
> had to reboot in between.
> 
> To be really comparable, you should really run the stupid benchmark
> after fairly equal boot up sequences. If the machine had been up for
> several days for one set of numbers, and freshly rebooted for the
> other, it can be a very unfair comparison.
> 
> (I long ago had a nice "L1 dentry cache" patch that helped with the
> fact that the dentry chains *can* get long especially if you have tons
> of memory, and that helped with this kind of variability a lot - and
> improved performance too. It was slightly racy, though, which is why
> it never got merged).
> 
> > powerpc patch below. I'm using arch_spin_is_locked() to implement
> > arch_spin_value_unlocked().
> 
> Your "slock" is of type "volatile unsigned int slock", so it may well
> cause those temporaries to be written to memory.
> 
> It probably doesn't matter, but you may want to check that the result
> of "make lib/lockref.s" looks ok.
> 
>                  Linus


