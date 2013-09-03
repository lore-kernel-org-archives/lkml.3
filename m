Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668Ab3ICI7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 04:59:09 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:55435 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932299Ab3ICI7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 04:59:07 -0400
X-AuditID: 9c930179-b7c0bae0000040ac-3a-5225a4d9b07d
Date: Tue, 3 Sep 2013 17:59:59 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 4/4] mm/vmalloc: don't assume vmap_area w/o VM_VM_AREA
 flag is vm_map_ram allocation
Message-ID: <20130903085959.GB30920@lge.com>
References: <1378191706-29696-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1378191706-29696-4-git-send-email-liwanp@linux.vnet.ibm.com>
 <20130903074221.GA30920@lge.com>
 <52259541.86a02b0a.2e56.ffffde93SMTPIN_ADDED_BROKEN@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52259541.86a02b0a.2e56.ffffde93SMTPIN_ADDED_BROKEN@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 03:51:39PM +0800, Wanpeng Li wrote:
> On Tue, Sep 03, 2013 at 04:42:21PM +0900, Joonsoo Kim wrote:
> >On Tue, Sep 03, 2013 at 03:01:46PM +0800, Wanpeng Li wrote:
> >> There is a race window between vmap_area free and show vmap_area information.
> >> 
> >> 	A                                                B
> >> 
> >> remove_vm_area
> >> spin_lock(&vmap_area_lock);
> >> va->flags &= ~VM_VM_AREA;
> >> spin_unlock(&vmap_area_lock);
> >> 						spin_lock(&vmap_area_lock);
> >> 						if (va->flags & (VM_LAZY_FREE | VM_LAZY_FREEZING))
> >> 							return 0;
> >> 						if (!(va->flags & VM_VM_AREA)) {
> >> 							seq_printf(m, "0x%pK-0x%pK %7ld vm_map_ram\n",
> >> 								(void *)va->va_start, (void *)va->va_end,
> >> 								va->va_end - va->va_start);
> >> 							return 0;
> >> 						}
> >> free_unmap_vmap_area(va);
> >> 	flush_cache_vunmap
> >> 	free_unmap_vmap_area_noflush
> >> 		unmap_vmap_area
> >> 		free_vmap_area_noflush
> >> 			va->flags |= VM_LAZY_FREE 
> >> 
> >> The assumption is introduced by commit: d4033afd(mm, vmalloc: iterate vmap_area_list, 
> >> instead of vmlist, in vmallocinfo()). This patch fix it by drop the assumption and 
> >> keep not dump vm_map_ram allocation information as the logic before that commit.
> >> 
> >> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> >> ---
> >>  mm/vmalloc.c | 7 -------
> >>  1 file changed, 7 deletions(-)
> >> 
> >> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> >> index 5368b17..62b7932 100644
> >> --- a/mm/vmalloc.c
> >> +++ b/mm/vmalloc.c
> >> @@ -2586,13 +2586,6 @@ static int s_show(struct seq_file *m, void *p)
> >>  	if (va->flags & (VM_LAZY_FREE | VM_LAZY_FREEING))
> >>  		return 0;
> >>  
> >> -	if (!(va->flags & VM_VM_AREA)) {
> >> -		seq_printf(m, "0x%pK-0x%pK %7ld vm_map_ram\n",
> >> -			(void *)va->va_start, (void *)va->va_end,
> >> -					va->va_end - va->va_start);
> >> -		return 0;
> >> -	}
> >> -
> >>  	v = va->vm;
> >>  
> >>  	seq_printf(m, "0x%pK-0x%pK %7ld",
> >
> >Hello, Wanpeng.
> >
> 
> Hi Joonsoo and Yanfei,
> 
> >Did you test this patch?
> >
> >I guess that, With this patch, if there are some vm_map areas,
> >null pointer deference would occurs, since va->vm may be null for it.
> >
> >And with this patch, if this race really occur, null pointer deference
> >would occurs too, since va->vm is set to null in remove_vm_area().
> >
> >I think that this is not a right fix for this possible race.
> >
> 
> How about append below to this patch?
> 
> if (va->vm)
> 	v = va->vm;
> else 
> 	return 0;

Hello,

I think that appending below code is better to represent it's purpose.
Maybe some comment is needed.

	/* blablabla */
	if (!(va->flags & VM_VM_AREA))
		return 0;

And maybe we can remove below code snippet, since
either VM_LAZY_FREE or VM_LAZY_FREEING is not possible for !VM_VM_AREA case.

	if (va->flags & (VM_LAZY_FREE | VM_LAZY_FREEING))
		return 0;

Thanks.
