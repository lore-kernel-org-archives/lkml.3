Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940Ab3IBANB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 20:13:01 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:42879 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757924Ab3IBAM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 20:12:59 -0400
MIME-Version: 1.0
In-Reply-To: <20130901233005.GX13318@ZenIV.linux.org.uk>
References: <CA+icZUXcn6-A+AW5bu_pfRdOcScsNyn3-OZe6n93S5NUEzHtcg@mail.gmail.com>
	<CA+55aFwHx=tCzdo50jJB0ey7-CTVSo6RRQHe6R9fAya7nPn00A@mail.gmail.com>
	<CA+icZUWmQHWHMr1symL7j0iYqUMJBiOuRJ=EJz4F-xkQtdnJLg@mail.gmail.com>
	<CA+55aFxwjx30pC=kcfvOzgJvt2KK9DLm2i6JKYYz+mtOOJEnMA@mail.gmail.com>
	<CA+icZUUwy=sbt6BOirH6N4mSrQOykb=Z3GSdCb7vy_eVfG2RYw@mail.gmail.com>
	<CA+55aFwU054C+zC+G+JrF4ngWvVmvD9WPGWaT_2=nF2j7bpHxA@mail.gmail.com>
	<CA+55aFyc17miqwhncAKsanPQ9fHX_czQx+g-a9At_S1-XNpyKA@mail.gmail.com>
	<20130901212355.GU13318@ZenIV.linux.org.uk>
	<CA+55aFzkZi6Q1bwSZUJxyfqUgLS05icjrObdCxC+4S-3Tup9Ew@mail.gmail.com>
	<CA+55aFzsXwFkYsWY45ZNTaVFC+-1Yh9nxx=NLhv+NxGmQAKHTg@mail.gmail.com>
	<20130901233005.GX13318@ZenIV.linux.org.uk>
Date: Sun, 1 Sep 2013 17:12:58 -0700
X-Google-Sender-Auth: pdWUe1HV5tfGsVoS-7ybxyFtrYY
Message-ID: <CA+55aFyzas75yYP+AiwOxsAg5sG3KU+KEmO+ny=dn0-jxqUt5Q@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Sedat Dilek <sedat.dilek@gmail.com>, Waiman Long <waiman.long@hp.com>,
        Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
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

On Sun, Sep 1, 2013 at 4:30 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Hrm...  It excludes sharing between the locks, all right.  AFAICS, that
> won't exclude sharing with plain per-cpu vars, will it?

Yes it will. DEFINE_PER_CPU_SHARED_ALIGNED not only aligns the data,
it also puts it in a separate section with only other aligned data
entries. So now the percpu address map around it looks like this:

  ...
  0000000000013a80 d call_single_queue
  0000000000013ac0 d cfd_data
  0000000000013b00 d files_lglock_lock
  0000000000013b40 d vfsmount_lock_lock
  0000000000013b80 d file_lock_lglock_lock
  0000000000013bc0 D softnet_data
  0000000000013d40 D __per_cpu_end
   ..

So there shouldn't be anything to share falsely with.

I'd like to say that the profile is bad, but this is *so* consistent,
and the profile data really looks perfectly fine in every other way.
I'm using "-e cycles:pp", so it's using hardware profiling and all the
other functions really look correct.

It *is* one of the few locked accesses remaining, and it's clearly
getting called a lot (three calls per system call: two mntput's  - one
for the root path, one for the result path, and one from path_init ->
rcu_walk_init), but with up to 8% CPU time for basically that one
"lock xadd" instruction is damn odd. I can't see how that could happen
without seriously nasty cacheline bouncing, but I can't see how *that*
can happen when all the accesses seem to be from the current CPU.

This is a new Haswell-based machine that I put together yesterdat, and
I haven't used it for profiling before. So maybe it _is_ something odd
with the profiling after all, and atomic serializing instructions get
incorrect profile counts.

             Linus
