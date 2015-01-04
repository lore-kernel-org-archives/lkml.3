Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbbADNvX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 08:51:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586AbbADNvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 08:51:21 -0500
Message-ID: <54A94531.4050009@redhat.com>
Date: Sun, 04 Jan 2015 19:20:41 +0530
From: Pratyush Anand <panand@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        tixy@linaro.org, ananth@in.ibm.com, sandeepa.prabhu@linaro.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, anil.s.keshavamurthy@intel.com,
        masami.hiramatsu.pt@hitachi.com, wcohen@redhat.com
Subject: Re: [RFC 5/8] ARM64: Re-factor flush_ptrace_access
References: <cover.1420038188.git.panand@redhat.com> <f41f96aaed90007076ce496b9a0746c6f1a01ddb.1420038188.git.panand@redhat.com> <20150102175115.GB6761@redhat.com> <20150102181908.GA8466@redhat.com>
In-Reply-To: <20150102181908.GA8466@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Friday 02 January 2015 11:49 PM, Oleg Nesterov wrote:
> On 01/02, Oleg Nesterov wrote:
>>
>> On 12/31, Pratyush Anand wrote:
>>>
>>> Re-factor flush_ptrace_access to reuse vma independent part.
>>
>> But for what? The changelog should explain this.
>>
>>> Signed-off-by: Pratyush Anand <panand@redhat.com>
>>> ---
>>>   arch/arm64/mm/flush.c | 24 +++++++++++++++---------
>>>   1 file changed, 15 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/arch/arm64/mm/flush.c b/arch/arm64/mm/flush.c
>>> index b6f14e8d2121..9a4dd6f39cfb 100644
>>> --- a/arch/arm64/mm/flush.c
>>> +++ b/arch/arm64/mm/flush.c
>>> @@ -34,19 +34,25 @@ void flush_cache_range(struct vm_area_struct *vma, unsigned long start,
>>>   		__flush_icache_all();
>>>   }
>>>
>>> +static void __flush_ptrace_access(struct page *page, unsigned long uaddr,
>>> +		void *kaddr, unsigned long len)
>>> +{
>>> +	unsigned long addr = (unsigned long)kaddr;
>>> +
>>> +	if (icache_is_aliasing()) {
>>> +		__flush_dcache_area(kaddr, len);
>>> +		__flush_icache_all();
>>> +	} else {
>>> +		flush_icache_range(addr, addr + len);
>>> +	}
>>> +}
>>> +
>>>   static void flush_ptrace_access(struct vm_area_struct *vma, struct page *page,
>>>   				unsigned long uaddr, void *kaddr,
>>>   				unsigned long len)
>>>   {
>>> -	if (vma->vm_flags & VM_EXEC) {
>>> -		unsigned long addr = (unsigned long)kaddr;
>>> -		if (icache_is_aliasing()) {
>>> -			__flush_dcache_area(kaddr, len);
>>> -			__flush_icache_all();
>>> -		} else {
>>> -			flush_icache_range(addr, addr + len);
>>> -		}
>>> -	}
>>> +	if (vma->vm_flags & VM_EXEC)
>>> +		__flush_ptrace_access(page, uaddr, kaddr, len);
>>>   }
>>
>> So why uprobes can't use flush_ptrace_access() ? flush_uprobe_xol_access() is
>> called by arch_uprobe_copy_ixol(), and xol vma has VM_EXEC bit set.
>
> Ah, sorry, I forgot that arch_uprobe_copy_ixol() doesn't have "vma" so it
> can't use flush_ptrace_access()... perhaps you can update the changelog.
>

OK.. Will improve commit log.

~Pratyush
> Oleg.
>
