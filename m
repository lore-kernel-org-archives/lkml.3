Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab3JCNfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 09:35:47 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:21820 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981Ab3JCNfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 09:35:44 -0400
Message-ID: <524D72A7.8030200@oracle.com>
Date: Thu, 03 Oct 2013 07:35:35 -0600
From: Khalid Aziz <khalid.aziz@oracle.com>
Organization: Oracle Corp
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
CC: stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [ 00/13] 3.0.99-stable review
References: <20131003040400.753642257@linuxfoundation.org> <524D0663.209@roeck-us.net> <1380801873@msgid.manchmal.in-ulm.de>
In-Reply-To: <1380801873@msgid.manchmal.in-ulm.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2013 06:47 AM, Christoph Biedl wrote:
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
> Looking closer, upstream commit 7cb2ef56 included linux/hugetlb.h
> while the backport for 3.0 just defines PageHuge. Reverting that like
> in the patch below causes the build to complete, and the resulting
> kernel shows no anomalies here.
>
> However did that backport, why was it done that way? Or did I miss an
> important point?

Thanks for tracking this down. I had not tried a configuration with 
CONFIG_HUGETLB_PAGE not set. In my config, I was getting many multiple 
definition errors for bunch of other defines from linux/hugetlb.h. I 
will look at my config again but chances are I had something else 
screwed up in my build since you did not see those errors. Did you 
compile with CONFIG_HUGETLB_PAGE set after including linux/hugetlb.h? If 
you did, including linux/hugetlb.h instead of importing just the 
definition of PageHuge in mm/swap.c would be the right thing to do.

--
Khalid

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

