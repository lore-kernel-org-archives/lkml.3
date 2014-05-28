Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbaE1VLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 17:11:54 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:50685 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbaE1VLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 17:11:52 -0400
MIME-Version: 1.0
In-Reply-To: <20140528201440.GB18016@ZenIV.linux.org.uk>
References: <20140527031415.GS18016@ZenIV.linux.org.uk>
	<20140527040026.GT18016@ZenIV.linux.org.uk>
	<20140527070409.GA1801@lahna.fi.intel.com>
	<20140528031955.GW18016@ZenIV.linux.org.uk>
	<20140528073751.GB1757@lahna.fi.intel.com>
	<20140528115701.GY18016@ZenIV.linux.org.uk>
	<20140528131136.GA1643@lahna.fi.intel.com>
	<20140528141937.GZ18016@ZenIV.linux.org.uk>
	<20140528183954.GA18016@ZenIV.linux.org.uk>
	<CA+55aFwmoevoA3h5AZhqtHC0kEJegb0crT_jYvXWWD3UWZt9Aw@mail.gmail.com>
	<20140528201440.GB18016@ZenIV.linux.org.uk>
Date: Wed, 28 May 2014 14:11:51 -0700
X-Google-Sender-Auth: W4jVrEucTb75VLEpXIGkBuvsrvw
Message-ID: <CA+55aFyUFjcGPOyfC+CuYyA8x0=ffnzjscRrgz5ZcVmX4k-Jqg@mail.gmail.com>
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

On Wed, May 28, 2014 at 1:14 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Unless I'm badly misreading your patch, you are calling dentry_kill()
> with rcu_read_lock() held.  And that can trigger all sorts of interesting
> things, starting with iput() and tons of disk IO...

Yes, right you are.

As to my worry:

> d_walk() covers its arse with ->d_lock (and it wants the starting point
> to be pinned, obviously).  So AFAICS RCU is not a problem.

It's not RCU itself, it's that DCACHE_MAY_FREE bit. Yes, d_walk() gets
->d_lock, but dentry_kill() drops d_lock in the middle, and the whole
"dentry_kill() can get called multiple times for the same dentry" just
makes me go "Hmm". It is *not* obvious what happens the second vs
third time that gets called. If it can get called two times, why not
three times? And if it can get called three times, why can't _two_ of
them set "can_free" to true? That is absolutely *not* obvious to me.

The aim of my patch (and I agree that sadly holding the rcu lock is
not viable) was to make that "if it gets called twice" case _much_
more obvious. Because any but the first time will be very obviously a
no-op (apart from taking and releasing the lock, which is ok for a
rcu-delayed data structure). That's very much not the case with
DCACHE_MAY_FREE. The behavior of that things os very much non-obvious,
because different callers into dentry_kill() all do different things.

                Linus
