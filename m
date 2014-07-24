Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759615AbaGXP4i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:56:38 -0400
Received: from kanga.kvack.org ([205.233.56.17]:37895 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759588AbaGXP4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:56:37 -0400
Date: Thu, 24 Jul 2014 11:56:36 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: axboe@kernel.dk, akpm@linux-foundation.org, jmoyer@redhat.com,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH 4/4] aio: use iovec array rather than the single one
Message-ID: <20140724155636.GE22390@kvack.org>
References: <1406109834-4414-1-git-send-email-guz.fnst@cn.fujitsu.com> <1406109834-4414-4-git-send-email-guz.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406109834-4414-4-git-send-email-guz.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 06:03:54PM +0800, Gu Zheng wrote:
> Previously, we only offer a single iovec to handle all the read/write cases, so
> the PREADV/PWRITEV request always need to alloc more iovec buffer when copying
> user vectors.
> If we use a tmp iovec array rather than the single one, some small PREADV/PWRITEV
> workloads(vector size small than the tmp buffer) will not need to alloc more
> iovec buffer when copying user vectors.

Thanks Gu -- applied to my aio-next tree at   
git://git.kvack.org/~bcrl/aio-next.git .

		-ben

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
> -- 
> 1.7.7

-- 
"Thought is the essence of where you are now."
