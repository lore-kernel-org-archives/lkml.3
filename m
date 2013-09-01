Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab3IAWQ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 18:16:28 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:42711 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab3IAWQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 18:16:26 -0400
MIME-Version: 1.0
In-Reply-To: <20130901212355.GU13318@ZenIV.linux.org.uk>
References: <CA+icZUX3zQEWDoaXk0RMKmbQhDRo0Z7jGZ=9tJu1gZWvGodMkg@mail.gmail.com>
	<CA+icZUUDKExRW3iNXj6jTs8A4DwQNaWvPuUfV5_ExXNPzq=+rA@mail.gmail.com>
	<CA+55aFxvEjdEFK0dXn783eVN0PEXVhb5k8OnrbxSWDpXgyTwWw@mail.gmail.com>
	<CA+icZUXcn6-A+AW5bu_pfRdOcScsNyn3-OZe6n93S5NUEzHtcg@mail.gmail.com>
	<CA+55aFwHx=tCzdo50jJB0ey7-CTVSo6RRQHe6R9fAya7nPn00A@mail.gmail.com>
	<CA+icZUWmQHWHMr1symL7j0iYqUMJBiOuRJ=EJz4F-xkQtdnJLg@mail.gmail.com>
	<CA+55aFxwjx30pC=kcfvOzgJvt2KK9DLm2i6JKYYz+mtOOJEnMA@mail.gmail.com>
	<CA+icZUUwy=sbt6BOirH6N4mSrQOykb=Z3GSdCb7vy_eVfG2RYw@mail.gmail.com>
	<CA+55aFwU054C+zC+G+JrF4ngWvVmvD9WPGWaT_2=nF2j7bpHxA@mail.gmail.com>
	<CA+55aFyc17miqwhncAKsanPQ9fHX_czQx+g-a9At_S1-XNpyKA@mail.gmail.com>
	<20130901212355.GU13318@ZenIV.linux.org.uk>
Date: Sun, 1 Sep 2013 15:16:24 -0700
X-Google-Sender-Auth: TfedwGiUzZbGF-72o4rpJbKIzNE
Message-ID: <CA+55aFzkZi6Q1bwSZUJxyfqUgLS05icjrObdCxC+4S-3Tup9Ew@mail.gmail.com>
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

On Sun, Sep 1, 2013 at 2:23 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> How much of that is due to br_write_lock() taken in mntput_no_expire()
> for no good reason?  IOW, could you try shmem.c patch I've sent yesterday
> and see how much effect does it have?[1]  Basically, we get it grabbed
> exclusive on each final fput() of a struct file created by shmem_file_setup(),
> which is _not_ a rare event.  And the only reason for that is not having
> shm_mnt marked long-living, even though its refcount never hits 0...

Does not seem to matter. Still 66% mntput_no_expire, 31% path_init.
And that lg_local_lock() takes 5-6% of CPU, pretty much all of which
is that single xadd instruction that implements the spinlock.

This is on /tmp, which is tmpfs. But I don't see how any of that could
matter. "mntput()" does an unconditional call to mntput_no_expire(),
and mntput_no_expire() does that br_read_lock() unconditionally too.

Note that I'm talking about that "cheap" *read* lock being expensive.
It's the local one, not the global one. So it's not what Waiman saw
with the global lock. This is a local per-cpu thing.

That read-lock is supposed to be very cheap - it's just a per-cpu
spinlock. But it ends up being very expensive for some reason. I'm not
quite sure why - I don't see any lg_global_lock() calls at all, so...

I wonder if there is some false sharing going on. But I don't see that
either, this is the percpu offset map afaik:

  000000000000f560 d files_lglock_lock
  000000000000f564 d nr_dentry
  000000000000f568 d last_ino
  000000000000f56c d nr_unused
  000000000000f570 d nr_inodes
  000000000000f574 d vfsmount_lock_lock
  000000000000f580 d bh_accounting

and I don't see anything there that would get cross-cpu accesses, so
there shouldn't be any cacheline bouncing. That's the whole point of
percpu variables, after all.

Odd. What am I missing?

            Linus
