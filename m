Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965993AbaFQVr2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:47:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53880 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965975AbaFQVrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:47:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Igor Mammedov <imammedo@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 099/212] ACPI / processor: do not mark present at boot but not onlined CPU as onlined
Date: Tue, 17 Jun 2014 14:43:13 -0700
Message-Id: <1403041506-13646-100-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Mammedov <imammedo@redhat.com>

commit 0b9d46dd7debf8e6dc8614106f1c1909fa8de64d upstream.

acpi_processor_add() assumes that present at boot CPUs
are always onlined, it is not so if a CPU failed to become
onlined. As result acpi_processor_add() will mark such CPU
device as onlined in sysfs and following attempts to
online/offline it using /sys/device/system/cpu/cpuX/online
attribute will fail.

Do not poke into device internals in acpi_processor_add()
and touch "struct device { .offline }" attribute, since
for CPUs onlined at boot it's set by:
  topology_init() -> arch_register_cpu() -> register_cpu()
before ACPI device tree is parsed, and for hotplugged
CPUs it's set when userspace onlines CPU via sysfs.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
Acked-by: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/acpi/acpi_processor.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
index 3c1d6b0..8df101e 100644
--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -400,7 +400,6 @@ static int acpi_processor_add(struct acpi_device *device,
 		goto err;
 
 	pr->dev = dev;
-	dev->offline = pr->flags.need_hotplug_init;
 
 	/* Trigger the processor driver's .probe() if present. */
 	if (device_attach(dev) >= 0)
-- 
1.9.1

