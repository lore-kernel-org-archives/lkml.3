Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944Ab3K1B1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 20:27:49 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:13461 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab3K1B1r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 20:27:47 -0500
X-AuditID: cbfee61b-b7f166d000007a34-0b-52969c0f70e2
From: Chao Yu <chao2.yu@samsung.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?utf-8?B?J+iwreWnnSc=?= <shu.tan@samsung.com>
References: <000101cee757$6f3b4790$4db1d6b0$@samsung.com>
 <1385530195.2417.22.camel@kjgkr> <002f01ceeb46$8758b9a0$960a2ce0$@samsung.com>
 <1385540365.2417.28.camel@kjgkr>
In-reply-to: <1385540365.2417.28.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH] f2fs: readahead contiguous pages for
 restore_node_summary
Date: Thu, 28 Nov 2013 09:26:45 +0800
Message-id: <003001ceebd9$07157380$15405a80$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQLo/dmhZfpHUVdsz0A5xHDiq3ZS0QHeqe7fAe9aYegCtYwBoZfRiN+Q
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsVy+t9jAV2BOdOCDCwtru/6y2RxaZG7xZ69
	J1ksLu+aw2bRuvA8swOrx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK6Nn9wW2go8m
	FTs+dbI0MB5U72Lk5JAQMJFYunw2I4QtJnHh3nq2LkYuDiGBRYwS39feZAdJCAn8YJT4c9oO
	xGYTUJFY3vGfCcQWEZCWmPVpHgtIA7PAbEaJni/PGCG61zJKvHh3khWkilNAV2L/1V1sILaw
	QLTEu0c9YFNZBFQlrv46BbaaV8BS4srbqVC2oMSPyfeApnIATVWXmDIlFyTMLKAt8eTdBVaI
	SxUkdpx9zQhSIiLgJvF5tiJEibjExiO3WCYwCs1CMmgWwqBZSAbNQtKxgJFlFaNoakFyQXFS
	eq6RXnFibnFpXrpecn7uJkZw8D+T3sG4qsHiEKMAB6MSD6+EzrQgIdbEsuLK3EOMEhzMSiK8
	CsVAId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwHW60DhQTSE0tSs1NTC1KLYLJMHJxSDYxRFkW7
	tU+nfFa80na160aPwPsDHPYVc7/HSK4QKjadFsR283qTd8N6O6f/y++HdIrYtidpVT+un5rv
	sX36veRYxjU5e1ujZNqY8gw7ObznvDkT2/29b47x7KrLE9dM/DxNLX9OiERIwcHDuya+DmLl
	6l759vKF4m7hhVxO1XnLu49f36NVJ6XEUpyRaKjFXFScCACpQ0BregIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Wednesday, November 27, 2013 4:19 PM
> To: Chao Yu
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net; '谭姝'
> Subject: RE: [f2fs-dev] [PATCH] f2fs: readahead contiguous pages for restore_node_summary
> 
> Hi,
> 
> 2013-11-27 (수), 15:58 +0800, Chao Yu:
> > Hi Kim,
> >
> > > -----Original Message-----
> > > From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> > > Sent: Wednesday, November 27, 2013 1:30 PM
> > > To: Chao Yu
> > > Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net; 谭姝
> > > Subject: Re: [f2fs-dev] [PATCH] f2fs: readahead contiguous pages for restore_node_summary
> > >
> > > Hi Chao,
> > >
> > > It seems that we already have a readahed function for node pages,
> > > ra_node_page().
> > > So, we don't make a page list for this, but can use the node_inode's
> > > page cache.
> >
> > So you mean it's waste to release page list with updated data after we
> > finish work in restore_node_summary, right?
> 
> Right.

So how about add all pages of page list to node_inode's address space by
add_to_page_cache_lru() with arg sum_entry->nid?

> 
> >
> > >
> > > So how about writing ra_node_pages() which use the node_inode's page
> > > cache?
> >
> > Hmm, so ra_node_pages is introduced for read node_inode's pages which are
> > logical contiguously? and it also could take place of ra_node_page?
> 
> Ah. The ra_node_page() read a node page ahead for a given node id.
> So it doesn't match exactly between ra_node_page() and ra_node_pages()
> that I suggested.
> So how about reading node pages and then caching some of them in the
> page cache, node_inode's address space?

Got it,
If we do not use the method above, we should search the NAT for nid number
as the index of node_inode's page by the specified node page blkaddr, that costs
a lot.
How do you think?

