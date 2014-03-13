Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbaCMUBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 16:01:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47729 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbaCMUBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 16:01:22 -0400
Date: Thu, 13 Mar 2014 21:01:19 +0100
From: Jan Kara <jack@suse.cz>
To: Roman Peniaev <r.peniaev@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/1] fs/mpage.c: forgotten WRITE_SYNC in case of data
 integrity write
Message-ID: <20140313200119.GB504@quack.suse.cz>
References: <1392519268-29991-1-git-send-email-r.peniaev@gmail.com>
 <20140218155945.ee2e22e07fa3b4f242b16a7f@linux-foundation.org>
 <CACZ9PQV8RsaefFAOt5b-aL33G3CiD+3+fTuW15io6u1DH3XJ6Q@mail.gmail.com>
 <CACZ9PQUKzsP4mwJSO3c=Z3W2pYr2AME-9j+1Cqg9t8a4T+uQQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACZ9PQUKzsP4mwJSO3c=Z3W2pYr2AME-9j+1Cqg9t8a4T+uQQg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Wed 12-03-14 23:29:04, Roman Peniaev wrote:
> could you please explain the real purpose of WAIT_SYNC?
> In case of wbc->sync_mode == WB_SYNC_ALL.
> Because my current understanding is if writeback control has
> WB_SYNC_ALL everything
> should be submitted with WAIT_SYNC.
  So AFAIK the idea is that REQ_SYNC flag should indicate the IO is
synchronous - i.e., someone is waiting for it to complete. This is opposed
to asynchronous writeback done by flusher threads where noone waits for
particular write to complete. Subsequently, IO scheduler is expected (but
not required to - only CFQ honors REQ_SYNC AFAIK) to treat sync requests
with higher priority than async onces.

When to set REQ_SYNC is not an obvious question. If we set it for too much
IO, it has no effect. If we don't set it for some IO we risk that someone
waiting for that IO to complete will be starved by others setting REQ_SYNC.

So all in all I think that using WRITE_SYNC iff we are doing WB_SYNC_ALL
writeback is a reasonable choice.

								Honza

