Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759446AbaD3WMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 18:12:42 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49554 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbaD3WMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 18:12:41 -0400
Date: Wed, 30 Apr 2014 23:12:38 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: dcache shrink list corruption?
Message-ID: <20140430221238.GV18016@ZenIV.linux.org.uk>
References: <20140430160345.GP18016@ZenIV.linux.org.uk>
 <CAJfpegu+q3sT=8==9K5t4=qeJH2azFcBGeMXUtK3LVSEEzXTUA@mail.gmail.com>
 <20140430183650.GQ18016@ZenIV.linux.org.uk>
 <CAJfpegu+=zidycJwcBPjuDLP-ZnGisOGQpD8GKhD-Wz6eNzd9g@mail.gmail.com>
 <20140430190227.GR18016@ZenIV.linux.org.uk>
 <20140430195918.GS18016@ZenIV.linux.org.uk>
 <CA+55aFxe4HKHiWbarfwtww9=WUgfAmk+Cf3G7tdBB19uMdjbEg@mail.gmail.com>
 <20140430203823.GT18016@ZenIV.linux.org.uk>
 <CA+55aFyqqwrtv7ifTYVK943qm2OJOF8aF1y6apMSwjG93T=ztA@mail.gmail.com>
 <20140430211206.GU18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140430211206.GU18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 10:12:06PM +0100, Al Viro wrote:
> On Wed, Apr 30, 2014 at 01:57:05PM -0700, Linus Torvalds wrote:
> > On Wed, Apr 30, 2014 at 1:38 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > >
> > > We do not (and cannot) call dentry_kill() with rcu_read_lock held - it can
> > > trigger any amount of IO, for one thing.  We can take it around the
> > > couple of places where do that spin_unlock(&dentry->d_lock) (along with
> > > setting DCACHE_RCUACCESS) - that's what I'd been refering to.
> > 
> > Just the last spin_unlock() would be the case that matters, if the
> > spin_unlock() is done on something that could be freed immediately and
> > the lock protects and is inside the entity that gets freed.
> 
> *nod*
> 
> There are two such spin_unlock (handover from shrink_dentry_list() to
> dput() and the opposite one), but they are all that needs protection -
> ->d_flags update is outside the rcu-critical area.  I really wonder
> if we *can* get there without DCACHE_RCUACCESS having been set, though;
> dentry would have to be
> 	* picked into shrink list (i.e. have had zero refcount at some point)
> 	* never had been through __d_rehash()
> shrink_dentry_list() definitely counts on that being impossible, and it
> probably is, but I'm feeling seriously paranoid about the whole area.
> I'll finish grepping through the tree and probably drop setting
> DCACHE_RCUACCESS from the patch - either that, or set it in d_shrink_add()
> it it turns out that it is possible and shrink_dentry_list() is fucked...

OK, it really can't happen.  The proof is more convoluted than I'd like it,
but it's solid enough, so setting that flag in dentry_kill() handover cases
wasn't needed.  I've just pushed the whole thing to vfs.git#for-linus;
review and testing would be very welcome.  I can repost it one more time,
but the only difference compared to the last variant in this thread is not
bothering with DCACHE_RCUACCESS.

It has survived LTP tests, going through xfstests now...
