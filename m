Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab3F0ErR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 00:47:17 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:53914 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750960Ab3F0ErP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 00:47:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArsPALDCy1F5LKwQ/2dsb2JhbABbgwm6W4UgBAF+F3SCIwEBBAEnExwjBQsIAxgJJQ8FJQMhE4gIBbobFo4igR0HgwJhA5dEih+HJ4MjKg
Date: Thu, 27 Jun 2013 14:47:05 +1000
From: Dave Chinner <david@fromorbit.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, tux3@tux3.org
Subject: Re: [PATCH] Optimize wait_sb_inodes()
Message-ID: <20130627044705.GB29790@dastard>
References: <87ehbpntuk.fsf@devron.myhome.or.jp>
 <20130626231143.GC28426@dastard>
 <87wqpg76ls.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wqpg76ls.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 09:14:07AM +0900, OGAWA Hirofumi wrote:
> Dave Chinner <david@fromorbit.com> writes:
> 
> >> On another view, wait_sb_inodes() would (arguably) be necessary for
> >> legacy FSes. But, for example, if data=journal on ext*, wait_sb_inodes()
> >> would be more than useless, because ext* can be done it by own
> >> transaction list (and more efficient way).
> >> 
> >> Likewise, on tux3, the state is same with data=journal.
> >> 
> >> Also, even if data=ordered, ext* might be able to check in-flight I/O by
> >> ordered data list (with some new additional check, I'm not sure).
> >
> > Why would you bother solving this problem differently in every
> > single filesystem? It's solvable at the VFS by tracking inodes that
> > are no longer dirty but still under writeback on the BDI. Then
> > converting wait_sb_inodes() to walk all the dirty and writeback
> > inodes would be sufficient for data integrity purposes, and it would
> > be done under the bdi writeback lock, not the inode_sb_list_lock....
> >
> > Alternatively, splitting up the inode sb list and lock (say via the
> > per-node list_lru structures in -mm and -next that are being added
> > for exactly this purpose) would also significantly reduce lock
> > contention on both the create/evict fast paths and the
> > wait_sb_inodes() walk that is currently done....
> >
> > So I think that you should address the problem properly at the VFS
> > level so everyone benefits, not push interfaces that allow
> > filesystem specific hacks to work around VFS level deficiencies...
> 
> Optimizing wait_sb_inodes() might help lock contention, but it doesn't
> help unnecessary wait/check.

You have your own wait code, that doesn't make what the VFS does
unnecesary. Quite frankly, I don't trust individual filesystems to
get it right - there's a long history of filesystem specific data
sync problems (including in XFS), and the best way to avoid that is
to ensure the VFS gets it right for you.

Indeed, we've gone from having sooper special secret sauce data sync
code in XFS to using the VFS over the past few years, and the result
is that it is now more reliable and faster than when we were trying
to be smart and do it all ourselves. We got to where we are by
fixing the problems in the VFS rather than continuing to try to work
around them.

> Since some FSes know about current
> in-flight I/O already in those internal, so I think, those FSes can be
> done it here, or are already doing in ->sync_fs().

Sure, do your internal checks in ->sync_fs(), but if
wait_sb_inodes() does not have any lock contention and very little
overhead, then why do you need to avoid it? This wait has to be done
somewhere between sync_inodes_sb() dispatching all the IO and
->sync_fs completing, so what's the problem with hving the VFS do
that *for everyone* efficiently?

Fix the root cause of the problem - the sub-optimal VFS code.
Hacking around it specifically for out-of-tree code is not the way
things get done around here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
