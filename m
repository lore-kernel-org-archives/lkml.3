Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab3JCN3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 09:29:07 -0400
Received: from mail.active-venture.com ([67.228.131.205]:55995 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab3JCN3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 09:29:05 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <524D711C.30605@roeck-us.net>
Date: Thu, 03 Oct 2013 06:29:00 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>,
        stable@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Khalid Aziz <khalid.aziz@oracle.com>
Subject: Re: [ 00/13] 3.0.99-stable review
References: <20131003040400.753642257@linuxfoundation.org> <524D0663.209@roeck-us.net> <1380801873@msgid.manchmal.in-ulm.de>
In-Reply-To: <1380801873@msgid.manchmal.in-ulm.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2013 05:47 AM, Christoph Biedl wrote:
> Guenter Roeck wrote...
>
>> On 10/02/2013 09:04 PM, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 3.0.99 release.
>
>> Heads up: I am getting lots of build failures in 3.0 and 3.4 builds.
>>
>> mm/built-in.o: In function `__put_compound_page':
>> slab.c:(.text+0xaa3c): undefined reference to `PageHuge'
>> mm/built-in.o: In function `put_compound_page':
>> slab.c:(.text+0xaab0): undefined reference to `PageHuge'
>> mm/built-in.o: In function `__get_page_tail':
>> slab.c:(.text+0xb178): undefined reference to `PageHuge'
>> make: *** [.tmp_vmlinux1] Error 1
>
> This is obviously due to
>
> | [ 11/13] mm: fix aio performance regression for database caused by THP
>
> and happens if CONFIG_HUGETLB_PAGE is not set.
>

Thanks a lot for tracking this down.

Final build result is
	total: 98 pass: 15 skipped: 16 fail: 67

for 3.0, which is obviously less than perfect.

All qemu tests failed as well, or rather the qemu images failed to build.

Guenter

> Looking closer, upstream commit 7cb2ef56 included linux/hugetlb.h
> while the backport for 3.0 just defines PageHuge. Reverting that like
> in the patch below causes the build to complete, and the resulting
> kernel shows no anomalies here.
>
> However did that backport, why was it done that way? Or did I miss an
> important point?
>
>      Christoph
>
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -31,6 +31,7 @@
>   #include <linux/backing-dev.h>
>   #include <linux/memcontrol.h>
>   #include <linux/gfp.h>
> +#include <linux/hugetlb.h>
>
>   #include "internal.h"
>
> @@ -41,8 +42,6 @@
>   static DEFINE_PER_CPU(struct pagevec, lru_rotate_pvecs);
>   static DEFINE_PER_CPU(struct pagevec, lru_deactivate_pvecs);
>
> -int PageHuge(struct page *page);
> -
>   /*
>    * This path almost never happens for VM activity - pages are normally
>    * freed via pagevecs.  But it gets used by networking.
>
>
>

