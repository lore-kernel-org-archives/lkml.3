Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771Ab3CHKQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 05:16:55 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:1178 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756538Ab3CHKQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 05:16:54 -0500
Message-ID: <5139BA90.4080606@hp.com>
Date: Fri, 08 Mar 2013 18:16:48 +0800
From: Jingbai Ma <jingbai.ma@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130108 Thunderbird/10.0.12
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: jingbai.ma@hp.com, mingo@redhat.com, kumagai-atsushi@mxc.nes.nec.co.jp,
        ebiederm@xmission.com, hpa@zytor.com, yinghai@kernel.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Mitchell, Lisa (MCLinux in Fort Collins)" <lisa.mitchell@hp.com>
Subject: Re: [RFC PATCH 0/5] crash dump bitmap: scan memory pages in kernel
 to speedup kernel dump process
References: <20130307145808.29098.41592.stgit@k.asiapacific.hpqcorp.net> <20130307152108.GC2790@redhat.com>
In-Reply-To: <20130307152108.GC2790@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2013 11:21 PM, Vivek Goyal wrote:
> On Thu, Mar 07, 2013 at 10:58:18PM +0800, Jingbai Ma wrote:
>> This patch intend to speedup the memory pages scanning process in
>> selective dump mode.
>>
>> Test result (On HP ProLiant DL980 G7 with 1TB RAM, makedumpfile
>> v1.5.3):
>>
>> 						Total scan Time
>> Original kernel
>> 	+ makedumpfile v1.5.3 cyclic mode	1958.05 seconds
>> Original kernel
>> 	+ makedumpfile v1.5.3 non-cyclic mode	1151.50 seconds
>> Patched kernel
>> 	+ patched makedumpfile v1.5.3		17.50 seconds
>>
>> Traditionally, to reduce the size of dump file, dumper scans all memory
>> pages to exclude the unnecessary memory pages after capture kernel
>> booted, and scan it in userspace code (makedumpfile).
>
> I think this is not a good idea. It has several issues.
>
> - First of all it is doing more stuff in first kernel. And that runs
>    contrary to kdump design where we want to do stuff in second kernel.
>    After a kernel crash, you can't trust running kernel's data structures.
>    So to improve reliability just do minial stuff in crashed kernel and
>    get out quickly.

I agreed with you, the first kernel should do as less as possible.
Intuitively, filter memory pages in the first kernel will harm the 
reliability of kernel dump, but let's think it thoroughly:

1. It only relies on the memory management data structure that 
makedumpfile also relies on, so no any reliability degradation at this 
point.

2. Filtering code itself is very simple and straightforward, doesn't 
depend on kernel functions too much. Current code calls 
pgdat_resize_lock() and spin_lock_irqsave() for testing purpose in 
non-crash situation, and can be removed safely in crash processing. It 
may affects reliability but very limit.

3. Before calling filtering code, the machine_crash_shutdown() has been 
executed, so all IRQs have been disabled, all other CPUs have been 
halted. We only need to make sure NMI from watchdog has been disabled here.
So far, we stay on a separate stack, no any potential interrupts here, 
only executes a little piece of code with very limit system functions.
Compares to the complicated functions been executed previously, the 
risks from the filtering code should be acceptable.

>
> - Secondly, it moves filetering policy in kernel. I think keeping it
>    in user space gives us the extra flexibility.

It doesn't keep user from extra flexibility, just adds another 
possibility. I have added a flag in makedumpfile, user can decide to 
filter memory pages by makedumpfile itself or just use the bitmap came 
from the first kernel.

>>
>> It introduces several problems:
>>
>> 1. Requires more memory to store memory bitmap on systems with large
>> amount of memory installed. And in capture kernel there is only a few
>> free memory available, it will cause an out of memory error and fail.
>> (Non-cyclic mode)
>
> makedumpfile requires 2bits per 4K page. That is 64MB per TB. In your
> patches also you are reserving 1bit per page and that is 32MB per TB
> in first kernel.
>
> So memory is anyway being reserved, just that makedumpfile seems to be
> needing this extra bit. Not sure if that can be optimized or not.

Yes, you are right. It's only a POC (proof of concept) implementation 
currently. I can add a mmap interface to allow makedumpfile to access 
the bitmap memory directly without reserving memory for it again.

>
> First of all 64MB per TB should not be a huge deal. And makedumpfile
> also has this cyclic mode where you process a map, discard it and then
> move on to next section. So memory usage remains constant at the expense
> of processing time.

