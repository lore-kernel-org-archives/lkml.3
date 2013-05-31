Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146Ab3EaVkq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 17:40:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52268 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757163Ab3EaVkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 17:40:20 -0400
Message-ID: <51A918B8.20303@canonical.com>
Date: Fri, 31 May 2013 16:40:08 -0500
From: Dave Chiluk <chiluk@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: viro@zeniv.linux.org.uk, petr@vandrovec.name, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ncpfs: fix rmdir returns Device or resource busy
References: <1369781410-24473-1-git-send-email-chiluk@canonical.com>
In-Reply-To: <1369781410-24473-1-git-send-email-chiluk@canonical.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any thoughts on this?  NCPFS seems to be the forgotten, left-behind,
red-headed stepchild of the fs community.

Dave.

On 05/28/2013 05:50 PM, Dave Chiluk wrote:
> 1d2ef5901483004d74947bbf78d5146c24038fe7 caused a regression in ncpfs such that
> directories could no longer be removed.  This was because ncp_rmdir checked
> to see if a dentry could be unhashed before allowing it to be removed. Since
> 1d2ef5901483004d74947bbf78d5146c24038fe7 introduced a change that incremented
> dentry->d_count causing it to always be greater than 1 unhash would always
> fail.  Thus causing the error path in ncp_rmdir to always be taken.  Removing
> this error path is safe as unhashing is still accomplished by calls to dput
> from vfs_rmdir.
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
> 

