Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab3IKFWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:22:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32814 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab3IKE52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:28 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=8PMWLVbLAOkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=FbhFI2Z0vtcA:10 a=cH6R9-kdAAAA:8 a=omOdbC7AAAAA:8 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=bt0zGP92IBIA:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042909.903407926@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Toshi Kani <toshi.kani@hp.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [106/251] ACPI / memhotplug: Fix a stale pointer in error path
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0106-ACPI-memhotplug-Fix-a-stale-pointer-in-error-path.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Toshi Kani <toshi.kani@hp.com>

[ Upstream commit d19f503e22316a84c39bc19445e0e4fdd49b3532 ]

device->driver_data needs to be cleared when releasing its data,
mem_device, in an error path of acpi_memory_device_add().

The function evaluates the _CRS of memory device objects, and fails
when it gets an unexpected resource or cannot allocate memory.  A
kernel crash or data corruption may occur when the kernel accesses
the stale pointer.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: 2.6.32+ <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/acpi/acpi_memhotplug.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index 24c807f..f16ffd4 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -442,6 +442,7 @@ static int acpi_memory_device_add(struct acpi_device *device)
 	/* Get the range from the _CRS */
 	result = acpi_memory_get_device_resources(mem_device);
 	if (result) {
+		device->driver_data = NULL;
 		kfree(mem_device);
 		return result;
 	}
-- 
1.7.10.4


