Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482Ab3ICHla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 03:41:30 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:42836 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759308Ab3ICHl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 03:41:29 -0400
X-AuditID: 9c93016f-b7cf0ae00000518f-94-522592a70c7e
Date: Tue, 3 Sep 2013 16:42:21 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 4/4] mm/vmalloc: don't assume vmap_area w/o VM_VM_AREA
 flag is vm_map_ram allocation
Message-ID: <20130903074221.GA30920@lge.com>
References: <1378191706-29696-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1378191706-29696-4-git-send-email-liwanp@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378191706-29696-4-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 03:01:46PM +0800, Wanpeng Li wrote:
> There is a race window between vmap_area free and show vmap_area information.
> 
> 	A                                                B
> 
> remove_vm_area
> spin_lock(&vmap_area_lock);
> va->flags &= ~VM_VM_AREA;
> spin_unlock(&vmap_area_lock);
> 						spin_lock(&vmap_area_lock);
> 						if (va->flags & (VM_LAZY_FREE | VM_LAZY_FREEZING))
> 							return 0;
> 						if (!(va->flags & VM_VM_AREA)) {
> 							seq_printf(m, "0x%pK-0x%pK %7ld vm_map_ram\n",
> 								(void *)va->va_start, (void *)va->va_end,
> 								va->va_end - va->va_start);
> 							return 0;
> 						}
> free_unmap_vmap_area(va);
> 	flush_cache_vunmap
> 	free_unmap_vmap_area_noflush
> 		unmap_vmap_area
> 		free_vmap_area_noflush
> 			va->flags |= VM_LAZY_FREE 
> 
> The assumption is introduced by commit: d4033afd(mm, vmalloc: iterate vmap_area_list, 
> instead of vmlist, in vmallocinfo()). This patch fix it by drop the assumption and 
> keep not dump vm_map_ram allocation information as the logic before that commit.
> 
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> ---
>  mm/vmalloc.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 5368b17..62b7932 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -2586,13 +2586,6 @@ static int s_show(struct seq_file *m, void *p)
>  	if (va->flags & (VM_LAZY_FREE | VM_LAZY_FREEING))
>  		return 0;
>  
> -	if (!(va->flags & VM_VM_AREA)) {
> -		seq_printf(m, "0x%pK-0x%pK %7ld vm_map_ram\n",
> -			(void *)va->va_start, (void *)va->va_end,
> -					va->va_end - va->va_start);
> -		return 0;
> -	}
> -
>  	v = va->vm;
>  
>  	seq_printf(m, "0x%pK-0x%pK %7ld",

Hello, Wanpeng.

Did you test this patch?

I guess that, With this patch, if there are some vm_map areas,
null pointer deference would occurs, since va->vm may be null for it.

And with this patch, if this race really occur, null pointer deference
would occurs too, since va->vm is set to null in remove_vm_area().

I think that this is not a right fix for this possible race.

Thanks.
