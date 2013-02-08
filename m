Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760452Ab3BHXQc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 18:16:32 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:60686 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757205Ab3BHXQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 18:16:30 -0500
Message-ID: <51158742.4030803@linux.vnet.ibm.com>
Date: Fri, 08 Feb 2013 15:16:18 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, bp@alien8.de,
        mingo@kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 1/2] add helper for highmem checks
References: <20130208202813.62965F25@kernel.stglabs.ibm.com> <51156507.50900@zytor.com>
In-Reply-To: <51156507.50900@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020823-7408-0000-0000-00000CA4A9CB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2013 12:50 PM, H. Peter Anvin wrote:
> On 02/08/2013 12:28 PM, Dave Hansen wrote:
>> +static inline phys_addr_t last_lowmem_phys_addr(void)
>> +{
>> +    /*
>> +     * 'high_memory' is not a pointer that can be dereferenced, so
>> +     * avoid calling __pa() on it directly.
>> +     */
>> +    return __pa(high_memory - 1);
>> +}
>> +static inline bool phys_addr_is_highmem(phys_addr_t addr)
>> +{
>> +    return addr > last_lowmem_paddr();
>> +}
>> +
> 
> Are we sure that high_memory - 1 is always a valid reference?  Consider
> especially the case where there is MMIO beyond end of memory on a system
> which has less RAM than the HIGHMEM boundary...

Yeah, I think it is.  "high_memory" should point at either the end of
RAM, or the end of the linear map, whichever is lower.  See setup_arch():

        max_pfn = e820_end_of_ram_pfn();
	...
        high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;

or in the highmem init code:

        high_memory = (void *) __va(max_low_pfn * PAGE_SIZE - 1) + 1;

