Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952AbaDALgx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:36:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42635 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbaDALS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:18:27 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 110/144] PNP / ACPI: proper handling of ACPI IO/Memory resource parsing failures
Date: Tue,  1 Apr 2014 12:15:14 +0100
Message-Id: <1396350948-29910-111-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

commit 89935315f192abf7068d0044cefc84f162c3c81f upstream.

Before commit b355cee88e3b (ACPI / resources: ignore invalid ACPI
device resources), if acpi_dev_resource_memory()/acpi_dev_resource_io()
returns false, it means the the resource is not a memeory/IO resource.

But after commit b355cee88e3b, those functions return false if the
given memory/IO resource entry is invalid (the length of the resource
is zero).

This breaks pnpacpi_allocated_resource(), because it now recognizes
the invalid memory/io resources as resources of unknown type.  Thus
users see confusing warning messages on machines with zero length
ACPI memory/IO resources.

Fix the problem by rearranging pnpacpi_allocated_resource() so that
it calls acpi_dev_resource_memory() for memory type and IO type
resources only, respectively.

Fixes: b355cee88e3b (ACPI / resources: ignore invalid ACPI device resources)
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Reported-and-tested-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Reported-and-tested-by: Julian Wollrath <jwollrath@web.de>
Reported-and-tested-by: Paul Bolle <pebolle@tiscali.nl>
[rjw: Changelog]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/pnp/pnpacpi/rsparser.c | 15 ++++++++++++---
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
1.9.1

