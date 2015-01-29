Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbbA2Mjn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 07:39:43 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:46113 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbbA2Mjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 07:39:41 -0500
X-AuditID: cbfee61a-f79c06d000004e71-3b-54ca2a0b8e9b
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
References: <1422401503-4769-1-git-send-email-jaegeuk@kernel.org>
 <1422401503-4769-5-git-send-email-jaegeuk@kernel.org>
In-reply-to: <1422401503-4769-5-git-send-email-jaegeuk@kernel.org>
Subject: RE: [PATCH 5/5] f2fs: introduce a batched trim
Date: Thu, 29 Jan 2015 20:38:30 +0800
Message-id: <003b01d03bc0$a5f23d20$f1d6b760$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQKDs63B3JtDSVeEmIqjDxgyUQN23AKL4RA4m1u1E3A=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t9jAV1urVMhBhevyFs8WT+L2eLSIneL
	PXtPslhc3jWHzYHFY9OqTjaP3Qs+M3l83iQXwBzFZZOSmpNZllqkb5fAlXFlzQ32gnXCFa1T
	jrI1MN7h72Lk5JAQMJG4cOIzM4QtJnHh3nq2LkYuDiGBRYwSnT8XsEI4Pxgl9h+YzQZSxSag
	IrG84z8TSEJEoJdR4seZfrB2IYFKiQtbH4PZnAJOEpOa+1lBbGEBc4nlq58zgdgsAqoSfcdm
	sIDYvAKWEheb1zND2IISPybfA4szC2hJrN95nAnClpfYvOYt1HkKEjvOvmYEsUUErCTOnr0A
	VS8usfHILZYJjIKzkIyahWTULCSjZiFpWcDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMj
	OMifSe1gXNlgcYhRgINRiYeXo/5kiBBrYllxZe4hRgkOZiUR3kKlUyFCvCmJlVWpRfnxRaU5
	qcWHGKU5WJTEeZXs20KEBNITS1KzU1MLUotgskwcnFINjGvXHz+q/iimf3vJuZPXfr1O5S9c
	s/Qns73MB+X/LTYnxBU2BnmLs944GzTxa7xhskykTIrYUr0vCclzQypSvmz6MH/D1p7FjIsO
	ZVw5mCevp7hw4dWXFv83aTNPs+8/qlyRcSv41aoTeZ7tc1q5zZz+Obx+JJB1ln/1pJeZaZsa
	v53zmz5r/g8lluKMREMt5qLiRACbwPZ4bgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

> -----Original Message-----
> From: linux-fsdevel-owner@vger.kernel.org [mailto:linux-fsdevel-owner@vger.kernel.org] On
> Behalf Of Jaegeuk Kim
> Sent: Wednesday, January 28, 2015 7:32 AM
> To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Cc: Jaegeuk Kim
> Subject: [PATCH 5/5] f2fs: introduce a batched trim
> 
> This patch introduces a batched trimming feature, which submits split discard
> commands.

I didn't get it, why we should split discard commands. :(

Does smaller discarding for flash shows better performance or effect or safety?
Can you please explain more about this patch?

Thanks,

> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>  fs/f2fs/f2fs.h    |  1 +
>  fs/f2fs/segment.c | 15 ++++++++++-----
>  2 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index c0b83d6..ec4d16b 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -104,6 +104,7 @@ enum {
>  	CP_DISCARD,
>  };
> 
> +#define BATCHED_TRIM_SEGMENTS	10
>  struct cp_control {
>  	int reason;
>  	__u64 trim_start;
> diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> index 31c4e57..6c9c784 100644
> --- a/fs/f2fs/segment.c
> +++ b/fs/f2fs/segment.c
> @@ -1066,14 +1066,19 @@ int f2fs_trim_fs(struct f2fs_sb_info *sbi, struct fstrim_range *range)
>  	end_segno = (end >= MAX_BLKADDR(sbi)) ? MAIN_SEGS(sbi) - 1 :
>  						GET_SEGNO(sbi, end);
>  	cpc.reason = CP_DISCARD;
> -	cpc.trim_start = start_segno;
> -	cpc.trim_end = end_segno;
>  	cpc.trim_minlen = range->minlen >> sbi->log_blocksize;
> 
>  	/* do checkpoint to issue discard commands safely */
> -	mutex_lock(&sbi->gc_mutex);
> -	write_checkpoint(sbi, &cpc);
> -	mutex_unlock(&sbi->gc_mutex);
> +	for (; start_segno <= end_segno;
> +				start_segno += BATCHED_TRIM_SEGMENTS + 1) {
> +		cpc.trim_start = start_segno;
> +		cpc.trim_end = min_t(unsigned int,
> +				start_segno + BATCHED_TRIM_SEGMENTS, end_segno);
> +
> +		mutex_lock(&sbi->gc_mutex);
> +		write_checkpoint(sbi, &cpc);
> +		mutex_unlock(&sbi->gc_mutex);
> +	}
>  out:
>  	range->len = cpc.trimmed << sbi->log_blocksize;
>  	return 0;
> --
> 2.1.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

