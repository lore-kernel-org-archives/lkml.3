Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbaIHROR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 13:14:17 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:45245 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658AbaIHRON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 13:14:13 -0400
Message-ID: <540DE3E3.8090700@codeaurora.org>
Date: Mon, 08 Sep 2014 10:14:11 -0700
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Steve Capper <steve.capper@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
CC: "zhichang.yuan" <zhichang.yuan@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, Deepak Saxena <dsaxena@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Some questions about DEBUG_PAGEALLOC on ARMv8
References: <53F739C2.8070809@linaro.org> <20140904094152.GB16169@arm.com> <20140908105530.GB4866@e103986-lin>
In-Reply-To: <20140908105530.GB4866@e103986-lin>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/8/2014 3:55 AM, Steve Capper wrote:
> On Thu, Sep 04, 2014 at 10:41:52AM +0100, Catalin Marinas wrote:
>> Hi Zhichang,
>>
>> (cc'ing Steve Capper for the huge page stuff)
>>
>> On Fri, Aug 22, 2014 at 01:38:26PM +0100, zhichang.yuan wrote:
>>> I am working to implement the DEBUG_PAGEALLOC on ARMv8.
>>
>> I assume that's the arm64 kernel.
>>
>>> After i investigated the DEBUG_PAGEALLOC implementation on x86 arch,
>>> some questions are standing in the way to start coding.
>>>
>>> 1. How to handle the large page when DEBUG_PAGEALLOC is enabled In
>>> ARMv8, the kernel direct memory page table entries will set the block
>>> flag for better performance. When DEBUG_PAGEALLOC is configured, if
>>> the size of freed page is not multiply of page block size, there is no
>>> corresponding page table entry. In the old x86 kernel version, the
>>> large page to be freed will be split into normal page size and build
>>> the corresponding PTEs. And afterwards, someone done a patch to remove
>>> the splitting process. It will make the code simpler and easily
>>> stable.
>>
>> Initially, you could either map everything as pages or implement
>> splitting of huge pages (if for example the huge page is at the pmd
>> level, you allocate and populate a pte).
>>
>>> I prefer the current design in x86, what are your thoughts here?
>>
>> I haven't looked at it yet.
>>
>>> 2. Does ARMv8 support HIBERNATION?
>>
>> Not yet.
>>
>>> The HIBERNATION has some dependency on DEBUG_PAGEALLOC.
>>
>> Like in DEBUG_PAGEALLOC "depends on !HIBERNATION"?
>>
>>> 3. Is the hypothesis of DEBUG_PAGEALLOC always true?
>>
>> Which hypothesis?
>>
>>> From the x86 code, DEBUG_PAGEALLOC use the invalid page table entries
>>> to catch the accesses to free pages. This mechanism is based on the
>>> hypothesis that all the corresponding page table entries that are
>>> corresponding to the free pages are cleared correctly. Supposed this
>>> condition is always true, what we need to do is just to clear the
>>> kernel linear mapping page entries, since those page tables are
>>> fixable after initialization. DEBUG_PAGEALLOC on x86 seems to do like
>>> that.
>>
>> I guess that's the ARCH_SUPPORTS_DEBUG_PAGEALLOC rather than just the
>> simple DEBUG_PAGEALLOC which can be enabled on arm64 as well, you just
>> get page poisoning rather than invalid mappings.
>>
>> It could be done on arm64 as well but you need to sort out huge page
>> splitting or just map everything as pages when the option is enabled.
>>
> 
> (cc'ing Laura Abbott for info...)
> 
> Hi,
> There is support for splitting pmd's and pud's in the direct kernel
> mapping in the following series from Laura Abbott:
> 
> "[PATCHv3 7/7] arm64: add better page protections to arm64"
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-August/280782.html
> 
> Perhaps some of the splitting logic there could be used by the
> kernel_map_pages arm64 implementation for ARCH_SUPPORTS_DEBUG_PAGEALLOC?
> 
> Cheers,
> 

The page splitting was originally written for a out of tree implementation
of something similar to ARCH_SUPPORTS_DEBUG_PAGEALLOC for both arm and
arm64 so yes it could be used. The approach taken was 
	- map all memory with sections initially
	- walk all memblock and remap as 4K pages

There is a performance hit involved but for some issues the benefits certainly
outweigh the costs (One person described it as 'the best feature since
CONFIG_SLUB_DEBUG'). 

If there is interest, I can clean up the patches and submit them as a proof
of concept. The approach probably won't cover 64K/THP but it might be a
starting point.

Thanks,
Laura

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