> On Wed, Feb 19, 2014 at 10:38 AM, Roman Peniaev <r.peniaev@gmail.com> wrote:
> > (my previous email was rejected by vger.kernel.org because google web
> > sent it as html.
> >  will resend the same one in plain text mode)
> >
> >> What do REQ_SYNC and REQ_NOIDLE actually *do*?
> >
> > Yep, this REQ_SYNC is very confusing to me.
> > First of all according to the sources of old school block buffer filesystems
> > (e.g. ext2) we can get this stack in case of fsync call:
> >
> >      __filemap_fdatawrite_range(mapping, 0, LLONG_MAX, sync_mode)
> >       do_writepages(mapping, &wbc)
> >          mapping->a_ops->writepages(page, wbc)
> >          (ext2_writepages)
> >             mpage_writepages(mapping, wbc, fat_get_block);
> >               write_cache_pages(mapping, wbc, __mpage_writepage, &mpd)
> >                 __mpage_writepage(page, wbc, data)
> >>>>>>             mpage_bio_submit(WRITE, bio) >>>> why WRITE? not WRITE_SYNC in case of WB_SYNC_ALL?
> >                     <or in case of not contiguous buffers>
> >                   mapping->a_ops->writepage(page, wbc)
> >                   (ext2_writepage)
> >                     block_write_full_page(page, fat_get_block, wbc)
> >                       block_write_full_page_endio(page, get_block, wbc,
> >                                                   end_buffer_async_write)
> >                         __block_write_full_page(inode, page, get_block, wbc,
> >                                                 handler);
> >                           submit_bh(WRITE_SYNC)
> >
> > So, it turns out to be that some bios for the same dirty range
> > can be submitted with REQ_WRITE|REQ_SYNC|REQ_NOIDLE and some of
> > the bios only with REQ_WRITE.
> > (according to the comment of __mpage_writepage:
> >  * If all blocks are found to be contiguous then the page can go into the
> >  * BIO.  Otherwise fall back to the mapping's writepage().
> > )
> >
> > Also, it seems to me that all over the kernel WRITE_SYNC has meaning of:
> > 1. try to get the block on-disk faster
> > 2. if I have to do flush - mark my bio with WRITE_SYNC and wait for result
> >
> > My patch is an attempt to make some unification in case of fsync call.
> >
> > --
> > Roman
> >
> >
> > On Wed, Feb 19, 2014 at 8:59 AM, Andrew Morton
> > <akpm@linux-foundation.org> wrote:
> >> On Sun, 16 Feb 2014 11:54:28 +0900 Roman Pen <r.peniaev@gmail.com> wrote:
> >>
> >>> In case of wbc->sync_mode == WB_SYNC_ALL we need to do data integrity write,
> >>> thus mark request as WRITE_SYNC.
> >>
> >> gargh, the documentation for this stuff is useless.
> >>
> >> What do REQ_SYNC and REQ_NOIDLE actually *do*?
> >>
> >> For mpage writes, REQ_NOIDLE appears to be incorrect - we very much
> >> expect that there will be more writes and that they will be contiguous
> >> with this one.  But we won't be waiting on this write before submitting
> >> more writes, so perhaps REQ_NOIDLE is at least harmless.
> >>
> >> I dunno about REQ_SYNC - it requires delving into the bowels of CFQ
> >> and we shouldn't need to do that.
> >>
> >> Jens.  Help.  How is a poor kernel reader supposed to work this out?
> >>
> >>> --- a/fs/mpage.c
> >>> +++ b/fs/mpage.c
> >>> @@ -462,6 +462,7 @@ static int __mpage_writepage(struct page *page, struct writeback_control *wbc,
> >>>       struct buffer_head map_bh;
> >>>       loff_t i_size = i_size_read(inode);
> >>>       int ret = 0;
> >>> +     int wr = (wbc->sync_mode == WB_SYNC_ALL ?  WRITE_SYNC : WRITE);
> >>>
> >>>       if (page_has_buffers(page)) {
> >>>               struct buffer_head *head = page_buffers(page);
> >>> @@ -570,7 +571,7 @@ page_is_mapped:
> >>>        * This page will go to BIO.  Do we need to send this BIO off first?
> >>>        */
> >>>       if (bio && mpd->last_block_in_bio != blocks[0] - 1)
> >>> -             bio = mpage_bio_submit(WRITE, bio);
> >>> +             bio = mpage_bio_submit(wr, bio);
> >>>
> >>>  alloc_new:
> >>>       if (bio == NULL) {
> >>> @@ -587,7 +588,7 @@ alloc_new:
> >>>        */
> >>>       length = first_unmapped << blkbits;
> >>>       if (bio_add_page(bio, page, length, 0) < length) {
> >>> -             bio = mpage_bio_submit(WRITE, bio);
> >>> +             bio = mpage_bio_submit(wr, bio);
> >>>               goto alloc_new;
> >>>       }
> >>>
> >>> @@ -620,7 +621,7 @@ alloc_new:
> >>>       set_page_writeback(page);
> >>>       unlock_page(page);
> >>>       if (boundary || (first_unmapped != blocks_per_page)) {
> >>> -             bio = mpage_bio_submit(WRITE, bio);
> >>> +             bio = mpage_bio_submit(wr, bio);
> >>>               if (boundary_block) {
> >>>                       write_boundary_block(boundary_bdev,
> >>>                                       boundary_block, 1 << blkbits);
> >>> @@ -632,7 +633,7 @@ alloc_new:
> >>>
> >>>  confused:
> >>>       if (bio)
> >>> -             bio = mpage_bio_submit(WRITE, bio);
> >>> +             bio = mpage_bio_submit(wr, bio);
> >>>
> >>>       if (mpd->use_writepage) {
> >>>               ret = mapping->a_ops->writepage(page, wbc);
> >>> @@ -688,8 +689,11 @@ mpage_writepages(struct address_space *mapping,
> >>>               };
> >>>
> >>>               ret = write_cache_pages(mapping, wbc, __mpage_writepage, &mpd);
> >>> -             if (mpd.bio)
> >>> -                     mpage_bio_submit(WRITE, mpd.bio);
> >>> +             if (mpd.bio) {
> >>> +                     int wr = (wbc->sync_mode == WB_SYNC_ALL ?
> >>> +                               WRITE_SYNC : WRITE);
> >>> +                     mpage_bio_submit(wr, mpd.bio);
> >>> +             }
> >>>       }
> >>>       blk_finish_plug(&plug);
> >>>       return ret;
> >>> @@ -706,8 +710,11 @@ int mpage_writepage(struct page *page, get_block_t get_block,
> >>>               .use_writepage = 0,
> >>>       };
> >>>       int ret = __mpage_writepage(page, wbc, &mpd);
> >>> -     if (mpd.bio)
> >>> -             mpage_bio_submit(WRITE, mpd.bio);
> >>> +     if (mpd.bio) {
> >>> +             int wr = (wbc->sync_mode == WB_SYNC_ALL ?
> >>> +                       WRITE_SYNC : WRITE);
> >>> +             mpage_bio_submit(wr, mpd.bio);
> >>> +     }
> >>>       return ret;
> >>>  }
> >>>  EXPORT_SYMBOL(mpage_writepage);
> >>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
