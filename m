Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639AbaAHVhy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 16:37:54 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:61196 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757412AbaAHVhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 16:37:50 -0500
MIME-Version: 1.0
In-Reply-To: <52CDBD94.9090808@gmx.de>
References: <alpine.LRH.2.02.1401041241590.4648@file01.intranet.prod.int.rdu2.redhat.com>
	<20140106073549.GA25771@lge.com>
	<alpine.LRH.2.02.1401061237120.6190@file01.intranet.prod.int.rdu2.redhat.com>
	<20140107014159.GA26726@lge.com>
	<52CDBD94.9090808@gmx.de>
Date: Wed, 8 Jan 2014 23:37:49 +0200
X-Google-Sender-Auth: VM1GoNtVS7HcW_7CRJ9ny-Guv-E
Message-ID: <CAOJsxLGJbRrDOesdSFnYCt9GOyTGEF0TDWNux06C3OxJnuLFMg@mail.gmail.com>
Subject: Re: [PATCH] fix crash when using XFS on loopback
From: Pekka Enberg <penberg@kernel.org>
To: Helge Deller <deller@gmx.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Mikulas Patocka <mpatocka@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 8, 2014 at 11:05 PM, Helge Deller <deller@gmx.de> wrote:
> On 01/07/2014 02:41 AM, Joonsoo Kim wrote:
>>
>> On Mon, Jan 06, 2014 at 12:54:22PM -0500, Mikulas Patocka wrote:
>>>
>>> Hi
>>>
>>> On Mon, 6 Jan 2014, Joonsoo Kim wrote:
>>>
>>>> Hello,
>>>>
>>>> I'm surprised that this VM_BUG_ON() has not been triggered until now. It
>>>> was
>>>> introduced in 2007 by commit (b5fab14). Maybe there is no person who
>>>> test
>>>> with CONFIG_DEBUG_VM.
>>>
>>> Last time I tried it, PS-RISC didn't work with CONFIG_DEBUG_VM at all.
>>>
>>>> There is one more bug report same as this.
>>>> * possible regression on 3.13 when calling flush_dcache_page
>>>>    (lkml.org/lkml/2013/12/12/255)
>>>
>>> That link doesn't show anything.
>>>
>>>> As mentioned in the description of commit (b5fab14), slab object may not
>>>> be
>>>> properly aligned and use of page oriented function to this object can be
>>>> dangerous. I searched the XFS code and found that they only try to
>>>> allocate
>>>> multiple of 512 bytes, so there is no problem for now. But, IMHO, it is
>>>> better
>>>> not to use slab objects for this purpose.
>>>
>>> If slab debugging is enabled, kmalloc memory is not aligned.
>>>
>>> In XFS in xfs_buf_allocate_memory they test if the kmalloc memory crosses
>>> page boundary - if it does, they free the kmalloc memory and allocate a
>>> full page. Maybe this approach could still run into problems with some
>>> bus-master adapters that assume alignment in hardware...
>>>
>>>
>>> dm-bufio also does I/O to slab-allocated buffers, but it allocates the
>>> object from slab (not kmalloc) with proper alignment.
>>
>> Hello,
>>
>> Okay. I see.
>> Thanks for good explanation.
>>
>>>> And I rapidly searched every callsites of page_mapping() and, IMHO, this
>>>> patch would work correctly. But possibly reverting original commit is
>>>> better solution.
>>>
>>> Reverting the original commit wouldn't fix that VM_BUG_ON.
>>
>> Initially, I thought that VM_BUG_ON() isn't wrong and it was better to
>> remove
>> the callsites where do I/O with slab-allocated buffers, because doing I/O
>> with slab-allocated buffers needs a great care. So I didn't fully agreed
>> with
>> your patch and recommended to revert original commit yesterday. After
>> reverting
>> that, I would attempt to remove the callsites.
>>
>> But, now, I change my thought, because of your explanation. There are
>> already
>> some users to do I/O with slab-allocated buffers and they already did it
>> with
>> some cares, so I guess that admitting this usage is more beneficial than
>> forbidding it.
>>
>> Reviewed-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>
>
> I can queue up this patch in my next pull-request for the parisc-tree which
> I plan to
> send tomorrow, unless people want this patch to go via mm-tree or
> similiar...
> Please let me know.

The patch looks good to me but it probably should go through Andrew's tree.

Acked-by: Pekka Enberg <penberg@kernel.org>
