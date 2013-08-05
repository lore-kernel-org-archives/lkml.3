Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab3HEXnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 19:43:13 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59419 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755069Ab3HEXnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 19:43:11 -0400
Message-ID: <1375746189.18481.23.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH] [SCSI] sg: Fix user memory corruption when SG_IO is
 interrupted by a signal
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Roland Dreier <roland@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Doug Gilbert <dgilbert@interlog.com>,
        Costa Sapuntzakis <costa@purestorage.com>,
        =?ISO-8859-1?Q?J=F6rn?= Engel <joern@purestorage.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Date: Mon, 05 Aug 2013 16:43:09 -0700
In-Reply-To: <CAG4TOxP6H9isOHYJN=oKgHPna=wWqfOgg2Zh5cpvNFsgNkh8xA@mail.gmail.com>
References: <1375740121-23350-1-git-send-email-roland@kernel.org>
	 <1375745462.18481.22.camel@dabdike.int.hansenpartnership.com>
	 <CAG4TOxP6H9isOHYJN=oKgHPna=wWqfOgg2Zh5cpvNFsgNkh8xA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-05 at 16:38 -0700, Roland Dreier wrote:
> On Mon, Aug 5, 2013 at 4:31 PM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > I agree with the analysis.  The fix is a bit draconian, though.  A
> > workqueue actually runs in a kernel thread and there's a simple test for
> > that (!current->mm), so how about this instead (which is much less
> > intrusive)
> 
> > ---
> 
> > diff --git a/fs/bio.c b/fs/bio.c
> > index 94bbc04..e2ab39c 100644
> > --- a/fs/bio.c
> > +++ b/fs/bio.c
> > @@ -1045,12 +1045,22 @@ static int __bio_copy_iov(struct bio *bio, struct bio_vec *iovecs,
> >  int bio_uncopy_user(struct bio *bio)
> >  {
> >         struct bio_map_data *bmd = bio->bi_private;
> > -       int ret = 0;
> > +       struct bio_vec *bvec;
> > +       int ret = 0, i;
> >
> > -       if (!bio_flagged(bio, BIO_NULL_MAPPED))
> > -               ret = __bio_copy_iov(bio, bmd->iovecs, bmd->sgvecs,
> > -                                    bmd->nr_sgvecs, bio_data_dir(bio) == READ,
> > -                                    0, bmd->is_our_pages);
> > +       if (!bio_flagged(bio, BIO_NULL_MAPPED)) {
> > +               /*
> > +                * if we're in a workqueue, the request is orphaned, so
> > +                * don't copy into the kernel address space, just free
> > +                */
> > +               if (current->mm)
> > +                       ret = __bio_copy_iov(bio, bmd->iovecs, bmd->sgvecs,
> > +                                            bmd->nr_sgvecs, bio_data_dir(bio) == READ,
> > +                                            0, bmd->is_our_pages);
> > +               else if (bmd->is_our_pages)
> > +                       bio_for_each_segment_all(bvec, bio, i)
> > +                               __free_page(bvec->bv_page);
> > +       }
> >         bio_free_map_data(bmd);
> >         bio_put(bio);
> >         return ret;
> 
> Yes, looks reasonable -- I can't think of any reason why anyone would
> ever want the bio code to copy to a random userspace address space.
> 
> Acked-by: Roland Dreier <roland@purestorage.com>

You did all the work ... just replace this patch with your previous one
and keep the original tags. (test it first, of course ...)

James


