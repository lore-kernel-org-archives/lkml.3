Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab3J1HI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 03:08:27 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:58614 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab3J1HIZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 03:08:25 -0400
X-AuditID: cbfee61b-b7fd56d000001fc6-d6-526e0d67edbe
From: Chao Yu <chao2.yu@samsung.com>
To: =?utf-8?B?J+ydtOywveunjCc=?= <cm224.lee@samsung.com>,
        jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org,
        =?utf-8?B?J+iwreWnnSc=?= <shu.tan@samsung.com>,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
References: <000401ced092$28087a90$78196fb0$@samsung.com>
 <003501ced384$31fb7530$95f25f90$@samsung.com>
In-reply-to: <003501ced384$31fb7530$95f25f90$@samsung.com>
Subject: RE: [f2fs-dev] [PATCH V2] f2fs: check all ones or zeros bitmap with
 bitops for better mount performance
Date: Mon, 28 Oct 2013 15:07:11 +0800
Message-id: <000201ced3ac$799274c0$6cb75e40$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJ6i6Dfb3BtsZq0jPxXbIKcIyyc4QJUIYVRmJ9lAJA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t9jAd103rwgg93vRCyu7Wtksri+6y+T
	xaVF7hZ79p5ksbi8aw6bRevC88wObB67F3xm8ujbsorR4/MmuQDmKC6blNSczLLUIn27BK6M
	lq6z7AUvNStmn3jF1MD4Vr6LkZNDQsBE4tatRjYIW0ziwr31QDYXh5DAIkaJw41zoZwfjBLT
	pqxmB6liE1CRWN7xnwnEFhEIllgwZzEzSBGzwGxGiYWrd4AlhAQyJd6s2gZmcwpYSbQ0bGMF
	sYUFiiT+tOxnBrFZBFQlVn19CraaV8BSYs3vJywQtqDEj8n3gGwOoKHqElOm5IKEmQW0JZ68
	u8AKcamCxI6zrxkhbrCSuLNzCQtEjbjExiO3WCYwCs1CMmkWwqRZSCbNQtKxgJFlFaNoakFy
	QXFSeq6RXnFibnFpXrpecn7uJkZwNDyT3sG4qsHiEKMAB6MSD++GtblBQqyJZcWVuYcYJTiY
	lUR4+24BhXhTEiurUovy44tKc1KLDzFKc7AoifMebLUOFBJITyxJzU5NLUgtgskycXBKNTAu
	SYwRSth3K2q6zZrzlmFd556ureavnKGbclb06MGsCe1CeonzsjJfC7NovZ6VZcFV/Fqkscmz
	r9VhSdHCd+/mZ5s32my+VDVJ4imDpNgcxQ+6VgKm6/cY/ftewN9le7uBXXJl1NRH54uYonmL
	eQtbGo8vZqk6EWbVLXDmmwLvmrWbdb4/5FZiKc5INNRiLipOBABkdyx+ggIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

> -----Original Message-----
> From: 이창만 [mailto:cm224.lee@samsung.com]
> Sent: Monday, October 28, 2013 10:20 AM
> To: 'Chao Yu'; jaegeuk.kim@samsung.com
> Cc: linux-fsdevel@vger.kernel.org; '谭姝'; linux-kernel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Subject: RE: [f2fs-dev] [PATCH V2] f2fs: check all ones or zeros bitmap with
> bitops for better mount performance
> 
> To check whether bitmap are all zeros or all ones, I think memcmp is more
> neat.
> But I don't know exactly performance gap between memcmp and
> find_next_bit.

With the result of my test, find_next_bit takes less time than memcmp.
If we could use {test, set, clear}_bit_le intead of f2fs_{test, set, clear}_bit, the following patch
could be used for better performance.
This one is better than the V2 patch for performance with mixed bitmap in my test.

diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 7f94d78..32153eb
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -544,7 +544,8 @@ static inline void check_block_count(struct f2fs_sb_info *sbi,
        struct f2fs_sm_info *sm_info = SM_I(sbi);
        unsigned int end_segno = sm_info->segment_count - 1;
        int valid_blocks = 0;
-       int i;
+       int i, cur_pos = 0, next_pos;
+       bool is_valid;
 
        /* check segment usage */
        BUG_ON(GET_SIT_VBLOCKS(raw_sit) > sbi->blocks_per_seg);
@@ -553,9 +554,21 @@ static inline void check_block_count(struct f2fs_sb_info *sbi,
        BUG_ON(segno > end_segno);
 
        /* check bitmap with valid block count */
-       for (i = 0; i < sbi->blocks_per_seg; i++)
-               if (f2fs_test_bit(i, raw_sit->valid_map))
-                       valid_blocks++;
+       cur_pos = 0;
+       is_valid = test_bit_le(0, raw_sit->valid_map) ? true : false;
+       do {
+               if (is_valid) {
+                       next_pos = find_next_zero_bit_le(&raw_sit->valid_map,
+                                       sbi->blocks_per_seg,
+                                       cur_pos);
+                       valid_blocks += next_pos - cur_pos;
+               } else
+                       next_pos = find_next_bit_le(&raw_sit->valid_map,
+                                       sbi->blocks_per_seg,
+                                       cur_pos);
+               cur_pos = next_pos;
+               is_valid = !is_valid;
+       } while (cur_pos < sbi->blocks_per_seg);
        BUG_ON(GET_SIT_VBLOCKS(raw_sit) != valid_blocks);
 }
> 
> 
> -----Original Message-----
> From: Chao Yu [mailto:chao2.yu@samsung.com]
> Sent: Thursday, October 24, 2013 5:21 PM
> To: jaegeuk.kim@samsung.com
> Cc: linux-fsdevel@vger.kernel.org; '谭姝'; linux-kernel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Subject: [f2fs-dev] [PATCH V2] f2fs: check all ones or zeros bitmap with bitops
> for better mount performance
> 
> Previously, check_block_count check valid_map with bit data type in common
> scenario that sit has all ones or zeros bitmap, it makes low mount
> performance.
> So let's check the special bitmap with integer data type instead of the bit one.
> 
> v2:
>     use find_next_bit_le/find_next_zero_bit_le for better performance and
> readable as Jaegeuk suggested.
> 
> Suggested-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> Signed-off-by: Tan Shu <shu.tan@samsung.com>
> Signed-off-by: Yu Chao <chao2.yu@samsung.com>
> ---
>  fs/f2fs/segment.h |   17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h index 7f94d78..d25b6af
> 100644
> --- a/fs/f2fs/segment.h
> +++ b/fs/f2fs/segment.h
> @@ -552,6 +552,23 @@ static inline void check_block_count(struct
> f2fs_sb_info *sbi,
>  	/* check boundary of a given segment number */
>  	BUG_ON(segno > end_segno);
> 
> +	/* check all ones or zeros valid_map */
> +	if (GET_SIT_VBLOCKS(raw_sit) == 0) {
> +		int pos = find_next_bit_le(&raw_sit->valid_map,
> +					sbi->blocks_per_seg,
> +					0);
> +		if (pos != sbi->blocks_per_seg)
> +			BUG();
> +		return;
> +	} else if (GET_SIT_VBLOCKS(raw_sit) == sbi->blocks_per_seg) {
> +		int pos = find_next_zero_bit_le(&raw_sit->valid_map,
> +					sbi->blocks_per_seg,
> +					0);
> +		if (pos != sbi->blocks_per_seg)
> +			BUG();
> +		return;
> +	}
> +
>  	/* check bitmap with valid block count */
>  	for (i = 0; i < sbi->blocks_per_seg; i++)
>  		if (f2fs_test_bit(i, raw_sit->valid_map))
> --
> 1.7.9.5
> 
> 
> ------------------------------------------------------------------------------
> October Webinars: Code for Performance
> Free Intel webinars can help you accelerate application performance.
> Explore tips for MPI, OpenMP, advanced profiling, and more. Get the most from
> the latest Intel processors and coprocessors. See abstracts and register >
> http://pubads.g.doubleclick.net/gampad/clk?id=60135991&iu=/4140/ostg.clktr
> k
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

