Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbaHVFZk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 01:25:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52807 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbaHVFZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 01:25:39 -0400
Message-ID: <53F6D44F.1060804@suse.com>
Date: Fri, 22 Aug 2014 07:25:35 +0200
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: stefan.bader@canonical.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        ville.syrjala@linux.intel.com, hpa@zytor.com, x86@kernel.org
Subject: Re: [PATCH RFC 1/3] x86: Make page cache mode a real type
References: <1408454745-32358-1-git-send-email-jgross@suse.com>	 <1408454745-32358-2-git-send-email-jgross@suse.com> <1408658961.28990.74.camel@misato.fc.hp.com>
In-Reply-To: <1408658961.28990.74.camel@misato.fc.hp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2014 12:09 AM, Toshi Kani wrote:
> On Tue, 2014-08-19 at 15:25 +0200, jgross@suse.com wrote:
>> From: Juergen Gross <jgross@suse.com>
>>
>> At the moment there are a lot of places that handle setting or getting
>> the page cache mode by treating the pgprot bits equal to the cache mode.
>> This is only true because there are a lot of assumptions about the setup
>> of the PAT MSR. Otherwise the cache type needs to get translated into
>> pgprot bits and vice versa.
>>
>> This patch tries to prepare for that by introducing a seperate type
>> for the cache mode and adding functions to translate between those and pgprot
>> values.
>>
>> To avoid too much performance penalty the translation between cache mode
>> and pgprot values is done via tables which contain the relevant information.
>> Write-back cache mode is hard-wired to be 0, all other modes are configurable
>> via those tables. For large pages there are translation functions as the
>> PAT bit is located at different positions in the ptes of 4k and large pages.
>
> One more comment below..
>
>> diff --git a/arch/x86/include/asm/cacheflush.h b/arch/x86/include/asm/cacheflush.h
>   :
>> -static inline void set_page_memtype(struct page *pg, unsigned long memtype)
>> +static inline void set_page_memtype(struct page *pg,
>> +				    enum page_cache_mode memtype)
>>   {
>>   	unsigned long memtype_flags = _PGMT_DEFAULT;
>>   	unsigned long old_flags;
>>   	unsigned long new_flags;
>>
>>   	switch (memtype) {
>> -	case _PAGE_CACHE_WC:
>> +	case _PAGE_CACHE_MODE_WC:
>>   		memtype_flags = _PGMT_WC;
>>   		break;
>> -	case _PAGE_CACHE_UC_MINUS:
>> +	case _PAGE_CACHE_MODE_UC_MINUS:
>>   		memtype_flags = _PGMT_UC_MINUS;
>>   		break;
>> -	case _PAGE_CACHE_WB:
>> +	case _PAGE_CACHE_MODE_WB:
>> +	default:
>>   		memtype_flags = _PGMT_WB;
>>   		break;
>>   	}
>
> Adding the "default" case handled as _PGMT_WB is not correct here.
> free_ram_pages_type() calls set_page_memtype() with -1, which needs to
> be set to _PGMT_DEFAULT.

It says so in the comment above. I'll correct it, thanks.

Juergen

