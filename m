Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbaINJgc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 05:36:32 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:49375 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbaINJg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 05:36:29 -0400
Message-ID: <54156197.5050303@gmail.com>
Date: Sun, 14 Sep 2014 12:36:23 +0300
From: Boaz Harrosh <openosd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Dave Hansen <dave.hansen@intel.com>, Boaz Harrosh <boaz@plexistor.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@fb.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-nvdimm@ml01.01.org, Toshi Kani <toshi.kani@hp.com>,
        linux-mm@kvack.org
CC: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/9] mm: Let sparse_{add,remove}_one_section receive a
 node_id
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com> <540F1EC6.4000504@plexistor.com> <540F20AB.4000404@plexistor.com> <540F48BA.2090304@intel.com> <541022DB.9090000@plexistor.com> <541077DF.1060609@intel.com> <5410899C.3030501@plexistor.com> <54109845.3050309@intel.com> <54115FAB.2050601@gmail.com> <5411D6D9.5080107@intel.com>
In-Reply-To: <5411D6D9.5080107@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2014 08:07 PM, Dave Hansen wrote:
<>
> 
> OK, that sounds like it will work.  The "leaked until the next mount"
> sounds disastrous, but I'm sure you'll fix that.  I can see how it might
> lead to some fragmentation if only small amounts are ever pinned, but
> not a deal-breaker.
> 

There is no such thing as fragmentation with memory mapped storage ;-)

<>
> I'm saying that, if we have a 'struct page' for the memory, we should
> try to make the mmap()s more normal.  This enables all kinds of things
> that DAX does not support today, like direct I/O.
> 

What? no! direct I/O is fully supported. Including all API's of it. Do
you mean open(O_DIRECT) and io_submit(..) Yes it is fully supported.

In fact all IO is direct IO. there is never page-cache on the way, hence direct

BTW: These patches enable something else. Say FSA is DAX and FSB is regular
disk FS then
	fda = open(/mnt/FSA);
	pa = mmap(fda, ...);

	fdb = open(/mnt/FSB, O_DIRECT);
	io_submit(fdb,..,pa ,..);
	/* I mean pa is put for IO into the passed iocb for fdb */

Before this patch above will not work and revert to buffered IO, but
with these patches it will work.
Please note this is true for the submitted pmem driver. With brd which
also supports DAX this will work, because brd always uses pages.

<>
> Great, so we at least agree that this adds complexity.
> 

But the complexity is already there DAX by Matthew is to go in soon I hope.
Surly these added pages do not add to the complexity that much.

<>
> 
> OK, so I think I at least understand the scope of the patch set and the
> limitations.  I think I've summarized the limitations:
> 
> 1. Approach requires all of RAM+Pmem to be direct-mapped (rules out
>    almost all 32-bit systems, or any 64-bit systems with more than 64TB
>    of RAM+pmem-storage)

Yes, for NOW

> 2. Approach is currently incompatible with some kernel code that
>    requires a 'struct page' (such as direct I/O), and all kernel code
>    that requires knowledge of zones or NUMA nodes.

NO!
Direct IO - supported
NUMA - supported

"all kernel code that requires knowledge of zones" - Not needed

> 3. Approach requires 1/64 of the amount of storage to be consumed by
>    RAM for a pseudo 'struct page'.  If you had 64GB of storage and 1GB
>    of RAM, you would simply run our of RAM.
> 

Yes so in a system as above of 64GB of pmem, 1GB of pmem will need to be
set aside and hotpluged as volatile memory. This already works today BTW
you can set aside a portion of NvDIMM and hotplug it as system memory.

We are already used to pay that ratio for RAM.
On a kernel-config choice that ratio can be also paid for pmem. This is
why I left it a configuration option

> Did I miss any?
> 

Thanks
Boaz

