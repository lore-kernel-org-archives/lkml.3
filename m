Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626AbaKRFcD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 00:32:03 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:45892 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbaKRFcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 00:32:01 -0500
X-AuditID: cbfee61a-f79c06d000004e71-87-546ad9cef7b9
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
References: <1416275874-74186-1-git-send-email-jaegeuk@kernel.org>
 <1416275874-74186-2-git-send-email-jaegeuk@kernel.org>
In-reply-to: <1416275874-74186-2-git-send-email-jaegeuk@kernel.org>
Subject: RE: [f2fs-dev] [PATCH 2/2] f2fs: put the inode page when error was
	occurred
Date: Tue, 18 Nov 2014 13:30:46 +0800
Message-id: <006b01d002f0$f6da1b80$e48e5280$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHZW/gja68DRPNNXXI/+0pWUwbvuQHXm/0dnERrtsA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsVy+t9jQd1zN7NCDK4dNrd4sn4Ws8WlRe4W
	e/aeZLG4vGsOmwOLx6ZVnWweuxd8ZvL4vEkugDmKyyYlNSezLLVI3y6BK+Po/83sBc3CFUtf
	9bE3MM7k72Lk5JAQMJG4vvgQG4QtJnHh3nogm4tDSGA6o8SP3kWsIAkhgR+MEnMvFYLYbAIq
	Ess7/jOBFIkI9AIVnelnhiiqlpjx8BkLiM0p4CzxYvc7sGZhgTCJf/svgtksAqoSxz62gNm8
	ApYSW480QdmCEj8m3wPrZRbQkli/8zgThC0vsXnNW2aI6xQkdpx9zdjFyAG02Epi3jtRiBJx
	iY1HbrFMYBSchWTSLCSTZiGZNAtJywJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwQH+
	TGoH48oGi0OMAhyMSjy8CVOzQoRYE8uKK3MPMUpwMCuJ8J7rBgrxpiRWVqUW5ccXleakFh9i
	lOZgURLnPdBqHSgkkJ5YkpqdmlqQWgSTZeLglGpgXLevxY/5zOFZtSs271m1o3SZlEKjc9P7
	X4HsJSs/H50tci2No3rPnV+3j/BO5Jx5KmH2hWuL7657wzRzp/66cwFP5k1c9qnpHqNmw8+Y
	x3K9O1/nGkyZ0newQsBLfeeUuzGT1ktu8It8zbdKQiS3Ybf/x73Hq55+vrqpxLBfNCZ3rePm
	edwLhA8qsRRnJBpqMRcVJwIAmesgS2wCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Tuesday, November 18, 2014 9:58 AM
> To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Cc: Jaegeuk Kim
> Subject: [f2fs-dev] [PATCH 2/2] f2fs: put the inode page when error was occurred
> 
> We should put the inode page when error was occurred.
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

You can add Reviewed-by: Chao Yu <chao2.yu@samsung.com>
after the following issue is fixed.

> ---
>  fs/f2fs/data.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index 8f16443..12dd58a 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -963,22 +963,22 @@ repeat:
>  		} else if (page->index == 0) {
>  			err = f2fs_convert_inline_page(&dn, page);
>  			if (err)
> -				goto unlock_fail;
> +				goto put_fail;
>  		} else {
>  			struct page *p = grab_cache_page(inode->i_mapping, 0);
>  			if (!p) {
>  				err = -ENOMEM;
> -				goto unlock_fail;
> +				goto put_fail;
>  			}
>  			err = f2fs_convert_inline_page(&dn, p);
>  			f2fs_put_page(p, 1);
>  			if (err)
> -				goto unlock_fail;
> +				goto put_fail;
>  		}
>  	}
>  	err = f2fs_reserve_block(&dn, index);
>  	if (err)
> -		goto unlock_fail;
> +		goto put_fail;

f2fs_reserve_block will do the clean work, we should not release dn again.

Thanks,
Yu

>  put_next:
>  	f2fs_put_dnode(&dn);
>  	f2fs_unlock_op(sbi);
> @@ -1021,6 +1021,8 @@ out:
>  	clear_cold_data(page);
>  	return 0;
> 
> +put_fail:
> +	f2fs_put_dnode(&dn);
>  unlock_fail:
>  	f2fs_unlock_op(sbi);
>  	f2fs_put_page(page, 1);
> --
> 2.1.1
> 
> 
> ------------------------------------------------------------------------------
> Download BIRT iHub F-Type - The Free Enterprise-Grade BIRT Server
> from Actuate! Instantly Supercharge Your Business Reports and Dashboards
> with Interactivity, Sharing, Native Excel Exports, App Integration & more
> Get technology previously reserved for billion-dollar corporations, FREE
> http://pubads.g.doubleclick.net/gampad/clk?id=157005751&iu=/4140/ostg.clktrk
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

