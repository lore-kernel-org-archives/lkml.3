Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaIDJmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 05:42:05 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:59790 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750966AbaIDJmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 05:42:03 -0400
Date: Thu, 4 Sep 2014 10:41:52 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: "zhichang.yuan" <zhichang.yuan@linaro.org>
Cc: Will Deacon <Will.Deacon@arm.com>, Deepak Saxena <dsaxena@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>
Subject: Re: Some questions about DEBUG_PAGEALLOC on ARMv8
Message-ID: <20140904094152.GB16169@arm.com>
References: <53F739C2.8070809@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F739C2.8070809@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zhichang,

(cc'ing Steve Capper for the huge page stuff)

On Fri, Aug 22, 2014 at 01:38:26PM +0100, zhichang.yuan wrote:
> I am working to implement the DEBUG_PAGEALLOC on ARMv8.

I assume that's the arm64 kernel.

> After i investigated the DEBUG_PAGEALLOC implementation on x86 arch,
> some questions are standing in the way to start coding.
> 
> 1. How to handle the large page when DEBUG_PAGEALLOC is enabled In
> ARMv8, the kernel direct memory page table entries will set the block
> flag for better performance. When DEBUG_PAGEALLOC is configured, if
> the size of freed page is not multiply of page block size, there is no
> corresponding page table entry. In the old x86 kernel version, the
> large page to be freed will be split into normal page size and build
> the corresponding PTEs. And afterwards, someone done a patch to remove
> the splitting process. It will make the code simpler and easily
> stable.

Initially, you could either map everything as pages or implement
splitting of huge pages (if for example the huge page is at the pmd
level, you allocate and populate a pte).

> I prefer the current design in x86, what are your thoughts here?

I haven't looked at it yet.

> 2. Does ARMv8 support HIBERNATION?

Not yet.

> The HIBERNATION has some dependency on DEBUG_PAGEALLOC.

Like in DEBUG_PAGEALLOC "depends on !HIBERNATION"?

> 3. Is the hypothesis of DEBUG_PAGEALLOC always true?

Which hypothesis?

> From the x86 code, DEBUG_PAGEALLOC use the invalid page table entries
> to catch the accesses to free pages. This mechanism is based on the
> hypothesis that all the corresponding page table entries that are
> corresponding to the free pages are cleared correctly. Supposed this
> condition is always true, what we need to do is just to clear the
> kernel linear mapping page entries, since those page tables are
> fixable after initialization. DEBUG_PAGEALLOC on x86 seems to do like
> that.

I guess that's the ARCH_SUPPORTS_DEBUG_PAGEALLOC rather than just the
simple DEBUG_PAGEALLOC which can be enabled on arm64 as well, you just
get page poisoning rather than invalid mappings.

It could be done on arm64 as well but you need to sort out huge page
splitting or just map everything as pages when the option is enabled.

> Is it possible the hypothesis will be broken?
> If the answer is yes, DEBUG_PAGEALLOC can catch the accesses to free
> page with kernel linear mapping address. But if the virtual address is
> from other mapped areas and target to the free pages, DEBUG_PAGEALLOC
> will do nothing.
> 
> Is this result the original objective of DEBUG_PAGEALLOC?
> I can not find the initial commit log in kernel Git, i am not sure
> about it.

The objective is written in the Kconfig:

config DEBUG_PAGEALLOC
	bool "Debug page memory allocations"
	...
	  Unmap pages from the kernel linear mapping after free_pages().
	  This results in a large slowdown, but helps to find certain types
	  of memory corruption.

	  For architectures which don't enable ARCH_SUPPORTS_DEBUG_PAGEALLOC,
	  fill the pages with poison patterns after free_pages() and verify
	  the patterns before alloc_pages().  Additionally,
	  this option cannot be enabled in combination with hibernation as
	  that would result in incorrect warnings of memory corruption after
	  a resume because free pages are not saved to the suspend image.

-- 
Catalin
