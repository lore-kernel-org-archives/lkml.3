Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbaKZR2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 12:28:54 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38816 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbaKZR2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 12:28:53 -0500
Date: Wed, 26 Nov 2014 09:28:42 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] dm-bufio: fix memleak when using a dm_buffer's inline
 bio
Message-ID: <20141126172842.GG10050@birch.djwong.org>
References: <20141126014515.GE10050@birch.djwong.org>
 <20141126034103.GA26585@redhat.com>
 <20141126040008.GF10050@birch.djwong.org>
 <20141126142832.GB29855@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141126142832.GB29855@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 09:28:32AM -0500, Mike Snitzer wrote:
> On Tue, Nov 25 2014 at 11:00pm -0500,
> Darrick J. Wong <darrick.wong@oracle.com> wrote:
> 
> > On Tue, Nov 25, 2014 at 10:41:04PM -0500, Mike Snitzer wrote:
> > > On Tue, Nov 25 2014 at  8:45pm -0500,
> > > Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > > 
> > > > When dm-bufio sets out to use the bio built into a struct dm_buffer to
> > > > issue an IO, it needs to call bio_reset after it's done with the bio
> > > > so that we can free things attached to the bio such as the integrity
> > > > payload.  Therefore, inject our own endio callback to take care of
> > > > the bio_reset after calling submit_io's end_io callback.
> > > > 
> > > > Test case:
> > > > 1. modprobe scsi_debug delay=0 dif=1 dix=199 ato=1 dev_size_mb=300
> > > > 2. Set up a dm-bufio client, e.g. dm-verity, on the scsi_debug device
> > > > 3. Repeatedly read metadata and watch kmalloc-192 leak!
> > > > 
> > > > Fix is against 3.18-rc6.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Thanks for reporting/fixing this.
> > > 
> > > Alternatively I think we could just call bio_reset() in submit_io(),
> > > e.g.:
> > > 
> > > diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> > > index afe7971..e7036e3 100644
> > > --- a/drivers/md/dm-bufio.c
> > > +++ b/drivers/md/dm-bufio.c
> > > @@ -579,6 +579,8 @@ static void submit_io(struct dm_buffer *b, int rw, sector_t block,
> > >  	if (rw == WRITE && b->c->write_callback)
> > >  		b->c->write_callback(b);
> > >  
> > > +	bio_reset(&b->bio);
> > > +
> > >  	if (b->c->block_size <= DM_BUFIO_INLINE_VECS * PAGE_SIZE &&
> > >  	    b->data_mode != DATA_MODE_VMALLOC)
> > >  		use_inline_bio(b, rw, block, end_io);
> > > 
> > > What do you think?
> > 
> > I decided to call bio_reset after calling end_io so that we can free
> > the integrity buffer as soon as we're done with the bio.  Calling
> > bio_reset just prior to the next submit_bio as this snippet does means
> > that the integrity buffer remains attached to the bio until just
> > before the next submit_bio call, which could be a while.
> > 
> > Also, I think use_dmio results in a new bio being used instead of the
> > bio embedded in the dm_buffer, so it shouldn't be necessary to reset
> > the bio if the previous IO had use_dmio'd.
> 
> OK, yeah, a new embedded bio is created as a side-effect of allocating a
> new dm_buffer.  So we have to use bi_end_io like you've done.
> 
> I didn't like seeing your use of .bi_private (because in the context of
> bios that are passed into DM: .bi_private must always be preserved so as
> not to break upper layers of the IO stack that might be using it).

<nod> I hadn't considered that not restoring .bi_private without
comment would raise eyebrows in a space where the norm is that they
must always be preserved.  :)

> But in the context of bufio's embedded bio, using .bi_private seems
> fine.  Just needs a comment.  I'll fixup and get your patch staged (and
> will CC stable).

The staged patch looks good, thank you!

--D

> 
> Thanks again,
> Mike
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
