Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbaAKB2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 20:28:54 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:36011 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbaAKB2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 20:28:50 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-45-52d09e50a3ee
From: Chao Yu <chao2.yu@samsung.com>
To: "'Gu Zheng'" <guz.fnst@cn.fujitsu.com>, "'Kim'" <jaegeuk.kim@samsung.com>
Cc: "'fsdevel'" <linux-fsdevel@vger.kernel.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'f2fs'" <linux-f2fs-devel@lists.sourceforge.net>
References: <52CFC6BE.7020609@cn.fujitsu.com>
In-reply-to: <52CFC6BE.7020609@cn.fujitsu.com>
Subject: RE: [f2fs-dev] [PATCH 1/3] f2fs: move grabing orphan pages out of
 protection region
Date: Sat, 11 Jan 2014 09:27:55 +0800
Message-id: <000001cf0e6c$77982430$66c86c90$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQFnQMUSKbbm/zwpSnzSiPxdGBkRlZtOVYCg
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsVy+t9jAd2AeReCDLY91LN43n6A2eL6rr9M
	FpcWuVvs2XuSxeLyrjlsDqwe/w9OYvbYveAzk0ffllWMHp83yQWwRHHZpKTmZJalFunbJXBl
	PH1+jangkGhFx9dnzA2M1wW7GDk5JARMJM5fa2CBsMUkLtxbz9bFyMUhJLCIUaLx5CVmCOcH
	o8SV1lusIFVsAioSyzv+M4HYIgKeEncu9jKCFDELTGSUeHB5NTtIQkhAV2LZ75lgYzkF9CQ+
	tR4Ds4UF4iQaH88AG8QioCqxveUjmM0rYCnRMecwlC0o8WPyPbB6ZgEtifU7jzNB2PISm9e8
	ZYY4VUFix9nXjBBHGEm0PL7KClEjLrHxyC2WCYxCs5CMmoVk1Cwko2YhaVnAyLKKUTS1ILmg
	OCk910ivODG3uDQvXS85P3cTIzginknvYFzVYHGIUYCDUYmHN0DkQpAQa2JZcWXuIUYJDmYl
	EV6pfqAQb0piZVVqUX58UWlOavEhRmkOFiVx3oOt1oFCAumJJanZqakFqUUwWSYOTqkGxrw/
	luszbv846GO+XNPaOHD2hM9LmC7NiZpo8/KUT+iyp8dus2jGvP4mKMzwQNvh6wbV1N+CPHcO
	CljnPH97vDrA/Oi1LOVzl7OX3q9Y6l80dSuLgI76jX5Ou96YVmVV032C5xv3bbI2ajE+Uxow
	zctyw+FLMVd7238ZpfNM269ZK9sgc02/XomlOCPRUIu5qDgRAA9tdhyEAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gu,

> -----Original Message-----
> From: Gu Zheng [mailto:guz.fnst@cn.fujitsu.com]
> Sent: Friday, January 10, 2014 6:09 PM
> To: Kim
> Cc: fsdevel; linux-kernel; f2fs
> Subject: [f2fs-dev] [PATCH 1/3] f2fs: move grabing orphan pages out of protection region
> 
> Move grabing orphan block page out of protection region, and grab all
> the orphan block pages ahead.
> 
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>

Reviewed-by: Chao Yu <chao2.yu@samsung.com>

> ---
>  fs/f2fs/checkpoint.c |   15 +++++++++------
>  1 files changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> index 0d78bbe..af92c74 100644
> --- a/fs/f2fs/checkpoint.c
> +++ b/fs/f2fs/checkpoint.c
> @@ -303,22 +303,25 @@ static void write_orphan_inodes(struct f2fs_sb_info *sbi, block_t
> start_blk)
>  {
>  	struct list_head *head;
>  	struct f2fs_orphan_block *orphan_blk = NULL;
> -	struct page *page = NULL;
>  	unsigned int nentries = 0;
> -	unsigned short index = 1;
> -	unsigned short orphan_blocks;
> +	unsigned short index;
> +	unsigned short orphan_blocks = (unsigned short)((sbi->n_orphans +
> +		(F2FS_ORPHANS_PER_BLOCK - 1)) / F2FS_ORPHANS_PER_BLOCK);
> +	struct page *page = NULL;
> +	struct page *pages[orphan_blocks];
>  	struct orphan_inode_entry *orphan = NULL;
> 
> -	orphan_blocks = (unsigned short)((sbi->n_orphans +
> -		(F2FS_ORPHANS_PER_BLOCK - 1)) / F2FS_ORPHANS_PER_BLOCK);
> +	for (index = 0; index < orphan_blocks; index++)
> +		pages[index] = grab_meta_page(sbi, start_blk + index);
> 
> +	index = 1;
>  	mutex_lock(&sbi->orphan_inode_mutex);
>  	head = &sbi->orphan_inode_list;
> 
>  	/* loop for each orphan inode entry and write them in Jornal block */
>  	list_for_each_entry(orphan, head, list) {
>  		if (!page) {
> -			page = grab_meta_page(sbi, start_blk);
> +			page = pages[index - 1];
>  			orphan_blk =
>  				(struct f2fs_orphan_block *)page_address(page);
>  			memset(orphan_blk, 0, sizeof(*orphan_blk));

It seems that we could remove the following code in write_orphan_inodes.
			start_blk++;

> --
> 1.7.7
> 
> 
> ------------------------------------------------------------------------------
> CenturyLink Cloud: The Leader in Enterprise Cloud Services.
> Learn Why More Businesses Are Choosing CenturyLink Cloud For
> Critical Workloads, Development Environments & Everything In Between.
> Get a Quote or Start a Free Trial Today.
> http://pubads.g.doubleclick.net/gampad/clk?id=119420431&iu=/4140/ostg.clktrk
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

