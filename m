Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab3BRSZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 13:25:13 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:33118 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab3BRSZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 13:25:07 -0500
Message-ID: <512271E1.9000105@linux.vnet.ibm.com>
Date: Mon, 18 Feb 2013 12:24:33 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ric Mason <ric.masonn@gmail.com>
CC: Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>
Subject: Re: [PATCH] zsmalloc: Add Kconfig for enabling PTE method
References: <1359937421-19921-1-git-send-email-minchan@kernel.org> <511F2721.2000305@gmail.com>
In-Reply-To: <511F2721.2000305@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021818-3620-0000-0000-00000141D0C4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2013 12:28 AM, Ric Mason wrote:
> On 02/04/2013 08:23 AM, Minchan Kim wrote:
>> Zsmalloc has two methods 1) copy-based and 2) pte based to access
>> allocations that span two pages.
>> You can see history why we supported two approach from [1].
>>
>> But it was bad choice that adding hard coding to select architecture
>> which want to use pte based method. This patch removed it and adds
>> new Kconfig to select the approach.
>>
>> This patch is based on next-20130202.
>>
>> [1] https://lkml.org/lkml/2012/7/11/58
>>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
>> Cc: Nitin Gupta <ngupta@vflare.org>
>> Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
>> Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>
>> Signed-off-by: Minchan Kim <minchan@kernel.org>
>> ---
>>   drivers/staging/zsmalloc/Kconfig         |   12 ++++++++++++
>>   drivers/staging/zsmalloc/zsmalloc-main.c |   11 -----------
>>   2 files changed, 12 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/staging/zsmalloc/Kconfig
>> b/drivers/staging/zsmalloc/Kconfig
>> index 9084565..2359123 100644
>> --- a/drivers/staging/zsmalloc/Kconfig
>> +++ b/drivers/staging/zsmalloc/Kconfig
>> @@ -8,3 +8,15 @@ config ZSMALLOC
>>         non-standard allocator interface where a handle, not a
>> pointer, is
>>         returned by an alloc().  This handle must be mapped in order to
>>         access the allocated space.
>> +
>> +config ZSMALLOC_PGTABLE_MAPPING
>> +        bool "Use page table mapping to access allocations that
>> span two pages"
>> +        depends on ZSMALLOC
>> +        default n
>> +        help
>> +      By default, zsmalloc uses a copy-based object mapping method
>> to access
>> +      allocations that span two pages. However, if a particular
>> architecture
>> +      performs VM mapping faster than copying, then you should
>> select this.
>> +      This causes zsmalloc to use page table mapping rather than
>> copying
>> +      for object mapping. You can check speed with zsmalloc
>> benchmark[1].
>> +      [1] https://github.com/spartacus06/zsmalloc
> 
> Is there benchmark to test zcache? eg. internal fragmentation level ...

First, zsmalloc is not used in zcache right now so just wanted to say
that.  It is used in zram and the proposed zswap
(https://lwn.net/Articles/528817/)

There is not an official benchmark.  However anything that generates
activity that will hit the frontswap or cleancache hooks will do.
These are workloads that overcommit memory and use swap, or access
file sets whose size is larger that the system page cache.

The closest thing to a fragmentation metric is an effective
compression ratio that can be calculated with debugfs attributes:

zcache_[eph|pers]_zbytes / (zcache_[eph|pers]_pageframes * PAGE_SIZE)

eph for cleancache, and pers for frontswap.

Seth

