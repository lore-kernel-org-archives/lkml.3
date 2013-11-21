Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488Ab3KUGjD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 01:39:03 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:21658 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab3KUGjB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 01:39:01 -0500
X-AuditID: cbfee61a-b7f836d0000025d7-42-528daa775da7
From: Chao Yu <chao2.yu@samsung.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?UTF-8?B?J+iwreWnnSc=?= <shu.tan@samsung.com>
References: <001d01cee5bc$779c2fe0$66d48fa0$@samsung.com>
 <1384997517.26319.60.camel@kjgkr>
 <000001cee668$872ec6a0$958c53e0$@samsung.com> <1385009132.26319.71.camel@kjgkr>
In-reply-to: <1385009132.26319.71.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH V2 2/2 RESEND] f2fs: read contiguous sit entry
 pages by merging for mount performance
Date: Thu, 21 Nov 2013 14:37:57 +0800
Message-id: <000201cee684$550e11a0$ff2a34e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIJ19KASf8zRPdVedlp8ddtfrYm2AK+Dn7CAcqcVCkBpqPD+ZmH0ErA
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t9jQd3yVb1BBl9uG1tc3/WXyeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aP3Qs+M3n0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXxt3bW1gL
	eqUrjrxsYmxgnCHaxcjJISFgIjGr4TIThC0mceHeejYQW0hgOqPEn//pXYxcQPYPRomJN68x
	giTYBFQklnf8B2sQEZCWmPVpHguIzSwwm1Fi82xHiIb1jBJNnw+AJTgF9CQeLz3GDmILC5RJ
	fFn6jBnEZhFQlXh15D3YIF4BS4m9i3vYIGxBiR+T70ENVZeYNG8RM4StLfHk3QVWiEsVJHac
	fc0IcYSbxM/T09ghasQlNh65xTKBUWgWklGzkIyahWTULCQtCxhZVjGKphYkFxQnpeca6hUn
	5haX5qXrJefnbmIER8EzqR2MKxssDjEKcDAq8fB2PO4JEmJNLCuuzD3EKMHBrCTCWzy/N0iI
	NyWxsiq1KD++qDQntfgQozQHi5I474FW60AhgfTEktTs1NSC1CKYLBMHp1QDY9H2fY8mR6fa
	doUsntfcsID5y1WVmKT3RWwpHN4PJPTb3TbvEjzxIJH57KVi29QHN/e+farUeYd99fk/FrKX
	Z1/1KVwuJjTX87eYZsqh2/cupQkW/7RcMLHLJsSZNU9hrtWTwAcFllbLM5RLTzRFtvsdetO/
	l3nnxS1uXGvlTm1UXbXktejKt0osxRmJhlrMRcWJAGA8Pep+AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Thursday, November 21, 2013 12:46 PM
> To: Chao Yu
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net; '谭姝'
> Subject: RE: [f2fs-dev] [PATCH V2 2/2 RESEND] f2fs: read contiguous sit entry pages by merging for mount performance
> 
> Hi,
> 
> 2013-11-21 (목), 11:18 +0800, Chao Yu:
> > Hi,
> >
> > > -----Original Message-----
> > > From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> > > Sent: Thursday, November 21, 2013 9:32 AM
> > > To: Chao Yu
> > > Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net; 谭姝
> > > Subject: Re: [f2fs-dev] [PATCH V2 2/2 RESEND] f2fs: read contiguous sit entry pages by merging for mount performance
> > >
> > > Hi,
> > >
> > > It seems that ra_sit_pages() is too tightly coupled with
> > > build_sit_entries().
> >
> > This code could be improved.
> >
> > > Is there another way not to use *is_order?
> >
> > Previously the code is like this:
> >  -build_sit_entries()
> >  next_setp:
> > 	for(start = 0; start < TOTAL_SEGS(sbi); start++)
> > 		/*step#1 readahead all sit entries blocks*/
> > 			if(start % SIT_ENTRY_PER_BLOCK == 0) {
> > 				blk_addr = current_sit_addr(sbi, start);
> > 				/* grab and submit_read_page */
> > 			}
> > 			if(start == TOTAL_SEGS(sbi) - 1)
> > 				f2fs_submit_read_bio();
> > 			continue;
> > 		/*step#2 fill sit entries info*/
> > 		/*step#3 cover sit entries with journal*/
> >
> > But I think its weakness is that it will cost lots of memory to read
> > ahead all sit entry pages when f2fs mount, and also it's serious waste
> > that we read them again after these pages are released by VM when
> > out of memory.
> >
> > >
> > > The ra_sit_pages() tries to read consecutive sit pages as many as
> > > possible.
> > > So then, what about just checking whether its block address is
> > > contiguous or not?
> > >
> > > Something like this:
> > >  -ra_sit_pages()
> > > 	blkno = start;
> > > 	while (blkno < sit_i->sit_blocks) {
> > > 		blk_addr = current_sit_addr(sbi, blkno);
> > > 		if (blkno != start && prev_blk_addr + 1 != blk_addr)
> > > 			break;
> > >
> > > 		/* grab and submit_read_page */
> > >
> > > 		prev_blk_addr = blk_addr;
> > > 		blkno++;
> > > 	}
> >
> > Agreed, this method could remove *order.
> > Shouldn't we add nrpages for readahead policy as VM?
> 
> Aha, agreed.
> We need nrpages to avoid too many reads on sit blocks.
> 
> But, still it needs to change the nrpages in its caller.
> In your patch, it was sit_i->sit_blocks that is total # of sit blocks.
> I think 128 or 256 is quite reasonable number.

Hmm, Originally in [PATCH V1] it was be set to 
MAX_BIO_BLOCKS(max_hw_blocks(sbi)).

So it could be "#define SIT_ENTRIES_RA_NUM	128"?
BTW, maybe we should send dynamical nrpages which depend on 
memory state of system as I mention in previous thread.
How do you think?

> 
> Anyway, how about implementing ra_sit_pages() with a blk_plug likewise
> ra_node_pages()?

So we use this structure to plug multi bios submitting in ra_sit_pages(), right?
-build_sit_entries()
	blk_start_plug(&plug);
	ra_sit_pages();
	blk_finish_plug(&plug);

> 
> --
> Jaegeuk Kim
> Samsung

