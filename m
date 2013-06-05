Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab3FEUP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 16:15:59 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:58446 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757286Ab3FEUP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 16:15:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Lan Tianyu <tianyu.lan@intel.com>,
        Jerome Cantenot <jerome.cantenot@gmail.com>,
        Peter Wu <lekensteyn@gmail.com>
Subject: [PATCH] ACPI / PM: Do not execute _PS0 for devices without _PSC during initialization
Date: Wed, 05 Jun 2013 22:24:58 +0200
Message-ID: <1448886.dqrNhOa96I@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc4+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Commit b378549 (ACPI / PM: Do not power manage devices in unknown
initial states) added code to force devices without _PSC, but having
_PS0 defined in the ACPI namespace, into ACPI power state D0 by
executing _PS0 for them.  That turned out to break Toshiba P870-303,
however, so revert that code.

References: https://bugzilla.kernel.org/show_bug.cgi?id=58201
Reported-and-tested-by: Jerome Cantenot <jerome.cantenot@gmail.com>
Tracked-down-by: Lan Tianyu <tianyu.lan@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/device_pm.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: linux-pm/drivers/acpi/device_pm.c
===================================================================
--- linux-pm.orig/drivers/acpi/device_pm.c
+++ linux-pm/drivers/acpi/device_pm.c
@@ -278,11 +278,13 @@ int acpi_bus_init_power(struct acpi_devi
 		if (result)
 			return result;
 	} else if (state == ACPI_STATE_UNKNOWN) {
-		/* No power resources and missing _PSC? Try to force D0. */
+		/*
+		 * No power resources and missing _PSC?  Cross fingers and make
+		 * it D0 in hope that this is what the BIOS put the device into.
+		 * [We tried to force D0 here by executing _PS0, but that broke
+		 * Toshiba P870-303 in a nasty way.]
+		 */
 		state = ACPI_STATE_D0;
-		result = acpi_dev_pm_explicit_set(device, state);
-		if (result)
-			return result;
 	}
 	device->power.state = state;
 	return 0;

