Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbaFPUGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 16:06:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498AbaFPUGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 16:06:38 -0400
Date: Mon, 16 Jun 2014 22:06:26 +0200
From: Mateusz Guzik <mguzik@redhat.com>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: joern@logfs.org, prasadjoshi.linux@gmail.com, logfs@logfs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Check for Null return from logfs_readpage_nolock in
 btree_write_block
Message-ID: <20140616200625.GA27360@mguzik.redhat.com>
References: <1402948021-8797-1-git-send-email-xerofoify@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1402948021-8797-1-git-send-email-xerofoify@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 03:47:01PM -0400, Nicholas Krause wrote:
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  fs/logfs/readwrite.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/logfs/readwrite.c b/fs/logfs/readwrite.c
> index 4814031..adb9233 100644
> --- a/fs/logfs/readwrite.c
> +++ b/fs/logfs/readwrite.c
> @@ -2210,6 +2210,8 @@ void btree_write_block(struct logfs_block *block)
>  	page = logfs_get_write_page(inode, block->bix, block->level);
>  
>  	err = logfs_readpage_nolock(page);
> +	if (!err)
> +		return -ENOMEM;
>  	BUG_ON(err);
>  	BUG_ON(!PagePrivate(page));
>  	BUG_ON(logfs_block(page) != block);

This function returns 0 on success, which you turn into error condition
and return -ENOMEM.
But the function returns void, thus it cannot return the error.
It does not allocate anything, thus -ENOMEM would not be appropriate in
the first place.

Since the function returns error, nobody would check the condition in
the first place.

Even if it was not void, it would either have to return the error or
oops on BUG_ON(err).

Read the code more carefully and at least compile-test your changes.
Instructions how to compile the kernel can be found here:
http://kernelnewbies.org/FAQ/KernelCompilation

I would also suggest letting the patch wait few hours and have another
look before sending.

Cheers,
-- 
Mateusz Guzik
