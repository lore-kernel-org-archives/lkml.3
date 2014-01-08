Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604AbaAHVmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 16:42:11 -0500
Received: from mout.gmx.net ([212.227.17.21]:64902 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532AbaAHVmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 16:42:07 -0500
Message-ID: <52CDC62B.1000409@gmx.de>
Date: Wed, 08 Jan 2014 22:42:03 +0100
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Mikulas Patocka <mpatocka@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fix crash when using XFS on loopback
References: <alpine.LRH.2.02.1401041241590.4648@file01.intranet.prod.int.rdu2.redhat.com>	<20140106073549.GA25771@lge.com>	<alpine.LRH.2.02.1401061237120.6190@file01.intranet.prod.int.rdu2.redhat.com>	<20140107014159.GA26726@lge.com>	<52CDBD94.9090808@gmx.de> <CAOJsxLGJbRrDOesdSFnYCt9GOyTGEF0TDWNux06C3OxJnuLFMg@mail.gmail.com>
In-Reply-To: <CAOJsxLGJbRrDOesdSFnYCt9GOyTGEF0TDWNux06C3OxJnuLFMg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:ACCOecyM96B+Nx2ZWImviXzWuTSPUVd4fQ1ON57GgwrXNlI0vjy
 Qec2T08XcYInvONK5MXUNeNS6beKZZ/8kwsvWpiFm58200ZbvmN1IhUMBA6haHcI3prxYht
 p0xSWywsnHpm1jzLXJPYrWkzT39Ahu26CAoKQp4uewAAf5KIZa6aXSMC0NL2LMNuU579AOD
 sK6OWLB8pbYDO0LG6iFhg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2014 10:37 PM, Pekka Enberg wrote:
> On Wed, Jan 8, 2014 at 11:05 PM, Helge Deller <deller@gmx.de> wrote:
>> On 01/07/2014 02:41 AM, Joonsoo Kim wrote:
>>> On Mon, Jan 06, 2014 at 12:54:22PM -0500, Mikulas Patocka wrote:
>>>> Hi
>>>>
>>>> On Mon, 6 Jan 2014, Joonsoo Kim wrote:
>>>>
>>>>> Hello,
>>>>>
>>>>> I'm surprised that this VM_BUG_ON() has not been triggered until now. It
>>>>> was
>>>>> introduced in 2007 by commit (b5fab14). Maybe there is no person who
>>>>> test
>>>>> with CONFIG_DEBUG_VM.
>>>> Last time I tried it, PS-RISC didn't work with CONFIG_DEBUG_VM at all.
>>>>
>>>>> There is one more bug report same as this.
>>>>> * possible regression on 3.13 when calling flush_dcache_page
>>>>>     (lkml.org/lkml/2013/12/12/255)
>>>> That link doesn't show anything.
>>>>
>>>>> As mentioned in the description of commit (b5fab14), slab object may not
>>>>> be
>>>>> properly aligned and use of page oriented function to this object can be
>>>>> dangerous. I searched the XFS code and found that they only try to
>>>>> allocate
>>>>> multiple of 512 bytes, so there is no problem for now. But, IMHO, it is
>>>>> better
>>>>> not to use slab objects for this purpose.
>>>> If slab debugging is enabled, kmalloc memory is not aligned.
>>>>
>>>> In XFS in xfs_buf_allocate_memory they test if the kmalloc memory crosses
>>>> page boundary - if it does, they free the kmalloc memory and allocate a
>>>> full page. Maybe this approach could still run into problems with some
>>>> bus-master adapters that assume alignment in hardware...
>>>>
>>>>
>>>> dm-bufio also does I/O to slab-allocated buffers, but it allocates the
>>>> object from slab (not kmalloc) with proper alignment.
>>> Hello,
>>>
>>> Okay. I see.
>>> Thanks for good explanation.
>>>
>>>>> And I rapidly searched every callsites of page_mapping() and, IMHO, this
>>>>> patch would work correctly. But possibly reverting original commit is
>>>>> better solution.
>>>> Reverting the original commit wouldn't fix that VM_BUG_ON.
>>> Initially, I thought that VM_BUG_ON() isn't wrong and it was better to
>>> remove
>>> the callsites where do I/O with slab-allocated buffers, because doing I/O
>>> with slab-allocated buffers needs a great care. So I didn't fully agreed
>>> with
>>> your patch and recommended to revert original commit yesterday. After
>>> reverting
>>> that, I would attempt to remove the callsites.
>>>
>>> But, now, I change my thought, because of your explanation. There are
>>> already
>>> some users to do I/O with slab-allocated buffers and they already did it
>>> with
>>> some cares, so I guess that admitting this usage is more beneficial than
>>> forbidding it.
>>>
>>> Reviewed-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>>
>> I can queue up this patch in my next pull-request for the parisc-tree which
>> I plan to
>> send tomorrow, unless people want this patch to go via mm-tree or
>> similiar...
>> Please let me know.
> The patch looks good to me but it probably should go through Andrew's tree.
>
> Acked-by: Pekka Enberg <penberg@kernel.org>

Absolutely fine with me. Andrew, can you please pick it up for 3.13 ?
Thanks,
Helge

