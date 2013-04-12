Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab3DLQvw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 12:51:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183Ab3DLQvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 12:51:51 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        akpm@linux-foundation.org, Zach Brown <zab@redhat.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Benjamin LaHaise <bcrl@kvack.org>,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 10/33] aio: do fget() after aio_get_req()
References: <1363883754-27966-1-git-send-email-koverstreet@google.com>
	<1363883754-27966-11-git-send-email-koverstreet@google.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 12 Apr 2013 12:51:23 -0400
In-Reply-To: <1363883754-27966-11-git-send-email-koverstreet@google.com> (Kent
	Overstreet's message of "Thu, 21 Mar 2013 09:35:31 -0700")
Message-ID: <x49vc7rsnec.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kent Overstreet <koverstreet@google.com> writes:

> aio_get_req() will fail if we have the maximum number of requests
> outstanding, which depending on the application may not be uncommon.  So
> avoid doing an unnecessary fget().


> diff --git a/fs/aio.c b/fs/aio.c
> index 2637555..4f23d43 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -587,6 +587,8 @@ static inline void really_put_req(struct kioctx *ctx, struct kiocb *req)
>  {
>  	assert_spin_locked(&ctx->ctx_lock);
>  
> +	if (req->ki_filp)
> +		fput(req->ki_filp);
>  	if (req->ki_eventfd != NULL)
>  		eventfd_ctx_put(req->ki_eventfd);
>  	if (req->ki_dtor)
[snip]
> @@ -618,8 +617,6 @@ static void __aio_put_req(struct kioctx *ctx, struct kiocb *req)
>  	req->ki_cancel = NULL;
>  	req->ki_retry = NULL;
>  
> -	fput(req->ki_filp);
> -	req->ki_filp = NULL;
>  	really_put_req(ctx, req);
>  }

So you've removed the setting of req->ki_filp to NULL here, and I think
it's okay.  The only function called after that which could possibly be
tripped up is req->ki_dtor.  That function has no business looking at
ki_filp, I think (and the only in-tree user does not look at it).

Acked-by: Jeff Moyer <jmoyer@redhat.com>
