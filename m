Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbaEOGo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 02:44:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:39021 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbaEOGo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 02:44:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1057,1389772800"; 
   d="scan'208";a="532238214"
From: Zhang Rui <rui.zhang@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com,
        Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH V6 01/11] ACPI: introduce .match() callback for ACPI scan handler
Date: Thu, 15 May 2014 14:44:06 +0800
Message-Id: <1400136256-2218-2-git-send-email-rui.zhang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400136256-2218-1-git-send-email-rui.zhang@intel.com>
References: <1400136256-2218-1-git-send-email-rui.zhang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, ACPI scan handler uses strcmp() to match device ids
and scan handler ids.

When converting PNPACPI enumeration into a scan handler, which I will do
later in this patch set, the current code becomes not flexible enough
because ACPI pnp scan handler requires wildcase and case insensitive support.

Thus a per scan handler .match() callback is introduced in this patch,
so that specified scan handler can have more flexible matching mechanism
by introduce its own .match() callback.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/acpi/scan.c     | 17 +++++++++++------
 include/acpi/acpi_bus.h |  1 +
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 7efe546..e46e51c 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1974,14 +1974,19 @@ static bool acpi_scan_handler_matching(struct acpi_scan_handler *handler,
 	const struct acpi_device_id *devid;
 
 	for (devid = handler->ids; devid->id[0]; devid++)
-		if (!strcmp((char *)devid->id, idstr)) {
-			if (matchid)
-				*matchid = devid;
-
-			return true;
-		}
+		if (handler->match) {
+			if (handler->match(idstr, (char *)devid->id))
+				goto success;
+		} else
+			if (!strcmp((char *)devid->id, idstr))
+				goto success;
 
 	return false;
+
+success:
+	if (matchid)
+		*matchid = devid;
+	return true;
 }
 
 static struct acpi_scan_handler *acpi_scan_match_handler(char *idstr,
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 84a2e29..ba679af 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -131,6 +131,7 @@ static inline struct acpi_hotplug_profile *to_acpi_hotplug_profile(
 struct acpi_scan_handler {
 	const struct acpi_device_id *ids;
 	struct list_head list_node;
+	int (*match)(char *devid, char *handler_id);
 	int (*attach)(struct acpi_device *dev, const struct acpi_device_id *id);
 	void (*detach)(struct acpi_device *dev);
 	void (*bind)(struct device *phys_dev);
-- 
1.8.3.2

