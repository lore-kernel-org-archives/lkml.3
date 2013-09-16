Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381Ab3IPD1F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 23:27:05 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:23175 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab3IPD1D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 23:27:03 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-72-52367a8410fa
From: Chao Yu <chao2.yu@samsung.com>
To: "'Gu Zheng'" <guz.fnst@cn.fujitsu.com>
Cc: "'Kim Jaegeuk'" <jaegeuk.kim@gmail.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?gb2312?B?J8y35q0n?= <shu.tan@samsung.com>
References: <000301ceb085$13189480$3949bd80$@samsung.com>
 <5236684C.6020606@cn.fujitsu.com>
In-reply-to: <5236684C.6020606@cn.fujitsu.com>
Subject: Re: [f2fs-dev][PATCH RESEND] f2fs: avoid allocating failure in
 bio_alloc
Date: Mon, 16 Sep 2013 11:26:05 +0800
Message-id: <000001ceb28c$9b293e20$d17bba60$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQKy8BC/mx3zsQcmWkc5BPvarxGQ4gGxOklPl/GihxA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRmVeSWpSXmKPExsVy+t9jQd3WKrMggxNbGC2etx9gtrh9ZRKL
	xaVF7hZ79p5ksbi8aw6bRevC88wObB7/D05i9tg56y67x+4Fn5k8+rasYvT4vEkugDWKyyYl
	NSezLLVI3y6BK2PHg/dMBUdkKk5fvsTSwLhLtIuRk0NCwERiyt957BC2mMSFe+vZuhi5OIQE
	pjNKTJ1xlR3C+cEocXDCRGaQKjYBFYnlHf+ZQGwRAQ2JaVP3M4EUMQvsZ5RYcO8h2CghgViJ
	beuOgjVwCuhJnOnsBLOFBYIlnu87wApiswioSuzfugWsnlfAUuLB4042CFtQ4sfkeywgNjPQ
	gv5FG9ggbG2JJ+8usEKcqiCx4+xrRogjrCS2veplh6gRl9h45BbLBEahWUhGzUIyahaSUbOQ
	tCxgZFnFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERwlz6R3MK5qsDjEKMDBqMTDa6BpFiTE
	mlhWXJl7iFGCg1lJhDfaDyjEm5JYWZValB9fVJqTWnyIUZqDRUmc92CrdaCQQHpiSWp2ampB
	ahFMlomDU6qB0f5y25eLK9+uWVvCKCclpv3u5cWAH49N7x95miHyLPP7kYRV585dy3IJ1uM1
	NL5/4t2hj47bU+xVF17dqbyORWDyO83uChOPF1N78+8b1+WH1c/7kLSk2V3W1pkh+iTXu29f
	Fj8UNKjbURhoc/+WUOKe+qNF8YvncN+N+/qoe51/U/VCN8ukJCWW4oxEQy3mouJEAHRj9emO	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gu

> -----Original Message-----
> From: Gu Zheng [mailto:guz.fnst@cn.fujitsu.com]
> Sent: Monday, September 16, 2013 10:09 AM
> To: Chao Yu
> Cc: Kim Jaegeuk; linux-f2fs-devel@lists.sourceforge.net;
> linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; Ì·æ­
> Subject: Re: [f2fs-dev][PATCH RESEND] f2fs: avoid allocating failure in
bio_alloc
> 
> Hi Chao,
> 
> On 09/13/2013 09:27 PM, Chao Yu wrote:
> 
> > This patch add macro MAX_BIO_BLOCKS to limit value of npages in
> > f2fs_bio_alloc, it can avoid allocating failure in bio_alloc caused by
> > npages is larger than UIO_MAXIOV.
> 
> As I know bio_alloc is based of *fs_bio_set* pool, without the limitation
of
> UIO_MAXIOV, am I missing something?

Here is the code in bio.c, fs_bio_set is as the actual parameter pass to bs
without being inited.
So it may have opportunity to return NULL in this function.
---
Bio.c 
struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set
*bs)
{
......
	if (!bs) {
		if (nr_iovecs > UIO_MAXIOV)
			return NULL;
---
I did the abnormal test: modify the max_sectors_kb in /sys/block/sdx/queue
to 32767 for a disk with f2fs format,
and I got a segfualt in f2fs_bio_alloc after the img mounted.
Is there anyting I missed?

> 
> Thanks,
> Gu
> 
> >
> > Signed-off-by: Yu Chao <chao2.yu@samsung.com>
> >  ---
> >  fs/f2fs/segment.c |    4 +++-
> >  fs/f2fs/segment.h |    3 +++
> >  2 files changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c index
> > 09af9c7..bd79bbe 100644
> > --- a/fs/f2fs/segment.c
> > +++ b/fs/f2fs/segment.c
> > @@ -657,6 +657,7 @@ static void submit_write_page(struct f2fs_sb_info
> > *sbi, struct page *page,
> >                                 block_t blk_addr, enum page_type
> type)
> > {
> >         struct block_device *bdev = sbi->sb->s_bdev;
> > +       int bio_blocks;
> >
> >         verify_block_addr(sbi, blk_addr);
> >
> > @@ -676,7 +677,8 @@ retry:
> >                         goto retry;
> >                 }
> >
> > -               sbi->bio[type] = f2fs_bio_alloc(bdev,
max_hw_blocks(sbi));
> > +               bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
> > +               sbi->bio[type] = f2fs_bio_alloc(bdev, bio_blocks);
> >                 sbi->bio[type]->bi_sector = SECTOR_FROM_BLOCK(sbi,
> > blk_addr);
> >                 sbi->bio[type]->bi_private = priv;
> >                 /*
> > diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h index
> > bdd10ea..6352af1 100644
> > --- a/fs/f2fs/segment.h
> > +++ b/fs/f2fs/segment.h
> > @@ -9,6 +9,7 @@
> >   * published by the Free Software Foundation.
> >   */
> >  #include <linux/blkdev.h>
> > +#include <linux/uio.h>
> >
> >  /* constant macro */
> >  #define NULL_SEGNO                     ((unsigned int)(~0))
> > @@ -90,6 +91,8 @@
> >         (blk_addr << ((sbi)->log_blocksize - F2FS_LOG_SECTOR_SIZE))
> >  #define SECTOR_TO_BLOCK(sbi, sectors)
> \
> >         (sectors >> ((sbi)->log_blocksize - F2FS_LOG_SECTOR_SIZE))
> > +#define MAX_BIO_BLOCKS(max_hw_blocks)
> \
> > +       (min((int)max_hw_blocks, UIO_MAXIOV))
> >
> >  /* during checkpoint, bio_private is used to synchronize the last bio
> > */  struct bio_private {
> > ---
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-kernel" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >


