Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560AbaG2Lm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 07:42:26 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:39516 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbaG2LmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:42:23 -0400
X-AuditID: cbfee61b-f79f86d00000144c-32-53d7889dc9aa
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <1406328445-63707-1-git-send-email-jaegeuk@kernel.org>
 <1406328445-63707-10-git-send-email-jaegeuk@kernel.org>
In-reply-to: <1406328445-63707-10-git-send-email-jaegeuk@kernel.org>
Subject: RE: [f2fs-dev] [PATCH 10/11] f2fs: avoid checkpoint when error was
	occurred
Date: Tue, 29 Jul 2014 19:41:35 +0800
Message-id: <008301cfab22$27e34fc0$77a9ef40$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: zh-cn
Thread-index: AQH0/sFA7oYZ7Fd/hcfctysO+ZeFcgIvEHQ3m1p0dGA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9jQd25HdeDDT6vULd4sn4Ws8WlRe4W
	e/aeZLG4vGsOmwOLx6ZVnWweuxd8ZvL4vEkugDmKyyYlNSezLLVI3y6BK2Ne32KmgpUiFf/f
	nmZtYLwr0MXIySEhYCLRc6eXHcIWk7hwbz0biC0kMJ1RYu77+i5GLiD7B6PEiYVbwBJsAioS
	yzv+M4HYIgJqEr37poDZzAKZEhP6X7BDNNdI7G25BxbnFHCRmLxmNVivsECYxLe7z1m6GDk4
	WARUJR52CYGEeQUsJe78e8MGYQtK/Jh8jwVipJbE+p3HocbLS2xe85YZ4k4FiR1nXzNCxMUl
	Nh65xQJxjpXEpTXT2CYwCs1CMmoWklGzkIyahaR9ASPLKkbR1ILkguKk9FwjveLE3OLSvHS9
	5PzcTYzgsH8mvYNxVYPFIUYBDkYlHt4Nc68FC7EmlhVX5h5ilOBgVhLhfVF+PViINyWxsiq1
	KD++qDQntfgQozQHi5I478FW60AhgfTEktTs1NSC1CKYLBMHp1QDIxfntMkNp4q4Cn0+7FML
	jPY+7OK9++6E6pVP2nVPP2yXW2E+seuozJoO9sWxZeUPD1X26vW6b3sfw+ZRfitK/HhD3vy/
	PHYpZxjW3WSYebDKNsW5IDItRbLEdG1N2XcFUb0VHwuWpmy4WPj+vdmD/c8c1nlIVii4e23f
	Mbnu89z2aVdsS4ROKLEUZyQaajEXFScCANAbArp3AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Saturday, July 26, 2014 6:47 AM
> To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Cc: Jaegeuk Kim
> Subject: [f2fs-dev] [PATCH 10/11] f2fs: avoid checkpoint when error was occurred
> 
> No need to do checkpoint, whenever any errors were detected.
> 

The code here is modified once at below commit for avoid unneeded cp.
You can see the reason through the description of the commit.

Commit 691c6fd2a2d6 ("remove unneeded write checkpoint in recover_fsync_data")

"Previously, recover_fsync_data still to write checkpoint when there is
nothing to recover with normal umount image.
It may reduce mount performance and flash memory lifetime, so let's remove
it."

Why we should revert the commit?

> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>  fs/f2fs/recovery.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
> index a112368..90d7e80 100644
> --- a/fs/f2fs/recovery.c
> +++ b/fs/f2fs/recovery.c
> @@ -436,7 +436,6 @@ int recover_fsync_data(struct f2fs_sb_info *sbi)
>  {
>  	struct list_head inode_list;
>  	int err;
> -	bool need_writecp = false;
> 
>  	fsync_entry_slab = f2fs_kmem_cache_create("f2fs_fsync_inode_entry",
>  			sizeof(struct fsync_inode_entry));
> @@ -454,8 +453,6 @@ int recover_fsync_data(struct f2fs_sb_info *sbi)
>  	if (list_empty(&inode_list))
>  		goto out;
> 
> -	need_writecp = true;
> -
>  	/* step #2: recover data */
>  	err = recover_data(sbi, &inode_list, CURSEG_WARM_NODE);
>  	f2fs_bug_on(!list_empty(&inode_list));
> @@ -463,7 +460,7 @@ out:
>  	destroy_fsync_dnodes(&inode_list);
>  	kmem_cache_destroy(fsync_entry_slab);
>  	sbi->por_doing = false;
> -	if (!err && need_writecp)
> +	if (!err)
>  		write_checkpoint(sbi, false);
>  	return err;
>  }
> --
> 1.8.5.2 (Apple Git-48)
> 
> 
> ------------------------------------------------------------------------------
> Want fast and easy access to all the code in your enterprise? Index and
> search up to 200,000 lines of code with a free copy of Black Duck
> Code Sight - the same software that powers the world's largest code
> search on Ohloh, the Black Duck Open Hub! Try it now.
> http://p.sf.net/sfu/bds
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

