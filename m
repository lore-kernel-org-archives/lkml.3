Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578AbbAYNbv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 08:31:51 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:38882 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbbAYNbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 08:31:48 -0500
Date: Sun, 25 Jan 2015 05:31:47 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org, Dave Kleikamp <dave.kleikamp@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Zach Brown <zab@zabbo.net>,
        Christoph Hellwig <hch@infradead.org>,
        Maxim Patlasov <mpatlasov@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, linux-fsdevel@vger.kernel.org,
        "open list:AIO" <linux-aio@kvack.org>
Subject: Re: [PATCH v2 1/4] aio: add aio_kernel_() interface
Message-ID: <20150125133147.GA19445@infradead.org>
References: <1421163888-21452-1-git-send-email-ming.lei@canonical.com>
 <1421163888-21452-2-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421163888-21452-2-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +struct kiocb *aio_kernel_alloc(gfp_t gfp)
> +{
> +	return kzalloc(sizeof(struct kiocb), gfp);
> +}
> +EXPORT_SYMBOL_GPL(aio_kernel_alloc);
> +
> +void aio_kernel_free(struct kiocb *iocb)
> +{
> +	kfree(iocb);
> +}
> +EXPORT_SYMBOL_GPL(aio_kernel_free);

Both functions don't actually seem to be used in this patch set.

> +void aio_kernel_init_rw(struct kiocb *iocb, struct file *filp,
> +			size_t nr, loff_t off,
> +			void (*complete)(u64 user_data, long res),
> +			u64 user_data)

> +int aio_kernel_submit(struct kiocb *iocb, bool is_write,
> +		      struct iov_iter *iter)

Why do we keep these two separate?  Especially having the iov passed
n the second, and the count in the first seems rather confusing as
we shouldn't even need both for a high level API.  Also the private
data should really be a void pointer for the kernel, or simply be
left away as we can assume the iocb is embedded into a caller
data structure and container_of can be used to find that structure.

Also it might make sense to just offer aio_kernel_read/write intefaces
instead of the common submit wrapper, as that's much closer to other
kernel APIs, e.g.

int aio_kernel_read(struct kiocb *iocb, struct file *file,
		struct iov_iter *iter, loff_t off,
		void (*complete)(struct kiocb *iocb, long res));
int aio_kernel_write(struct kiocb *iocb, struct file *file,
		struct iov_iter *iter, loff_t off,
		void (*complete)(struct kiocb *iocb, long res));

> +	if (WARN_ON(!is_kernel_kiocb(iocb) || !iocb->ki_obj.complete
> +			|| !iocb->ki_filp || !(iter->type & ITER_BVEC)))

Why do you want to limit what the iov_iter can contain?  iovec based
ones seem very useful, and athough I can come up with a use case
for vectors pointing to userspace address I can't see anything that
speaks against allowing them either.
call this from drivers deadling

