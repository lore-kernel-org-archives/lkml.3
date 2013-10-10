Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498Ab3JJVXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 17:23:35 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:43833 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754092Ab3JJVXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 17:23:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArwGAFcaV1J5LFuj/2dsb2JhbABZgiVig0u5NIVHgSUXdIIlAQEFOhwjEAgDDgoJJQ8FJQMhE4gFuHeBRBaPMQeEIwOYBIpAh0ODOCg
Date: Fri, 11 Oct 2013 08:23:26 +1100
From: Dave Chinner <david@fromorbit.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, tytso@mit.edu,
        adilger.kernel@dilger.ca, bpm@sgi.com, elder@kernel.org,
        hch@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        xfs@oss.sgi.com, a.sangwan@samsung.com,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH RESEND 2/7] xfs: add support FALLOC_FL_COLLAPSE_RANGE for
 fallocate
Message-ID: <20131010212326.GZ4446@dastard>
References: <1381090388-2761-1-git-send-email-linkinjeon@gmail.com>
 <20131010005154.GS4446@dastard>
 <CAKYAXd8=ZKESV5Fmw7hqwL=G8L=BG6h0LQpc2cVjN9uTkj7nYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKYAXd8=ZKESV5Fmw7hqwL=G8L=BG6h0LQpc2cVjN9uTkj7nYw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 04:00:13PM +0900, Namjae Jeon wrote:
> >
> > /*
> >  * Shift extent records to the left to cover a hole.
> >  *
> >  * The maximum number of extents to be shifted in a single operation
> >  * is @count, and @current_ext keeps track of the current extent
> >  * index we have shifted. If there is no hole to shift the extents
> >  * into, then we abort immediately.
> >  */
> Thanks for your help. I will change this comment instead of original one.
> 
> >> +int
> >> +xfs_bmap_shift_extents(
> >> +     struct xfs_trans        *tp,
> >> +     struct xfs_inode        *ip,
> >> +     int                     *done,
> >> +     xfs_fileoff_t           start_fsb,
> >> +     xfs_fileoff_t           shift,
> >
> > Shift means ...? Number of extents to shift, a length, a number of
> > block, or something else?
> Ah, yes, shift_len would be a more proper name

I'm not sure that's a lot better. What are we shifting? We are
shifting the offset of the blocks, right? And the unit is in fsb?
So perhaps offset_shift_fsb, and add that to the description of the
function above?

> >> +             /*
> >> +              * Before shifting extent into hole, make sure that the hole
> >> +              * is large enough to accomodate the shift.
> >> +              */
> >> +             if (*current_ext) {
> >> +                     state |= BMAP_LEFT_VALID;
> >> +                     xfs_bmbt_get_all(xfs_iext_get_ext(ifp,
> >> +                                             *current_ext - 1), &left);
> >> +
> >> +                     if (isnullstartblock(left.br_startblock))
> >> +                             state |= BMAP_LEFT_DELAY;
> >> +
> >> +                     if (startoff < left.br_startoff + left.br_blockcount)
> >> +                             error = XFS_ERROR(EFSCORRUPTED);
> >
> > Why is the filesystem corrupted if the shift we asked for is too
> > large for the hole in the file? I haven't seen any checks before
> > this that guarantee that the hole is big enough for the shift...
> 
> we call xfs_free_file_space to free enough blocks for shifting.
> If still the space is not big enough will it be considered as fs corrupted?
> What error could we return in this case?

Hole punching rounds inwards, and the amount of rounding is not
necessarily the nearest filesystem block. Again it's the block size
smaller than page size case that will trip you over here, as the
rounding  when punching holes will be done to page size, not
filesystem block size. Hence it's entirely possible that your
calculated shift start and lengths don't match the size of the hole
that was punched.

That doesn't mean there was a corruption - just that the hole wasn't
the size and shape that was expected....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
