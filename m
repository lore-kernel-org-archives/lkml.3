Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964848AbaE2JHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 05:07:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933198AbaE2JHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 05:07:53 -0400
Date: Thu, 29 May 2014 17:09:13 +0800
From: Dave Young <dyoung@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: matt.fleming@intel.com, bp@alien8.de, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH] export efi.flags to sysfs
Message-ID: <20140529090913.GK2068@darkstar.nay.redhat.com>
References: <20140526083935.GA19682@dhcp-16-198.nay.redhat.com>
 <20140527133411.GG10994@redhat.com>
 <20140528021359.GC2820@darkstar.nay.redhat.com>
 <20140528124029.GF14863@redhat.com>
 <20140529020837.GB2068@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140529020837.GB2068@darkstar.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/14 at 10:08am, Dave Young wrote:
> On 05/28/14 at 08:40am, Vivek Goyal wrote:
> > On Wed, May 28, 2014 at 10:13:59AM +0800, Dave Young wrote:
> > > On 05/27/14 at 09:34am, Vivek Goyal wrote:
> > > > On Mon, May 26, 2014 at 04:39:35PM +0800, Dave Young wrote:
> > > > > 
> > > > > For efi=old_map and any old_map quirks like SGI UV in current
> > > > > tree kexec/kdump will fail because it depends on the new 1:1 mapping.
> > > > > 
> > > > > Thus export the mapping method to sysfs so kexec tools can switch
> > > > > to original way to boot.
> > > > > 
> > > > > Since we have efi.flags for all efi facilities so let's just export the
> > > > > efi.flags itself, it maybe useful for other arches and use cases.
> > > > > 
> > > > 
> > > > Does it require any documentation in Documentation/ABI/..
> > > 
> > > Yes, it's necessary. Will do in next version.
> > > 
> > > I'm still discussing with Matt, exporting efi.flags seems not a good way
> > > because they are more internal interfaces. 
> > > 
> > > Probably I should export only a file 'old_map' instead.
> > 
> > How does /sys/firmware/efi/runtime-map/* look like with old mapping? Can't
> > we look at it and figure out if it is 1:1 or not.
> 
> There's phys_addr and virt_addr, (virt_addr - phys_addr) will always be
> -64G for 1:1 map, ioremapped addresses space is different.
> 
> So this is a good idea, we can do this way to avoid more ABI.

Thinking more about it. There's another another way. ioremapped addresses can not
be garanteed to be same in 2nd kernel, but for same kernel it's usually are same
so in 2nd kernel just try ioremap the regions again hopefully it will work.
At lease it works for me before Boris's patchset. So user can do some test if it
works then just use it as is. If kexec/kdump test failed he can switch to use
--noefi in userspace. Like below patch:


Subject: [PATCH 2/2] x86: kexec efi boot use ioremap in case efi=old_map

In case efi=old_map or quirked system which use old ioremap kexec should
hopefully work for same kernel but it is not garanteed to be true.

It will help if one has to use old_map and he want kexec support as well.
At the same time he has succesfully tested the kexec boot. If it does not
work then user can switch to use kexec --noefi in userspace instead.

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 arch/x86/platform/efi/efi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 3781dd3..d2eaa6f 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -1030,7 +1030,11 @@ static void __init kexec_enter_virtual_mode(void)
 	*/
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
-		efi_map_region_fixed(md); /* FIXME: add error handling */
+		/* For ioremapped ranges it will hopefully work with same kernel. */
+		if (efi_enabled(EFI_OLD_MEMMAP))
+			old_map_region(md);
+		else
+			efi_map_region_fixed(md); /* FIXME: add error handling */
 		get_systab_virt_addr(md);
 	}
 
