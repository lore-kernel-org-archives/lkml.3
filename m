Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbaCKN30 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 09:29:26 -0400
Received: from mout.web.de ([212.227.17.12]:50608 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392AbaCKN3Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 09:29:25 -0400
Date: Tue, 11 Mar 2014 14:29:10 +0100
From: Julian Wollrath <jwollrath@web.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND] Fast TSC calibration fails with v3.14-rc1 and later
Message-ID: <20140311142910.27594027@ilfaris>
In-Reply-To: <alpine.DEB.2.02.1403101123470.18573@ionos.tec.linutronix.de>
References: <20140310110410.5b2218f6@ilfaris>
 <alpine.DEB.2.02.1403101123470.18573@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K0:NRecu9gJCQBD0lQzcIh+C/rqfdTV+2XJ+5uJXPBoXt5Szglv9lK
 rN6/GS7ZdLLy/Ha1/KvHyyhnkQIq2t7aHP/h5mHDiBkcDrOwbpdEj+hCFCSz5KKjQwkfy6/
 7nRKUqDOhWz2x3IJIC59VVdZU3DR0C/aqjQwlTs1em3pQszYwrq/+KmvCQUa8RB+oUyiXoM
 QtyBFic8CoV4OQ92IVepA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mon, 10 Mar 2014 11:39:44 +0100 (CET)
schrieb Thomas Gleixner <tglx@linutronix.de>:
> And that definitely does not affect the quick calibration. No idea,
> except bisecting.
Ok, via bisecting I found commit
73f7d1ca32638028e3271f54616773727e2f9f26 (see below) to be the one that
introduced this regression.


Cheers,
Julian Wollrath

>From 73f7d1ca32638028e3271f54616773727e2f9f26 Mon Sep 17 00:00:00 2001
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Date: Wed, 15 Jan 2014 15:25:48 +0800
Subject: [PATCH] ACPI / init: Run acpi_early_init() before timekeeping_init()

This is a variant patch from Rafael J. Wysocki's
ACPI / init: Run acpi_early_init() before efi_enter_virtual_mode()

According to Matt Fleming, if acpi_early_init() was executed before
efi_enter_virtual_mode(), the EFI initialization could benefit from
it, so Rafael's patch makes that happen.

And, we want accessing ACPI TAD device to set system clock, so move
acpi_early_init() before timekeeping_init(). This final position is
also before efi_enter_virtual_mode().

Tested-by: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 init/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/main.c b/init/main.c
index febc511e078a..b6d93c840154 100644
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
1.9.0

