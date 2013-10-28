Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab3J1ChC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 22:37:02 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:45628 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754546Ab3J1Cg6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 22:36:58 -0400
X-IronPort-AV: E=Sophos;i="4.93,582,1378828800"; 
   d="scan'208";a="8873666"
Message-ID: <526DCC5C.30808@cn.fujitsu.com>
Date: Mon, 28 Oct 2013 10:30:52 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: =?UTF-8?B?7J207LC966eM?= <cm224.lee@samsung.com>
CC: "'Chao Yu'" <chao2.yu@samsung.com>, jaegeuk.kim@samsung.com,
        linux-fsdevel@vger.kernel.org,
        =?UTF-8?B?J+iwreWnnSc=?= <shu.tan@samsung.com>,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH V2] f2fs: check all ones or zeros bitmap with
 bitops for better mount performance
References: <000401ced092$28087a90$78196fb0$@samsung.com> <003501ced384$31fb7530$95f25f90$@samsung.com>
In-Reply-To: <003501ced384$31fb7530$95f25f90$@samsung.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/28 10:35:11,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/28 10:35:13
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2013 10:19 AM, 이창만 wrote:

> To check whether bitmap are all zeros or all ones, I think memcmp is more neat.
> But I don't know exactly performance gap between memcmp and find_next_bit.

According to my understanding,
memcmp: one by one search,
find_next_bit: binary search.

Regards,
Gu

> 
> 
> -----Original Message-----
> From: Chao Yu [mailto:chao2.yu@samsung.com] 
> Sent: Thursday, October 24, 2013 5:21 PM
> To: jaegeuk.kim@samsung.com
> Cc: linux-fsdevel@vger.kernel.org; '谭姝'; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net
> Subject: [f2fs-dev] [PATCH V2] f2fs: check all ones or zeros bitmap with bitops for better mount performance
> 
> Previously, check_block_count check valid_map with bit data type in common scenario that sit has all ones or zeros bitmap, it makes low mount performance.
> So let's check the special bitmap with integer data type instead of the bit one.
> 
> v2:
>     use find_next_bit_le/find_next_zero_bit_le for better performance and readable as Jaegeuk suggested.
> 
> Suggested-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> Signed-off-by: Tan Shu <shu.tan@samsung.com>
> Signed-off-by: Yu Chao <chao2.yu@samsung.com>
> ---
>  fs/f2fs/segment.h |   17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h index 7f94d78..d25b6af 100644
> --- a/fs/f2fs/segment.h
> +++ b/fs/f2fs/segment.h
> @@ -552,6 +552,23 @@ static inline void check_block_count(struct f2fs_sb_info *sbi,
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
> http://pubads.g.doubleclick.net/gampad/clk?id=60135991&iu=/4140/ostg.clktrk
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


