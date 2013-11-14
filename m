Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231Ab3KNBvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 20:51:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701Ab3KNBvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 20:51:42 -0500
Date: Thu, 14 Nov 2013 09:50:47 +0800
From: Dave Young <dyoung@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de
Subject: Re: [patch 5/7 v2] export efi runtime memory mapping to sysfs
Message-ID: <20131114015047.GD4081@dhcp-16-126.nay.redhat.com>
References: <20131105082007.872550445@dhcp-16-126.nay.redhat.com>
 <20131105082718.185728964@dhcp-16-126.nay.redhat.com>
 <20131113155027.GC17248@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113155027.GC17248@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/13 at 03:50pm, Matt Fleming wrote:
> On Tue, 05 Nov, at 04:20:12PM, dyoung@redhat.com wrote:
> > kexec kernel will need exactly same mapping for
> > efi runtime memory ranges. Thus here export the
> > runtime ranges mapping to sysfs, kexec-tools
> > will assemble them and pass to 2nd kernel via
> > setup_data.
> > 
> > Introducing a new directly /sys/firmware/efi/efi-runtime-map
> > Just like /sys/firmware/memmap. Containing below attribute
> > in each file of that directory:
> > attribute  num_pages  phys_addr  type  virt_addr
> > 
> > It will not work for efi 32bit. Only x86_64 currently.
> > 
> > Signed-off-by: Dave Young <dyoung@redhat.com>
> > ---
> >  Documentation/ABI/testing/sysfs-efi-runtime-map |   45 ++++++
> >  arch/x86/include/asm/efi.h                      |    3 
> >  arch/x86/platform/efi/efi.c                     |   11 +
> >  drivers/firmware/efi/Kconfig                    |   10 +
> >  drivers/firmware/efi/Makefile                   |    1 
> >  drivers/firmware/efi/efi-runtime-map.c          |  164 ++++++++++++++++++++++++
> >  drivers/firmware/efi/efi.c                      |    3 
> >  include/linux/efi.h                             |    6 
> >  8 files changed, 242 insertions(+), 1 deletion(-)
> 
> [...]
> 
> > @@ -852,6 +855,14 @@ static void efi_map_regions(void **new_m
> >  
> >  		memcpy(*new_memmap + (*count * memmap.desc_size), md,
> >  		       memmap.desc_size);
> > +		if (md->type != EFI_BOOT_SERVICES_CODE &&
> > +			md->type != EFI_BOOT_SERVICES_DATA) {
> > +			efi_runtime_map = krealloc(efi_runtime_map,
> > +					(nr_efi_runtime_map + 1) *
> > +					sizeof(efi_memory_desc_t), GFP_KERNEL);
> > +			*(efi_runtime_map + nr_efi_runtime_map) = *md;
> > +			nr_efi_runtime_map++;
> > +		}
> >  		(*count)++;
> >  	}
> 
> You really need to be using 'memmap.desc_size' here and not
> sizeof(efi_memory_desc_t) as the two may differ. Also, you should be
> checking for failure of krealloc() and using memcpy() instead of
> directly dereferencing 'md'.

I'm a bit confused with the desc_size and sizeof(efi_memory_desc_t),
Because I intended to same struct efi_memory_desc_t in userspace to pass the
setup_data, so I worry about if desc_size will cause problems.

Will double check it.

> 
> > --- linux-2.6.orig/drivers/firmware/efi/Makefile
> > +++ linux-2.6/drivers/firmware/efi/Makefile
> > @@ -4,3 +4,4 @@
> >  obj-y					+= efi.o vars.o
> >  obj-$(CONFIG_EFI_VARS)			+= efivars.o
> >  obj-$(CONFIG_EFI_VARS_PSTORE)		+= efi-pstore.o
> > +obj-$(CONFIG_EFI_RUNTIME_MAP)		+= efi-runtime-map.o
> > --- /dev/null
> > +++ linux-2.6/drivers/firmware/efi/efi-runtime-map.c
> 
> Small nit but I wouldn't bother prefixing the filename with "efi-",
> since you can't build this file as a module.

Ok, will do

> 
> > +/*
> > + * These are default attributes that are added for every memmap entry.
> > + */
> > +static struct attribute *def_attrs[] = {
> > +	&map_type_attr.attr,
> > +	&map_phys_addr_attr.attr,
> > +	&map_virt_addr_attr.attr,
> > +	&map_num_pages_attr.attr,
> > +	&map_attribute_attr.attr,
> > +	NULL
> > +};
> 
> If the UEFI spec ever releases an update for the memory descriptor
> structure, and bumps 'memmap.desc_version', how are we going to signal
> the incompatibility to legacy versions of kexec tools?

Hmm, that is a problem. I will consider to export memmap according to
what firmware provided with extra desc_version instead of using attrs from kernel
data structure efi_memory_desc_t

Now it's clear for previous question about desc_size and sizeof(efi_memory_desc_t)
Will switch to use desc_size.

> 
> -- 
> Matt Fleming, Intel Open Source Technology Center
