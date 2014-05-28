Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbaE1UC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 16:02:26 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:34690 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaE1UCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 16:02:24 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwmoevoA3h5AZhqtHC0kEJegb0crT_jYvXWWD3UWZt9Aw@mail.gmail.com>
References: <CA+55aFxq-=xyNOLKQhS5kwy5FKZ=Jp2XSRnyZLU9e8neBLk_2A@mail.gmail.com>
	<20140527014054.GR18016@ZenIV.linux.org.uk>
	<20140527031415.GS18016@ZenIV.linux.org.uk>
	<20140527040026.GT18016@ZenIV.linux.org.uk>
	<20140527070409.GA1801@lahna.fi.intel.com>
	<20140528031955.GW18016@ZenIV.linux.org.uk>
	<20140528073751.GB1757@lahna.fi.intel.com>
	<20140528115701.GY18016@ZenIV.linux.org.uk>
	<20140528131136.GA1643@lahna.fi.intel.com>
	<20140528141937.GZ18016@ZenIV.linux.org.uk>
	<20140528183954.GA18016@ZenIV.linux.org.uk>
	<CA+55aFwmoevoA3h5AZhqtHC0kEJegb0crT_jYvXWWD3UWZt9Aw@mail.gmail.com>
Date: Wed, 28 May 2014 13:02:23 -0700
X-Google-Sender-Auth: KQBkHwUSS8U_xzKorbJXJRxYnOA
Message-ID: <CA+55aFy6-bga8LumLKO8Yc_83vA=p-g8sqUE-aGP-uF3Xb6e4w@mail.gmail.com>
Subject: Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for 22s! [systemd-udevd:1667]
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 12:43 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>  - the shrinker list logic depends on the actual freeing of the dentry
> to be delayed until the RCU grace period (already true for RCU-lookup
> dentries)

Side note: I just unconditionally removed the immediate __d_free()
case, but it could as well have become

-       if (!(dentry->d_flags & DCACHE_RCUACCESS))
+       if (!(dentry->d_flags & (DCACHE_RCUACCESS|DCACHE_SHRINK_LIST))
                __d_free(&dentry->d_u.d_rcu);
        else
                call_rcu(&dentry->d_u.d_rcu, __d_free);

instead.

Anyway, one reason I looked at this is that most of the threads in
Mika's NMI watchdog traces were stuck on _raw_spin_lock() in the whole
d_walk() thing, and I had a *really* hard time convincing myself that
this was all safe without the RCU lock. I'm wondering if Mika perhaps
has CONFIG_PREEMPT_RCU set, which means that spinlocks (or the
rename_lock sequence lock) do not end up being RCU-safe points.

And once I started worrying about that, the whole "ok, who calls
dentry_kill() when shrinking races with dput()" question started just
making me worry about that whole DCACHE_MAY_FREE thing.  Because one
of the things that Miklos/Al's series of patches did was to drop some
of the RCU locking, since it wasn't "necessary" any more as far as the
lru list itself was concerned..

             Linus
