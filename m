Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbaCJFOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 01:14:23 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:35081 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbaCJFOV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 01:14:21 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-5b-531d4a29b999
From: Chao Yu <chao2.yu@samsung.com>
To: "'Gu Zheng'" <guz.fnst@cn.fujitsu.com>, jaegeuk.kim@samsung.com
Cc: "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'f2fs'" <linux-f2fs-devel@lists.sourceforge.net>
References: <5319A2D8.70409@cn.fujitsu.com> <1394426742.3870.89.camel@kjgkr>
In-reply-to: <1394426742.3870.89.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH 4/5] f2fs: optimize restore_node_summary	slightly
Date: Mon, 10 Mar 2014 13:13:30 +0800
Message-id: <000901cf3c1f$9611b7b0$c2352710$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJT06/+U02IP7V5r3rmNpSsYDt3pALd88hPmbmjrlA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsVy+t9jAV1NL9lgg6mHzC2etx9gtri+6y+T
	xaVF7haXd81hc2Dx+H9wErPH7gWfmTz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEr4+aMeSwF
	OzUrpt48ztTAuFu+i5GTQ0LARGLa81vMELaYxIV769lAbCGBRYwSb/+4dDFyAdk/GCWO9M9n
	AkmwCahILO/4D2aLCDhKLDy1k6WLkYODWSBFYnmXLYgpJOAjcfCcI0gFp4CuxOOmKawgtrBA
	gMSZWU2MIDaLgKrEm0Uz2UDKeQUsJf5NDwQJ8woISvyYfI8FxGYWUJeYNG8RM4StLfHk3QVW
	iCsVJHacfc0IcYCVxOVT7UwQNeISG4/cYpnAKDQLyahZSEbNQjJqFpKWBYwsqxhFUwuSC4qT
	0nON9IoTc4tL89L1kvNzNzGCg/+Z9A7GVQ0WhxgFOBiVeHgPvJUJFmJNLCuuzD3EKMHBrCTC
	y2UoGyzEm5JYWZValB9fVJqTWnyIUZqDRUmc92CrdaCQQHpiSWp2ampBahFMlomDU6qBMWzD
	7gMyM2LjY12NT3+SXyf2aafBm10WWR3qXzjUTdxYJFoXf1fZU7ZQNpE1v9xz/xKOu4tj/9hP
	aHzKsPY1u0Fv/pw5M7w0VujwFm48d0NJy/LGUbYgDb+Iuu9rTRju7TVL+3uKpX2WcF63n1bM
	N62j91rkfp3U3vxgg6bvew+GxlORbxt2KrEUZyQaajEXFScCAKP15Ep6AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gu, Kim:

One more comment.

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Monday, March 10, 2014 12:46 PM
> To: Gu Zheng
> Cc: linux-kernel; f2fs
> Subject: Re: [f2fs-dev] [PATCH 4/5] f2fs: optimize restore_node_summary slightly
> 
> Hi Gu,
> 
> 2014-03-07 (금), 18:43 +0800, Gu Zheng:
> > Previously, we ra_sum_pages to pre-read contiguous pages as more
> > as possible, and if we fail to alloc more pages, an ENOMEM error
> > will be reported upstream, even though we have alloced some pages
> > yet. In fact, we can use the available pages to do the job partly,
> > and continue the rest in the following circle. Only reporting ENOMEM
> > upstream if we really can not alloc any available page.
> >
> > And another fix is ignoring dealing with the following pages if an
> > EIO occurs when reading page from page_list.
> >
> > Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>

Reviewed-by: Chao Yu <chao2.yu@samsung.com>

