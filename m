Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688Ab3G3Jcq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:32:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53014 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332Ab3G3Jch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:32:37 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Toshi Kani <toshi.kani@hp.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 021/106] ACPI / memhotplug: Fix a stale pointer in error path
Date: Tue, 30 Jul 2013 10:30:40 +0100
Message-Id: <1375176725-5825-22-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toshi Kani <toshi.kani@hp.com>

commit d19f503e22316a84c39bc19445e0e4fdd49b3532 upstream.

device->driver_data needs to be cleared when releasing its data,
mem_device, in an error path of acpi_memory_device_add().

The function evaluates the _CRS of memory device objects, and fails
when it gets an unexpected resource or cannot allocate memory.  A
kernel crash or data corruption may occur when the kernel accesses
the stale pointer.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/acpi/acpi_memhotplug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index d985713..f81597f 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -421,6 +421,7 @@ static int acpi_memory_device_add(struct acpi_device *device)
 	/* Get the range from the _CRS */
 	result = acpi_memory_get_device_resources(mem_device);
 	if (result) {
+		device->driver_data = NULL;
 		kfree(mem_device);
 		return result;
 	}
-- 
1.8.3.2

