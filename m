Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbaCJGNH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 02:13:07 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48806 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbaCJGNF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 02:13:05 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-ef-531d57ef2b79
From: Chao Yu <chao2.yu@samsung.com>
To: jaegeuk.kim@samsung.com
Cc: "'Gu Zheng'" <guz.fnst@cn.fujitsu.com>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'f2fs'" <linux-f2fs-devel@lists.sourceforge.net>
References: <5319A2D8.70409@cn.fujitsu.com> <1394426742.3870.89.camel@kjgkr>
 <000901cf3c1f$9611b7b0$c2352710$@samsung.com> <1394429876.3870.97.camel@kjgkr>
In-reply-to: <1394429876.3870.97.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH 4/5] f2fs: optimize restore_node_summary slightly
Date: Mon, 10 Mar 2014 14:12:19 +0800
Message-id: <000a01cf3c27$cb269c10$6173d430$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJT06/+U02IP7V5r3rmNpSsYDt3pALd88hPAxIL5lsCIpGuMpmQEN0g
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsVy+t9jAd334bLBBm+vcVg8bz/AbHF9118m
	i0uL3C0u75rD5sDi8f/gJGaP3Qs+M3n0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXRt/cyoJZ
	JhW/9txmbWBcpNbFyMEhIWAisemcZhcjJ5ApJnHh3nq2LkYuDiGBRYwSX6esYIVwfjBK9Gye
	xAhSxSagIrG84z8TiC0iIC0x69M8FhCbWaCHUWJ5Xx5Ew1xGiZ//D4M1cAroSnyYNYcdxBYW
	CJD4s7abGcRmEVCVmLzmCFgNr4ClxKmeKVC2oMSPyfeghqpLTJq3iBnC1pZ48u4CK8SpChI7
	zr5mhDjCTWLCxkWsEDXiEhuP3GKZwCg0C8moWUhGzUIyahaSlgWMLKsYRVMLkguKk9JzDfWK
	E3OLS/PS9ZLzczcxgmPgmdQOxpUNFocYBTgYlXh4M17LBAuxJpYVV+YeYpTgYFYS4eUylA0W
	4k1JrKxKLcqPLyrNSS0+xCjNwaIkznug1TpQSCA9sSQ1OzW1ILUIJsvEwSnVwMh5rP+vzcJk
	4SzN9H1inPfibIp2aLbKh/NO2v7mSZX8+r2PS9cnRx+yOW68ZZ/32oAF3z+f2s359VBIhPzz
	73UM30q/LF9WXLCDdfJcafHXzvXOPt+D7V+fK192YMrHvUbvH0r8yvkxeY3Vo3WMeUmPr0+r
	K8uRmP3o0MTfBkKXzj+IubdU4foEJZbijERDLeai4kQAtL0WmH0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Monday, March 10, 2014 1:38 PM
