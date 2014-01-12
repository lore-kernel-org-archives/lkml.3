Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750977AbaALAQd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 19:16:33 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:52794 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750876AbaALAQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 19:16:30 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Matt Fleming <matt@console-pimps.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, joeyli <jlee@suse.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Matthew Garrett <matthew.garrett@nebula.com>, Elliott@hp.com,
        samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>,
        werner@suse.com, trenn@suse.de, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org, Borislav Petkov <bp@suse.de>
Subject: [RFT][PATCH] ACPI / init: Run acpi_early_init() before efi_enter_virtual_mode() (was: Re: [RFC PATCH 00/14] Support timezone of ACPI TAD and EFI TIME)
Date: Sun, 12 Jan 2014 01:30:23 +0100
Message-ID: <2530951.HFPX8MI38t@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc6+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20131221122148.GB29501@console-pimps.org>
References: <1387439053-8711-1-git-send-email-jlee@suse.com> <3476450.BMEcId2Lgj@vostro.rjw.lan> <20131221122148.GB29501@console-pimps.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, December 21, 2013 12:21:48 PM Matt Fleming wrote:
> On Fri, 20 Dec, at 11:18:56PM, Rafael J. Wysocki wrote:
> > 
> > I'm not sure 100%, but I *think* we need to do that with interrupts enabled.
> > At least after mm_init(), because it relies on things initialized there if I
> > remember correctly.
> > 
> > From what I can tell at the moment, it might be possible to move it before
> > efi_enter_virtual_mode() if that would help.
> 
> Actually yeah, that would be super useful, and I think we'd be able to
> get rid of the whole efi_late_init() stuff because we'd no longer need
> to hang on to the EFI_BOOT_SERVICES* regions after
> SetVirtualAddressMap().

OK

I don't see any adverse effects of the patch below on a couple of my test
boxes, but (a) they are Intel-based and (b) they are non-EFI, so it would be
good to give it a go on as many machines as reasonably possible.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: ACPI / init: Run acpi_early_init() before efi_enter_virtual_mode()

According to Matt Fleming, if acpi_early_init() was executed befpre
efi_enter_virtual_mode(), the EFI initialization could benefit from
it, so make that happen.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-pm/init/main.c
===================================================================
--- linux-pm.orig/init/main.c
+++ linux-pm/init/main.c
@@ -615,6 +615,7 @@ asmlinkage void __init start_kernel(void
 	calibrate_delay();
 	pidmap_init();
 	anon_vma_init();
+	acpi_early_init();
 #ifdef CONFIG_X86
 	if (efi_enabled(EFI_RUNTIME_SERVICES))
 		efi_enter_virtual_mode();
@@ -641,7 +642,6 @@ asmlinkage void __init start_kernel(void
 
 	check_bugs();
 
-	acpi_early_init(); /* before LAPIC and SMP init */
 	sfi_init_late();
 
 	if (efi_enabled(EFI_RUNTIME_SERVICES)) {

