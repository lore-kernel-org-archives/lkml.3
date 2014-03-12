Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbaCLXMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 19:12:37 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:64092 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752487AbaCLXMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 19:12:35 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: joeyli <jlee@suse.com>, Julian Wollrath <jwollrath@web.de>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RESEND] Fast TSC calibration fails with v3.14-rc1 and later
Date: Thu, 13 Mar 2014 00:27:56 +0100
Message-ID: <1554867.utJVyPuT6A@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc6+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.02.1403121729060.18573@ionos.tec.linutronix.de>
References: <20140310110410.5b2218f6@ilfaris> <alpine.DEB.2.02.1403121722030.18573@ionos.tec.linutronix.de> <alpine.DEB.2.02.1403121729060.18573@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 12, 2014 05:39:15 PM Thomas Gleixner wrote:
> On Wed, 12 Mar 2014, Thomas Gleixner wrote:
> > On Wed, 12 Mar 2014, Thomas Gleixner wrote:
> > 
> > > On Wed, 12 Mar 2014, joeyli wrote:
> > > > I think maybe still using ACPI_FADT_NO_CMOS_RTC to check does
> > > > acpi_early_init() need run before timekeeping_init().
> > > > If there have any future machine that applied ACPI TAD but "Fast TSC
> > > > calibration" fail, at least the alternate TSC calibration can work
> > > > around issue.
> > > 
> > > Well, it can work around, but it sucks as it's way slower than the
> > > fast one. And we really don't want to pay that price for some half
> > > baken ACPI nonsense.
> > > 
> > > Why exactly do you need that ACPI stuff before timekeeping_init()?
> > 
> > According to the changelog:
> > 
> >     And, we want accessing ACPI TAD device to set system clock, so move
> >     acpi_early_init() before timekeeping_init(). This final position is
> >     also before efi_enter_virtual_mode().
> > 
> > Why do we need to access that TAD thing (whatever newfangled that is)
> > at this point?
> 
> And we have no support for that nonsense in tree, so why do we need to
> disturb functionality which does not need that at all?
> 
> We can revisit the issue when we actually have reached a conclusion
> how to deal with that and when we are merging something which supports
> TAD.
> 
> Up to then we really can live without that and put the call just
> before efi_enter_virtual_mode().

I agree, and we need to fix that for 3.14.  Patch is appended.

Thanks,
Rafael


---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: ACPI / init: Invoke early ACPI initialization later

Commit 73f7d1ca3263 (ACPI / init: Run acpi_early_init() before
timekeeping_init()) optimistically moved the early ACPI initialization
before timekeeping_init(), but that didn't work, because it broke fast
TSC calibration for Julian Wollrath on Thinkpad x121e (and most likely
for others too).  The reason is that acpi_early_init() enables the SCI
and that interferes with the fast TSC calibration mechanism.

Thus follow the original idea to execute acpi_early_init() before
efi_enter_virtual_mode() to help the EFI people for now and we can
revisit the other problem that commit 73f7d1ca3263 attempted to
address in the future (if really necessary).

Fixes: 73f7d1ca3263 (ACPI / init: Run acpi_early_init() before timekeeping_init())
Reported-by: Julian Wollrath <jwollrath@web.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-pm/init/main.c
===================================================================
--- linux-pm.orig/init/main.c
+++ linux-pm/init/main.c
@@ -561,7 +561,6 @@ asmlinkage void __init start_kernel(void
 	init_timers();
 	hrtimers_init();
 	softirq_init();
-	acpi_early_init();
 	timekeeping_init();
 	time_init();
 	sched_clock_postinit();
@@ -613,6 +612,7 @@ asmlinkage void __init start_kernel(void
 	calibrate_delay();
 	pidmap_init();
 	anon_vma_init();
+	acpi_early_init();
 #ifdef CONFIG_X86
 	if (efi_enabled(EFI_RUNTIME_SERVICES))
 		efi_enter_virtual_mode();