> > ---
> >  fs/f2fs/node.c    |   44 ++++++++++++++++++++------------------------
> >  fs/f2fs/segment.c |    7 +++++--
> >  2 files changed, 25 insertions(+), 26 deletions(-)
> >
> > diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> > index 8787469..4b7861d 100644
> > --- a/fs/f2fs/node.c
> > +++ b/fs/f2fs/node.c
> > @@ -1588,15 +1588,8 @@ static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head
> *pages,
> >  	for (; page_idx < start + nrpages; page_idx++) {
> >  		/* alloc temporal page for read node summary info*/
> >  		page = alloc_page(GFP_F2FS_ZERO);
> > -		if (!page) {
> > -			struct page *tmp;
> > -			list_for_each_entry_safe(page, tmp, pages, lru) {
> > -				list_del(&page->lru);
> > -				unlock_page(page);
> > -				__free_pages(page, 0);
> > -			}
> > -			return -ENOMEM;
> > -		}
> > +		if (!page)
> > +			break;
> >
> >  		lock_page(page);
> >  		page->index = page_idx;
> > @@ -1607,7 +1600,8 @@ static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head
> *pages,
> >  		f2fs_submit_page_mbio(sbi, page, page->index, &fio);
> >
> >  	f2fs_submit_merged_bio(sbi, META, READ);
> > -	return 0;
> > +
> > +	return page_idx - start;
> >  }
> >
> >  int restore_node_summary(struct f2fs_sb_info *sbi,
> > @@ -1630,28 +1624,30 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
> >  		nrpages = min(last_offset - i, bio_blocks);
> >
> >  		/* read ahead node pages */
> > -		err = ra_sum_pages(sbi, &page_list, addr, nrpages);
> > -		if (err)
> > -			return err;
> > +		nrpages = ra_sum_pages(sbi, &page_list, addr, nrpages);
> > +		if (!nrpages)
> > +			return -ENOMEM;
> >
> >  		list_for_each_entry_safe(page, tmp, &page_list, lru) {
> > -
> 
> Here we can just add:
> 			if (err)
> 				goto skip;
> 			lock_page();
> 			...
> 			unlock_page();
> 		skip:
> 			list_del();
> 			__free_pages();
> 
> IMO, it's more neat, so if you have any objection, let me know.
> Otherwise, I'll handle this by myself. :)
> Thanks,
> 
> > -			lock_page(page);
> > -			if (unlikely(!PageUptodate(page))) {
> > -				err = -EIO;
> > -			} else {
> > -				rn = F2FS_NODE(page);
> > -				sum_entry->nid = rn->footer.nid;
> > -				sum_entry->version = 0;
> > -				sum_entry->ofs_in_node = 0;
> > -				sum_entry++;
> > +			if (!err) {

If we skip here, next round we will fill these summary page entries with
wrong info because we skip the code 'sum_entry++;'.

> > +				lock_page(page);
> > +				if (unlikely(!PageUptodate(page))) {
> > +					err = -EIO;
> > +				} else {
> > +					rn = F2FS_NODE(page);
> > +					sum_entry->nid = rn->footer.nid;
> > +					sum_entry->version = 0;
> > +					sum_entry->ofs_in_node = 0;
> > +					sum_entry++;
> > +				}
> > +				unlock_page(page);
> >  			}
> >
> >  			list_del(&page->lru);
> > -			unlock_page(page);
> >  			__free_pages(page, 0);
> >  		}

Maybe we should add code here.
			if (err)
				return err;

> >  	}
> > +
> >  	return err;
> >  }
> >
> > diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> > index 199c964..b3f8431 100644
> > --- a/fs/f2fs/segment.c
> > +++ b/fs/f2fs/segment.c
> > @@ -1160,9 +1160,12 @@ static int read_normal_summaries(struct f2fs_sb_info *sbi, int type)
> >  				ns->ofs_in_node = 0;
> >  			}
> >  		} else {
> > -			if (restore_node_summary(sbi, segno, sum)) {
> > +			int err;
> > +
> > +			err = restore_node_summary(sbi, segno, sum);
> > +			if (err) {
> >  				f2fs_put_page(new, 1);
> > -				return -EINVAL;
> > +				return err;
> >  			}
> >  		}
> >  	}
> 
> --
> Jaegeuk Kim
> Samsung
> 
> 
> ------------------------------------------------------------------------------
> Learn Graph Databases - Download FREE O'Reilly Book
> "Graph Databases" is the definitive new guide to graph databases and their
> applications. Written by three acclaimed leaders in the field,
> this first edition is now available. Download your free book today!
> http://p.sf.net/sfu/13534_NeoTech
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

