Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab3LBEsQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 23:48:16 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:28412 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab3LBEsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 23:48:12 -0500
X-AuditID: cbfee61a-b7f316d000007e34-45-529c1105757c
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?gb2312?B?zLfmrQ==?= <shu.tan@samsung.com>
References: <1385792739-31405-1-git-send-email-jaegeuk.kim@samsung.com>
In-reply-to: <1385792739-31405-1-git-send-email-jaegeuk.kim@samsung.com>
Subject: RE: [f2fs-dev] [PATCH] f2fs: refactor bio-related operations
Date: Mon, 02 Dec 2013 12:47:11 +0800
Message-id: <000101ceef19$ae149b50$0a3dd1f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGw7XbXFfvWzLj+WigF+tBDCO33/Jp8VKzQ
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t9jAV1WwTlBBjtP6Vpc3/WXyeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aP3Qs+M3n0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXxoQZUQVf
	RCtanu5laWD8INjFyMkhIWAicX/9KhYIW0ziwr31bF2MXBxCAosYJY43fGWGcH4wSrzr72YG
	qWITUJFY3vGfCcQWEdCW+Dm3lR2kiFlgBqPE4bn/WEESQgLuEjNm/WADsTkFPCSmNR0FaxAW
	cJXoefaZHcRmEVCVeHP4AVg9r4ClxOTOFhYIW1Dix+R7YDazgIZE/6INbBC2vMTmNW+ZIU5V
	kNhx9jUjxBFGEh/eLmKEqBGX2HjkFssERqFZSEbNQjJqFpJRs5C0LGBkWcUomlqQXFCclJ5r
	qFecmFtcmpeul5yfu4kRHAXPpHYwrmywOMQowMGoxMNbcWx2kBBrYllxZe4hRgkOZiURXpa/
	QCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8B1qtA4UE0hNLUrNTUwtSi2CyTBycUg2MRSf2cIQE
	bj7E1S9U1XlU7BDzVzGOwN466c/S0bPqr9vfNbp/ujHeIvrMHYX7hmE/xeelNvFcmGuZs/t8
	ToGftzunxduT0TsL/ypI/7OwWCqTIFT5Jcz4RGPQjoMT31jKvfm7YPrif7abeK0lrjmZqWdx
	O7B5V2a8WLo51+nnh8+ZvreYc6yVWIozEg21mIuKEwFoB9dtfgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Some comments as following.

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Saturday, November 30, 2013 2:26 PM
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net
> Subject: [f2fs-dev] [PATCH] f2fs: refactor bio-related operations
> 

[snip]

> +void f2fs_submit_page_mbio(struct f2fs_sb_info *sbi, struct page *page,
> +			block_t blk_addr, enum page_type type, int rw)
> +{
> +	enum page_type btype = PAGE_TYPE_OF_BIO(type);
> +	struct block_device *bdev = sbi->sb->s_bdev;
> +	struct f2fs_bio_info *io;
> +	int bio_blocks;
> +
> +	io = is_read_io(rw) ? &sbi->read_io : &sbi->write_io[btype];
> +
> +	verify_block_addr(sbi, blk_addr);
> +
> +	mutex_lock(&io->io_mutex);
> +
> +	if (!is_read_io(rw))
> +		inc_page_count(sbi, F2FS_WRITEBACK);
> +
> +	if (io->bio && io->last_block_in_bio != blk_addr - 1)
> +		__submit_merged_bio(sbi, io, type, true, rw);
> +alloc_new:
> +	if (io->bio == NULL) {
> +		bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
> +		io->bio = __bio_alloc(bdev, bio_blocks);
> +		io->bio->bi_sector = SECTOR_FROM_BLOCK(sbi, blk_addr);
> +		io->bio->bi_end_io = is_read_io(rw) ? f2fs_read_end_io :
> +							f2fs_write_end_io;
> +		/*
> +		 * The end_io will be assigned at the sumbission phase.
> +		 * Until then, let bio_add_page() merge consecutive IOs as much
> +		 * as possible.
> +		 */
> +	}
> +
> +	if (bio_add_page(io->bio, page, PAGE_CACHE_SIZE, 0) <
> +							PAGE_CACHE_SIZE) {
> +		__submit_merged_bio(sbi, io, type, true, rw);
> +		io->bio = NULL;

We should remove the redundant code " io->bio = NULL;" here,
because __submit_merged_bio does the same job.

[snip]

>  /*
>   * data.c
>   */
> +void f2fs_submit_merged_bio(struct f2fs_sb_info *, enum page_type, bool, int);
> +int f2fs_submit_page_bio(struct f2fs_sb_info *, struct page *, block_t, int);

Redundant to the following code.

> +void f2fs_submit_page_mbio(struct f2fs_sb_info *, struct page *, block_t,
> +							enum page_type, int);
>  int reserve_new_block(struct dnode_of_data *);
>  int f2fs_reserve_block(struct dnode_of_data *, pgoff_t);
>  void update_extent_cache(block_t, struct dnode_of_data *);
>  struct page *find_data_page(struct inode *, pgoff_t, bool);
>  struct page *get_lock_data_page(struct inode *, pgoff_t);
>  struct page *get_new_data_page(struct inode *, struct page *, pgoff_t, bool);
> -int f2fs_readpage(struct f2fs_sb_info *, struct page *, block_t, int);
> -void f2fs_submit_read_bio(struct f2fs_sb_info *, int);
> -void submit_read_page(struct f2fs_sb_info *, struct page *, block_t, int);
> +int f2fs_submit_page_bio(struct f2fs_sb_info *, struct page *, block_t, int);

Here.

[snip]