Yes, that's true. But in cyclic mode, makedumpfile will have to 
write/read bitmap from storage, it will also impact the performance.
I have measured the penalty for cyclic mode is about 70% slowdown. Maybe 
could be faster after mmap implemented.

>
> Looks like now hpa and yinghai have done the work to be able to load
> kdump kernel above 4GB. I am assuming this also removes the restriction
> that we can only reserve 512MB or 896MB in second kernel. If that's
> the case, then I don't see why people can't get away with reserving
> 64MB per TB.

That's true. With kernel 3.9-rc1 with kexec-tools 2.0.4, capture kernel 
will have enough memory to run. And makedumpfile could be always run at 
non-cyclic mode, but we still concern about the kernel dump performance 
on systems with huge memory (above 4TB).

>>
>> 2. Scans all memory pages in makedumpfile is a very slow process. On
>> system with 1TB or more memory installed, the scanning process is very
>> long. Typically on 1TB idle system, it takes about 19 minutes. On system
>> with 4TB or more memory installed, it even doesn't work. To address the
>> out of memory issue on system with big memory (4TB or more memory
>> installed),  makedumpfile v1.5.1 introduces a new cyclic mode. It only
>> scans a piece of memory pages each time, and do it cyclically to scan
>> all memory pages. But it runs more slowly, on 1TB system, takes about 33
>> minutes.
>
> One of the reasons it is slow because we don't support mmpa() interface.
> That means for every read, we map 4K page, flush TLB, read it, unmap it
> and flush TLB again. This is lot of processing overhead per 4K page.

Agree, I have read the code, and even had a plan to implement mmap() for 
capture kernel, but I saw Hatayama has been working on it for a while. 
So I decided to improve the page filtering part.

>
> Hatayama is now working on making mmap() interface and allow user space
> to bigger chunks of memory in one so. So that in one mmap() call we can
> map a bigger range instead of just 4K. And his numbers show that it
> has helped a lot.
>
> So instead of trying to move filtering logic in kernel, I think it
> might be better if we try to optimize things in makedumpfile or second
> kernel.

Kernel do have some abilities that user space haven't. It's possible to 
map whole memory space of the first kernel into user space on the second 
kernel. But the user space code has to re-implement some parts of the 
kernel memory management system again. And worse, it's architecture 
dependent, more architectures supported, more codes have to be 
implemented. All implementation in user space must be sync to kernel 
implementation. It's may called "flexibility", but it's painful to 
maintain the codes.

But if we scan memory in the first kernel, all problem will not exist 
anymore. We just use the same logical for all kind of architectures.

User still be able to decide if the want to filter memory as their own 
way. We can treat it as an option to accelerate the kernel dump process.

The downtime usually is not a big deal for personal user, but for some 
mission critical systems, time really is money.

Again, I summarized the pros and cons of filtering memory pages in the 
first kernel:
Pros:
1. Extremely fast.
2. Simple logic and code.
3. Move architecture dependent code into, make user space code simpler 
and easy to maintain.
Cons:
1. Reduce the reliability of kernel dump very slightly.
2. A few more memory occupation in current version, and can be improved.

Thanks for your comments!

>
>>
>> 3. Scans memory pages code in makedumpfile is very complicated, without
>> kernel memory management related data structure, makedumpfile has to
>> build up its own data structure, and will not able to use some macros
>> that only be available in kernel (e.g. page_to_pfn), and has to use some
>> slow lookup algorithm instead.
>>
>> This patch introduces a new way to scan memory pages. It reserves a
>> piece of memory (1 bit for each page, 32MB per TB memory on x86 systems)
>> in the first kernel. During the kernel crash process, it scans all
>> memory pages, clear the bit for all excluded memory pages in the
>> reserved memory.
>
> I think this is not a good idea. It has several issues.
>
> - First of all it is doing more stuff in first kernel. And that runs
>    contrary to kdump design where we want to do stuff in second kernel.
>    After a kernel crash, you can't trust running kernel's data structures.
>    So to improve reliability just do minial stuff in crashed kernel and
>    get out quickly.
>
> - Secondly, it moves filetering policy in kernel. I think keeping it
>    in user space gives us the extra flexibility.
>
>>
>
>> We have several benefits by this new approach:
>>
>> 1. It's extremely fast, on 1TB system only takes about 17.5 seconds to
>> scan all memory pages!
>>
>> 2. Reduces the memory requirement of makedumpfile by putting the
>> reserved memory in the first kernel memory space.
>
> Even the second kernel's memory comes from first kernel. So that really
> does not help.
>
> Thanks
> Vivek


-- 
Jingbai Ma (jingbai.ma@hp.com)
