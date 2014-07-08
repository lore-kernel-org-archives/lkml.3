Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbaGHWjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:39:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987AbaGHWjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:39:17 -0400
Date: Tue, 8 Jul 2014 18:39:13 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: "xinhui.pan" <xinhuix.pan@intel.com>
cc: linux-kernel@vger.kernel.org, agk@redhat.com, snitzer@redhat.com,
        dm-devel@redhat.com, "Liu, ShuoX" <shuox.liu@intel.com>,
        yanmin_zhang@linux.intel.com
Subject: Re: [dm-devel] [PATCH] md/dm-ioctl.c: optimize memory allocation in
 copy_params
In-Reply-To: <53B68068.2060102@intel.com>
Message-ID: <alpine.LRH.2.02.1407081831510.27831@file01.intranet.prod.int.rdu2.redhat.com>
References: <53B68068.2060102@intel.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I don't really know what is the purpose of this patch. In existing device 
mapper code, if kmalloc fails, the allocation is retried with __vmalloc. 
So there is no need to avoid kmalloc aritifically.

kmalloc doesn't cause memory fragmentation. If the memory is too 
fragmented, kmalloc fails. If it isn't, it succeeds. But it doesn't cause 
memory being fragmented.

If you have some other driver that fails because of large kmalloc failure, 
you should fix it to use scatter-gather DMA or (if the hardware can't do 
it) preallocate the memory when the driver is loaded.

Mikulas



On Fri, 4 Jul 2014, xinhui.pan wrote:

> KMALLOC_MAX_SIZE is too big, it easily cause memory fragmented and low memory when param_kernel->data_size
> is also big. That's not nice. So use vmalloc instead of kmalloc when size is larger than (PAGE_SIZE << 2).
> There are other drivers using kmalloc to gain a big size memory. And that cause our devices to hit hang and
> many worse issues. We don't benefit much when using kmalloc in such scenario.
> 
> Signed-off-by: xinhui.pan <xinhuiX.pan@intel.com>
> Signed-off-by: yanmin.zhang <yanmin_zhang@linux.intel.com>
> ---
>  drivers/md/dm-ioctl.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> index 5152142..31c3af9 100644
> --- a/drivers/md/dm-ioctl.c
> +++ b/drivers/md/dm-ioctl.c
> @@ -1709,7 +1709,7 @@ static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl *param_kern
>          * Use kmalloc() rather than vmalloc() when we can.
>          */
>         dmi = NULL;
> -       if (param_kernel->data_size <= KMALLOC_MAX_SIZE) {
> +       if (param_kernel->data_size <= (PAGE_SIZE << 2)) {
>                 dmi = kmalloc(param_kernel->data_size, GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
>                 if (dmi)
>                         *param_flags |= DM_PARAMS_KMALLOC;
> -- 
> 1.7.9.5
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
