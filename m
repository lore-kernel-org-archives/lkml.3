Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbaI3MQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 08:16:45 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:60370 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbaI3MQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 08:16:44 -0400
From: Thibaut Robert <thibaut.robert@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Thibaut Robert <thibaut.robert@gmail.com>
Subject: [PATCH] tc: fix warning and coding style
Date: Tue, 30 Sep 2014 14:16:36 +0200
Message-Id: <1412079396-26005-1-git-send-email-thibaut.robert@gmail.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warnings:
WARNING: Prefer [subsystem eg: netdev]_err([subsystem]dev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
WARNING: Possible unnecessary 'out of memory' message
WARNING: quoted string split across lines
WARNING: Use #include <linux/io.h> instead of <asm/io.h>

Fix gcc warning:
warning: format ‘%d’ expects argument of type ‘int’, but argument 4 has type ‘resource_size_t’ [-Wformat=]

As resource_size_t can be 32 or 64 bits (depending on CONFIG_RESOURCES_64BIT), this patch uses "%lld" format along with a cast to u64 for printing resource_size_t values

Signed-off-by: Thibaut Robert <thibaut.robert@gmail.com>
---
 drivers/tc/tc.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/tc/tc.c b/drivers/tc/tc.c
index 9465623..9b1f831 100644
--- a/drivers/tc/tc.c
+++ b/drivers/tc/tc.c
@@ -12,6 +12,7 @@
 #include <linux/compiler.h>
 #include <linux/errno.h>
 #include <linux/init.h>
+#include <linux/io.h>
 #include <linux/ioport.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
@@ -21,8 +22,6 @@
 #include <linux/tc.h>
 #include <linux/types.h>
 
-#include <asm/io.h>
-
 static struct tc_bus tc_bus = {
 	.name = "TURBOchannel",
 };
@@ -82,11 +81,9 @@ static void __init tc_bus_add_devices(struct tc_bus *tbus)
 
 		/* Found a board, allocate it an entry in the list */
 		tdev = kzalloc(sizeof(*tdev), GFP_KERNEL);
-		if (!tdev) {
-			printk(KERN_ERR "tc%x: unable to allocate tc_dev\n",
-			       slot);
+		if (!tdev)
 			goto out_err;
-		}
+
 		dev_set_name(&tdev->dev, "tc%x", slot);
 		tdev->bus = tbus;
 		tdev->dev.parent = &tbus->dev;
@@ -105,7 +102,7 @@ static void __init tc_bus_add_devices(struct tc_bus *tbus)
 		tdev->vendor[8] = 0;
 		tdev->name[8] = 0;
 
-		pr_info("%s: %s %s %s\n", dev_name(&tdev->dev), tdev->vendor,
+		dev_info(&tdev->dev, "%s %s %s\n", tdev->vendor,
 			tdev->name, tdev->firmware);
 
 		devsize = readb(module + offset + TC_SLOT_SIZE);
@@ -117,10 +114,10 @@ static void __init tc_bus_add_devices(struct tc_bus *tbus)
 			tdev->resource.start = extslotaddr;
 			tdev->resource.end = extslotaddr + devsize - 1;
 		} else {
-			printk(KERN_ERR "%s: Cannot provide slot space "
-			       "(%dMiB required, up to %dMiB supported)\n",
-			       dev_name(&tdev->dev), devsize >> 20,
-			       max(slotsize, extslotsize) >> 20);
+			dev_err(&tdev->dev,
+				"Cannot provide slot space (%lluMiB required, up to %lluMiB supported)\n",
+				(u64) devsize >> 20,
+				(u64) max(slotsize, extslotsize) >> 20);
 			kfree(tdev);
 			goto out_err;
 		}
@@ -159,8 +156,8 @@ static int __init tc_init(void)
 	if (tc_bus.info.slot_size) {
 		unsigned int tc_clock = tc_get_speed(&tc_bus) / 100000;
 
-		pr_info("tc: TURBOchannel rev. %d at %d.%d MHz "
-			"(with%s parity)\n", tc_bus.info.revision,
+		pr_info("tc: TURBOchannel rev. %d at %d.%d MHz (with%s parity)\n",
+			tc_bus.info.revision,
 			tc_clock / 10, tc_clock % 10,
 			tc_bus.info.parity ? "" : "out");
 
@@ -172,7 +169,7 @@ static int __init tc_init(void)
 		tc_bus.resource[0].flags = IORESOURCE_MEM;
 		if (request_resource(&iomem_resource,
 				     &tc_bus.resource[0]) < 0) {
-			printk(KERN_ERR "tc: Cannot reserve resource\n");
+			pr_err("tc: Cannot reserve resource\n");
 			return 0;
 		}
 		if (tc_bus.ext_slot_size) {
@@ -184,8 +181,7 @@ static int __init tc_init(void)
 			tc_bus.resource[1].flags = IORESOURCE_MEM;
 			if (request_resource(&iomem_resource,
 					     &tc_bus.resource[1]) < 0) {
-				printk(KERN_ERR
-				       "tc: Cannot reserve resource\n");
+				pr_err("tc: Cannot reserve resource\n");
 				release_resource(&tc_bus.resource[0]);
 				return 0;
 			}
-- 
1.9.1

