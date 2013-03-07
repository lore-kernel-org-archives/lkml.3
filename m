Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917Ab3CGLXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 06:23:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756218Ab3CGLXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 06:23:24 -0500
Message-ID: <513878A1.3020701@redhat.com>
Date: Thu, 07 Mar 2013 12:23:13 +0100
From: Jan Vesely <jvesely@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block: modify __bio_add_page check to accept pages that
 don't start a new segment
References: <5125DB22.7020901@redhat.com>
In-Reply-To: <5125DB22.7020901@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

I have added you to cc, I'm not sure who to bug to get this patch 
merged.

thanks,
Jan Vesely

On Thu 21 Feb 2013 09:30:26 CET, Jan Vesely wrote:
> The original behavior was to refuse all pages after the maximum number of
> segments has been reached. However, some drivers (like st) craft their buffers
> to potentially require exactly max segments and multiple pages in the last
> segment. This patch modifies the check to allow pages that can be merged into
> the last segment.
>
> This change fixes EBUSY failures when using large (1mb) tape block size in high
> memory fragmentation condition.
>
> Signed-off-by: Jan Vesely <jvesely@redhat.com>
> ---
>  fs/bio.c |   26 ++++++++++++++++----------
>  1 files changed, 16 insertions(+), 10 deletions(-)
>
> diff --git a/fs/bio.c b/fs/bio.c
> index b96fc6c..02efbd5 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -500,7 +500,6 @@ static int __bio_add_page(struct request_queue *q, struct
> bio *bio, struct page
>                *page, unsigned int len, unsigned int offset,
>                unsigned short max_sectors)
>  {
> -    int retried_segments = 0;
>      struct bio_vec *bvec;
>
>      /*
> @@ -551,18 +550,12 @@ static int __bio_add_page(struct request_queue *q,
> struct bio *bio, struct page
>          return 0;
>
>      /*
> -     * we might lose a segment or two here, but rather that than
> -     * make this too complex.
> +     * prepare segment count check, reduce segment count if possible
>       */
>
> -    while (bio->bi_phys_segments >= queue_max_segments(q)) {
> -
> -        if (retried_segments)
> -            return 0;
> -
> -        retried_segments = 1;
> +    if (bio->bi_phys_segments >= queue_max_segments(q))
>          blk_recount_segments(q, bio);
> -    }
> +
>
>      /*
>       * setup the new entry, we might clear it again later if we
> @@ -572,6 +565,19 @@ static int __bio_add_page(struct request_queue *q, struct
> bio *bio, struct page
>      bvec->bv_page = page;
>      bvec->bv_len = len;
>      bvec->bv_offset = offset;
> +
> +    /*
> +     * the other part of the segment count check, allow mergeable pages
> +     */
> +    if ((bio->bi_phys_segments > queue_max_segments(q)) ||
> +        ( (bio->bi_phys_segments == queue_max_segments(q)) &&
> +        !BIOVEC_PHYS_MERGEABLE(bvec - 1, bvec))) {
> +            bvec->bv_page = NULL;
> +            bvec->bv_len = 0;
> +            bvec->bv_offset = 0;
> +            return 0;
> +    }
> +
>
>      /*
>       * if queue has other restrictions (eg varying max sector size

--
Jan Vesely <jvesely@redhat.com>
