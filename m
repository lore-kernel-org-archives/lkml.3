Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402AbaHJHl4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 03:41:56 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:51459 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaHJHlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 03:41:55 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Sasha Levin <sasha.levin@oracle.com>, ericvh@gmail.com,
        rminnich@sandia.gov, lucho@ionkov.net
Cc: v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [V9fs-developer] [PATCH] fs/9p/: don't treat error as status value	in file locking
In-Reply-To: <1403480661-32620-1-git-send-email-sasha.levin@oracle.com>
References: <1403480661-32620-1-git-send-email-sasha.levin@oracle.com>
User-Agent: Notmuch/0.18.1 (http://notmuchmail.org) Emacs/24.3.91.1 (x86_64-unknown-linux-gnu)
Date: Sun, 10 Aug 2014 13:11:43 +0530
Message-ID: <8761i0u6yw.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081007-0260-0000-0000-0000000E0217
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin <sasha.levin@oracle.com> writes:

> When trying to lock a file we didn't properly handle the case where a
> failure in p9_client_lock_dotl() occurs and treated the status value
> as valid instead of discarding it due to the error.
>
> This would usually trigger a BUG() since the status value would
> just be stack garbage.
>
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  fs/9p/vfs_file.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
> index 520c11c..06077f3 100644
> --- a/fs/9p/vfs_file.c
> +++ b/fs/9p/vfs_file.c
> @@ -194,7 +194,7 @@ static int v9fs_file_do_lock(struct file *filp, int cmd, struct file_lock *fl)
>  	for (;;) {
>  		res = p9_client_lock_dotl(fid, &flock, &status);
>  		if (res < 0)
> -			break;
> +			return res;
>
>  		if (status != P9_LOCK_BLOCKED)
>  			break;

We may want to do the local revert of the posix lock held. ie,

diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index 520c11c2dcca..20ed603e60b2 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -194,7 +194,7 @@ static int v9fs_file_do_lock(struct file *filp, int cmd, struct file_lock *fl)
 	for (;;) {
 		res = p9_client_lock_dotl(fid, &flock, &status);
 		if (res < 0)
-			break;
+			goto err_out;
 
 		if (status != P9_LOCK_BLOCKED)
 			break;
@@ -220,6 +220,7 @@ static int v9fs_file_do_lock(struct file *filp, int cmd, struct file_lock *fl)
 		BUG();
 	}
 
+err_out:
 	/*
 	 * incase server returned error for lock request, revert
 	 * it locally

