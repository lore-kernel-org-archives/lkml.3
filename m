Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbaGVPVC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 11:21:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846AbaGVPVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 11:21:00 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: bcrl@kvack.org, axboe@kernel.dk, akpm@linux-foundation.org,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] aio: use iovec array rather than the single one
References: <1405996804-8262-1-git-send-email-guz.fnst@cn.fujitsu.com>
	<1405996804-8262-4-git-send-email-guz.fnst@cn.fujitsu.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 22 Jul 2014 11:20:52 -0400
In-Reply-To: <1405996804-8262-4-git-send-email-guz.fnst@cn.fujitsu.com> (Gu
	Zheng's message of "Tue, 22 Jul 2014 10:40:04 +0800")
Message-ID: <x494my94dyj.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gu Zheng <guz.fnst@cn.fujitsu.com> writes:

> use an iovec array rather than the single one, so that we can avoid
> to alloc more iovecs buffer in small(< 8) PREADV/PWRITEV cases.

I did some basic functional testing of this change and the change in
patch 1/4.  That testing included using aio-stress to drive queue depths
of 7, 8 and 9, and verify that it didn't fall over.  I also ran xfstests
'./check -g aio', and libaio's 'make partcheck'.

The change looks good to me, and passed testing, so:

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

However, I still would like some comment on the reasoning behind it, and
whether there is some measurable performance advantage for some
workload.  Additionally, it would be nice if that comment made its way
into the commit message.

Cheers,
Jeff

>
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> ---
>  fs/aio.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/fs/aio.c b/fs/aio.c
> index 0cd0479..ef21efe 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -1260,12 +1260,12 @@ static ssize_t aio_setup_vectored_rw(struct kiocb *kiocb,
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
> @@ -1302,7 +1302,7 @@ static ssize_t aio_run_iocb(struct kiocb *req, unsigned opcode,
>  	fmode_t mode;
>  	aio_rw_op *rw_op;
>  	rw_iter_op *iter_op;
> -	struct iovec inline_vec, *iovec = &inline_vec;
> +	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
>  	struct iov_iter iter;
>  
>  	switch (opcode) {
> @@ -1337,7 +1337,7 @@ rw_common:
>  		if (!ret)
>  			ret = rw_verify_area(rw, file, &req->ki_pos, req->ki_nbytes);
>  		if (ret < 0) {
> -			if (iovec != &inline_vec)
> +			if (iovec != inline_vecs)
>  				kfree(iovec);
>  			return ret;
>  		}
> @@ -1384,7 +1384,7 @@ rw_common:
>  		return -EINVAL;
>  	}
>  
> -	if (iovec != &inline_vec)
> +	if (iovec != inline_vecs)
>  		kfree(iovec);
>  
>  	if (ret != -EIOCBQUEUED) {
