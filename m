Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab3JWDZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 23:25:11 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:12916 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459Ab3JWDZJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 23:25:09 -0400
X-AuditID: cbfee61b-b7fd56d000001fc6-86-5267418633ac
From: Chao Yu <chao2.yu@samsung.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?utf-8?B?J+iwreWnnSc=?= <shu.tan@samsung.com>
References: <000701cecf09$2b2a2280$817e6780$@samsung.com>
 <1382444612.992.67.camel@kjgkr>
In-reply-to: <1382444612.992.67.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH] f2fs: check all ones or zeros bitmap with
 integer data type for better mount performance
Date: Wed, 23 Oct 2013 11:23:52 +0800
Message-id: <000001cecf9f$7113b630$533b2290$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQDZIwqdT2gfBmAxVRhZqO8VDeOyHgI34Xxsm9sJ72A=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsVy+t9jAd02x/Qgg8O7FSyu7/rLZHFpkbvF
	nr0nWSwu75rDZtG68DyzA6vH7gWfmTz6tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoEr482r10wF
	G8QqFnVMZW1gvCXYxcjJISFgIrH/TDsjhC0mceHeerYuRi4OIYFFjBI9O/ewQjg/GCUePj/F
	BlLFJqAisbzjPxOILSIgLTHr0zwWkCJmgZmMEtumfwAbJSQQLbHySxuYzSmgIzFl7mJWEFtY
	oEri6dSr7CA2i4CqxOxb51hAbF4BS4lPc7+yQdiCEj8m3wOKcwANVZeYMiUXJMwsoC3x5N0F
	VohLFSR2nH3NCHGDlcTV5z+ZIWrEJTYeucUygVFoFpJJsxAmzUIyaRaSjgWMLKsYRVMLkguK
	k9JzjfSKE3OLS/PS9ZLzczcxgmPgmfQOxlUNFocYBTgYlXh4LdvTgoRYE8uKK3MPMUpwMCuJ
	8Db7AoV4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmy1DhQSSE8sSc1OTS1ILYLJMnFwSjUwWr+Z
	rfmuVOx9dMHfJ5WFbuuPzLdi0dey4TzM8f3gKwvxXdGrxdK6OooWufrmzuzfuMH7n6pvr/c6
	BXPpacxTT9f7+99U23I+2KT0/tHPxeGxYnznJUL41yaIC+vVvK+4PKnl1T1lq51OSi++Hf09
	5Wj2baOQuOcBwtX/bNzTfKdWHyuRUQ1RYinOSDTUYi4qTgQAMI3pa30CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Kim:

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Tuesday, October 22, 2013 8:24 PM
> To: Chao Yu
> Cc: linux-f2fs-devel@lists.sourceforge.net; linux-fsdevel@vger.kernel.org;
> linux-kernel@vger.kernel.org; 谭姝
> Subject: Re: [f2fs-dev] [PATCH] f2fs: check all ones or zeros bitmap with integer
> data type for better mount performance
> 
> Hi,
> 
> 2013-10-22 (화), 17:28 +0800, Chao Yu:
> > Previously, check_block_count check valid_map with bit data type in
> > common scenario that sit has all ones or zeros bitmap, it makes low
> > mount performance.
> > So let's check the special bitmap with integer data type instead of
> > the bit one.
> >
> > Signed-off-by: Tan Shu <shu.tan@samsung.com>
> > Signed-off-by: Yu Chao <chao2.yu@samsung.com>
> > ---
> >  fs/f2fs/segment.h |   13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> >
> > diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h index
> > 7f94d78..d43ab9f 100644
> > --- a/fs/f2fs/segment.h
> > +++ b/fs/f2fs/segment.h
> > @@ -543,6 +543,7 @@ static inline void check_block_count(struct
> > f2fs_sb_info *sbi,  {
> >  	struct f2fs_sm_info *sm_info = SM_I(sbi);
> >  	unsigned int end_segno = sm_info->segment_count - 1;
> > +	int *valid_map = (int *)raw_sit->valid_map;
> >  	int valid_blocks = 0;
> >  	int i;
> >
> > @@ -552,6 +553,19 @@ static inline void check_block_count(struct
> > f2fs_sb_info *sbi,
> >  	/* check boundary of a given segment number */
> >  	BUG_ON(segno > end_segno);
> >
> > +	/* check all ones or zeros valid_map */
> > +	if (GET_SIT_VBLOCKS(raw_sit) == 0) {
> > +		for (i = 0; i < SIT_VBLOCK_MAP_SIZE / sizeof(int); i++)
> 
> We cannot guarantee all the time that SIT_VBLOCK_MAP_SIZE is multiple of
> sizeof(int).
Well, It's really large changes for f2fs if SIT_VBLOCK_MAP_SIZE value is being modified.

> How about using memcmp() with __u8?
Do you mean that we can alloc all zeros or ones memory in SIT_VBLOCK_MAP_SIZE size,
then memcmp() it with sit bitmap by __u8?

> 
> > +			if (unlikely(valid_map[i] != 0))
> > +				BUG();
> > +		return;
> > +	} else if (GET_SIT_VBLOCKS(raw_sit) == sbi->blocks_per_seg) {
> > +		for (i = 0; i < SIT_VBLOCK_MAP_SIZE / sizeof(int); i++)
> > +			if (unlikely(valid_map[i] != -1))
> > +				BUG();
> > +		return;
> > +	}
> > +
> >  	/* check bitmap with valid block count */
> >  	for (i = 0; i < sbi->blocks_per_seg; i++)
> >  		if (f2fs_test_bit(i, raw_sit->valid_map))
> > ---
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-fsdevel" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> Jaegeuk Kim
> Samsung

