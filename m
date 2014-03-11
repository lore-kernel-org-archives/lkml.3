Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaCKPQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 11:16:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbaCKPQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 11:16:05 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Frank Mayhar <fmayhar@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block:  Force sector and nr_sects to device alignment and granularity.
References: <1394474492.31499.177.camel@bobble.lax.corp.google.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 11 Mar 2014 11:15:59 -0400
In-Reply-To: <1394474492.31499.177.camel@bobble.lax.corp.google.com> (Frank
	Mayhar's message of "Mon, 10 Mar 2014 11:01:32 -0700")
Message-ID: <x49wqg0bwb4.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frank Mayhar <fmayhar@google.com> writes:

> block:  Force sector and nr_sects to device alignment and granularity.
>
> In blkdev_issue_discard(), rather than sending an improperly-
> aligned discard to the device (where it may get an error),
> adjust the start and length to the block device alignment and
> granularity.  Don't fail if this leaves nothing to discard.
>
> Without this change, certain flash drivers can report invalid
> trim parameters (and will fail the command).  Per tytso, "given
> that discards are advisory, any part of the storage stack is
> free to drop discard requests silently."

And how do you get here with misaligned discards?

-Jeff

>
> Signed-off-by: Frank Mayhar <fmayhar@google.com>
> Reviewed-by: "Theodore Ts'o" <tytso@mit.edu>
>
>  block/blk-lib.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index 97a733c..a4472cd 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -61,6 +61,21 @@ int blkdev_issue_discard(struct block_device *bdev,
> sector_t sector,
>  	alignment = (bdev_discard_alignment(bdev) >> 9) % granularity;
>  
>  	/*
> +	 * Force sector and nr_sects to block device alignment and
> +	 * granularity.
> +	 */
> +	if (alignment && (sector % alignment)) {
> +		sector_t adj = alignment - (sector % alignment);
> +
> +		sector += adj;
> +		nr_sects -= adj;
> +	}
> +	if (nr_sects % granularity)
> +		nr_sects -= nr_sects % granularity;
> +	if (!nr_sects)
> +		return ret;
> +
> +	/*
>  	 * Ensure that max_discard_sectors is of the proper
>  	 * granularity, so that requests stay aligned after a split.
>  	 */
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
