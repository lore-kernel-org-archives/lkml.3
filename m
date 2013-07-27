Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab3G0NFd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 09:05:33 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:43312 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654Ab3G0NEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 09:04:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Aaron Lu <aaron.lu@intel.com>, Tejun Heo <tj@kernel.org>,
        linux-ide@vger.kernel.org
Subject: [PATCH 1/3] ACPI / PM: Only set power states of devices that are power manageable
Date: Sat, 27 Jul 2013 15:10:52 +0200
Message-ID: <1657971.1utElu0Hzo@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <10433383.dueoNg39qi@vostro.rjw.lan>
References: <10433383.dueoNg39qi@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Make acpi_device_set_power() check if the given device is power
manageable before checking if the given power state is valid for that
device.  Otherwise it will print that "Device does not support" that
power state into the kernel log, which may not make sense for some
power states (D0 and D3cold are supported by all devices by
definition).

Tested-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/device_pm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-pm/drivers/acpi/device_pm.c
===================================================================
--- linux-pm.orig/drivers/acpi/device_pm.c
+++ linux-pm/drivers/acpi/device_pm.c
@@ -159,7 +159,8 @@ int acpi_device_set_power(struct acpi_de
 	int result = 0;
 	bool cut_power = false;
 
-	if (!device || (state < ACPI_STATE_D0) || (state > ACPI_STATE_D3_COLD))
+	if (!device || !device->flags.power_manageable
+	    || (state < ACPI_STATE_D0) || (state > ACPI_STATE_D3_COLD))
 		return -EINVAL;
 
 	/* Make sure this is a valid target state */

