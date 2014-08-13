Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbaHMWzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 18:55:52 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:27988 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490AbaHMWzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 18:55:50 -0400
Date: Wed, 13 Aug 2014 15:55:43 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Chin-Tsung Cheng <chintzung@gmail.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: include journal blocks of internal journal in df
 overhead calcs
Message-ID: <20140813225543.GK2808@birch.djwong.org>
References: <1407937043-23186-1-git-send-email-chintzung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407937043-23186-1-git-send-email-chintzung@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 09:37:23PM +0800, Chin-Tsung Cheng wrote:
> The journal blocks of external journal device should not
> be counted as overhead.
> 
> Signed-off-by: Chin-Tsung Cheng <chintzung@gmail.com>
> ---
>  fs/ext4/super.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 32b43ad..03b2f62 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3316,9 +3316,10 @@ int ext4_calculate_overhead(struct super_block *sb)
>  			memset(buf, 0, PAGE_SIZE);
>  		cond_resched();
>  	}
> -	/* Add the journal blocks as well */
> -	if (sbi->s_journal)
> -		overhead += EXT4_NUM_B2C(sbi, sbi->s_journal->j_maxlen);
> +	/* Add the internal journal blocks as well */
> +	if ((sbi->s_journal) &&
> +		(sbi->s_journal->j_fs_dev == sbi->s_journal->j_dev))
> +			overhead += EXT4_NUM_B2C(sbi, sbi->s_journal->j_maxlen);

I think you have some whitespace issues here, but otherwise this seems ok.

External journals aren't counted towards the total blocks count, correct?

--D
>  
>  	sbi->s_overhead = overhead;
>  	smp_wmb();
> -- 
> 1.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
