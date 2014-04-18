Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666AbaDRDST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 23:18:19 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:32008 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaDRDSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 23:18:16 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-60-5350997654fa
From: Chao Yu <chao2.yu@samsung.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <000101cf5a1e$5c051770$140f4650$@samsung.com>
 <1397787344.7727.32.camel@kjgkr>
In-reply-to: <1397787344.7727.32.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH] f2fs: fix to enable readahead last NAT block
Date: Fri, 18 Apr 2014 11:17:16 +0800
Message-id: <000901cf5ab4$d64171a0$82c454e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJ+B5VCbaafyLSB4DaGccbOc89jYQGozRZ8mawFQ1A=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9jAd2ymQHBBu+2m1tc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlTFp0RfGgovCFY3N
	W5gbGF/ydzFyckgImEhcefONFcIWk7hwbz1bFyMXh5DAIkaJH3OXsUA4Pxglft3oBKtiE1CR
	WN7xnwnEFhGQlpj1aR4LiM0skClxr2kGcxcjB1BDjMSTCeogYU4BXYl3328zg9jCAj4Sv9pm
	gZWzCKhKTJm8FMzmFbCUuL/8DJQtKPFj8j2okeoSk+YtYoaw5SU2r3nLDHGogsSOs68ZIU6w
	kpjdtpoJokZcYuORWywTGIVmIRk1C8moWUhGzULSsoCRZRWjaGpBckFxUnqukV5xYm5xaV66
	XnJ+7iZGcOA/k97BuKrB4hCjAAejEg/vha/+wUKsiWXFlbmHGCU4mJVEeJVLA4KFeFMSK6tS
	i/Lji0pzUosPMUpzsCiJ8x5stQ4UEkhPLEnNTk0tSC2CyTJxcEo1MLreCgj7sZhD9WR62lqN
	VQXL6htcLQIPfLt51ZsrfMLbuAsJjGUlm7jW+0Qkz1R//PvMyraSmApP/pwtx3/fX1OjyrH4
	XaP2Sn6L+D3qas5ZT1fGC2mYHbPujxav7Jwy58O+ewoXqxu1Altrzul26voZ9YttOhre4jVT
	aubj6/vLrl3868B0VImlOCPRUIu5qDgRAAt81fF4AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Friday, April 18, 2014 10:16 AM
> To: Chao Yu
> Cc: linux-f2fs-devel@lists.sourceforge.net; linux-fsdevel@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [f2fs-dev] [PATCH] f2fs: fix to enable readahead last NAT block
> 
> Hi Chao,
> 
> How about this?

This modification can really fix the previously deadloop problem without bringing
more problem. I'd like use your patch.
Thanks.

One comment as following.

Reviewed-by: Chao Yu <chao2.yu@samsung.com>

> 
> ---
>  fs/f2fs/f2fs.h | 1 +
>  fs/f2fs/node.c | 6 ++++--
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 55152de..556d06b 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -244,6 +244,7 @@ static inline void set_raw_extent(struct extent_info
> *ext,
>  struct f2fs_nm_info {
>  	block_t nat_blkaddr;		/* base disk address of NAT */
>  	nid_t max_nid;			/* maximum possible node ids */
> +	nid_t available_nids;		/* maximum available node ids */
>  	nid_t next_scan_nid;		/* the next nid to be scanned */
>  	unsigned int ram_thresh;	/* control the memory footprint */
> 
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index 837f5fd..5fb484c 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -1447,7 +1447,7 @@ bool alloc_nid(struct f2fs_sb_info *sbi, nid_t
> *nid)
>  	struct f2fs_nm_info *nm_i = NM_I(sbi);
>  	struct free_nid *i = NULL;
>  retry:
> -	if (unlikely(sbi->total_valid_node_count + 1 >= nm_i->max_nid))
> +	if (unlikely(sbi->total_valid_node_count + 1 >= nm_i->available_nids))

Could we use the last valid nid and modify like this?

	if (unlikely(sbi->total_valid_node_count + 1 > nm_i->available_nids))

>  		return false;
> 
>  	spin_lock(&nm_i->free_nid_list_lock);
> @@ -1859,8 +1859,10 @@ static int init_node_manager(struct f2fs_sb_info
> *sbi)
>  	nat_segs = le32_to_cpu(sb_raw->segment_count_nat) >> 1;
>  	nat_blocks = nat_segs << le32_to_cpu(sb_raw->log_blocks_per_seg);
> 
> +	nm_i->max_nid = NAT_ENTRY_PER_BLOCK * nat_blocks;
> +
>  	/* not used nids: 0, node, meta, (and root counted as valid node) */
> -	nm_i->max_nid = NAT_ENTRY_PER_BLOCK * nat_blocks - 3;
> +	nm_i->available_nids = nm_i->max_nid - 3;
>  	nm_i->fcnt = 0;
>  	nm_i->nat_cnt = 0;
>  	nm_i->ram_thresh = DEF_RAM_THRESHOLD;
> --
> 1.8.4.474.g128a96c
> 
> 
> --
> Jaegeuk Kim
> Samsung

