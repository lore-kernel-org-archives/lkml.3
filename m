Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbaANELD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 23:11:03 -0500
Received: from smtp.nue.novell.com ([195.135.221.5]:57481 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbaANELA (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Mon, 13 Jan 2014 23:11:00 -0500
Subject: Re: [RFT][PATCH] ACPI / init: Run acpi_early_init() before
 efi_enter_virtual_mode() (was: Re: [RFC PATCH 00/14] Support timezone of
 ACPI TAD and EFI TIME)
From: joeyli <jlee@suse.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Matt Fleming <matt@console-pimps.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Matthew Garrett <matthew.garrett@nebula.com>, Elliott@hp.com,
        samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>,
        werner@suse.com, trenn@suse.de, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org, Borislav Petkov <bp@suse.de>
In-Reply-To: <2530951.HFPX8MI38t@vostro.rjw.lan>
References: <1387439053-8711-1-git-send-email-jlee@suse.com>
	 <3476450.BMEcId2Lgj@vostro.rjw.lan>
	 <20131221122148.GB29501@console-pimps.org>
	 <2530951.HFPX8MI38t@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Jan 2014 12:09:08 +0800
Message-ID: <1389672548.24105.252.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 日，2014-01-12 於 01:30 +0100，Rafael J. Wysocki 提到：
> OK
> 
> I don't see any adverse effects of the patch below on a couple of my
> test
> boxes, but (a) they are Intel-based and (b) they are non-EFI, so it
> would be
> good to give it a go on as many machines as reasonably possible.
> 
> Thanks,
> Rafael
> 
> ---
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: ACPI / init: Run acpi_early_init() before
> efi_enter_virtual_mode()
> 
> According to Matt Fleming, if acpi_early_init() was executed befpre
> efi_enter_virtual_mode(), the EFI initialization could benefit from
> it, so make that happen.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  init/main.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-pm/init/main.c
> ===================================================================
> --- linux-pm.orig/init/main.c
> +++ linux-pm/init/main.c
> @@ -615,6 +615,7 @@ asmlinkage void __init start_kernel(void
>         calibrate_delay();
>         pidmap_init();
>         anon_vma_init();
> +       acpi_early_init();
>  #ifdef CONFIG_X86
>         if (efi_enabled(EFI_RUNTIME_SERVICES))
>                 efi_enter_virtual_mode();
> @@ -641,7 +642,6 @@ asmlinkage void __init start_kernel(void
>  
>         check_bugs();
>  
> -       acpi_early_init(); /* before LAPIC and SMP init */
>         sfi_init_late();
>  
>         if (efi_enabled(EFI_RUNTIME_SERVICES)) {
> 
> 
> 

This patch works to me on Acer Gateway Z5WT2 UEFI notebook and Intel
UEFI development board.

Does it possible move acpi_early_init() to before timekeeping_init()?
The position is also before efi_enter_virtual_mode() and that will be
useful for parsing ACPI TAD to set system clock:

diff --git a/init/main.c b/init/main.c
index febc511..b6d93c8 100644
--- a/init/main.c
+++ b/init/main.c
@@ -565,6 +565,7 @@ asmlinkage void __init start_kernel(void)
        init_timers();
        hrtimers_init();
        softirq_init();
+       acpi_early_init();
        timekeeping_init();
        time_init();
        sched_clock_postinit();
@@ -641,7 +642,6 @@ asmlinkage void __init start_kernel(void)
 
        check_bugs();
 
-       acpi_early_init(); /* before LAPIC and SMP init */
        sfi_init_late();
 
        if (efi_enabled(EFI_RUNTIME_SERVICES)) {


Thanks a lot!
Joey Lee

