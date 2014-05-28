Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbaE1V3F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 17:29:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54255 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbaE1V3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 17:29:03 -0400
Date: Wed, 28 May 2014 22:28:59 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for 22s!
 [systemd-udevd:1667]
Message-ID: <20140528212859.GD18016@ZenIV.linux.org.uk>
References: <20140527070409.GA1801@lahna.fi.intel.com>
 <20140528031955.GW18016@ZenIV.linux.org.uk>
 <20140528073751.GB1757@lahna.fi.intel.com>
 <20140528115701.GY18016@ZenIV.linux.org.uk>
 <20140528131136.GA1643@lahna.fi.intel.com>
 <20140528141937.GZ18016@ZenIV.linux.org.uk>
 <20140528183954.GA18016@ZenIV.linux.org.uk>
 <CA+55aFwmoevoA3h5AZhqtHC0kEJegb0crT_jYvXWWD3UWZt9Aw@mail.gmail.com>
 <20140528201440.GB18016@ZenIV.linux.org.uk>
 <CA+55aFyUFjcGPOyfC+CuYyA8x0=ffnzjscRrgz5ZcVmX4k-Jqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyUFjcGPOyfC+CuYyA8x0=ffnzjscRrgz5ZcVmX4k-Jqg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 02:11:51PM -0700, Linus Torvalds wrote:

> > d_walk() covers its arse with ->d_lock (and it wants the starting point
> > to be pinned, obviously).  So AFAICS RCU is not a problem.
> 
> It's not RCU itself, it's that DCACHE_MAY_FREE bit. Yes, d_walk() gets
> ->d_lock, but dentry_kill() drops d_lock in the middle, and the whole
> "dentry_kill() can get called multiple times for the same dentry" just
> makes me go "Hmm". It is *not* obvious what happens the second vs
> third time that gets called. If it can get called two times, why not
> three times?

dentry_kill(dentry, 1) can only be called when ->d_count had been positive
up to the point of caller grabbing ->d_lock.  And it either does
lockref_mark_dead() before dropping ->d_lock or it fails trylock and buggers
off having done nothing, including changes of ->d_count.

In case of dentry_kill(dentry, 0), ->d_lock has been held since the moment
dentry had been found on shrink list.  It either does nothing and dentry gets
returned to the same shrink list without ever dropping ->d_lock (or changing
refcount) or it does lockref_mark_dead() before dropping ->d_lock.  In the
latter case dentry will *not* be put on any shrink lists again.

So we have at most one call of the first kind getting past the trylocks and
at most one call of the second kind doing the same.
