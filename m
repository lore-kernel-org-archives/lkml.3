Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbaLSCgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 21:36:17 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:43495 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaLSCgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 21:36:15 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-81-54938f1d189e
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: "'Changman Lee'" <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <005301d01aad$9128d0e0$b37a72a0$@samsung.com>
 <20141218191257.GA24821@jaegeuk-mac02>
In-reply-to: <20141218191257.GA24821@jaegeuk-mac02>
Subject: RE: [f2fs-dev] [PATCH v3] f2fs: use ra_meta_pages to simplify
 readahead code in restore_node_summary
Date: Fri, 19 Dec 2014 10:35:07 +0800
Message-id: <000001d01b34$8deccc60$a9c66520$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQK9ZGUf7vcQXIRm+XFZJaukBKtQMAHQixCcmq0Y7OA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t9jAV3Z/skhBhubeCyu7Wtksniyfhaz
	xaVF7hZ79p5ksbi8aw6bA6vHplWdbB67F3xm8ujbsorR4/MmuQCWKC6blNSczLLUIn27BK6M
	N3fushTcUan48eI4cwPjNJkuRk4OCQETicfnJrNC2GISF+6tZ+ti5OIQEljEKPFz9zFWCOcH
	o8S1vx3MIFVsAioSyzv+M4HYIgJqEr37pjCBFDELTGaUmNV3F8jhAOpIkph4QgSkhlPAWOLy
	/PXsIGFhgXyJedMDQcIsAqoSbTsXgS3mFbCUuHT7FCOELSjxY/I9FhCbWUBLYv3O40wQtrzE
	5jVvmSEOVZDYcfY1I8QJVhIfn39jhqgRl9h45BbLBEahWUhGzUIyahaSUbOQtCxgZFnFKJpa
	kFxQnJSea6RXnJhbXJqXrpecn7uJERwNz6R3MK5qsDjEKMDBqMTD21E4OUSINbGsuDL3EKME
	B7OSCK95JlCINyWxsiq1KD++qDQntfgQozQHi5I4r5J9W4iQQHpiSWp2ampBahFMlomDU6qB
	sa9r0j+pBImLPvMtiqZsSPpx5HlWoccCw4KVqYevHP+29kNbYegCZTG/p0WJn/TmPmVSkmT/
	K9a48YFfxc1Gzpyk9RJO7Yvj3sVka0S76zQJnkm2+tZWWlu+6M2CPddn+PswKd1gUMl20TOW
	OqWwOv542rPrxs7pjVdqhbufXRKzjW2csyBJiaU4I9FQi7moOBEAukQiU4ICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Friday, December 19, 2014 3:13 AM
