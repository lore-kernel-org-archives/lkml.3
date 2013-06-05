Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab3FEN17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 09:27:59 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:32533 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267Ab3FEN16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 09:27:58 -0400
Message-ID: <51AF3CCE.1060908@oracle.com>
Date: Wed, 05 Jun 2013 08:27:42 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jonghwan Choi <jhbird.choi@samsung.com>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "'Vahram Martirosyan'" <vahram.martirosyan@linuxtesting.org>
Subject: Re: [PATCH 3.9-stable]  jfs: Several bugs in jfs_freeze() and jfs_unfreeze()
References: <000001ce60c9$622de130$2689a390$%choi@samsung.com>
In-Reply-To: <000001ce60c9$622de130$2689a390$%choi@samsung.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2013 09:15 PM, Jonghwan Choi wrote:
> This patch looks like it should be in the 3.9-stable tree, should we apply
> it?

I'm kind of on the fence on this one. I believe the failure here was
triggered by induced errors to check the error paths. I'm not aware of a
real-world crash due to the problem being fixed here. Of course, it's
possible, but I don't think it's very likely.

Thanks,
Dave

> 
> ------------------
> 
> From: "Vahram Martirosyan <vmartirosyan@gmail.com>"
> 
> commit e9b376671910d105c5e61103111b96209c729529 upstream
> 
> The mentioned functions do not pay attention to the error codes returned
> by the functions updateSuper(), lmLogInit() and lmLogShutdown(). It brings
> to system crash later when writing to log.
> 
> The patch adds corresponding code to check and return the error codes
> and to print correct error messages in case of errors.
> 
> Found by Linux File System Verification project (linuxtesting.org).
> 
> Signed-off-by: Vahram Martirosyan <vahram.martirosyan@linuxtesting.org>
> Reviewed-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> ---
>  fs/jfs/super.c |   38 ++++++++++++++++++++++++++++++--------
>  1 file changed, 30 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/jfs/super.c b/fs/jfs/super.c
> index 1a543be..2502d39 100644
> --- a/fs/jfs/super.c
> +++ b/fs/jfs/super.c
> @@ -611,11 +611,28 @@ static int jfs_freeze(struct super_block *sb)
>  {
>  	struct jfs_sb_info *sbi = JFS_SBI(sb);
>  	struct jfs_log *log = sbi->log;
> +	int rc = 0;
>  
>  	if (!(sb->s_flags & MS_RDONLY)) {
>  		txQuiesce(sb);
> -		lmLogShutdown(log);
> -		updateSuper(sb, FM_CLEAN);
> +		rc = lmLogShutdown(log);
> +		if (rc) {
> +			jfs_error(sb, "jfs_freeze: lmLogShutdown failed");
> +
> +			/* let operations fail rather than hang */
> +			txResume(sb);
> +
> +			return rc;
> +		}
> +		rc = updateSuper(sb, FM_CLEAN);
> +		if (rc) {
> +			jfs_err("jfs_freeze: updateSuper failed\n");
> +			/*
> +			 * Don't fail here. Everything succeeded except
> +			 * marking the superblock clean, so there's really
> +			 * no harm in leaving it frozen for now.
> +			 */
> +		}
>  	}
>  	return 0;
>  }
> @@ -627,13 +644,18 @@ static int jfs_unfreeze(struct super_block *sb)
>  	int rc = 0;
>  
>  	if (!(sb->s_flags & MS_RDONLY)) {
> -		updateSuper(sb, FM_MOUNT);
> -		if ((rc = lmLogInit(log)))
> -			jfs_err("jfs_unlock failed with return code %d",
> rc);
> -		else
> -			txResume(sb);
> +		rc = updateSuper(sb, FM_MOUNT);
> +		if (rc) {
> +			jfs_error(sb, "jfs_unfreeze: updateSuper failed");
> +			goto out;
> +		}
> +		rc = lmLogInit(log);
> +		if (rc)
> +			jfs_error(sb, "jfs_unfreeze: lmLogInit failed");
> +out:
> +		txResume(sb);
>  	}
> -	return 0;
> +	return rc;
>  }
>  
>  static struct dentry *jfs_do_mount(struct file_system_type *fs_type,
> 
