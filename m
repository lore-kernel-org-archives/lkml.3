Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbaBKXuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 18:50:46 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:59025 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750978AbaBKXup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 18:50:45 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH] ACPI / container: Fix error code path in container_device_attach()
Date: Wed, 12 Feb 2014 01:05:24 +0100
Message-ID: <1575051.TZgsd5D5jn@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

To avoid leaking memory on errors from device_register(), do a
put_device() on the device object in question in the error code
path of container_device_attach().

Fixes: caa73ea158de (ACPI / hotplug / driver core: Handle containers in a special way)
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

3.14 material.

Thanks!

---
 drivers/acpi/container.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-pm/drivers/acpi/container.c
===================================================================
--- linux-pm.orig/drivers/acpi/container.c
+++ linux-pm/drivers/acpi/container.c
@@ -82,9 +82,10 @@ static int container_device_attach(struc
 	ACPI_COMPANION_SET(dev, adev);
 	dev->release = acpi_container_release;
 	ret = device_register(dev);
-	if (ret)
+	if (ret) {
+		put_device(dev);
 		return ret;
-
+	}
 	adev->driver_data = dev;
 	return 1;
 }

