Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab3JXKJZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 06:09:25 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:33338 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754579Ab3JXKJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 06:09:22 -0400
X-IronPort-AV: E=Sophos;i="4.93,561,1378828800"; 
   d="scan'208";a="8849459"
Message-ID: <5268F075.3000206@cn.fujitsu.com>
Date: Thu, 24 Oct 2013 18:03:33 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Chao Yu <chao2.yu@samsung.com>
CC: jaegeuk.kim@samsung.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        =?UTF-8?B?J+iwreWnnSc=?= <shu.tan@samsung.com>
Subject: Re: [f2fs-dev] [PATCH V2] f2fs: check all ones or zeros bitmap with
 bitops for better mount performance
References: <000401ced092$28087a90$78196fb0$@samsung.com>
In-Reply-To: <000401ced092$28087a90$78196fb0$@samsung.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/24 18:06:46,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/24 18:06:47,
	Serialize complete at 2013/10/24 18:06:47
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yu,
On 10/24/2013 04:21 PM, Chao Yu wrote:

> Previously, check_block_count check valid_map with bit data type in common scenario that sit has all ones or zeros bitmap, it makes low mount performance.
> So let's check the special bitmap with integer data type instead of the bit one.
> 
> v2:
>     use find_next_bit_le/find_next_zero_bit_le for better performance and readable as Jaegeuk suggested.

If so, how about using find_first_{zero_}bit_le instead? It's more neat.

Regards,
Gu

> 
> Suggested-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> Signed-off-by: Tan Shu <shu.tan@samsung.com>
> Signed-off-by: Yu Chao <chao2.yu@samsung.com>
> ---
>  fs/f2fs/segment.h |   17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
> index 7f94d78..d25b6af 100644
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


