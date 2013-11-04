Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab3KDAxG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 19:53:06 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43720 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab3KDAxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 19:53:04 -0500
Date: Mon, 4 Nov 2013 00:53:00 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bruce Fields <bfields@fieldses.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [git pull] fixes for 3.12-final
Message-ID: <20131104005300.GM13318@ZenIV.linux.org.uk>
References: <20131103015803.GK13318@ZenIV.linux.org.uk>
 <CA+55aFy3tAeLYL3_+PbeD15p6PGS-P7bs8fMUaRVSC0OCzvq6w@mail.gmail.com>
 <20131103195452.GL13318@ZenIV.linux.org.uk>
 <CA+55aFwW9s3GCa+zNTMg7m44-cj2RdJp7wRpCnPUvQHm9xYnFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwW9s3GCa+zNTMg7m44-cj2RdJp7wRpCnPUvQHm9xYnFg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 03, 2013 at 03:39:14PM -0800, Linus Torvalds wrote:
> On Sun, Nov 3, 2013 at 11:54 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > IIRC, at some point such an attempt has seriously hurt iget() on 32bit
> > boxen, so we ended up deciding not to go there.  Had been years ago,
> > though...
> 
> Yeah, I think the circumstances have changed. 32-bit is less
> important, and iget() is much less critical than it used to be (all
> *normal* inode lookups are through the direct dentry pointer).
>
> Sure, ARM is a few years away from 64-bit being common, but it's
> happening. And I suspect even 32-bit ARM doesn't have the annoying
> issues that x86-32 had with 64-bit values (namely using up a lot of
> the register space).
> 
> So unless there's something hidden that makes it really nasty, I do
> suspect that a "u64 i_ino" would just be the right thing to do. Rather
> than adding workarounds for our current odd situation on 32-bit
> kernels (and just wasting time on 64-bit kernels).

Maybe...  OTOH, that crap really needs doing something only with nfsd on
filesystems with 64bit inode numbers living on 32bit hosts (i_ino is
unsigned long, not u32 right now).  Hell knows; I'm somewhat concerned about
setups like e.g. ext2 on VIA C7 mini-itx boxen (and yes, I do have such
beasts).  FWIW, the whole area around iget_locked() needs profiling;
in particular, I really wonder if this
                spin_lock(&inode->i_lock);
                if (inode->i_ino != ino) {
                        spin_unlock(&inode->i_lock);
                        continue;
                }
                if (inode->i_sb != sb) {
                        spin_unlock(&inode->i_lock);
                        continue;
                }
makes any sense; both ->i_ino and ->i_sb are assign-once and assigned before
the sucker gets inserted into hash, so inode_hash_lock provides all barriers
we need here.  Sure, we want to grab ->i_lock for this:
                if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
                        __wait_on_freeing_inode(inode);
                        goto repeat;
                }
                __iget(inode);
                spin_unlock(&inode->i_lock);
but that's once per find_inode{_fast,}(), not once per inode in hash chain
being traversed...

And picking them from dentries is fine, but every time we associate an inode
with dentry, we end up walking the hash chain in icache and the time we
spend in that loop can get sensitive - we are holding a system-wide lock,
after all (and the way it's implemented right now, we end up touching
a cacheline in a bunch of struct inode for no good reason).
