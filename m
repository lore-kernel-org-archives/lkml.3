Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301Ab3LCE2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 23:28:48 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51579 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab3LCE2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 23:28:45 -0500
Date: Tue, 3 Dec 2013 04:28:30 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Simon Kirby <sim@hostway.ca>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Waiman Long <Waiman.Long@hp.com>, Ian Applegate <ia@cloudflare.com>,
        Christoph Lameter <cl@gentwo.org>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>
Subject: Re: Found it! (was Re: [3.10] Oopses in kmem_cache_allocate() via
 prepare_creds())
Message-ID: <20131203042830.GI10323@ZenIV.linux.org.uk>
References: <CA+55aFyez7uZ6LeXrBRCqJzgJ=w4Xv+CV6QSYp5NkOJ2R9Xang@mail.gmail.com>
 <CA+55aFyhzvJrCiJOqUgL-98=MVutWePToQXaVfS2j6e5eetJSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyhzvJrCiJOqUgL-98=MVutWePToQXaVfS2j6e5eetJSw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 06:58:57PM -0800, Linus Torvalds wrote:

> In other words, it's unsafe to protect reference counts inside objects
> with anything but spinlocks and/or atomic refcounts. Or you have to
> have the lock *outside* the object you're protecting (which is often
> what you want for other reasons anyway, notably lookup).
> 
> So having a non-atomic refcount protected inside a sleeping lock is a
> bug, and that's really the bug that ended up biting us for pipes.
> 
> Now, the question is: do we have other such cases? How do we document
> this? Do we try to make mutexes and other locks safe to use for things
> like this?

Umm...  AFAICS, in VFS proper we have
	files_struct - atomic_dec_and_test
	fs_struct - spinlock + int
	file - atomic_long_dec_and_test (with delays after that, including
RCU).
	super_block - global spinlock + int (s_count); the mutex in there
(->s_umount) can be taken by anybody who holds an active ref *or* has
bumped ->s_count while holding sb_lock.  Exactly to prevent that kind of
unpleasantness.  Freeing RCU-delayed.
	vfsmount - percpu counter + flag + global seqlock, with quite a bit of
contortions for the sake of avoiding cross-CPU stores on fastpath; discussed
back in October, concluded to be safe.  Freeing RCU-delayed.
	dentry - lockref, with RCU-delayed actual freeing.
	file_system_type, nls_table, linux_binfmt - module refcount of "owner";
search structures protected by global spinlocks or rwlocks, exiting module
is responsible for unregistering first.
	inode - atomic_dec_and_lock, with actual freeing RCU-delayed (and
evicting code waiting for pagecache references to be gone, with the rest
being responsibility of fs method called before we free the sucker)
	block_device - part of bdevfs inode

These should be safe, but damnit, we really need the lifecycle documented for
all objects - the above is only a part of it (note that for e.g. superblocks
we have additional rules re "->s_active can't be incremented for any reason
once it drops to zero, it can't be incremented until superblock had been
marked 'born' and it crosses over to zero only with ->s_umount held"; there's
6 stages in life cycle of struct super_block and we had interesting bugs due
to messing the transitions up).  The trouble is, attempt to write those down
tends to stray into massive grep session, with usual results - some other
crap gets found (e.g. in some odd driver) and needs to be dealt with ;-/
Sigh...
