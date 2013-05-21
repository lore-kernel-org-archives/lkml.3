Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451Ab3EUVeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 17:34:08 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:10277 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab3EUVeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 17:34:06 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, tangchen@cn.fujitsu.com,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH] mm: Change normal message to use pr_debug
Date: Tue, 21 May 2013 15:33:54 -0600
Message-Id: <1369172034-17267-1-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During early boot-up, iomem_resource is set up from the boot
descriptor table, such as EFI Memory Table and e820.  Later,
acpi_memory_device_add() calls add_memory() for each ACPI
memory device object as it enumerates ACPI namespace.  This
add_memory() call is expected to fail in register_memory_resource()
at boot since iomem_resource has been set up from EFI/e820.
As a result, add_memory() returns -EEXIST, which
acpi_memory_device_add() handles as the normal case.

This scheme works fine, but the following error message is
logged for every ACPI memory device object during boot-up.

  "System RAM resource %pR cannot be added\n"

This patch changes register_memory_resource() to use pr_debug()
for the message as it shows up under the normal case.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 5ea1287..90ebc91 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -75,7 +75,7 @@ static struct resource *register_memory_resource(u64 start, u64 size)
 	res->end = start + size - 1;
 	res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
 	if (request_resource(&iomem_resource, res) < 0) {
-		printk("System RAM resource %pR cannot be added\n", res);
+		pr_debug("System RAM resource %pR cannot be added\n", res);
 		kfree(res);
 		res = NULL;
 	}
