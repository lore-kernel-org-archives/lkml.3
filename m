Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110AbaFEAip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:38:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39886 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbaFDXV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:21:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        wxg4net <wxg4net@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.14 057/228] PNP / ACPI: Do not return errors if _DIS or _SRS are not present
Date: Wed,  4 Jun 2014 16:21:26 -0700
Message-Id: <20140604232349.898651512@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit a8d22396302b7e4e5f0a594c1c1594388c29edaf upstream.

The ACPI PNP subsystem returns errors from pnpacpi_set_resources()
and pnpacpi_disable_resources() if the _SRS or _DIS methods are not
present, respectively, but it should not do that, because those
methods are optional.  For this reason, modify pnpacpi_set_resources()
and pnpacpi_disable_resources(), respectively, to ignore missing _SRS
or _DIS.

This problem has been uncovered by commit 202317a573b2 (ACPI / scan:
Add acpi_device objects for all device nodes in the namespace) and
manifested itself by causing serial port suspend to fail on some
systems.

Fixes: 202317a573b2 (ACPI / scan: Add acpi_device objects for all device nodes in the namespace)
References: https://bugzilla.kernel.org/show_bug.cgi?id=74371
Reported-by: wxg4net <wxg4net@gmail.com>
Reported-and-tested-by: <nonproffessional@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pnp/pnpacpi/core.c |   44 ++++++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 18 deletions(-)

--- a/drivers/pnp/pnpacpi/core.c
+++ b/drivers/pnp/pnpacpi/core.c
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


