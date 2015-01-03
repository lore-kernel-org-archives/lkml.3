Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbbACQAD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 11:00:03 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:64415 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbbACQAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 11:00:00 -0500
Date: Sat, 3 Jan 2015 18:59:46 +0300
From: Sergey Dyasly <dserrg@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Dmitry Safonov <d.safonov@partner.samsung.com>, linux-mm@kvack.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Dyasly Sergey <s.dyasly@samsung.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        James Bottomley <JBottomley@parallels.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [RFC][PATCH RESEND] mm: vmalloc: remove ioremap align
 constraint
Message-Id: <20150103185946.1d4fad32bb3de9ac9bdcfb88@gmail.com>
In-Reply-To: <11656044.WGcPr1b8t8@wuerfel>
References: <1419328813-2211-1-git-send-email-d.safonov@partner.samsung.com>
	<11656044.WGcPr1b8t8@wuerfel>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

First, some background information. We originally encountered high fragmentation
issue in vmalloc area:

	1. Total size of vmalloc area was 400 MB.
	2. 200 MB of vmalloc area was consumed by ioremaps of various sizes.
	3. Largest contiguous chunk of vmalloc area was 12 MB.
	4. ioremap of 10 MB failed due to 8 MB alignment requirement.

It was decided to further increase the size of vmalloc area to resolve the above
issue. And I don't like that solution because it decreases the amount of lowmem.

Now let's see how ioremap uses supersections. Judging from current implementation
of __arm_ioremap_pfn_caller:

	#if !defined(CONFIG_SMP) && !defined(CONFIG_ARM_LPAE)
		if (pfn >= 0x100000 && !((paddr | size | addr) & ~SUPERSECTION_MASK)) {
			remap_area_supersections();
		} else if (!((paddr | size | addr) & ~PMD_MASK)) {
			remap_area_sections();
		} else
	#endif
			err = ioremap_page_range();

supersections and sections mappings are used only in !SMP && !LPAE case.
Otherwise, mapping is created using the usual 4K pages (and we are using SMP).
The suggested patch removes alignment requirements for ioremap but it means that
sections will not be used in !SMP case. So another solution is required.

__get_vm_area_node has align parameter, maybe it can be used to specify the
required alignment of ioremap operation? Because I find current generic fls
algorithm to be very restrictive in cases when it's not necessary to use such
a big alignment.


On Tue, 23 Dec 2014 21:58:49 +0100
Arnd Bergmann <arnd@arndb.de> wrote:

> On Tuesday 23 December 2014 13:00:13 Dmitry Safonov wrote:
> > ioremap uses __get_vm_area_node which sets alignment to fls of requested size.
> > I couldn't find any reason for such big align. Does it decrease TLB misses?
> > I tested it on custom ARM board with 200+ Mb of ioremap and it works.
> > What am I missing?
> 
> The alignment was originally introduced in this commit:
> 
> commit ff0daca525dde796382b9ccd563f169df2571211
> Author: Russell King <rmk@dyn-67.arm.linux.org.uk>
> Date:   Thu Jun 29 20:17:15 2006 +0100
> 
>     [ARM] Add section support to ioremap
>     
>     Allow section mappings to be setup using ioremap() and torn down
>     with iounmap().  This requires additional support in the MM
>     context switch to ensure that mappings are properly synchronised
>     when mapped in.
>     
>     Based an original implementation by Deepak Saxena, reworked and
>     ARMv6 support added by rmk.
>     
>     Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> 
> and then later extended to 16MB supersection mappings, which indeed
> is used to reduce TLB pressure.
> 
> I don't see any downsides to it, why change it?
> 
> 	Arnd

-- 
Sergey Dyasly <dserrg@gmail.com>
