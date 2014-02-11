Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbaBKMWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:22:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbaBKMW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:22:28 -0500
Date: Tue, 11 Feb 2014 12:22:17 +0000
From: "Richard W.M. Jones" <rjones@redhat.com>
To: Kent Overstreet <kmo@daterainc.com>
Cc: axboe@kernel.dk, clm@fb.com, linux-fsdevel@vger.kernel.org, neilb@suse.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: Fix cloning of discard/write same bios
Message-ID: <20140211122216.GE1346@redhat.com>
References: <1392083150-11670-1-git-send-email-kmo@daterainc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392083150-11670-1-git-send-email-kmo@daterainc.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 05:45:50PM -0800, Kent Overstreet wrote:
> Immutable biovecs changed the way bio segments are treated in such a way that
> bio_for_each_segment() cannot now do what we want for discard/write same bios,
> since bi_size means something completely different for them.
> 
> Fortunately discard and write same bios never have more than a single biovec, so
> bio_for_each_segment() is unnecessary and not terribly meaningful for them, but
> we still have to special case them in a few places.
> 
> Signed-off-by: Kent Overstreet <kmo@daterainc.com>

Tested-by: Richard W.M. Jones <rjones@redhat.com>

I have confirmed this fixes the bug described here:

https://bugzilla.redhat.com/show_bug.cgi?id=1061339

Rich.

> ---
>  fs/bio.c            | 15 ++++++++++-----
>  include/linux/bio.h | 11 +++++++++++
>  2 files changed, 21 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/bio.c b/fs/bio.c
> index 75c49a3822..8754e7b6eb 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -611,7 +611,6 @@ EXPORT_SYMBOL(bio_clone_fast);
>  struct bio *bio_clone_bioset(struct bio *bio_src, gfp_t gfp_mask,
>  			     struct bio_set *bs)
>  {
> -	unsigned nr_iovecs = 0;
>  	struct bvec_iter iter;
>  	struct bio_vec bv;
>  	struct bio *bio;
> @@ -638,10 +637,7 @@ struct bio *bio_clone_bioset(struct bio *bio_src, gfp_t gfp_mask,
>  	 *    __bio_clone_fast() anyways.
>  	 */
>  
> -	bio_for_each_segment(bv, bio_src, iter)
> -		nr_iovecs++;
> -
> -	bio = bio_alloc_bioset(gfp_mask, nr_iovecs, bs);
> +	bio = bio_alloc_bioset(gfp_mask, bio_segments(bio_src), bs);
>  	if (!bio)
>  		return NULL;
>  
> @@ -650,9 +646,18 @@ struct bio *bio_clone_bioset(struct bio *bio_src, gfp_t gfp_mask,
>  	bio->bi_iter.bi_sector	= bio_src->bi_iter.bi_sector;
>  	bio->bi_iter.bi_size	= bio_src->bi_iter.bi_size;
>  
> +	if (bio->bi_rw & REQ_DISCARD)
> +		goto integrity_clone;
> +
> +	if (bio->bi_rw & REQ_WRITE_SAME) {
> +		bio->bi_io_vec[bio->bi_vcnt++] = bio_src->bi_io_vec[0];
> +		goto integrity_clone;
> +	}
> +
>  	bio_for_each_segment(bv, bio_src, iter)
>  		bio->bi_io_vec[bio->bi_vcnt++] = bv;
>  
> +integrity_clone:
>  	if (bio_integrity(bio_src)) {
>  		int ret;
>  
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 70654521da..05d2a0392f 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -250,6 +250,17 @@ static inline unsigned bio_segments(struct bio *bio)
>  	struct bio_vec bv;
>  	struct bvec_iter iter;
>  
> +	/*
> +	 * We special case discard/write same, because they interpret bi_size
> +	 * differently:
> +	 */
> +
> +	if (bio->bi_rw & REQ_DISCARD)
> +		return 1;
> +
> +	if (bio->bi_rw & REQ_WRITE_SAME)
> +		return 1;
> +
>  	bio_for_each_segment(bv, bio, iter)
>  		segs++;
>  
> -- 
> 1.8.5.3

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming blog: http://rwmj.wordpress.com
Fedora now supports 80 OCaml packages (the OPEN alternative to F#)
