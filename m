Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab3LSBNK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 20:13:10 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:34027 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab3LSBNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 20:13:08 -0500
X-AuditID: cbfee61b-b7fbf6d0000051a3-e3-52b24822f10e
From: Chao Yu <chao2.yu@samsung.com>
To: jaegeuk.kim@samsung.com
Cc: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org
References: <1387244992-7038-1-git-send-email-jaegeuk.kim@samsung.com>
 <1387325521.2101.212.camel@kjgkr>
In-reply-to: <1387325521.2101.212.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH] f2fs: introduce a new direct_IO write path
Date: Thu, 19 Dec 2013 09:12:16 +0800
Message-id: <000901cefc57$775a6450$660f2cf0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIuN7ZoSJWXSWJORHKD4kLFTtrs2wIHyjEvmYv+g8A=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9jAV1lj01BBisb2S2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgymg5NYuxYIpgxa1d
	2xkbGL/ydjFyckgImEhsWdvCAmGLSVy4t56ti5GLQ0hgEaPE5b2N7BDOD0aJh0c/s4FUsQmo
	SCzv+M8EYosISEvM+jQPqJuDg1kgU+L84USQsJBAlsSapRvBhnIK6El87z/KBlIiLOAl0fet
	GCTMIqAqcezvNlYQm1fAUuL+tbeMELagxI/J98BamQW0JNbvPM4EYctLbF7zlhniTgWJHWdf
	M0JcYCWx7cwTNogacYmNR26xTGAUmoVk1Cwko2YhGTULScsCRpZVjKKpBckFxUnpuUZ6xYm5
	xaV56XrJ+bmbGMFh/0x6B+OqBotDjAIcjEo8vAHPNwYJsSaWFVfmHmKU4GBWEuG9wrIpSIg3
	JbGyKrUoP76oNCe1+BCjNAeLkjjvwVbrQCGB9MSS1OzU1ILUIpgsEwenVANjh32cxaQtPo9Z
	PPu0GOdqO1yf8608y6itWL02LO92g9zvZRJPtJ3708zsrK5OqDd7uTOpoFgmalWRPHctc9Xs
	ydcn9dVunXaf99y+w2LTnszkVT+bc/bllwBbhmd3rD1b/PZohp4K27frXuVq4417Z6/Ib9z1
	o6ZNY23Y2Vs2eS/OtPAwH5yrxFKckWioxVxUnAgAXYRJ2HcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Looks Nice!

> 
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>

Reviewed-by: Chao Yu <chao2.yu@samsung.com>

> +
> +	end_offset = IS_INODE(dn.node_page) ?
> +			ADDRS_PER_INODE(F2FS_I(inode)) : ADDRS_PER_BLOCK;
> +	bh_result->b_size = (((size_t)1) << blkbits);
> +	dn.ofs_in_node++;
> +	pgofs++;
> +
> +get_next:
> +	if (dn.ofs_in_node >= end_offset) {
> +		if (allocated)
> +			sync_inode_page(&dn);
> +		allocated = false;

		if (allocated) {
			sync_inode_page(&dn);
			allocated = false;
		}
Certainly, it's really not a big deal. :)

Thanks

