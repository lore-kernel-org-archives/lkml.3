Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbaEAMjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 08:39:16 -0400
Received: from kanga.kvack.org ([205.233.56.17]:50087 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbaEAMjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 08:39:14 -0400
Date: Thu, 1 May 2014 08:39:13 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Leon Yu <chianglungyu@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] aio: fix potential leak in aio_run_iocb().
Message-ID: <20140501123913.GI28959@kvack.org>
References: <1398915088-8472-1-git-send-email-chianglungyu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398915088-8472-1-git-send-email-chianglungyu@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 03:31:28AM +0000, Leon Yu wrote:
> iovec should be reclaimed whenever caller of rw_copy_check_uvector() returns,
> but it doesn't hold when failure happens right after aio_setup_vectored_rw().
> 
> Fix that in a such way to avoid hairy goto.

Good catch -- applied.

		-ben

> Signed-off-by: Leon Yu <chianglungyu@gmail.com>
> ---
>  fs/aio.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index 12a3de0e..04cd768 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -1299,10 +1299,8 @@ rw_common:
>  						&iovec, compat)
>  			: aio_setup_single_vector(req, rw, buf, &nr_segs,
>  						  iovec);
> -		if (ret)
> -			return ret;
> -
> -		ret = rw_verify_area(rw, file, &req->ki_pos, req->ki_nbytes);
> +		if (!ret)
> +			ret = rw_verify_area(rw, file, &req->ki_pos, req->ki_nbytes);
>  		if (ret < 0) {
>  			if (iovec != &inline_vec)
>  				kfree(iovec);
> -- 
> 1.9.2

-- 
"Thought is the essence of where you are now."
