Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbaGVKDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 06:03:39 -0400
Received: from smtp.ispras.ru ([83.149.199.79]:48810 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754534AbaGVKDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 06:03:38 -0400
Message-ID: <53CE3722.60307@ispras.ru>
Date: Tue, 22 Jul 2014 14:04:18 +0400
From: Andrey Tsyvarev <tsyvarev@ispras.ru>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
CC: Jaegeuk Kim <jaegeuk@kernel.org>, linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: Re: f2fs: Possible use-after-free when umount filesystem
References: <52F320FC.50803@ispras.ru> <534BC29B.3020408@ispras.ru> <53CCF1EC.30008@ispras.ru> <53CDC9AF.2050605@cn.fujitsu.com>
In-Reply-To: <53CDC9AF.2050605@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gu,

>> Investigation shows, that f2fs_evict_inode, when called for 'meta_inode', uses invalidate_mapping_pages() for 'node_inode'.
>> But 'node_inode' is deleted before 'meta_inode' in f2fs_put_super via iput().
>>
>> It seems that in common usage scenario this use-after-free is benign, because 'node_inode' remains partially valid data even after kmem_cache_free().
>> But things may change if, while 'meta_inode' is evicted in one f2fs filesystem, another (mounted) f2fs filesystem requests inode from cache, and formely
>> 'node_inode' of the first filesystem is returned.
> The analysis seems reasonable. Have you tried to swap the reclaim order of node_inde
> and meta_inode?
>
> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> index 870fe19..e114418 100644
> --- a/fs/f2fs/super.c
> +++ b/fs/f2fs/super.c
> @@ -430,8 +430,8 @@ static void f2fs_put_super(struct super_block *sb)
>          if (sbi->s_dirty && get_pages(sbi, F2FS_DIRTY_NODES))
>                  write_checkpoint(sbi, true);
>   
> -       iput(sbi->node_inode);
>          iput(sbi->meta_inode);
> +       iput(sbi->node_inode);
>   
>          /* destroy f2fs internal modules */
>          destroy_node_manager(sbi);
>
> Thanks,
> Gu

With reclaim order of node_inode and meta_inode swapped, use-after-free 
error disappears.

But shouldn't initialization order of these inodes be swapped too?
As meta_inode uses node_inode, it seems logical that it should be 
initialized after it.

-- 
Best regards,

Andrey Tsyvarev
Linux Verification Center, ISPRAS
web:http://linuxtesting.org

