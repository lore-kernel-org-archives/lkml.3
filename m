Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbaLHJaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 04:30:46 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:57327 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbaLHJao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 04:30:44 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-b2-54856fc29ec5
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <1417895739-15251-1-git-send-email-jaegeuk@kernel.org>
In-reply-to: <1417895739-15251-1-git-send-email-jaegeuk@kernel.org>
Subject: RE: [f2fs-dev] [PATCH 1/5] f2fs: do retry operations with cond_resched
Date: Mon, 08 Dec 2014 17:29:53 +0800
Message-id: <002101d012c9$a1d85460$e588fd20$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQLvW05wsiThI6k/gcI9n6vG0STI9JpG2cNg
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9jQd1D+a0hBmdWi1g8WT+L2eLSIneL
	PXtPslhc3jWHzYHFY9OqTjaP3Qs+M3l83iQXwBzFZZOSmpNZllqkb5fAlXHqZitjwQ7+ipP3
	/zA1MO7j6WLk4JAQMJG4vZmri5ETyBSTuHBvPVsXIxeHkMB0RoklDTcZIZwfjBLH1r1lAqli
	E1CRWN7xH8wWEVCT6N03BcxmFsiUmND/gh3EFhJwkpi7ZQ4LiM0p4Cyx/9UEsBphAX+J/6ev
	g9WwCKhKPJkxjQnkCF4BS4npF71BwrwCghI/Jt9jgRipJbF5WxMrhC0vsXnNW2aIQxUkdpx9
	zQhxgpHE0UW72CBqxCU2HrnFMoFRaBaSUbOQjJqFZNQsJC0LGFlWMYqmFiQXFCel5xrpFSfm
	Fpfmpesl5+duYgSH/TPpHYyrGiwOMQpwMCrx8C580BIixJpYVlyZe4hRgoNZSYQ3Ma41RIg3
	JbGyKrUoP76oNCe1+BCjNAeLkjjvjZu5IUIC6YklqdmpqQWpRTBZJg5OqQZG5r+LjlRby8fO
	uhvTzCrqtvu5SGN4lnyMrublDzEfpm69rM/3NiWUTVR3KruEnqBBp1vVtNhvc7MbdZTc5tSf
	kO28NGX5xcrl/Q2uz5h3JP0IV6nL+140/fG3sBRvp02Ppl9/os75ZPvKa7ZT/WVSnmgXNt9q
	7tJ6L7Cs5fJM02d7LiaU9zopsRRnJBpqMRcVJwIACkyRzncCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Sunday, December 07, 2014 3:56 AM
> To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Cc: Jaegeuk Kim
> Subject: [f2fs-dev] [PATCH 1/5] f2fs: do retry operations with cond_resched
> 
> This patch revists retrial paths in f2fs.
> The basic idea is to use cond_resched instead of retrying from the very early
> stage.
> 
> Suggested-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

Reviewed-by: Chao Yu <chao2.yu@samsung.com>

> ---
>  fs/f2fs/f2fs.h    |  7 +++++++
>  fs/f2fs/gc.c      |  5 ++---
>  fs/f2fs/node.c    | 41 +++++++++--------------------------------
>  fs/f2fs/segment.c |  5 ++---
>  4 files changed, 20 insertions(+), 38 deletions(-)
> 
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index c873140..c787fe3 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -1021,6 +1021,13 @@ retry:
>  	return entry;
>  }
> 
> +static inline void f2fs_radix_tree_insert(struct radix_tree_root *root,
> +				unsigned long index, void *item)
> +{
> +	while (radix_tree_insert(root, index, item))
> +		cond_resched();
> +}
> +
>  #define RAW_IS_INODE(p)	((p)->footer.nid == (p)->footer.ino)
> 
>  static inline bool IS_INODE(struct page *page)
> diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
> index 2c58c58..eec0933 100644
> --- a/fs/f2fs/gc.c
> +++ b/fs/f2fs/gc.c
> @@ -356,12 +356,11 @@ static void add_gc_inode(struct gc_inode_list *gc_list, struct inode
> *inode)
>  		iput(inode);
>  		return;
>  	}
> -retry:
>  	new_ie = f2fs_kmem_cache_alloc(winode_slab, GFP_NOFS);
>  	new_ie->inode = inode;
> -
> +retry:
>  	if (radix_tree_insert(&gc_list->iroot, inode->i_ino, new_ie)) {
> -		kmem_cache_free(winode_slab, new_ie);
> +		cond_resched();
>  		goto retry;
>  	}

use f2fs_radix_tree_insert instead?

Thanks,
Yu

