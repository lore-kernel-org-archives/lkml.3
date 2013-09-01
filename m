Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313Ab3IAU7Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 16:59:25 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:56907 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498Ab3IAU7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 16:59:23 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwU054C+zC+G+JrF4ngWvVmvD9WPGWaT_2=nF2j7bpHxA@mail.gmail.com>
References: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com>
	<1375758759-29629-2-git-send-email-Waiman.Long@hp.com>
	<CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com>
	<1377751465.4028.20.camel@pasglop>
	<20130829070012.GC27322@gmail.com>
	<CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com>
	<CA+55aFx1oq7+jce8vLWRitASVMugCojYe3gmhXwhLx4K9Au3XQ@mail.gmail.com>
	<CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com>
	<52200DAE.2020303@hp.com>
	<CA+55aFyhTR15GBS4VNoRkcFyubEJU7a+Pzd-6VZeKoU8qB0q5Q@mail.gmail.com>
	<CA+icZUX3zQEWDoaXk0RMKmbQhDRo0Z7jGZ=9tJu1gZWvGodMkg@mail.gmail.com>
	<CA+icZUUDKExRW3iNXj6jTs8A4DwQNaWvPuUfV5_ExXNPzq=+rA@mail.gmail.com>
	<CA+55aFxvEjdEFK0dXn783eVN0PEXVhb5k8OnrbxSWDpXgyTwWw@mail.gmail.com>
	<CA+icZUXcn6-A+AW5bu_pfRdOcScsNyn3-OZe6n93S5NUEzHtcg@mail.gmail.com>
	<CA+55aFwHx=tCzdo50jJB0ey7-CTVSo6RRQHe6R9fAya7nPn00A@mail.gmail.com>
	<CA+icZUWmQHWHMr1symL7j0iYqUMJBiOuRJ=EJz4F-xkQtdnJLg@mail.gmail.com>
	<CA+55aFxwjx30pC=kcfvOzgJvt2KK9DLm2i6JKYYz+mtOOJEnMA@mail.gmail.com>
	<CA+icZUUwy=sbt6BOirH6N4mSrQOykb=Z3GSdCb7vy_eVfG2RYw@mail.gmail.com>
	<CA+55aFwU054C+zC+G+JrF4ngWvVmvD9WPGWaT_2=nF2j7bpHxA@mail.gmail.com>
Date: Sun, 1 Sep 2013 13:59:22 -0700
X-Google-Sender-Auth: ZJ1kTXgYBMF28rbiki2y-OHbL5k
Message-ID: <CA+55aFyc17miqwhncAKsanPQ9fHX_czQx+g-a9At_S1-XNpyKA@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Waiman Long <waiman.long@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
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

On Sun, Sep 1, 2013 at 8:32 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sun, Sep 1, 2013 at 3:01 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>
>> Looks like this is now 10x faster: ~2.66Mloops (debug) VS.
>> ~26.60Mloops (no-debug).
>
> Ok, that's getting to be in the right ballpark.

So I installed my new i7-4770S yesterday - somewhat lower frequency
than my previous CPU, but it has four cores plus HT, and boy does that
show the scalability problems better.

My test-program used to get maybe 15% time in spinlock. On the 4770S,
with current -git (so no lockref) I get this:

   [torvalds@i5 test-lookup]$ for i in 1 2 3 4 5; do ./a.out ; done
   Total loops: 26656873
   Total loops: 26701572
   Total loops: 26698526
   Total loops: 26752993
   Total loops: 26710556

with a profile that looks roughly like:

  84.14%  a.out   _raw_spin_lock
   3.04%  a.out   lg_local_lock
   2.16%  a.out   vfs_getattr
   1.16%  a.out   dput.part.15
   0.67%  a.out   copy_user_enhanced_fast_string
   0.55%  a.out   complete_walk

[ Side note: Al, that lg_local_lock really is annoying: it's
br_read_lock(mntput_no_expire), with two thirds of the calls coming
from mntput_no_expire, and the rest from path_init -> lock_rcu_walk.

  I really really wonder if we could get rid of the
br_read_lock(&vfsmount_lock) for rcu_walk_init(), and use just the RCU
read accesses for the mount-namespaces too. What is that lock really
protecting against during lookup anyway? ]

With the last lockref patch I sent out, it looks like this:

   [torvalds@i5 test-lookup]$ for i in 1 2 3 4 5; do ./a.out ; done
   Total loops: 54740529
   Total loops: 54568346
   Total loops: 54715686
   Total loops: 54715854
   Total loops: 54790592

  28.55%  a.out   lockref_get_or_lock
  20.65%  a.out   lockref_put_or_lock
   9.06%  a.out   dput
   6.37%  a.out   lg_local_lock
   5.45%  a.out   lookup_fast
   3.77%  a.out   d_rcu_to_refcount
   2.03%  a.out   vfs_getattr
   1.75%  a.out   copy_user_enhanced_fast_string
   1.16%  a.out   link_path_walk
   1.15%  a.out   avc_has_perm_noaudit
   1.14%  a.out   __lookup_mnt

so performance more than doubled (on that admittedly stupid
benchmark), and you can see that the cacheline bouncing for that
reference count is still a big deal, but at least it gets some real
work done now because we're not spinning waiting for it.

So you can see the bad case with even just a single socket when the
benchmark is just targeted enough. But two cores just wasn't enough to
show any performance advantage.

                Linus
