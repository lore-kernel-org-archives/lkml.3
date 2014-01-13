Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbaAMS4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 13:56:53 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:37128 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbaAMS4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 13:56:50 -0500
Date: Mon, 13 Jan 2014 18:57:15 +0000
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, linux-efi@vger.kernel.org,
        linux@arm.linux.org.uk, patches@linaro.org, roy.franz@linaro.org,
        matt.fleming@intel.com, msalter@redhat.com
Subject: Re: [PATCH v4 5/5] init: efi: arm: enable (U)EFI runtime services on
 arm
Message-ID: <20140113185714.GE30907@bivouac.eciton.net>
References: <1389445524-30623-1-git-send-email-leif.lindholm@linaro.org>
 <1389445524-30623-6-git-send-email-leif.lindholm@linaro.org>
 <201401131929.07236.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201401131929.07236.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 07:29:06PM +0100, Arnd Bergmann wrote:
> On Saturday 11 January 2014, Leif Lindholm wrote:
> > diff --git a/init/main.c b/init/main.c
> > index febc511..1331829 100644
> > --- a/init/main.c
> > +++ b/init/main.c
> > @@ -905,6 +905,10 @@ static noinline void __init kernel_init_freeable(void)
> >         smp_prepare_cpus(setup_max_cpus);
> >  
> >         do_pre_smp_initcalls();
> > +
> > +       if (IS_ENABLED(CONFIG_ARM) && efi_enabled(EFI_BOOT))
> > +               efi_enter_virtual_mode();
> 
> What is the dependency on CONFIG_ARM here? Wouldn't most other
> architectures need the same?

Most 64-bit architectures could get away from it.
x86 does it where its particular init environment forces it to.

For arm, the strict ordering requirement is for efi_enter_virtual_mode
to be called after init_static_idmap.

If ordering between early_initcalls was possible in a sane way, I could
do that instead, but I don't think a patch that swapped order of kernel/
and mm/ in arch/arm/Makefile would be accepted :)

> I'd rather not see this turn into
> a long list of CONFIG_$(ARCH) checks if other architectures
> enable it in the same place.
> 
> I also wonder why the three architectures implementing it all
> call this from wildly different places during init/main.c, namely
> (very early) setup_arch() on ia64,

Likewise arm64.

> (relatively early) start_kernel
> on x86 and (relatively late) kernel_init_freeable on arm.

As I said - the pure 64-bit archs have less of an issue, since they
can have their kernel somewhere that won't clash with the 1:1 mapping
of RAM required by UEFI SetVirtualAddressMap.

> In general, I'd be happy with adding this as late in the startup
> code as possible, but it may be better to use the same place as
> x86 in order to avoid surprises with unexpected dependencies.

I _really_ don't want to call SetVirtualAddressMap after smp_init.

> One such dependency that may cause problems is the fact that
> we (try to) call efi_late_init() before efi_enter_virtual_mode()
> now.

Well, efi_late_init() is an inline {} on everything !x86.

/
    Leif
