Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab3EXREA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 13:04:00 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:50441 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132Ab3EXRD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 13:03:59 -0400
Message-ID: <519F9D63.8000305@oracle.com>
Date: Fri, 24 May 2013 12:03:31 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Vahram Martirosyan <vmartirosyan@gmail.com>
CC: Dave Kleikamp <shaggy@kernel.org>, Gu Zheng <guz.fnst@cn.fujitsu.com>,
        Vahram Martirosyan <vahram.martirosyan@linuxtesting.org>,
        jfs-discussion@lists.sourceforge.net, spruce-project@linuxtesting.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Jfs-discussion] [PATCH 1/2] jfs: Several bugs in jfs_freeze()
 and jfs_unfreeze()
References: <1369385833-6852-1-git-send-email-vahram.martirosyan@linuxtesting.org>
In-Reply-To: <1369385833-6852-1-git-send-email-vahram.martirosyan@linuxtesting.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2013 03:57 AM, Vahram Martirosyan wrote:
> The mentioned functions do not pay attention to the error codes returned
> by the functions updateSuper(), lmLogInit() and lmLogShutdown(). It brings to
> system crash later when writing to log.
> 
> The patch adds corresponding code to check and return the error codes
> and to print correct error messages in case of errors.
> 
> Besides that the lmLogShutdown() function must not be called when 'nointegrity' mount option is provided.
> It leads to kernel OOPS.
> 
> Found by Linux File System Verification project (linuxtesting.org).
> 
> Signed-off-by: Vahram Martirosyan <vahram.martirosyan@linuxtesting.org>
> 
> Reviewed-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
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
> +			jfs_err("lmLogShutdown failed with return code %d", rc);
> +			return rc;

Hmm. I'm not sure about the nicest way to recover here. txQuiesce() has
been called. This will leave the filesystem effectively frozen, but not
marked as frozen. Maybe better to call jfs_error() and maybe txResume()
in an attempt to unblock any blocked threads.

> +		}
> +		rc = updateSuper(sb, FM_CLEAN);
> +		if (rc != 0) {
> +			jfs_err("updateSuper failed with return code %d", rc);
> +			return rc;

same here, except we know that lmLogShutdown() has already succeeded.
Maybe we're better off ignoring this return code, since the freezing
succeeded. Failing to mark the filesystem clean is hardly damaging. It
just means that fsck will work harder next time, which is probably a
good idea. This is an unlikely error if everything else has succeeded.

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

I think I like calling jfs_error() here and letting the system panic,
the filesystem to be marked as read-only (default), or whatever action
is desired.

> +		}
> +		rc = lmLogInit(log);
> +		if (rc != 0) {
> +			jfs_err("lmLogInit failed with return code %d", rc);
> +			return rc;

same here

> +		}
> +		txResume(sb);
>  	}
>  	return 0;
>  }

I'm going to tweak your patch a bit and see what kind of improvement I
can make.

Thanks,
Shaggy
