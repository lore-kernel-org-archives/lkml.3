Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab3HBKS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:18:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37654 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab3HBKSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:18:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Toshi Kani <toshi.kani@hp.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 23/39] ACPI / memhotplug: Fix a stale pointer in error path
Date: Fri,  2 Aug 2013 18:18:33 +0800
Message-Id: <20130802101500.095800733@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802101456.800497005@linuxfoundation.org>
References: <20130802101456.800497005@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/acpi_memhotplug.c |    1 +
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


