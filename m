Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbaIAXIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 19:08:41 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42778 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbaIAXIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 19:08:40 -0400
Date: Tue, 2 Sep 2014 00:08:35 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Evgeniy Dushistov <dushistov@mail.ru>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH] ufs: fix deadlocks after mutex merge
Message-ID: <20140901230835.GK7996@ZenIV.linux.org.uk>
References: <1409610624-10898-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409610624-10898-1-git-send-email-khoroshilov@ispras.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 02:30:24AM +0400, Alexey Khoroshilov wrote:
> Commit 0244756edc4b ("ufs: sb mutex merge + mutex_destroy") introduces
> deadlocks in ufs_new_inode() and ufs_free_inode() that call lock_ufs()
> being already invoked with mutex held.
> 
> ufs_free_inode() is always invoked with mutex locked, while
> ufs_new_inode() is called with mutex locked two times of four.
> 
> The patch proposes to resolve the issue by agreement to call
> ufs_new_inode() and ufs_free_inode() with mutex unheld.

> @@ -902,9 +902,6 @@ void ufs_evict_inode(struct inode * inode)
>  	invalidate_inode_buffers(inode);
>  	clear_inode(inode);
>  
> -	if (want_delete) {
> -		lock_ufs(inode->i_sb);
> -		ufs_free_inode (inode);
> -		unlock_ufs(inode->i_sb);
> -	}
> +	if (want_delete)
> +		ufs_free_inode(inode);

Your commit message makes no sense - ufs_evict_inode() is *never* called
with that lock held, for one thing.  I agree that "ufs: sb mutex merge +
mutex_destroy" was been badly broken and apparently never tested, though -
the bugs are real.

	Please, write a saner commit message; what happens is that
ufs_{new,free}_inode() take the damn lock themselves these days, so
their caller shouldn't do that.
