Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab3LFSAl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 13:00:41 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:57737 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab3LFSAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 13:00:39 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Leif Lindholm <leif.lindholm@linaro.org>
Subject: Re: [PATCH v3 2/3] arm: Add [U]EFI runtime services support
Date: Fri, 6 Dec 2013 18:59:40 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: matt.fleming@intel.com, linux-arm-kernel@lists.infradead.org,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, mark.rutland@arm.com,
        linaro-uefi@lists.linaro.org, patches@linaro.org, roy.franz@linaro.org,
        msalter@redhat.com, grant.likely@linaro.org
References: <1385656883-4420-1-git-send-email-leif.lindholm@linaro.org> <201312060259.48259.arnd@arndb.de> <20131206175449.GD24997@rocoto.smurfnet.nu>
In-Reply-To: <20131206175449.GD24997@rocoto.smurfnet.nu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201312061859.40224.arnd@arndb.de>
X-Provags-ID: V02:K0:KYLCASBJu8kJbTkp5RzFs99iBTbi+Yr4YGIbHHtlOXt
 t8AxoxyB/nPaduHkPBe304evhfb/YlYt8pkYAhavQmXcp6tiNy
 dcFwnGFlQMjJuJbTWoB3hj7RMly2mR+OJTuqgq32V9w5xcZH5E
 X5UuOle+id5tCZrY4Dw65tOvGk2kMDxn5Gkia8Cbvzfc5CKumt
 iMsIOeJY47MHJnYwsKweFRetLSstPBFgVlq4NeZHkCuqSo1TmL
 ptecCtumJ83MA3yX2DseE79QaoW98StSBwVClnNGRxS0BLX4T+
 RR2k2jpMBorSiVOhiG+s6QUsrbhxfTRePwXLVp1faP+35eza2K
 a1cMS4qtIhhXQaiiplzc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 December 2013, Leif Lindholm wrote:
> 
> On Fri, Dec 06, 2013 at 02:59:48AM +0100, Arnd Bergmann wrote:
> > On Thursday 28 November 2013, Leif Lindholm wrote:
> > > @@ -898,6 +900,10 @@ void __init setup_arch(char **cmdline_p)
> > >  	sanity_check_meminfo();
> > >  	arm_memblock_init(&meminfo, mdesc);
> > >  
> > > +#ifdef CONFIG_EFI
> > > +	uefi_memblock_arm_reserve_range();
> > > +#endif
> > > +
> > 
> > Better use 
> > 
> > 	if (IS_ENABLED(CONFIG_EFI))
> > 
> > here for readability and better build-time checking of the interface when
> > CONFIG_EFI is disabled.
> 
> I think I'll do what Grant suggested and stub it out in asm/uefi.h.

That's ok, too. I usually prefer the IS_ENABLED() method if there is only
one caller, since it's harder to get wrong, but the result is similar.

> > > +/*
> > > + * Returns 1 if 'facility' is enabled, 0 otherwise.
> > > + */
> > > +int efi_enabled(int facility)
> > > +{
> > > +	return test_bit(facility, &arm_uefi_facility) != 0;
> > > +}
> > > +EXPORT_SYMBOL(efi_enabled);
> > 
> > I'd use EXPORT_SYMBOL_GPL() unless there is a documented reason why
> > a symbol should be available to GPL-incompatible modules.
> 
> So ... this is duplicating x86 code which Matt Fleming has promised
> to make generic. I'd prefer to keep it identical to x86 until this
> copy goes away.

Ok, makes sense.

> > > +static int __init remap_region(efi_memory_desc_t *md, efi_memory_desc_t *entry)
> > > +{
> > > +	u64 va;
> > > +	u64 paddr;
> > > +	u64 size;
> > > +
> > > +	*entry = *md;
> > > +	paddr = entry->phys_addr;
> > > +	size = entry->num_pages << EFI_PAGE_SHIFT;
> > > +
> > > +	/*
> > > +	 * Map everything writeback-capable as coherent memory,
> > > +	 * anything else as device.
> > > +	 */
> > > +	if (md->attribute & EFI_MEMORY_WB)
> > > +		va = (u64)((u32)uefi_remap(paddr, size) & 0xffffffffUL);
> > > +	else
> > > +		va = (u64)((u32)uefi_ioremap(paddr, size) & 0xffffffffUL);
> > 
> > Same here. Why is 'va' a u64?
> 
> Because the field in the structure (defined by UEFI) is 64-bit:
> 
>         entry->virt_addr = va;

I see. Maybe put the typecast in that final assignment then?

	Arnd
