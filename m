Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934110AbaDJBEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 21:04:24 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:45275 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932996AbaDJBEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 21:04:23 -0400
X-IronPort-AV: E=Sophos;i="4.97,830,1389715200"; 
   d="scan'208";a="29069902"
Message-ID: <5345EDCC.2000900@cn.fujitsu.com>
Date: Thu, 10 Apr 2014 09:03:08 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131030 Thunderbird/17.0.10
MIME-Version: 1.0
To: Nathan Fontenot <nfont@linux.vnet.ibm.com>
CC: Dave Hansen <dave.hansen@intel.com>, Li Zhong <zhong@linux.vnet.ibm.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC PATCH] memory driver: make phys_index/end_phys_index reflect
 the start/end section number
References: <1396429018.2913.19.camel@ThinkPad-T5421.cn.ibm.com> <533E0B0E.9020909@jp.fujitsu.com> <1396945659.3162.6.camel@ThinkPad-T5421.cn.ibm.com> <53442021.2060608@intel.com> <53443E8C.4070906@linux.vnet.ibm.com> <53445245.3020400@intel.com> <534585E8.50302@linux.vnet.ibm.com>
In-Reply-To: <534585E8.50302@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.197]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2014 01:39 AM, Nathan Fontenot wrote:
> On 04/08/2014 02:47 PM, Dave Hansen wrote:
>>
>> That document really needs to be updated to stop referring to sections
>> (at least in the descriptions of the user interface).  We can not change
>> the units of phys_index/end_phys_index without also changing
>> block_size_bytes.
>>
> 
> Here is a first pass at updating the documentation.
> 
> I have tried to update the documentation to refer to memory blocks instead
> of memory sections where appropriate and added a paragraph to explain
> that memory blocks are mode of memory sections.
> 
> Thoughts?

I think the change is basically ok. So

Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

Only one nitpick below.

