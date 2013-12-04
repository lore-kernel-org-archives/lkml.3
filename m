Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab3LDGB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 01:01:58 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:47105 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572Ab3LDGB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 01:01:56 -0500
X-AuditID: cbfee61b-b7f006d000003e1f-00-529ec5539d7a
From: Chao Yu <chao2.yu@samsung.com>
To: jaegeuk.kim@samsung.com
Cc: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org,
        =?gb2312?B?zLfmrQ==?= <shu.tan@samsung.com>
References: <1385792739-31405-1-git-send-email-jaegeuk.kim@samsung.com>
 <1385972847.2417.113.camel@kjgkr>
In-reply-to: <1385972847.2417.113.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH v2] f2fs: refactor bio-related operations
Date: Wed, 04 Dec 2013 14:01:05 +0800
Message-id: <001101cef0b6$562766e0$027634a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGw7XbXFfvWzLj+WigF+tBDCO33/AJ1cP7KmmvawzA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t9jQd3go/OCDJovS1hc3/WXyeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aP3Qs+M3n0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXxvHNt1gK
	lglVrLm/hLmB8RRfFyMnh4SAicTB04dZIWwxiQv31rN1MXJxCAlMZ5R49XQ6C4Tzg1FiWvsN
	dpAqNgEVieUd/5lAbBEBaYlZn+aBFTELTGOUWDr5AFCCA6gjW+LIa3WQGk4BPYmpd16wgdjC
	Ah4SM6/0M4LYLAKqEgcezgSbwytgKbHo0nRWCFtQ4sfkeywgNrOAhkT/og1sELa8xOY1b5kh
	LlWQ2HH2NSPEDVYSe869ZIWoEZfYeOQWywRGoVlIRs1CMmoWklGzkLQsYGRZxSiaWpBcUJyU
	nmukV5yYW1yal66XnJ+7iREcBc+kdzCuarA4xCjAwajEw5vAOS9IiDWxrLgy9xCjBAezkgiv
	TRlQiDclsbIqtSg/vqg0J7X4EKM0B4uSOO/BVutAIYH0xJLU7NTUgtQimCwTB6dUA2Pcm4lq
	Xv/bHUqn8F6+/cX8dLP3xQmMcwMZZz1tEru+9ME7tSs+qQX2IVe9Gub93r9h0rapNR7tjrU/
	HmR/5363Z7/3qvM3ZmQHM8uvnBRx3j3gFe/RNJYLi1cd2862+unjJQuaHC6vfnA64U5T2Cxh
	4TM7TsWkdPcLrA98oOmz7/s+x1uxB0/qK7EUZyQaajEXFScCAFL5DS1+AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Comment as following.

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Monday, December 02, 2013 4:27 PM
> To: linux-fsdevel@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net
> Subject: Re: [f2fs-dev] [PATCH v2] f2fs: refactor bio-related operations
> 
> Change log from v1:
>  o remove redundant codes
> 
> >From a480dfc915490f4bca7275f6fbb44fa34aa00eaa Mon Sep 17 00:00:00 2001
> From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> Date: Sat, 30 Nov 2013 12:51:14 +0900
> Subject: [PATCH] f2fs: refactor bio-related operations
> Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
> 
> This patch integrates redundant bio operations on read and write IOs.
> 
> 1. Move bio-related codes to the top of data.c.
> 2. Replace f2fs_submit_bio with f2fs_submit_merged_bio, which handles read
>    bios additionally.
> 3. Introduce __submit_merged_bio to submit the merged bio.
> 4. Change f2fs_readpage to f2fs_submit_page_bio.
> 5. Introduce f2fs_submit_page_mbio to integrate previous submit_read_page and
>    submit_write_page.

[snip]

> +static void __submit_merged_bio(struct f2fs_sb_info *sbi,
> +				struct f2fs_bio_info *io,
> +				enum page_type type, bool sync, int rw)
> +{
> +	enum page_type btype = PAGE_TYPE_OF_BIO(type);
> +
> +	if (!io->bio)
> +		return;
> +
> +	if (btype == META)
> +		rw |= REQ_META;
> +
> +	if (is_read_io(rw)) {
> +		if (sync)
> +			rw |= READ_SYNC;
> +		submit_bio(rw, io->bio);
> +		trace_f2fs_submit_read_bio(sbi->sb, rw, type, io->bio);
> +		io->bio = NULL;
> +		return;
> +	}
> +
> +	if (sync)
> +		rw |= WRITE_SYNC;

rw = WRITE_SYNC; ?

> +	if (type >= META_FLUSH)
> +		rw |= WRITE_FLUSH_FUA;

rw = WRITE_FLUSH_FUA; ?

> +
> +	/*
> +	 * META_FLUSH is only from the checkpoint procedure, and we should wait
> +	 * this metadata bio for FS consistency.
> +	 */
> +	if (type == META_FLUSH) {
> +		DECLARE_COMPLETION_ONSTACK(wait);
> +		io->bio->bi_private = &wait;
> +		submit_bio(rw, io->bio);
> +		wait_for_completion(&wait);
> +	} else {
> +		submit_bio(rw, io->bio);
> +	}
> +	trace_f2fs_submit_write_bio(sbi->sb, rw, btype, io->bio);
> +	io->bio = NULL;
> +}

[snip]

Thanks,
Yu

