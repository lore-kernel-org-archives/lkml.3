Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaBBWDw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 17:03:52 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:56220 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752462AbaBBWDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 17:03:51 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8JALS/7lJ5LGaB/2dsb2JhbABagwy5T4VSgQAXdIIlAQEFJxMcIxAIAxgJJQ8FJQMhE4gEzC8XFo5zB4Q4BJgpilCHUoFvgVIo
Date: Mon, 3 Feb 2014 09:03:46 +1100
From: Dave Chinner <david@fromorbit.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Namjae Jeon <linkinjeon@gmail.com>, viro@zeniv.linux.org.uk, bpm@sgi.com,
        tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz,
        mtk.manpages@gmail.com, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH RESEND 0/10] fs: Introduce new
 flag(FALLOC_FL_COLLAPSE_RANGE) for fallocate
Message-ID: <20140202220346.GU2212@dastard>
References: <1391319694-3089-1-git-send-email-linkinjeon@gmail.com>
 <20140202151624.GK20939@parisc-linux.org>
 <20140202152106.GL20939@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140202152106.GL20939@parisc-linux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 02, 2014 at 08:21:06AM -0700, Matthew Wilcox wrote:
> On Sun, Feb 02, 2014 at 08:16:24AM -0700, Matthew Wilcox wrote:
> > On Sun, Feb 02, 2014 at 02:41:34PM +0900, Namjae Jeon wrote:
> > > The semantics of this flag are following:
> > > 1) It collapses the range lying between offset and length by removing any data
> > >    blocks which are present in this range and than updates all the logical
> > >    offsets of extents beyond "offset + len" to nullify the hole created by
> > >    removing blocks. In short, it does not leave a hole.
> > > 2) It should be used exclusively. No other fallocate flag in combination.
> > > 3) Offset and length supplied to fallocate should be fs block size aligned
> > >    in case of xfs and ext4.
> > > 4) Collaspe range does not work beyond i_size.
> > 
> > What if the file is mmaped at the time somebody issues this command?
> > Seems to me we should drop pagecache pages that overlap with the
> > removed blocks.  If the removed range is not a multiple of PAGE_SIZE,
> > then we should also drop any pagecache pages after the removed range.
> 
> Oops, forgot to add "and if it is a multiple of page size, then we need
> to update the offsets of any pages after the removed page". 

Yup, that's what the XFS implementation does when it punches the
hole out of the file before shifting the extents down. Check
xfs_free_file_space():

1275         /* wait for the completion of any pending DIOs */
1276         inode_dio_wait(VFS_I(ip));
1277
1278         rounding = max_t(xfs_off_t, 1 << mp->m_sb.sb_blocklog, PAGE_CACHE_SIZE);
1279         ioffset = offset & ~(rounding - 1);
1280         error = -filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
1281                                               ioffset, -1);
1282         if (error)
1283                 goto out;
1284         truncate_pagecache_range(VFS_I(ip), ioffset, -1);

Bonus points for working out why the XFS code doesn't just use
PAGE_CACHE_SIZE for rounding here....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
