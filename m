Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310AbaFLHHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 03:07:32 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:54224 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbaFLHHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 03:07:30 -0400
Date: Thu, 12 Jun 2014 00:07:28 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Zhang Zhen <zhenzhang.zhang@huawei.com>
cc: gregkh@linuxfoundation.org, laijs@cn.fujitsu.com,
        sjenning@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Wang Nan <wangnan0@huawei.com>
Subject: Re: Proposal to realize hot-add *several sections one time*
In-Reply-To: <53991353.5040607@huawei.com>
Message-ID: <alpine.DEB.2.02.1406120002410.23724@chino.kir.corp.google.com>
References: <53981D81.5060708@huawei.com> <alpine.DEB.2.02.1406111503050.27885@chino.kir.corp.google.com> <53991353.5040607@huawei.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2014, Zhang Zhen wrote:

> >> % echo start_address_of_new_memory count_of_sections > /sys/devices/system/memory/probe
> >>
> >> Then, [start_address_of_new_memory, start_address_of_new_memory +
> >> count_of_sections * memory_block_size] memory range is hot-added.
> >>
> >> If this proposal is reasonable, i will send a patch to realize it.
> >>
> > 
> > The problem is knowing how much memory is being onlined so that you can 
> > definitively determine what count_of_sections should be.  The number of 
> > pages per memory section depends on PAGE_SIZE and SECTION_SIZE_BITS which 
> > differ depending on the architectures that support this interface.  So if 
> > you support count_of_sections, it would return errno even though you have 
> > onlined some sections.
> > 
> Hum, sorry.
> My expression is not right. The count of sections one time hot-added
> depends on sections_per_block.
> 

Ok, so you know specifically what sections_per_block is for your platform 
so you know exactly how many sections need to be added.

> Now we are porting the memory-hotplug to arm.
> But we can only hot-add *fixed number of sections one time* on particular architecture.
> 
> Whether we can add an argument on behalf of the count of the blocks to add ?
> 
> % echo start_address_of_new_memory count_of_blocks > /sys/devices/system/memory/probe
> 
> Then, [start_address_of_new_memory, start_address_of_new_memory + count_of_blocks * memory_block_size]
> memory range is hot-added.
> 

As I said, if the above returns errno at some point, it still can result 
in some sections being onlined.  To be clear: if
"echo 0x10000000 > /sys/devices/system/memory/probe" fails, the section 
starting at address 0x10000000 failed to be onlined for the reason 
specified by errno.  If we follow your suggestion to specify how many 
sections to online, if
"echo '0x10000000 16' > /sys/devices/system/memory/probe" fails, eight 
sections could have been successfully onlined at address 0x10000000 and 
then we encountered a failure (perhaps because the next sections were 
already onlined, we get an -EEXIST).  We don't know what we successfully 
onlined.

This could be mitigated, but there would have to be a convincing reason 
that this is better than using the currently functionally in a loop and 
properly handling your error codes.
