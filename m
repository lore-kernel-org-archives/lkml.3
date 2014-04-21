Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846AbaDUMrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 08:47:13 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:40436 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbaDUMrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 08:47:10 -0400
Message-ID: <5355132F.4070303@oracle.com>
Date: Mon, 21 Apr 2014 20:46:39 +0800
From: Jeff Liu <jeff.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>,
        Dave Chinner <david@fromorbit.com>
CC: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH] xfs: Fix wrong error codes being returned
References: <1398074687-26548-1-git-send-email-tuomas.tynkkynen@iki.fi>
In-Reply-To: <1398074687-26548-1-git-send-email-tuomas.tynkkynen@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tuomas,

On 04/21 2014 18:04 PM, Tuomas Tynkkynen wrote:
> xfs_{compat_,}attrmulti_by_handle could return an errno with incorrect
> sign in some cases. While at it, make sure ENOMEM is returned instead of
> E2BIG if kmalloc fails.
> 
> Signed-off-by: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
> ---
> Compile tested only. For the ERANGE case, I also wonder if it should
> be assigning to ops[i].am_error instead of error, and/or have a break.

If I understand right, ops[i].am_error is used to save the internal operation result,
i.e, xfs_attrmult_attr_get{set}... but error is used for the ioctl call results.
Therefore, assign ERANGE to error is compatible with the VFS set{get}xattr syscalls in
case of "if (ops[i].am_error == 0 || ops[i].am_error == MAXNAMELEN)".

It seems that we don't need to have a break in this case because xfs_attrmulti_by_handle()
is used to process multiple attrs.  Hence if a given attrname in ops array is invalid,
the am_error will indicate that with ENOATTR or EFAULT...but it should proceed to loop
through the left array members.

Also, looks there is another minor issue at xfs_attrmulti_attr_set(), we should return
-PTR_ERR(kbuf) if call memdup_user() failed.

> 
>  fs/xfs/xfs_ioctl.c   |    5 +++--
>  fs/xfs/xfs_ioctl32.c |    5 +++--
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 0b18776..2d8f4fd 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -543,10 +543,11 @@ xfs_attrmulti_by_handle(
>  
>  	ops = memdup_user(am_hreq.ops, size);
>  	if (IS_ERR(ops)) {
> -		error = PTR_ERR(ops);
> +		error = -PTR_ERR(ops);
>  		goto out_dput;
>  	}
>  
> +	error = ENOMEM;
>  	attr_name = kmalloc(MAXNAMELEN, GFP_KERNEL);
>  	if (!attr_name)
>  		goto out_kfree_ops;
> @@ -556,7 +557,7 @@ xfs_attrmulti_by_handle(
>  		ops[i].am_error = strncpy_from_user((char *)attr_name,
>  				ops[i].am_attrname, MAXNAMELEN);
>  		if (ops[i].am_error == 0 || ops[i].am_error == MAXNAMELEN)
> -			error = -ERANGE;
> +			error = ERANGE;
>  		if (ops[i].am_error < 0)
>  			break;
>  
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index a7992f8..944d5ba 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -424,10 +424,11 @@ xfs_compat_attrmulti_by_handle(
>  
>  	ops = memdup_user(compat_ptr(am_hreq.ops), size);
>  	if (IS_ERR(ops)) {
> -		error = PTR_ERR(ops);
> +		error = -PTR_ERR(ops);
>  		goto out_dput;
>  	}
>  
> +	error = ENOMEM;
>  	attr_name = kmalloc(MAXNAMELEN, GFP_KERNEL);
>  	if (!attr_name)
>  		goto out_kfree_ops;
> @@ -438,7 +439,7 @@ xfs_compat_attrmulti_by_handle(
>  				compat_ptr(ops[i].am_attrname),
>  				MAXNAMELEN);
>  		if (ops[i].am_error == 0 || ops[i].am_error == MAXNAMELEN)
> -			error = -ERANGE;
> +			error = ERANGE;
>  		if (ops[i].am_error < 0)
>  			break;
>  

Thanks,
-Jeff
