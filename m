Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab3AKKTF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 05:19:05 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:38103 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751954Ab3AKKTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 05:19:04 -0500
X-Greylist: delayed 388 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Jan 2013 05:19:04 EST
Message-ID: <50EFE581.3070309@tao.ma>
Date: Fri, 11 Jan 2013 18:12:17 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: "Theodore Ts'o" <tytso@mit.edu>, Tao Ma <boyu.mt@taobao.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: Fix memory leak in ext4_init_new_dir
References: <20130111100639.GA3302@suse.de>
In-Reply-To: <20130111100639.GA3302@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 182.92.247.2 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

Thanks for the report.

This bug is already spotted by Guo Chao and the patch has been accepted
by Ted already.

Thanks,
Tao
On 01/11/2013 06:06 PM, Mel Gorman wrote:
> Commit a774f9c2 "ext4: make ext4_init_dot_dotdot for inline dir usage"
> is a preparation cleanup for later ext4 patches but there was a snag
> when moving code to the newly created ext4_init_new_dir() function.
> ext4_bread() is called twice but brelse() is only called one leading to a
> memory leak. The user-visible effect is that after a compile-orientated
> benchmark 0% of memory could be allocated as transparent huge pages.
> This patch deletes the extra call and after it is applied, 76% of memory
> could be allocated after the same test.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> ---
>  fs/ext4/namei.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 8990165..d068885 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -2368,7 +2368,6 @@ static int ext4_init_new_dir(handle_t *handle, struct inode *dir,
>  	}
>  
>  	inode->i_size = EXT4_I(inode)->i_disksize = blocksize;
> -	dir_block = ext4_bread(handle, inode, 0, 1, &err);
>  	if (!(dir_block = ext4_bread(handle, inode, 0, 1, &err))) {
>  		if (!err) {
>  			err = -EIO;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

