Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbbADQih (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 11:38:37 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:57558 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbbADQif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 11:38:35 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sergey Dyasly <dserrg@gmail.com>
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
Date: Sun, 04 Jan 2015 17:38:06 +0100
Message-ID: <5891256.RkdjYUxedq@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20150103185946.1d4fad32bb3de9ac9bdcfb88@gmail.com>
References: <1419328813-2211-1-git-send-email-d.safonov@partner.samsung.com> <11656044.WGcPr1b8t8@wuerfel> <20150103185946.1d4fad32bb3de9ac9bdcfb88@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:/4E/o34fURmiB91PbAiboPzoXyRxM9tC0DWNHC3b0HchHvCVBbQ
 0nJ+Skz5XJdRpKscBq8kfM3QluNsD+YPKuRS8Eaps5OucXqZBrfF88ZMiVFQPSyd8ntymbd
 8VKgBYcFnQP6tzXjvol3LEUqbjnZHJLIAz/j9hT49aA4RfYkae12RW/Y5PYyfSTYHt4hB14
 VqXFr2uKzjxnUxyJUcXzg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 January 2015 18:59:46 Sergey Dyasly wrote:
> Hi Arnd,
> 
> First, some background information. We originally encountered high fragmentation
> issue in vmalloc area:
> 
> 	1. Total size of vmalloc area was 400 MB.
> 	2. 200 MB of vmalloc area was consumed by ioremaps of various sizes.
> 	3. Largest contiguous chunk of vmalloc area was 12 MB.
> 	4. ioremap of 10 MB failed due to 8 MB alignment requirement.

Interesting, can you describe how you end up with that many ioremap mappings?
200MB seems like a lot. Do you perhaps get a lot of duplicate entries for the
same hardware registers, or maybe a leak?

Can you send the output of /proc/vmallocinfo?
 
> It was decided to further increase the size of vmalloc area to resolve the above
> issue. And I don't like that solution because it decreases the amount of lowmem.

If all the mappings are in fact required, have you considered using
CONFIG_VMSPLIT_2G split to avoid the use of highmem?

> Now let's see how ioremap uses supersections. Judging from current implementation
> of __arm_ioremap_pfn_caller:
> 
> 	#if !defined(CONFIG_SMP) && !defined(CONFIG_ARM_LPAE)
> 		if (pfn >= 0x100000 && !((paddr | size | addr) & ~SUPERSECTION_MASK)) {
> 			remap_area_supersections();
> 		} else if (!((paddr | size | addr) & ~PMD_MASK)) {
> 			remap_area_sections();
> 		} else
> 	#endif
> 			err = ioremap_page_range();
> 
> supersections and sections mappings are used only in !SMP && !LPAE case.
> Otherwise, mapping is created using the usual 4K pages (and we are using SMP).
> The suggested patch removes alignment requirements for ioremap but it means that
> sections will not be used in !SMP case. So another solution is required.
> 
> __get_vm_area_node has align parameter, maybe it can be used to specify the
> required alignment of ioremap operation? Because I find current generic fls
> algorithm to be very restrictive in cases when it's not necessary to use such
> a big alignment.

I think using next-power-of-two alignment generally helps limit the effects of
fragmentation the same way that the buddy allocator works.

Since the section and supersection maps are only used with non-SMP non-LPAE
(why is that the case btw?), it would however make sense to use the default
(7 + PAGE_SHIFT) instead of the ARM-specific 24 here if one of them is set,
I don't see any downsides to that.

	Arnd
