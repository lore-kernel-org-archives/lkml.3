Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934310Ab3FSJaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 05:30:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34360 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933820Ab3FSJac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 05:30:32 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: Dave Chiluk <chiluk@canonical.com>
Cc: viro@zeniv.linux.org.uk, petr@vandrovec.name, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] ncpfs: fix rmdir returns Device or resource busy
References: <1369781410-24473-1-git-send-email-chiluk@canonical.com>
Date: Wed, 19 Jun 2013 10:30:26 +0100
In-Reply-To: <1369781410-24473-1-git-send-email-chiluk@canonical.com> (Dave
	Chiluk's message of "Tue, 28 May 2013 17:50:10 -0500")
Message-ID: <87fvwev45p.fsf@canonical.com>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chiluk <chiluk@canonical.com> writes:

> 1d2ef5901483004d74947bbf78d5146c24038fe7 caused a regression in ncpfs such that
> directories could no longer be removed.  This was because ncp_rmdir checked
> to see if a dentry could be unhashed before allowing it to be removed. Since
> 1d2ef5901483004d74947bbf78d5146c24038fe7 introduced a change that incremented
> dentry->d_count causing it to always be greater than 1 unhash would always
> fail.  Thus causing the error path in ncp_rmdir to always be taken.  Removing
> this error path is safe as unhashing is still accomplished by calls to dput
> from vfs_rmdir.

Stable kernels starting with 3.0 also contain the offending commit, so
I believe this patch should be applied to stable kernels as well.

Upstream commit is 698b8223631472bf982ed570b0812faa61955683.

Cheers,
-- 
Luis

> ---
>  fs/ncpfs/dir.c |    9 ---------
>  1 file changed, 9 deletions(-)
>
> diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
> index 8163260..6792ce1 100644
> --- a/fs/ncpfs/dir.c
> +++ b/fs/ncpfs/dir.c
> @@ -1029,15 +1029,6 @@ static int ncp_rmdir(struct inode *dir, struct dentry *dentry)
>  	DPRINTK("ncp_rmdir: removing %s/%s\n",
>  		dentry->d_parent->d_name.name, dentry->d_name.name);
>  
> -	/*
> -	 * fail with EBUSY if there are still references to this
> -	 * directory.
> -	 */
> -	dentry_unhash(dentry);
> -	error = -EBUSY;
> -	if (!d_unhashed(dentry))
> -		goto out;
> -
>  	len = sizeof(__name);
>  	error = ncp_io2vol(server, __name, &len, dentry->d_name.name,
>  			   dentry->d_name.len, !ncp_preserve_case(dir));
