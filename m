Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbaGLAsk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 20:48:40 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:41445 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbaGLAsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 20:48:39 -0400
Date: Sat, 12 Jul 2014 02:47:51 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: x86@kernel.org, Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        tglx@linutronix.de, andrew.cooper3@citrix.com,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>, david.vrabel@citrix.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com, matt.fleming@intel.com,
        jbeulich@suse.com, xen-devel@lists.xenproject.org, mingo@redhat.com,
        jeremy@goop.org, ian.campbell@citrix.com
Subject: Re: [PATCH 2/2] arch/x86/xen: Silence compiler warnings
Message-ID: <20140712004751.GN13620@olila.local.net-space.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 08:14:51PM -0400, Konrad Rzeszutek Wilk wrote:
>
> On Jul 11, 2014 7:45 PM, Daniel Kiper <daniel.kiper@oracle.com> wrote:
> >
> > On Fri, Jul 11, 2014 at 04:32:27PM -0400, Boris Ostrovsky wrote:
> > > On 07/11/2014 04:10 PM, Daniel Kiper wrote:
> > > >On Fri, Jul 11, 2014 at 04:03:46PM -0400, Boris Ostrovsky wrote:
> > > >>On 07/11/2014 03:54 PM, Daniel Kiper wrote:
> > > >>>Compiler complains in the following way when x86 32-bit kernel
> > > >>>with Xen support is build:
> > > >>>
> > > >>>   CC      arch/x86/xen/enlighten.o
> > > >>>arch/x86/xen/enlighten.c: In function ‘xen_start_kernel’:
> > > >>>arch/x86/xen/enlighten.c:1726:3: warning: right shift count >= width of type [enabled by default]
> > > >>>
> > > >>>Such line contains following EFI initialization code:
> > > >>>
> > > >>>boot_params.efi_info.efi_systab_hi = (__u32)(__pa(efi_systab_xen) >> 32);
> > > >>>
> > > >>>There is no issue if x86 64-bit kernel is build. However, 32-bit case
> > > >>>generate warning (even if that code will not be executed because Xen
> > > >>>does not work on 32-bit EFI platforms) due to __pa() returning unsigned long
> > > >>>type which has 32-bits width. So move whole EFI initialization stuff
> > > >>>to separate function and build its body conditionally to avoid above
> > > >>>mentioned warning on x86 32-bit architecture.
> > > >>>
> > > >>>Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
> > > >>>---
> > > >>>  arch/x86/xen/enlighten.c |   35 ++++++++++++++++++++++-------------
> > > >>>  1 file changed, 22 insertions(+), 13 deletions(-)
> > > >>>
> > > >>>diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> > > >>>index bc89647..6abec74 100644
> > > >>>--- a/arch/x86/xen/enlighten.c
> > > >>>+++ b/arch/x86/xen/enlighten.c
> > > >>>@@ -1516,12 +1516,32 @@ static void __init xen_pvh_early_guest_init(void)
> > > >>>  #endif
> > > >>>  }
> > > >>>+static void __init xen_efi_init(void)
> > > >>>+{
> > > >>>+#ifdef CONFIG_XEN_EFI
> > > >>>+ efi_system_table_t *efi_systab_xen;
> > > >>>+
> > > >>>+ efi_systab_xen = xen_efi_probe();
> > > >>>+
> > > >>>+ if (efi_systab_xen == NULL)
> > > >>>+ return;
> > > >>>+
> > > >>>+ strncpy((char *)&boot_params.efi_info.efi_loader_signature, "Xen",
> > > >>>+ sizeof(boot_params.efi_info.efi_loader_signature));
> > > >>>+ boot_params.efi_info.efi_systab = (__u32)__pa(efi_systab_xen);
> > > >>>+ boot_params.efi_info.efi_systab_hi = (__u32)(__pa(efi_systab_xen) >> 32);
> > > >>>+
> > > >>>+ set_bit(EFI_BOOT, &efi.flags);
> > > >>>+ set_bit(EFI_PARAVIRT, &efi.flags);
> > > >>>+ set_bit(EFI_64BIT, &efi.flags);
> > > >>>+#endif
> > > >>>+}
> > > >>>+
> > > >>>  /* First C function to be called on Xen boot */
> > > >>>  asmlinkage __visible void __init xen_start_kernel(void)
> > > >>>  {
> > > >>>  struct physdev_set_iopl set_iopl;
> > > >>>  int rc;
> > > >>>- efi_system_table_t *efi_systab_xen;
> > > >>>  if (!xen_start_info)
> > > >>>  return;
> > > >>>@@ -1717,18 +1737,7 @@ asmlinkage __visible void __init xen_start_kernel(void)
> > > >>>  xen_setup_runstate_info(0);
> > > >>>- efi_systab_xen = xen_efi_probe();
> > > >>>-
> > > >>>- if (efi_systab_xen) {
> > > >>>- strncpy((char *)&boot_params.efi_info.efi_loader_signature, "Xen",
> > > >>>- sizeof(boot_params.efi_info.efi_loader_signature));
> > > >>>- boot_params.efi_info.efi_systab = (__u32)__pa(efi_systab_xen);
> > > >>>- boot_params.efi_info.efi_systab_hi = (__u32)(__pa(efi_systab_xen) >> 32);
> > > >>>-
> > > >>>- set_bit(EFI_BOOT, &efi.flags);
> > > >>>- set_bit(EFI_PARAVIRT, &efi.flags);
> > > >>>- set_bit(EFI_64BIT, &efi.flags);
> > > >>>- }
> > > >>>+ xen_efi_init();
> > > >>I'd put ifdef CONFIG_XEN_EFI around the call instead of having it
> > > >>inside the routine.
> > > >Well, I thought about that a bit and I prefer function like Konrad.
> > > >Could you agree with him which solution do you (as maintainers) prefer?
> > > >
> > >
> > > I am not arguing against having a separate routine. All I am saying
> > > is that calling xen_efi_init() when CONFIG_XEN_EFI is not defined
> > > doesn't look logical. It will also add an unnecessary call (although
> >
> > Ahh... I misunderstood you. However, your proposal, as below:
> >
> > #ifdef CONFIG_XEN_EFI
> >   xen_efi_init();
> > #endif
> >
> > does not solve the problem because this vulnerable shift will be still
> > visible for compiler during x86 32-bit kernel build.
> >
> > > compiler may optimize it out).
> >
> > Please loot at arch/x86/xen/enlighten.c:xen_check_mwait() and
> > arch/x86/xen/enlighten.c:xen_boot_params_init_edd() (probably
> > there are more stuff like that around). As I can see this is fairly
> > common solution and probably compiler cope with it quite well.
> >
>
> Those are some examples of some rather bad examples.

What is wrong with them?

> The way that is preferred in the Linux code is to have the ifdef in headers.
>
> See
> http://lxr.free-electrons.com/source/arch/x86/include/asm/xen/swiotlb-xen.h
> Or
> http://lxr.free-electrons.com/source/arch/x86/include/asm/xen/pci.h
>
> You can create a similar file there and for the 32 bit implementation just make an empty static function.
>
> The 64 bit implementation has to be somewhere. Can it be in the Xen EFI file which is only compiled on 64 bit platforms?

OK, this (putting declaration/definition in *.h file) makes sens if you
declare/define functions which must be called from different places.
However, xen_efi_init() is called only once in arch/x86/xen/enlighten.c.
Of course, I could define this function here in similar way like it is done
in above headers but it take a bit more place. However, if you wish why not.

Daniel
