Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab3IQULf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 16:11:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37698 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab3IQULe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 16:11:34 -0400
Date: Tue, 17 Sep 2013 13:11:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm/vmalloc: don't warning vmalloc allocation
 failure twice
Message-Id: <20130917131132.30cea21dba15f42b919fe71a@linux-foundation.org>
In-Reply-To: <1378125345-13228-2-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1378125345-13228-1-git-send-email-liwanp@linux.vnet.ibm.com>
	<1378125345-13228-2-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  2 Sep 2013 20:35:44 +0800 Wanpeng Li <liwanp@linux.vnet.ibm.com> wrote:

> Don't warning twice in __vmalloc_area_node and __vmalloc_node_range if 
> __vmalloc_area_node allocation failure.
> 
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> ---
>  mm/vmalloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index ee41cc6..e324d38 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -1635,7 +1635,7 @@ void *__vmalloc_node_range(unsigned long size, unsigned long align,
>  
>  	addr = __vmalloc_area_node(area, gfp_mask, prot, node, caller);
>  	if (!addr)
> -		goto fail;
> +		return NULL;
>  
>  	/*
>  	 * In this function, newly allocated vm_struct has VM_UNINITIALIZED

Putting a `return' in the middle of a function is often a bad thing -
functions which have multiple return points often lead to resource and
locking leaks.

It's particularly bad to have that return *after* a bunch of "goto
fail" statements - the result is utter spaghetti.

Fix:

--- a/mm/vmalloc.c~mm-vmalloc-dont-warn-about-vmalloc-allocation-failure-twice-fix
+++ a/mm/vmalloc.c
@@ -1626,16 +1626,16 @@ void *__vmalloc_node_range(unsigned long
 
 	size = PAGE_ALIGN(size);
 	if (!size || (size >> PAGE_SHIFT) > totalram_pages)
-		goto fail;
+		goto warn;
 
 	area = __get_vm_area_node(size, align, VM_ALLOC | VM_UNINITIALIZED,
 				  start, end, node, gfp_mask, caller);
 	if (!area)
-		goto fail;
+		goto warn;
 
 	addr = __vmalloc_area_node(area, gfp_mask, prot, node, caller);
 	if (!addr)
-		return NULL;
+		goto fail;
 
 	/*
 	 * In this function, newly allocated vm_struct has VM_UNINITIALIZED
@@ -1653,10 +1653,11 @@ void *__vmalloc_node_range(unsigned long
 
 	return addr;
 
-fail:
+warn:
 	warn_alloc_failed(gfp_mask, 0,
 			  "vmalloc: allocation failure: %lu bytes\n",
 			  real_size);
+fail:
 	return NULL;
 }
 
_

