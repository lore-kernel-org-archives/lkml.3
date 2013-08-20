Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539Ab3HTQLA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 12:11:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33496 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097Ab3HTQK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 12:10:59 -0400
Date: Tue, 20 Aug 2013 18:10:55 +0200
From: Jan Kara <jack@suse.cz>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Dave Chinner <david@fromorbit.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Dave Hansen <dave.hansen@linux.intel.com>, xfs@oss.sgi.com,
        Jan Kara <jack@suse.cz>, Tim Chen <tim.c.chen@linux.intel.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 2/5] fs: Add inode_update_time_writable
Message-ID: <20130820161055.GD2862@quack.suse.cz>
References: <cover.1376679411.git.luto@amacapital.net>
 <a27accc2d9460b7ef194a203f305a18dafe926e8.1376679411.git.luto@amacapital.net>
 <20130820022822.GD6023@dastard>
 <CALCETrVE2G4x9mL0-o1FDQPfc=qZzw10Cx6AgOdhwphSaCmyzw@mail.gmail.com>
 <20130820033329.GG6023@dastard>
 <CALCETrVrSiXCt5+2801C+QA6B1jzb0K3VHT6w8sVf_VXrz16Bw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVrSiXCt5+2801C+QA6B1jzb0K3VHT6w8sVf_VXrz16Bw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 19-08-13 21:07:49, Andy Lutomirski wrote:
> On Mon, Aug 19, 2013 at 8:33 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Mon, Aug 19, 2013 at 08:20:12PM -0700, Andy Lutomirski wrote:
> >> On Mon, Aug 19, 2013 at 7:28 PM, Dave Chinner <david@fromorbit.com> wrote:
> >> > On Fri, Aug 16, 2013 at 04:22:09PM -0700, Andy Lutomirski wrote:
> >> >> This is like file_update_time, except that it acts on a struct inode *
> >> >> instead of a struct file *.
> >> >>
> >> >> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> >> >> ---
> >> >>  fs/inode.c         | 72 ++++++++++++++++++++++++++++++++++++++++++------------
> >> >>  include/linux/fs.h |  1 +
> >> >>  2 files changed, 58 insertions(+), 15 deletions(-)
> >> >>
> >>
> >> [...]
> >>
> >> >> +
> >> >> +int inode_update_time_writable(struct inode *inode)
> >> >> +{
> >> >> +     struct timespec now;
> >> >> +     int sync_it = prepare_update_cmtime(inode, &now);
> >> >> +     int ret;
> >> >> +
> >> >> +     if (!sync_it)
> >> >> +             return 0;
> >> >> +
> >> >> +     /* sb_start_pagefault and update_time can both sleep. */
> >> >> +     sb_start_pagefault(inode->i_sb);
> >> >> +     ret = update_time(inode, &now, sync_it);
> >> >> +     sb_end_pagefault(inode->i_sb);
> >> >
> >> > This gets called from the writeback path - you can't use
> >> > sb_start_pagefault/sb_end_pagefault in that path.
> >>
> >> The race I'm worried about is:
> >>
> >>  - mmap
> >>  - write to the mapping
> >>  - remount ro
> >>  - flush_cmtime -> inode_update_time_writable
> >
> > sb_start_pagefault() is for filesystem freeze protection, not
> > remount-ro protection. If you freeze the filesystem, then we stop
> > writes and pagefaults by making sb_start_pagefault/sb_start_write
> > block, and then run writeback to clean all the pages.  If writeback
> > then blocks on sb_start_pagefault(), we've got a deadlock.
> >
> >> This may be impossible, in which case I'm okay, but it's nice to have
> >> a sanity check.  I'll see if I can figure out how to do that.
> >
> > The process of remount-ro should flush the dirty pages - the inode
> > and page has been marked dirty by page_mkwrite(), after all.
> 
> Hmm.  We can land in here from writeback, in which case the time
> should be updated unconditionally.  We can also land in here from
> msync(MS_ASYNC) or munmap.  munmap at least shouldn't block.
> 
> The nasty case is if a page is dirtied, then the frozen level is set
> to SB_FREEZE_PAGEFAULT, and then userspace calls munmap or msync
> *before* writepages gets called.  In this case, blocking until the fs
> is unfrozen is probably impolite, and returning without updating the
> time is questionable.
> 
> Removing the check entirely may add a new race, though: what if
> .flush_cmtime has called mapping_test_clear_cmtime but hasn't gotten
> to updating the time yet when freezing finishes?  This could be
> prevented by changing generic_flush_cmtime to do __sb_start_write(sb,
> SB_FREEZE_FS, false) and doing nothing if the fs is already frozen.
  I think it should be a responsibility of the caller of .flush_cmtime (as
is the case of update_time()) to handle freeze protection if needed. As
Dave told you, writeback path mustn't actually take it. OTOH things like
munmap() or msync() need to get it because we must avoid changing the
filesystem when it is frozen and these calls can happen when fs is frozen.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
