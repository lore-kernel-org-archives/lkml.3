Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab3JYBfu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 21:35:50 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:50772 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab3JYBfs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 21:35:48 -0400
X-AuditID: cbfee61a-b7f836d0000025d7-6d-5269caf22c06
From: Chao Yu <chao2.yu@samsung.com>
To: "'Gu Zheng'" <guz.fnst@cn.fujitsu.com>
Cc: jaegeuk.kim@samsung.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        =?utf-8?B?J+iwreWnnSc=?= <shu.tan@samsung.com>
References: <000401ced092$28087a90$78196fb0$@samsung.com>
 <5268F075.3000206@cn.fujitsu.com>
In-reply-to: <5268F075.3000206@cn.fujitsu.com>
Subject: RE: [f2fs-dev] [PATCH V2] f2fs: check all ones or zeros bitmap with
 bitops for better mount performance
Date: Fri, 25 Oct 2013 09:34:46 +0800
Message-id: <000001ced122$86c53f10$944fbd30$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJ6i6Dfb3BtsZq0jPxXbIKcIyyc4QKSIF3bmJia0gA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsVy+t9jQd1PpzKDDI5cF7Z43n6A2eL6rr9M
	FpcWuVvs2XuSxeLyrjlsFq0LzzM7sHn8PziJ2WP3gs9MHn1bVjF6fN4kF8ASxWWTkpqTWZZa
	pG+XwJXR9fYpa8EqoYquU1sYGxj38XUxcnJICJhI3NmyjhHCFpO4cG89WxcjF4eQwHRGiY3f
	FrNCOD8YJeYees4EUsUmoCKxvOM/mC0ioCExbep+JpAiZoEtjBIfliwH6uAA6oiVWLWvAKSG
	U0BP4tnkRWwgtrBAkcSflv3MIDaLgKrEsW3/wTbzClhK/Hq2jBXCFpT4MfkeC8gYZgF1iSlT
	ckHCzALaEk/eXWCFOFRBYsfZ14wQJ1hJnDi6mRmiRlxi45FbLBMYhWYhmTQLYdIsJJNmIelY
	wMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4Kp5J7WBc2WBxiFGAg1GJhzdhRmaQEGti
	WXFl7iFGCQ5mJRHe0lVAId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwHWq0DhQTSE0tSs1NTC1KL
	YLJMHJxSDYwrpy+4MzEmumzrhueza0JKQ2O/ZV/cfGpP0Yx/+VyVNbN6L2evn6SzZ/vWVewR
	E+ZzdsxXq5+2Lr7dVumRo7nNzic2uyo6I0WZkkQiq8OrFy1nFL+mwHj8CMMaN/7SrkX3H985
	cldSujf/M//EAOew/sNqzPWzn+xtnHB3YZhV62ebrTZP2gKUWIozEg21mIuKEwGDZpSihgIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gu,

> -----Original Message-----
> From: Gu Zheng [mailto:guz.fnst@cn.fujitsu.com]
> Sent: Thursday, October 24, 2013 6:04 PM
> To: Chao Yu
> Cc: jaegeuk.kim@samsung.com; linux-fsdevel@vger.kernel.org;
> linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net; '谭姝'
> Subject: Re: [f2fs-dev] [PATCH V2] f2fs: check all ones or zeros bitmap with
> bitops for better mount performance
> 
> Hi Yu,
> On 10/24/2013 04:21 PM, Chao Yu wrote:
> 
> > Previously, check_block_count check valid_map with bit data type in common
> scenario that sit has all ones or zeros bitmap, it makes low mount
> performance.
> > So let's check the special bitmap with integer data type instead of the bit one.
> >
> > v2:
> >     use find_next_bit_le/find_next_zero_bit_le for better performance and
> readable as Jaegeuk suggested.
> 
> If so, how about using find_first_{zero_}bit_le instead? It's more neat.
It seems more neat. I will take it, thanks.

> 
> Regards,
> Gu
> 
> >
> > Suggested-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> > Signed-off-by: Tan Shu <shu.tan@samsung.com>
> > Signed-off-by: Yu Chao <chao2.yu@samsung.com>
> > ---
> >  fs/f2fs/segment.h |   17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
> >
> > diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h index
> > 7f94d78..d25b6af 100644
> > --- a/fs/f2fs/segment.h
> > +++ b/fs/f2fs/segment.h
> > @@ -552,6 +552,23 @@ static inline void check_block_count(struct
> f2fs_sb_info *sbi,
> >  	/* check boundary of a given segment number */
> >  	BUG_ON(segno > end_segno);
> >
> > +	/* check all ones or zeros valid_map */
> > +	if (GET_SIT_VBLOCKS(raw_sit) == 0) {
> > +		int pos = find_next_bit_le(&raw_sit->valid_map,
> > +					sbi->blocks_per_seg,
> > +					0);
> > +		if (pos != sbi->blocks_per_seg)
> > +			BUG();
> > +		return;
> > +	} else if (GET_SIT_VBLOCKS(raw_sit) == sbi->blocks_per_seg) {
> > +		int pos = find_next_zero_bit_le(&raw_sit->valid_map,
> > +					sbi->blocks_per_seg,
> > +					0);
> > +		if (pos != sbi->blocks_per_seg)
> > +			BUG();
> > +		return;
> > +	}
> > +
> >  	/* check bitmap with valid block count */
> >  	for (i = 0; i < sbi->blocks_per_seg; i++)
> >  		if (f2fs_test_bit(i, raw_sit->valid_map))


