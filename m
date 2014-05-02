Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815AbaEBIql (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 04:46:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbaEBIqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 04:46:38 -0400
Date: Fri, 2 May 2014 10:46:32 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
X-X-Sender: lczerner@localhost.localdomain
To: Leon Yu <chianglungyu@gmail.com>
cc: Benjamin LaHaise <bcrl@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] aio: fix potential leak in aio_run_iocb().
In-Reply-To: <1398915088-8472-1-git-send-email-chianglungyu@gmail.com>
Message-ID: <alpine.LFD.2.00.1405021041250.2154@localhost.localdomain>
References: <1398915088-8472-1-git-send-email-chianglungyu@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2014, Leon Yu wrote:

> Date: Thu,  1 May 2014 03:31:28 +0000
> From: Leon Yu <chianglungyu@gmail.com>
> To: Benjamin LaHaise <bcrl@kvack.org>,
>     Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
>     linux-kernel@vger.kernel.org, Leon Yu <chianglungyu@gmail.com>
> Subject: [PATCH] aio: fix potential leak in aio_run_iocb().
> 
> iovec should be reclaimed whenever caller of rw_copy_check_uvector() returns,
> but it doesn't hold when failure happens right after aio_setup_vectored_rw().
> 
> Fix that in a such way to avoid hairy goto.


Hi,

this does not seem right, see bellow

> 
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

here ret could be possibly set to a positive number.

> +		if (!ret)
> +			ret = rw_verify_area(rw, file, &req->ki_pos, req->ki_nbytes);
>  		if (ret < 0) {

but here we're checking for negative and bail out. However this
changes the way it worked before this patch and the iovec would not
be reclaimed anyway as you mentioned in the commit description.

Thanks!
-Lukas

>  			if (iovec != &inline_vec)
>  				kfree(iovec);

