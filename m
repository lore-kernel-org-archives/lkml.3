Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbaEANQg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 09:16:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbaEANQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 09:16:34 -0400
Date: Thu, 1 May 2014 21:17:55 +0800
From: Dave Young <dyoung@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: matt.fleming@intel.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, akpm@linux-foundation.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] earlyprintk=efi,keep fix
Message-ID: <20140501131755.GC2677@darkstar.redhat.com>
References: <20140430021303.GA12316@darkstar.redhat.com>
 <20140501101220.GP26088@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140501101220.GP26088@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/14 at 11:12am, Matt Fleming wrote:
> On Wed, 30 Apr, at 10:13:03AM, Dave Young wrote:
> > 
> > earlyprintk=efi,keep will cause kernel hangs while freeing initmem like below:
> > [    2.826089] VFS: Mounted root (ext4 filesystem) readonly on device 254:2.
> > [    2.846592] devtmpfs: mounted
> > [    2.856974] Freeing unused kernel memory: 880K (ffffffff817d4000 - ffffffff818b0000)
> > 
> > It is caused by efi earlyprintk use __init function which will be freed later.
> > Such as early_efi_write is marked as __init, also it will use early_ioremap
> > which is init function as well.
> > 
> > To fix this issue, I added one early initcall efi_ioremap_fb which will map the whole
> > efi fb for later use. OTOH, adding a wrapper function efi_ioremap which will call
> > early_ioremap before ioremap is available.
> > 
> > With this patch applied efi boot ok with earlyprintk=efi,keep console=efi
> > 
> > Signed-off-by: Dave Young <dyoung@redhat.com>
> > ---
> >  arch/x86/platform/efi/early_printk.c |   54 +++++++++++++++++++++++++++--------
> >  1 file changed, 42 insertions(+), 12 deletions(-)
>  
> Thanks Dave, good catch. I've got a few comments below.
> 
> > +static __init int efi_ioremap_fb(void)
> > +{
> > +	unsigned long base, size;
> > +
> > +	base = boot_params.screen_info.lfb_base;
> > +	size = boot_params.screen_info.lfb_size;
> > +	efi_fb = ioremap(base, size);
> > +
> > +	return efi_fb ? 0 : -ENOMEM;
> > +}
> > +early_initcall(efi_ioremap_fb);
> 
> So, here you're actually ioremap'ing the framebuffer irrespective of
> whether anyone passed earlyprintk=efi,keep on the command line.
> Furthermore, you'll perform the ioremap() even if some error was
> encountered in early_efi_setup().
> 
> You need a way to figure out whether the ioremap() is actually needed.
> 
> Please document this function to explain why we need to ioremap() the
> framebuffer from an early_initcall().
> 
> Oh and as a side note, please prefix functions in this file with
> early_efi_*. Yeah, I realise that I suggested efi_ioremap() as a name -
> my bad.
> 
> > +static __init_refok void *efi_ioremap(unsigned long start, unsigned long len)
> > +{
> > +	unsigned long base;
> > +
> > +	base = boot_params.screen_info.lfb_base;
> > +	if (efi_fb)
> > +		return (efi_fb + start - base);
> > +	else
> > +		return early_ioremap(start, len);
> > +}
> 
> Adding .lfb_base in the caller and then subtracting here seems
> needlessly complicated. Instead I'd suggest making early_efi_map() take
> an offset and a length, and document when each framebuffer is used.

Matt, thanks for the comments. I have sent out an update patch which addressed
the comments except the last one "and document when each framebuffer is used"
I added comment before function early_efi_map, not sure if it's what you want.

Thanks
Dave
