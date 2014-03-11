Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbaCKOle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 10:41:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:64019 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbaCKOlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 10:41:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,631,1389772800"; 
   d="scan'208";a="496210042"
From: Zhang Rui <rui.zhang@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: rafael.j.wysocki@intel.com, jwollrath@web.de, markus@trippelsdorf.de,
        pebolle@tiscali.nl, Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH] PNPACPI: proper handling ACPI IO/Memory resources
Date: Tue, 11 Mar 2014 22:40:27 +0800
Message-Id: <1394548827-15172-1-git-send-email-rui.zhang@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before commit b355cee88e3b1a193f0e9a81db810f6f83ad728b,
if acpi_dev_resource_memory()/acpi_dev_resource_io() returns false,
it means the the resource is not a memeory/IO resource.

But after commit b355cee88e3b1a193f0e9a81db810f6f83ad728b,
if the memory/IO resource is invalid (the length of the resource is zero),
acpi_dev_resource_memory()/acpi_dev_resource_io() returns false as well.

This breaks pnpacpi_allocated_resource(), because the current code would
recognize the invalid memory/io resource as unknown resource type.
Thus users will get warning messages on machines with zero length
ACPI memeory/IO resources.

This patch fixes the problem by invoking acpi_dev_resource_memory()/
acpi_dev_resource_io() for ACPI memory/IO resources only.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/pnp/pnpacpi/rsparser.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/pnp/pnpacpi/rsparser.c b/drivers/pnp/pnpacpi/rsparser.c
index 167f3d0..66977eb 100644
--- a/drivers/pnp/pnpacpi/rsparser.c
+++ b/drivers/pnp/pnpacpi/rsparser.c
@@ -183,9 +183,7 @@ static acpi_status pnpacpi_allocated_resource(struct acpi_resource *res,
 	struct resource r = {0};
 	int i, flags;
 
-	if (acpi_dev_resource_memory(res, &r)
-	    || acpi_dev_resource_io(res, &r)
-	    || acpi_dev_resource_address_space(res, &r)
+	if (acpi_dev_resource_address_space(res, &r)
 	    || acpi_dev_resource_ext_address_space(res, &r)) {
 		pnp_add_resource(dev, &r);
 		return AE_OK;
@@ -217,6 +215,17 @@ static acpi_status pnpacpi_allocated_resource(struct acpi_resource *res,
 	}
 
 	switch (res->type) {
+	case ACPI_RESOURCE_TYPE_MEMORY24:
+	case ACPI_RESOURCE_TYPE_MEMORY32:
+	case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
+		if (acpi_dev_resource_memory(res, &r))
+			pnp_add_resource(dev, &r);
+		break;
+	case ACPI_RESOURCE_TYPE_IO:
+	case ACPI_RESOURCE_TYPE_FIXED_IO:
+		if (acpi_dev_resource_io(res, &r))
+			pnp_add_resource(dev, &r);
+		break;
 	case ACPI_RESOURCE_TYPE_DMA:
 		dma = &res->data.dma;
 		if (dma->channel_count > 0 && dma->channels[0] != (u8) -1)
-- 
1.7.9.5

