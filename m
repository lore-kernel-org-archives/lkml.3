Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178AbaGWN0K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 09:26:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798AbaGWN0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 09:26:08 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: bcrl@kvack.org, axboe@kernel.dk, akpm@linux-foundation.org,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH 4/4] aio: use iovec array rather than the single one
References: <1406109834-4414-1-git-send-email-guz.fnst@cn.fujitsu.com>
	<1406109834-4414-4-git-send-email-guz.fnst@cn.fujitsu.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 23 Jul 2014 09:25:57 -0400
In-Reply-To: <1406109834-4414-4-git-send-email-guz.fnst@cn.fujitsu.com> (Gu
	Zheng's message of "Wed, 23 Jul 2014 18:03:54 +0800")
Message-ID: <x497g34w6je.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gu Zheng <guz.fnst@cn.fujitsu.com> writes:

> Previously, we only offer a single iovec to handle all the read/write cases, so
> the PREADV/PWRITEV request always need to alloc more iovec buffer when copying
> user vectors.
> If we use a tmp iovec array rather than the single one, some small PREADV/PWRITEV
> workloads(vector size small than the tmp buffer) will not need to alloc more
> iovec buffer when copying user vectors.

Hi, Gu,

This still doesn't explain why you decided to look into this.  Did you
notice a performance issue in this path?  Do you have benchmarks that
show some speedup due to this change?

Thanks,
Jeff

>
> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> ---
>  fs/aio.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/fs/aio.c b/fs/aio.c
> index f1fede2..df3491a 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -1267,12 +1267,12 @@ static ssize_t aio_setup_vectored_rw(struct kiocb *kiocb,
>  	if (compat)
>  		ret = compat_rw_copy_check_uvector(rw,
>  				(struct compat_iovec __user *)buf,
> -				*nr_segs, 1, *iovec, iovec);
> +				*nr_segs, UIO_FASTIOV, *iovec, iovec);
>  	else
>  #endif
>  		ret = rw_copy_check_uvector(rw,
>  				(struct iovec __user *)buf,
> -				*nr_segs, 1, *iovec, iovec);
> +				*nr_segs, UIO_FASTIOV, *iovec, iovec);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -1309,7 +1309,7 @@ static ssize_t aio_run_iocb(struct kiocb *req, unsigned opcode,
>  	fmode_t mode;
>  	aio_rw_op *rw_op;
>  	rw_iter_op *iter_op;
> -	struct iovec inline_vec, *iovec = &inline_vec;
> +	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
>  	struct iov_iter iter;
>  
>  	switch (opcode) {
> @@ -1344,7 +1344,7 @@ rw_common:
>  		if (!ret)
>  			ret = rw_verify_area(rw, file, &req->ki_pos, req->ki_nbytes);
>  		if (ret < 0) {
> -			if (iovec != &inline_vec)
> +			if (iovec != inline_vecs)
>  				kfree(iovec);
>  			return ret;
>  		}
> @@ -1391,7 +1391,7 @@ rw_common:
>  		return -EINVAL;
>  	}
>  
> -	if (iovec != &inline_vec)
> +	if (iovec != inline_vecs)
>  		kfree(iovec);
>  
>  	if (ret != -EIOCBQUEUED) {
