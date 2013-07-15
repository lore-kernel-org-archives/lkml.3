Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab3GOKW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 06:22:28 -0400
Received: from service87.mimecast.com ([91.220.42.44]:33620 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021Ab3GOKWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 06:22:23 -0400
From: Sudeep.KarkadaNagesha@arm.com
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: cpufreq@vger.kernel.org, arnd@arndb.de, olof@lixom.net,
        lorenzo.pieralisi@arm.com, rob.herring@calxeda.com,
        grant.likely@linaro.org, rjw@sisk.pl, viresh.kumar@linaro.org,
        gregkh@linuxfoundation.org, gregory.clement@free-electrons.com,
        kernel@pengutronix.de, shawn.guo@linaro.org, linux@arm.linux.org.uk,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [RFC PATCH 01/11] driver/core: cpu: initialize of_node in cpu's device struture
Date: Mon, 15 Jul 2013 11:22:02 +0100
Message-Id: <1373883732-26303-2-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373883732-26303-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1373883732-26303-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 15 Jul 2013 10:22:18.0331 (UTC) FILETIME=[2F1A6AB0:01CE8145]
X-MC-Unique: 113071511222104101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r6FANaov007634

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

CPUs are also registered as devices but the of_node in these cpu
devices are not initialized. Currently different drivers requiring
to access cpu device node are parsing the nodes themselves and
initialising the of_node in cpu device.

The of_node in all the cpu devices properly needs to be initialized
properly and at one place. The best place to update this is CPU
subsystem driver when registering the cpu devices.

This patch introduces a new function arch_of_get_cpu_node and uses it
to assign of_node. The definition of this function can be overridden
by architecture specific implementation.

Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
---
 drivers/base/cpu.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index a16d20e..4b3047a 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -28,6 +28,24 @@ static int cpu_subsys_match(struct device *dev, struct device_driver *drv)
 	return 0;
 }
 
+/**
+ * arch_of_get_cpu_node - Get device node associated with the given logical CPU
+ * @cpu: CPU number(logical index) for which device node is required
+ *
+ * The only purpose of this function is to retrieve the device node for the
+ * given logical CPU index. It should be used to intialise the of_node in
+ * cpu device. Once of_node in cpu device is populated, all the further
+ * references can use that instead.
+ *
+ * CPU logical to physical index mapping is architecure specific and is built
+ * before booting secondary cores. Hence this function is marked __weak and
+ * can be overridden by architecture specific implementation.
+ */
+struct device_node * __weak arch_of_get_cpu_node(int cpu)
+{
+	return NULL;
+}
+
 #ifdef CONFIG_HOTPLUG_CPU
 static void change_cpu_under_node(struct cpu *cpu,
 			unsigned int from_nid, unsigned int to_nid)
@@ -289,6 +307,7 @@ int __cpuinit register_cpu(struct cpu *cpu, int num)
 	cpu->dev.release = cpu_device_release;
 	cpu->dev.offline_disabled = !cpu->hotpluggable;
 	cpu->dev.offline = !cpu_online(num);
+	cpu->dev.of_node = arch_of_get_cpu_node(num);
 #ifdef CONFIG_ARCH_HAS_CPU_AUTOPROBE
 	cpu->dev.bus->uevent = arch_cpu_uevent;
 #endif
-- 
1.8.1.2


