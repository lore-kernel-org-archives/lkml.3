Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436AbaDZH1H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 03:27:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbaDZH1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 03:27:05 -0400
Date: Sat, 26 Apr 2014 15:28:21 +0800
From: Dave Young <dyoung@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: matt.fleming@intel.com, hpa@zytor.com, akpm@linux-foundation.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH] ignore ,keep for efi earlyprintk
Message-ID: <20140426072821.GA2286@darkstar.redhat.com>
References: <20140424093658.GA7158@dhcp-16-198.nay.redhat.com>
 <20140425115345.GC26088@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140425115345.GC26088@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/14 at 12:53pm, Matt Fleming wrote:
> On Thu, 24 Apr, at 05:36:58PM, Dave Young wrote:
> > earlyprint=efi,keep results a kernel hang after "Freeing unused kernel memory"
>  
> Are you sure it hangs and it's not just that nothing is output to the
> console after that point?

There's other kernel messages without appending ,keep.

Also console=ttyS0 does not work with earlyprintk=efi,keep, removing ,keep it works well.

> 
> > Actually efi earlyprintk is using __init functions such as early_ioremap etc.
> > Thus efi earlyconsole can not be kept.
>  
> Urgh, good point, that's a bug. However I'm sure I've had this working
> in the past and have in fact used it to debug stuff.
> 
> Could you try and fix this up so it works with 'keep'?

Will do. I want use ioremap when it is available but it's hard to decide
where to add the code.

I'm thinking to do below:
1. ioremap the whole framebuffer like: efi_fb = ioremap(lfb_base, lfb_size) in the
   function efi_enter_virtual_mode because ioremap should be usable then.

2. add two functions for earlyprintk use (scrollup, write, etc.) 
__init_refok void * get_vaddr(unsigned long start, unsigned long len)
{
	unsigned long base;

	base = boot_params.screen_info.lfb_base;
	if (efi_fb)
		return (efi_fb + start - base);
	else
		return early_ioremap(start, len);
}

__init_refok void put_vaddr(void *addr, unsigned long len)
{
	if (!efi_fb)
		early_iounmap(addr, len);
}

But it does not sound good to add the ioremap in enter virtual mode funtion.   

Please help if you have any other better idea.

Thanks
Dave