> 
> Thanks,
> 
> >
> >
> > >
> > > Thanks,
> > >
> > > 2013-11-22 (금), 15:48 +0800, Chao Yu:
> > > > If cp has no CP_UMOUNT_FLAG, we will read all pages in whole node segment
> > > > one by one, it makes low performance. So let's merge contiguous pages and
> > > > readahead for better performance.
> > > >
> > > > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > > > ---
> > > >  fs/f2fs/node.c |   89 +++++++++++++++++++++++++++++++++++++++-----------------
> > > >  1 file changed, 63 insertions(+), 26 deletions(-)
> > > >
> > > > diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> > > > index 4ac4150..81e704a 100644
> > > > --- a/fs/f2fs/node.c
> > > > +++ b/fs/f2fs/node.c
> > > > @@ -1572,47 +1572,84 @@ int recover_inode_page(struct f2fs_sb_info *sbi, struct page *page)
> > > >  	return 0;
> > > >  }
> > > >
> > > > +/*
> > > > + * ra_sum_pages() merge contiguous pages into one bio and submit.
> > > > + * these pre-readed pages are linked in pages list.
> > > > + */
> > > > +static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head *pages,
> > > > +				int start, int nrpages)
> > > > +{
> > > > +	struct page *page;
> > > > +	int page_idx = start;
> > > > +
> > > > +	for (; page_idx < start + nrpages; page_idx++) {
> > > > +		/* alloc temporal page for read node summary info*/
> > > > +		page = alloc_page(GFP_NOFS | __GFP_ZERO);
> > > > +		if (!page) {
> > > > +			struct page *tmp;
> > > > +			list_for_each_entry_safe(page, tmp, pages, lru) {
> > > > +				list_del(&page->lru);
> > > > +				unlock_page(page);
> > > > +				__free_pages(page, 0);
> > > > +			}
> > > > +			return -ENOMEM;
> > > > +		}
> > > > +
> > > > +		lock_page(page);
> > > > +		page->index = page_idx;
> > > > +		list_add_tail(&page->lru, pages);
> > > > +	}
> > > > +
> > > > +	list_for_each_entry(page, pages, lru)
> > > > +		submit_read_page(sbi, page, page->index, READ_SYNC);
> > > > +
> > > > +	f2fs_submit_read_bio(sbi, READ_SYNC);
> > > > +	return 0;
> > > > +}
> > > > +
> > > >  int restore_node_summary(struct f2fs_sb_info *sbi,
> > > >  			unsigned int segno, struct f2fs_summary_block *sum)
> > > >  {
> > > >  	struct f2fs_node *rn;
> > > >  	struct f2fs_summary *sum_entry;
> > > > -	struct page *page;
> > > > +	struct page *page, *tmp;
> > > >  	block_t addr;
> > > > -	int i, last_offset;
> > > > -
> > > > -	/* alloc temporal page for read node */
> > > > -	page = alloc_page(GFP_NOFS | __GFP_ZERO);
> > > > -	if (!page)
> > > > -		return -ENOMEM;
> > > > -	lock_page(page);
> > > > +	int bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
> > > > +	int i, last_offset, nrpages, err = 0;
> > > > +	LIST_HEAD(page_list);
> > > >
> > > >  	/* scan the node segment */
> > > >  	last_offset = sbi->blocks_per_seg;
> > > >  	addr = START_BLOCK(sbi, segno);
> > > >  	sum_entry = &sum->entries[0];
> > > >
> > > > -	for (i = 0; i < last_offset; i++, sum_entry++) {
> > > > -		/*
> > > > -		 * In order to read next node page,
> > > > -		 * we must clear PageUptodate flag.
> > > > -		 */
> > > > -		ClearPageUptodate(page);
> > > > +	for (i = 0; i < last_offset; i += nrpages, addr += nrpages) {
> > > >
> > > > -		if (f2fs_readpage(sbi, page, addr, READ_SYNC))
> > > > -			goto out;
> > > > +		nrpages = min(last_offset - i, bio_blocks);
> > > > +		/* read ahead node pages */
> > > > +		err = ra_sum_pages(sbi, &page_list, addr, nrpages);
> > > > +		if (err)
> > > > +			return err;
> > > >
> > > > -		lock_page(page);
> > > > -		rn = F2FS_NODE(page);
> > > > -		sum_entry->nid = rn->footer.nid;
> > > > -		sum_entry->version = 0;
> > > > -		sum_entry->ofs_in_node = 0;
> > > > -		addr++;
> > > > +		list_for_each_entry_safe(page, tmp, &page_list, lru) {
> > > > +
> > > > +			lock_page(page);
> > > > +			if(PageUptodate(page)) {
> > > > +				rn = F2FS_NODE(page);
> > > > +				sum_entry->nid = rn->footer.nid;
> > > > +				sum_entry->version = 0;
> > > > +				sum_entry->ofs_in_node = 0;
> > > > +				sum_entry++;
> > > > +			} else {
> > > > +				err = -EIO;
> > > > +			}
> > > > +
> > > > +			list_del(&page->lru);
> > > > +			unlock_page(page);
> > > > +			__free_pages(page, 0);
> > > > +		}
> > > >  	}
> > > > -	unlock_page(page);
> > > > -out:
> > > > -	__free_pages(page, 0);
> > > > -	return 0;
> > > > +	return err;
> > > >  }
> > > >
> > > >  static bool flush_nats_in_journal(struct f2fs_sb_info *sbi)
> > >
> > > --
> > > Jaegeuk Kim
> > > Samsung
> >
> 
> --
> Jaegeuk Kim
> Samsung