> To: Chao Yu
> Cc: Changman Lee; linux-f2fs-devel@lists.sourceforge.net; linux-fsdevel@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [f2fs-dev] [PATCH v3] f2fs: use ra_meta_pages to simplify readahead code in
> restore_node_summary
> 
> Hi Chao,
> 
> On Thu, Dec 18, 2014 at 06:29:05PM +0800, Chao Yu wrote:
> > Use more common function ra_meta_pages() with META_POR to readahead node blocks
> > in restore_node_summary() instead of ra_sum_pages(), hence we can simplify the
> > readahead code there, and also we can remove unused function ra_sum_pages().
> >
> > changes from v2:
> >  o use invalidate_mapping_pages as before suggested by Changman Lee.
> > changes from v1:
> >  o fix one bug when using truncate_inode_pages_range which is pointed out by
> >    Jaegeuk Kim.
> >
> > Reviewed-by: Changman Lee <cm224.lee@samsung.com>
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> >  fs/f2fs/node.c | 63 +++++++++++-----------------------------------------------
> >  1 file changed, 12 insertions(+), 51 deletions(-)
> >
> > diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> > index 5aa54a0..17bf239 100644
> > --- a/fs/f2fs/node.c
> > +++ b/fs/f2fs/node.c
> > @@ -1726,80 +1726,41 @@ int recover_inode_page(struct f2fs_sb_info *sbi, struct page *page)
> >  	return 0;
> >  }
> >
> > -/*
> > - * ra_sum_pages() merge contiguous pages into one bio and submit.
> > - * these pre-read pages are allocated in bd_inode's mapping tree.
> > - */
> > -static int ra_sum_pages(struct f2fs_sb_info *sbi, struct page **pages,
> > -				int start, int nrpages)
> > -{
> > -	struct inode *inode = sbi->sb->s_bdev->bd_inode;
> > -	struct address_space *mapping = inode->i_mapping;
> > -	int i, page_idx = start;
> > -	struct f2fs_io_info fio = {
> > -		.type = META,
> > -		.rw = READ_SYNC | REQ_META | REQ_PRIO
> > -	};
> > -
> > -	for (i = 0; page_idx < start + nrpages; page_idx++, i++) {
> > -		/* alloc page in bd_inode for reading node summary info */
> > -		pages[i] = grab_cache_page(mapping, page_idx);
> > -		if (!pages[i])
> > -			break;
> > -		f2fs_submit_page_mbio(sbi, pages[i], page_idx, &fio);
> > -	}
> > -
> > -	f2fs_submit_merged_bio(sbi, META, READ);
> > -	return i;
> > -}
> > -
> >  int restore_node_summary(struct f2fs_sb_info *sbi,
> >  			unsigned int segno, struct f2fs_summary_block *sum)
> >  {
> >  	struct f2fs_node *rn;
> >  	struct f2fs_summary *sum_entry;
> > -	struct inode *inode = sbi->sb->s_bdev->bd_inode;
> >  	block_t addr;
> >  	int bio_blocks = MAX_BIO_BLOCKS(sbi);
> > -	struct page *pages[bio_blocks];
> > -	int i, idx, last_offset, nrpages, err = 0;
> > +	int i, idx, last_offset, nrpages;
> >
> >  	/* scan the node segment */
> >  	last_offset = sbi->blocks_per_seg;
> >  	addr = START_BLOCK(sbi, segno);
> >  	sum_entry = &sum->entries[0];
> >
> > -	for (i = 0; !err && i < last_offset; i += nrpages, addr += nrpages) {
> > +	for (i = 0; i < last_offset; i += nrpages, addr += nrpages) {
> >  		nrpages = min(last_offset - i, bio_blocks);
> >
> >  		/* readahead node pages */
> > -		nrpages = ra_sum_pages(sbi, pages, addr, nrpages);
> > -		if (!nrpages)
> > -			return -ENOMEM;
> > +		ra_meta_pages(sbi, addr, nrpages, META_POR);
> >
> > -		for (idx = 0; idx < nrpages; idx++) {
> > -			if (err)
> > -				goto skip;
> > +		for (idx = addr; idx < addr + nrpages; idx++) {
> > +			struct page *page = get_meta_page(sbi, idx);
> >
> > -			lock_page(pages[idx]);
> > -			if (unlikely(!PageUptodate(pages[idx]))) {
> > -				err = -EIO;
> > -			} else {
> > -				rn = F2FS_NODE(pages[idx]);
> > -				sum_entry->nid = rn->footer.nid;
> > -				sum_entry->version = 0;
> > -				sum_entry->ofs_in_node = 0;
> > -				sum_entry++;
> > -			}
> > -			unlock_page(pages[idx]);
> > -skip:
> > -			page_cache_release(pages[idx]);
> > +			rn = F2FS_NODE(page);
> > +			sum_entry->nid = rn->footer.nid;
> > +			sum_entry->version = 0;
> > +			sum_entry->ofs_in_node = 0;
> > +			sum_entry++;
> > +			f2fs_put_page(page, 1);
> >  		}
> >
> >  		invalidate_mapping_pages(inode->i_mapping, addr,
> >  							addr + nrpages);
> 
> This causes a build error.

Sorry, out of my mind at that time.

> Let's use META_MAPPING() here.
> If you don't mind, I'll change this and then merge the patch.

It's OK, thank you!

Regards,
Yu

> 
> Thanks,
> 
> >  	}
> > -	return err;
> > +	return 0;
> >  }
> >
> >  static void remove_nats_in_journal(struct f2fs_sb_info *sbi)
> > --
> > 2.1.2

