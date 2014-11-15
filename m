Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbaKOBJ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 20:09:56 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:63927 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755228AbaKOBJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 20:09:54 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Robert Moore <robert.moore@intel.com>
Subject: [PATCH] ACPI / sleep: Drain outstanding events after disabling multiple GPEs
Date: Sat, 15 Nov 2014 02:30:51 +0100
Message-ID: <2087711.53EgqR6vL6@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

After multiple GPEs have been disabled at the low level in one go,
like when acpi_disable_all_gpes() is called, we should always drain
all of the outstanding events from them, or the ACPICA's GPE handling
code may re-enable one of them as a result of a race condition.

For this reason, call acpi_os_wait_events_complete() after
acpi_enable_all_wakeup_gpes() and acpi_disable_all_gpes() in
acpi_freeze_prepare() and acpi_power_off_prepare(), respectively.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/sleep.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-pm/drivers/acpi/sleep.c
===================================================================
--- linux-pm.orig/drivers/acpi/sleep.c
+++ linux-pm/drivers/acpi/sleep.c
@@ -630,6 +630,7 @@ static int acpi_freeze_begin(void)
 static int acpi_freeze_prepare(void)
 {
 	acpi_enable_all_wakeup_gpes();
+	acpi_os_wait_events_complete();
 	enable_irq_wake(acpi_gbl_FADT.sci_interrupt);
 	return 0;
 }
@@ -825,6 +826,7 @@ static void acpi_power_off_prepare(void)
 	/* Prepare to power off the system */
 	acpi_sleep_prepare(ACPI_STATE_S5);
 	acpi_disable_all_gpes();
+	acpi_os_wait_events_complete();
 }
 
 static void acpi_power_off(void)

