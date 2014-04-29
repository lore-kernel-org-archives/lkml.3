Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933579AbaD2KCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 06:02:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933515AbaD2KC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 06:02:28 -0400
Date: Tue, 29 Apr 2014 18:03:52 +0800
From: Dave Young <dyoung@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: matt.fleming@intel.com, hpa@zytor.com, akpm@linux-foundation.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH] ignore ,keep for efi earlyprintk
Message-ID: <20140429100352.GD2016@darkstar.nay.redhat.com>
References: <20140424093658.GA7158@dhcp-16-198.nay.redhat.com>
 <20140425115345.GC26088@console-pimps.org>
 <20140426072821.GA2286@darkstar.redhat.com>
 <20140429094539.GD26088@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140429094539.GD26088@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/14 at 10:45am, Matt Fleming wrote:
> On Sat, 26 Apr, at 03:28:21PM, Dave Young wrote:
> > 
> > There's other kernel messages without appending ,keep.
> > 
> > Also console=ttyS0 does not work with earlyprintk=efi,keep, removing
> > ,keep it works well.
> 
> Try console=efi

With console=efi, it also hangs the screen is not readable. When I add both console=efi
and console=ttyS0, in serial console output looks like it hangs while mounting rootfs. 
On screen it's same as console=efi only case.

I justed tested on qemu.

> 
> > > > Actually efi earlyprintk is using __init functions such as early_ioremap etc.
> > > > Thus efi earlyconsole can not be kept.
> > >  
> > > Urgh, good point, that's a bug. However I'm sure I've had this working
> > > in the past and have in fact used it to debug stuff.
> > > 
> > > Could you try and fix this up so it works with 'keep'?
> > 
> > Will do. I want use ioremap when it is available but it's hard to decide
> > where to add the code.
> > 
> > I'm thinking to do below:
> > 1. ioremap the whole framebuffer like: efi_fb = ioremap(lfb_base, lfb_size) in the
> >    function efi_enter_virtual_mode because ioremap should be usable then.
> > 
> > 2. add two functions for earlyprintk use (scrollup, write, etc.) 
> > __init_refok void * get_vaddr(unsigned long start, unsigned long len)
> > {
> > 	unsigned long base;
> > 
> > 	base = boot_params.screen_info.lfb_base;
> > 	if (efi_fb)
> > 		return (efi_fb + start - base);
> > 	else
> > 		return early_ioremap(start, len);
> > }
> > 
> > __init_refok void put_vaddr(void *addr, unsigned long len)
> > {
> > 	if (!efi_fb)
> > 		early_iounmap(addr, len);
> > }
> > 
> > But it does not sound good to add the ioremap in enter virtual mode funtion.   
> > 
> > Please help if you have any other better idea.
> 
> I would just replace the existing calls to early_ioremap() with
> efi_ioremap() and implement it like so (all in
> arch/x86/platform/efi/early_printk.c),
> 
> static void *efi_ioremap(resource_size_t phys_addr, unsigned long size)
> {
> 	if (system_state == SYSTEM_BOOTING)
> 		return early_ioremap(phys_addr, size);
> 
> 	return ioremap(phys_addr, size);
> }
> 
> At least I think SYSTEM_BOOTING is the correct way to figure out when to
> use early_ioremap(), I'm open to other suggestions though.

I also thought about this before, but I remember it hangs before system state
changing.

The flow is like below, I added some debug printk, only the ones before free_initmem()
shows in log. Thus I guess this will not work. But I can have a try. 
        kernel_init_freeable();
        /* need to finish all async __init code before freeing the memory */
        async_synchronize_full();
        free_initmem();
        mark_rodata_ro();
        system_state = SYSTEM_RUNNING; 

Thanks
Dave
