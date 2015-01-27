Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573AbbA0QF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 11:05:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36602 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbbA0QF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 11:05:56 -0500
MIME-Version: 1.0
In-Reply-To: <20150125133433.GB19445@infradead.org>
References: <1421163888-21452-1-git-send-email-ming.lei@canonical.com>
	<1421163888-21452-3-git-send-email-ming.lei@canonical.com>
	<20150125133433.GB19445@infradead.org>
Date: Wed, 28 Jan 2015 00:05:53 +0800
Message-ID: <CACVXFVMjZ--7tQR2Ftcdne3n9GY97a9s8QVoTHBubeOOO=TO2g@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] fd/direct-io: introduce should_dirty for kernel aio
From: Ming Lei <ming.lei@canonical.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Dave Kleikamp <dave.kleikamp@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Zach Brown <zab@zabbo.net>,
        Maxim Patlasov <mpatlasov@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, Omar Sandoval <osandov@osandov.com>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/25/15, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Jan 13, 2015 at 11:44:46PM +0800, Ming Lei wrote:
>>
>> -	if (dio->is_async && dio->rw == READ)
>> +	if (dio->is_async && dio->rw == READ && dio->should_dirty)
>>  		bio_set_pages_dirty(bio);
>>
>>  	if (sdio->submit_io)
>> @@ -463,13 +464,14 @@ static int dio_bio_complete(struct dio *dio, struct
>> bio *bio)
>>  	if (!uptodate)
>>  		dio->io_error = -EIO;
>>
>> -	if (dio->is_async && dio->rw == READ) {
>> +	if (dio->is_async && dio->rw == READ && dio->should_dirty) {
>
> I'd rather have a ->should_dirrty flag that means we need to call
> bio_check_pages_dirty, And set that either if we have a kernel
> iovec/bvec or dio->is_async && dio->rw == READ.

It may not work for loop because the page may not become dirty
until the read dio is completed, so it just means the caller totally
handles the page dirty if I/O is from kernel.

>
> But why would we even set this if writing from an iovec?

Or just rename it as ->from_user?

>>  		bio_check_pages_dirty(bio);	/* transfers ownership */
>>  	} else {
>>  		bio_for_each_segment_all(bvec, bio, i) {
>>  			struct page *page = bvec->bv_page;
>>
>> -			if (dio->rw == READ && !PageCompound(page))
>> +			if (dio->rw == READ && !PageCompound(page) &&
>> +					dio->should_dirty)
>>  				set_page_dirty_lock(page);
>
> And this unk could also use some explanation.

This is same, just don't handle page dirty for kernel dio pages.

Thanks,
Ming Lei
