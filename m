Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629AbbAINNa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 08:13:30 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:55402 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757560AbbAINN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 08:13:28 -0500
Date: Fri, 9 Jan 2015 13:13:22 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mason <mpeg.blue@free.fr>
Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: ioremap vs remap_pfn_range, VMSPLIT, etc
Message-ID: <20150109131322.GO12302@n2100.arm.linux.org.uk>
References: <54AFD09E.1010806@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54AFD09E.1010806@free.fr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 01:59:10PM +0100, Mason wrote:
> Hello everyone,
> 
> Yesterday, I used /dev/mem to mmap 2 GB and (to my surprise) it worked.
> Specifically, I opened /dev/mem O_RDWR | O_SYNC
> then called
>   mmap(NULL, 1U<<31, PROT_WRITE, MAP_SHARED, fd, 0x80000000);

So you asked to map 2GB starting at 2GB physical.

> And mmap returned a valid pointer.

And that mapping would have been created to map physical addresses
0x80000000-0xffffffff inclusive.

> I was expecting it to fail.
> 
> - the kernel is configured with VMSPLIT_3G (3G/1G user/kernel)

This has no bearing on the above.

> - the kernel manages 256 MB RAM
> - there is roughly 750 MB of VMALLOC space, no highmem

vmalloc has no bearing on the above, mmap() doesn't allocate anything
into vmalloc space.

> If I requested the same mapping *within the kernel* using ioremap,
> would that fail because of limited VMALLOC space?

Correct.

> Moving to arch-specific questions (namely ARM Cortex-A9).
> If I understand correctly (which is very possibly NOT the case)
> the CPU has two registers pointing to page tables, one for
> the current process, one for the kernel. And the CPU automatically
> picks the correct one, based on the active context?
> It would seem possible to have a full 4G for process, and a full 4G
> for the kernel, using that method, no? (Like Ingo's old 4G/4G split).
> Without the performance overhead of fiddling with the page tables.
> What am I missing?

It's possible to use both, but the CPU selects the page table register
according to the virtual address.  So it's not possible to have 4G for
both.  There's only a restricted set of options:  2G / 2G, where the
bottom 2G of virtual space uses TTBR0 and the upper 2G uses TTBR1.
1G / 3G (1G for TTBR0, 3G for TTBR1).

We don't use it because most people run with 3G for userspace, which
isn't supported in hardware.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
