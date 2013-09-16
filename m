Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625Ab3IPV2F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 17:28:05 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60863 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab3IPV2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 17:28:01 -0400
Message-ID: <523777D8.2000304@jp.fujitsu.com>
Date: Mon, 16 Sep 2013 17:27:52 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: liwanp@linux.vnet.ibm.com
CC: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com, zhangyanfei@cn.fujitsu.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH v5 4/4] mm/vmalloc: fix show vmap_area information
 race with vmap_area tear down
References: <1379202342-23140-1-git-send-email-liwanp@linux.vnet.ibm.com> <1379202342-23140-4-git-send-email-liwanp@linux.vnet.ibm.com>
In-Reply-To: <1379202342-23140-4-git-send-email-liwanp@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/14/2013 7:45 PM, Wanpeng Li wrote:
> Changelog:
>  *v4 -> v5: return directly for !VM_VM_AREA case and remove (VM_LAZY_FREE | VM_LAZY_FREEING) check 
> 
> There is a race window between vmap_area tear down and show vmap_area information.
> 
> 	A                                                B
> 
> remove_vm_area
> spin_lock(&vmap_area_lock);
> va->vm = NULL;
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
> The assumption !VM_VM_AREA represents vm_map_ram allocation is introduced by 
> commit: d4033afd(mm, vmalloc: iterate vmap_area_list, instead of vmlist, in 
> vmallocinfo()). However, !VM_VM_AREA also represents vmap_area is being tear 
> down in race window mentioned above. This patch fix it by don't dump any 
> information for !VM_VM_AREA case and also remove (VM_LAZY_FREE | VM_LAZY_FREEING)
> check since they are not possible for !VM_VM_AREA case.
> 
> Suggested-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

