Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161043AbaDJRPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 13:15:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758657AbaDJRPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 13:15:01 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        imammedo@redhat.com, bp@suse.de, paul.gortmaker@windriver.com,
        JBeulich@suse.com, prarit@redhat.com, drjones@redhat.com,
        toshi.kani@hp.com, riel@redhat.com, gong.chen@linux.intel.com,
        andi@firstfloor.org, lenb@kernel.org, rjw@rjwysocki.net,
        linux-acpi@vger.kernel.org
Subject: [PATCH v3 5/5] acpi_processor: do not mark present at boot but not onlined CPU as onlined
Date: Thu, 10 Apr 2014 19:14:21 +0200
Message-Id: <1397150061-29735-6-git-send-email-imammedo@redhat.com>
In-Reply-To: <1397150061-29735-1-git-send-email-imammedo@redhat.com>
References: <1397150061-29735-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 drivers/acpi/acpi_processor.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
index c29c2c3..d56e4b4 100644
--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -403,9 +403,6 @@ static int acpi_processor_add(struct acpi_device *device,
 	if (result)
 		goto err;
 
-	pr->dev = dev;
-	dev->offline = pr->flags.need_hotplug_init;
-
 	/* Trigger the processor driver's .probe() if present. */
 	if (device_attach(dev) >= 0)
 		return 1;
-- 
1.7.1

