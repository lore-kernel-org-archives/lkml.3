Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab3KWCyN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 21:54:13 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:44341 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755981Ab3KWCyJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 21:54:09 -0500
X-AuditID: cbfee61a-b7f4b6d00000761f-df-529018cfbca4
From: Chao Yu <chao2.yu@samsung.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?utf-8?B?J+iwreWnnSc=?= <shu.tan@samsung.com>
References: <000301cee71f$b0e54160$12afc420$@samsung.com>
 <1385111441.26319.81.camel@kjgkr>
In-reply-to: <1385111441.26319.81.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH V3 2/2] f2fs: read contiguous sit entry pages by
 merging for mount performance
Date: Sat, 23 Nov 2013 10:53:16 +0800
Message-id: <000c01cee7f7$471c04c0$d5540e40$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQK5ip1hYVBPavTw3v39qs6NCq5t6wD/f1vamFTaLBA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsVy+t9jAd3zEhOCDDbt5re4vusvk8WlRe4W
	e/aeZLG4vGsOm0XrwvPMDqweuxd8ZvLo27KK0ePzJrkA5igum5TUnMyy1CJ9uwSujLWnmhkL
	ZgtVfPp4hb2B8RxfFyMnh4SAicSP/nesELaYxIV769m6GLk4hAQWMUos+/eRBcL5wSjR13uN
	CaSKTUBFYnnHfzBbREBaYtaneWBFzAKzGSV6vjxjBEkICcRKrL35gwXE5hTQk9iwpBGsQVgg
	X2LqjhvsXYwcHCwCqhK3u6NAwrwClhIXtl5mhbAFJX5MvscCUsIsoC4xZUouSJhZQFviybsL
	UIcqSOw4+5oR4gQriXV39rBC1IhLbDxyi2UCo9AsJJNmIUyahWTSLCQdCxhZVjGKphYkFxQn
	peca6hUn5haX5qXrJefnbmIER8AzqR2MKxssDjEKcDAq8fAK2PQFCbEmlhVX5h5ilOBgVhLh
	nf+6P0iINyWxsiq1KD++qDQntfgQozQHi5I474FW60AhgfTEktTs1NSC1CKYLBMHp1QDo8OK
	e7y3+g733ZC9YHXi+JfNnU5aXO90Gi1uXHQrd48/cvZhmtSfhD+5H5Ys6pn7KHXXbpW0jDUP
	VkhHyyst5HModzt9ao3J8xkTPxzcsUrgzJ2bC67P3qhe5LxJICR11/wHiecrJp3XmvE3sz3w
	fCbjlY3r0nj+3JhZEGr0RGqdV5eCwcGEC4pKLMUZiYZazEXFiQDLMbuqfAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Friday, November 22, 2013 5:11 PM
> To: Chao Yu
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net; 谭姝
> Subject: Re: [f2fs-dev] [PATCH V3 2/2] f2fs: read contiguous sit entry pages by merging for mount performance
> 
> Hi,
> 
> Just one niptick.
> 
> 2013-11-22 (금), 09:09 +0800, Chao Yu:
> > Previously we read sit entries page one by one, this method lost the chance
> > of reading contiguous page together. So we read pages as contiguous as
> > possible for better mount performance.
> >
> > change log:
> >  o merge judgements/use 'Continue' or 'Break' instead of 'Goto' as Gu Zheng
> >    suggested.
> >  o add mark_page_accessed() before release page to delay VM reclaiming.
> >  o remove '*order' for simplification of function as Jaegeuk Kim suggested.
> >
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> >  fs/f2fs/segment.c |  103 +++++++++++++++++++++++++++++++++++++++--------------
> >  fs/f2fs/segment.h |    2 ++
> >  2 files changed, 78 insertions(+), 27 deletions(-)
> >
> > diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> > index 8149eba..998e7d3 100644
> > --- a/fs/f2fs/segment.c
> > +++ b/fs/f2fs/segment.c
> > @@ -14,6 +14,7 @@
> >  #include <linux/blkdev.h>
> >  #include <linux/prefetch.h>
> >  #include <linux/vmalloc.h>
> > +#include <linux/swap.h>
> >
> >  #include "f2fs.h"
> >  #include "segment.h"
> > @@ -1488,41 +1489,89 @@ static int build_curseg(struct f2fs_sb_info *sbi)
> >  	return restore_curseg_summaries(sbi);
> >  }
> >
> > +static int ra_sit_pages(struct f2fs_sb_info *sbi, int start, int nrpages)
> > +{
> > +	struct address_space *mapping = sbi->meta_inode->i_mapping;
> > +	struct page *page;
> > +	block_t blk_addr, prev_blk_addr = 0;
> > +	int sit_blk_cnt = SIT_BLK_CNT(sbi);
> 
> Can we remove SIT_BLK_CNT by replacing with sit_i->sit_blocks?

Because sit_i->sit_blocks is a multiple of segment size(i.e. 512/1024),
but we may use part of sit_blocks, not all of them. So it's waste to read 
all of them.
What's your opinion?

Regards,
Yu

> 
> --
> Jaegeuk Kim
> Samsung

