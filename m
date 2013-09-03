Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932408Ab3ICHYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 03:24:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:4491 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759742Ab3ICHYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 03:24:43 -0400
X-IronPort-AV: E=Sophos;i="4.89,1012,1367942400"; 
   d="scan'208";a="8388710"
Message-ID: <52258EAB.8040002@cn.fujitsu.com>
Date: Tue, 03 Sep 2013 15:24:27 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/4] mm/vmalloc: revert "mm/vmalloc.c: check VM_UNINITIALIZED
 flag in s_show instead of show_numa_info"
References: <1378191706-29696-1-git-send-email-liwanp@linux.vnet.ibm.com> <1378191706-29696-3-git-send-email-liwanp@linux.vnet.ibm.com>
In-Reply-To: <1378191706-29696-3-git-send-email-liwanp@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/03 15:22:35,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/03 15:22:36,
	Serialize complete at 2013/09/03 15:22:36
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2013 03:01 PM, Wanpeng Li wrote:
> Changelog:
>  *v2 -> v3: revert commit d157a558 directly
> 
> The VM_UNINITIALIZED/VM_UNLIST flag introduced by commit f5252e00(mm: avoid
> null pointer access in vm_struct via /proc/vmallocinfo) is used to avoid
> accessing the pages field with unallocated page when show_numa_info() is
> called. This patch move the check just before show_numa_info in order that
> some messages still can be dumped via /proc/vmallocinfo. This patch revert 
> commit d157a558 (mm/vmalloc.c: check VM_UNINITIALIZED flag in s_show instead 
> of show_numa_info);
> 
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>

Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

> ---
>  mm/vmalloc.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index e3ec8b4..5368b17 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -2562,6 +2562,11 @@ static void show_numa_info(struct seq_file *m, struct vm_struct *v)
>  		if (!counters)
>  			return;
>  
> +		/* Pair with smp_wmb() in clear_vm_uninitialized_flag() */
> +		smp_rmb();
> +		if (v->flags & VM_UNINITIALIZED)
> +			return;
> +
>  		memset(counters, 0, nr_node_ids * sizeof(unsigned int));
>  
>  		for (nr = 0; nr < v->nr_pages; nr++)
> @@ -2590,11 +2595,6 @@ static int s_show(struct seq_file *m, void *p)
>  
>  	v = va->vm;
>  
> -	/* Pair with smp_wmb() in clear_vm_uninitialized_flag() */
> -	smp_rmb();
> -	if (v->flags & VM_UNINITIALIZED)
> -		return 0;
> -
>  	seq_printf(m, "0x%pK-0x%pK %7ld",
>  		v->addr, v->addr + v->size, v->size);
>  
> 


-- 
Thanks.
Zhang Yanfei
