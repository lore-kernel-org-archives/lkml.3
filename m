Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbaGGDSw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 23:18:52 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:29553 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbaGGDSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 23:18:48 -0400
X-AuditID: cbfee61a-f79e46d00000134f-1b-53ba11960ada
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <1404297270-26809-1-git-send-email-jaegeuk@kernel.org>
In-reply-to: <1404297270-26809-1-git-send-email-jaegeuk@kernel.org>
Subject: RE: [f2fs-dev] [PATCH] f2fs: do checkpoint for the renamed inode
Date: Mon, 07 Jul 2014 11:17:35 +0800
Message-id: <006101cf9992$2a077340$7e1659c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQKdyc2R7jksmCsoklYob+94qQZLpJn3dQ8w
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9jAd1pgruCDVqaJC2erJ/FbHFpkbvF
	nr0nWSwu75rD5sDisWlVJ5vH7gWfmTw+b5ILYI7isklJzcksSy3St0vgynjw6zNzwRbpirOT
	ZrM2MB4S62Lk5JAQMJFYu+gNM4QtJnHh3nq2LkYuDiGBRYwS+/5fZodwfjBKHHw7jQmkik1A
	RWJ5x38wW0RATaJ33xQwm1kgU2JC/wt2EFtIwEni9L9bYFM5BZwlJu18BzSVg0NYwFPiyPwK
	kDCLgKrE9XUfwcp5BSwlfh66ywJhC0r8mHyPBWKklsT6ncehxstLbF7zFupQBYkdZ18zQpxg
	JNH7+RhUjbjExiO3WCYwCs1CMmoWklGzkIyahaRlASPLKkbR1ILkguKk9FxDveLE3OLSvHS9
	5PzcTYzgwH8mtYNxZYPFIUYBDkYlHt4Dq3YGC7EmlhVX5h5ilOBgVhLhPeMGFOJNSaysSi3K
	jy8qzUktPsQozcGiJM57oNU6UEggPbEkNTs1tSC1CCbLxMEp1cBovlGaL0z2MA/vdgO/7zsv
	LNLI4HiUG/5vy+8neXJbL3DfEPDwm3Pjx1lRmS0fH1/cInrgW2G85s//stoNKhbl+qFpYtmv
	XH5xt/eK6QY/zJy0tDRv1UWj7NRz5heZiqd/K3j8Wt+bMSCfZ0X92Wvntn9f6OSv0q/kfSru
	G//63XZH3A8/WDJDiaU4I9FQi7moOBEA8TkypngCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Wednesday, July 02, 2014 6:35 PM
> To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Cc: Jaegeuk Kim
> Subject: [f2fs-dev] [PATCH] f2fs: do checkpoint for the renamed inode
> 
> If an inode is renamed, it should be registered as file_lost_pino to conduct
> checkpoint at f2fs_sync_file.
> Otherwise, the inode cannot be recovered due to no dent_mark in the following
> scenario.
> 
> Note that, this scenario is from xfstests/322.
> 
> 1. create "a"
> 2. fsync "a"
> 3. rename "a" to "b"
> 4. fsync "b"
> 5. Sudden power-cut
> 
> After recovery is done, "b" should be seen.
> However, the result shows "a", since the recovery procedure does not enter
> recover_dentry due to no dent_mark.

As we know CP is expensive, how about modifying checkpointed value directly
in nat cache at step #3? So "b" could be fsynced with dent_mark at step #4.

> 
> The reason is like below.
> - The nid of "a" is checkpointed during #2, f2fs_sync_file.
> - The inode page for "b" produced by #3 is written without dent_mark by
> sync_node_pages.
> 
> So, this patch fixes this bug by assinging file_lost_pino to the "a"'s inode.
> If the pino is lost, f2fs_sync_file conducts checkpoint, and then recovers
> the latest pino and its dentry information for further recovery.
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>  fs/f2fs/namei.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
> index 96f1dd1..1b3cae0 100644
> --- a/fs/f2fs/namei.c
> +++ b/fs/f2fs/namei.c
> @@ -411,9 +411,6 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
>  		}
> 
>  		f2fs_set_link(new_dir, new_entry, new_page, old_inode);
> -		down_write(&F2FS_I(old_inode)->i_sem);
> -		F2FS_I(old_inode)->i_pino = new_dir->i_ino;
> -		up_write(&F2FS_I(old_inode)->i_sem);
> 
>  		new_inode->i_ctime = CURRENT_TIME;
>  		down_write(&F2FS_I(new_inode)->i_sem);
> @@ -446,6 +443,10 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
>  		}
>  	}
> 
> +	down_write(&F2FS_I(old_inode)->i_sem);
> +	file_lost_pino(old_inode);
> +	up_write(&F2FS_I(old_inode)->i_sem);
> +
>  	old_inode->i_ctime = CURRENT_TIME;
>  	mark_inode_dirty(old_inode);
> 
> @@ -455,9 +456,6 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
>  		if (old_dir != new_dir) {
>  			f2fs_set_link(old_inode, old_dir_entry,
>  						old_dir_page, new_dir);
> -			down_write(&F2FS_I(old_inode)->i_sem);
> -			F2FS_I(old_inode)->i_pino = new_dir->i_ino;
> -			up_write(&F2FS_I(old_inode)->i_sem);
>  			update_inode_page(old_inode);
>  		} else {
>  			kunmap(old_dir_page);
> --
> 1.8.5.2 (Apple Git-48)
> 
> 
> ------------------------------------------------------------------------------
> Open source business process management suite built on Java and Eclipse
> Turn processes into business applications with Bonita BPM Community Edition
> Quickly connect people, data, and systems into organized workflows
> Winner of BOSSIE, CODIE, OW2 and Gartner awards
> http://p.sf.net/sfu/Bonitasoft
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

