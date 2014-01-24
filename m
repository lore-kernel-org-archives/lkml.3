Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545AbaAXGyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 01:54:52 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:50248 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbaAXGyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 01:54:51 -0500
MIME-Version: 1.0
In-Reply-To: <20140123144954.644c14d60a4b55255d32960b@linux-foundation.org>
References: <alpine.LNX.2.00.1401232025400.1392@linmac>
	<20140123144954.644c14d60a4b55255d32960b@linux-foundation.org>
Date: Fri, 24 Jan 2014 10:54:48 +0400
Message-ID: <CABV+yWtxKDOGgJxLQQ1pg4YYPTB0JDuz+KPK9D+Fqu81vYfdUw@mail.gmail.com>
Subject: Re: [PATCH] Revert "mm/vmalloc: interchage the implementation of vmalloc_to_{pfn,page}"
From: Vladimir Murzin <murzin.v@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: malc <av1474@comtv.ru>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Jianyu Zhan <nasa4836@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew

On Fri, Jan 24, 2014 at 2:49 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 23 Jan 2014 20:27:29 +0400 (MSK) malc <av1474@comtv.ru> wrote:
>
>> Sep 17 00:00:00 2001
>> From: Vladimir Murzin <murzin.v@gmail.com>
>> Date: Thu, 23 Jan 2014 14:54:20 +0400
>> Subject: [PATCH] Revert "mm/vmalloc: interchage the implementation of
>>  vmalloc_to_{pfn,page}"
>>
>> This reverts commit ece86e222db48d04bda218a2be70e384518bb08c.
>>
>> Despite being claimed that patch doesn't introduce any functional
>> changes in fact it does.
>>
>> The "no page" path behaves different now. Originally, vmalloc_to_page
>> might return NULL under some conditions, with new implementation it returns
>> pfn_to_page(0) which is not the same as NULL.
>>
>> Simple test shows the difference.
>>
>> test.c
>>
>> #include <linux/kernel.h>
>> #include <linux/module.h>
>> #include <linux/vmalloc.h>
>> #include <linux/mm.h>
>>
>> int __init myi(void)
>> {
>>       struct page *p;
>>       void *v;
>>
>>       v = vmalloc(PAGE_SIZE);
>>       /* trigger the "no page" path in vmalloc_to_page*/
>>       vfree(v);
>>
>>       p = vmalloc_to_page(v);
>>
>>       pr_err("expected val = NULL, returned val = %p", p);
>>
>>       return -EBUSY;
>> }
>>
>> void __exit mye(void)
>> {
>>
>> }
>> module_init(myi)
>> module_exit(mye)
>>
>> Before interchange:
>> expected val = NULL, returned val =   (null)
>>
>> After interchange:
>> expected val = NULL, returned val = c7ebe000
>>
>
> hm, yes, I suppose that's bad.
>
> Rather than reverting the patch we could fix up vmalloc_to_pfn() and/or
> vmalloc_to_page() to handle this situation.  Did you try that?
>

Personally, I didn't try; I leaved this responsibility to the author
of the patch
as a review feedback. Unfortunately, there was no any response.

Being said that original patch makes vmalloc_to_* "slightly more efficient",
I'm in doubt that with additional handling it'd still improve something. I'd be
very glad if someone point me at the benefit of the patch - just to have an
idea why we need to put extra effort here.

Thanks
Vladimir

> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
