Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031022Ab3HIUde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 16:33:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030904Ab3HIUdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 16:33:33 -0400
Date: Fri, 09 Aug 2013 16:33:26 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: yonghua zheng <younghua.zheng@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Motohiro KOSAKI <kosaki.motohiro@gmail.com>
Message-ID: <1376080406-4r7r3uye-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <CAMyfujfZayb8_673vkb2hdE9J_w+wPTD4aQ6TsY+aWxb9EzY8A@mail.gmail.com>
References: <CAMyfujfZayb8_673vkb2hdE9J_w+wPTD4aQ6TsY+aWxb9EzY8A@mail.gmail.com>
Subject: Re: [PATCH 1/1] pagemap: fix buffer overflow in add_page_map()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <CAMyfujfZayb8_673vkb2hdE9J_w+wPTD4aQ6TsY+aWxb9EzY8A@mail.gmail.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 01:16:41PM +0800, yonghua zheng wrote:
> Hi,
> 
> Recently we met quite a lot of random kernel panic issues after enable
> CONFIG_PROC_PAGE_MONITOR in kernel, after debuggint sometime we found
> this has something to do with following bug in pagemap:
> 
> In struc pagemapread:
> 
> struct pagemapread {
>     int pos, len;
>     pagemap_entry_t *buffer;
>     bool v2;
> };
> 
> pos is number of PM_ENTRY_BYTES in buffer, but len is the size of buffer,
> it is a mistake to compare pos and len in add_page_map() for checking

s/add_page_map/add_to_pagemap/ ?

> buffer is full or not, and this can lead to buffer overflow and random
> kernel panic issue.
> 
> Correct len to be total number of PM_ENTRY_BYTES in buffer.
> 
> Signed-off-by: Yonghua Zheng <younghua.zheng@gmail.com>

You can find coding style violation with scripts/checkpatch.pl.
And I think this patch is worth going into -stable trees
(maybe since 2.6.34.)

The fix itself looks fine to me.

Thanks,
Naoya Horiguchi

> ---
>  fs/proc/task_mmu.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index dbf61f6..cb98853 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -1116,8 +1116,8 @@ static ssize_t pagemap_read(struct file *file,
> char __user *buf,
>          goto out_task;
> 
>      pm.v2 = soft_dirty_cleared;
> -    pm.len = PM_ENTRY_BYTES * (PAGEMAP_WALK_SIZE >> PAGE_SHIFT);
> -    pm.buffer = kmalloc(pm.len, GFP_TEMPORARY);
> +    pm.len = (PAGEMAP_WALK_SIZE >> PAGE_SHIFT);
> +    pm.buffer = kmalloc(pm.len * PM_ENTRY_BYTES, GFP_TEMPORARY);
>      ret = -ENOMEM;
>      if (!pm.buffer)
>          goto out_task;
> 
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
