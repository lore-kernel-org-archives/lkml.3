Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933500AbaD2Jpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 05:45:46 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:34010 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933000AbaD2Jpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 05:45:45 -0400
Date: Tue, 29 Apr 2014 10:45:39 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Dave Young <dyoung@redhat.com>
Cc: matt.fleming@intel.com, hpa@zytor.com, akpm@linux-foundation.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH] ignore ,keep for efi earlyprintk
Message-ID: <20140429094539.GD26088@console-pimps.org>
References: <20140424093658.GA7158@dhcp-16-198.nay.redhat.com>
 <20140425115345.GC26088@console-pimps.org>
 <20140426072821.GA2286@darkstar.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140426072821.GA2286@darkstar.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Apr, at 03:28:21PM, Dave Young wrote:
> 
> There's other kernel messages without appending ,keep.
> 
> Also console=ttyS0 does not work with earlyprintk=efi,keep, removing
> ,keep it works well.

Try console=efi

> > > Actually efi earlyprintk is using __init functions such as early_ioremap etc.
> > > Thus efi earlyconsole can not be kept.
> >  
> > Urgh, good point, that's a bug. However I'm sure I've had this working
> > in the past and have in fact used it to debug stuff.
> > 
> > Could you try and fix this up so it works with 'keep'?
> 
> Will do. I want use ioremap when it is available but it's hard to decide
> where to add the code.
> 
> I'm thinking to do below:
> 1. ioremap the whole framebuffer like: efi_fb = ioremap(lfb_base, lfb_size) in the
>    function efi_enter_virtual_mode because ioremap should be usable then.
> 
> 2. add two functions for earlyprintk use (scrollup, write, etc.) 
> __init_refok void * get_vaddr(unsigned long start, unsigned long len)
> {
> 	unsigned long base;
> 
> 	base = boot_params.screen_info.lfb_base;
> 	if (efi_fb)
> 		return (efi_fb + start - base);
> 	else
> 		return early_ioremap(start, len);
> }
> 
> __init_refok void put_vaddr(void *addr, unsigned long len)
> {
> 	if (!efi_fb)
> 		early_iounmap(addr, len);
> }
> 
> But it does not sound good to add the ioremap in enter virtual mode funtion.   
> 
> Please help if you have any other better idea.

I would just replace the existing calls to early_ioremap() with
efi_ioremap() and implement it like so (all in
arch/x86/platform/efi/early_printk.c),

static void *efi_ioremap(resource_size_t phys_addr, unsigned long size)
{
	if (system_state == SYSTEM_BOOTING)
		return early_ioremap(phys_addr, size);

	return ioremap(phys_addr, size);
}

At least I think SYSTEM_BOOTING is the correct way to figure out when to
use early_ioremap(), I'm open to other suggestions though.

-- 
Matt Fleming, Intel Open Source Technology Center
