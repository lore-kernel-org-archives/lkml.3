Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbaAXG4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 01:56:42 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:38728 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbaAXG4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 01:56:40 -0500
Message-ID: <52E20E98.7010703@ti.com>
Date: Fri, 24 Jan 2014 01:56:24 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Dave Hansen <dave.hansen@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Panic on 8-node system in memblock_virt_alloc_try_nid()
References: <52E19C7D.7050603@intel.com> <CAE9FiQX9kTxnaqpWNgg3dUzr7+60YCrEx3q3xxO-G1n6z64xVQ@mail.gmail.com> <52E20A56.1000507@ti.com>
In-Reply-To: <52E20A56.1000507@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 January 2014 01:38 AM, Santosh Shilimkar wrote:
> Yinghai,
> 
> On Friday 24 January 2014 12:55 AM, Yinghai Lu wrote:
>> On Thu, Jan 23, 2014 at 2:49 PM, Dave Hansen <dave.hansen@intel.com> wrote:
>>>> Linus's current tree doesn't boot on an 8-node/1TB NUMA system that I
>>>> have.  Its reboots are *LONG*, so I haven't fully bisected it, but it's
>>>> down to a just a few commits, most of which are changes to the memblock
>>>> code.  Since the panic is in the memblock code, it looks like a
>>>> no-brainer.  It's almost certainly the code from Santosh or Grygorii
>>>> that's triggering this.
>>>>
>>>> Config and good/bad dmesg with memblock=debug are here:
>>>>
>>>>         http://sr71.net/~dave/intel/3.13/
>>>>
>>>> Please let me know if you need it bisected further than this.
>> Please check attached patch, and it should fix the problem.
>>
> 
> [...]
> 
>>
>> Subject: [PATCH] x86: Fix numa with reverting wrong memblock setting.
>>
>> Dave reported Numa on x86 is broken on system with 1T memory.
>>
>> It turns out
>> | commit 5b6e529521d35e1bcaa0fe43456d1bbb335cae5d
>> | Author: Santosh Shilimkar <santosh.shilimkar@ti.com>
>> | Date:   Tue Jan 21 15:50:03 2014 -0800
>> |
>> |    x86: memblock: set current limit to max low memory address
>>
>> set limit to low wrongly.
>>
>> max_low_pfn_mapped is different from max_pfn_mapped.
>> max_low_pfn_mapped is always under 4G.
>>
>> That will memblock_alloc_nid all go under 4G.
>>
>> Revert that offending patch.
>>
>> Reported-by: Dave Hansen <dave.hansen@intel.com>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>>
> This mostly will fix the $subject issue but the regression 
> reported by Andrew [1] will surface with the revert. Its clear
> now that even though commit fixed the issue, it wasn't the fix.
> 
> Would be great if you can have a look at the thread.
> 
The patch which is now commit 457ff1d {lib/swiotlb.c: use 
memblock apis for early memory allocations} was the breaking the
boot on Andrew's machine. Now if I look back the patch, based on your
above description, I believe below hunk waS/is the culprit.

@@ -172,8 +172,9 @@ int __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
 	/*
 	 * Get the overflow emergency buffer
 	 */
-	v_overflow_buffer = alloc_bootmem_low_pages_nopanic(
-						PAGE_ALIGN(io_tlb_overflow));
+	v_overflow_buffer = memblock_virt_alloc_nopanic(
+						PAGE_ALIGN(io_tlb_overflow),
+						PAGE_SIZE);
 	if (!v_overflow_buffer)
 		return -ENOMEM;


Looks like 'v_overflow_buffer' must be allocated from low memory in this
case. Is that correct ?

Regards,
Santosh
