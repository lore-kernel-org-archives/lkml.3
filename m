Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbaE0Iup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 04:50:45 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:48800 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbaE0Iul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 04:50:41 -0400
X-AuditID: cbfee61b-b7fbb6d000001be3-80-538451de449e
From: Chao Yu <chao2.yu@samsung.com>
To: "'Changman Lee'" <cm224.lee@samsung.com>
Cc: "'Jaegeuk Kim'" <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
References: <00f601cf7948$1263a480$372aed80$@samsung.com>
 <20140527062307.GB4886@cm224.lee>
In-reply-to: <20140527062307.GB4886@cm224.lee>
Subject: RE: [f2fs-dev] [PATCH] f2fs: avoid overflow when large directory
 feathure is enabled
Date: Tue, 27 May 2014 16:49:49 +0800
Message-id: <010701cf7988$bc218420$34648c60$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQLARk+s/Gy8LVAXYjPcNN6ljA7IuwJGpqrtmWBNa/A=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t9jAd37gS3BBp+Xslpc29fIZHF9118m
	i0uL3C327D3JYnF51xw2B1aP3Qs+M3n0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXxoHv4QVX
	xCu67vxhb2CcINzFyMkhIWAi8aavhRXCFpO4cG89WxcjF4eQwCJGid7Nh9khnB+MEvN+tjOD
	VLEJqEgs7/jPBGKLCGhJ7O/pZgEpYhaYxCix5GczC0hCSCBWYt+pz2BjOQX0JLrermcHsYUF
	4iWmvlkDZrMIqEqc//EdbBCvgKVEx26Iel4BQYkfk++BzWEGWrB+53EmCFteYvOat8wQpypI
	7Dj7mhHiCCuJhz3L2CBqxCU2HrnFMoFRaBaSUbOQjJqFZNQsJC0LGFlWMYqmFiQXFCel5xrp
	FSfmFpfmpesl5+duYgRHwTPpHYyrGiwOMQpwMCrx8E7wbQ4WYk0sK67MPcQowcGsJMLb6dIS
	LMSbklhZlVqUH19UmpNafIhRmoNFSZz3YKt1oJBAemJJanZqakFqEUyWiYNTqoGx9nhCnChD
	+ZplK33ZLgsasN7UW8K78I7Ax/lV6eU2X2c8ClHker8+V8PPKX5S4dvMPUZ7Toes6+LnO6mc
	v9n7jP5xM4evlo/37wooajq6ccbSJHbdCYuL1QUnT5x49K7Ve++vhvoXWPrWvtOaraftdTRi
	2Sfr+pTm37UZshZvM6/ldWp+Ov1GiaU4I9FQi7moOBEAFYqiV34CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi changman,

> -----Original Message-----
> From: Changman Lee [mailto:cm224.lee@samsung.com]
> Sent: Tuesday, May 27, 2014 2:23 PM
> To: Chao Yu
> Cc: Jaegeuk Kim; linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Subject: Re: [f2fs-dev] [PATCH] f2fs: avoid overflow when large directory feathure is enabled
> 
> Hi, Chao
> Good catch. Please, modify Documentation/filesytems/f2fs.txt

Thank you for reminding me, I will add modification of f2fs.txt in the patch later.

> 
> On Tue, May 27, 2014 at 09:06:52AM +0800, Chao Yu wrote:
> > When large directory feathure is enable, We have one case which could cause
> > overflow in dir_buckets() as following:
> > special case: level + dir_level >= 32 and level < MAX_DIR_HASH_DEPTH / 2.
> >
> > Here we define MAX_DIR_BUCKETS to limit the return value when the condition
> > could trigger potential overflow.
> >
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> >  fs/f2fs/dir.c           |    4 ++--
> >  include/linux/f2fs_fs.h |    3 +++
> >  2 files changed, 5 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
> > index c3f1485..966acb0 100644
> > --- a/fs/f2fs/dir.c
> > +++ b/fs/f2fs/dir.c
> > @@ -23,10 +23,10 @@ static unsigned long dir_blocks(struct inode *inode)
> >
> >  static unsigned int dir_buckets(unsigned int level, int dir_level)
> >  {
> > -	if (level < MAX_DIR_HASH_DEPTH / 2)
> > +	if (level + dir_level < MAX_DIR_HASH_DEPTH / 2)
> >  		return 1 << (level + dir_level);
> >  	else
> > -		return 1 << ((MAX_DIR_HASH_DEPTH / 2 + dir_level) - 1);
> > +		return MAX_DIR_BUCKETS;
> >  }
> >
> >  static unsigned int bucket_blocks(unsigned int level)
> > diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
> > index 8c03f71..ba6f312 100644
> > --- a/include/linux/f2fs_fs.h
> > +++ b/include/linux/f2fs_fs.h
> > @@ -394,6 +394,9 @@ typedef __le32	f2fs_hash_t;
> >  /* MAX level for dir lookup */
> >  #define MAX_DIR_HASH_DEPTH	63
> >
> > +/* MAX buckets in one level of dir */
> > +#define MAX_DIR_BUCKETS		(1 << ((MAX_DIR_HASH_DEPTH / 2) - 1))
> > +
> >  #define SIZE_OF_DIR_ENTRY	11	/* by byte */
> >  #define SIZE_OF_DENTRY_BITMAP	((NR_DENTRY_IN_BLOCK + BITS_PER_BYTE - 1) / \
> >  					BITS_PER_BYTE)
> > --
> > 1.7.10.4
> >
> >
> >
> > ------------------------------------------------------------------------------
> > The best possible search technologies are now affordable for all companies.
> > Download your FREE open source Enterprise Search Engine today!
> > Our experts will assist you in its installation for $59/mo, no commitment.
> > Test it for FREE on our Cloud platform anytime!
> > http://pubads.g.doubleclick.net/gampad/clk?id=145328191&iu=/4140/ostg.clktrk
> > _______________________________________________
> > Linux-f2fs-devel mailing list
> > Linux-f2fs-devel@lists.sourceforge.net
> > https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

