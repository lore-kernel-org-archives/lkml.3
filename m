Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbbAWKkM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 05:40:12 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:27479 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbbAWKkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 05:40:10 -0500
X-AuditID: cbfee61a-f79c06d000004e71-b3-54c225086872
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
References: <1421971730-17024-1-git-send-email-jaegeuk@kernel.org>
 <1421971730-17024-2-git-send-email-jaegeuk@kernel.org>
In-reply-to: <1421971730-17024-2-git-send-email-jaegeuk@kernel.org>
Subject: RE: [f2fs-dev] [PATCH 2/2] f2fs: do checkpoint when umount flag is not
	set
Date: Fri, 23 Jan 2015 18:39:25 +0800
Message-id: <000501d036f8$f5e99660$e1bcc320$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQFaMPpnZeb37MLacFcfPEJmggOwHQJG2iWwnadYTxA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t9jAV0O1UMhBvPv8ls8WT+L2eLSIneL
	PXtPslhc3jWHzYHFY9OqTjaP3Qs+M3l83iQXwBzFZZOSmpNZllqkb5fAlXG2ZR1rwQPeihPz
	5zI1MHZwdzFyckgImEgsPb6OHcIWk7hwbz1bFyMXh5DAIkaJxRvaWEESQgI/GCUe//cHsdkE
	VCSWd/xnAikSEehllPhxpp8Zoqha4tThJrBJnALOElvn/gBrFhYIldi9fBlYnEVAVaK5/T5Y
	nFfAUuL8tiYoW1Dix+R7LCA2s4CWxPqdx5kgbHmJzWveMkNcpyCx4+xrRhBbRMAKaO9pqHpx
	iY1HbrFMYBSchWTULCSjZiEZNQtJywJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwSH+
	TGoH48oGi0OMAhyMSjy8DVsOhgixJpYVV+YeYpTgYFYS4Y37AhTiTUmsrEotyo8vKs1JLT7E
	KM3BoiTOq2TfFiIkkJ5YkpqdmlqQWgSTZeLglGpgtLnrN0Hiu9Ye621zZvY6inlI7N6xOs/3
	io48c27BliD7L5r1H3f5HF/7ccL0f/vCd3Tbq834HxLeZdC2oOl/ooHwhQVXltVe6LLV1a+6
	WKBdFGDQWHzb4T9P3ol0/sXfdnIKvkl57qcXULxq69qdd04a7ni3/Fp6U8GiY/ZXzF/F/zrw
	aN2fn0osxRmJhlrMRcWJAIuEaPttAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Friday, January 23, 2015 8:09 AM
> To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Cc: Jaegeuk Kim
> Subject: [f2fs-dev] [PATCH 2/2] f2fs: do checkpoint when umount flag is not set
> 
> If the previous checkpoint was done without CP_UMOUNT flag, it needs to do
> checkpoint with CP_UMOUNT for the next fast boot.
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

Reviewed-by: Chao Yu <chao2.yu@samsung.com>

> ---
>  fs/f2fs/checkpoint.c | 3 ++-
>  fs/f2fs/super.c      | 3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> index 9f5317c..231d8c9 100644
> --- a/fs/f2fs/checkpoint.c
> +++ b/fs/f2fs/checkpoint.c
> @@ -1043,7 +1043,8 @@ void write_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc)
> 
>  	mutex_lock(&sbi->cp_mutex);
> 
> -	if (!sbi->s_dirty && cpc->reason != CP_DISCARD)
> +	if (!sbi->s_dirty &&
> +			cpc->reason != CP_DISCARD && cpc->reason != CP_UMOUNT)
>  		goto out;
>  	if (unlikely(f2fs_cp_error(sbi)))
>  		goto out;
> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> index 84f95cd..6ef1458 100644
> --- a/fs/f2fs/super.c
> +++ b/fs/f2fs/super.c
> @@ -448,7 +448,8 @@ static void f2fs_put_super(struct super_block *sb)
>  	stop_gc_thread(sbi);
> 
>  	/* We don't need to do checkpoint when it's clean */

Better to update the annotation above.

Thanks,
Yu

> -	if (sbi->s_dirty) {
> +	if (sbi->s_dirty ||
> +			!is_set_ckpt_flags(F2FS_CKPT(sbi), CP_UMOUNT_FLAG)) {
>  		struct cp_control cpc = {
>  			.reason = CP_UMOUNT,
>  		};
> --
> 2.1.1
> 

