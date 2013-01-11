Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab3AKWqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 17:46:33 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:22813 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955Ab3AKWlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 17:41:13 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <lenb@kernel.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v8 07/22] ACPI: Separate acpi_bus_trim to support two steps.
Date: Fri, 11 Jan 2013 14:40:34 -0800
Message-Id: <1357944049-29620-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357944049-29620-1-git-send-email-yinghai@kernel.org>
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current all acpi_bus_trim callers have rmdevice to 1.
that means it will remove all acpi devices.

When 0, is passed, it will keep the parent.

For root bus hotremove support, we need to have pci device to be
removed before acpi devices.

So try to keep all acpi devices, and only stop drivers with them.

This change should be safe because all current callers all have 1 passed.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
---
 drivers/acpi/scan.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index e380345..db7664e 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1669,10 +1669,7 @@ int acpi_bus_trim(struct acpi_device *start, int rmdevice)
 			child = parent;
 			parent = parent->parent;
 
-			if (level == 0)
-				err = acpi_bus_remove(child, rmdevice);
-			else
-				err = acpi_bus_remove(child, 1);
+			err = acpi_bus_remove(child, rmdevice);
 
 			continue;
 		}
-- 
1.7.10.4

