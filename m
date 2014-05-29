Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbaE2HtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 03:49:14 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:6119 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751660AbaE2HtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 03:49:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AndMAAfmhlN5LL1sPGdsb2JhbABZgweDRIUIonUGmB4BgRAXAwEBAQE4NYIlAQEFOhwjEAgDGAklDwUlAwcaExuIJtdNFxaFP4h9B4RABJl0lnMr
Date: Thu, 29 May 2014 17:49:09 +1000
From: Dave Chinner <david@fromorbit.com>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: xfs@oss.sgi.com, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: xfs: possible deadlock warning
Message-ID: <20140529074909.GI6677@dastard>
References: <538571D4.70904@cn.fujitsu.com>
 <20140528060050.GK8554@dastard>
 <5386AABD.5070708@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5386AABD.5070708@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 11:34:21AM +0800, Gu Zheng wrote:
> Hi Dave,
> 
> On 05/28/2014 02:00 PM, Dave Chinner wrote:
> 
> > On Wed, May 28, 2014 at 01:19:16PM +0800, Gu Zheng wrote:
> >> Hi all,
> >> When running the latest Linus' tree, the following possible deadlock warning occurs.
> > 
> > false positive. There isn't a deadlock between inode locks on
> > different filesystems. i.e. there is no dependency between shmem
> > inodes and xfs inodes, nor on their security contexts.  Nor can you
> > take a page fault on a directory inode, which is the XFS inode lock
> > class it's complaining about.
> 
> If it's really a noisy, can we avoid this?

It's on my list of things to do. The XFs directory locking was
changed slightly to remove race condition that SGI's CXFS filesystem
was hitting, and that introduced all these lockdep false positives.

Unfortunately, to get rid of the lockdep false positives we can
either:

	a) revert the locking change; or
	b) rewrite the readdir code to use more fine grained locking
	   so that we don't hold the lock over filldir() calls.

I don't think that reverting a change that fixed a directory
corruption problem is a good idea, so rewriting the readdir code is
the solution.

SGI have disappeared off the planet so they aren't going to fix it
anytime soon, so it's waiting for me to find the time to finish and
test the patches I have ibeen working on in my spare time that
rework the readdir code.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
