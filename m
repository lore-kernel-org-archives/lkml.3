Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917Ab3CGPVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 10:21:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914Ab3CGPVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 10:21:24 -0500
Date: Thu, 7 Mar 2013 10:21:08 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jingbai Ma <jingbai.ma@hp.com>
Cc: mingo@redhat.com, kumagai-atsushi@mxc.nes.nec.co.jp, ebiederm@xmission.com,
        hpa@zytor.com, yinghai@kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] crash dump bitmap: scan memory pages in kernel
 to speedup kernel dump process
Message-ID: <20130307152108.GC2790@redhat.com>
References: <20130307145808.29098.41592.stgit@k.asiapacific.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130307145808.29098.41592.stgit@k.asiapacific.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 10:58:18PM +0800, Jingbai Ma wrote:
> This patch intend to speedup the memory pages scanning process in
> selective dump mode.
> 
> Test result (On HP ProLiant DL980 G7 with 1TB RAM, makedumpfile
> v1.5.3):
> 
> 						Total scan Time
> Original kernel
> 	+ makedumpfile v1.5.3 cyclic mode	1958.05 seconds
> Original kernel
> 	+ makedumpfile v1.5.3 non-cyclic mode	1151.50 seconds
> Patched kernel
> 	+ patched makedumpfile v1.5.3		17.50 seconds
> 
> Traditionally, to reduce the size of dump file, dumper scans all memory
> pages to exclude the unnecessary memory pages after capture kernel
> booted, and scan it in userspace code (makedumpfile).

I think this is not a good idea. It has several issues.

- First of all it is doing more stuff in first kernel. And that runs
  contrary to kdump design where we want to do stuff in second kernel.
  After a kernel crash, you can't trust running kernel's data structures.
  So to improve reliability just do minial stuff in crashed kernel and
  get out quickly.

- Secondly, it moves filetering policy in kernel. I think keeping it
  in user space gives us the extra flexibility.
> 
> It introduces several problems:
> 
> 1. Requires more memory to store memory bitmap on systems with large
> amount of memory installed. And in capture kernel there is only a few
> free memory available, it will cause an out of memory error and fail.
> (Non-cyclic mode)

makedumpfile requires 2bits per 4K page. That is 64MB per TB. In your
patches also you are reserving 1bit per page and that is 32MB per TB
in first kernel.

So memory is anyway being reserved, just that makedumpfile seems to be
needing this extra bit. Not sure if that can be optimized or not.

First of all 64MB per TB should not be a huge deal. And makedumpfile
also has this cyclic mode where you process a map, discard it and then
move on to next section. So memory usage remains constant at the expense
of processing time.

Looks like now hpa and yinghai have done the work to be able to load
kdump kernel above 4GB. I am assuming this also removes the restriction
that we can only reserve 512MB or 896MB in second kernel. If that's
the case, then I don't see why people can't get away with reserving
64MB per TB.

> 
> 2. Scans all memory pages in makedumpfile is a very slow process. On
> system with 1TB or more memory installed, the scanning process is very
> long. Typically on 1TB idle system, it takes about 19 minutes. On system
> with 4TB or more memory installed, it even doesn't work. To address the
> out of memory issue on system with big memory (4TB or more memory
> installed),  makedumpfile v1.5.1 introduces a new cyclic mode. It only
> scans a piece of memory pages each time, and do it cyclically to scan
> all memory pages. But it runs more slowly, on 1TB system, takes about 33
> minutes.

One of the reasons it is slow because we don't support mmpa() interface.
That means for every read, we map 4K page, flush TLB, read it, unmap it
and flush TLB again. This is lot of processing overhead per 4K page.

Hatayama is now working on making mmap() interface and allow user space
to bigger chunks of memory in one so. So that in one mmap() call we can
map a bigger range instead of just 4K. And his numbers show that it
has helped a lot.

So instead of trying to move filtering logic in kernel, I think it
might be better if we try to optimize things in makedumpfile or second
kernel.

> 
> 3. Scans memory pages code in makedumpfile is very complicated, without
> kernel memory management related data structure, makedumpfile has to
> build up its own data structure, and will not able to use some macros
> that only be available in kernel (e.g. page_to_pfn), and has to use some
> slow lookup algorithm instead.
> 
> This patch introduces a new way to scan memory pages. It reserves a
> piece of memory (1 bit for each page, 32MB per TB memory on x86 systems)
> in the first kernel. During the kernel crash process, it scans all
> memory pages, clear the bit for all excluded memory pages in the
> reserved memory.

I think this is not a good idea. It has several issues.

- First of all it is doing more stuff in first kernel. And that runs
  contrary to kdump design where we want to do stuff in second kernel.
  After a kernel crash, you can't trust running kernel's data structures.
  So to improve reliability just do minial stuff in crashed kernel and
  get out quickly.

- Secondly, it moves filetering policy in kernel. I think keeping it
  in user space gives us the extra flexibility.

> 

> We have several benefits by this new approach:
> 
> 1. It's extremely fast, on 1TB system only takes about 17.5 seconds to
> scan all memory pages!
> 
> 2. Reduces the memory requirement of makedumpfile by putting the
> reserved memory in the first kernel memory space.

Even the second kernel's memory comes from first kernel. So that really
does not help.

Thanks
Vivek
