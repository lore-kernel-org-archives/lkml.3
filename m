Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760838Ab3IDTUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 15:20:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41483 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760719Ab3IDTUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 15:20:52 -0400
Date: Wed, 4 Sep 2013 21:20:48 +0200
From: Jan Kara <jack@suse.cz>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Jan Kara <jack@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Dave Hansen <dave.hansen@linux.intel.com>, xfs@oss.sgi.com,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v4 3/7] mm: Allow filesystems to defer cmtime updates
Message-ID: <20130904192048.GM3996@quack.suse.cz>
References: <cover.1377193658.git.luto@amacapital.net>
 <e1620c8e4909a65e270c8e9590e307c22fd96a44.1377193658.git.luto@amacapital.net>
 <20130904145740.GE3996@quack.suse.cz>
 <CALCETrUA653bw3C=XP=Es9UApqsKsDG-UAzuZ=qS1RA1LeoKYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUA653bw3C=XP=Es9UApqsKsDG-UAzuZ=qS1RA1LeoKYw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 04-09-13 10:54:50, Andy Lutomirski wrote:
> >> @@ -1970,6 +1988,39 @@ int write_one_page(struct page *page, int wait)
> >>  }
> >>  EXPORT_SYMBOL(write_one_page);
> >>
> >> +void mapping_flush_cmtime(struct address_space *mapping)
> >> +{
> >> +     if (mapping_test_clear_cmtime(mapping) &&
> >> +         mapping->a_ops->update_cmtime_deferred)
> >> +             mapping->a_ops->update_cmtime_deferred(mapping);
> >> +}
> >> +EXPORT_SYMBOL(mapping_flush_cmtime);
> >   Hum, is there a reason for update_cmtime_deferred() operation? I can
> > hardly imagine anyone will want to do anything else than what
> > inode_update_time_writable() does so why bother? You mention tmpfs & co.
> > don't fit into your scheme well with which I agree so let's just keep
> > file_update_time() in their page_mkwrite() operation. But I don't see a
> > real need for avoiding the deferred cmtime logic...
> 
> I think there might be odd corner cases.  For example, mmap a tmpfs
> file, write it, and unmap it.  Then, an hour later, maybe the system
  If you unmap it then that will handle the update. But if you won't unmap,
you'd get spurious updates of timestamps which would be strange.

> will be under memory pressure and page out the file.  This could
> trigger a surprising time update.  (I'm not sure this can actually
> happen on tmpfs, but maybe it would on some other filesystem.)
> 
> Does this actually matter?  A flag to turn the feature on or off would
> do the trick, but I don't think there's precedent for sticking a flag
> in a_ops.
  Flag in a_ops is ugly. But you can have a flag in 'struct
filesystem_type' which would be reasonable. 

> >> +void mapping_flush_cmtime_nowb(struct address_space *mapping)
> >> +{
> >> +     /*
> >> +      * We get called from munmap and msync.  Both calls can race
> >> +      * with fs freezing.  If the fs is frozen after
> >> +      * mapping_test_clear_cmtime but before the time update, then
> >> +      * sync_filesystem will miss the cmtime update (because we
> >> +      * just cleared it) and we don't be able to write (because the
> >> +      * fs is frozen).  On the other hand, we can't just return if
> >> +      * we're in the SB_FREEZE_PAGEFAULT state because our caller
> >> +      * expects the timestamp to be synchronously updated.  So we
> >> +      * get write access without blocking, at the SB_FREEZE_FS
> >> +      * level.  If the fs is already fully frozen, then we already
> >> +      * know we have nothing to do.
> >> +      */
> >> +
> >> +     if (!mapping_test_cmtime(mapping))
> >> +             return;  /* Optimization: nothing to do. */
> >> +
> >> +     if (__sb_start_write(mapping->host->i_sb, SB_FREEZE_FS, false)) {
> >> +             mapping_flush_cmtime(mapping);
> >> +             __sb_end_write(mapping->host->i_sb, SB_FREEZE_FS);
> >> +     }
> >> +}
> >   This is wrong because SB_FREEZE_FS level is targetted for filesystem
> > internal use. Also it is racy. mapping_flush_cmtime() ends up calling
> > mark_inode_dirty() and filesystems such as ext4 or xfs will start a
> > transaction to store inode in the journal. This gets freeze protection at
> > SB_FREEZE_FS level again. If freeze_super() sets s_writers.frozen to
> > SB_FREEZE_FS before this second protection, things will deadlock.
> 
> Whoops -- I assumed that it was safe to recursively take freeze
> protection at the same level.
> 
> I'm worried about the following race:
> 
> Thread 1 (in munmap):
> Check AS_CMTIME set
> sb_start_pagefault
> 
> Thread 2 (freezing the fs):
> frozen = SB_FREEZE_PAGEFAULT;
> sync_filesystem()
> 
> Thread 1 is now stuck.  It doesn't need to be, because sync_filesystem
> will flush out the cmtime write.  But there doesn't seem to be a clean
> mechanism to wait for the freeze to finish.
  OK, I see. Frankly, I'd rather live with msync() and munmap() blocking
while filesystem is frozen than trying to outsmart the freezing logic...
If someone comes up with a usecase where it causes trouble, we can always
improve the logic with some clever tricks.

> Is there a clean way to avoid this?  I don't want to return
> immediately if a freeze is in progress, because userspace expects that
> munmap will update cmtime synchronously.
> 
> And ugly but simple solution is:
> 
> if (!mapping_test_cmtime(mapping))
>     return;  /* Optimization: nothing to do. */
> 
> if (__sb_start_write(mapping->host->i_sb, SB_FREEZE_FS, false)) {
>     mapping_flush_cmtime(mapping);
>     __sb_end_write(mapping->host->i_sb, SB_FREEZE_FS);
> } else {
>     /* Freeze is or was in progress.  The part of freezing from
> SB_FREEZE_PAGEFAULT through sync_filesystem holds s_umount for write,
> so we can wait for it to finish by taking s_umount for read. */
>     down_read(&sb->s_umount);
>     up_read(&sb->s_umount);
> }
  Yes, this would probably work but as I said above, I'd prefer the to keep
it simple unless we have a good reason for the complex solution.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
