Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605AbaLQGEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 01:04:40 -0500
Received: from mail.kernel.org ([198.145.19.201]:45336 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbaLQGEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 01:04:38 -0500
Date: Tue, 16 Dec 2014 22:04:36 -0800
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Chao Yu <chao2.yu@samsung.com>
Cc: Changman Lee <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [f2fs-dev][PATCH] f2fs: use ra_meta_pages to simplify readahead
 code in restore_node_summary
Message-ID: <20141217060436.GA7624@jaegeuk-mac02.mot-mobility.com>
References: <003e01d0152b$a7fd0b60$f7f72220$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <003e01d0152b$a7fd0b60$f7f72220$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chao,

On Thu, Dec 11, 2014 at 06:16:27PM +0800, Chao Yu wrote:
> Use more common function ra_meta_pages() with META_POR to readahead node blocks
> in restore_node_summary() instead of ra_sum_pages(), hence we can simplify the
> readahead code there, and also we can remove unused function ra_sum_pages().
> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/f2fs/node.c | 67 ++++++++++++----------------------------------------------
>  1 file changed, 14 insertions(+), 53 deletions(-)
> 
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index f83326c..5824d6a 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -1726,80 +1726,41 @@ int recover_inode_page(struct f2fs_sb_info *sbi, struct page *page)
>  	return 0;
>  }
>  
> -/*
> - * ra_sum_pages() merge contiguous pages into one bio and submit.
> - * these pre-read pages are allocated in bd_inode's mapping tree.
> - */
> -static int ra_sum_pages(struct f2fs_sb_info *sbi, struct page **pages,
> -				int start, int nrpages)
> -{
> -	struct inode *inode = sbi->sb->s_bdev->bd_inode;
> -	struct address_space *mapping = inode->i_mapping;
> -	int i, page_idx = start;
> -	struct f2fs_io_info fio = {
> -		.type = META,
> -		.rw = READ_SYNC | REQ_META | REQ_PRIO
> -	};
> -
> -	for (i = 0; page_idx < start + nrpages; page_idx++, i++) {
> -		/* alloc page in bd_inode for reading node summary info */
> -		pages[i] = grab_cache_page(mapping, page_idx);
> -		if (!pages[i])
> -			break;
> -		f2fs_submit_page_mbio(sbi, pages[i], page_idx, &fio);
> -	}
> -
> -	f2fs_submit_merged_bio(sbi, META, READ);
> -	return i;
> -}
> -
>  int restore_node_summary(struct f2fs_sb_info *sbi,
>  			unsigned int segno, struct f2fs_summary_block *sum)
>  {
>  	struct f2fs_node *rn;
>  	struct f2fs_summary *sum_entry;
> -	struct inode *inode = sbi->sb->s_bdev->bd_inode;
>  	block_t addr;
>  	int bio_blocks = MAX_BIO_BLOCKS(sbi);
> -	struct page *pages[bio_blocks];
> -	int i, idx, last_offset, nrpages, err = 0;
> +	int i, idx, last_offset, nrpages;
>  
>  	/* scan the node segment */
>  	last_offset = sbi->blocks_per_seg;
>  	addr = START_BLOCK(sbi, segno);
>  	sum_entry = &sum->entries[0];
>  
> -	for (i = 0; !err && i < last_offset; i += nrpages, addr += nrpages) {
> +	for (i = 0; i < last_offset; i += nrpages, addr += nrpages) {
>  		nrpages = min(last_offset - i, bio_blocks);
>  
>  		/* readahead node pages */
> -		nrpages = ra_sum_pages(sbi, pages, addr, nrpages);
> -		if (!nrpages)
> -			return -ENOMEM;
> +		ra_meta_pages(sbi, addr, nrpages, META_POR);
>  
> -		for (idx = 0; idx < nrpages; idx++) {
> -			if (err)
> -				goto skip;
> +		for (idx = addr; idx < addr + nrpages; idx++) {
> +			struct page *page = get_meta_page(sbi, idx);
>  
> -			lock_page(pages[idx]);
> -			if (unlikely(!PageUptodate(pages[idx]))) {
> -				err = -EIO;
> -			} else {
> -				rn = F2FS_NODE(pages[idx]);
> -				sum_entry->nid = rn->footer.nid;
> -				sum_entry->version = 0;
> -				sum_entry->ofs_in_node = 0;
> -				sum_entry++;
> -			}
> -			unlock_page(pages[idx]);
> -skip:
> -			page_cache_release(pages[idx]);
> +			rn = F2FS_NODE(page);
> +			sum_entry->nid = rn->footer.nid;
> +			sum_entry->version = 0;
> +			sum_entry->ofs_in_node = 0;
> +			sum_entry++;
> +			f2fs_put_page(page, 1);
>  		}
>  
> -		invalidate_mapping_pages(inode->i_mapping, addr,
> -							addr + nrpages);
> +		truncate_inode_pages_range(META_MAPPING(sbi),
> +						addr, addr + nrpages);

I found a bug here. :)
The truncate_inode_pages_range uses start and end parameters as byte offsets.
So, you should use like (addr << PAGE_CACHE_SHIFT).

Thanks,

>  	}
> -	return err;
> +	return 0;
>  }
>  
>  static void remove_nats_in_journal(struct f2fs_sb_info *sbi)
> -- 
> 2.1.2
