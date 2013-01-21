Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab3AUG5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 01:57:09 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37174 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab3AUG5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 01:57:07 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Date: Mon, 21 Jan 2013 15:56:50 +0900 (JST)
Message-Id: <20130121.155650.229769620.d.hatayama@jp.fujitsu.com>
To: vgoyal@redhat.com
Cc: riel@redhat.com, kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        lisa.mitchell@hp.com, kumagai-atsushi@mxc.nes.nec.co.jp,
        ebiederm@xmission.com, cpw@sgi.com
Subject: Re: [RFC PATCH v1 0/3] kdump, vmcore: Map vmcore memory in direct
 mapping region
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <20130118205413.GB10969@redhat.com>
References: <20130117221348.GJ2237@redhat.com>
	<20130118.230659.282304499.d.hatayama@jp.fujitsu.com>
	<20130118205413.GB10969@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 24.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC PATCH v1 0/3] kdump, vmcore: Map vmcore memory in direct mapping region
Date: Fri, 18 Jan 2013 15:54:13 -0500

> On Fri, Jan 18, 2013 at 11:06:59PM +0900, HATAYAMA Daisuke wrote:
> 
> [..]
>> > These are impressive improvements. I missed the discussion on mmap().
>> > So why couldn't we provide mmap() interface for /proc/vmcore. If that
>> > works then application can select to mmap/unmap bigger chunks of file
>> > (instead ioremap mapping/remapping a page at a time). 
>> > 
>> > And if application controls the size of mapping, then it can vary the
>> > size of mapping based on available amount of free memory. That way if
>> > somebody reserves less amount of memory, we could still dump but with
>> > some time penalty.
>> > 
>> 
>> mmap() needs user-space page table in addition to kernel-space's,
> 
> [ CC Rik van Riel] 
> 
> I was chatting with Rik and it does not look like that there is any
> fundamental requirement that range of pfn being mapped in user tables
> has to be mapped in kernel tables too. Did you run into specific issue.
> 

No, I was confused simply this around.

>> and
>> it looks that remap_pfn_range() that creates the user-space page
>> table, doesn't support large pages, only 4KB pages.
> 
> This indeed looks like the case. May be we can enahnce remap_pfn_range()
> to take an argument and create larger size mappings.
> 

Adding a new argument to remap_pfn_range would never easily be
accepted because it changes signature of it. It is the function that
is exported to modules.

As init_memory_mapping does, it should internally automatically divide
a given ranges of kernel address space into properly aligned ones then
remap them.

Also, if we extend this in the future, we need to have some feature
for userland to know a given kernel can use 2MB/1GB pages for
remapping. makedumpfile needs to estimate how much memory is required
for the remapping.

>> If mmaping small
>> chunks only for small memory programming, then we would again face the
>> same issue as with ioremap.
> 
> Even if it is 4KB pages, I think it will still be faster than current
> interface. Because we will not be issuing these many tlb flushes.
> (Assuming makedumpfile has been modified to map/unap large areas of
> /proc/vmcore).
> 

OK, I'll go in this direction first. From my local investigation, I'm
beginning with thinking that my idea to map a whole DIMM ranges in
direct mapping region is difficult due to some memory hot-plug issues,
and mmap interface is more useful than keeping page table handling in
/proc/vmcore when we process /proc/vmcore in paralell where each
process reads different range.

Assuming we can use 4KB pages only, if we use 1MB buffer for page
table, we can cover about 500MB memory region. Then, remapping is done
about 2000 times. On ioremap case, remapping is done 268435456
times. Peformacne should be improved so much. We should benchmark this
first.

Thanks.
HATAYAMA, Daisuke

