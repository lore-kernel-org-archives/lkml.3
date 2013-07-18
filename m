Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759328Ab3GRWtP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 18:49:15 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:29555 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759072Ab3GRWtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 18:49:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AssNADlw6FF5LK4r/2dsb2JhbABagwaDIrh1hS8EAYERF3SCJAEBBScTHCMQCAMOCgklDwUlAyETiA+2OxaOXIEdB4MObgOXXJFOgyQq
Date: Fri, 19 Jul 2013 08:49:07 +1000
From: Dave Chinner <david@fromorbit.com>
To: Ben Myers <bpm@sgi.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Jones <davej@redhat.com>, xfs@oss.sgi.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: splice vs execve lockdep trace.
Message-ID: <20130718224907.GD13468@dastard>
References: <CA+55aFwHMQd-VDeTDh-gm3jyj+5+FSoAHOeU47mwU-mKtEj9RQ@mail.gmail.com>
 <20130717040616.GI11674@dastard>
 <CA+55aFz5xw9Qi9Q6mwoCSud5eQh5u-QZ-xrY+TqgZPoKOgn6ew@mail.gmail.com>
 <20130717055103.GK11674@dastard>
 <CA+55aFxdqzMY5VJoYaLmL=+=f2s1cbHHV-TjC3=taXpF-xov1w@mail.gmail.com>
 <20130717234049.GC3572@sgi.com>
 <CA+55aFy-8QH4bTW7hU=381tuEWgHC=PUM6WP3qn-ooge=7M0QQ@mail.gmail.com>
 <20130718034203.GO11674@dastard>
 <20130718211632.GD3572@sgi.com>
 <20130718222117.GE3572@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130718222117.GE3572@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 05:21:17PM -0500, Ben Myers wrote:
> Dave,
> 
> On Thu, Jul 18, 2013 at 04:16:32PM -0500, Ben Myers wrote:
> > On Thu, Jul 18, 2013 at 01:42:03PM +1000, Dave Chinner wrote:
> > > On Wed, Jul 17, 2013 at 05:17:36PM -0700, Linus Torvalds wrote:
> > > > On Wed, Jul 17, 2013 at 4:40 PM, Ben Myers <bpm@sgi.com> wrote:
> > > > >>
> > > > >> We're still talking at cross purposes then.
> > > > >>
> > > > >> How the hell do you handle mmap() and page faulting?
> > > > >
> > > > > __xfs_get_blocks serializes access to the block map with the i_lock on the
> > > > > xfs_inode.  This appears to be racy with respect to hole punching.
> > > > 
> > > > Would it be possible to just make __xfs_get_blocks get the i_iolock
> > > > (non-exclusively)?
> > > 
> > > No. __xfs_get_blocks() operates on metadata (e.g. extent lists), and
> > > as such is protected by the i_ilock (note: not the i_iolock).  i.e.
> > > XFS has a multi-level locking strategy:
> > > 
> > > 	i_iolock is provided for *data IO serialisation*,
> > > 	i_ilock is for *inode metadata serialisation*.
> > 
> > I think if __xfs_get_blocks has some way of knowing it is the mmap/page fault
> > path, taking the iolock shared in addition to the ilock (in just that case)
> > would prevent the mmap from being able to read stale data from disk.  You would
> > see either the data before the punch or you would see the hole.  
> > 
> > Actually... I think that is wrong:  You'd have to take the iolock across the
> > read itself (not just the access to the block map) for it to have the desired
> > effect:
> > 
> > 1608 int filemap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
> > ...
> > 1704 page_not_uptodate:
> > 1705         /*
> > 1706          * Umm, take care of errors if the page isn't up-to-date.
> > 1707          * Try to re-read it _once_. We do this synchronously,
> > 1708          * because there really aren't any performance issues here
> > 1709          * and we need to check for errors.
> > 1710          */
> > 1711         ClearPageError(page);
> > 1712         error = mapping->a_ops->readpage(file, page);
> > 1713         if (!error) {
> > 1714                 wait_on_page_locked(page);
> > 1715                 if (!PageUptodate(page))
> > 1716                         error = -EIO;
> > 1717         }
> > 1718         page_cache_release(page);
> > 
> > Wouldn't you have to hold the iolock until after wait_on_page_locked returns?
> 
> Maybe like so (crappy/untested/probably wrong/fodder for ridicule/etc):

Try running it with lockdep. You'll see pretty quickly why you can't
take the i_iolock or i_mutex in the ->fault path - it is called
with the mmap_sem held.

The lock inversion that can deadlock is that the page fault might be
occurring in the read path that is already holding the
i_mutex/i_iolock....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
