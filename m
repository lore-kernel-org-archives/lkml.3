Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbaFPGuk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 02:50:40 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbaFPGuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 02:50:39 -0400
Message-ID: <539E93B9.5070407@nod.at>
Date: Mon, 16 Jun 2014 08:50:33 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Real Name <enjoymindful@gmail.com>
CC: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] delete unnecessary bootmem struct page array
References: <1401773445-25256-1-git-send-email-enjoymindful@gmail.com> <539C1964.4050504@nod.at> <20140616032852.GA1763@name>
In-Reply-To: <20140616032852.GA1763@name>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 16.06.2014 05:28, schrieb Real Name:
> On Sat, Jun 14, 2014 at 11:44:04AM +0200, Richard Weinberger wrote:
>> Hi!
>>
>> Am 03.06.2014 07:30, schrieb Real Name:
>>> From: Honggang Li <enjoymindful@gmail.com>
>>>
>>> The patch based on linux-next-2014-06-02.
>>>
>>> The old init_maps function does two things:
>>> 1) allocates and initializes one struct page array for bootmem
>>> 2) count the number of total pages
>>>
>>> After removed the source code related to the unnecessary array, the name 
>>> 'init_maps' is some kind of improper named, as it just count the number of
>>> total page numbers. So, I renamed the function as 'mem_total_pages'.
>>>
>>> I tested the patch through repeat reboot the uml kernel many times.
>>> [real@name linux-next]$ make ARCH=um defconfig
>>> [real@name linux-next]$ make ARCH=um linux
>>> [real@name linux-next]$ file linux
>>> linux: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.32, not stripped
>>> [real@name linux-next]$ ./linux ubda=/home/real/linux-next/Fedora20-AMD64-root_fs mem=256m && sync && echo 1
>>> [real@name linux-next]$ ./linux ubda=/home/real/linux-next/Fedora20-AMD64-root_fs mem=256m && sync && echo 2
>>> (repeat reboot the uml kernel many times..)
>>
>> Can you please include in the changelog the commit sha1 which made the old init_maps() obsolete?
>> I had a look at the pre-git linux tree, looks like init_maps() wasn't touched for more than 10 years.
> 
> hi, richard
> 
> what is the pre-git linux tree? I searched it with google, but failed.
> 
> The v2.6.12 kernel is the oldest one available from the linux-next git tree. And it has duplicated
> struct page arrays. So, any suggestion how to find the commit you wanted?

https://git.kernel.org/cgit/linux/kernel/git/tglx/history.git

> linux-2.4.20 + uml-patch-2.4.20-8 works on *old* redhat-9 virtual machine. And it seems has duplicated
> struct page array too.
>

And if you remove it here too UML still works?

Thanks,
//richard

> The first struct page array
> ------------------------
> linux-2.4.20/arch/um/kernel/physmem.c
> 157 int init_maps(unsigned long len)
> 158 {
> 159         struct page *p, *map;
> 160         int i, n;
> 161 
> 162         n = len >> PAGE_SHIFT;
> 163         len = n * sizeof(struct page);
> 164 
> 165         if(kmalloc_ok){
> 166                 map = kmalloc(len, GFP_KERNEL);
> 167                 if(map == NULL) map = vmalloc(len);
> 168         }
> 169         else map = alloc_bootmem_low_pages(len);
> 170 
> 171         if(map == NULL)
> 172                 return(-ENOMEM);
> 173 
> 174         for(i = 0; i < n; i++){
> 175                 p = &map[i];
> 176                 set_page_count(p, 0);
> 177                 SetPageReserved(p);
> 178                 INIT_LIST_HEAD(&p->list);
> 179         }
> 180 
> 181         mem_map = map;
> 182         max_mapnr = n;
> 183         return(0);
> 184 }
> 
> 
> The second struct page array
> -----------------------
> mm/memory.c
> 73 mem_map_t * mem_map; // global define
> 
> mm/page_alloc.c
> 839 void __init free_area_init(unsigned long *zones_size)
> 840 {
> 841         free_area_init_core(0, &contig_page_data, &mem_map, zones_size, 0, 0, 0);
> 842 }
> 
> --------
> mm/page_alloc.c
> 685 void __init free_area_init_core(int nid, pg_data_t *pgdat, struct page **gmap,
> 686         unsigned long *zones_size, unsigned long zone_start_paddr,
> 687         unsigned long *zholes_size, struct page *lmem_map)
> 688 {
> ........
> 716         map_size = (totalpages + 1)*sizeof(struct page);
> 717         if (lmem_map == (struct page *)0) {
> 718                 lmem_map = (struct page *) alloc_bootmem_node(pgdat, map_size);
> 719                 lmem_map = (struct page *)(PAGE_OFFSET +
> 720                         MAP_ALIGN((unsigned long)lmem_map - PAGE_OFFSET));
> 721         }
> 722         *gmap = pgdat->node_mem_map = lmem_map;
> 
> 
>>
>> Thanks,
>> //richard
>>
>>> Honggang Li (1):
>>>   delete unnecessary bootmem struct page array
>>>
>>>  arch/um/include/shared/mem_user.h |  2 +-
>>>  arch/um/kernel/physmem.c          | 32 ++++++--------------------------
>>>  arch/um/kernel/um_arch.c          |  7 +------
>>>  3 files changed, 8 insertions(+), 33 deletions(-)
>>>
