Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbaFDX5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:57:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40473 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbaFDXXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:23:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Igor Mammedov <imammedo@redhat.com>, Toshi Kani <toshi.kani@hp.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.14 201/228] ACPI / processor: do not mark present at boot but not onlined CPU as onlined
Date: Wed,  4 Jun 2014 16:23:50 -0700
Message-Id: <20140604232354.493924925@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/acpi_processor.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -405,7 +405,6 @@ static int acpi_processor_add(struct acp
 		goto err;
 
 	pr->dev = dev;
-	dev->offline = pr->flags.need_hotplug_init;
 
 	/* Trigger the processor driver's .probe() if present. */
 	if (device_attach(dev) >= 0)


