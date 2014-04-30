Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759571AbaD3Uea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 16:34:30 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59370 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759483AbaD3Ue2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 16:34:28 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lan Tianyu <tianyu.lan@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        wxg4net <wxg4net@gmail.com>, nonproffessional@gmail.com
Subject: [PATCH] PNP / ACPI: Do not return errors if _DIS or _SRS are not present
Date: Wed, 30 Apr 2014 22:50:58 +0200
Message-ID: <1492044.L41XNkFY4m@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The ACPI PNP subsystem returns errors from pnpacpi_set_resources()
and pnpacpi_disable_resources() if the _SRS or _DIS methods are not
present, respectively, but it should not do that, because those
methods are optional.  For this reason, modify pnpacpi_set_resources()
and pnpacpi_disable_resources(), respectively, to ignore missing _SRS
or _DIS.

This problem has been uncovered by commit 202317a573b2 (ACPI / scan: Add
acpi_device objects for all device nodes in the namespace) and manifested
itself by causing serial port suspend to fail on some systems.

Fixes: 202317a573b2 (ACPI / scan: Add acpi_device objects for all device nodes in the namespace)
References: https://bugzilla.kernel.org/show_bug.cgi?id=74371
Reported-by: wxg4net <wxg4net@gmail.com>
Reported-and-tested-by: <nonproffessional@gmail.com>
Cc: 3.14+ <stable@vger.kernel.org> # 3.14+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pnp/pnpacpi/core.c |   44 ++++++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 18 deletions(-)

Index: linux-pm/drivers/pnp/pnpacpi/core.c
===================================================================
--- linux-pm.orig/drivers/pnp/pnpacpi/core.c
+++ linux-pm/drivers/pnp/pnpacpi/core.c
@@ -83,8 +83,7 @@ static int pnpacpi_set_resources(struct
 {
 	struct acpi_device *acpi_dev;
 	acpi_handle handle;
-	struct acpi_buffer buffer;
-	int ret;
+	int ret = 0;
 
 	pnp_dbg(&dev->dev, "set resources\n");
 
@@ -97,19 +96,26 @@ static int pnpacpi_set_resources(struct
 	if (WARN_ON_ONCE(acpi_dev != dev->data))
 		dev->data = acpi_dev;
 
-	ret = pnpacpi_build_resource_template(dev, &buffer);
-	if (ret)
-		return ret;
-	ret = pnpacpi_encode_resources(dev, &buffer);
-	if (ret) {
+	if (acpi_has_method(handle, METHOD_NAME__SRS)) {
+		struct acpi_buffer buffer;
+
+		ret = pnpacpi_build_resource_template(dev, &buffer);
+		if (ret)
+			return ret;
+
+		ret = pnpacpi_encode_resources(dev, &buffer);
+		if (!ret) {
+			acpi_status status;
+
+			status = acpi_set_current_resources(handle, &buffer);
+			if (ACPI_FAILURE(status))
+				ret = -EIO;
+		}
 		kfree(buffer.pointer);
-		return ret;
 	}
-	if (ACPI_FAILURE(acpi_set_current_resources(handle, &buffer)))
-		ret = -EINVAL;
-	else if (acpi_bus_power_manageable(handle))
+	if (!ret && acpi_bus_power_manageable(handle))
 		ret = acpi_bus_set_power(handle, ACPI_STATE_D0);
-	kfree(buffer.pointer);
+
 	return ret;
 }
 
@@ -117,7 +123,7 @@ static int pnpacpi_disable_resources(str
 {
 	struct acpi_device *acpi_dev;
 	acpi_handle handle;
-	int ret;
+	acpi_status status;
 
 	dev_dbg(&dev->dev, "disable resources\n");
 
@@ -128,13 +134,15 @@ static int pnpacpi_disable_resources(str
 	}
 
 	/* acpi_unregister_gsi(pnp_irq(dev, 0)); */
-	ret = 0;
 	if (acpi_bus_power_manageable(handle))
 		acpi_bus_set_power(handle, ACPI_STATE_D3_COLD);
-		/* continue even if acpi_bus_set_power() fails */
-	if (ACPI_FAILURE(acpi_evaluate_object(handle, "_DIS", NULL, NULL)))
-		ret = -ENODEV;
-	return ret;
+
+	/* continue even if acpi_bus_set_power() fails */
+	status = acpi_evaluate_object(handle, "_DIS", NULL, NULL);
+	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND)
+		return -ENODEV;
+
+	return 0;
 }
 
 #ifdef CONFIG_ACPI_SLEEP

