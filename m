Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab3LOMKS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 07:10:18 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:50918 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984Ab3LOMKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 07:10:16 -0500
Date: Sun, 15 Dec 2013 04:10:11 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] PNPACPI: check return value of pnp_add_device()
Message-ID: <20131215121008.GA436@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pnp_add_device() may fail so we need to handle errors and avoid leaking
memory. Also, do not use ACPI-specific return codes (AE_OK) but rather
standard one (0).

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/pnp/pnpacpi/core.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
index 14655a0..4bd4c54 100644
--- a/drivers/pnp/pnpacpi/core.c
+++ b/drivers/pnp/pnpacpi/core.c
@@ -242,6 +242,7 @@ static int __init pnpacpi_add_device(struct acpi_device *device)
 	struct pnp_dev *dev;
 	char *pnpid;
 	struct acpi_hardware_id *id;
+	int error;
 
 	/* Skip devices that are already bound */
 	if (device->physical_node_count)
@@ -300,10 +301,16 @@ static int __init pnpacpi_add_device(struct acpi_device *device)
 	/* clear out the damaged flags */
 	if (!dev->active)
 		pnp_init_resources(dev);
-	pnp_add_device(dev);
+
+	error = pnp_add_device(dev);
+	if (error) {
+		put_device(&dev->dev);
+		return error;
+	}
+
 	num++;
 
-	return AE_OK;
+	return 0;
 }
 
 static acpi_status __init pnpacpi_add_device_handler(acpi_handle handle,
-- 
1.8.3.1


-- 
Dmitry
