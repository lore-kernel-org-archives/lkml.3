Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab3JBSh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 14:37:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36959 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753776Ab3JBSh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 14:37:26 -0400
Message-ID: <524C6799.9060800@zytor.com>
Date: Wed, 02 Oct 2013 11:36:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Frantisek Hrbata <fhrbata@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, oleg@redhat.com,
        kamaleshb@in.ibm.com, hechjie@cn.ibm.com, akpm@linux-foundation.org,
        dave.hansen@intel.com
Subject: Re: [RESEND PATCH] x86: add phys addr validity check for /dev/mem
 mmap
References: <20131002160514.GA25471@localhost.localdomain> <524C5BFB.5050501@zytor.com> <20131002183155.GA2975@localhost.localdomain>
In-Reply-To: <20131002183155.GA2975@localhost.localdomain>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2013 11:31 AM, Frantisek Hrbata wrote:
> On Wed, Oct 02, 2013 at 10:46:35AM -0700, H. Peter Anvin wrote:
>> On 10/02/2013 09:05 AM, Frantisek Hrbata wrote:
>>> +
>>> +int valid_phys_addr_range(phys_addr_t addr, size_t count)
>>> +{
>>> +	return addr + count <= __pa(high_memory);
>>> +}
>>> +
>>> +int valid_mmap_phys_addr_range(unsigned long pfn, size_t count)
>>> +{
>>> +	resource_size_t addr = (pfn << PAGE_SHIFT) + count;
>>> +	return phys_addr_valid(addr);
>>> +}
>>>
>>
>> The latter has overflow problems.
> 
> Could you please specify what overflow problems do you mean?

Consider if pfn + count overflows and wraps around, or if (pfn <<
PAGE_SHIFT) pushes bits out to the left.

>> The former I realize matches the current /dev/mem, but it is still just
>> plain wrong in multiple ways.
> 
> I guess that you are talking about /dev/mem implementation generelly, because
> this patch is exactly the same as the first one. All I'm trying to do here is to
> fix this simple problem, which was reported by a customer, using IMHO the least
> invasive way. Anyway is there any description what is wrong with /dev/mem
> implementation? Maybe I can try to take a look.
> 

The bottom line is that read/write to /dev/mem should be able to access
the same memory that we can mmap().  Having two different tests is
ridiculous.

	-hpa


