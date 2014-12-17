Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751104AbaLQPUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 10:20:00 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:45875 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbaLQPT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 10:19:58 -0500
MIME-Version: 1.0
In-Reply-To: <001d01d019e1$d6ad6c10$84084430$@samsung.com>
References: <001d01d019e1$d6ad6c10$84084430$@samsung.com>
Date: Thu, 18 Dec 2014 00:19:56 +0900
Message-ID: <CAN863PuF-aSNGxe6=5k9LL-9V5maHnNnd7w-Sz2GQPFz-MHC7A@mail.gmail.com>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: use ra_meta_pages to simplify
 readahead code in restore_node_summary
From: Changman Lee <cm224.lee@gmail.com>
To: Chao Yu <chao2.yu@samsung.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is there any reason to use truncate_inode_pages_range instead of
invalidate_mapping_pages?
IMHO, it seems nice to just use invalidate_mapping_pages because pages
of meta_inode shouldn't be dirty, locked, under writeback or mapped in
this function.
If there is my misunderstanding, let me know.

Thanks,

Reviewed-by: Changman Lee <cm224.lee@samsung.com>

2014-12-17 19:10 GMT+09:00 Chao Yu <chao2.yu@samsung.com>:
> Use more common function ra_meta_pages() with META_POR to readahead node blocks
> in restore_node_summary() instead of ra_sum_pages(), hence we can simplify the
> readahead code there, and also we can remove unused function ra_sum_pages().
>
> changes from v1:
>  o fix one bug when using truncate_inode_pages_range which is pointed out by
>    Jaegeuk Kim.
>
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/f2fs/node.c | 68 +++++++++++++---------------------------------------------
>  1 file changed, 15 insertions(+), 53 deletions(-)
>
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index 5aa54a0..ab48b4c 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -1726,80 +1726,42 @@ int recover_inode_page(struct f2fs_sb_info *sbi, struct page *page)
>         return 0;
>  }
>
> -/*
> - * ra_sum_pages() merge contiguous pages into one bio and submit.
> - * these pre-read pages are allocated in bd_inode's mapping tree.
> - */
> -static int ra_sum_pages(struct f2fs_sb_info *sbi, struct page **pages,
> -                               int start, int nrpages)
> -{
> -       struct inode *inode = sbi->sb->s_bdev->bd_inode;
> -       struct address_space *mapping = inode->i_mapping;
> -       int i, page_idx = start;
> -       struct f2fs_io_info fio = {
> -               .type = META,
> -               .rw = READ_SYNC | REQ_META | REQ_PRIO
> -       };
> -
> -       for (i = 0; page_idx < start + nrpages; page_idx++, i++) {
> -               /* alloc page in bd_inode for reading node summary info */
> -               pages[i] = grab_cache_page(mapping, page_idx);
> -               if (!pages[i])
> -                       break;
> -               f2fs_submit_page_mbio(sbi, pages[i], page_idx, &fio);
> -       }
> -
> -       f2fs_submit_merged_bio(sbi, META, READ);
> -       return i;
> -}
> -
>  int restore_node_summary(struct f2fs_sb_info *sbi,
>                         unsigned int segno, struct f2fs_summary_block *sum)
>  {
>         struct f2fs_node *rn;
>         struct f2fs_summary *sum_entry;
> -       struct inode *inode = sbi->sb->s_bdev->bd_inode;
>         block_t addr;
>         int bio_blocks = MAX_BIO_BLOCKS(sbi);
> -       struct page *pages[bio_blocks];
> -       int i, idx, last_offset, nrpages, err = 0;
> +       int i, idx, last_offset, nrpages;
>
>         /* scan the node segment */
>         last_offset = sbi->blocks_per_seg;
>         addr = START_BLOCK(sbi, segno);
>         sum_entry = &sum->entries[0];
>
> -       for (i = 0; !err && i < last_offset; i += nrpages, addr += nrpages) {
> +       for (i = 0; i < last_offset; i += nrpages, addr += nrpages) {
>                 nrpages = min(last_offset - i, bio_blocks);
>
>                 /* readahead node pages */
> -               nrpages = ra_sum_pages(sbi, pages, addr, nrpages);
> -               if (!nrpages)
> -                       return -ENOMEM;
> +               ra_meta_pages(sbi, addr, nrpages, META_POR);
>
> -               for (idx = 0; idx < nrpages; idx++) {
> -                       if (err)
> -                               goto skip;
> +               for (idx = addr; idx < addr + nrpages; idx++) {
> +                       struct page *page = get_meta_page(sbi, idx);
>
> -                       lock_page(pages[idx]);
> -                       if (unlikely(!PageUptodate(pages[idx]))) {
> -                               err = -EIO;
> -                       } else {
> -                               rn = F2FS_NODE(pages[idx]);
> -                               sum_entry->nid = rn->footer.nid;
> -                               sum_entry->version = 0;
> -                               sum_entry->ofs_in_node = 0;
> -                               sum_entry++;
> -                       }
> -                       unlock_page(pages[idx]);
> -skip:
> -                       page_cache_release(pages[idx]);
> +                       rn = F2FS_NODE(page);
> +                       sum_entry->nid = rn->footer.nid;
> +                       sum_entry->version = 0;
> +                       sum_entry->ofs_in_node = 0;
> +                       sum_entry++;
> +                       f2fs_put_page(page, 1);
>                 }
>
> -               invalidate_mapping_pages(inode->i_mapping, addr,
> -                                                       addr + nrpages);
> +               truncate_inode_pages_range(META_MAPPING(sbi),
> +                               addr << PAGE_CACHE_SHIFT,
> +                               ((addr + nrpages) << PAGE_CACHE_SHIFT) - 1);
>         }
> -       return err;
> +       return 0;
>  }
>
>  static void remove_nats_in_journal(struct f2fs_sb_info *sbi)
> --
> 2.1.2
>
>
>
> ------------------------------------------------------------------------------
> Download BIRT iHub F-Type - The Free Enterprise-Grade BIRT Server
> from Actuate! Instantly Supercharge Your Business Reports and Dashboards
> with Interactivity, Sharing, Native Excel Exports, App Integration & more
> Get technology previously reserved for billion-dollar corporations, FREE
> http://pubads.g.doubleclick.net/gampad/clk?id=164703151&iu=/4140/ostg.clktrk
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
