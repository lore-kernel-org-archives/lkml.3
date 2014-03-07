Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbaCGSij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 13:38:39 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43172 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaCGSih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 13:38:37 -0500
Date: Fri, 7 Mar 2014 18:38:34 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Stephen Tweedie <sct@redhat.com>,
        Jeremy Eder <jeder@redhat.com>
Subject: Re: [PATCH 5/5][RFC][CFT] resizable namespace.c hashes
Message-ID: <20140307183834.GE18016@ZenIV.linux.org.uk>
References: <20140305034751.GW18016@ZenIV.linux.org.uk>
 <20140305035219.GE26528@ZenIV.linux.org.uk>
 <87bnxi6i8w.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bnxi6i8w.fsf@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 09:17:19AM -0800, Andi Kleen wrote:
> Al Viro <viro@ZenIV.linux.org.uk> writes:
> 
> > * switch allocation to alloc_large_system_hash()
> > * make sizes overridable by boot parameters (mhash_entries=, mphash_entries=)
> > * switch mountpoint_hashtable from list_head to hlist_head
> 
> So how much memory does this use on a standard system (<4GB memory)?

Two hash chains per megabyte.  IOW, 2Gb => 4096 of them.  Could drive
it lower, probably, but I'm a bit nervous about _really_ low-end
boxen.  Right now it matches your variant at 128Mb box.

> How much memory does it use on a large system (0.5TB)?

Probably over the top - alloc_large_system_hash() has that problem
in general.

0.5Tb would amount to 2^20 hash chains.  Which is probably too much,
but then dentry hash on the same box will be 2^26 hash chains and
inode hash - 2^25 chains.

> How good is your hash function. Would jhash be more appropiate
> and allow smaller hash tables?

How the hell does hash function affect the average chain length?  And
yes, they are pretty evenly distributed.  And while we are at it,
what the hell does jhash have to do with the whole thing?  No strings
involved - the hash key is a pair of pointers.  To objects allocated
by kmem_cache_alloc(), so their middle bits are already fairly random.

> Perhaps just want a tree here.

_What_ tree?  Andi, WTF are you talking about?  That hash is a mapping
from (parent vfsmount, mountpoint dentry) to child vfsmount.  Sure,
we do have the mount tree - all children of given vfsmount are on a
cyclic list anchored in it.  And iterating through those is painfully
slow on realistic setups.  Have a bunch of nfs4 referrals on one fs,
and you are welcome to a hundred of vfsmounts on the child list of one.
Create a bunch of bindings in assorted places in /usr, have *any*
mountpoint in /usr pay the price when we cross it on pathname resolution.
Same with /, since there tends to be a bunch of mounts on directories
in root filesystem.  FWIW, on the box I'm typing at right now - /proc,
/sys, /dev, /run, /tmp, /home, /usr, /var.   8 of them.  On the box I'm
sshed into: /proc, /sys, /dev, /run, /usr, /media, /var, /tmp, /boot,
/archive - 10.  And traversing that would be the price on *any* pathname
resolution trying to cross from root to e.g. /home or /usr.

To get an equally bad behaviour on the current setup (even with the
ridiculously small hash table size set by your patch back in 2002),
you'd need ~2000 mounts.  And it very easily degrades even more -
consider e.g. a box that has a shitload of stuff automounted under
/home.  It can easily go well past 10 simultaneous ones...

We could keep a per-mountpoint list, anchored in dentry.  And pay with
an extra pointer in each struct dentry out there.  Which will cost a lot
more.  Or, we could anchor them in struct mountpoint and do hash lookup
*and* list search on each mountpoint crossing - one to find struct mountpoint
by struct dentry, another to look for vfsmount with the right parent.
