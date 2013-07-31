Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab3GaN0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:26:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47153 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759689Ab3GaN0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:26:10 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Toshi Kani" <toshi.kani@hp.com>,
        "Yasuaki Ishimatsu" <isimatu.yasuaki@jp.fujitsu.com>
Date: Wed, 31 Jul 2013 15:23:09 +0200
Message-ID: <lsq.1375276989.380399962@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [38/84] ACPI / memhotplug: Fix a stale pointer in error path
In-Reply-To: <lsq.1375276989.251749228@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.181
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.50-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/acpi/acpi_memhotplug.c | 1 +
 1 file changed, 1 insertion(+)

--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -421,6 +421,7 @@ static int acpi_memory_device_add(struct
 	/* Get the range from the _CRS */
 	result = acpi_memory_get_device_resources(mem_device);
 	if (result) {
+		device->driver_data = NULL;
 		kfree(mem_device);
 		return result;
 	}

