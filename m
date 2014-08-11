Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbaHKDcx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 23:32:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:6783 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123AbaHKDcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 23:32:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="370648504"
Message-ID: <53E83960.6020108@linux.intel.com>
Date: Mon, 11 Aug 2014 11:32:48 +0800
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Sha, Ruibin" <ruibin.sha@intel.com>,
        Chintan Pandya <cpandya@codeaurora.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "mel@csn.ul.ie" <mel@csn.ul.ie>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "mgorman@suse.de" <mgorman@suse.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Zhang, Yanmin" <yanmin.zhang@intel.com>, "He, Bo" <bo.he@intel.com>
Subject: Re: [PATCH]  export the function kmap_flush_unused.
References: <3C85A229999D6B4A89FA64D4680BA6142C7DFA@SHSMSX101.ccr.corp.intel.com> <53E4D312.5000601@codeaurora.org> <3C85A229999D6B4A89FA64D4680BA6142CAFF3@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <3C85A229999D6B4A89FA64D4680BA6142CAFF3@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014/8/11 9:26, Sha, Ruibin wrote:
> Hi Chintan,
> Thank you very much for your timely and kindly response and comments.
>
> Here is more detail about our Scenario:
>
>      We have a big driver on Android product. The driver allocates lots of
>      DDR pages. When applications mmap a file exported from the driver,
>      driver would mmap the pages to the application space, usually with
>      uncachable prot.
>      On ia32/x86_64 arch, we have to avoid page cache alias issue. When
>      driver allocates the pages, it would change page original mapping in
>      page table with uncachable prot. Sometimes, the allocated page was
>      used by kmap/kunmap. After kunmap, the page is still mapped in KMAP
>      space. The entries in KMAP page table are not cleaned up until a
>      kernel thread flushes the freed KMAP pages(usually it is woken up by kunmap).
>      It means the driver need  force to flush the KMAP page table entries before mapping pages to
>      application space to be used. Otherwise, there is a race to create
>      cache alias.
>
>      To resolve this issue, we need export function kmap_flush_unused as
>      the driver is compiled as module. Then, the driver calls
>      kmap_flush_unused if the allocated pages are in HIGHMEM and being
>      used by kmap.
>
> Thanks again!
>
> Best Regards
> ---------------------------------------------------------------
> Sha, Rui bin ( Robin )
> +86 13817890945
> Android System Integration Shanghai
>
> -----Original Message-----
> From: Chintan Pandya [mailto:cpandya@codeaurora.org]
> Sent: Friday, August 8, 2014 9:40 PM
> To: Sha, Ruibin
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org; mel@csn.ul.ie; a.p.zijlstra@chello.nl; mgorman@suse.de; mingo@redhat.com; Zhang, Yanmin; He, Bo
> Subject: Re: [PATCH] export the function kmap_flush_unused.
>
> On 08/08/2014 02:46 PM, Sha, Ruibin wrote:
>> export the function kmap_flush_unused.
>>
>> Scenario: When graphic driver need high memory spece, we use
>> alloc_pages() to allocate. But if the allocated page has just been
>> mapped in the KMAP space(like first kmap then kunmap) and no flush
>> page happened on PKMAP, the page virtual address is not NULL.Then when
>> we get that page and set page attribute like set_memory_uc and
>> set_memory_wc, we hit error.
> Could you explain your scenario with more details ? set_memory_* should be applied on mapped address. And in attempt to map your page (which was just kmap and kunmap'ed), it will overwrite the previous mappings.
>
> Moreover, in my view, kmap_flush_unused is just helping us in keeping the cache clean for kmap virtual addresses if they are unmapped. Is it serving any more purpose here ?

It depends on how to define 'clean' here. It resets pkmap_count[i] to 0,
and cleans up page table entries used by PKMAP. Here, our scenario is
caused by the late page table entry cleanup as driver need avoid page
cache alias.

>
>> fix: For that scenario,when we get the allocated page and its virtual
>> address is not NULL, we would like first flush that page.
>> So need export that function kmap_flush_unused.
>>
>> Signed-off-by: sha, ruibin <ruibin.sha@intel.com>
>>
>> ---
>> mm/highmem.c | 1 +
>> 1 file changed, 1 insertion(+)
>>
>> diff --git a/mm/highmem.c b/mm/highmem.c
>> index b32b70c..511299b 100644
>> --- a/mm/highmem.c
>> +++ b/mm/highmem.c
>> @@ -156,6 +156,7 @@ void kmap_flush_unused(void)
>> flush_all_zero_pkmaps();
>> unlock_kmap();
>> }
>> +EXPORT_SYMBOL(kmap_flush_unused);
> This symbol is already extern'ed. Is it not sufficient for your case ?

We want to call it in driver module. extern is not enough.

Thanks,
Yanmin


