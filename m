Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759414Ab3ICFlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 01:41:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:40136 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753246Ab3ICFlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 01:41:02 -0400
X-IronPort-AV: E=Sophos;i="4.89,1011,1367942400"; 
   d="scan'208";a="8387128"
Message-ID: <5225765E.8000402@cn.fujitsu.com>
Date: Tue, 03 Sep 2013 13:40:46 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] mm/vmalloc: move VM_UNINITIALIZED just before
 show_numa_info
References: <1378177220-26218-1-git-send-email-liwanp@linux.vnet.ibm.com> <1378177220-26218-3-git-send-email-liwanp@linux.vnet.ibm.com>
In-Reply-To: <1378177220-26218-3-git-send-email-liwanp@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/03 13:38:54,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/03 13:38:55,
	Serialize complete at 2013/09/03 13:38:55
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2013 11:00 AM, Wanpeng Li wrote:
> The VM_UNINITIALIZED/VM_UNLIST flag introduced by commit f5252e00(mm: avoid
> null pointer access in vm_struct via /proc/vmallocinfo) is used to avoid
> accessing the pages field with unallocated page when show_numa_info() is
> called. This patch move the check just before show_numa_info in order that
> some messages still can be dumped via /proc/vmallocinfo.
> 
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>

Hmmm, sorry again. Please revert commit
d157a55815ffff48caec311dfb543ce8a79e283e. That said, we could still
do the check in show_numa_info like before.

> ---
>  mm/vmalloc.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index e3ec8b4..c4720cd 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -2590,11 +2590,6 @@ static int s_show(struct seq_file *m, void *p)
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
> @@ -2622,6 +2617,11 @@ static int s_show(struct seq_file *m, void *p)
>  	if (v->flags & VM_VPAGES)
>  		seq_printf(m, " vpages");
>  
> +	/* Pair with smp_wmb() in clear_vm_uninitialized_flag() */
> +	smp_rmb();
> +	if (v->flags & VM_UNINITIALIZED)
> +		return 0;
> +
>  	show_numa_info(m, v);
>  	seq_putc(m, '\n');
>  	return 0;
> 


-- 
Thanks.
Zhang Yanfei
