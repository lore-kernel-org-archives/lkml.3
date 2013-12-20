Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab3LTCQB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 21:16:01 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:61345 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab3LTCP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 21:15:59 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-7e-52b3a85effc2
From: Chao Yu <chao2.yu@samsung.com>
To: jaegeuk.kim@samsung.com
Cc: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org
References: <1387244992-7038-1-git-send-email-jaegeuk.kim@samsung.com>
 <1387325521.2101.212.camel@kjgkr>
In-reply-to: <1387325521.2101.212.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH] f2fs: introduce a new direct_IO write path
Date: Fri, 20 Dec 2013 10:14:58 +0800
Message-id: <000b01cefd29$6c1e61e0$445b25a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIuN7ZoSJWXSWJORHKD4kLFTtrs2wIHyjEvmY2fh9A=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t9jAd24FZuDDN68kbK4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK2PN0q+MBUslK37N
	6mJrYLwi0sXIwSEhYCKx6lx+FyMnkCkmceHeerYuRi4OIYFFjBLbmtoYIZwfjBITl8xgAali
	E1CRWN7xnwnEFhGQlpj1aR4LyCBmgUyJ84cTQcJCAlkSa5ZuBCvnFNCT+N5/lA2kRFjAS6Lv
	WzFImEVAVaLj0xJWEJtXwFJi7+Z/TBC2oMSPyffAWpkFtCTW7zzOBGHLS2xe85YZ4k4FiR1n
	XzOCjBQRsJLYcdoZokRcYuORWywTGIVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnqukV5x
	Ym5xaV66XnJ+7iZGcMg/k97BuKrB4hCjAAejEg9vgf7mICHWxLLiytxDjBIczEoivCtmA4V4
	UxIrq1KL8uOLSnNSiw8xSnOwKInzHmy1DhQSSE8sSc1OTS1ILYLJMnFwSjUwZnEvMnthwvF0
	o8N6baHlgbPlts1abvSQz/za7IikbpmULvXnzLcreT05TyTZZ999tVfuQ6VK3q52zsfrTp84
	qBiT39u77umi7/yX/XPdHnx5e1j7U4vTOr4fVXo/Nm/2jviVG1STIOu74WjcG88VNdKbeWo8
	VWbVz2t7kNDnp+e9483U8/ealFiKMxINtZiLihMB7zFWIXUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim,

One comment as following:

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Wednesday, December 18, 2013 8:12 AM
> To: linux-fsdevel@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net
> Subject: Re: [f2fs-dev] [PATCH] f2fs: introduce a new direct_IO write path
> 
> Change log from v1:
>  o fix NOSPC error handling
> 
> >From b8511a74fe98b67247a9feeed58441e8f5ffd705 Mon Sep 17 00:00:00 2001
> From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> Date: Mon, 16 Dec 2013 19:04:05 +0900
> Subject: [PATCH] f2fs: introduce a new direct_IO write path
> Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
> linux-f2fs-devel@lists.sourceforge.net
> 
> Previously, f2fs doesn't support direct IOs with high performance, which
> throws
> every write requests via the buffered write path, resulting in highly
> performance degradation due to memory opeations like copy_from_user.
> 
> This patch introduces a new direct IO path in which every write requests
> are
> processed by generic blockdev_direct_IO() with enhanced get_block
> function.
> 
> The get_data_block() in f2fs handles:
> 1. if original data blocks are allocates, then give them to blockdev.
> 2. otherwise,
>   a. preallocate requested block addresses
>   b. do not use extent cache for better performance
>   c. give the block addresses to blockdev
> 
> This policy induces that:
> - new allocated data are sequentially written to the disk
> - updated data are randomly written to the disk.
> - f2fs gives consistency on its file meta, not file data.
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> ---
>  fs/f2fs/data.c    | 152
> ++++++++++++++++++++++++++++++++++++++++--------------
>  fs/f2fs/f2fs.h    |   2 +
>  fs/f2fs/segment.c |  23 ++++++---
>  3 files changed, 129 insertions(+), 48 deletions(-)
> 
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index 15956fa..a0950bc 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -570,74 +570,151 @@ repeat:
>  	return page;
>  }
> 
> +static int __allocate_data_block(struct dnode_of_data *dn)
> +{
> +	struct f2fs_sb_info *sbi = F2FS_SB(dn->inode->i_sb);
> +	struct f2fs_summary sum;
> +	block_t new_blkaddr;
> +	struct node_info ni;
> +	int type;
> +
> +	if (unlikely(is_inode_flag_set(F2FS_I(dn->inode), FI_NO_ALLOC)))
> +		return -EPERM;
> +	if (unlikely(!inc_valid_block_count(sbi, dn->inode, 1)))
> +		return -ENOSPC;
> +
> +	__set_data_blkaddr(dn, NEW_ADDR);
> +	dn->data_blkaddr = NEW_ADDR;
> +
> +	get_node_info(sbi, dn->nid, &ni);
> +	set_summary(&sum, dn->nid, dn->ofs_in_node, ni.version);
> +
> +	type = CURSEG_WARM_DATA;

If so, our cold data will be written to WARM_DATA segment.
How about check segment type here?

> +
> +	allocate_data_block(sbi, NULL, NULL_ADDR, &new_blkaddr, &sum, type);
> +
> +	/* direct IO doesn't use extent cache to maximize the performance */
> +	set_inode_flag(F2FS_I(dn->inode), FI_NO_EXTENT);
> +	update_extent_cache(new_blkaddr, dn);
> +	clear_inode_flag(F2FS_I(dn->inode), FI_NO_EXTENT);
> +
> +	dn->data_blkaddr = new_blkaddr;
> +	return 0;
> +}
> +

[snip]

