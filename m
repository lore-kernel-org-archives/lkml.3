Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbbAUGxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 01:53:04 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:9830 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbbAUGxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 01:53:01 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-fc-54bf4cca01c6
Date: Wed, 21 Jan 2015 09:52:57 +0300
From: Sergey Dyasly <s.dyasly@samsung.com>
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
Subject: Re: [RFC][PATCH RESEND] mm: vmalloc: remove ioremap align constraint
Message-id: <20150121095257.ce97fb984ed7b9572cb1cc6a@samsung.com>
In-reply-to: <5891256.RkdjYUxedq@wuerfel>
References: <1419328813-2211-1-git-send-email-d.safonov@partner.samsung.com>
 <11656044.WGcPr1b8t8@wuerfel>
 <20150103185946.1d4fad32bb3de9ac9bdcfb88@gmail.com>
 <5891256.RkdjYUxedq@wuerfel>
X-Mailer: Sylpheed 3.5.0beta2 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42I5/e/4Zd1TPvtDDJZPsbSYs34Nm8XKHm+L
	v5OOsVu8X9bDaPFp5VM2i4M3vrFbXOpdwmqx6fE1VovLu+awWdxb85/V4vZlXotPz/6xW0ye
	LWXx8uMJFgc+jzXz1jB6tDT3sHn8/jWJ0WPTp0nsHneu7WHzODHjN4vH5iX1Ho/3WnqcnPeT
	zePguz1MHn1bVjF6fN4kF8ATxWWTkpqTWZZapG+XwJXR/+4hY8FWiYoVZ+YyNzDOFO5i5OSQ
	EDCR2PKykw3CFpO4cG89kM3FISSwlFFizdVuRginhUli67lV7F2MHBwsAqoSv546gTSwCWhJ
	nF28nRnEFhFQlJj64hkzSD2zQDOLxNL21YwgCWEBX4mfOz6BFfEKOEqc697LDmJzCmhK3Nm2
	HmrBQUaJSws2skKc4SjxeeEXdogGQYkfk++xgNjMQNs2b2tihbDlJTavecs8gVFgFpKyWUjK
	ZiEpW8DIvIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/dxMjJNa+7GBcfMzqEKMAB6MSDy/Hin0h
	QqyJZcWVuYcYJTiYlUR4FSX2hwjxpiRWVqUW5ccXleakFh9iZOLglGpgXF27/ELCtNw/OptX
	bJoUtWQ1T0vsgpSn05Rm/6ue9yQl0ONk9JuzUw7F8IUk52y6IXm3v2v6bLWUCXnF8nZBwpJi
	861e9tbp+PQtExXm3FFx1U+IY3JI3N+z5kZtgf+NanaeV273fD79/rn5IafZqnc+vVszeZL/
	7RXyfLn9P8LOh7dLummaKbEUZyQaajEXFScCAAaq6E6TAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 04 Jan 2015 17:38:06 +0100
Arnd Bergmann <arnd@arndb.de> wrote:

> On Saturday 03 January 2015 18:59:46 Sergey Dyasly wrote:
> > Hi Arnd,
> > 
> > First, some background information. We originally encountered high fragmentation
> > issue in vmalloc area:
> > 
> > 	1. Total size of vmalloc area was 400 MB.
> > 	2. 200 MB of vmalloc area was consumed by ioremaps of various sizes.
> > 	3. Largest contiguous chunk of vmalloc area was 12 MB.
> > 	4. ioremap of 10 MB failed due to 8 MB alignment requirement.
> 
> Interesting, can you describe how you end up with that many ioremap mappings?
> 200MB seems like a lot. Do you perhaps get a lot of duplicate entries for the
> same hardware registers, or maybe a leak?
> 
> Can you send the output of /proc/vmallocinfo?
>  
> > It was decided to further increase the size of vmalloc area to resolve the above
> > issue. And I don't like that solution because it decreases the amount of lowmem.
> 
> If all the mappings are in fact required, have you considered using
> CONFIG_VMSPLIT_2G split to avoid the use of highmem?
> 
> > Now let's see how ioremap uses supersections. Judging from current implementation
> > of __arm_ioremap_pfn_caller:
> > 
> > 	#if !defined(CONFIG_SMP) && !defined(CONFIG_ARM_LPAE)
> > 		if (pfn >= 0x100000 && !((paddr | size | addr) & ~SUPERSECTION_MASK)) {
> > 			remap_area_supersections();
> > 		} else if (!((paddr | size | addr) & ~PMD_MASK)) {
> > 			remap_area_sections();
> > 		} else
> > 	#endif
> > 			err = ioremap_page_range();
> > 
> > supersections and sections mappings are used only in !SMP && !LPAE case.
> > Otherwise, mapping is created using the usual 4K pages (and we are using SMP).
> > The suggested patch removes alignment requirements for ioremap but it means that
> > sections will not be used in !SMP case. So another solution is required.
> > 
> > __get_vm_area_node has align parameter, maybe it can be used to specify the
> > required alignment of ioremap operation? Because I find current generic fls
> > algorithm to be very restrictive in cases when it's not necessary to use such
> > a big alignment.
> 
> I think using next-power-of-two alignment generally helps limit the effects of
> fragmentation the same way that the buddy allocator works.
> 
> Since the section and supersection maps are only used with non-SMP non-LPAE
> (why is that the case btw?),

vmap/vunmap mechanism works that way. ARM is using 2 levels of page tables:
PGD and PTE; and that provides the needed level of indirection. Every mm
contains a copy of init_mm's pgd mappings for kernel and they point to the same
set of PTEs. vmap/vunmap manipulates only with *pgd->pte and the change becomes
visible to every mm. This is impossible to do for sections because they use
PGD entries directly.

> it would however make sense to use the default
> (7 + PAGE_SHIFT) instead of the ARM-specific 24 here if one of them is set,
> I don't see any downsides to that.

This makes sense. I'll prepare a patch for that.

> 
> 	Arnd


-- 
Sergey Dyasly <s.dyasly@samsung.com>
