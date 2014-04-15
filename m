Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751067AbaDOHpl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 03:45:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:24769 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbaDOHpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 03:45:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="520969288"
Date: Tue, 15 Apr 2014 15:44:43 +0800
From: Feng Tang <feng.tang@intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Clemens Ladisch <clemens@ladisch.de>, tglx@linutronix.de, mingo@elte.hu,
        hpa@zytor.com, linux-kernel@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v2] x86: hpet: Don't default CONFIG_HPET_TIMER to be y
 for X86_64
Message-ID: <20140415074443.GA10911@feng-snb>
References: <1395975316-4795-1-git-send-email-feng.tang@intel.com>
 <20140328071716.GC30107@gmail.com>
 <20140328073718.GA12762@feng-snb>
 <53352DE5.2090600@ladisch.de>
 <20140328081117.GA32308@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140328081117.GA32308@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Fri, Mar 28, 2014 at 09:11:17AM +0100, Ingo Molnar wrote:
> 
> * Clemens Ladisch <clemens@ladisch.de> wrote:
> 
> > Feng Tang wrote:
> > > On Fri, Mar 28, 2014 at 08:17:16AM +0100, Ingo Molnar wrote:
> > >> * Feng Tang <feng.tang@intel.com> wrote:
> > >>  - or the kernel should have a quirk to reliably disable it. Why
> > >>    should we crash or misbehave if a driver is built into the
> > >>    kernel?
> > >
> > > I thought about this before, HPET doesn't have PCI ID like stuff,
> > 
> > HPET does have the PCI vendor ID in the first register.
> > 
> > > only thing I can think of to identify them may be the CPU family/ID.
> > 
> > The HPET is implemented by some actual chip, and that chip also has lots
> > of PCI devices.  (In the case of a SoC, the CPU ID would work, too).
> 
> Correct. See arch/x86/kernel/hpet.c, which has a large number of HPET 
> quirks keyed off chipset PCI IDs:
> 
>   DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ESB2_0,
>                            ich_force_enable_hpet);
>   DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH6_0,
>                            ich_force_enable_hpet);
>   DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH6_1,
>                            ich_force_enable_hpet);
>   [...]

I just gave it another thought, that the HPET on our platform currently
do have some problem to be used as clocksource/clockevent, but it may
get fixed in future version (by Silicon or BIOS). 

If I add quirk to block it now, I may revert this code in future when
it get fixed, same problem applis for the future generation of platform.

So can we do a small change like below, so that we are able to disable
the HPET_TIMER in our own x86_64 .config, while all exising distributions
are not affected as it is still default "y" .

---
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f67e839..a1027a5 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -711,7 +711,7 @@ source "arch/x86/Kconfig.cpu"
 
 config HPET_TIMER
 	def_bool X86_64
-	prompt "HPET Timer Support" if X86_32
+	prompt "HPET Timer Support"
 	---help---
 	  Use the IA-PC HPET (High Precision Event Timer) to manage
 	  time in preference to the PIT and RTC, if a HPET is


Thanks,
Feng

