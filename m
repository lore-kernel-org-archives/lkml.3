Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966406AbaFROmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:42:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbaFROmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:42:20 -0400
Message-ID: <1403102507.32688.42.camel@deneb.redhat.com>
Subject: Re: [PATCH] arm64: support reboot and power off via EFI runtime
From: Mark Salter <msalter@redhat.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-efi@vger.kernel.org, Matt Fleming <matt@console-pimps.org>
Date: Wed, 18 Jun 2014 10:41:47 -0400
In-Reply-To: <CAL_JsqJUMMRwUn+PUiFweDOywgLCbKiWfDTLDSfJqE9oTV5gYw@mail.gmail.com>
References: <1403023514-1352-1-git-send-email-msalter@redhat.com>
	 <CAL_JsqJUMMRwUn+PUiFweDOywgLCbKiWfDTLDSfJqE9oTV5gYw@mail.gmail.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-18 at 09:09 -0500, Rob Herring wrote:
> On Tue, Jun 17, 2014 at 11:45 AM, Mark Salter <msalter@redhat.com> wrote:
> > Add handlers for arm_pm_resestart and pm_power_off which use EFI
> 
> typo.
> 
> > runtime services ResetSystem call to perform the functions. These
> > handlers are only installed if no handler currently exists. This
> > allows PSCI to take priority over EFI for these functions.
> >
> > Signed-off-by: Mark Salter <msalter@redhat.com>
> > ---
> >  arch/arm64/kernel/efi.c | 40 ++++++++++++++++++++++++++++++++++++++++
> 
> Where's the arm32 version? Surely this could be shared with all
> arches. pm_power_off is at least architecturally independent. We
> should do the same for restart/reboot. I'm not saying do that now, but
> at least put it in the right place for that to happen.
> 
> Rob

Good point. So the right place would be drivers/firmware/efi I think.
Add a CONFIG_EFI_RESET with default off. I suppose we could also
go ahead and s/arm_pm_restart/pm_restart/ kernel-wide or have an
ifdef in the code (or depends on ARM64 || ARM in Kconfig) until we
do so.

[Matt Fleming CC'd]

> 
> >  1 file changed, 40 insertions(+)
> >
> > diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> > index 14db1f6..e8c0476 100644
> > --- a/arch/arm64/kernel/efi.c
> > +++ b/arch/arm64/kernel/efi.c
> > @@ -19,11 +19,14 @@
> >  #include <linux/of_fdt.h>
> >  #include <linux/sched.h>
> >  #include <linux/slab.h>
> > +#include <linux/reboot.h>
> > +#include <linux/pm.h>
> >
> >  #include <asm/cacheflush.h>
> >  #include <asm/efi.h>
> >  #include <asm/tlbflush.h>
> >  #include <asm/mmu_context.h>
> > +#include <asm/system_misc.h>
> >
> >  struct efi_memory_map memmap;
> >
> > @@ -467,3 +470,40 @@ static int __init arm64_enter_virtual_mode(void)
> >         return 0;
> >  }
> >  early_initcall(arm64_enter_virtual_mode);
> > +
> > +static void efi_restart(enum reboot_mode reboot_mode, const char *cmd)
> > +{
> > +       int efi_mode;
> > +
> > +       switch (reboot_mode) {
> > +       case REBOOT_WARM:
> > +       case REBOOT_SOFT:
> > +               efi_mode = EFI_RESET_WARM;
> > +               break;
> > +       default:
> > +               efi_mode = EFI_RESET_COLD;
> > +               break;
> > +       }
> > +       efi.reset_system(efi_mode, 0, 0, NULL);
> > +}
> > +
> > +static void efi_power_off(void)
> > +{
> > +       efi.reset_system(EFI_RESET_SHUTDOWN, 0, 0, NULL);
> > +}
> > +
> > +static int __init setup_efi_reset(void)
> > +{
> > +       if (efi_enabled(EFI_RUNTIME_SERVICES)) {
> > +               /*
> > +                * If something (psci, etc) hasn't already registered
> > +                * a handler, use EFI.
> > +                */
> > +               if (arm_pm_restart == NULL)
> > +                       arm_pm_restart = efi_restart;
> > +               if (pm_power_off == NULL)
> > +                       pm_power_off = efi_power_off;
> > +       }
> > +       return 0;
> > +}
> > +pure_initcall(setup_efi_reset);
> > --
> > 1.9.0
> >
> >
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel


