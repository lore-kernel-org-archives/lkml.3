Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147AbaKTIxf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 03:53:35 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:43517 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbaKTIxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 03:53:33 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-cc-546dac0b2b7e
Message-id: <546DAC06.9010700@samsung.com>
Date: Thu, 20 Nov 2014 11:53:26 +0300
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] kernel: irq: use a kmem_cache for allocating struct
 irq_desc
References: <1415621218-6438-1-git-send-email-a.ryabinin@samsung.com>
 <1415621218-6438-2-git-send-email-a.ryabinin@samsung.com>
 <alpine.DEB.2.10.1411191551350.32057@chino.kir.corp.google.com>
In-reply-to: <alpine.DEB.2.10.1411191551350.32057@chino.kir.corp.google.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJLMWRmVeSWpSXmKPExsVy+t/xK7rca3JDDG52KFtc3jWHzaJtyUYm
	i82bpjI7MHss2FTq8e7cOXaPz5vkApijuGxSUnMyy1KL9O0SuDJmr/vJXPCMt+LOwy2sDYyz
	ubsYOTkkBEwkWm7tYIGwxSQu3FvP1sXIxSEksJRRYu/pOUwgCSGBZiaJRQ+Muhg5OHgFtCRu
	HjMECbMIqEq83fSSEcRmE9CT+DdrOxuILSoQIXFlzRywOK+AoMSPyffA5osIaEi0zfjPBjKG
	WcBNov0D2AnCAuES2652sEJsOswosfOPJkgJp4CPxKal8RDVehL3L2qBVDALyEtsXvOWeQKj
	wCwk82chVM1CUrWAkXkVo2hqaXJBcVJ6rpFecWJucWleul5yfu4mRkhwft3BuPSY1SFGAQ5G
	JR7eC7NyQ4RYE8uKK3MPMUpwMCuJ8CotAQrxpiRWVqUW5ccXleakFh9iZOLglGpgXCUY8+Uc
	Y9ftU8s+iX71n5d6UWLpgR1he0LXFdo8/W94RNqg93v/fP8bbfNPB/mZyJ/8VqGRuTU/Ibn5
	xtywFcK5JQsWSkfc/B6n/c4irzU29pyQ+vKt6e7BksuOt/PuCLy6+5Wv09SoQ3Mzfv41fJow
	5TJLy725/+V2SududzTVO7W4rdzaQImlOCPRUIu5qDgRAEgmMuAsAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2014 02:52 AM, David Rientjes wrote:
> On Mon, 10 Nov 2014, Andrey Ryabinin wrote:
> 
>> After enabling alignment checks in UBSan I've noticed a lot of
>> reports like this:
>>
>>     UBSan: Undefined behaviour in ../kernel/irq/chip.c:195:14
>>     member access within misaligned address ffff88003e80d6f8
>>     for type 'struct irq_desc' which requires 16 byte alignment
>>
>> struct irq_desc declared with ____cacheline_internodealigned_in_smp
>> attribute. However in some cases it allocated dynamically via kmalloc().
>> In general case kmalloc() guaranties only sizeof(void *) alignment.
>> We should use a separate slab cache to make struct irq_desc
>> properly aligned on SMP configuration.
>>
>> This also could slightly reduce memory usage on some configurations.
>> E.g. in my setup sizeof(struct irq_desc) == 320. Which means that
>> kmalloc-512 will be used for allocating irg_desc via kmalloc().
>> In that case using separate slab cache will save us 192 bytes per
>> each irq_desc.
>>
>> Note: UBSan reports says that 'struct irq_desc' requires 16 byte alignment.
>> It's wrong, in my setup it should be 64 bytes. This looks like a gcc bug,
>> but it doesn't change the fact that irq_desc is misaligned.
>>
>> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
> 
> I think this is just fine, I would just prefer that you do the memset() 

I'd rather do kmem_cache_alloc_node(irq_desc_cachep, gfp | __GFP_ZERO, node)
instead of memset.

> explicitly rather than introduce the new slab function for such a 
> specialized purpose (unless there's other examples in the kernel where 
> this would be useful).
> 

I've counted 7 places where kmem_cache_alloc_node(..., gfp | __GFP_ZERO, ...); called.