> 
> -Nathan
> ---
>  Documentation/memory-hotplug.txt |  113 ++++++++++++++++++++-------------------
>  1 file changed, 59 insertions(+), 54 deletions(-)
> 
> Index: linux/Documentation/memory-hotplug.txt
> ===================================================================
> --- linux.orig/Documentation/memory-hotplug.txt
> +++ linux/Documentation/memory-hotplug.txt
> @@ -88,16 +88,21 @@ phase by hand.
>  
>  1.3. Unit of Memory online/offline operation
>  ------------
> -Memory hotplug uses SPARSEMEM memory model. SPARSEMEM divides the whole memory
> -into chunks of the same size. The chunk is called a "section". The size of
> -a section is architecture dependent. For example, power uses 16MiB, ia64 uses
> -1GiB. The unit of online/offline operation is "one section". (see Section 3.)
> +Memory hotplug uses SPARSEMEM memory model which allows memory to be divided
> +into chunks of the same size. These chunks are called "sections". The size of
> +a memory section is architecture dependent. For example, power uses 16MiB, ia64
> +uses 1GiB.
> +
> +Memory sections are combined into chunks referred to as "memory blocks". The
> +size of a memory block is architecture dependent and represents the logical
> +unit upon which memory online/offline operations are to be performed. The
> +default size of a memory block is the same as memory section size unless an
> +architecture specifies otherwise. (see Section 3.)
>  
> -To determine the size of sections, please read this file:
> +To determine the size (in bytes) of a memory block please read this file:
>  
>  /sys/devices/system/memory/block_size_bytes
>  
> -This file shows the size of sections in byte.
>  
>  -----------------------
>  2. Kernel Configuration
> @@ -123,14 +128,15 @@ config options.
>      (CONFIG_ACPI_CONTAINER).
>      This option can be kernel module too.
>  
> +
>  --------------------------------
> -4 sysfs files for memory hotplug
> +3 sysfs files for memory hotplug
>  --------------------------------
> -All sections have their device information in sysfs.  Each section is part of
> -a memory block under /sys/devices/system/memory as
> +All memory blocks have their device information in sysfs.  Each memory block
> +is described under /sys/devices/system/memory as
>  
>  /sys/devices/system/memory/memoryXXX
> -(XXX is the section id.)
> +(XXX is the memory block id.)
>  
>  Now, XXX is defined as (start_address_of_section / section_size) of the first
>  section contained in the memory block.  The files 'phys_index' and
> @@ -141,13 +147,13 @@ range. Currently there is no way to dete
>  the existence of one should not affect the hotplug capabilities of the memory
>  block.
>  
> -For example, assume 1GiB section size. A device for a memory starting at
> +For example, assume 1GiB memory block size. A device for a memory starting at
>  0x100000000 is /sys/device/system/memory/memory4
>  (0x100000000 / 1Gib = 4)
>  This device covers address range [0x100000000 ... 0x140000000)
>  
> -Under each section, you can see 4 or 5 files, the end_phys_index file being
> -a recent addition and not present on older kernels.
> +Under each memory block, you can see 4 or 5 files, the end_phys_index file
> +being a recent addition and not present on older kernels.
>  
>  /sys/devices/system/memory/memoryXXX/start_phys_index
>  /sys/devices/system/memory/memoryXXX/end_phys_index
> @@ -185,6 +191,7 @@ For example:
>  A backlink will also be created:
>  /sys/devices/system/memory/memory9/node0 -> ../../node/node0
>  
> +
>  --------------------------------
>  4. Physical memory hot-add phase
>  --------------------------------
> @@ -227,11 +234,10 @@ You can tell the physical address of new
>  
>  % echo start_address_of_new_memory > /sys/devices/system/memory/probe
>  
> -Then, [start_address_of_new_memory, start_address_of_new_memory + section_size)
> -memory range is hot-added. In this case, hotplug script is not called (in
> -current implementation). You'll have to online memory by yourself.
> -Please see "How to online memory" in this text.
> -
> +Then, [start_address_of_new_memory, start_address_of_new_memory +
> +memory_block_size] memory range is hot-added. In this case, hotplug script is
> +not called (in current implementation). You'll have to online memory by
> +yourself.  Please see "How to online memory" in this text.
>  
>  
>  ------------------------------
> @@ -240,36 +246,36 @@ Please see "How to online memory" in thi
>  
>  5.1. State of memory
>  ------------
> -To see (online/offline) state of memory section, read 'state' file.
> +To see (online/offline) state of a memory block, read 'state' file.
>  
>  % cat /sys/device/system/memory/memoryXXX/state
>  
>  
> -If the memory section is online, you'll read "online".
> -If the memory section is offline, you'll read "offline".
> +If the memory block is online, you'll read "online".
> +If the memory block is offline, you'll read "offline".
>  
>  
>  5.2. How to online memory
>  ------------
>  Even if the memory is hot-added, it is not at ready-to-use state.
> -For using newly added memory, you have to "online" the memory section.
> +For using newly added memory, you have to "online" the memory block.
>  
> -For onlining, you have to write "online" to the section's state file as:
> +For onlining, you have to write "online" to the memory block's state file as:
>  
>  % echo online > /sys/devices/system/memory/memoryXXX/state
>  
> -This onlining will not change the ZONE type of the target memory section,
> -If the memory section is in ZONE_NORMAL, you can change it to ZONE_MOVABLE:
> +This onlining will not change the ZONE type of the target memory block,
> +If the memory block is in ZONE_NORMAL, you can change it to ZONE_MOVABLE:
>  
>  % echo online_movable > /sys/devices/system/memory/memoryXXX/state
> -(NOTE: current limit: this memory section must be adjacent to ZONE_MOVABLE)
> +(NOTE: current limit: this memory block must be adjacent to ZONE_MOVABLE)
>  
> -And if the memory section is in ZONE_MOVABLE, you can change it to ZONE_NORMAL:
> +And if the memory block is in ZONE_MOVABLE, you can change it to ZONE_NORMAL:
>  
>  % echo online_kernel > /sys/devices/system/memory/memoryXXX/state
> -(NOTE: current limit: this memory section must be adjacent to ZONE_NORMAL)
> +(NOTE: current limit: this memory block must be adjacent to ZONE_NORMAL)
>  
> -After this, section memoryXXX's state will be 'online' and the amount of
> +After this, memory block XXX's state will be 'online' and the amount of
>  available memory will be increased.
>  
>  Currently, newly added memory is added as ZONE_NORMAL (for powerpc, ZONE_DMA).
> @@ -284,22 +290,22 @@ This may be changed in future.
>  6.1 Memory offline and ZONE_MOVABLE
>  ------------
>  Memory offlining is more complicated than memory online. Because memory offline
> -has to make the whole memory section be unused, memory offline can fail if
> -the section includes memory which cannot be freed.
> +has to make the whole memory block be unused, memory offline can fail if
> +the memort block includes memory which cannot be freed.
       ^^^^^^
       memory
