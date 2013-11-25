Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab3KYBeL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 20:34:11 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:62125 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab3KYBeI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 20:34:08 -0500
X-AuditID: cbfee61b-b7f076d0000004f6-db-5292a90a395b
From: Chao Yu <chao2.yu@samsung.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?utf-8?B?J+iwreWnnSc=?= <shu.tan@samsung.com>
References: <000301cee71f$b0e54160$12afc420$@samsung.com>
 <1385267160.26319.98.camel@kjgkr>
In-reply-to: <1385267160.26319.98.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH V3 2/2] f2fs: read contiguous sit entry pages by
 merging for mount performance
Date: Mon, 25 Nov 2013 09:33:12 +0800
Message-id: <000e01cee97e$6b83e480$428bad80$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQK5ip1hYVBPavTw3v39qs6NCq5t6wI37MMMmE4nD6A=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsVy+t9jAV2ulZOCDD7O4Le4vusvk8WlRe4W
	e/aeZLG4vGsOm0XrwvPMDqweuxd8ZvLo27KK0ePzJrkA5igum5TUnMyy1CJ9uwSujO/LV7MU
	LBOueN3SxNzAOJe/i5GTQ0LARGLb3B/sELaYxIV769m6GLk4hAQWMUr83nucHcL5wSjR/Qck
	w8nBJqAisbzjPxOILSIgLTHr0zwWkCJmgdmMEj1fnjGCJIQEYiWmbpsFNpZTQE/i+J6fzCC2
	sEC+xNQdN8DiLAKqElPOTgGzeQUsJV7++gZlC0r8mHwPaCgH0FB1iSlTckHCzALaEk/eXWCF
	uFRBYsfZ14wQN1hJ7Lm5mR2iRlxi45FbLBMYhWYhmTQLYdIsJJNmIelYwMiyilE0tSC5oDgp
	PddIrzgxt7g0L10vOT93EyM4Bp5J72Bc1WBxiFGAg1GJh3di9aQgIdbEsuLK3EOMEhzMSiK8
	e+qAQrwpiZVVqUX58UWlOanFhxilOViUxHkPtloHCgmkJ5akZqemFqQWwWSZODilGhiTd0gH
	nT91k3enkPyFlRImvDv3mRudNt2t05L26gFXafmdlxWvN/gdOTblVOiLHb9PNXT3bhf0MXR5
	ZNFekMwovnzO0Q+vJeoX2DWrGDrMeOp5Uf11UP97oTD5aYc+7NTxaBJ9ru7vsWn/7IRVwlqz
	P4Sy9vYo/WF4teHR4ddVkau4xSaEbX2rxFKckWioxVxUnAgAea/8rX0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Sunday, November 24, 2013 12:26 PM
> To: Chao Yu
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net; 谭姝
> Subject: Re: [f2fs-dev] [PATCH V3 2/2] f2fs: read contiguous sit entry pages by merging for mount performance
> 
> Hi,
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
> > +	int blkno = start;
> > +
> > +	for (; blkno < start + nrpages && blkno < sit_blk_cnt; blkno++) {
> > +
> > +		blk_addr = current_sit_addr(sbi, start * SIT_ENTRY_PER_BLOCK);
> 
> Should be:
> 	blk_addr = current_sit_addr(sbi, blkno * SIT_ENTRY_PER_BLOCK);
> 	                                -------
> I'll fix this and merge the patch though.
> Thanks,

Oh, It's my mistake, sorry for that.
Thanks for your review! :)

> 
> --
> Jaegeuk Kim
> Samsung

