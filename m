Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab3DVNfd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 09:35:33 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:50559 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565Ab3DVNfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 09:35:32 -0400
Message-ID: <51753CAE.5010506@suse.cz>
Date: Mon, 22 Apr 2013 15:35:42 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: stable <stable@vger.kernel.org>
CC: Jiri Kosina <jkosina@suse.cz>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [stable-3.0 revert request] sysfs: fix race between readdir and lseek
References: <51741967.6070400@suse.de> <51742C34.2080802@suse.de> <alpine.LNX.2.00.1304220028000.1341@pobox.suse.cz> <alpine.LNX.2.00.1304221530120.1341@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1304221530120.1341@pobox.suse.cz>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to Jiri Kosina et al...

See the reasons below.

On 04/22/2013 03:32 PM, Jiri Kosina wrote:
> From: Jiri Kosina <jkosina@suse.cz>
> Subject: [PATCH 3.0-stable] Revert "sysfs: fix race between readdir and lseek"
> 
> This reverts commit 991f76f837bf22c5bb07261cfd86525a0a96650c.
> 
> It depends on ef3d0fd27e90f ("vfs: do (nearly) lockless generic_file_llseek")
> which is available only in 3.2+.
> 
> When applied on 3.0 codebase, it causes A-A deadlock, whenever anyone does
> seek() on sysfs, as both generic_file_llseek() and sysfs_dir_llseek() obtain
> i_mutex.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---
>  fs/sysfs/dir.c |   13 +------------
>  1 files changed, 1 insertions(+), 12 deletions(-)
> 
> Index: linux-3.0-SLE11-SP3-sysfs-hang-debug/fs/sysfs/dir.c
> ===================================================================
> --- linux-3.0-SLE11-SP3-sysfs-hang-debug.orig/fs/sysfs/dir.c
> +++ linux-3.0-SLE11-SP3-sysfs-hang-debug/fs/sysfs/dir.c
> @@ -961,21 +961,9 @@ static int sysfs_readdir(struct file * f
>  	return 0;
>  }
>  
> -static loff_t sysfs_dir_llseek(struct file *file, loff_t offset, int whence)
> -{
> -	struct inode *inode = file->f_path.dentry->d_inode;
> -	loff_t ret;
> -
> -	mutex_lock(&inode->i_mutex);
> -	ret = generic_file_llseek(file, offset, whence);
> -	mutex_unlock(&inode->i_mutex);
> -
> -	return ret;
> -}
> -
>  const struct file_operations sysfs_dir_operations = {
>  	.read		= generic_read_dir,
>  	.readdir	= sysfs_readdir,
>  	.release	= sysfs_dir_release,
> -	.llseek		= sysfs_dir_llseek,
> +	.llseek		= generic_file_llseek,
>  };
> 


-- 
js
suse labs
