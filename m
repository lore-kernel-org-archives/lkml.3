Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbaCaAlC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:41:02 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:56676 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752903AbaCaAk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 20:40:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ai1lANy4OFN5LEcvPGdsb2JhbABZgwY7gw+nOQWZIIEUFwMBAQEBODWCJQEBAQQ6HCMQCAMYCSUPBSUDBxoTG4ddDtEuFoxpggAHgySBFASYTYpdix0p
Date: Mon, 31 Mar 2014 11:40:53 +1100
From: Dave Chinner <david@fromorbit.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com
Subject: Re: xfs i_lock vs mmap_sem lockdep trace.
Message-ID: <20140331004053.GA17603@dastard>
References: <20140329223109.GA24098@redhat.com>
 <20140330234335.GB16336@dastard>
 <20140330235717.GO18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140330235717.GO18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 12:57:17AM +0100, Al Viro wrote:
> On Mon, Mar 31, 2014 at 10:43:35AM +1100, Dave Chinner wrote:
> > filldir on a directory inode vs page fault on regular file. Known
> > issue, definitely a false positive. We have to change locking
> > algorithms to avoid such deficiencies of lockdep (a case of "lockdep
> > considered harmful", perhaps?) so it's not something I'm about to
> > rush...
> 
> Give i_lock on directories a separate class, as it's been done for i_mutex...

Already done that. Commit:

93a8614 xfs: fix directory inode iolock lockdep false positive

This just changes where the false positives come from. This
insanity, for example, where shmem instantiates an inode in the page
fault path and so triggers selinux related lockdep fun:

http://oss.sgi.com/archives/xfs/2014-02/msg00618.html

and this with reclaim state contexts:

http://oss.sgi.com/archives/xfs/2014-03/msg00145.html

I even hacked a patch to move the inode classes to per-fstype classes,
and that just pushed the false positive somewhere else. It's just
another horrible game of whack-a-mole, caused by XFS doing something
different. The first possible fix:

http://oss.sgi.com/archives/xfs/2014-03/msg00146.html

is a bit of a big hammer approach, so the approach I'm looking at is
the "don't cache mappings in readdir" solution noted here:

http://oss.sgi.com/archives/xfs/2014-03/msg00163.html

Note that the problem that the additional locking added in 3.13
resolved can not be triggered by anything using the VFS for
directory access. The issues is that one of SGI's plug-ins (CXFS)
can access directories without going through the VFS and so the
internal XFS locking needs to serialise readdir vs directory
modification safely....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
