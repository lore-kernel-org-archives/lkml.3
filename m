Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbbAYNeg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 08:34:36 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:40635 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbbAYNee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 08:34:34 -0500
Date: Sun, 25 Jan 2015 05:34:33 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org, Dave Kleikamp <dave.kleikamp@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Zach Brown <zab@zabbo.net>,
        Christoph Hellwig <hch@infradead.org>,
        Maxim Patlasov <mpatlasov@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, Omar Sandoval <osandov@osandov.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] fd/direct-io: introduce should_dirty for kernel
 aio
Message-ID: <20150125133433.GB19445@infradead.org>
References: <1421163888-21452-1-git-send-email-ming.lei@canonical.com>
 <1421163888-21452-3-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421163888-21452-3-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 11:44:46PM +0800, Ming Lei wrote:
>  
> -	if (dio->is_async && dio->rw == READ)
> +	if (dio->is_async && dio->rw == READ && dio->should_dirty)
>  		bio_set_pages_dirty(bio);
>  
>  	if (sdio->submit_io)
> @@ -463,13 +464,14 @@ static int dio_bio_complete(struct dio *dio, struct bio *bio)
>  	if (!uptodate)
>  		dio->io_error = -EIO;
>  
> -	if (dio->is_async && dio->rw == READ) {
> +	if (dio->is_async && dio->rw == READ && dio->should_dirty) {

I'd rather have a ->should_dirrty flag that means we need to call
bio_check_pages_dirty, And set that either if we have a kernel
iovec/bvec or dio->is_async && dio->rw == READ.

But why would we even set this if writing from an iovec?

>  		bio_check_pages_dirty(bio);	/* transfers ownership */
>  	} else {
>  		bio_for_each_segment_all(bvec, bio, i) {
>  			struct page *page = bvec->bv_page;
>  
> -			if (dio->rw == READ && !PageCompound(page))
> +			if (dio->rw == READ && !PageCompound(page) &&
> +					dio->should_dirty)
>  				set_page_dirty_lock(page);

And this unk could also use some explanation.

