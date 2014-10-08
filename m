Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbaJHOXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 10:23:18 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:40068 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673AbaJHOXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 10:23:17 -0400
Message-ID: <543548C3.7030003@oracle.com>
Date: Wed, 08 Oct 2014 10:22:59 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Dave Hansen <dave.hansen@intel.com>, akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com,
        mgorman@suse.de, Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 5/5] mm: poison page struct
References: <1412041639-23617-1-git-send-email-sasha.levin@oracle.com> <1412041639-23617-6-git-send-email-sasha.levin@oracle.com> <5434630C.3070006@intel.com>
In-Reply-To: <5434630C.3070006@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2014 06:02 PM, Dave Hansen wrote:
> On 09/29/2014 06:47 PM, Sasha Levin wrote:
>>  struct page {
>> +#ifdef CONFIG_DEBUG_VM_POISON
>> +	u32 poison_start;
>> +#endif
>>  	/* First double word block */
>>  	unsigned long flags;		/* Atomic flags, some possibly
>>  					 * updated asynchronously */
>> @@ -196,6 +199,9 @@ struct page {
>>  #ifdef LAST_CPUPID_NOT_IN_PAGE_FLAGS
>>  	int _last_cpupid;
>>  #endif
>> +#ifdef CONFIG_DEBUG_VM_POISON
>> +	u32 poison_end;
>> +#endif
>>  }
> 
> Does this break slub's __cmpxchg_double_slab trick?  I thought it
> required page->freelist and page->counters to be doubleword-aligned.

I'll probably have to switch it to 8 bytes anyways to make it work with
kasan. This should take care of the slub optimization as well.

> It's not like we really require this optimization when we're debugging,
> but trying to use it will unnecessarily slow things down.
> 
> FWIW, if you're looking to trim down the number of lines of code, you
> could certainly play some macro tricks and #ifdef tricks.
> 
> struct vm_poison {
> #ifdef CONFIG_DEBUG_VM_POISON
> 	u32 val;
> #endif	
> };
> 
> Then, instead of #ifdefs in each structure, you do:
> 
> struct page {
> 	struct vm_poison poison_start;
> 	... other gunk
> 	struct vm_poison poison_end;
> };

Agreed, I'll reword that in the next version.


Thanks,
Sasha

