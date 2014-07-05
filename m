Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbaGEGnR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 02:43:17 -0400
Received: from mail.kernel.org ([198.145.19.201]:53231 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856AbaGEGnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 02:43:15 -0400
Date: Fri, 4 Jul 2014 23:43:13 -0700
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Chao Yu <chao2.yu@samsung.com>
Cc: Changman Lee <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [f2fs-dev][PATCH 1/2] f2fs: check name_len of dir entry to
 prevent from deadloop
Message-ID: <20140705064313.GA35795@jmac.local>
References: <000001cf95b5$eac71ad0$c0555070$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001cf95b5$eac71ad0$c0555070$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chao,

On Wed, Jul 02, 2014 at 01:23:47PM +0800, Chao Yu wrote:
> We assume that modification of some special application could result in zeroed
> name_len, or it is consciously made by somebody. We will deadloop in
> find_in_block when name_len of dir entry is zero.

Could you explain this a little bit more?
I'm not sure how it can happen.
I think the zeroed name_len would cause some problems in f2fs_add_link.

Thanks,

> 
> This patch is added for preventing deadloop in above scenario.
> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/f2fs/dir.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
> index be8c7af..4316ec5 100644
> --- a/fs/f2fs/dir.c
> +++ b/fs/f2fs/dir.c
> @@ -121,6 +121,16 @@ static struct f2fs_dir_entry *find_in_block(struct page *dentry_page,
>  			}
>  		}
>  
> +		/* check name_len to prevent from deadloop here */
> +		if (unlikely(de->name_len == 0)) {
> +			struct inode *inode = dentry_page->mapping->host;
> +
> +			f2fs_msg(inode->i_sb, KERN_ERR,
> +				"zero-length dir entry, ino = %lu, name = %s",
> +				(unsigned long)inode->i_ino, name->name);
> +			break;
> +		}
> +
>  		bit_start = bit_pos
>  				+ GET_DENTRY_SLOTS(le16_to_cpu(de->name_len));
>  	}
> -- 
> 1.7.9.5

-- 
Jaegeuk Kim
