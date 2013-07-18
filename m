Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486Ab3GRDmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 23:42:31 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:25125 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756579Ab3GRDma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 23:42:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjoPABpj51F5LK4r/2dsb2JhbABagwa8DoUvBAGBDhd0giMBAQQBOhwjBQsIAxgJJQ8FJQMhE4gKBbZrFo5HgR0Hg3sDl1uRToMkKg
Date: Thu, 18 Jul 2013 13:42:03 +1000
From: Dave Chinner <david@fromorbit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ben Myers <bpm@sgi.com>, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Jones <davej@redhat.com>, xfs@oss.sgi.com
Subject: Re: splice vs execve lockdep trace.
Message-ID: <20130718034203.GO11674@dastard>
References: <20130716193332.GB3572@sgi.com>
 <CA+55aFzTBUKStdZu1GhKoiYc2knybhiaUFr2By98QYew_STE=A@mail.gmail.com>
 <20130716204335.GH11674@dastard>
 <CA+55aFwHMQd-VDeTDh-gm3jyj+5+FSoAHOeU47mwU-mKtEj9RQ@mail.gmail.com>
 <20130717040616.GI11674@dastard>
 <CA+55aFz5xw9Qi9Q6mwoCSud5eQh5u-QZ-xrY+TqgZPoKOgn6ew@mail.gmail.com>
 <20130717055103.GK11674@dastard>
 <CA+55aFxdqzMY5VJoYaLmL=+=f2s1cbHHV-TjC3=taXpF-xov1w@mail.gmail.com>
 <20130717234049.GC3572@sgi.com>
 <CA+55aFy-8QH4bTW7hU=381tuEWgHC=PUM6WP3qn-ooge=7M0QQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy-8QH4bTW7hU=381tuEWgHC=PUM6WP3qn-ooge=7M0QQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 05:17:36PM -0700, Linus Torvalds wrote:
> On Wed, Jul 17, 2013 at 4:40 PM, Ben Myers <bpm@sgi.com> wrote:
> >>
> >> We're still talking at cross purposes then.
> >>
> >> How the hell do you handle mmap() and page faulting?
> >
> > __xfs_get_blocks serializes access to the block map with the i_lock on the
> > xfs_inode.  This appears to be racy with respect to hole punching.
> 
> Would it be possible to just make __xfs_get_blocks get the i_iolock
> (non-exclusively)?

No. __xfs_get_blocks() operates on metadata (e.g. extent lists), and
as such is protected by the i_ilock (note: not the i_iolock).  i.e.
XFS has a multi-level locking strategy:

	i_iolock is provided for *data IO serialisation*,
	i_ilock is for *inode metadata serialisation*.

Truncate and hole punching require IO level serialisation rather
than metadata or page cache level serialisation as they have to be
safe against direct IO as well as page cache based IO.

> Or, alternatively, do it in the readpage() function?
> 
> That was what I thought you did anyway. Exactly because of the whole
> page faulting issue.

We protect the inode itself with the i_ilock in the page fault path,
but we have no IO level serialisation. Racing faults serialise
access to inode metadata via on the i_ilock, but this doesn't
serialise against IO in progress....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
