Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbaAXHXC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 02:23:02 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:45847 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbaAXHXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 02:23:00 -0500
Message-ID: <52E214C7.9050309@ti.com>
Date: Fri, 24 Jan 2014 02:22:47 -0500
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
References: <52E19C7D.7050603@intel.com> <CAE9FiQX9kTxnaqpWNgg3dUzr7+60YCrEx3q3xxO-G1n6z64xVQ@mail.gmail.com> <52E20A56.1000507@ti.com> <52E20E98.7010703@ti.com> <CAE9FiQWRkP1Hir6UFuPRGu6bXNd_SHonuaC-MG1UD-tSeE0teQ@mail.gmail.com>
In-Reply-To: <CAE9FiQWRkP1Hir6UFuPRGu6bXNd_SHonuaC-MG1UD-tSeE0teQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 January 2014 02:04 AM, Yinghai Lu wrote:
> On Thu, Jan 23, 2014 at 10:56 PM, Santosh Shilimkar
> <santosh.shilimkar@ti.com> wrote:
>> On Friday 24 January 2014 01:38 AM, Santosh Shilimkar wrote:
> 
>> The patch which is now commit 457ff1d {lib/swiotlb.c: use
>> memblock apis for early memory allocations} was the breaking the
>> boot on Andrew's machine. Now if I look back the patch, based on your
>> above description, I believe below hunk waS/is the culprit.
>>
>> @@ -172,8 +172,9 @@ int __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
>>         /*
>>          * Get the overflow emergency buffer
>>          */
>> -       v_overflow_buffer = alloc_bootmem_low_pages_nopanic(
>> -                                               PAGE_ALIGN(io_tlb_overflow));
>> +       v_overflow_buffer = memblock_virt_alloc_nopanic(
>> +                                               PAGE_ALIGN(io_tlb_overflow),
>> +                                               PAGE_SIZE);
>>         if (!v_overflow_buffer)
>>                 return -ENOMEM;
>>
>>
>> Looks like 'v_overflow_buffer' must be allocated from low memory in this
>> case. Is that correct ?
> 
> yes.
> 
> but should the change like following
> 
> commit 457ff1de2d247d9b8917c4664c2325321a35e313
> Author: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Date:   Tue Jan 21 15:50:30 2014 -0800
> 
>     lib/swiotlb.c: use memblock apis for early memory allocations
> 
> 
> @@ -215,13 +220,13 @@ swiotlb_init(int verbose)
>         bytes = io_tlb_nslabs << IO_TLB_SHIFT;
> 
>         /* Get IO TLB memory from the low pages */
> -       vstart = alloc_bootmem_low_pages_nopanic(PAGE_ALIGN(bytes));
> +       vstart = memblock_virt_alloc_nopanic(PAGE_ALIGN(bytes), PAGE_SIZE);
>         if (vstart && !swiotlb_init_with_tbl(vstart, io_tlb_nslabs, verbose))
>                 return;
> 
OK. So we need '__alloc_bootmem_low()' equivalent memblock API. We will try
to come up with a patch for the same. Thanks for inputs.

Regards,
Santosh
