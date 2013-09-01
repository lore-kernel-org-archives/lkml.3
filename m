Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab3IAXaU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 19:30:20 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50417 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab3IAXaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 19:30:18 -0400
Date: Mon, 2 Sep 2013 00:30:05 +0100
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
Message-ID: <20130901233005.GX13318@ZenIV.linux.org.uk>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzsXwFkYsWY45ZNTaVFC+-1Yh9nxx=NLhv+NxGmQAKHTg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 01, 2013 at 03:48:01PM -0700, Linus Torvalds wrote:
> I made DEFINE_LGLOCK use DEFINE_PER_CPU_SHARED_ALIGNED for the
> spinlock, so that each local lock gets its own cacheline, and the
> total loops jumped to 62M (from 52-54M before). So when I looked at
> the numbers, I thought "oh, that helped".
> 
> But then I looked closer, and realized that I just see a fair amount
> of boot-to-boot variation anyway (probably a lot to do with cache
> placement and how dentries got allocated etc). And it didn't actually
> help at all, the problem is stilte there, and lg_local_lock is still
> really really high on the profile, at 8% cpu time:
> 
> -   8.00%  lg_local_lock
>    - lg_local_lock
>       + 64.83% mntput_no_expire
>       + 33.81% path_init
>       + 0.78% mntput
>       + 0.58% path_lookupat
> 
> which just looks insane. And no, no lg_global_lock visible anywhere..
> 
> So it's not false sharing. But something is bouncing *that* particular
> lock around.

Hrm...  It excludes sharing between the locks, all right.  AFAICS, that
won't exclude sharing with plain per-cpu vars, will it?  Could you
tell what vfsmount_lock is sharing with on that build?  The stuff between
it and files_lock doesn't have any cross-CPU writers, but with that
change it's the stuff after it that becomes interesting...
