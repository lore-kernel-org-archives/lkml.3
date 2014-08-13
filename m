Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258AbaHMKUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 06:20:33 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:31645 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaHMKUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 06:20:32 -0400
X-AuditID: cbfee61b-f79f86d00000144c-db-53eb3bee748d
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <1407872967-26423-1-git-send-email-jaegeuk@kernel.org>
 <1407872967-26423-5-git-send-email-jaegeuk@kernel.org>
In-reply-to: <1407872967-26423-5-git-send-email-jaegeuk@kernel.org>
Subject: RE: [f2fs-dev] [PATCH 05/13] f2fs: should clear the inline_xattr flag
Date: Wed, 13 Aug 2014 18:19:28 +0800
Message-id: <009d01cfb6e0$3489cf50$9d9d6df0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQG4wP7f0RrIWMfJUczB9r86/XcZWwCnJ3Nlm/cEoWA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9jQd131q+DDbqW61s8WT+L2eLSIneL
	PXtPslhc3jWHzYHFY9OqTjaP3Qs+M3l83iQXwBzFZZOSmpNZllqkb5fAlfFvzTzWgiv8Fe9P
	6zUw/uTpYuTkkBAwkfh+7y0rhC0mceHeerYuRi4OIYHpjBKf98xhhXB+MErsm/KLGaSKTUBF
	YnnHfyYQW0RATaJ33xQwm1kgU2JC/wt2EFtIoFri0LsdYDangLPEkt3HwXqFBfwkNu79CBZn
	EVCVaN+wHizOK2Ap8WjraRYIW1Dix+R7LBAztSTW7zwONV9eYvOat8wQlypI7Dj7mhHiBiuJ
	W/N2QNWIS2w8cotlAqPQLCSjZiEZNQvJqFlIWhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L10vO
	z93ECA78Z9I7GFc1WBxiFOBgVOLh3eH6KliINbGsuDL3EKMEB7OSCO8ao9fBQrwpiZVVqUX5
	8UWlOanFhxilOViUxHkPtloHCgmkJ5akZqemFqQWwWSZODilGhgTX+s/flK/OyWiIsTpsmJx
	0e30AJbYSd4d+/ve2HzJm9i3xVDI4Vb5z617P+kcNivfV/ks7IX8JmUvttL9zfe83Q4Jtr7s
	f3T5keCbZ6fifx0/+LLW9em71ro7s8P2H1uqvSv6q7lMcqqj/K/5ykz2k6OXiax67b3467om
	jxV+NrIdO/zKPZ4psRRnJBpqMRcVJwIACvCDjngCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Wednesday, August 13, 2014 3:49 AM
> To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Cc: Jaegeuk Kim
> Subject: [f2fs-dev] [PATCH 05/13] f2fs: should clear the inline_xattr flag
> 
> During the recovery, we should clear the inline_xattr flag if its xattr node
> block is recovered.
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

Reviewed-by: Chao Yu <chao2.yu@samsung.com>

> ---
>  fs/f2fs/node.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index 093d799..151045f 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -1557,26 +1557,25 @@ void recover_inline_xattr(struct inode *inode, struct page *page)
>  	struct page *ipage;
>  	struct f2fs_inode *ri;
> 
> -	if (!f2fs_has_inline_xattr(inode))
> -		return;
> -
>  	if (!IS_INODE(page))
>  		return;
> 
> -	ri = F2FS_INODE(page);
> -	if (!(ri->i_inline & F2FS_INLINE_XATTR))
> -		return;
> -
>  	ipage = get_node_page(sbi, inode->i_ino);
>  	f2fs_bug_on(IS_ERR(ipage));
> 
> +	ri = F2FS_INODE(page);
> +	if (!(ri->i_inline & F2FS_INLINE_XATTR)) {
> +		clear_inode_flag(F2FS_I(inode), FI_INLINE_XATTR);
> +		goto update_inode;
> +	}
> +
>  	dst_addr = inline_xattr_addr(ipage);
>  	src_addr = inline_xattr_addr(page);
>  	inline_size = inline_xattr_size(inode);
> 
>  	f2fs_wait_on_page_writeback(ipage, NODE);
>  	memcpy(dst_addr, src_addr, inline_size);
> -
> +update_inode:
>  	update_inode(inode, ipage);
>  	f2fs_put_page(ipage, 1);
>  }
> --
> 1.8.5.2 (Apple Git-48)
> 
> 
> ------------------------------------------------------------------------------
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

