Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab3HTDdg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 23:33:36 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:43865 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751757Ab3HTDdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 23:33:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmMHAMniElJ5LJ62/2dsb2JhbABagwWDN7dHhTuBJBd0giQBAQQBJxMcIwULCAMOCgklDwUlAyETiAoFqzYWkEYHhBIDl2OKKYctgy4q
Date: Tue, 20 Aug 2013 13:33:29 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Dave Hansen <dave.hansen@linux.intel.com>, xfs@oss.sgi.com,
        Jan Kara <jack@suse.cz>, Tim Chen <tim.c.chen@linux.intel.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 2/5] fs: Add inode_update_time_writable
Message-ID: <20130820033329.GG6023@dastard>
References: <cover.1376679411.git.luto@amacapital.net>
 <a27accc2d9460b7ef194a203f305a18dafe926e8.1376679411.git.luto@amacapital.net>
 <20130820022822.GD6023@dastard>
 <CALCETrVE2G4x9mL0-o1FDQPfc=qZzw10Cx6AgOdhwphSaCmyzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVE2G4x9mL0-o1FDQPfc=qZzw10Cx6AgOdhwphSaCmyzw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 08:20:12PM -0700, Andy Lutomirski wrote:
> On Mon, Aug 19, 2013 at 7:28 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Fri, Aug 16, 2013 at 04:22:09PM -0700, Andy Lutomirski wrote:
> >> This is like file_update_time, except that it acts on a struct inode *
> >> instead of a struct file *.
> >>
> >> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> >> ---
> >>  fs/inode.c         | 72 ++++++++++++++++++++++++++++++++++++++++++------------
> >>  include/linux/fs.h |  1 +
> >>  2 files changed, 58 insertions(+), 15 deletions(-)
> >>
> 
> [...]
> 
> >> +
> >> +int inode_update_time_writable(struct inode *inode)
> >> +{
> >> +     struct timespec now;
> >> +     int sync_it = prepare_update_cmtime(inode, &now);
> >> +     int ret;
> >> +
> >> +     if (!sync_it)
> >> +             return 0;
> >> +
> >> +     /* sb_start_pagefault and update_time can both sleep. */
> >> +     sb_start_pagefault(inode->i_sb);
> >> +     ret = update_time(inode, &now, sync_it);
> >> +     sb_end_pagefault(inode->i_sb);
> >
> > This gets called from the writeback path - you can't use
> > sb_start_pagefault/sb_end_pagefault in that path.
> 
> The race I'm worried about is:
> 
>  - mmap
>  - write to the mapping
>  - remount ro
>  - flush_cmtime -> inode_update_time_writable

sb_start_pagefault() is for filesystem freeze protection, not
remount-ro protection. If you freeze the filesystem, then we stop
writes and pagefaults by making sb_start_pagefault/sb_start_write
block, and then run writeback to clean all the pages.  If writeback
then blocks on sb_start_pagefault(), we've got a deadlock.

> This may be impossible, in which case I'm okay, but it's nice to have
> a sanity check.  I'll see if I can figure out how to do that.

The process of remount-ro should flush the dirty pages - the inode
and page has been marked dirty by page_mkwrite(), after all.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
