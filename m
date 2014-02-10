Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbaBJKtC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:49:02 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:4178 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752615AbaBJKrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:47:51 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvoPAGyt+FJ5LGaB/2dsb2JhbABZgww4qTQDkQyFX4EOF3SCJQEBBScTHCMQCAMYCSUPBSUDIROIBMh/FxaOZweEOASYKpIig0Eo
Date: Mon, 10 Feb 2014 21:47:47 +1100
From: Dave Chinner <david@fromorbit.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs.git fixes for -rc2
Message-ID: <20140210104747.GV13997@dastard>
References: <20140209233643.GB18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140209233643.GB18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 09, 2014 at 11:36:43PM +0000, Al Viro wrote:
> 	A couple of fixes, both -stable fodder.  O_SYNC bug is
> fairly old...  Please, pull from the usual place -
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus
> 
> Shortlog:
> Al Viro (2):
>       fix O_SYNC|O_APPEND syncing the wrong range on write()

As i pointed out in a private thread this doesn't fix XFS. It passes
a private "pos" variable to generic_write_checks() and so
iocb->ki_pos never gets updated to point at the new EOF when
O_APPEND is set. Hence the code inthe above commit is still syncing
the wrong range.

Indeed, I think that __generic_file_aio_write has the same problem.
It gets called from generic_file_aio_write() like so:

	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);

And __generic_file_aio_write() does this:

	pos = *ppos;
	....
	err = generic_write_checks(file, &pos, &count, S_ISBLK(inode->i_mode));

and the updated pos value on O_APPEND writes is never folded back
into ppos. Hence the later call to generic_write_sync() still has
the wrong range....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
