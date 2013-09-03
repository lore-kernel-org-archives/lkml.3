Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562Ab3ICHmK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 03:42:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:31016 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932502Ab3ICHmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 03:42:08 -0400
X-IronPort-AV: E=Sophos;i="4.89,1012,1367942400"; 
   d="scan'208";a="8389016"
Message-ID: <522592BF.1090102@cn.fujitsu.com>
Date: Tue, 03 Sep 2013 15:41:51 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 4/4] mm/vmalloc: don't assume vmap_area w/o VM_VM_AREA
 flag is vm_map_ram allocation
References: <1378191706-29696-1-git-send-email-liwanp@linux.vnet.ibm.com> <1378191706-29696-4-git-send-email-liwanp@linux.vnet.ibm.com>
In-Reply-To: <1378191706-29696-4-git-send-email-liwanp@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/03 15:40:00,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/03 15:40:00,
	Serialize complete at 2013/09/03 15:40:00
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2013 03:01 PM, Wanpeng Li wrote:
> There is a race window between vmap_area free and show vmap_area information.
> 
> 	A                                                B
> 
> remove_vm_area
> spin_lock(&vmap_area_lock);
> va->flags &= ~VM_VM_AREA;

Here we also do: va->vm = NULL; And see below....

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

If we remove the if test above, in the window you said above, va->vm is NULL,
but below we will still try to access the members of this vm_struct, which
will cause problems...

Correct me if I am wrong, please.

>  
>  	seq_printf(m, "0x%pK-0x%pK %7ld",
> 


-- 
Thanks.
Zhang Yanfei
