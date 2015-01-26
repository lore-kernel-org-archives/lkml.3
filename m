Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbbAZQS3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 11:18:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57917 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756534AbbAZQS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 11:18:27 -0500
MIME-Version: 1.0
In-Reply-To: <20150125133147.GA19445@infradead.org>
References: <1421163888-21452-1-git-send-email-ming.lei@canonical.com>
	<1421163888-21452-2-git-send-email-ming.lei@canonical.com>
	<20150125133147.GA19445@infradead.org>
Date: Tue, 27 Jan 2015 00:18:23 +0800
Message-ID: <CACVXFVOzjroTqcgduqvKzcDVvNvO4xGX6go3+ZspfQkz3_2zAQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] aio: add aio_kernel_() interface
From: Ming Lei <ming.lei@canonical.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>, Jens Axboe <axboe@kernel.dk>,
        Zach Brown <zab@zabbo.net>, Maxim Patlasov <mpatlasov@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "open list:AIO" <linux-aio@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 25, 2015 at 9:31 PM, Christoph Hellwig <hch@infradead.org> wrote:
>> +struct kiocb *aio_kernel_alloc(gfp_t gfp)
>> +{
>> +     return kzalloc(sizeof(struct kiocb), gfp);
>> +}
>> +EXPORT_SYMBOL_GPL(aio_kernel_alloc);
>> +
>> +void aio_kernel_free(struct kiocb *iocb)
>> +{
>> +     kfree(iocb);
>> +}
>> +EXPORT_SYMBOL_GPL(aio_kernel_free);
>
> Both functions don't actually seem to be used in this patch set.

My fault, and it is just v2 which stops using them.

>> +void aio_kernel_init_rw(struct kiocb *iocb, struct file *filp,
>> +                     size_t nr, loff_t off,
>> +                     void (*complete)(u64 user_data, long res),
>> +                     u64 user_data)
>
>> +int aio_kernel_submit(struct kiocb *iocb, bool is_write,
>> +                   struct iov_iter *iter)
>
> Why do we keep these two separate?  Especially having the iov passed

No special meaning, just follow previous patches, :-)

But one benefit is that we can separate the one-shot
initialization from submit, at least filep/complete/ki_ctx can be
set during initialization.

> n the second, and the count in the first seems rather confusing as
> we shouldn't even need both for a high level API.  Also the private
> data should really be a void pointer for the kernel, or simply be
> left away as we can assume the iocb is embedded into a caller
> data structure and container_of can be used to find that structure.

Either one is OK.

> Also it might make sense to just offer aio_kernel_read/write intefaces
> instead of the common submit wrapper, as that's much closer to other
> kernel APIs, e.g.
>
> int aio_kernel_read(struct kiocb *iocb, struct file *file,
>                 struct iov_iter *iter, loff_t off,
>                 void (*complete)(struct kiocb *iocb, long res));
> int aio_kernel_write(struct kiocb *iocb, struct file *file,
>                 struct iov_iter *iter, loff_t off,
>                 void (*complete)(struct kiocb *iocb, long res));

It is like style of sync APIs, looks submit/complete is common
for async APIs, like io_submit().

>> +     if (WARN_ON(!is_kernel_kiocb(iocb) || !iocb->ki_obj.complete
>> +                     || !iocb->ki_filp || !(iter->type & ITER_BVEC)))
>
> Why do you want to limit what the iov_iter can contain?  iovec based
> ones seem very useful, and athough I can come up with a use case
> for vectors pointing to userspace address I can't see anything that
> speaks against allowing them either.
> call this from drivers deadling

Yes, we should allow KVEC at least.


Thanks,
Ming Lei
