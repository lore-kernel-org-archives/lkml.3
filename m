Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab3H3Cb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 22:31:28 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:58233 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab3H3CbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 22:31:24 -0400
MIME-Version: 1.0
In-Reply-To: <29797.1377828380@ale.ozlabs.ibm.com>
References: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com>
	<1375758759-29629-2-git-send-email-Waiman.Long@hp.com>
	<CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com>
	<1377751465.4028.20.camel@pasglop>
	<20130829070012.GC27322@gmail.com>
	<CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com>
	<CA+55aFx1oq7+jce8vLWRitASVMugCojYe3gmhXwhLx4K9Au3XQ@mail.gmail.com>
	<CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com>
	<1377822408.4028.44.camel@pasglop>
	<CA+55aFz4rJAAWopcSEJct55jUgCHY_6ZD=GSkKFmWanvd0otuw@mail.gmail.com>
	<29797.1377828380@ale.ozlabs.ibm.com>
Date: Thu, 29 Aug 2013 19:31:23 -0700
X-Google-Sender-Auth: B_J_QO6t6trSXI8Prd4cS6_s_8A
Message-ID: <CA+55aFzVNe==TM+PeK4zqvGQm7K+KLgO1hBYSOzFqwPSVts03Q@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michael Neuling <mikey@neuling.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@kernel.org>, Waiman Long <Waiman.Long@hp.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
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

On Thu, Aug 29, 2013 at 7:06 PM, Michael Neuling <mikey@neuling.org> wrote:
>
> Running on a POWER7 here with 32 threads (8 cores x 4 threads) I'm
> getting some good improvements:

That's *much* better than I get. But I literally just have a single
socket with two cores (and HT, so four threads) in my test machine, so
I really have a hard time getting any real contention. And the main
advantage of the patch should be when you actually have CPU's spinning
on that dentry d_lock.

Also, on x86, there are no advantages to cmpxchg over a spinlock -
they are both exactly one equally serializing instruction. If
anything, cmpxchg is worse due to having a cache read before the
write, and a few cycles slower anyway. So I actually expect the x86
code to slow down a tiny bit for the single-threaded case, although
that should be hopefully unmeasurable.

On POWER, you may have much less serialization for the cmpxchg. That
may sadly be something we'll need to fix - the serialization between
getting a lockref and checking sequence counts etc may need some extra
work.

So it may be that you are seeing unrealistically good numbers, and
that we will need to add a memory barrier or two. On x86, due to the
locked instruction semantics, that just isn't an issue.

> The numbers move around about 10% from run to run.

Please note that the whole "dentry hash chains may be better" for one
run vs another, and that's something that will _persist_ between
subsequent runs, so you may see "only 10% variability", but there may
be a bigger picture variability that you're not noticing because you
had to reboot in between.

To be really comparable, you should really run the stupid benchmark
after fairly equal boot up sequences. If the machine had been up for
several days for one set of numbers, and freshly rebooted for the
other, it can be a very unfair comparison.

(I long ago had a nice "L1 dentry cache" patch that helped with the
fact that the dentry chains *can* get long especially if you have tons
of memory, and that helped with this kind of variability a lot - and
improved performance too. It was slightly racy, though, which is why
it never got merged).

> powerpc patch below. I'm using arch_spin_is_locked() to implement
> arch_spin_value_unlocked().

Your "slock" is of type "volatile unsigned int slock", so it may well
cause those temporaries to be written to memory.

It probably doesn't matter, but you may want to check that the result
of "make lib/lockref.s" looks ok.

                 Linus
