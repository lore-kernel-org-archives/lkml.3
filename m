Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab3EQSxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 14:53:19 -0400
Received: from kanga.kvack.org ([205.233.56.17]:58280 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976Ab3EQSxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 14:53:18 -0400
Date: Fri, 17 May 2013 14:53:17 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: koverstreet@google.com, akpm@linux-foundation.org, tytso@mit.edu,
        viro@zeniv.linux.org.uk, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: aio: use correct integer overflow checks when creation aio ctx
Message-ID: <20130517185317.GM1008@kvack.org>
References: <1368815034-844-1-git-send-email-sasha.levin@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368815034-844-1-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 02:23:54PM -0400, Sasha Levin wrote:
> Commit "aio: percpu reqs_available" added some math to the nr_requests
> calculation, but didn't correct the overflow calculations to handle that.
> 
> This means that this:
> 
> 	#include <linux/aio_abi.h>
> 	void main(void)
> 	{
> 	        aio_context_t ctx_idp;
> 	        io_setup(0x80000001, &ctx_idp);
> 	}
> 
> Would trigger the newly added BUG() couple of lines after the overflow
> checks.

This BUG() isn't in Linus' tree, and probably should be removed before 
it gets there.

> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  fs/aio.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index 5b7ed78..0ae450a 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -411,7 +411,8 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
>  
>  	/* Prevent overflows */
>  	if ((nr_events > (0x10000000U / sizeof(struct io_event))) ||
> -	    (nr_events > (0x10000000U / sizeof(struct kiocb)))) {
> +	    (nr_events > (0x10000000U / sizeof(struct kiocb))) ||
> +	    (nr_events < num_possible_cpus() * 4)) {
>  		pr_debug("ENOMEM: nr_events too high\n");
>  		return ERR_PTR(-EINVAL);

This is completely wrong.  Enforcing a minimum needs to be done in a way 
that doesn't fail for existing users that potentially use a minimum 
smaller than what is newly required.  That is: an existing userland program 
that only requests 16 events must not fail because of changes to the kernel 
that increase the minimum number of requests.  So I have to NACK this patch 
as it stands.

		-ben

>  	}
> -- 
> 1.8.2.1

-- 
"Thought is the essence of where you are now."