>  
>  In general, memory offline can use 2 techniques.
>  
> -(1) reclaim and free all memory in the section.
> -(2) migrate all pages in the section.
> +(1) reclaim and free all memory in the memory block.
> +(2) migrate all pages in the memory block.
>  
>  In the current implementation, Linux's memory offline uses method (2), freeing
> -all  pages in the section by page migration. But not all pages are
> +all  pages in the memory block by page migration. But not all pages are
>  migratable. Under current Linux, migratable pages are anonymous pages and
> -page caches. For offlining a section by migration, the kernel has to guarantee
> -that the section contains only migratable pages.
> +page caches. For offlining a memory block by migration, the kernel has to
> +guarantee that the memory block contains only migratable pages.
>  
> -Now, a boot option for making a section which consists of migratable pages is
> -supported. By specifying "kernelcore=" or "movablecore=" boot option, you can
> +Now, a boot option for making a memory block which consists of migratable pages
> +is supported. By specifying "kernelcore=" or "movablecore=" boot option, you can
>  create ZONE_MOVABLE...a zone which is just used for movable pages.
>  (See also Documentation/kernel-parameters.txt)
>  
> @@ -315,28 +321,27 @@ creates ZONE_MOVABLE as following.
>    Size of memory for movable pages (for offline) is ZZZZ.
>  
>  
> -Note) Unfortunately, there is no information to show which section belongs
> +Note: Unfortunately, there is no information to show which memory block belongs
>  to ZONE_MOVABLE. This is TBD.
>  
>  
>  6.2. How to offline memory
>  ------------
> -You can offline a section by using the same sysfs interface that was used in
> -memory onlining.
> +You can offline a memory block by using the same sysfs interface that was used
> +in memory onlining.
>  
>  % echo offline > /sys/devices/system/memory/memoryXXX/state
>  
> -If offline succeeds, the state of the memory section is changed to be "offline".
> +If offline succeeds, the state of the memory block is changed to be "offline".
>  If it fails, some error core (like -EBUSY) will be returned by the kernel.
> -Even if a section does not belong to ZONE_MOVABLE, you can try to offline it.
> -If it doesn't contain 'unmovable' memory, you'll get success.
> +Even if a memory block does not belong to ZONE_MOVABLE, you can try to offline
> +it.  If it doesn't contain 'unmovable' memory, you'll get success.
>  
> -A section under ZONE_MOVABLE is considered to be able to be offlined easily.
> -But under some busy state, it may return -EBUSY. Even if a memory section
> -cannot be offlined due to -EBUSY, you can retry offlining it and may be able to
> -offline it (or not).
> -(For example, a page is referred to by some kernel internal call and released
> - soon.)
> +A memory block under ZONE_MOVABLE is considered to be able to be offlined
> +easily.  But under some busy state, it may return -EBUSY. Even if a memory
> +block cannot be offlined due to -EBUSY, you can retry offlining it and may be
> +able to offline it (or not). (For example, a page is referred to by some kernel
> +internal call and released soon.)
>  
>  Consideration:
>  Memory hotplug's design direction is to make the possibility of memory offlining
> @@ -373,11 +378,11 @@ MEMORY_GOING_OFFLINE
>    Generated to begin the process of offlining memory. Allocations are no
>    longer possible from the memory but some of the memory to be offlined
>    is still in use. The callback can be used to free memory known to a
> -  subsystem from the indicated memory section.
> +  subsystem from the indicated memory block.
>  
>  MEMORY_CANCEL_OFFLINE
>    Generated if MEMORY_GOING_OFFLINE fails. Memory is available again from
> -  the section that we attempted to offline.
> +  the memory block that we attempted to offline.
>  
>  MEMORY_OFFLINE
>    Generated after offlining memory is complete.
> @@ -413,8 +418,8 @@ node if necessary.
>  --------------
>    - allowing memory hot-add to ZONE_MOVABLE. maybe we need some switch like
>      sysctl or new control file.
> -  - showing memory section and physical device relationship.
> -  - showing memory section is under ZONE_MOVABLE or not
> +  - showing memory block and physical device relationship.
> +  - showing memory block is under ZONE_MOVABLE or not
>    - test and make it better memory offlining.
>    - support HugeTLB page migration and offlining.
>    - memmap removing at memory offline.
> 
> .
> 


-- 
Thanks.
Zhang Yanfei
