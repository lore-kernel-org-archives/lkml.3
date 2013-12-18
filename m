Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab3LRWdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 17:33:18 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:7620 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751072Ab3LRWdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 17:33:17 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AogHAHwhslJ5LHyk/2dsb2JhbABZgwqDPLEUhV2BHBd0giUBAQEEOhwjEAgDGAklDwUlAyETiAPKbxaOfAeENgSYFYpMh0mBbYFSKA
Date: Thu, 19 Dec 2013 09:33:13 +1100
From: Dave Chinner <david@fromorbit.com>
To: arno <arno@disconnect.de>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [XFS BUG] xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed:
 Structure needs cleaning
Message-ID: <20131218223312.GP31386@dastard>
References: <52B1B89A.8030401@disconnect.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B1B89A.8030401@disconnect.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 04:00:42PM +0100, arno wrote:
> Hello,
> 
> (Please keep me in CC, I'm not subscribed)
> 
> Just got "xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Structure
> needs cleaning" when trying to grow a logical Volume. Sorry, I lost the
> xfs_growfs output.
> 
> After collecting some info, I ran xfs_repair, and that seemed to fix it,
> so no harm done. After fixing, the FS had the new, increased size, if
> that matters.

This isn't the first time you've grown the filesystem, is it?

On older kernels, growfs could leave trailing garbage in the new
secondary superblocks it created. This was fixed in kernel v3.8 by
commit:

1375cb6 xfs: growfs: don't read garbage for new secondary superblocks

This garbage is detected by other changes made in v3.8 that verify
the secondary superblocks as they are read.

9802182 xfs: verify superblocks as they are read from disk

So if you grew the filesystem on a kernel older than v3.8, growing
it again on a v3.8+ kernel will detect the superblock corruption and
throw this error.

xfs_repair was recently fixed to detect the garbage in secondary
superblocks and zero it:

cbd7508 xfs_repair: zero out unused parts of superblocks

So what you need to do is run xfs_repair built from the development
git tree and run it on your filesystem. That will remove the garbage
from the superblocks and make this problem go away forever.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
