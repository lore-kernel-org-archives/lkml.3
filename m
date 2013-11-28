Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326Ab3K1SJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 13:09:48 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:57482 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759301Ab3K1SJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 13:09:36 -0500
Date: Fri, 29 Nov 2013 02:11:14 +0800
From: Jianyu Zhan <nasa4836@gmail.com>
To: murzin.v@gmail.com
Cc: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com,
        zhangyanfei@cn.fujitsu.com, rientjes@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]mm/vmalloc: interchage the implementation of
 vmalloc_to_{pfn,page}
Message-ID: <20131128181114.GA5154@lcx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, Vladimir,

On Fri, Nov 29, 2013 at 1:41 AM, Vladimir Murzin <murzin.v@gmail.com> wrote:
>
> Any numbers for efficiency?
>

For the original implementation, vmalloc_to_pfn() wraps the vmalloc_to_page(),
which means

     pfn   ------>         struct page      ------>    pfn
      |                                                          |
  vmalloc_to_page()                             vmalloc_to_pfn()

So this patch interchange the implementation, do the dirty page table
walking code in vmalloc_to_pfn(), and then vmalloc_to_page() uses it, the graph
now becomes

     pfn            ------>         struct page        
       |                                     |
  vmalloc_to_pfn()         vmalloc_to_page()


>>  /*
>> - * Walk a vmap address to the struct page it maps.
>> + * Walk a vmap address to the physical pfn it maps to.
>>   */
>> -struct page *vmalloc_to_page(const void *vmalloc_addr)
>> +unsigned long vmalloc_to_pfn(const void *vmalloc_addr)
>>  {
>>       unsigned long addr = (unsigned long) vmalloc_addr;
>> -     struct page *page = NULL;
>> +     unsigned long pfn;
>
> uninitialized pfn will lead to a bug.
>

Why? The coding pratice has mandates we use it after we initialize it,
And if we initialize it , to what value will it promise no bug?
It is unlikely a rubbish initial value will creep in.


>>       /*
>> @@ -244,23 +244,23 @@ struct page *vmalloc_to_page(const void *vmalloc_addr)
>>                               ptep = pte_offset_map(pmd, addr);
>>                               pte = *ptep;
>>                               if (pte_present(pte))
>> -                                     page = pte_page(pte);
>> +                                     pfn = pte_page(pte);
>
> page_to_pfn is missed here.
>
> Have you ever tested there is no functional changes?

Oh, gods. My fault. It did has no functional changes.

I just sent the incorrect patch...

it should be  
 -   page = pte_page(pte);
 +  pfn = pte_pfn(pte);;

Here is the resent patch:


---
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 0fdf968..e4f0db2 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -220,12 +220,12 @@ int is_vmalloc_or_module_addr(const void *x)
 }
 
 /*
- * Walk a vmap address to the struct page it maps.
+ * Walk a vmap address to the physical pfn it maps to.
  */
-struct page *vmalloc_to_page(const void *vmalloc_addr)
+unsigned long vmalloc_to_pfn(const void *vmalloc_addr)
 {
 	unsigned long addr = (unsigned long) vmalloc_addr;
-	struct page *page = NULL;
+	unsigned long pfn = 0;
 	pgd_t *pgd = pgd_offset_k(addr);
 
 	/*
@@ -244,23 +244,23 @@ struct page *vmalloc_to_page(const void *vmalloc_addr)
 				ptep = pte_offset_map(pmd, addr);
 				pte = *ptep;
 				if (pte_present(pte))
-					page = pte_page(pte);
+					pfn = pte_pfn(pte);
 				pte_unmap(ptep);
 			}
 		}
 	}
-	return page;
+	return pfn;
 }
-EXPORT_SYMBOL(vmalloc_to_page);
+EXPORT_SYMBOL(vmalloc_to_pfn);
 
 /*
- * Map a vmalloc()-space virtual address to the physical page frame number.
+ * Map a vmalloc()-space virtual address to the struct page.
  */
-unsigned long vmalloc_to_pfn(const void *vmalloc_addr)
+struct page *vmalloc_to_page(const void *vmalloc_addr)
 {
-	return page_to_pfn(vmalloc_to_page(vmalloc_addr));
+	return pfn_to_page(vmalloc_to_pfn(vmalloc_addr));
 }
-EXPORT_SYMBOL(vmalloc_to_pfn);
+EXPORT_SYMBOL(vmalloc_to_page);
 
 
 /*** Global kva allocator ***/
