Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbaG2Lkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 07:40:33 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:36365 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbaG2Lkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:40:32 -0400
X-AuditID: cbfee61b-f79f86d00000144c-73-53d7882ecb71
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <1406328445-63707-1-git-send-email-jaegeuk@kernel.org>
 <1406328445-63707-6-git-send-email-jaegeuk@kernel.org>
In-reply-to: <1406328445-63707-6-git-send-email-jaegeuk@kernel.org>
Subject: RE: [f2fs-dev] [PATCH 06/11] f2fs: skip unnecessary data writes during
	fsync
Date: Tue, 29 Jul 2014 19:39:45 +0800
Message-id: <008201cfab21$e5c57ff0$b1507fd0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: zh-cn
Thread-index: AQH0/sFA7oYZ7Fd/hcfctysO+ZeFcgIEH1bJm1wWurA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9jQV29juvBBi++alk8WT+L2eLSIneL
	PXtPslhc3jWHzYHFY9OqTjaP3Qs+M3l83iQXwBzFZZOSmpNZllqkb5fAlXH3qHvBP+GKRyd2
	sjUwrhboYuTkkBAwkVj39R4jhC0mceHeerYuRi4OIYHpjBInNzYwQzg/GCU23O8Gq2ITUJFY
	3vGfCcQWEVCT6N03BcxmFsiUmND/gh3EFhKolujbtQCsnlPAWWLfw1tAUzk4hAXCJTZ8lQAJ
	swioSkzctZcNxOYVsJRonH+WCcIWlPgx+R4LxEgtifU7j0ONl5fYvOYtM8ShChI7zr5mhIiL
	S2w8cosF4hwriVmHuxgnMArNQjJqFpJRs5CMmoWkfQEjyypG0dSC5ILipPRcI73ixNzi0rx0
	veT83E2M4LB/Jr2DcVWDxSFGAQ5GJR7eDXOvBQuxJpYVV+YeYpTgYFYS4X1Rfj1YiDclsbIq
	tSg/vqg0J7X4EKM0B4uSOO/BVutAIYH0xJLU7NTUgtQimCwTB6dUA2OE16PjHFt/VvRmfrJy
	t1bs8H3OeWPTWuH2Z/NN/p5SSU75++ThJq31b9zq+ftyYqfrLedve13dUV3xQe/HzIZG77h4
	nQjT1/Pu753RuMzc7Jllpc2Nl1/ZYgy3ndrkeEkhTudd4tw3R+blzuRMcE4O/dn8LftxCXvt
	Q7FVzVy3nsy6U2ZSX6vEUpyRaKjFXFScCACZEyt/dwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Saturday, July 26, 2014 6:47 AM
> To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Cc: Jaegeuk Kim
> Subject: [f2fs-dev] [PATCH 06/11] f2fs: skip unnecessary data writes during fsync
> 
> This patch intends to improve the fsync performance by skipping remaining the
> recovery information, only when there is no data that we should recover.
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>  fs/f2fs/file.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> index 7c652b3..121689a 100644
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -133,6 +133,17 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int
> datasync)
>  		return ret;
>  	}
> 
> +	/*
> +	 * if there is no written data, don't waste time to write recovery info.
> +	 */
> +	if (!is_inode_flag_set(fi, FI_APPEND_WRITE) &&
> +		!exist_written_data(sbi, inode->i_ino, APPEND_INO)) {
> +		if (is_inode_flag_set(fi, FI_UPDATE_WRITE) &&
> +			exist_written_data(sbi, inode->i_ino, UPDATE_INO))

Should we shift this to is_inode_flag_set(fi, FI_UPDATE_WRITE) ||
exist_written_data(sbi, inode->i_ino, UPDATE_INO) ?

> +			goto flush_out;
> +		goto out;
> +	}
> +
>  	/* guarantee free sections for fsync */
>  	f2fs_balance_fs(sbi);
> 
> @@ -188,6 +199,11 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int
> datasync)
>  		ret = wait_on_node_pages_writeback(sbi, inode->i_ino);
>  		if (ret)
>  			goto out;
> +
> +		/* once recovery info is written, don't need to tack this */
> +		remove_dirty_inode(sbi, inode->i_ino, APPEND_INO);
> +flush_out:
> +		remove_dirty_inode(sbi, inode->i_ino, UPDATE_INO);
>  		ret = f2fs_issue_flush(F2FS_SB(inode->i_sb));
>  	}
>  out:
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

