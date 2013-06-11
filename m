Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab3FKUD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:03:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41914 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197Ab3FKUDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:03:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 32/79] ACPI / PM: Do not execute _PS0 for devices without _PSC during initialization
Date: Tue, 11 Jun 2013 13:02:58 -0700
Message-Id: <20130611195316.681939210@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195312.352656079@linuxfoundation.org>
References: <20130611195312.352656079@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit 7cd8407d53ef5fb0280fcbe34f42311472f90feb upstream.

Commit b378549 (ACPI / PM: Do not power manage devices in unknown
initial states) added code to force devices without _PSC, but having
_PS0 defined in the ACPI namespace, into ACPI power state D0 by
executing _PS0 for them.  That turned out to break Toshiba P870-303,
however, so revert that code.

References: https://bugzilla.kernel.org/show_bug.cgi?id=58201
Reported-and-tested-by: Jerome Cantenot <jerome.cantenot@gmail.com>
Tracked-down-by: Lan Tianyu <tianyu.lan@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/device_pm.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/acpi/device_pm.c
+++ b/drivers/acpi/device_pm.c
@@ -269,11 +269,13 @@ int acpi_bus_init_power(struct acpi_devi
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