> To: Chao Yu
> Cc: 'Gu Zheng'; 'linux-kernel'; 'f2fs'
> Subject: RE: [f2fs-dev] [PATCH 4/5] f2fs: optimize restore_node_summary slightly
> 
> Hi,
> 
> 2014-03-10 (월), 13:13 +0800, Chao Yu:
> > Hi Gu, Kim:
> >
> > One more comment.
> >
> > > -----Original Message-----
> > > From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> > > Sent: Monday, March 10, 2014 12:46 PM
> > > To: Gu Zheng
> > > Cc: linux-kernel; f2fs
> > > Subject: Re: [f2fs-dev] [PATCH 4/5] f2fs: optimize restore_node_summary slightly
> > >
> > > Hi Gu,
> > >
> > > 2014-03-07 (금), 18:43 +0800, Gu Zheng:
> > > > Previously, we ra_sum_pages to pre-read contiguous pages as more
> > > > as possible, and if we fail to alloc more pages, an ENOMEM error
> > > > will be reported upstream, even though we have alloced some pages
> > > > yet. In fact, we can use the available pages to do the job partly,
> > > > and continue the rest in the following circle. Only reporting ENOMEM
> > > > upstream if we really can not alloc any available page.
> > > >
> > > > And another fix is ignoring dealing with the following pages if an
> > > > EIO occurs when reading page from page_list.
> > > >
> > > > Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> >
> > Reviewed-by: Chao Yu <chao2.yu@samsung.com>
> >
> > > > ---
> > > >  fs/f2fs/node.c    |   44 ++++++++++++++++++++------------------------
> > > >  fs/f2fs/segment.c |    7 +++++--
> > > >  2 files changed, 25 insertions(+), 26 deletions(-)
> > > >
> > > > diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> > > > index 8787469..4b7861d 100644
> > > > --- a/fs/f2fs/node.c
> > > > +++ b/fs/f2fs/node.c
> > > > @@ -1588,15 +1588,8 @@ static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head
> > > *pages,
> > > >  	for (; page_idx < start + nrpages; page_idx++) {
> > > >  		/* alloc temporal page for read node summary info*/
> > > >  		page = alloc_page(GFP_F2FS_ZERO);
> > > > -		if (!page) {
> > > > -			struct page *tmp;
> > > > -			list_for_each_entry_safe(page, tmp, pages, lru) {
> > > > -				list_del(&page->lru);
> > > > -				unlock_page(page);
> > > > -				__free_pages(page, 0);
> > > > -			}
> > > > -			return -ENOMEM;
> > > > -		}
> > > > +		if (!page)
> > > > +			break;
> > > >
> > > >  		lock_page(page);
> > > >  		page->index = page_idx;
> > > > @@ -1607,7 +1600,8 @@ static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head
> > > *pages,
> > > >  		f2fs_submit_page_mbio(sbi, page, page->index, &fio);
> > > >
> > > >  	f2fs_submit_merged_bio(sbi, META, READ);
> > > > -	return 0;
> > > > +
> > > > +	return page_idx - start;
> > > >  }
> > > >
> > > >  int restore_node_summary(struct f2fs_sb_info *sbi,
> > > > @@ -1630,28 +1624,30 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
> > > >  		nrpages = min(last_offset - i, bio_blocks);
> > > >
> > > >  		/* read ahead node pages */
> > > > -		err = ra_sum_pages(sbi, &page_list, addr, nrpages);
> > > > -		if (err)
> > > > -			return err;
> > > > +		nrpages = ra_sum_pages(sbi, &page_list, addr, nrpages);
> > > > +		if (!nrpages)
> > > > +			return -ENOMEM;
> > > >
> > > >  		list_for_each_entry_safe(page, tmp, &page_list, lru) {
> > > > -
> > >
> > > Here we can just add:
> > > 			if (err)
> > > 				goto skip;
> > > 			lock_page();
> > > 			...
> > > 			unlock_page();
> > > 		skip:
> > > 			list_del();
> > > 			__free_pages();
> > >
> > > IMO, it's more neat, so if you have any objection, let me know.
> > > Otherwise, I'll handle this by myself. :)
> > > Thanks,
> > >
> > > > -			lock_page(page);
> > > > -			if (unlikely(!PageUptodate(page))) {
> > > > -				err = -EIO;
> > > > -			} else {
> > > > -				rn = F2FS_NODE(page);
> > > > -				sum_entry->nid = rn->footer.nid;
> > > > -				sum_entry->version = 0;
> > > > -				sum_entry->ofs_in_node = 0;
> > > > -				sum_entry++;
> > > > +			if (!err) {
> >
> > If we skip here, next round we will fill these summary page entries with
> > wrong info because we skip the code 'sum_entry++;'.
> 
> There is no next round. Once err = -EIO, there's no route to make err =
> 0.

Ah, you're right. Only old code has this problem, this new patch can fix it well.
Thanks for the mention. :)

Thanks.

> 
> >
> > > > +				lock_page(page);
> > > > +				if (unlikely(!PageUptodate(page))) {
> > > > +					err = -EIO;
> > > > +				} else {
> > > > +					rn = F2FS_NODE(page);
> > > > +					sum_entry->nid = rn->footer.nid;
> > > > +					sum_entry->version = 0;
> > > > +					sum_entry->ofs_in_node = 0;
> > > > +					sum_entry++;
> > > > +				}
> > > > +				unlock_page(page);
> > > >  			}
> > > >
> > > >  			list_del(&page->lru);
> > > > -			unlock_page(page);
> > > >  			__free_pages(page, 0);
> > > >  		}
> >
> > Maybe we should add code here.
> > 			if (err)
> > 				return err;
> 
> This can reduce unnecessary loop executions.
> I'll add this.
> Thanks,
> 
> >
> > > >  	}
> > > > +
> > > >  	return err;
> > > >  }
> > > >
> > > > diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> > > > index 199c964..b3f8431 100644
> > > > --- a/fs/f2fs/segment.c
> > > > +++ b/fs/f2fs/segment.c
> > > > @@ -1160,9 +1160,12 @@ static int read_normal_summaries(struct f2fs_sb_info *sbi, int
> type)
> > > >  				ns->ofs_in_node = 0;
> > > >  			}
> > > >  		} else {
> > > > -			if (restore_node_summary(sbi, segno, sum)) {
> > > > +			int err;
> > > > +
> > > > +			err = restore_node_summary(sbi, segno, sum);
> > > > +			if (err) {
> > > >  				f2fs_put_page(new, 1);
> > > > -				return -EINVAL;
> > > > +				return err;
> > > >  			}
> > > >  		}
> > > >  	}
> > >
> > > --
> > > Jaegeuk Kim
> > > Samsung
> > >
> > >
> > > ------------------------------------------------------------------------------
> > > Learn Graph Databases - Download FREE O'Reilly Book
> > > "Graph Databases" is the definitive new guide to graph databases and their
> > > applications. Written by three acclaimed leaders in the field,
> > > this first edition is now available. Download your free book today!
> > > http://p.sf.net/sfu/13534_NeoTech
> > > _______________________________________________
> > > Linux-f2fs-devel mailing list
> > > Linux-f2fs-devel@lists.sourceforge.net
> > > https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
> >
> 
> --
> Jaegeuk Kim
> Samsung

