Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751178AbaESVDy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 17:03:54 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:50969 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbaESVDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 17:03:53 -0400
Date: Mon, 19 May 2014 23:02:55 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, boris.ostrovsky@oracle.com,
        eshelton@pobox.com, hpa@zytor.com, ian.campbell@citrix.com,
        jbeulich@suse.com, jeremy@goop.org, konrad.wilk@oracle.com,
        matt.fleming@intel.com, mingo@redhat.com, mjg59@srcf.ucam.org,
        stefano.stabellini@eu.citrix.com, tglx@linutronix.de
Subject: Re: [PATCH v4 1/5] efi: Introduce EFI_DIRECT flag
Message-ID: <20140519210255.GC3529@olila.local.net-space.pl>
References: <1400272904-31121-1-git-send-email-daniel.kiper@oracle.com>
 <1400272904-31121-2-git-send-email-daniel.kiper@oracle.com>
 <537A2A28.4010903@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537A2A28.4010903@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 04:58:32PM +0100, David Vrabel wrote:
> On 16/05/14 21:41, Daniel Kiper wrote:
> > Introduce EFI_DIRECT flag. If it is set this means that Linux
> > Kernel has direct access to EFI infrastructure. If not then
> > kernel runs on EFI platform but it has not direct control
> > on EFI stuff. This functionality is used in Xen dom0.
>
> This is backwards.  It should flag should indicate the weird platform
> not the standard, default one.

Do you wish EFI_NO_DIRECT? I understand your idea but I would like to avoid this
name because it is quite difficult to read e.g. !efi_enabled(EFI_NO_DIRECT).
You must think a bit to know what is going on. However, maybe you have a better idea?

> You also need to explain why this is needed rather than presenting a
> more complete EFI interface to PV guests.  And you should explain why
> each use is necessary.

OK.

> > +static void __init __iomem *efi_early_ioremap(resource_size_t phys_addr,
> > +							unsigned long size)
> > +{
> > +	if (efi_enabled(EFI_DIRECT))
> > +		return early_ioremap(phys_addr, size);
> > +
> > +	return (__force void __iomem *)phys_addr;
> > +}
>
> Er...  Perhaps you mean BUG_ON(!efi_enabled(EFI_DIRECT))? Or return NULL?

It is correct. As I said earlier: in case of !efi_enabled(EFI_DIRECT) some
structures are created artificially and they live in virtual address space.
So that is why they should not be mapped.

> > --- a/include/linux/efi.h
> > +++ b/include/linux/efi.h
> > @@ -893,12 +893,13 @@ extern int __init efi_setup_pcdp_console(char *);
> >   * possible, remove EFI-related code altogether.
> >   */
> >  #define EFI_BOOT		0	/* Were we booted from EFI? */
> > -#define EFI_SYSTEM_TABLES	1	/* Can we use EFI system tables? */
> > -#define EFI_CONFIG_TABLES	2	/* Can we use EFI config tables? */
> > -#define EFI_RUNTIME_SERVICES	3	/* Can we use runtime services? */
> > -#define EFI_MEMMAP		4	/* Can we use EFI memory map? */
> > -#define EFI_64BIT		5	/* Is the firmware 64-bit? */
> > -#define EFI_ARCH_1		6	/* First arch-specific bit */
> > +#define EFI_DIRECT		1	/* Can we access EFI directly? */
> > +#define EFI_SYSTEM_TABLES	2	/* Can we use EFI system tables? */
> > +#define EFI_CONFIG_TABLES	3	/* Can we use EFI config tables? */
> > +#define EFI_RUNTIME_SERVICES	4	/* Can we use runtime services? */
> > +#define EFI_MEMMAP		5	/* Can we use EFI memory map? */
> > +#define EFI_64BIT		6	/* Is the firmware 64-bit? */
> > +#define EFI_ARCH_1		7	/* First arch-specific bit */
>
> Unnecessary shuffling of these values.  Why didn't you stick it after
> EFI_64BIT?

I was going to have EFI_DIRECT close to EFI_BOOT which is quite generic
and platform independent name like EFI_BOOT. However, I do not insist
on having it in that place.

Daniel
