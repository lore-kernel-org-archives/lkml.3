Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945975AbaD3T7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 15:59:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49457 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759376AbaD3T7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 15:59:21 -0400
Date: Wed, 30 Apr 2014 20:59:18 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: dcache shrink list corruption?
Message-ID: <20140430195918.GS18016@ZenIV.linux.org.uk>
References: <20140429232013.GM18016@ZenIV.linux.org.uk>
 <20140430023142.GN18016@ZenIV.linux.org.uk>
 <CA+55aFypNxsjJTq_rc2Jx4p_3scJo2VWdt=e8n-9eJ-ZQphnpQ@mail.gmail.com>
 <20140430040436.GO18016@ZenIV.linux.org.uk>
 <20140430154958.GC3113@tucsk.piliscsaba.szeredi.hu>
 <20140430160345.GP18016@ZenIV.linux.org.uk>
 <CAJfpegu+q3sT=8==9K5t4=qeJH2azFcBGeMXUtK3LVSEEzXTUA@mail.gmail.com>
 <20140430183650.GQ18016@ZenIV.linux.org.uk>
 <CAJfpegu+=zidycJwcBPjuDLP-ZnGisOGQpD8GKhD-Wz6eNzd9g@mail.gmail.com>
 <20140430190227.GR18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140430190227.GR18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 08:02:27PM +0100, Al Viro wrote:
> On Wed, Apr 30, 2014 at 08:42:01PM +0200, Miklos Szeredi wrote:
> 
> > Message-ID: <20140430154958.GC3113@tucsk.piliscsaba.szeredi.hu>
> 
> I see...  Several points:
> 	* I still think that it's better to do handling of "we see
> DCACHE_DENTRY_KILLED already set" in dentry_kill() itself.
> 	* in dentry_kill(dentry, 0) we *know* that it's not on a shrink
> list - the caller has just removed it from there and we'd kept ->d_lock
> since that point.   What's more, with that scheme we don't need to bother
> with can_free at all - just grab ->d_lock after ->d_release() call and check
> DCACHE_SHRINK_LIST.  No sense trying to avoid that - in case where we
> could just go ahead and free the sucker, there's neither contention nor
> anybody else interested in that cacheline, so spin_lock(&dentry->d_lock)
> is pretty much free.
> 
> IOW, I'd prefer to do the following (completely untested) on top of 1/6--4/6:

Sigh...  One more problem:
                /*
                 * We found an inuse dentry which was not removed from
                 * the LRU because of laziness during lookup. Do not free it.
                 */
                if (dentry->d_lockref.count) {
                        spin_unlock(&dentry->d_lock);
                        continue;
                }
should become
		if (dentry->d_lockref.count > 0) {
			....
instead - lockref_mark_dead() slaps -128 into it, so we'll just leak all
dentries where dput() has come first and decided to leave the suckers
for us.

Another thing: I don't like what's going on with freeing vs. ->d_lock there.
Had that been a mutex, we'd definitely get a repeat of "vfs: fix subtle
use-after-free of pipe_inode_info".  The question is, can spin_unlock(p)
dereference p after another CPU gets through spin_lock(p)?  Linus?

It can be dealt with by setting DCACHE_RCUACCESS in "let another guy free
it" cases and playing with rcu_read_lock a bit, but I wonder whether we
need to bother - quick look through alpha/sparc/ppc shows that on those
we do not and the same is true for non-paravirt case on x86.  I hadn't
checked what paravirt one does, though, and I certainly hadn't done
exhaustive search for architectures doing something weird...
