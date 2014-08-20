Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808AbaHTPRF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 11:17:05 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:39320 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaHTPRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 11:17:00 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 06/19] ARM64 / ACPI: Parse FADT table to get PSCI flags
 for PSCI init
To: Hanjun Guo <hanjun.guo@linaro.org>, Olof Johansson <olof@lixom.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Will Deacon <will.deacon@arm.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@linaro.org>, Robert Richter <rric@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linaro-acpi-private@linaro.org
In-Reply-To: <53DA1916.1030907@linaro.org>
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org>
	<1406206825-15590-7-git-send-email-hanjun.guo@linaro.org>
	<CAOesGMjzFyd_=+ToFmjyn958F86KsDJDht+9ZmniAERz16K_VQ@mail.gmail.com>
	<53DA1916.1030907@linaro.org>
Date: Wed, 20 Aug 2014 10:02:54 -0500
Message-Id: <20140820150254.E115EC41205@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2014 18:23:18 +0800, Hanjun Guo <hanjun.guo@linaro.org> wrote:
> On 2014-7-31 12:22, Olof Johansson wrote:
> > Hi,
> 
> Hi Olof,
> 
> > 
> > On Thu, Jul 24, 2014 at 6:00 AM, Hanjun Guo <hanjun.guo@linaro.org> wrote:
> >> There are two flags: PSCI_COMPLIANT and PSCI_USE_HVC. When set,
> >> the former signals to the OS that the hardware is PSCI compliant.
> >> The latter selects the appropriate conduit for PSCI calls by
> >> toggling between Hypervisor Calls (HVC) and Secure Monitor Calls
> >> (SMC).
> >>
> >> FADT table contains such information, parse FADT to get the flags
> >> for PSCI init. Since ACPI 5.1 doesn't support self defined PSCI
> >> function IDs, which means that only PSCI 0.2+ is supported in ACPI.
> >>
> >> At the same time, only ACPI 5.1 or higher verison supports PSCI,
> >> and FADT Major.Minor version was introduced in ACPI 5.1, so we
> >> will check the version and only parse FADT table with version >= 5.1.
> >>
> >> If firmware provides ACPI tables with ACPI version less than 5.1,
> >> OS will be messed up with those information and have no way to
> >> bring up secondery CPUs, so disable ACPI if we get an FADT table
> >> with version less that 5.1.
> >>
> >> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> >> Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
> >> ---
> >>  arch/arm64/include/asm/acpi.h |    2 +
> >>  arch/arm64/kernel/acpi.c      |   50 ++++++++++++++++++++++
> >>  arch/arm64/kernel/psci.c      |   95 +++++++++++++++++++++++++++++------------
> >>  arch/arm64/kernel/setup.c     |    2 +
> >>  4 files changed, 121 insertions(+), 28 deletions(-)
> >>
> >> diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
> >> index 44b617f..67dac90 100644
> >> --- a/arch/arm64/include/asm/acpi.h
> >> +++ b/arch/arm64/include/asm/acpi.h
> >> @@ -18,6 +18,8 @@ extern int acpi_disabled;
> >>  extern int acpi_noirq;
> >>  extern int acpi_pci_disabled;
> >>  extern int acpi_strict;
> >> +extern int acpi_psci_present;
> >> +extern int acpi_psci_use_hvc;
> >>
> >>  static inline void disable_acpi(void)
> >>  {
> >> diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
> >> index f5a10b5..374926f 100644
> >> --- a/arch/arm64/kernel/acpi.c
> >> +++ b/arch/arm64/kernel/acpi.c
> >> @@ -11,6 +11,8 @@
> >>   *  published by the Free Software Foundation.
> >>   */
> >>
> >> +#define pr_fmt(fmt) "ACPI: " fmt
> >> +
> >>  #include <linux/init.h>
> >>  #include <linux/acpi.h>
> >>  #include <linux/cpumask.h>
> >> @@ -34,6 +36,12 @@ EXPORT_SYMBOL(acpi_disabled);
> >>  int acpi_pci_disabled;         /* skip ACPI PCI scan and IRQ initialization */
> >>  EXPORT_SYMBOL(acpi_pci_disabled);
> >>
> >> +/* 1 to indicate PSCI is implemented */
> >> +int acpi_psci_present;
> >> +
> >> +/* 1 to indicate HVC must be used instead of SMC as the PSCI conduit */
> >> +int acpi_psci_use_hvc;
> > 
> > Here's a prime example of where it would just make more sense to
> > populate DT based on what's in the ACPI info.
> > 
> > Have a acpi_parse_fadt() that, if needed, creates a /psci node in the
> > system-wide DT and populates it with the few properties needed.
> > 
> > That way, the rest of the code path in the kernel setup is identical,
> > instead of dealing with separate functions for setup, two exported
> > variables just to communicate the state, and so on. It's just extra
> > complexity for no good reason. The ACPi side code isn't even adding
> > significant complexity compared to this. We'll need to add an
> > of_add_node() property though.
> 
> Yes, this will make the code path in the kernel setup is identical, but
> I think mixture of ACPI and DT (converting ACPI into DT at run-time) is
> not a good solution, and this had been discussed last year:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-November/211662.html

Agreed. I don't want to get into populating DT structures with ACPI
data. I think doing so ends up increasing the conceptual complexity.

> >> -       np = of_find_matching_node_and_match(NULL, psci_of_match, &matched_np);
> >> +       if (acpi_disabled) {
> >> +               np = of_find_matching_node_and_match(NULL,
> >> +                               psci_of_match, &matched_np);
> > 
> > Ideally this code should go away by changing the rest of it, but for
> > future cases: It'd be a lot cleaner to do this as:
> > 
> >         if (!acpi_disabled)
> >                 return psci_0_2_init_acpi();
> > 
> > ... then fall through to the current implementation instead.
> 
> I prefer this one :)

Good! :-)

g.
