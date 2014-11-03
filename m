Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750876AbaKCGcm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 01:32:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41442 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbaKCGck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 01:32:40 -0500
Message-ID: <54572182.8080005@suse.com>
Date: Mon, 03 Nov 2014 07:32:34 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: hpa@zytor.com, x86@kernel.org, mingo@redhat.com,
        stefan.bader@canonical.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        ville.syrjala@linux.intel.com, david.vrabel@citrix.com,
        jbeulich@suse.com, toshi.kani@hp.com, plagnioj@jcrosoft.com,
        tomi.valkeinen@ti.com, bhelgaas@google.com
Subject: Re: [PATCH 10/17] x86: Use new cache mode type in setting page attributes
References: <1414764033-30011-1-git-send-email-jgross@suse.com> <1414764033-30011-11-git-send-email-jgross@suse.com> <alpine.DEB.2.11.1410311617260.5308@nanos>
In-Reply-To: <alpine.DEB.2.11.1410311617260.5308@nanos>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2014 04:34 PM, Thomas Gleixner wrote:
> On Fri, 31 Oct 2014, Juergen Gross wrote:
>> --- a/arch/x86/mm/pageattr.c
>> +++ b/arch/x86/mm/pageattr.c
>> @@ -1304,12 +1304,6 @@ static int __change_page_attr_set_clr(struct cpa_data *cpa, int checkalias)
>>   	return 0;
>>   }
>>
>> -static inline int cache_attr(pgprot_t attr)
>> -{
>> -	return pgprot_val(attr) &
>> -		(_PAGE_PAT | _PAGE_PAT_LARGE | _PAGE_PWT | _PAGE_PCD);
>> -}
>> -
>>   static int change_page_attr_set_clr(unsigned long *addr, int numpages,
>>   				    pgprot_t mask_set, pgprot_t mask_clr,
>>   				    int force_split, int in_flag,
>> @@ -1390,7 +1384,7 @@ static int change_page_attr_set_clr(unsigned long *addr, int numpages,
>>   	 * No need to flush, when we did not set any of the caching
>>   	 * attributes:
>>   	 */
>> -	cache = cache_attr(mask_set);
>> +	cache = !!pgprot2cachemode(mask_set);
>
> So this loses _PAGE_PAT_LARGE, right ?

change_page_attr_set_clr() is never called with _PAGE_PAT_LARGE set in
mask, so this is no problem.

BTW: correct handling of the PAT bit for large pages is added in
patch 15. There have been places in the kernel respecting
_PAGE_PAT_LARGE, but handling has never been complete up to now.

>
>>   int set_memory_uc(unsigned long addr, int numpages)
>> @@ -1456,7 +1451,7 @@ int set_memory_uc(unsigned long addr, int numpages)
>>   	 * for now UC MINUS. see comments in ioremap_nocache()
>>   	 */
>>   	ret = reserve_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE,
>> -			    _PAGE_CACHE_UC_MINUS, NULL);
>> +			      _PAGE_CACHE_UC_MINUS, NULL);
>
> That should be in the patch which added the _PAGE_CACHE_UC_MINUS
>
>>   int _set_memory_wb(unsigned long addr, int numpages)
>>   {
>> +	/* WB cache mode is hard wired to all cache attribute bits being 0 */
>
> I like the comment, but shouldn't we compile time check that
> assumption somewhere?

There is a comment in patch 1 where the page_cache_mode enum is set up.
The translation functions between page_cache_mode and protection values
have a special check for "0" built in. Isn't this enough?

BTW: How would you check this assumption at compile time? The
translation between WB cache mode and protection values is done only
dynamically...


Thanks for the review,

Juergen
