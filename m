Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbaIJEle (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 00:41:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60603 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbaIJElb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 00:41:31 -0400
Message-ID: <540FD677.5060203@suse.com>
Date: Wed, 10 Sep 2014 06:41:27 +0200
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: stefan.bader@canonical.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        ville.syrjala@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        jbeulich@suse.com, david.vrabel@citrix.com
Subject: Re: [PATCH V2 1/3] x86: Make page cache mode a real type
References: <1410163298-8951-1-git-send-email-jgross@suse.com>	 <1410163298-8951-2-git-send-email-jgross@suse.com> <1410283492.28990.225.camel@misato.fc.hp.com>
In-Reply-To: <1410283492.28990.225.camel@misato.fc.hp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2014 07:24 PM, Toshi Kani wrote:
> On Mon, 2014-09-08 at 10:01 +0200, Juergen Gross wrote:
>> At the moment there are a lot of places that handle setting or getting
>> the page cache mode by treating the pgprot bits equal to the cache mode.
>> This is only true because there are a lot of assumptions about the setup
>> of the PAT MSR. Otherwise the cache type needs to get translated into
>> pgprot bits and vice versa.
>>
>> This patch tries to prepare for that by introducing a seperate type
>> for the cache mode and adding functions to translate between those and
>> pgprot values.
>>
>> To avoid too much performance penalty the translation between cache mode
>> and pgprot values is done via tables which contain the relevant
>> information.  Write-back cache mode is hard-wired to be 0, all other
>> modes are configurable via those tables. For large pages there are
>> translation functions as the PAT bit is located at different positions
>> in the ptes of 4k and large pages.
>>
>> Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
>> Signed-off-by: Juergen Gross <jgross@suse.com>
>
> I have two minor comments (which I should have caught before)... Other
> wise, the changes look good to me
>
> Reviewed-by: Toshi Kani <toshi.kani@hp.com>
>
>
>>   /*
>> diff --git a/arch/x86/include/asm/fb.h b/arch/x86/include/asm/fb.h
>> index 2519d06..0902a50 100644
>> --- a/arch/x86/include/asm/fb.h
>> +++ b/arch/x86/include/asm/fb.h
>> @@ -8,8 +8,12 @@
>>   static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma,
>>   				unsigned long off)
>>   {
>> +	unsigned long prot;
>> +
>> +	prot = pgprot_val(vma->vm_page_prot) & ~_PAGE_CACHE_MASK;
>>   	if (boot_cpu_data.x86 > 3)
>> -		pgprot_val(vma->vm_page_prot) |= _PAGE_PCD;
>> +		pgprot_val(vma->vm_page_prot) =
>> +			prot | cachemode2protval(_PAGE_CACHE_MODE_UC);
>
> This should be _PAGE_CACHE_MODE_UC_MINUS as the original code only sets
> the PCD bit.

Okay.

>
>> diff --git a/drivers/video/fbdev/gbefb.c b/drivers/video/fbdev/gbefb.c
>> index 4aa56ba..b1cc7a6 100644
>> --- a/drivers/video/fbdev/gbefb.c
>> +++ b/drivers/video/fbdev/gbefb.c
>> @@ -54,7 +54,8 @@ struct gbefb_par {
>>   #endif
>>   #endif
>>   #ifdef CONFIG_X86
>> -#define pgprot_fb(_prot) ((_prot) | _PAGE_PCD)
>> +#define pgprot_fb(_prot) (((_prot) & ~_PAGE_CACHE_MASK) |	\
>> +			  cachemode2protval(_PAGE_CACHE_MODE_UC))
>
> Ditto.

Yep.


Thanks,

Juergen
