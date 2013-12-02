Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab3LBJAV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 04:00:21 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:29053 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab3LBJAU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 04:00:20 -0500
X-AuditID: cbfee61b-b7f166d000007a34-80-529c4c2223d1
From: Chao Yu <chao2.yu@samsung.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?UTF-8?B?J+iwreWnnSc=?= <shu.tan@samsung.com>
References: <1385776085-21163-1-git-send-email-jaegeuk.kim@samsung.com>
 <000201ceef25$e145cec0$a3d16c40$@samsung.com> <1385972094.2417.104.camel@kjgkr>
In-reply-to: <1385972094.2417.104.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH] f2fs: remove the own bi_private allocation
Date: Mon, 02 Dec 2013 16:59:28 +0800
Message-id: <000301ceef3c$ecee00a0$c6ca01e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGX/9NZphYaRjZNa5uMOVNLOkn7OgIOjC1XAgEHCL2ajfqOEA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsVy+t9jQV0lnzlBBrOWyFtc3/WXyeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aP3Qs+M3n0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXxqY5PYwF
	10Urdv1fw97AuF6wi5GTQ0LAROLOrV8sELaYxIV769lAbCGB6YwSv7fLQNg/GCUm96eC2GwC
	KhLLO/4zgdgiAtISsz7NA+tlFpjNKLF5tmMXIxdQ/UxGiZd/esASnAJ6Egs61zCD2MICXhIN
	p96xg9gsAqoSPW+vgMV5BSwlmu98Y4OwBSV+TL4HNVRdYtK8RcwQtrbEk3cXWCEOVZDYcfY1
	I8QRThK7/syCqheX2HjkFssERqFZSEbNQjJqFpJRs5C0LGBkWcUomlqQXFCclJ5rpFecmFtc
	mpeul5yfu4kRHAPPpHcwrmqwOMQowMGoxMN74cTsICHWxLLiytxDjBIczEoivCx/gUK8KYmV
	ValF+fFFpTmpxYcYpTlYlMR5D7ZaBwoJpCeWpGanphakFsFkmTg4pRoYS1arr5yx9qdAcPtf
	I07psqMvnvkxC5g+VJUxiqpxN7I0uVXw7Jy7491ogQeyrsXJ+WfDq6p6Vx1eYhIScLMrYInu
	tL0ai/wZU3e27YzVVf65ZDqXUfWMU3qfFDJrIiTS7nDFqW/i8rLe+/fyBdtjfI/6L/zUrat6
	w3/W3emQBNOx9eyXNKOVWIozEg21mIuKEwHLwIq+fQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Monday, December 02, 2013 4:15 PM
> To: Chao Yu
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net; 谭姝
> Subject: RE: [f2fs-dev] [PATCH] f2fs: remove the own bi_private allocation
> 
> 2013-12-02 (월), 14:14 +0800, Chao Yu:
> > Hi Kim,
> >
> > > -----Original Message-----
> > > From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> > > Sent: Saturday, November 30, 2013 9:48 AM
> > > Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net
> > > Subject: [f2fs-dev] [PATCH] f2fs: remove the own bi_private allocation
> > >
> > > Previously f2fs allocates its own bi_private data structure all the time even
> > > though we don't use it. But, can we remove this bi_private allocation?
> > >
> > > This patch removes such the additional bi_private allocation.
> > >
> > > 1. Retrieve f2fs_sb_info from its page->mapping->host->i_sb.
> > >  - This removes the usecases of bi_private in end_io.
> > >
> > > 2. Use bi_private only when we really need it.
> > >  - The bi_private is used only when the checkpoint procedure is conducted.
> > >  - When conducting the checkpoint, f2fs submits a META_FLUSH bio to wait its bio
> > > completion.
> > >  - Since we have no dependancies to remove bi_private now, let's just use
> > >  bi_private pointer as the completion pointer.
> > >
> > > Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> > > ---
> > >  fs/f2fs/segment.c | 43 ++++++++++++++++---------------------------
> > >  fs/f2fs/segment.h |  7 -------
> > >  2 files changed, 16 insertions(+), 34 deletions(-)
> > >
> > > diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> > > index 0387863..0db4027 100644
> > > --- a/fs/f2fs/segment.c
> > > +++ b/fs/f2fs/segment.c
> > > @@ -791,7 +791,7 @@ static void f2fs_end_io_write(struct bio *bio, int err)
> > >  {
> > >  	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
> > >  	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
> > > -	struct bio_private *p = bio->bi_private;

		f2fs_bug_on(unlikely(!bvec->bv_page->mapping));

> > > +	struct f2fs_sb_info *sbi = F2FS_SB(bvec->bv_page->mapping->host->i_sb);
> >
> > I'm not sure whether bvec->bv_page->mapping will be set to NULL in the flow
> > where may not check WRITEBACK flag of page. Is it possible?
> 
> The mapping should be not NULL cause it is a writebacking page.
> Otherwise, it's a bug.

If so, should we add additional code as above?

Regards,
Yu

> Thanks,
> 
> --
> Jaegeuk Kim
> Samsung

