Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbaFRNwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 09:52:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386AbaFRNwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 09:52:34 -0400
Message-ID: <1403099525.32688.28.camel@deneb.redhat.com>
Subject: Re: [PATCH] arm64: support reboot and power off via EFI runtime
From: Mark Salter <msalter@redhat.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Wed, 18 Jun 2014 09:52:05 -0400
In-Reply-To: <20140618132623.GF26461@leverpostej>
References: <1403023514-1352-1-git-send-email-msalter@redhat.com>
	 <20140618132623.GF26461@leverpostej>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-18 at 14:26 +0100, Mark Rutland wrote:
> Hi Mark,
> 
> On Tue, Jun 17, 2014 at 05:45:14PM +0100, Mark Salter wrote:
> > Add handlers for arm_pm_resestart and pm_power_off which use EFI
> > runtime services ResetSystem call to perform the functions. These
> > handlers are only installed if no handler currently exists. This
> > allows PSCI to take priority over EFI for these functions.
> > 
> > Signed-off-by: Mark Salter <msalter@redhat.com>
> > ---
> >  arch/arm64/kernel/efi.c | 40 ++++++++++++++++++++++++++++++++++++++++
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
> >  	return 0;
> >  }
> >  early_initcall(arm64_enter_virtual_mode);
> > +
> > +static void efi_restart(enum reboot_mode reboot_mode, const char *cmd)
> > +{
> > +	int efi_mode;
> > +
> > +	switch (reboot_mode) {
> > +	case REBOOT_WARM:
> > +	case REBOOT_SOFT:
> > +		efi_mode = EFI_RESET_WARM;
> > +		break;
> > +	default:
> > +		efi_mode = EFI_RESET_COLD;
> > +		break;
> > +	}
> > +	efi.reset_system(efi_mode, 0, 0, NULL);
> > +}
> > +
> > +static void efi_power_off(void)
> > +{
> > +	efi.reset_system(EFI_RESET_SHUTDOWN, 0, 0, NULL);
> > +}
> > +
> > +static int __init setup_efi_reset(void)
> > +{
> > +	if (efi_enabled(EFI_RUNTIME_SERVICES)) {
> > +		/*
> > +		 * If something (psci, etc) hasn't already registered
> > +		 * a handler, use EFI.
> > +		 */
> > +		if (arm_pm_restart == NULL)
> > +			arm_pm_restart = efi_restart;
> > +		if (pm_power_off == NULL)
> > +			pm_power_off = efi_power_off;
> > +	}
> > +	return 0;
> > +}
> > +pure_initcall(setup_efi_reset);
> 
> This doesn't seem to match the definition of a pure initcall, given that
> it depends on the state of EFI runtime services and
> arm_{pm_restart,power_off}.
> 
> Is there any reason this needs to run so early? Can this not be
> called later, when we have more of a guarantee of other reboot /
> shutdown mechanisms having been registered?
> 

I used pure_initcall because that was the earliest EFI runtime services
would be available (runtime services set up with early_initcall). I was
thinking this was after psci would have a chance to set handlers and
other hw specific drivers could come later and override. But now that
you mention it, there is no reason this couldn't come much later in boot
so that the EFI handlers are a last resort.


