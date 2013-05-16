Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab3EPI7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 04:59:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:32703 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755785Ab3EPI7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 04:59:42 -0400
X-IronPort-AV: E=Sophos;i="4.87,683,1363104000"; 
   d="scan'208";a="7284955"
Message-ID: <51949F70.9020306@cn.fujitsu.com>
Date: Thu, 16 May 2013 16:57:20 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Vahram Martirosyan <vmartirosyan@gmail.com>
CC: Dave Kleikamp <shaggy@kernel.org>,
        Vahram Martirosyan <vahram.martirosyan@linuxtesting.org>,
        jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        spruce-project@linuxtesting.org
Subject: Re: [PATCH] jfs: Functions jfs_freeze() and jfs_unfreeze() always
 return 0
References: <1368681273-869-1-git-send-email-vahram.martirosyan@linuxtesting.org>
In-Reply-To: <1368681273-869-1-git-send-email-vahram.martirosyan@linuxtesting.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/16 16:58:22,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/16 16:58:25,
	Serialize complete at 2013/05/16 16:58:25
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2013 01:14 PM, Vahram Martirosyan wrote:

> The mentioned functions do not pay attention to the error codes returned
> by the functions updateSuper(), lmLogInit() and lmLogShutdown(). It brings to
> system crash later when writing to log.
> 
> The patch adds corresponding code to check and return the error codes
> and to print correct error messages in case of errors.
> 
> Found by Linux File System Verification project (linuxtesting.org).
> 
> Signed-off-by: Vahram Martirosyan <vahram.martirosyan@linuxtesting.org>


Reviewed-by: Gu Zheng <guz.fnst@cn.fujitsu.com>

> ---
>  fs/jfs/super.c | 29 ++++++++++++++++++++++-------
>  1 file changed, 22 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/jfs/super.c b/fs/jfs/super.c
> index 2003e83..a3d424d 100644
> --- a/fs/jfs/super.c
> +++ b/fs/jfs/super.c
> @@ -611,11 +611,20 @@ static int jfs_freeze(struct super_block *sb)
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
> +		if (rc != 0) {

"if (rc)", and the following. 

Thanks,
Gu

> +			jfs_err("lmLogShutdown failed with return code %d", rc);
> +			return rc;
> +		}
> +		rc = updateSuper(sb, FM_CLEAN);
> +		if (rc != 0) {
> +			jfs_err("updateSuper failed with return code %d", rc);
> +			return rc;
> +		}
>  	}
>  	return 0;
>  }
> @@ -627,11 +636,17 @@ static int jfs_unfreeze(struct super_block *sb)
>  	int rc = 0;
>  
>  	if (!(sb->s_flags & MS_RDONLY)) {
> -		updateSuper(sb, FM_MOUNT);
> -		if ((rc = lmLogInit(log)))
> -			jfs_err("jfs_unlock failed with return code %d", rc);
> -		else
> -			txResume(sb);
> +		rc = updateSuper(sb, FM_MOUNT);
> +		if (rc != 0) {
> +			jfs_err("updateSuper failed with return code %d", rc);
> +			return rc;
> +		}
> +		rc = lmLogInit(log);
> +		if (rc != 0) {
> +			jfs_err("lmLogInit failed with return code %d", rc);
> +			return rc;
> +		}
> +		txResume(sb);
>  	}
>  	return 0;
>  }


