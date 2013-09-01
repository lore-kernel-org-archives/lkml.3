Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab3IAWfh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 18:35:37 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50215 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500Ab3IAWfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 18:35:34 -0400
Date: Sun, 1 Sep 2013 23:35:21 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
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
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
Message-ID: <20130901223521.GV13318@ZenIV.linux.org.uk>
References: <CA+55aFxvEjdEFK0dXn783eVN0PEXVhb5k8OnrbxSWDpXgyTwWw@mail.gmail.com>
 <CA+icZUXcn6-A+AW5bu_pfRdOcScsNyn3-OZe6n93S5NUEzHtcg@mail.gmail.com>
 <CA+55aFwHx=tCzdo50jJB0ey7-CTVSo6RRQHe6R9fAya7nPn00A@mail.gmail.com>
 <CA+icZUWmQHWHMr1symL7j0iYqUMJBiOuRJ=EJz4F-xkQtdnJLg@mail.gmail.com>
 <CA+55aFxwjx30pC=kcfvOzgJvt2KK9DLm2i6JKYYz+mtOOJEnMA@mail.gmail.com>
 <CA+icZUUwy=sbt6BOirH6N4mSrQOykb=Z3GSdCb7vy_eVfG2RYw@mail.gmail.com>
 <CA+55aFwU054C+zC+G+JrF4ngWvVmvD9WPGWaT_2=nF2j7bpHxA@mail.gmail.com>
 <CA+55aFyc17miqwhncAKsanPQ9fHX_czQx+g-a9At_S1-XNpyKA@mail.gmail.com>
 <20130901212355.GU13318@ZenIV.linux.org.uk>
 <CA+55aFzkZi6Q1bwSZUJxyfqUgLS05icjrObdCxC+4S-3Tup9Ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzkZi6Q1bwSZUJxyfqUgLS05icjrObdCxC+4S-3Tup9Ew@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 01, 2013 at 03:16:24PM -0700, Linus Torvalds wrote:

> Does not seem to matter. Still 66% mntput_no_expire, 31% path_init.
> And that lg_local_lock() takes 5-6% of CPU, pretty much all of which
> is that single xadd instruction that implements the spinlock.
> 
> This is on /tmp, which is tmpfs. But I don't see how any of that could
> matter. "mntput()" does an unconditional call to mntput_no_expire(),
> and mntput_no_expire() does that br_read_lock() unconditionally too.
> 
> Note that I'm talking about that "cheap" *read* lock being expensive.
> It's the local one, not the global one. So it's not what Waiman saw
> with the global lock. This is a local per-cpu thing.
> 
> That read-lock is supposed to be very cheap - it's just a per-cpu
> spinlock. But it ends up being very expensive for some reason. I'm not
> quite sure why - I don't see any lg_global_lock() calls at all, so...
> 
> I wonder if there is some false sharing going on. But I don't see that
> either, this is the percpu offset map afaik:
> 
>   000000000000f560 d files_lglock_lock
>   000000000000f564 d nr_dentry
>   000000000000f568 d last_ino
>   000000000000f56c d nr_unused
>   000000000000f570 d nr_inodes
>   000000000000f574 d vfsmount_lock_lock
>   000000000000f580 d bh_accounting
> 
> and I don't see anything there that would get cross-cpu accesses, so
> there shouldn't be any cacheline bouncing. That's the whole point of
> percpu variables, after all.

Hell knows...  Are you sure you don't see br_write_lock() at all?  I don't
see anything else that would cause cross-cpu traffic with that layout...
