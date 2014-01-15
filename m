Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296AbaAOH1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 02:27:37 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:62341 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbaAOH1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 02:27:35 -0500
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>
Cc: Elliott@hp.com, samer.el-haj-mahmoud@hp.com,
        Oliver Neukum <oneukum@suse.de>, werner@suse.com, trenn@suse.de,
        JBeulich@suse.com, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Matt Fleming <matt@console-pimps.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH] ACPI / init: Run acpi_early_init() before timekeeping_init()
Date: Wed, 15 Jan 2014 15:25:48 +0800
Message-Id: <1389770748-32698-1-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a variant patch from Rafael J. Wysocki's
ACPI / init: Run acpi_early_init() before efi_enter_virtual_mode()

According to Matt Fleming, if acpi_early_init() was executed before
efi_enter_virtual_mode(), the EFI initialization could benefit from
it, so Rafael's patch makes that happen.

And, we want accessing ACPI TAD device to set system clock, so move
acpi_early_init() before timekeeping_init(). This final position is
also before efi_enter_virtual_mode().

v2:
Move acpi_early_init() before timekeeping_init() to prepare setting
system clock with ACPI TAD.

v1:
Rafael J. Wysocki
ACPI / init: Run acpi_early_init() before efi_enter_virtual_mode()

Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Matthew Garrett <matthew.garrett@nebula.com>
Tested-by: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 init/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/main.c b/init/main.c
index febc511..b6d93c8 100644
--- a/init/main.c
+++ b/init/main.c
@@ -565,6 +565,7 @@ asmlinkage void __init start_kernel(void)
 	init_timers();
 	hrtimers_init();
 	softirq_init();
+	acpi_early_init();
 	timekeeping_init();
 	time_init();
 	sched_clock_postinit();
@@ -641,7 +642,6 @@ asmlinkage void __init start_kernel(void)
 
 	check_bugs();
 
-	acpi_early_init(); /* before LAPIC and SMP init */
 	sfi_init_late();
 
 	if (efi_enabled(EFI_RUNTIME_SERVICES)) {
-- 
1.6.4.2

