Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab3JaVzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 17:55:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53382 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab3JaVzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 17:55:16 -0400
Message-ID: <5272D1BB.3030205@infradead.org>
Date: Thu, 31 Oct 2013 14:55:07 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Kent Overstreet <kmo@daterainc.com>, axboe@kernel.dk
CC: tj@kernel.org, linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] block: Document immutable biovecs
References: <1383254825-25609-1-git-send-email-kmo@daterainc.com>
In-Reply-To: <1383254825-25609-1-git-send-email-kmo@daterainc.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/13 14:27, Kent Overstreet wrote:
> Signed-off-by: Kent Overstreet <kmo@daterainc.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: NeilBrown <neilb@suse.de>
> Cc: Christoph Hellwig <hch@lst.de>
> ---
>  Documentation/block/biovecs.txt | 111 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/blk_types.h       |   3 +-
>  2 files changed, 113 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/block/biovecs.txt
> 
> diff --git a/Documentation/block/biovecs.txt b/Documentation/block/biovecs.txt
> new file mode 100644
> index 0000000..34711fa
> --- /dev/null
> +++ b/Documentation/block/biovecs.txt
> @@ -0,0 +1,111 @@
> +
> +Immutable biovecs and biovec iterators:
> +=======================================
> +
> +Kent Overstreet <kmo@daterainc.com>
> +
> +As of 3.13, biovecs should never be modified after a bio has been submitted.
> +Instead, we have a new struct bvec_iter which represents a range of a biovec -
> +the iterator will be modified as the bio is completed, not the biovec.
> +
> +More specifically, old code that needed to partially complete a bio would
> +update bi_sector and bi_size, and advance bi_idx to the next biovec. If it
> +ended up partway through a biovec, it would increment bv_offset and decrement
> +bv_len by the number of bytes completed in that biovec.
> +
> +In the new scheme of things, everything that must be mutated in order to
> +partially complete a bio is segregated into struct bvec_iter: bi_sector,
> +bi_size and bi_idx have been moved there; and instead of modifying bv_offset
> +and bv_len, struct bvec_iter has bi_bvec_done, which represents the number of
> +bytes completed in the current bvec.
> +
> +There are a bunch of new helper macros for hiding the gory details - in
> +particular, presenting the illusion of partially completed biovecs so that
> +normal code doesn't have to deal with bi_bvec_done.
> +
> + * Driver code should no longer refer to biovecs directly; we now have
> +   bio_iovec() and bio_iovec_iter() macros that return literal struct biovecs,
> +   constructed from the raw biovecs but taking into account bi_bvec_done and
> +   bi_size.
> +
> +   bio_for_each_segment() has been updated to take a bvec_iter argument
> +   instead of an integer (that corresponded to bi_idx); for a lot of code the
> +   conversion just required changing the types of the arguments to
> +   bio_for_each_segment().
> +
> + * Advancing a bvec_iter is done with bio_advance_iter(); bio_advance() is a
> +   wrapper around bio_advance_iter() that operates on bio->bi_iter, and also
> +   advances the bio integrity's iter if present.
> +
> +   There is a lower level advance function - bvec_iter_advance() - which takes
> +   a pointer to a biovec, not a bio; this is used by the bio integrity code.
> +
> +What's all this get us?
> +=======================
> +
> +Having a real iterator, and making biovecs immutable, has a number of
> +advantages:
> +
> + * Before, iterating over bios was very awkward when you weren't processing
> +   exactly one bvec at a time - for example, bio_copy_data() in fs/bio.c,
> +   which copies the contents of one bio into another. Because the biovecs
> +   wouldn't necessarily be the same size, the old code was tricky convoluted -
> +   it had to walk two different bios at the same time, keeping both bi_idx and
> +   and offset into the current biovec for each.
> +
> +   The new code is much more straightforward - have a look. This sort of
> +   pattern comes up in a lot of places; a lot of drivers were essentially open
> +   coding bvec iterators before, and having common implementation considerably
> +   simplifies a lot of code.
> +
> + * Before, any code that might need to use the biovec after the bio had been
> +   completed (perhaps to copy the data somewhere else, or perhaps to resubmit
> +   it somewhere else if there was an error) had to save the entire bvec array
> +   - again, this was being done in a fair number of places.
> +
> + * Biovecs can be shared between multiple bios - a bvec iter can represent an
> +   arbitrary range of an existing biovec, both starting an ending midway

                                                           and

> +   through biovecs. This is what enables efficient splitting of arbitrary
> +   bios. Note that this means we _only_ use bi_size to determine when we're

                                                                         we've

> +   reached the end of a bio, not bi_vcnt - and the bio_iovec() macro takes
> +   bi_size into account when constructing biovecs.
> +
> + * Splitting bios is now much simpler. The old bio_split() didn't even work on
> +   bios with more than a single bvec! Now, we can efficiently split arbitrary
> +   size bios - because the new bio can share the old bio's biovec.
> +
> +   Care must be taken to ensure the biovec isn't freed while the split bio is
> +   still using it, in case the original bio completes first, though. Using
> +   bio_chain() when splitting bios helps with this.
> +
> + * Submitting partially completed bios is now perfectly fine - this comes up
> +   occasionally in stacking block drivers and various code (e.g. md and
> +   bcache) had some ugly workarounds for this.
> +
> +   It used to be the case that submitting a partially completed bio would work
> +   fine to _most_ devices, but since accessing the raw bvec array was the
> +   norm, not all drivers would respect bi_idx and those would break. Now,
> +   since all drivers _must_ go through the bvec iterator - and have been
> +   audited to make sure they are - submitting partially completed bios is
> +   perfectly fine.
> +
> +Other implications:
> +===================
> +
> + * Almost all usage of bi_idx is now incorrect and has been removed; instead,
> +   where previously you would have used bi_idx you'd now use a bvec_iter,
> +   probably passing it to one of the helper macros.
> +
> +   i.e. instead of using bio_iovec_idx() (or bio->bi_iovec[bio->bi_idx]), you

      I.e.,

> +   would now use bio_iter_iovec(), which takes a bvec_iter and returns a

drop "would".

> +   literal struct bio_vec - constructed on the fly from the raw biovec but
> +   taking into account bi_bvec_done (and bi_size).
> +
> + * bi_vcnt can't be trusted or relied upon by driver code - i.e. anything that
> +   doesn't actually own the bio. The reason is twofold: firstly, it's not
> +   actually needed for iterating over the bio anymore - we only go bi_size.

                                                                   use

> +   Secondly, when cloning a bio and reusing (a portion of) the original bio's
> +   biovec, in order to calculate bi_vcnt for the new bio we'd have to iterate
> +   over all the biovecs in the new bio - which is silly as it's not needed.
> +
> +   So, don't use bi_vcnt anymore.

Nice job.
Thanks.

-- 
~Randy
