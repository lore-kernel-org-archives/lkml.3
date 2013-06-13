Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab3FMGml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 02:42:41 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55168 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab3FMGmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 02:42:40 -0400
Date: Thu, 13 Jun 2013 07:42:35 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Chiluk <chiluk@canonical.com>
Cc: Petr Vandrovec <petr@vandrovec.name>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ncpfs: fix rmdir returns Device or resource busy
Message-ID: <20130613064235.GK4165@ZenIV.linux.org.uk>
References: <1369781410-24473-1-git-send-email-chiluk@canonical.com>
 <51A918B8.20303@canonical.com>
 <CA+i2_De5HHw2H9SvZ=W+QAOcy0M7jFac88OK6aeYdJVCGL6b+A@mail.gmail.com>
 <51AF9D77.2000901@canonical.com>
 <CA+i2_DfEhn_CPRBmyy4scG7UEL5bGsjodcq00Nyx4JZjnuSBGQ@mail.gmail.com>
 <51B205A1.4040405@canonical.com>
 <20130607161452.GI13110@ZenIV.linux.org.uk>
 <20130613020122.GA20274@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130613020122.GA20274@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 03:01:22AM +0100, Al Viro wrote:
> On Fri, Jun 07, 2013 at 05:14:52PM +0100, Al Viro wrote:
> > On Fri, Jun 07, 2013 at 11:09:05AM -0500, Dave Chiluk wrote:
> > > Can't you just use the patch from my original e-mail?  Anyhow I attached
> > > it an already signed-off patch.
> > > 
> > > Al Viro Can you integrate it now?
> > 
> > Applied...  FWIW, patch directly in mail body is more convenient to deal with.
> 
> Actually, looking at that stuff...  Why are we bothering with -EBUSY for
> removal of busy directories on ncpfs, anyway?  It's not just rmdir(), it's
> overwriting rename() as well.  IS_DEADDIR checks in fs/namei.c and fs/readdir.c
> mean that the only method of ncpfs directories that might get called after
> successful removal is ->setattr() and it would be trivial to add the check
> in ncp_notify_change() that would make it fail for dead directories without
> bothering the server at all...
> 
> Related question: what happens if you open / unlink / fchmod on ncpfs?

Speaking of crap used only by ncpfs: I think we can use ->d_iput() to get rid
of d_validate() for good.  The only remaining user is ncpfs; what happens there
is that we use the page cache of directory to cache the references to dentries
made by readdir.  We could do the following trick:
	* have ->d_fsdata for these dentries a pointer into the cache page where
the reference back to dentry is stored
	* ->freepage() for those pages consisting of
		grab global spinlock
		go through all dentries still pointed to by pointers in that
page, zeroing ->d_fsdata
		drop the spinlock
	* ->d_iput() for those dentries consisting of
		grab the same spinlock
		if ->d_fsdata is non-zero, store NULL at the address pointed
to by it
		drop the spinlock
	* ncp_dget_fpos() would
		grab that spinlock
		check if the reference to dentry in the position we are
interested in is non-NULL
			grab ->d_lock
			if DCACHE_DENTRY_KILLED is not set
				bump ->d_count
				drop ->d_lock
				drop the spinlock
				return dentry
			// dentry is doomed
			clear the reference
			drop ->d_lock
		drop the spinlock
		return NULL
	* ncp_fill_cache() would insert the sucker into cache and set
->d_fsdata under the same spinlock.

IOW, instead of wanking with untrusted pointers to dentries, we simply make
sure we clean the pointer when dentry is going away and clean the reference
from dentry to the location of that pointer when the page is going away.

Objections?  I can do a patch along those lines, but I've nothing to test it
on.  Had that been cifs, I could at least use samba to test the fucker, but
I've no idea how to do that with ncpfs and I'm not too fond of checking how
much bitrot has mars_nwe suffered...
