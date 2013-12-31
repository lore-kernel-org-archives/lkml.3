Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902Ab3LaGJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 01:09:29 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:53797 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab3LaGJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 01:09:28 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-a4-52c25f910863
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <1388116820-15038-1-git-send-email-jaegeuk.kim@samsung.com>
 <1388116820-15038-2-git-send-email-jaegeuk.kim@samsung.com>
In-reply-to: <1388116820-15038-2-git-send-email-jaegeuk.kim@samsung.com>
Subject: RE: [f2fs-dev] [PATCH 2/6] f2fs: convert inline_data for punch_hole
Date: Tue, 31 Dec 2013 14:08:24 +0800
Message-id: <000001cf05ee$d8bd8c90$8a38a5b0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJ5cIHO6QcnOR0DoAizVAhm3+hYigFSE4MfmQ5owzA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9jQd2J8YeCDM5OF7G4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+Nw307WggbRiil7
	DzI2MC4U7GLk5JAQMJH4/ugLI4QtJnHh3nq2LkYuDiGB6YwSz+/PYIFwfjBKzD29iQ2kik1A
	RWJ5x38mEFtEQFvi59xWdhCbWSBTYs7ryawQDa2MEn8XzwYr4hTwkFj6dTKQzcEhLOAjMeN6
	NkiYRUBVomF1L9hMXgFLiTNH1rNA2IISPybfY4GYqSWxfudxJghbXmLzmrfMEJcqSOw4+5oR
	ZKSIgJXE1sslECXiEhuP3GKZwCg0C8mkWUgmzUIyaRaSlgWMLKsYRVMLkguKk9JzDfWKE3OL
	S/PS9ZLzczcxggP/mdQOxpUNFocYBTgYlXh4bxocChJiTSwrrsw9xCjBwawkwtt492CQEG9K
	YmVValF+fFFpTmrxIUZpDhYlcd4DrdaBQgLpiSWp2ampBalFMFkmDk6pBkbXmS+CKhZH3ton
	3LwttrWq8AvP4vZH5nnf/inKqxTG3Y7e0mz0Zm2J1wM54VMc7dfPrrllIPFnmuCWX2U8E2+1
	H3jrteJsXNbxyTHzd7MH8fjOTdq6LTzVbFV05+qGRzX9j6I+l55b9OjU+clyz7dnfVdYGzVX
	b7N8xqU6n7t82zZsZl2VLhSoxFKckWioxVxUnAgAwTxIIHgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

One comment as following.

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Friday, December 27, 2013 12:00 PM
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net
> Subject: [f2fs-dev] [PATCH 2/6] f2fs: convert inline_data for punch_hole
> 
> In the punch_hole(), let's convert inline_data all the time for simplicity and
> to avoid potential deadlock conditions.
> It is pretty much not a big deal to do this.
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>

Reviewed-by: Chao Yu <chao2.yu@samsung.com>

> ---
>  fs/f2fs/file.c | 22 +++-------------------
>  1 file changed, 3 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> index 7ef2d6a..f64a1c8 100644
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -462,25 +462,9 @@ static int punch_hole(struct inode *inode, loff_t offset, loff_t len)
>  	loff_t off_start, off_end;
>  	int ret = 0;
> 
> -	if (f2fs_has_inline_data(inode)) {
> -		struct page *page;
> -		unsigned flags = AOP_FLAG_NOFS;
> -		page = grab_cache_page_write_begin(inode->i_mapping, 0, flags);
> -		if (IS_ERR(page))
> -			return PTR_ERR(page);

We use following code because grab_cache_page_write_begin only use
NULL value as its error number.

	if (!page)
		return -ENOMEM;

> -		if (offset + len > MAX_INLINE_DATA) {
> -			ret = f2fs_convert_inline_data(inode, page, flags);
> -			f2fs_put_page(page, 1);
> -			if (ret)
> -				return ret;
> -		} else {
> -			zero_user_segment(page, offset, offset + len);
> -			SetPageUptodate(page);
> -			set_page_dirty(page);
> -			f2fs_put_page(page, 1);
> -			return ret;
> -		}
> -	}
> +	ret = f2fs_convert_inline_data(inode, NULL, AOP_FLAG_NOFS);
> +	if (ret)
> +		return ret;
> 
>  	pg_start = ((unsigned long long) offset) >> PAGE_CACHE_SHIFT;
>  	pg_end = ((unsigned long long) offset + len) >> PAGE_CACHE_SHIFT;
> --
> 1.8.4.474.g128a96c
> 
> 
> ------------------------------------------------------------------------------
> Rapidly troubleshoot problems before they affect your business. Most IT
> organizations don't have a clear picture of how application performance
> affects their revenue. With AppDynamics, you get 100% visibility into your
> Java,.NET, & PHP application. Start your 15-day FREE TRIAL of AppDynamics Pro!
> http://pubads.g.doubleclick.net/gampad/clk?id=84349831&iu=/4140/ostg.clktrk
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

