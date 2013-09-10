Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab3IJOfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 10:35:43 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:47690 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab3IJOfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 10:35:41 -0400
Date: Tue, 10 Sep 2013 17:34:16 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Minchan Kim <minchan@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: zram: minimize `slot_free_lock' usage (v2)
Message-ID: <20130910143416.GC2270@swordfish>
References: <20130906151255.GE2238@swordfish.minsk.epam.com>
 <20130909123329.GZ19256@mwanda>
 <20130909124942.GA2221@swordfish.minsk.epam.com>
 <20130909132124.GY6329@mwanda>
 <522DD125.1030607@redhat.com>
 <522DF2DF.5060407@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522DF2DF.5060407@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (09/09/13 18:10), Jerome Marchand wrote:
> On 09/09/2013 03:46 PM, Jerome Marchand wrote:
> > On 09/09/2013 03:21 PM, Dan Carpenter wrote:
> >> On Mon, Sep 09, 2013 at 03:49:42PM +0300, Sergey Senozhatsky wrote:
> >>>>> Calling handle_pending_slot_free() for every RW operation may
> >>>>> cause unneccessary slot_free_lock locking, because most likely
> >>>>> process will see NULL slot_free_rq. handle_pending_slot_free()
> >>>>> only when current detects that slot_free_rq is not NULL.
> >>>>>
> >>>>> v2: protect handle_pending_slot_free() with zram rw_lock.
> >>>>>
> >>>>
> >>>> zram->slot_free_lock protects zram->slot_free_rq but shouldn't the zram
> >>>> rw_lock be wrapped around the whole operation like the original code
> >>>> does?  I don't know the zram code, but the original looks like it makes
> >>>> sense but in this one it looks like the locks are duplicative.
> >>>>
> >>>> Is the down_read() in the original code be changed to down_write()?
> >>>>
> >>>
> >>> I'm not touching locking around existing READ/WRITE commands.
> >>>
> >>
> >> Your patch does change the locking because now instead of taking the
> >> zram lock once it takes it and then drops it and then retakes it.  This
> >> looks potentially racy to me but I don't know the code so I will defer
> >> to any zram maintainer.
> > 
> > You're right. Nothing prevents zram_slot_free_notify() to repopulate the
> > free slot queue while we drop the lock.
> > 
> > Actually, the original code is already racy. handle_pending_slot_free()
> > modifies zram->table while holding only a read lock. It needs to hold a
> > write lock to do that. Using down_write for all requests would obviously
> > fix that, but at the cost of read performance.
> 
> Now I think we can drop the call to handle_pending_slot_free() in
> zram_bvec_rw() altogether. As long as the write lock is held when
> handle_pending_slot_free() is called, there is no race. It's no different
> from any write request and the current code handles R/W concurrency
> already.

Yes, I think that can work. 

To summarize, there should be 3 patches:
1) handle_pending_slot_free() in zram_bvec_rw() (as suggested by Jerome Marchand)
2) handle_pending_slot_free() race with reset (found by Dan Carpenter)
3) drop init_done and use init_done()

I'll prepare a patches later today.

	-ss

> Jerome
> 
> > 
> >>
> >> 1) You haven't given us any performance numbers so it's not clear if the
> >>    locking is even a problem.
> >>
> >> 2) The v2 patch introduces an obvious deadlock in zram_slot_free()
> >>    because now we take the rw_lock twice.  Fix your testing to catch
> >>    this kind of bug next time.
> >>
> >> 3) Explain why it is safe to test zram->slot_free_rq when we are not
> >>    holding the lock.  I think it is unsafe.  I don't want to even think
> >>    about it without the numbers.
> >>
> >> regards,
> >> dan carpenter
> >>
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> 
