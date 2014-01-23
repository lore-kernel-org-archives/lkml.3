Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770AbaAWWt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 17:49:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37063 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbaAWWt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 17:49:56 -0500
Date: Thu, 23 Jan 2014 14:49:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: malc <av1474@comtv.ru>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Jianyu Zhan <nasa4836@gmail.com>
Subject: Re: [PATCH] Revert
 "mm/vmalloc: interchage the implementation of vmalloc_to_{pfn,page}"
Message-Id: <20140123144954.644c14d60a4b55255d32960b@linux-foundation.org>
In-Reply-To: <alpine.LNX.2.00.1401232025400.1392@linmac>
References: <alpine.LNX.2.00.1401232025400.1392@linmac>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jan 2014 20:27:29 +0400 (MSK) malc <av1474@comtv.ru> wrote:

> Sep 17 00:00:00 2001
> From: Vladimir Murzin <murzin.v@gmail.com>
> Date: Thu, 23 Jan 2014 14:54:20 +0400
> Subject: [PATCH] Revert "mm/vmalloc: interchage the implementation of
>  vmalloc_to_{pfn,page}"
> 
> This reverts commit ece86e222db48d04bda218a2be70e384518bb08c.
> 
> Despite being claimed that patch doesn't introduce any functional
> changes in fact it does.
> 
> The "no page" path behaves different now. Originally, vmalloc_to_page
> might return NULL under some conditions, with new implementation it returns
> pfn_to_page(0) which is not the same as NULL.
> 
> Simple test shows the difference.
> 
> test.c
> 
> #include <linux/kernel.h>
> #include <linux/module.h>
> #include <linux/vmalloc.h>
> #include <linux/mm.h>
> 
> int __init myi(void)
> {
> 	struct page *p;
> 	void *v;
> 
> 	v = vmalloc(PAGE_SIZE);
> 	/* trigger the "no page" path in vmalloc_to_page*/
> 	vfree(v);
> 
> 	p = vmalloc_to_page(v);
> 
> 	pr_err("expected val = NULL, returned val = %p", p);
> 
> 	return -EBUSY;
> }
> 
> void __exit mye(void)
> {
> 
> }
> module_init(myi)
> module_exit(mye)
> 
> Before interchange:
> expected val = NULL, returned val =   (null)
> 
> After interchange:
> expected val = NULL, returned val = c7ebe000
> 

hm, yes, I suppose that's bad.

Rather than reverting the patch we could fix up vmalloc_to_pfn() and/or
vmalloc_to_page() to handle this situation.  Did you try that?

