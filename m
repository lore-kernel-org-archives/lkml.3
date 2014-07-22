Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbaGVKQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 06:16:41 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:34043 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780AbaGVKQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 06:16:40 -0400
Message-ID: <53CE39EE.5020309@linaro.org>
Date: Tue, 22 Jul 2014 11:16:14 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Marek Vasut <marex@denx.de>, Harro Haan <hrhaan@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH RFC 5/9] ARM: Add L1 PTE non-secure mapping
References: <1405954040-30399-1-git-send-email-daniel.thompson@linaro.org> <1405954040-30399-6-git-send-email-daniel.thompson@linaro.org> <20140721164634.GF21766@n2100.arm.linux.org.uk>
In-Reply-To: <20140721164634.GF21766@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/07/14 17:46, Russell King - ARM Linux wrote:
> On Mon, Jul 21, 2014 at 03:47:16PM +0100, Daniel Thompson wrote:
>> From: Marek Vasut <marex@denx.de>
>>
>> Add new device type, MT_DEVICE_NS. This type sets the NS bit in L1 PTE [1].
>> Accesses to a memory region which is mapped this way generate non-secure
>> access to that memory area. One must be careful here, since the NS bit is
>> only available in L1 PTE, therefore when creating the mapping, the mapping
>> must be at least 1 MiB big and must be aligned to 1 MiB. If that condition
>> was false, the kernel would use regular L2 page mapping for this area instead
>> and the NS bit setting would be ineffective.
> 
> Right, so this says that PTE mappings are not permissible.
> 
>> +	[MT_DEVICE_NS] = {	  /* Non-secure accesses from secure mode */
>> +		.prot_pte	= PROT_PTE_DEVICE | L_PTE_MT_DEV_SHARED |
>> +				  L_PTE_SHARED,
>> +		.prot_l1	= PMD_TYPE_TABLE,
> 
> However, by filling in prot_pte and prot_l1, you're telling the code that
> it /can/ setup such a mapping.  This is screwed.

I'll fix this.


> If you want to deny anything but section mappings (because they don't work)
> then you omit prot_pte and prot_l1.  With those omitted, if someone tries
> to abuse this mapping type, then this check in create_mapping() will
> trigger:
> 
>         if (type->prot_l1 == 0 && ((addr | phys | length) & ~SECTION_MASK)) {
>                 printk(KERN_WARNING "BUG: map for 0x%08llx at 0x%08lx can not "
>                        "be mapped using pages, ignoring.\n",
>                        (long long)__pfn_to_phys(md->pfn), addr);
>                 return;
>         }
> 
> ioremap doesn't have that check; it assumes that it will always be setting
> up PTE mappings via ioremap_page_range().  In fact, on many platforms
> that's the only option.

I have proposed a patch (which I just noticed is currently *really*
broken but ignore that for now) to prevent the fallback to
ioremap_page_range(). As you say this leaves nothing but the lookup in
the static mappings for many platforms.

That patches looks at PMD_SECT_NS directly but could be changed to zero
check ->prot_l1 instead.

That removes the danger of spuriously getting bad mappings but is
certainly not elegant.


> So making this interface available via ioremap() seems pointless - but
> more importantly it's extremely error-prone.  So, MT_DEVICE_NS shouldn't
> be using 4 at all, shouldn't be in asm/io.h, but should be with the
> private MT_* definitions in map.h.

I wanted to use ioremap() because it allows platform neutral code in the
GIC driver to look up a staticly configured non-secure aliased mapping
for the GIC (if it exists). Also given the mapping is used for register
I/O ioremap() also felt "right".

Is new API better? A very thin wrapper around find_static_vm_paddr()?

I guess the best thing would be to allocate the mapping dynamically. It
might be possible for __arm_ioremap_pfn_caller() to change the NS flag
in the first-level table after allocating a naturally aligned 1MB
vm_area and before updating the second-level? We are not required to use
sections, however all pages that share a L1 entry get the same security
flags.


Daniel.
