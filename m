Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468AbaHPAf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 20:35:28 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:34375 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaHPAf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 20:35:26 -0400
MIME-Version: 1.0
In-Reply-To: <00fefb9cf2b5493a86912de55ba912bdfae4a207.1408122224.git.bcrl@kvack.org>
References: <cover.1408122224.git.bcrl@kvack.org>
	<00fefb9cf2b5493a86912de55ba912bdfae4a207.1408122224.git.bcrl@kvack.org>
Date: Fri, 15 Aug 2014 18:35:25 -0600
X-Google-Sender-Auth: NfWlOpFiXG2counV1Uhb05GbZGg
Message-ID: <CA+55aFyYt41jie6N1UyawPYYnpRAMKcRG8wRTa_ShPreT24qTw@mail.gmail.com>
Subject: Re: [PATCH 7/7] aio: use iovec array rather than the single one
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: linux-aio@kvack.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben,

*please* stop doing this kind of crap.

You're creating fake emails with invalid senders. That's simply not acceptable.

The way to specify the author of a commit is *not* to fake the email
sender information, it's to have

   From: Real A U Thor <real.thor@fake.com>

at the top of the message body. NOT by sending fake email from that name.

Seriously, faking email authorship is too distasteful for words. What
the F*CK were you thinking? Fix your scripts immediately. I refuse to
have anything to do with people who send fake emails.

Not acceptable. Not acceptable AT ALL.

                  Linus

On Fri, Aug 15, 2014 at 11:25 AM, Gu Zheng <guz.fnst@cn.fujitsu.com> wrote:
> Previously, we only offer a single iovec to handle all the read/write cases, so
> the PREADV/PWRITEV request always need to alloc more iovec buffer when copying
> user vectors.
> If we use a tmp iovec array rather than the single one, some small PREADV/PWRITEV
> workloads(vector size small than the tmp buffer) will not need to alloc more
> iovec buffer when copying user vectors.
>
> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
> ---
>  fs/aio.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/fs/aio.c b/fs/aio.c
> index d6d9520..0fd9181 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -1243,12 +1243,12 @@ static ssize_t aio_setup_vectored_rw(struct kiocb *kiocb,
>         if (compat)
>                 ret = compat_rw_copy_check_uvector(rw,
>                                 (struct compat_iovec __user *)buf,
> -                               *nr_segs, 1, *iovec, iovec);
> +                               *nr_segs, UIO_FASTIOV, *iovec, iovec);
>         else
>  #endif
>                 ret = rw_copy_check_uvector(rw,
>                                 (struct iovec __user *)buf,
> -                               *nr_segs, 1, *iovec, iovec);
> +                               *nr_segs, UIO_FASTIOV, *iovec, iovec);
>         if (ret < 0)
>                 return ret;
>
> @@ -1285,7 +1285,7 @@ static ssize_t aio_run_iocb(struct kiocb *req, unsigned opcode,
>         fmode_t mode;
>         aio_rw_op *rw_op;
>         rw_iter_op *iter_op;
> -       struct iovec inline_vec, *iovec = &inline_vec;
> +       struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
>         struct iov_iter iter;
>
>         switch (opcode) {
> @@ -1320,7 +1320,7 @@ rw_common:
>                 if (!ret)
>                         ret = rw_verify_area(rw, file, &req->ki_pos, req->ki_nbytes);
>                 if (ret < 0) {
> -                       if (iovec != &inline_vec)
> +                       if (iovec != inline_vecs)
>                                 kfree(iovec);
>                         return ret;
>                 }
> @@ -1367,7 +1367,7 @@ rw_common:
>                 return -EINVAL;
>         }
>
> -       if (iovec != &inline_vec)
> +       if (iovec != inline_vecs)
>                 kfree(iovec);
>
>         if (ret != -EIOCBQUEUED) {
> --
> 1.8.2.1
>
>
> --
> "Thought is the essence of where you are now."
