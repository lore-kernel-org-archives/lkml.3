Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab3KFUDG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 15:03:06 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:41323 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174Ab3KFUDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 15:03:04 -0500
Date: Wed, 6 Nov 2013 12:02:22 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Chris Mason <chris.mason@fusionio.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        Mike Snitzer <snitzer@redhat.com>, NeilBrown <neilb@suse.de>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] block: Revert bio_clone() default behaviour
Message-ID: <20131106200222.GA3842@kmo>
References: <1383709721-22809-1-git-send-email-kmo@daterainc.com>
 <20131106161130.3802.97153@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131106161130.3802.97153@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 11:11:30AM -0500, Chris Mason wrote:
> Quoting Kent Overstreet (2013-11-05 22:48:41)
> > This patch reverts the default behaviour introduced by
> > 9fc6286f347d00528adcdcf12396d220f47492ed - bio_clone_biovec() no clonger
> > shares the source bio's biovec, cloning the biovec is once again the
> > default.
> > 
> > Instead, we add a new bio_clone_biovec_fast(), which creates a clone
> > that shares the source's biovec. This patch changes bcache and md to use
>                                                                ^^^^^
> 							       dm?
> 
> > __bio_clone_biovec_fast() since they're expecting the new behaviour due
> > to other refactoring; most of the other uses of bio_clone() should be
> > same to convert to the _fast() variant but that will be done more
> > incrementally in other patches (bio_split() in particular).
> 
> Hi Kent,
> 
> I noticed yesterday the _fast variants of bio clone introduce sharing
> between the src and the clone, but without any reference counts:
> 
>         bio->bi_io_vec = bio_src->bi_io_vec;
> 
> Have you audited all of the _fast users to make sure they are not
> freeing the src before the clone?  Sorry if this came up already in past
> reviews.

Yup - that should actually be safe for all the existing bio_clone() users
actually, I audited all of them - because normally you're not going to complete
the original bio until the clone finishes.

> > Note that __bio_clone() isn't being readded - the reason being that with
> > immutable biovecs allocating the right number of biovecs for the new
> > clone is no longer trivial so we don't want drivers trying to do that
> > themselves.
> > 
> > This patch also reverts febca1baea1cfe2d7a0271385d89b03d5fb34f94 -
> > __bio_clone_fast() should not be setting bi_vcnt for bios that do not
> > own the biovec (see Documentation/block/biovecs.txt for rationale) - in
> > short,
> 
> I think I see what you mean with tying bi_vcnt to ownership of the bio,
> but we're not consistent.  Looking at bio_for_eaach_segment_all:
> 
> *
>  * drivers should _never_ use the all version - the bio may have been split
>  * before it got to the driver and the driver won't own all of it
>  */
> #define bio_for_each_segment_all(bvl, bio, i)                           \
>         for (i = 0, bvl = (bio)->bi_io_vec; i < (bio)->bi_vcnt; i++, bvl++)
> 
> bio_for_each_segment_all still trusts bi_vcnt, so any
> bio_for_each_segment_all operation on a clone will basically be a noop.
> 
> Just looking at MD raid1 make_request()
> 
>                 mbio = bio_clone_mddev(bio, GFP_NOIO, mddev);
> 		...
> 		alloc_behind_pages(mbio, r1_bio); -> bio_for_each_segment_all
> 		...
> 		if (r1_bio->behind_bvecs) {
>                         bio_for_each_segment_all(bvec, mbio, j)
> 			...
> 
> I didn't test MD without the vcnt fix, but I think any operations in MD
> that duplicate data for raid1 turn into noops.  I think we'll end up
> writing garbage (or nothing) to the second mirror.
> 
> If you look at dm's crypt_free_buffer_pages(), it had similar problems.

Those are fine actually - in both cases, they're bios they allocated, not the
bios that were submitted to them. Though md _definitely_ shouldn't have been
sharing the original bio's biovec, so looks like this patch will fix a bug
there...

(I remember seeing that code before and I thought I added a bio_clone_biovec()
call to that md code, but apparently that never got commited. Argh.)

> 
> > not setting it might cause bugs in the short term but long term
> > it's likely to hide nastier more subtle bugs, we don't want code looking
> > at bi_vcnt at all for bios it does not own.
> 
> I think the concept of bio ownership is still much too weak, at least
> for established users like MD and DM.  I don't know how to verify the
> sharing of bi_io_vec without some kind of reference counting on the
> iovec.

What's unclear about it? The rule is just - if you didn't allocate the biovec,
don't modify it or use bio_for_each_segment_all() (probably I didn't quite state
it clearly enough before though)
