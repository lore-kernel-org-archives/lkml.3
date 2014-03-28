Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431AbaC1WnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 18:43:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54180 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaC1WnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 18:43:02 -0400
Date: Fri, 28 Mar 2014 15:43:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "fengguang.wu" <fengguang.wu@intel.com>,
        "Chen, Jet" <jet.chen@intel.com>
Subject: Re: [PATCH linux-next v2] ufs: sb mutex merge + mutex_destroy: fix
Message-Id: <20140328154301.c25c495a8fcfd510ba2bf019@linux-foundation.org>
In-Reply-To: <20140327233831.c32f99a8fbabb31a5e37e598@skynet.be>
References: <20140327233831.c32f99a8fbabb31a5e37e598@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Mar 2014 23:38:31 +0100 Fabian Frederick <fabf@skynet.be> wrote:

> mutex_destroy was also called when trying to mount volume in read/write
> without write support enabled.
> 
> --- a/fs/ufs/super.c
> +++ b/fs/ufs/super.c
> @@ -798,7 +798,7 @@ static int ufs_fill_super(struct super_block *sb, void *data, int silent)
>  	if (!(sb->s_flags & MS_RDONLY)) {
>  		printk("ufs was compiled with read-only support, "
>  		"can't be mounted as read-write\n");
> -		goto failed;
> +		goto failed_noreadwrite;
>  	}
>  #endif
>  	mutex_init(&sbi->mutex);
> @@ -1255,10 +1255,14 @@ magic_found:
>  	return 0;
>  
>  failed:
> +	mutex_destroy(&sbi->mutex);
> +
> +#ifndef CONFIG_UFS_FS_WRITE
> +failed_noreadwrite:
> +#endif
>  	if (ubh)
>  		ubh_brelse_uspi (uspi);
>  	kfree (uspi);
> -	mutex_destroy(&sbi->mutex);
>  	kfree(sbi);
>  	sb->s_fs_info = NULL;
>  	UFSD("EXIT (FAILED)\n");

Ugly.  Wht don't we perform the check before we've allocated anything
so we can simply return?

And it should return -EROFS, not -EINVAL.

--- a/fs/ufs/super.c~ufs-sb-mutex-merge-mutex_destroy-fix-v2-fix
+++ a/fs/ufs/super.c
@@ -785,6 +785,14 @@ static int ufs_fill_super(struct super_b
 	flags = 0;
 	
 	UFSD("ENTER\n");
+
+#ifndef CONFIG_UFS_FS_WRITE
+	if (!(sb->s_flags & MS_RDONLY)) {
+		printk("ufs was compiled with read-only support, "
+		       "can't be mounted as read-write\n");
+		return -EROFS;
+	}
+#endif
 		
 	sbi = kzalloc(sizeof(struct ufs_sb_info), GFP_KERNEL);
 	if (!sbi)
@@ -794,13 +802,6 @@ static int ufs_fill_super(struct super_b
 
 	UFSD("flag %u\n", (int)(sb->s_flags & MS_RDONLY));
 	
-#ifndef CONFIG_UFS_FS_WRITE
-	if (!(sb->s_flags & MS_RDONLY)) {
-		printk("ufs was compiled with read-only support, "
-		"can't be mounted as read-write\n");
-		goto failed_noreadwrite;
-	}
-#endif
 	mutex_init(&sbi->mutex);
 	spin_lock_init(&sbi->work_lock);
 	INIT_DELAYED_WORK(&sbi->sync_work, delayed_sync_fs);
@@ -1256,10 +1257,6 @@ magic_found:
 
 failed:
 	mutex_destroy(&sbi->mutex);
-
-#ifndef CONFIG_UFS_FS_WRITE
-failed_noreadwrite:
-#endif
 	if (ubh)
 		ubh_brelse_uspi (uspi);
 	kfree (uspi);
_

